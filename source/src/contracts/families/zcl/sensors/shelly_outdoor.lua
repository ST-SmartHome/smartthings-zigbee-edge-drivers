local zcl = require "protocol.zcl"
local device_helpers = require "contracts.helpers.family"
local emit = require "capabilities.events.all"
local data_types = require "st.zigbee.data_types"

local device_definitions, register_device_definition = device_helpers.definition_registry()

local function battery(endpoint)
  return zcl.battery({endpoint=endpoint, read_only=true, read_on_configure=true,
    minimum_interval=3600, maximum_interval=65000, reportable_change=10,
    from_device=function(value, _, context)
      if context.raw_value ~= 255 then return value end
    end})
end

local function battery_low(name, event_factory, endpoint)
  return zcl.battery_low({name=name, endpoint=endpoint, emit=event_factory,
    read_only=true, read_on_configure=true, configure_reporting=false,
    converter={from=function(value)
      if type(value) == "table" then value = value.value end
      return (value & 8) ~= 0 and "low" or "normal"
    end}})
end

local function identify(name)
  return zcl.cluster_attribute(0x0003, 0, {name=name, endpoint=1,
    write_only=true, suppress_optimistic_state=true, tx_command_id=0,
    to_device=function(value)
      if type(value) ~= "number" or value % 1 ~= 0 or value < 1 or value > 30 then return nil end
      return string.pack("<I2", value)
    end})
end

local outdoor = {
  profile = "safety-contact-battery-shelly-outdoor",
  configure = function(driver, device)
    zcl.bind_cluster(device, 0x0500, driver.environment_info.hub_zigbee_eui, 1)
  end,
  capability_commands = {
    {capability_id="concertmirror08464.sbdw302Identify", command_name="setIdentifyTime",
      argument_name="identifyTime", mapping_name="sbdw302_identify"},
  },
  zcl_clusters = {
    zcl.contact_alarm_1_or_2({endpoint=1, read_only=true, read_on_configure=true, configure_reporting=false}),
    zcl.shelly_handle_position({name="sbdw302_handle_position", endpoint=1,
      emit=emit.sbdw302HandlePosition(), read_only=true, read_on_configure=true, configure_reporting=false}),
    battery_low("sbdw302_battery_low", emit.sbdw302BatteryLow(), 1),
    battery(1),
    identify("sbdw302_identify"),
  },
}

register_device_definition(outdoor, {
  device_helpers.create_fingerprint("Shelly", "BLU DoorWindow Outdoor ZB"),
})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(device_definitions, {
  {1, "rpt-blz"},
})
-- ZCL REPORTING CAPABILITIES END

return {
  id = "zcl.sensors.shelly_outdoor",
  registrations = device_definitions,
}
