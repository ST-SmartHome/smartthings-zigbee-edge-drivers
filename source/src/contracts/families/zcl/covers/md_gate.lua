-- cff1de47 custom_devices_diy.ts:1075..1358; MakeDIY firmware Basic231..235.
local zcl = require "protocol.zcl"
local emit = require "capabilities.events.all"
local caps = require "st.capabilities"
local types = require "st.zigbee.data_types"
local Reader = require("st.buf").Reader
local cluster_base = require "st.zigbee.cluster_base"
local management = require "st.zigbee.device_management"
local device_helpers = require "contracts.helpers.family"
local registrations, register = device_helpers.definition_registry()
local MAIN, FULL = "covers-md-gate-main", "covers-md-gate-walk"
local MODE, CONTACTS, PROFILE = "mdGate:sensor_mode", "mdGate:contacts", "mdGate:requested_profile"
local persistent, transient = {persist = true}, {persist = false}
local gate_event = emit.mdGateState()

local function finite(value)
  return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end
local function float(value)
  return types.SinglePrecisionFloat.deserialize(Reader(string.pack("<f", value)))
end
local function has_walk(device) return device:supports_server_cluster(0x0006, 5) end
local expected_components = {
  main = {"momentary", "concertmirror08464.mdGateState", "concertmirror08464.mdGatePulseDuration", "refresh", "signalStrength"},
  closedLimit = {"contactSensor"}, openLimit = {"contactSensor"}, walk = {"momentary"},
}
local function profile_matches(device)
  local components, walk = device.profile.components, has_walk(device)
  for id in pairs(components) do
    if expected_components[id] == nil or id == "walk" and not walk then return false end
  end
  for id, required in pairs(expected_components) do
    if id ~= "walk" or walk then
      local component = components[id]
      if component == nil or #(component.capabilities or {}) ~= #required then return false end
      for _, capability in ipairs(required) do
        if not device:supports_capability_by_id(capability, id) then return false end
      end
    end
  end
  return true
end
local function gate_state_value(device)
  local values = device:get_field(CONTACTS) or {}
  local state = "unknown"
  if type(values.closed) == "boolean" then
    if device:get_field(MODE) ~= "two" then state = values.closed and "closed" or "open"
    elseif type(values.open) == "boolean" then
      state = values.closed and (values.open and "sensor_error" or "closed") or (values.open and "open" or "intermediate")
    end
  end
  return state
end
local function gate_state(device)
  if device:supports_capability_by_id("concertmirror08464.mdGateState", "main") then
    device:emit_component_event({id = "main"}, gate_event(device, gate_state_value(device)))
  end
end
local function set_mode(device, value)
  if value ~= "one" and value ~= "two" then return false end
  if device:get_field(MODE) ~= value then
    -- Coordinator setting, no device DP/write or radio delivery prerequisite.
    device:set_field(MODE, value, persistent)
    device:set_field(CONTACTS, nil, transient)
    gate_state(device)
  end
  return true
end
local function select_profile(device)
  local wanted = has_walk(device) and FULL or MAIN
  -- profile.id is a hub UUID. Only applied component capability shape proves
  -- completion; try_update_metadata accepts the packaged profile name.
  if profile_matches(device) then device:set_field(PROFILE, nil, transient)
  elseif device:get_field(PROFILE) ~= wanted then
    device:set_field(PROFILE, wanted, transient)
    device:try_update_metadata({profile = wanted})
  end
  -- Metadata enqueue is not profile application. No fabricated component here.
end
local function pulse(device, _, command)
  local component = command and command.component or "main"
  local endpoint = component == "main" and 1 or component == "walk" and 5 or nil
  if not endpoint or not profile_matches(device) or (endpoint == 5 and not has_walk(device)) then return false end
  local ok, sent = pcall(zcl.send_raw_cluster_command, device, 6, 1, "", endpoint, nil, nil, true)
  return ok and sent or false
end

local function duration_to_device(value)
  if finite(value) and value % 1 == 0 and value >= 0 and value <= 1000 then return float(value) end
end
local function duration(device, mapping, value)
  local encoded = mapping.to_device(value)
  if encoded == nil then return false end
  local message = cluster_base.write_attribute(device, types.ClusterId(0x000D), types.AttributeId(0x0055), encoded):to_endpoint(4)
  if not pcall(device.send, device, message) then return false end
  -- Edge send means local enqueue, unlike Node's awaited network write. Only
  -- actual RX emits state. No ACK ownership/queue/transaction state is added.
  device.thread:call_with_delay(.25, function() pcall(zcl.read_attribute, device, 0x000D, 0x0055, 4) end,
    "MD gate duration readback250ms after enqueue")
  return true
end
local function read_values(device)
  zcl.read_attribute(device, 0x000D, 0x0055, 4)
  zcl.read_attribute(device, 0x000F, 0x0055, 2)
  zcl.read_attribute(device, 0x000F, 0x0055, 3)
end
local function stop_reporting(device, endpoint, cluster, attribute, kind, change)
  -- This contract stops old schedules; user reporting overrides must not turn
  -- these manual reports into periodic reports. No reporting UI is attached.
  device:send(management.attr_config(device, {cluster = cluster, attribute = attribute, data_type = kind,
    minimum_interval = 0, maximum_interval = 65535, reportable_change = change}):to_endpoint(endpoint))
end
local function contact_value(value)
  if value == true or value == 1 then return true end
  if value == false or value == 0 then return false end
end
local mappings = {zcl.cluster_attribute(0x000D, 0x0055, {
  name = "md_gate_pulse_duration", endpoint = 4, component = "main", data_type = types.SinglePrecisionFloat,
  to_device = duration_to_device, sender = duration, suppress_optimistic_state = true, emit = emit.mdGatePulseDuration(),
  from_device = function(value, _, context)
    -- API16 FloatABC.value mishandles subnormals/nonfinite, but retains exact
    -- Float32 serialization. Decode only this declared attribute locally.
    local typed = context and context.typed_value
    if type(typed) == "table" and typed.ID == 0x39 then value = string.unpack("<f", typed:_serialize()) end
    if finite(value) then return value end
  end,
  read_on_configure = false, read_on_refresh = false,
})}
for _, input in ipairs({{2, "closed", "closedLimit"}, {3, "open", "openLimit"}}) do
  local endpoint, key, component = input[1], input[2], input[3]
  mappings[#mappings + 1] = zcl.cluster_attribute(0x000F, 0x0055, {
    name = "md_gate_state", endpoint = endpoint, component = "main", data_type = types.Boolean,
    read_only = true, read_on_configure = false, read_on_refresh = false,
    from_device = function(value, device)
      local active = contact_value(value)
      if active == nil then return end
      local values = device:get_field(CONTACTS) or {}
      values[key] = active
      device:set_field(CONTACTS, values, transient)
      return gate_state_value(device)
    end,
    emit = gate_event,
  })
  mappings[#mappings + 1] = zcl.cluster_attribute(0x000F, 0x0055, {
    name = "md_gate_" .. key .. "_contact", endpoint = endpoint, component = component, data_type = types.Boolean,
    read_only = true, read_on_configure = false, read_on_refresh = false,
    from_device = function(value)
      local active = contact_value(value)
      if active ~= nil then return active and "closed" or "open" end
    end,
    emit = function(_, value) return caps.contactSensor.contact(value) end,
  })
end
-- Main's writable attribute lives at4. Pulse's named writer explicitly uses1;
-- one logical component has these two distinct physical routes.
local component_endpoints = {main = 4, walk = 5, closedLimit = 2, openLimit = 3}
local endpoint_components = {[1] = "main", [4] = "main", [5] = "walk", [2] = "closedLimit", [3] = "openLimit"}
local family = {
  profile = MAIN, auxiliary_profiles = {FULL}, valid_parent_profiles = {[MAIN] = true, [FULL] = true},
  parent_profile_matches = profile_matches,
  magic_packet = false,
  component_to_endpoint = function(_, component) return component_endpoints[component] end,
  endpoint_to_component = function(_, endpoint) return endpoint_components[endpoint] end,
  protocol_writers = {md_gate_pulse = pulse},
  capability_commands = {{capability_id = "momentary", command_name = "push", mapping_name = "md_gate_pulse"}},
  preferences_changed = function(device) set_mode(device, device.preferences.mdGateSensorMode) end,
  zcl_clusters = mappings,
  runtime_start = function(device)
    select_profile(device)
    local previous = device:get_field(MODE)
    set_mode(device, device.preferences.mdGateSensorMode or device:get_field(MODE) or "one")
    if previous == device:get_field(MODE) then gate_state(device) end
  end,
  parent_refresh = read_values,
  configure = function(driver, device)
    select_profile(device)
    stop_reporting(device, 1, 6, 0, types.Boolean)
    if has_walk(device) then stop_reporting(device, 5, 6, 0, types.Boolean) end
    stop_reporting(device, 4, 0x000D, 0x0055, types.SinglePrecisionFloat, float(100))
    zcl.read_attribute(device, 0x000D, 0x0055, 4)
    for _, endpoint in ipairs({2, 3}) do
      zcl.bind_cluster(device, 0x000F, driver.environment_info.hub_zigbee_eui, endpoint)
      stop_reporting(device, endpoint, 0x000F, 0x0055, types.Boolean)
      zcl.read_attribute(device, 0x000F, 0x0055, endpoint)
    end
  end,
}
register(family, {device_helpers.create_fingerprint("MakeDIY", "MD-GATE-ZB1")})
return {id = "zcl.covers.md_gate", registrations = registrations,}
