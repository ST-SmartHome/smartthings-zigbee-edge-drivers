-- ZHC cff1de47 multir.ts:35-78,194-224.
local zcl = require "protocol.zcl"
local emit = require "capabilities.events.all"
local device_helpers = require "contracts.helpers.family"
local clusters = require "st.zigbee.zcl.clusters"
local types = require "st.zigbee.data_types"

local definitions, register = device_helpers.definition_registry()
local action_emit = emit.mirSr100SwitchAction()
local modes = {stop = 0, burglar = 1, fire = 2, emergency = 3, police_panic = 4, fire_panic = 5, emergency_panic = 6}
local levels = {low = 0, medium = 1, high = 2, very_high = 3}
local warning_fields = {mode = true, level = true, strobe = true, duration = true, strobeDutyCycle = true, strobeLevel = true}

local function finite(value, minimum, maximum)
  return type(value) == "number" and value == value and value >= minimum and value <= maximum
end

local function send(device, tx, cluster)
  tx.body.zcl_header.frame_ctrl:set_disable_default_response()
  device:send(tx:to_endpoint(device:get_endpoint(cluster)))
  return true
end

local function warning(device, options)
  if options == nil then options = {} elseif options == "stop" then options = {mode = "stop"} end
  if type(options) ~= "table" then return false end
  for key in pairs(options) do if not warning_fields[key] then return false end end
  local mode = modes[options.mode or "emergency"]
  local level = levels[options.level or "medium"]
  local strobe_level = levels[options.strobeLevel or "high"]
  local strobe, duration, duty = options.strobe, options.duration, options.strobeDutyCycle
  if strobe == nil then strobe = false end
  if duration == nil then duration = 10 end
  if duty == nil then duty = 0 end
  if mode == nil or level == nil or strobe_level == nil or type(strobe) ~= "boolean" or
      not finite(duration, 0, 65535) or not finite(duty, 0, 10) then return false end
  local info = (mode << 4) | (strobe and 4 or 0) | level
  return send(device, clusters.IASWD.server.commands.StartWarning(
    device, info, math.modf(duration), math.modf(duty * 10), strobe_level), 0x0502)
end

local function timed_on(device, timing)
  if type(timing) == "number" then timing = {onTime = timing} end
  if timing == nil then timing = {} end
  if type(timing) ~= "table" then return false end
  for key in pairs(timing) do if key ~= "onTime" and key ~= "offWaitTime" then return false end end
  local on_time, off_wait = timing.onTime, timing.offWaitTime
  if on_time == nil then on_time = 0 end
  if off_wait == nil then off_wait = 0 end
  if not finite(on_time, 0, 6553.4) or not finite(off_wait, 0, 6553.4) then return false end
  return send(device, clusters.OnOff.server.commands.OnWithTimedOff(
    device, 0, math.floor(on_time * 10 + 0.5), math.floor(off_wait * 10 + 0.5)), 6)
end

local function zone_status(rx)
  local status = rx.body.zcl_body.zone_status
  return {raw_value = status.value, typed_value = status}
end

local switch = zcl.switch({
  configure_reporting = false,
  read_on_configure = false,
  read_on_refresh = true,
  reporting_defaults = {minimum_interval = 0, maximum_interval = 65000},
  sender = function(device, _, value)
    if value == true then return send(device, clusters.OnOff.server.commands.On(device), 6) end
    if value == false then return send(device, clusters.OnOff.server.commands.Off(device), 6) end
    return false
  end,
})
local tamper = zcl.tamper()
-- Primary iasZoneAlarm has neither zoneStatusReporting nor configure read.
tamper.minimum_interval, tamper.maximum_interval, tamper.reportable_change = nil, nil, nil
tamper.read_on_configure, tamper.read_on_refresh = false, true

local mir_sr100 = {
  profile = "safety-multir-mirsr100",
  zcl_clusters = {
    switch,
    zcl.cluster_attribute(6, 0, {
      name = "mir_sr100_switch_action",
      data_type = types.Boolean,
      read_only = true,
      read_on_configure = false,
      read_on_refresh = false,
      from_device = function(value, device)
        if device.preferences.stateAction ~= true then return nil end
        return (value == true or value == 1) and "on" or "off"
      end,
      emit = function(device, value)
        local event = action_emit(device, value)
        if event then event.state_change = true end
        return event
      end,
    }),
    zcl.cluster_attribute(0x0500, 2, {
      name = "mir_sr100_alarm",
      data_type = types.Bitmap16,
      read_only = true,
      read_on_configure = false,
      read_on_refresh = true,
      emit = emit.mirSr100Alarm(),
      from_device = function(value)
        if type(value) == "table" then value = value.value end
        if type(value) ~= "number" then return nil end
        return (value & 1) ~= 0 and "alarm" or "clear"
      end,
      command_id = 0,
      command_extractor = zone_status,
    }),
    tamper,
  },
  protocol_writers = {
    mir_sr100_warning = warning,
    mir_sr100_toggle = function(device)
      return send(device, clusters.OnOff.server.commands.Toggle(device), 6)
    end,
    mir_sr100_timed_on = timed_on,
  },
  capability_commands = {
    {capability_id = "concertmirror08464.mirSr100Warning", command_name = "warning", mapping_name = "mir_sr100_warning", argument_name = "warning"},
    {capability_id = "concertmirror08464.mirSr100Warning", command_name = "stop", mapping_name = "mir_sr100_warning", value = "stop"},
    {capability_id = "concertmirror08464.mirSr100Toggle", command_name = "toggle", mapping_name = "mir_sr100_toggle"},
    {capability_id = "concertmirror08464.mirSr100TimedOn", command_name = "onWithTimedOff", mapping_name = "mir_sr100_timed_on", argument_name = "timing"},
    {capability_id = "concertmirror08464.mirSr100TimedOn", command_name = "setOnTime", mapping_name = "mir_sr100_timed_on", argument_name = "onTime"},
  },
  configure = function(driver, device)
    local endpoints = {}
    for _, endpoint in pairs(device.zigbee_endpoints or {}) do
      if device:supports_server_cluster(6, endpoint.id) then endpoints[#endpoints + 1] = endpoint.id end
    end
    table.sort(endpoints)
    for _, endpoint in ipairs(endpoints) do
      zcl.bind_cluster(device, 6, driver.environment_info.hub_zigbee_eui, endpoint)
      zcl.configure_reporting(device, {cluster = 6, attribute = 0, data_type = types.Boolean,
        minimum_interval = 0, maximum_interval = 65000}, endpoint, {auto_endpoint = true})
      device:send(clusters.OnOff.attributes.OnOff:read(device):to_endpoint(endpoint))
    end
  end,
}

register(mir_sr100, {device_helpers.create_fingerprint("MultIR", "MIR-SR100")})


-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(definitions, {
  {1, "rpt-may"},
})
-- ZCL REPORTING CAPABILITIES END

return {id = "zcl.sensors.multir_mirsr100", registrations = definitions,}
