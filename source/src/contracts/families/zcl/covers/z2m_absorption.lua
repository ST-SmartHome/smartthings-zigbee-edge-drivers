local zcl = require "protocol.zcl"
local emit = require "capabilities.events.all"
local device_helpers = require "contracts.helpers.family"
local data_types = require "st.zigbee.data_types"
local cluster_base = require "st.zigbee.cluster_base"

local registrations, register = device_helpers.definition_registry()

local position = {
  from = function(value) return value >= 0 and value <= 100 and 100-value or nil end,
  to = function(value) return 100-value end,
}
local shade_state = {from = function(value)
  if value < 0 or value > 100 then return nil end
  return value == 0 and "open" or value == 100 and "closed" or "partially open"
end}

local somfy_glydea2 = {
  profile = "covers-somfy-glydea2",
  component_to_endpoint = function() return 1 end,
  parent_refresh = function(device)
    zcl.read_attribute(device, 0x0102, 8, 1)
    for _, attribute in ipairs({0x21, 0x20}) do pcall(zcl.read_attribute, device, 1, attribute, 232) end
  end,
  zcl_clusters = {
    zcl.cover_position({
      endpoint = 1, component = "main",
      minimum_interval = 1, maximum_interval = 65000, reportable_change = 1,
      converter = position,
    }),
    zcl.window_shade_state({
      endpoint = 1, component = "main", configure_reporting = false, read_on_configure = false,
      converter = shade_state,
    }),
    zcl.cover_state({endpoint=1, component="main"}),
    zcl.battery({
      endpoint = 232, component = "main",
      minimum_interval = 3600, maximum_interval = 65000, reportable_change = 10,
      from_device = function(value, _, context) if context.raw_value ~= 255 then return value end end,
    }),
  },
  configure = function(driver, device)
    local hub_eui = driver.environment_info.hub_zigbee_eui
    zcl.bind_cluster(device, 0x0102, hub_eui, 1)
    zcl.bind_cluster(device, 0x0001, hub_eui, 232)
  end,
}
register(somfy_glydea2, {
  device_helpers.create_fingerprint("SOMFY", "Glydea 2 Ultra WF Curtain"),
})

local function allesin_identify_sender(device, _, value, context)
  local seconds = value or 3
  if type(seconds) ~= "number" or seconds < 1 or seconds > 30 or seconds % 1 ~= 0 then return false end
  return zcl.send_raw_cluster_command(device, 0x0003, 0x00, string.char(seconds, 0), context.endpoint or 1)
end

local allesin_cover = {
  profile = "covers-allesin-roller-shade",
  zcl_clusters = {
    zcl.cover_position({
      endpoint = 1, component = "main",
      minimum_interval = 1, maximum_interval = 65000, reportable_change = 1,
      converter = position,
    }),
    zcl.window_shade_state({
      endpoint = 1, component = "main", configure_reporting = false, read_on_configure = false,
      converter = shade_state,
    }),
    zcl.cover_state({endpoint = 1, component = "main"}),
    zcl.battery({
      endpoint = 1, component = "main", scale = 1,
      minimum_interval = 3600, maximum_interval = 65000, reportable_change = 10,
      converter = {from = function(value) return value < 255 and value or nil end},
    }),
    zcl.cluster_attribute(0x0003, nil, {
      name = "allesin_identify", endpoint = 1, component = "main",
      write_only = true, sender = allesin_identify_sender,
    }),
  },
  capability_commands = {
    {capability_id="concertmirror08464.allesinIdentify",command_name="identify",argument_name="seconds",mapping_name="allesin_identify"},
  },
  configure = function(driver, device)
    local hub_eui = driver.environment_info.hub_zigbee_eui
    zcl.bind_cluster(device, 0x0102, hub_eui, 1)
    zcl.bind_cluster(device, 0x0001, hub_eui, 1)
  end,
}
register(allesin_cover, {
  device_helpers.create_fingerprint("Aubor", "TLSR82xx"),
})

local function zm108m_enum(name, cluster, attribute, emitter, values, read_only)
  local reverse = {}
  for raw, value in pairs(values) do reverse[value] = raw end
  local mapping = zcl.cluster_attribute(cluster, attribute, {
    name = name, endpoint = 1, component = "main", emit = emitter,
    data_type = data_types.Enum8, write_type = data_types.Enum8,
    read_only = read_only, read_on_configure = false,
    converter = {
      from = function(value)
        if type(value) == "table" then value = value.value end
        return values[value]
      end,
      to = function(value) return reverse[value] end,
    },
  })
  if not read_only then
    mapping.sender = function(device, _, value, context)
      local request = cluster_base.write_attribute(
        device, data_types.ClusterId(cluster), data_types.AttributeId(attribute),
        data_types.Enum8(reverse[value])
      )
      if cluster == 0xE001 then request.body.zcl_header.frame_ctrl:set_disable_default_response() end
      device:send(request:to_endpoint(context.endpoint or 1))
      return true
    end
  end
  return mapping
end

local zm108m_switch_type = zm108m_enum(
  "zm108m_switch_type", 0xE001, 0xD030, emit.zm108mSwitchType(),
  {[0] = "flip-switch", [1] = "sync-switch", [2] = "button-switch", [3] = "button2-switch"}
)
local function zm108m_position(value, device)
  if value < 0 or value > 100 then return nil end
  return device.preferences.invertCover == true and 100 - value or value
end

local moes_zm108m = {
  profile = "covers-moes-zm108m",
  zcl_clusters = {
    zcl.tuya_magic_packet({read_on_configure = false}),
    zcl.cluster_attribute(0x0102, 8, {
      name = "cover_position", endpoint = 1, data_type = data_types.Uint8, emit = emit.shade_level(), read_on_configure = false,
      converter = {from = zm108m_position, to = zm108m_position},
    }),
    zcl.cluster_attribute(0x0102, 8, {
      name = "window_shade_state", endpoint = 1, data_type = data_types.Uint8, emit = emit.shade_state(), read_only = true, read_on_configure = false,
      converter = {from = function(value, device)
        local position = zm108m_position(value, device)
        if position == nil then return nil end
        return position == 0 and "closed" or position == 100 and "open" or "partially open"
      end},
    }),
    zcl.cover_state({endpoint = 1}),
    zm108m_enum("zm108m_moving", 0x0102, 0xF000, emit.zm108mMoving(), {[0] = "UP", [1] = "STOP", [2] = "DOWN"}, true),
    zm108m_enum("zm108m_motor_reversal", 0x0102, 0xF002, emit.zm108mMotorReversal(), {[0] = "OFF", [1] = "ON"}),
    zm108m_enum("zm108m_calibration", 0x0102, 0xF001, emit.zm108mCalibration(), {[0] = "ON", [1] = "OFF"}),
    zcl.cluster_attribute(0x0102, 0xF003, {
      name = "zm108m_calibration_time", endpoint = 1, read_only = true, read_on_configure = false,
      data_type = data_types.Uint16, scale = 10, emit = emit.zm108mCalibrationTime(),
    }),
    zm108m_enum("zm108m_indicator_mode", 6, 0x8001, emit.zm108mIndicatorMode(), {[0] = "off", [1] = "off/on", [2] = "on/off", [3] = "on"}),
    zm108m_enum("zm108m_backlight_mode", 6, 0x5000, emit.zm108mBacklightMode(), {[0] = "OFF", [1] = "ON"}),
    zm108m_switch_type,
  },
  parent_refresh = function(device)
    for _, item in ipairs({{0x0102, 8}, {0x0102, 0xF000}, {0x0102, 0xF001}, {0x0102, 0xF002}, {0x0102, 0xF003}, {6, 0x8001}, {6, 0x5000}, {0xE001, 0xD030}}) do
      zcl.read_attribute(device, item[1], item[2], 1)
    end
    return true
  end,
}
register(moes_zm108m, {
  device_helpers.create_fingerprint("_TZ3210_mldzab8w", "TS130F"),
})

local function axis_modern(device)
  return (device:get_field("axis_gear_version") or 0) >= 1093
end
local function axis_refresh(device)
  zcl.read_attribute(device, 0, 0x4000, 1)
  zcl.read_attribute(device, 1, 0x21, 1)
  zcl.read_attribute(device, axis_modern(device) and 0x0102 or 8, axis_modern(device) and 8 or 0, 1)
end
local axis_level_event, axis_state_event = emit.shade_level(), emit.shade_state()
local function axis_position(device, _, value)
  if type(value) ~= "number" or value < 0 or value > 100 or value % 1 ~= 0 then return false end
  if axis_modern(device) then
    local previous = device:get_latest_state("main", "windowShadeLevel", "shadeLevel") or 0
    device:emit_event(axis_state_event(device, value > previous and "opening" or "closing"))
    return zcl.send_raw_cluster_command(device, 0x0102, 5, string.char(100 - value), 1)
  end
  return zcl.send_raw_cluster_command(device, 8, 4, string.char(math.floor(value * 254 / 100 + 0.5), 0, 0, 0, 0), 1)
end
local function axis_state(device, mapping, value)
  if value == "open" or value == "close" then
    if not axis_modern(device) then return axis_position(device, mapping, value == "open" and 100 or 0) end
    device:emit_event(axis_state_event(device, value == "open" and "opening" or "closing"))
    return zcl.send_raw_cluster_command(device, 0x0102, value == "open" and 0 or 1, "", 1)
  end
  if value ~= "stop" then return false end
  if axis_modern(device) then
    local state = device:get_latest_state("main", "windowShade", "windowShade")
    if state == "opening" or state == "closing" then return zcl.send_raw_cluster_command(device, 0x0102, 2, "", 1) end
    return zcl.read_attribute(device, 0x0102, 8, 1)
  end
  device.thread:call_with_delay(5, function() zcl.read_attribute(device, 8, 0, 1) end, "AXIS pause position")
  return true
end
local function axis_terminal(value)
  return value == 0 and "closed" or value >= 99 and "open" or "partially open"
end
local function axis_level_events(device, value)
  local state = axis_terminal(value)
  if axis_modern(device) then
    local previous = device:get_latest_state("main", "windowShadeLevel", "shadeLevel") or 0
    if value ~= previous then state = value > previous and "opening" or "closing" end
  end
  return {axis_level_event(device, value), axis_state_event(device, state)}
end
local axis_gear = {
  profile = "covers-axis-gear", magic_packet = false, initial_custom_state_query = false,
  component_to_endpoint = function() return 1 end,
  parent_refresh = axis_refresh,
  zcl_clusters = {
    zcl.cluster_attribute(0, 0x4000, {
      name = "axis_gear_version", endpoint = 1, data_type = data_types.CharString, read_only = true,
      read_on_configure = false, read_on_refresh = false,
      handler = function(device, value)
        local version = type(value) == "string" and tonumber(value:sub(-4)) or nil
        local modern = (version or 0) >= 1093
        local changed = axis_modern(device) ~= modern
        device:set_field("axis_gear_version", version, {persist = true})
        if changed then zcl.read_attribute(device, modern and 0x0102 or 8, modern and 8 or 0, 1) end
      end,
    }),
    zcl.cluster_attribute(8, 0, {
      name = "axis_gear_level", endpoint = 1, data_type = data_types.Uint8, read_only = true,
      read_on_configure = false, read_on_refresh = false, emit = axis_level_events,
      converter = {from = function(value) if value <= 254 then return math.floor(value * 100 / 254 + 0.5) end end},
      minimum_interval = 1, maximum_interval = 3600, reportable_change = 1,
    }),
    zcl.cover_position({
      endpoint = 1, read_on_configure = false, read_on_refresh = false, sender = axis_position,
      converter = position,
      from_device = function(value, device) if axis_modern(device) then return position.from(value) end end,
      minimum_interval = 1, maximum_interval = 65000, reportable_change = 1,
    }),
    zcl.window_shade_state({
      endpoint = 1, configure_reporting = false, read_on_configure = false, read_on_refresh = false,
      from_device = function(value, device)
        local level = position.from(value)
        if axis_modern(device) and level ~= nil then return axis_terminal(level) end
      end,
    }),
    zcl.cover_state({endpoint = 1, sender = axis_state}),
    zcl.battery({
      endpoint = 1, read_on_configure = false, read_on_refresh = false,
      from_device = function(value, _, context) if context.raw_value ~= 255 then return value end end,
      minimum_interval = 3600, maximum_interval = 65000, reportable_change = 10,
    }),
  },
  configure = function(driver, device)
    for _, cluster in ipairs({8, 0x0102, 1}) do zcl.bind_cluster(device, cluster, driver.environment_info.hub_zigbee_eui, 1) end
    axis_refresh(device)
  end,
}
register(axis_gear, {device_helpers.create_fingerprint("AXIS", "Gear")})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(registrations, {
  {1, "rpt-gtd"},
  {2, "rpt-tqk"},
  {4, "rpt-gaw"},
})
-- ZCL REPORTING CAPABILITIES END

return {
  id = "zcl.covers.z2m_absorption",
  registrations = registrations,
}
