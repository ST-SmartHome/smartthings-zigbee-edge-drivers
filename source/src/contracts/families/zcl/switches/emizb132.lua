-- EMIZB-132 only. ZHC cff1de47 develco.ts:503-556,766-824.
local zcl = require "protocol.zcl"
local emit = require "capabilities.events.all"
local types = require "st.zigbee.data_types"
local cluster_base = require "st.zigbee.cluster_base"
local sdk_utils = require "st.utils"
local device_helpers = require "contracts.helpers.family"

local registrations, register = device_helpers.definition_registry()
local persistent, transient = {persist = true}, {persist = false}
local prefix = "emizb132:"
local modes = {[0x0200] = "norwegian_han", [0x0201] = "norwegian_han_extra_load",
  [0x0202] = "aidon_meter", [0x0203] = "kaifa_and_kamstrup"}
local mode_values = {norwegian_han = 0x0200, norwegian_han_extra_load = 0x0201,
  aidon_meter = 0x0202, kaifa_and_kamstrup = 0x0203}
local scalers = {[0x0600] = "voltage_multiplier", [0x0601] = "voltage_divisor",
  [0x0602] = "current_multiplier", [0x0603] = "current_divisor"}

local function basic_endpoint(device)
  local first
  for _, endpoint in pairs(device.zigbee_endpoints) do
    if device:supports_server_cluster(0, endpoint.id) and (not first or endpoint.id < first) then first = endpoint.id end
  end
  return first
end

-- This is RX duplicate suppression, not a claim about native TX TSN assignment.
-- Primary utils.ts:104-163: per device+endpoint, 10 seconds, last five IDs.
local function duplicate(device, sequence)
  if sequence == nil then return false end
  local now = require("cosock.socket").gettime()
  local entries = device:get_field(prefix .. "transactions") or {}
  for _, entry in ipairs(entries) do
    if entry.sequence == sequence and entry.expiry > now then return true end
  end
  for index = #entries, 1, -1 do if entries[index].expiry <= now then table.remove(entries, index) end end
  if #entries > 4 then table.remove(entries, 1) end
  entries[#entries + 1] = {sequence = sequence, expiry = now + 10}
  device:set_field(prefix .. "transactions", entries, transient)
  return false
end

local function capture_frame(device, rx)
  local header = rx.body and rx.body.zcl_header
  if not header or header.frame_ctrl:is_cluster_specific_set() then return end
  local command = header.cmd.value
  if command ~= 1 and command ~= 10 then return end
  if rx.address_header.src_endpoint.value ~= 2 then return end
  local cluster = rx.address_header.cluster.value
  if cluster ~= 0x0702 and cluster ~= 0x0B04 then return end
  local values = {}
  for _, record in ipairs(rx.body.zcl_body.attr_records or {}) do
    if record.data and (not record.status or record.status.value == 0) then
      local typed = record.data
      local value = typed.value
      -- SDK augmentation replaces a known attribute's metatable with its
      -- declared type. FloatABC's original raw_bits survive that replacement.
      local kind = record.data_type.value
      if kind == 0x39 or kind == 0x3A then
        local raw = string.reverse(sdk_utils.bit_list_to_byte_str(typed.raw_bits))
        value = string.unpack(kind == 0x39 and "<f" or "<d", raw)
      end
      local attribute, accepted = record.attr_id.value, true
      -- Herdsman11.1.0 processAttributePostRead runs before message.data:
      -- failed restrictions do not replace a preceding valid duplicate.
      if cluster == 0x0B04 then
        if attribute == 0x0304 or attribute == 0x0305 then
          accepted = type(value) == "number" and not (value < -8388607 or value > 8388607)
        elseif scalers[attribute] then
          accepted = type(value) == "number" and not (value < 1)
        end
        local bank = math.floor(attribute / 0x100)
        local rms = (bank == 5 or bank == 9 or bank == 10) and (attribute % 0x100 == 5 or attribute % 0x100 == 8)
        if (scalers[attribute] or rms) and value == 0xFFFF then value = 0/0 end
      end
      if accepted then values[attribute] = value end
    end
  end
  local state = {values = values, used = {}, duplicate = duplicate(device, header.seqno.value)}
  rx.__emizb132 = state
  if cluster == 0x0702 then
    state.reject_energy = values[0] == 0 or values[0] == 0xFFFFFFFFFFFF or values[0] ~= values[0]
  else
    -- Like the endpoint cache read by fz.electrical_measurement, scalar updates
    -- precede conversion, including when they follow a reading on the wire.
    for attribute, name in pairs(scalers) do
      local value = values[attribute]
      if type(value) == "number" then
        -- Preserve an invalid scaler marker without putting NaN in JSON.
        device:set_field(prefix .. name, value == value and value or false, persistent)
        if attribute == 0x0603 then
          -- A live NaN becomes null at the primary endpoint JSON checkpoint.
          -- Keep only its live provenance transient; do not recover a default.
          device:set_field(prefix .. "current_divisor_invalid_live", value ~= value and true or nil, transient)
        end
      end
    end
  end
end

local function frame_value(context, mapping)
  local state = context.zb_rx.__emizb132
  local attribute = mapping.attribute_id
  local total = mapping.cluster_id == 0x0B04 and (attribute == 0x0304 or attribute == 0x0305)
  if not state or state.duplicate and not total or state.used[attribute] then return nil end
  state.used[attribute] = true
  local value = state.values[attribute]
  if type(value) ~= "number" or value ~= value or math.abs(value) == math.huge then return nil end
  return value, state
end

local function energy_value(_, _, context, mapping)
  local value, state = frame_value(context, mapping)
  if value ~= nil and not state.reject_energy then return value / 1000 end
end

local function electrical_value(_, device, context, mapping)
  local value = frame_value(context, mapping)
  if value == nil then return end
  if mapping.attribute_id == 0x0304 or mapping.attribute_id == 0x0305 then return value end
  local current = mapping.attribute_id % 0x100 == 8
  local kind = current and "current" or "voltage"
  local multiplier = device:get_field(prefix .. kind .. "_multiplier")
  local divisor = device:get_field(prefix .. kind .. "_divisor")
  if multiplier == nil then multiplier = 1 end
  if divisor == nil then divisor = 10 end
  local factor = multiplier and divisor and multiplier ~= 0 and divisor ~= 0 and multiplier / divisor or 1
  if current then
    if divisor == false then
      return not device:get_field(prefix .. "current_divisor_invalid_live") and 0 or nil
    end
    local mode_divisor = device:get_field(prefix .. "interface_mode") == "kaifa_and_kamstrup" and 1000 or 10
    return value * factor * divisor / mode_divisor
  end
  return value * factor
end

local function receive_mode(value, device)
  local mode = modes[value]
  if mode then device:set_field(prefix .. "interface_mode", mode, persistent) end
  return mode
end

local function write_mode(device, _, value)
  if type(value) ~= "string" then return false end
  local raw = mode_values[value]
  if raw == nil then return false end
  local request = cluster_base.write_manufacturer_specific_attribute(device, 0x0702, 0x0302,
    0x1015, types.Enum16, raw):to_endpoint(2)
  if not pcall(device.send, device, request) then return false end
  -- Edge native send has no confirmed remote write result. Actual readback
  -- supplies state; no guessed ACK TSN, optimistic state or rollback.
  pcall(zcl.read_attribute, device, 0x0702, 0x0302, 2, 0x1015)
  return true
end

local function receive_version(value, device, _, mapping)
  if type(value) ~= "string" then return end
  local bytes = {value:byte(1, #value)}
  local software = mapping.attribute_id == 0x8000
  local version = software and table.concat(bytes, ".") or tonumber(table.concat(bytes))
  device:set_field(prefix .. (software and "software_version" or "hardware_version"), version, persistent)
  return version
end

local clusters = {
  zcl.cluster_attribute(0x0B04, 0x0304, {name = "power", endpoint = 2, component = "main", read_only = true,
    data_type = types.Int32, emit = emit.power(), from_device = electrical_value, read_on_configure = true,
    reporting_defaults = {minimum_interval = 5, maximum_interval = 3600, reportable_change = 1}}),
  zcl.cluster_attribute(0x0B04, 0x0305, {name = "emizb132_reactive_power", endpoint = 2, component = "main", read_only = true,
    data_type = types.Int32, emit = emit.emizb132ReactivePower("VAr"),
    from_device = electrical_value, read_on_configure = true,
    reporting_defaults = {minimum_interval = 5, maximum_interval = 3600, reportable_change = 1}}),
  zcl.cluster_attribute(0x0702, 0x0302, {name = "emizb132_interface_mode", endpoint = 2, component = "main", mfg_code = 0x1015,
    data_type = types.Enum16, write_type = types.Enum16, sender = write_mode, suppress_optimistic_state = true,
    emit = emit.emizb132InterfaceMode(), from_device = receive_mode,
    read_on_configure = true}),
}

for index, component in ipairs({"phaseA", "phaseB", "phaseC"}) do
  local base = ({0x0500, 0x0900, 0x0A00})[index]
  clusters[#clusters + 1] = zcl.cluster_attribute(0x0B04, base + 5, {
    name = "voltage_" .. component, endpoint = 2, component = component, read_only = true,
    data_type = types.Uint16, emit = emit.voltage(), from_device = electrical_value, read_on_configure = true,
    reporting_defaults = {minimum_interval = 10, maximum_interval = 65000, reportable_change = 50},
  })
  clusters[#clusters + 1] = zcl.cluster_attribute(0x0B04, base + 8, {
    name = "current_" .. component, endpoint = 2, component = component, read_only = true,
    data_type = types.Uint16, emit = emit.current(), from_device = electrical_value, read_on_configure = true,
    -- ZHC 0.05 * divisor10 = 0.5, encoded by its Uint16 carrier as 0.
    reporting_defaults = {minimum_interval = 10, maximum_interval = 65000, reportable_change = 0},
  })
end
for _, item in ipairs({{0, "main"}, {1, "production"}}) do
  clusters[#clusters + 1] = zcl.cluster_attribute(0x0702, item[1], {
    name = item[1] == 0 and "energy" or "produced_energy", endpoint = 2, component = item[2], read_only = true,
    data_type = types.Uint48, emit = emit.energy(), from_device = energy_value, read_on_configure = true,
    reporting_defaults = {minimum_interval = 10, maximum_interval = 65000, reportable_change = 100},
  })
end
for _, attribute in ipairs({0x8000, 0x8020}) do
  clusters[#clusters + 1] = zcl.cluster_attribute(0, attribute, {
    name = attribute == 0x8000 and "emizb132_software_version" or "emizb132_hardware_version",
    endpoint = basic_endpoint, mfg_code = 0x1015, data_type = types.OctetString,
    from_device = receive_version, read_only = true, read_on_configure = false, read_on_refresh = false,
  })
end

local emizb132 = {
  profile = "meters-emizb132", zcl_clusters = clusters, zigbee_message_handler = capture_frame,
  configure = function(driver, device)
    -- Primary forces these caches on every configure; no scaler reads required.
    for name, value in pairs({voltage_multiplier = 1, voltage_divisor = 10, current_multiplier = 1, current_divisor = 10}) do
      device:set_field(prefix .. name, value, persistent)
    end
    local endpoint = basic_endpoint(device)
    if endpoint then
      zcl.read_attribute(device, 0, 0x8000, endpoint, 0x1015)
      zcl.read_attribute(device, 0, 0x8020, endpoint, 0x1015)
    end
    for _, cluster in ipairs({0x0B04, 0x0702}) do
      zcl.bind_cluster(device, cluster, driver.environment_info.hub_zigbee_eui, 2)
    end
    -- Explicit endpoint also implements the ZHC EP2 missing-cluster quirk;
    -- no descriptor rewrite or generic SDK bind of unrelated EP1 is needed.
    for _, mapping in ipairs(clusters) do
      local defaults = mapping.reporting_defaults
      if defaults then
        zcl.configure_reporting(device, {cluster = mapping.cluster_id, attribute = mapping.attribute_id,
          data_type = mapping.data_type, minimum_interval = defaults.minimum_interval,
          maximum_interval = defaults.maximum_interval, reportable_change = defaults.reportable_change}, 2)
      end
    end
  end,
}

register(emizb132, {
  device_helpers.create_fingerprint("Develco Products A/S", "EMIZB-132"),
  device_helpers.create_fingerprint("frient A/S", "EMIZB-132"),
})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(registrations, {
  {1, "rpt-eft"},
})
-- ZCL REPORTING CAPABILITIES END

return {id = "zcl.switches.emizb132", registrations = registrations,}
