local zcl = require "protocol.zcl"
local device_helpers = require "contracts.helpers.family"
local zcl_device_helpers = require "contracts.helpers.zcl"

local registrations, register = device_helpers.definition_registry()
local function inverted_percent(value)
  if type(value)=="number" and value>=0 and value<=100 then return 100-value end
end
local function shade_state(value)
  if type(value)~="number" or value<0 or value>100 then return nil end
  return value==0 and "open" or value==100 and "closed" or "partially open"
end
local position = {from=inverted_percent,to=inverted_percent}
local function cover_endpoint(device) return device:get_endpoint(0x0102) end
local function read_battery(device)
  for _,attribute in ipairs({0x21,0x20}) do pcall(zcl.read_attribute,device,1,attribute,device:get_endpoint(1)) end
end
local function battery_mapping()
  return zcl.battery({minimum_interval=3600,maximum_interval=65000,reportable_change=10,
    from_device=function(value,_,context) if context.raw_value~=255 then return value end end})
end
local function cover_mappings(tilt)
  local options={converter=position,minimum_interval=1,maximum_interval=65000,reportable_change=1}
  return {
    tilt and zcl.cover_tilt(options) or zcl.cover_position(options),
    zcl.window_shade_state({configure_reporting=false,read_on_configure=false,converter={from=shade_state}}),
    zcl.cover_state(),
  }
end
local tilt_lift = {
  profile="covers-somfy-tilt-lift", magic_packet=false,
  initial_custom_state_query=false,
  component_to_endpoint=cover_endpoint,
  protocol_writers={somfy_tilt_lift_identify=zcl_device_helpers.identify},
  capability_commands={
    {capability_id="concertmirror08464.somfyTiltLiftIdentify",command_name="identify",
      mapping_name="somfy_tilt_lift_identify",value=3},
    {capability_id="concertmirror08464.somfyTiltLiftIdentify",command_name="setIdentifyTime",
      argument_name="identifyTime",mapping_name="somfy_tilt_lift_identify"},
  },
  parent_refresh=function(device)
    for _,attribute in ipairs({8,9}) do zcl.read_attribute(device,0x0102,attribute,device:get_endpoint(0x0102)) end
    read_battery(device)
  end,
  zcl_clusters={
    zcl.cover_position({converter=position,minimum_interval=1,maximum_interval=65000,reportable_change=1}),
    zcl.cover_tilt({converter=position,minimum_interval=1,maximum_interval=65000,reportable_change=1}),
    zcl.window_shade_state({configure_reporting=false,read_on_configure=false,converter={from=shade_state}}),
    zcl.cover_state(),
    battery_mapping(),
  },
}
register(tilt_lift,{device_helpers.create_fingerprint("SOMFY","Tilt & Lift 25 WF Roller")})

local lift = {
  profile="covers-somfy-lift",magic_packet=false,
  initial_custom_state_query=false,
  component_to_endpoint=cover_endpoint,
  parent_refresh=function(device) zcl.read_attribute(device,0x0102,8,device:get_endpoint(0x0102)) end,
  zcl_clusters=cover_mappings(),
}
register(lift,{
  device_helpers.create_fingerprint("SOMFY","Sonesse 30 DC 24V Roller"),
  device_helpers.create_fingerprint("SOMFY","Sonesse2 40 Zigbee Roller"),
})

local battery_lift = {
  profile="covers-somfy-lift-battery",magic_packet=false,
  initial_custom_state_query=false,
  component_to_endpoint=cover_endpoint,
  parent_refresh=function(device)
    read_battery(device)
    zcl.read_attribute(device,0x0102,8,cover_endpoint(device))
  end,
  zcl_clusters=zcl_device_helpers.append_clusters({battery_mapping()},cover_mappings()),
}
register(battery_lift,{
  device_helpers.create_fingerprint("SOMFY","Sonesse 28 WF Li-Ion Roller"),
  device_helpers.create_fingerprint("SOMFY","Sonesse 28 WF Roller"),
  device_helpers.create_fingerprint("SOMFY","Sonesse2 28 WF Li-Ion Roller"),
  device_helpers.create_fingerprint("SOMFY","Sonesse2 28 WF Roller"),
  device_helpers.create_fingerprint("SOMFY","Sonesse 28 WF Li-Ion Zebra"),
})

local lift_battery = {
  profile="covers-somfy-lift-battery",magic_packet=false,
  initial_custom_state_query=false,
  component_to_endpoint=cover_endpoint,
  parent_refresh=function(device)
    zcl.read_attribute(device,0x0102,8,cover_endpoint(device))
    read_battery(device)
  end,
  zcl_clusters=zcl_device_helpers.append_clusters(cover_mappings(),battery_mapping()),
}
register(lift_battery,{
  device_helpers.create_fingerprint("SOMFY","Sonesse Ultra 30 WF Li-Ion Rolle"),
  device_helpers.create_fingerprint("SOMFY","Sonesse2 ULTRA 30 WF Li-ion Roll"),
  device_helpers.create_fingerprint("SOMFY","Roll Up 24 WF Li-ion Roller"),
  device_helpers.create_fingerprint("SOMFY","Sonesse 28 WF Zebra"),
})

local GLYDEA_STATE, GLYDEA_IGNORE = "__somfy_glydea_state", "__somfy_glydea_ignore"
local function glydea_state(device, endpoint)
  local states = device:get_field(GLYDEA_STATE) or {}
  states[endpoint] = states[endpoint] or {stopped=false}
  device:set_field(GLYDEA_STATE, states, {persist=false})
  return states[endpoint]
end
local function glydea_send(device, mapping, value, context)
  local state = glydea_state(device, context.endpoint)
  state.target = type(value)=="number" and value or ({open=100, close=0, stop="stop"})[value]
  state.stopped = false
  local ok, sent = pcall(zcl.get_sender(0x0102), device, mapping, value, context)
  if not ok or sent==false then state.target=nil end
  if not ok then error(sent, 0) end
  return sent
end
local function glydea_received(value, device, context, mapping)
  if device:get_field(GLYDEA_IGNORE)==context.endpoint then return nil end
  if mapping.name=="cover_position" then return inverted_percent(value) end
  return shade_state(value)
end
local glydea = {
  profile="covers-somfy-glydea", magic_packet=false,
  initial_custom_state_query=false,
  component_to_endpoint=cover_endpoint,
  parent_refresh=lift.parent_refresh,
  zcl_clusters={
    zcl.cover_position({converter=position,from_device=glydea_received,sender=glydea_send,
      minimum_interval=1,maximum_interval=65000,reportable_change=1}),
    zcl.window_shade_state({configure_reporting=false,read_on_configure=false,from_device=glydea_received}),
    zcl.cover_state({sender=glydea_send}),
  },
}
glydea.zigbee_message_handler=function(device, rx)
  device:set_field(GLYDEA_IGNORE,nil,{persist=false})
  local header=rx.body.zcl_header
  if header==nil or rx.address_header.cluster.value~=0x0102 or header.cmd.value~=0x0A
      or header.frame_ctrl:is_cluster_specific_set() or header.frame_ctrl:is_mfg_specific_set()
      or not header.frame_ctrl:is_direction_set() then return end
  local endpoint=rx.address_header.src_endpoint.value
  if not device:supports_server_cluster(0x0102,endpoint) then return end
  local state=glydea_state(device,endpoint)
  local raw, moving
  for _,record in ipairs(rx.body.zcl_body.attr_records or {}) do
    if record.data then
      if record.attr_id.value==0 then moving=record.data.value~=0 end
      if record.attr_id.value==8 then raw=record.data.value end
    end
  end
  if moving~=nil then
    if moving and state.stopped then state.target=nil end
    state.stopped=not moving
  end
  if raw==0 and state.target~=nil then
    if state.target=="stop" or state.target~=100 then device:set_field(GLYDEA_IGNORE,endpoint,{persist=false}) end
    state.target=nil
  end
end
register(glydea,{device_helpers.create_fingerprint("SOMFY","Glydea Ultra Curtain")})


local tilt_only = {
  profile="covers-somfy-tilt-only",magic_packet=false,
  initial_custom_state_query=false,
  component_to_endpoint=cover_endpoint,
  parent_refresh=function(device)
    zcl.read_attribute(device,0x0102,9,cover_endpoint(device))
    read_battery(device)
  end,
  zcl_clusters=zcl_device_helpers.append_clusters(cover_mappings(true),battery_mapping()),
}
register(tilt_only,{device_helpers.create_fingerprint("SOMFY","Tilt Only 50 WF TiltOnly")})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(registrations, {
  {1, "rpt-tqvi"},
  {2, "rpt-sca"},
  {3, "rpt-swo"},
  {4, "rpt-sqr"},
  {5, "rpt-sca"},
  {6, "rpt-tfk"},
})
-- ZCL REPORTING CAPABILITIES END

return {
  id = "zcl.covers.somfy_tilt_lift",
  registrations = registrations,
}
