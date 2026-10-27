-- Core presence contracts from Z2M 764f7d10bd2c2b2009f85938b6ae07fd92946d3b.
local tuya = require "protocol.tuya"
local emit = require "capabilities.events.all"
local device_helpers = require "contracts.helpers.family"
local registrations, register_device_definition = device_helpers.definition_registry()

-- MW836P differs from MW833P: its MCU supports startup/rejoin state queries.
local mowe_mw836p_core = {
  profile = "safety-presence-mw836p-core",
  magic_packet = true,
  query_on_configure = true,
  query_on_announce = true,
  announce_delay = 0,
  time_start = "off",
  datapoints = {
    tuya.dp_enum(1, {name="presence", endpoint=1, read_only=true,
      converter=tuya.converter.from_only(function(value) return value==1 end), emit=emit.presence()}),
    tuya.dp_illuminance(103, {endpoint=1, read_only=true, emit=emit.illuminance()}),
  },
}
register_device_definition(mowe_mw836p_core, {
  device_helpers.create_fingerprint("_TZE284_mexuq6lm", "TS0601"),
})

-- ZG-210Z: pinned hobeian.ts and the exact identity from issue #46.
local zg210z = {
  profile = "safety-pressure-zg210z-core",
  magic_packet = true,
  query_on_configure = false,
  query_on_announce = false,
  initial_custom_state_query = false,
  mcu_version_request_on_configure = false,
  time_start = "off",
  datapoints = {
    tuya.dp_enum(1, {name="zg210z_pressure_state", read_only=true,
      converter=tuya.converter.lookup_from_to({none=0, sit=1, sedentary=2}),
      emit=emit.zg210zPressureState()}),
    tuya.dp_numeric(2, {name="zg210z_current_pressure", read_only=true,
      converter=tuya.converter.signed_number_pair(1), emit=emit.zg210zCurrentPressure()}),
    tuya.dp_temperature(101, {read_only=true,
      converter=tuya.converter.signed_number_pair(10), emit=emit.temperature("C")}),
    tuya.dp_humidity(102, {read_only=true, scale=1, emit=emit.humidity()}),
    tuya.dp_battery(15, {read_only=true, emit=emit.battery()}),
    tuya.dp_numeric(105, {name="zg210z_pressure_intensity", suppress_optimistic_state=true,
      command_id=0x00, transaction=0x0100, converter=tuya.converter.signed_number_pair(1),
      emit=emit.zg210zPressureIntensity()}),
    tuya.dp_numeric(106, {name="zg210z_presence_delay", suppress_optimistic_state=true,
      command_id=0x00, transaction=0x0100, converter=tuya.converter.signed_number_pair(1),
      emit=emit.zg210zPresenceDelay()}),
    tuya.dp_numeric(107, {name="zg210z_sedentary_reminder", suppress_optimistic_state=true,
      command_id=0x00, transaction=0x0100, converter=tuya.converter.signed_number_pair(1),
      emit=emit.zg210zSedentaryReminder()}),
    tuya.dp_temperature_calibration(103, {name="zg210z_temperature_calibration",
      command_id=0x00, transaction=0x0100,
      suppress_optimistic_state=true, emit=emit.zg210zTemperatureCalibration()}),
    tuya.dp_humidity_calibration(104, {name="zg210z_humidity_calibration",
      command_id=0x00, transaction=0x0100,
      suppress_optimistic_state=true, emit=emit.zg210zHumidityCalibration()}),
  },
}
register_device_definition(zg210z, {
  device_helpers.create_fingerprint("_TZE200_ihizzpzn", "ZG-210Z"),
})

return {
  id = "ef00.presence.simple_sensors",
  registrations = registrations,
}
