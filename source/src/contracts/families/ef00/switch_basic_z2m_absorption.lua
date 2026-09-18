local tuya = require "protocol.tuya"
local emit = require "capabilities.events.all"
local device_helpers = require "contracts.helpers.family"

local device_definitions, register_device_definition = device_helpers.definition_registry()

-- Z2M v26.99.0 tuya.ts:8914-8942: Semicom six-switch touch panel.
-- This exact has only DP1..DP6 on/off values. It must not share the metered
-- _TZE200_8eazvzo6 definition, which additionally owns DP21..DP23.
local semicom_6switch = {
  profile = "switches-switch-6",
  package_group = "switch-basic",
  query_on_configure = false,
  tuya.dp_on_off(1, { name = "switch", component = "main" }),
  tuya.dp_on_off(2, { name = "switch", component = "switch2" }),
  tuya.dp_on_off(3, { name = "switch", component = "switch3" }),
  tuya.dp_on_off(4, { name = "switch", component = "switch4" }),
  tuya.dp_on_off(5, { name = "switch", component = "switch5" }),
  tuya.dp_on_off(6, { name = "switch", component = "switch6" }),
}

register_device_definition(semicom_6switch, device_helpers.create_fingerprints("TS0601", {
  "_TZE204_8eazvzo6",
}))

-- Z2M 26.108.1: Unix time response is required to keep sensor reports alive.
local grxx6qek_temperature_humidity_switch = {
  profile = "switches-switch-1-temp-humidity",
  package_group = "switch-basic",
  query_on_configure = false,
  time_start = "1970",
  datapoints = {
    tuya.dp_on_off(2, {name = "switch", component = "main", suppress_optimistic_state = true}),
    tuya.dp_temperature(27, {read_only = true, scale = 10, emit = emit.temperature("C")}),
    tuya.dp_humidity(46, {read_only = true, scale = 1, emit = emit.humidity()}),
  },
}
register_device_definition(grxx6qek_temperature_humidity_switch,
  device_helpers.create_fingerprints("TS0601", {"_TZE284_grxx6qek"}))

return {
  id = "ef00.switch.basic.z2m_absorption",
  registrations = device_definitions,
}
