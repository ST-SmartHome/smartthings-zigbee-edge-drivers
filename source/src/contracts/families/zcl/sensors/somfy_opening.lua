local zcl = require "protocol.zcl"
local emit = require "capabilities.events.all"
local capabilities = require "st.capabilities"
local device_helpers = require "contracts.helpers.family"
local zcl_device_helpers = require "contracts.helpers.zcl"

local registrations, register = device_helpers.definition_registry()
local passive = zcl_device_helpers.passive

local opening = {
  profile="safety-somfy-opening", magic_packet=false,
  initial_custom_state_query=false,
  protocol_writers={somfy_open_identify=zcl_device_helpers.identify},
  capability_commands={
    {capability_id="concertmirror08464.somfyOpenIdentify",command_name="identify",
      mapping_name="somfy_open_identify",value=3},
    {capability_id="concertmirror08464.somfyOpenIdentify",command_name="setIdentifyTime",
      argument_name="identifyTime",mapping_name="somfy_open_identify"},
  },
  parent_refresh=function(device)
    for _,attribute in ipairs({0x21,0x20}) do
      pcall(zcl.read_attribute,device,1,attribute,device:get_endpoint(1))
    end
  end,
  zcl_clusters={
    passive(zcl.occupancy({name="somfy_open_alarm",ias_zone=true,component="main",
      emit=emit.somfyOpenAlarm(),from_device=function(value)
        if type(value)=="table" then value=value.value end
        return (value & 1)~=0 and "active" or "inactive"
      end})),
    passive(zcl.battery_low({component="main",emit=function(_,value)
        return value and capabilities.batteryLevel.battery.critical() or capabilities.batteryLevel.battery.normal()
      end})),
    zcl.battery({component="main",minimum_interval=3600,maximum_interval=65000,reportable_change=10,
      from_device=function(value,_,context) if context.raw_value~=255 then return value end end}),
  },
}
register(opening,{device_helpers.create_fingerprint("SOMFY","1811680")})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(registrations, {
  {1, "rpt-zxa"},
})
-- ZCL REPORTING CAPABILITIES END

return {
  id = "zcl.sensors.somfy_opening",
  registrations = registrations,
}
