-- ZHC cff1de47 zigbeetlc.ts:11-55,206-320,712-720. Sonoff is the Basic manufacturer.
local zcl = require "protocol.zcl"
local emit = require "capabilities.events.all"
local capabilities = require "st.capabilities"
local types = require "st.zigbee.data_types"
local cluster_base = require "st.zigbee.cluster_base"
local device_helpers = require "contracts.helpers.family"
local registrations, register = device_helpers.definition_registry()
local persistent, transient = {persist = true}, {persist = false}
local prefix = "zgDual:"
local power = {[0] = "off", [1] = "on", [2] = "toggle", [255] = "previous"}
local power_wire = {off = 0, on = 1, toggle = 2, previous = 255}
local limits = {[0x10] = {0, 524}, [0x5101] = {0, 99}, [0x5102] = {0, 99},
  [0x5103] = {0, 99}, [0x5104] = {0, 99}, [0x5105] = {0, 99}, [0x5106] = {0, 99}, [0x5107] = {1, 10}}
local presence_emit = emit.zgDualPresenceState()
local raw_emit = emit.zgDualIlluminanceRaw()

local function capture_occupancy(device, rx)
  local header = rx.body.zcl_header
  if not header then return end
  if rx.address_header.cluster.value == 6 and header.frame_ctrl:is_cluster_specific_set() then
    local now = require("cosock.socket").gettime()
    local key = prefix .. "actions:" .. rx.address_header.src_endpoint.value
    local recent = device:get_field(key) or {}
    for _, item in ipairs(recent) do
      if item.sequence == header.seqno.value and item.expiry > now then rx.__zgDualDuplicateAction = true; return end
    end
    for index = #recent, 1, -1 do if recent[index].expiry <= now then table.remove(recent, index) end end
    if #recent > 4 then table.remove(recent, 1) end
    recent[#recent + 1] = {sequence = header.seqno.value, expiry = now + 10}
    device:set_field(key, recent, transient)
    -- The existing remote emitter compares only its last key; the primary guard above is authoritative here.
    device:set_field("__zcl_last_remote_action", nil, transient)
    return
  end
  if rx.address_header.cluster.value ~= 0x0406 or header.frame_ctrl:is_cluster_specific_set()
    or (header.cmd.value ~= 1 and header.cmd.value ~= 10) or header.frame_ctrl:is_mfg_specific_set() then return end
  local value
  for _, record in ipairs(rx.body.zcl_body.attr_records or {}) do
    if record.attr_id.value == 0 and record.data and (not record.status or record.status.value == 0) then value = record.data.value end
  end
  rx.__zgDualOccupancy = {value = value}
end

local function occupancy(_, _, context)
  local frame = context.zb_rx.__zgDualOccupancy
  if not frame or frame.used or type(frame.value) ~= "number" then return end
  frame.used = true
  return frame.value
end

local function occupancy_events(device, value)
  local pir, radar = (value & 2) ~= 0, (value & 4) ~= 0
  return {
    capabilities.occupancySensor.occupancy((value & 1) ~= 0 and "occupied" or "unoccupied"),
    capabilities.motionSensor.motion(pir and "active" or "inactive"),
    capabilities.presenceSensor.presence(radar and "present" or "not present"),
    presence_emit(device, pir and (radar and "motion_and_presence" or "motion") or (radar and "presence" or "clear")),
  }
end

local function receive_setting(value, device, _, mapping)
  if type(value) == "table" then value = value.value end
  if mapping.attribute_id == 0x4003 then value = power[value]
  elseif type(value) ~= "number" or value ~= value or value < 0 or value > (mapping.attribute_id == 0x10 and 65534 or 255) then return end
  if value == nil then return end
  device:set_field(prefix .. mapping.name, value, persistent)
  return value
end

local function write_setting(device, mapping, value, context)
  local raw
  if mapping.attribute_id == 0x4003 then
    if type(value) ~= "string" then return false end
    raw = power_wire[value]
  else
    local range = limits[mapping.attribute_id]
    if type(value) ~= "number" or value ~= value or value < range[1] or value > range[2] then return false end
    -- Primary Buffer.writeUInt8/16LE truncates positive fractions; expose bounds constrain SET only.
    raw = math.floor(value)
  end
  if raw == nil then return false end
  local endpoint = context and context.endpoint or device:get_endpoint(mapping.cluster_id)
  local request = cluster_base.write_attribute(device, types.ClusterId(mapping.cluster_id),
    types.AttributeId(mapping.attribute_id), mapping.data_type(raw)):to_endpoint(endpoint)
  if not pcall(device.send, device, request) then return false end
  -- Queue acceptance is not remote success. Actual RX/readback supplies state and persistent cache.
  pcall(zcl.read_attribute, device, mapping.cluster_id, mapping.attribute_id, endpoint)
  return true
end

local function action(rx, cluster, command)
  if cluster ~= 6 or rx.__zgDualDuplicateAction then return nil, nil, true end
  local value = ({[0] = "off", [1] = "on", [2] = "toggle", [0x40] = "off"})[command]
  return value, "main", true
end

local mappings = {
  zcl.cluster_attribute(0x0406, 0, {name = "zg_dual_occupancy", data_type = types.Bitmap8,
    read_only = true, read_on_configure = false, from_device = occupancy, emit = occupancy_events}),
  zcl.battery({read_only = true, minimum_interval = 3600, maximum_interval = 65000, reportable_change = 10,
    from_device = function(value, _, context)
      if context.raw_value >= 255 then return end
      return value
    end}),
  zcl.cluster_attribute(1, 0x20, {name = "battery_voltage", data_type = types.Uint8, read_only = true,
    read_on_configure = false, from_device = function(value)
      if value < 255 then return value / 10 end
    end, emit = emit.voltage()}),
  zcl.illuminance({name = "zg_dual_illuminance", emit = emit.zgDualIlluminance(),
    minimum_interval = 10, maximum_interval = 3600, reportable_change = 5,
    from_device = function(value)
      if value == 65535 then return end
      -- Primary does not round or clamp lux. Standard ST lux has a 100000 maximum.
      return value == 0 and 0 or 10 ^ ((value - 1) / 10000)
    end}),
  zcl.cluster_attribute(0x0400, 0, {name = "zg_dual_illuminance_raw", data_type = types.Uint16,
    read_only = true, read_on_configure = false, read_on_refresh = false,
    from_device = function(value, device)
      if device.preferences.illuminanceRaw == true and value ~= 65535 then return value end
    end, emit = raw_emit}),
  zcl.on_off({emit = emit.switch(), read_on_configure = true,
    minimum_interval = 0, maximum_interval = 65000, reportable_change = 1}),
  zcl.cluster_attribute(6, 0x4003, {name = "zg_dual_PowerOn", data_type = types.Enum8,
    read_on_configure = true, sender = write_setting, suppress_optimistic_state = true,
    from_device = receive_setting, emit = emit.zgDualPowerOn()}),
}
for _, item in ipairs({
  {0x0010, "zg_dual_FadingTime", types.Uint16, emit.zgDualFadingTime()},
  {0x5101, "zg_dual_ZoneOneMotion", types.Uint8, emit.zgDualZoneOneMotion()},
  {0x5102, "zg_dual_ZoneOneStill", types.Uint8, emit.zgDualZoneOneStill()},
  {0x5103, "zg_dual_ZoneTwoMotion", types.Uint8, emit.zgDualZoneTwoMotion()},
  {0x5104, "zg_dual_ZoneTwoStill", types.Uint8, emit.zgDualZoneTwoStill()},
  {0x5105, "zg_dual_ZoneThreeMotion", types.Uint8, emit.zgDualZoneThreeMotion()},
  {0x5106, "zg_dual_ZoneThreeStill", types.Uint8, emit.zgDualZoneThreeStill()},
  {0x5107, "zg_dual_RadarScans", types.Uint8, emit.zgDualRadarScans()},
}) do
  mappings[#mappings + 1] = zcl.cluster_attribute(0x0406, item[1], {name = item[2], data_type = item[3],
    read_on_configure = true, sender = write_setting, suppress_optimistic_state = true,
    from_device = receive_setting, emit = item[4]})
end

-- Primary determineEndpoint/getEndpointsWithCluster uses the interview descriptor.
-- main-component defaults are not evidence that these models have physical EP1.
for _, mapping in ipairs(mappings) do
  local cluster = mapping.cluster_id
  mapping.endpoint = function(device)
    return device:get_endpoint(cluster)
  end
end

local dual = {
  profile = "safety-motion-zigbeetlc-dual", magic_packet = false, query_on_configure = false, query_on_announce = false,
  component_to_endpoint = function(device)
    return device:get_endpoint(0x0406)
  end,
  advanced_remote = true, remote_action_emit_name = "zgDualAction", standard_command_action_resolver = action,
  zigbee_message_handler = capture_occupancy, zcl_clusters = mappings,
  configure = function(driver, device)
    -- commandsOnOff additionally binds the output OnOff cluster. No occupancy reporting is declared upstream.
    for _, endpoint in pairs(device.zigbee_endpoints) do
      for _, cluster in ipairs(endpoint.client_clusters or {}) do
        if cluster == 6 then zcl.bind_cluster(device, 6, driver.environment_info.hub_zigbee_eui, endpoint.id) end
      end
    end
  end,
}
register(dual, {
  device_helpers.create_fingerprint("Sonoff", "ZG-204ZS-z"),
  device_helpers.create_fingerprint("Sonoff", "ZG-204ZM-z"),
})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(registrations, {
  {1, "rpt-zqk"},
})
-- ZCL REPORTING CAPABILITIES END

return {id = "zcl.sensors.zigbeetlc_dual", registrations = registrations,}
