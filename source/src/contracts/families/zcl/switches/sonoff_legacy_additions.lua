local zcl = require "protocol.zcl"
local emit = require "capabilities.events.all"
local device_helpers = require "contracts.helpers.family"
local fp = device_helpers.create_fingerprint
local zcl_device_helpers = require "contracts.helpers.zcl"
local data_types = require "st.zigbee.data_types"
local device_management = require "st.zigbee.device_management"
local generic_body = require "st.zigbee.generic_body"

local device_definitions, register = device_helpers.definition_registry()

local function sonoff_legacy_state(value, device, context)
  local rx = context.zb_rx
  if rx and zcl_device_helpers.duplicate_transaction(device, context.endpoint,
      rx.body.zcl_header.seqno.value, "__sonoff_legacy_transactions") then return end
  return value == 1 or value == true
end

local sonoff_legacy_clusters = {
  zcl.switch({endpoint=1,configure_reporting=false,read_on_configure=false,
    suppress_optimistic_state=true,from_device=sonoff_legacy_state}),
}
local sonoff_legacy_writers = {
  sonoff_legacy_toggle = function(device)
    return zcl.send_raw_cluster_command(device, 6, 2, "", 1)
  end,
}
local sonoff_legacy_commands = {
  {capability_id="momentary",command_name="push",mapping_name="sonoff_legacy_toggle"},
}
local sonoff_basic_zbr3 = {
  profile="switches-sonoff-basiczbr3", zcl_clusters=sonoff_legacy_clusters,
  protocol_writers=sonoff_legacy_writers,capability_commands=sonoff_legacy_commands,
}
local sonoff_s31_zb = {
  profile="plugs-sonoff-s31zb",zcl_clusters=sonoff_legacy_clusters,
  protocol_writers=sonoff_legacy_writers,capability_commands=sonoff_legacy_commands,
  configure=function(driver,device)
    zcl.bind_cluster(device,6,driver.environment_info.hub_zigbee_eui,1)
  end,
}

register(sonoff_basic_zbr3,{fp("SONOFF","BASICZBR3")})
register(sonoff_s31_zb,{fp("SONOFF","S31 Lite zb")})

local sonoff_zbmini = {
  profile="switches-sonoff-zbmini",
  zcl_clusters={zcl.switch({endpoint=1,minimum_interval=0,maximum_interval=65000,
    suppress_optimistic_state=true,from_device=function(value) return value==true or value==1 end})},
  protocol_writers=sonoff_legacy_writers,capability_commands=sonoff_legacy_commands,
}
register(sonoff_zbmini,{fp("SONOFF","01MINIZB")})

local sonoff_minil2 = {
  profile = "switches-sonoff-minil2",
  zcl_clusters = {
    zcl.switch({endpoint=1,minimum_interval=0,maximum_interval=65000,
      suppress_optimistic_state=true,from_device=function(value) return value==true or value==1 end}),
    zcl.cluster_attribute(6, 0x4003, {
      name = "sonoff_minil2_power_on_behavior", endpoint = 1,
      emit = emit.sonoffMinil2PowerBehavior(),
      data_type = data_types.Enum8, write_type = data_types.Enum8,
      from_device = function(value)
        value = type(value)=="table" and value.value or value
        return ({[0]="off",[1]="on",[2]="toggle",[255]="previous"})[value]
      end,
      to_device = function(value)
        return ({off=0,on=1,toggle=2,previous=255})[value]
      end,
      read_on_configure = true, suppress_optimistic_state = true,
    }),
  },
  protocol_writers = sonoff_legacy_writers, capability_commands = sonoff_legacy_commands,
  configure = function(driver, device)
    local request = device_management.build_bind_request(device, 0x0020, driver.environment_info.hub_zigbee_eui, 1)
    request.address_header.cluster = data_types.ClusterId(0x0022)
    request.body.zdo_body = generic_body.GenericBody(request.body.zdo_body:_serialize())
    device:send(request)
  end,
}

register(sonoff_minil2, {fp("SONOFF", "ZBMINIL2")})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(device_definitions, {
  {3, "rpt-zpi"},
  {4, "rpt-zqj"},
})
-- ZCL REPORTING CAPABILITIES END

return {
  id = "zcl.switches.sonoff_legacy_additions",
  registrations = device_definitions,
}
