local tuya = require "protocol.tuya"
local emit = require "capabilities.events.all"
local device_helpers = require "contracts.helpers.family"
local ef00_helpers = require "contracts.helpers.ef00"
local thermostat_metadata = require "contracts.helpers.ef00_thermostat_metadata"

local converter = tuya.converter
local device_definitions, register_device_definition = device_helpers.definition_registry()

local hd_t1000 = {
  profile = "thermostats-floor-hd-t1000-core",
  package_group = "wall-2",
  magic_packet = true,
  mcu_version_request_on_configure = true,
  query_on_configure = false,
  time_start = "off",
  tuya.dp_binary(1, {
    name = "system_mode",
    converter = converter.lookup_from_to({ off = false, heat = true }),
    emit = emit.thermostat_mode(),
  }),
  tuya.dp_running_state(3, {
    name = "running_state",
    read_only = true,
    converter = converter.from_only(function(value)
      return ({ [0] = "heating", [1] = "idle" })[tonumber(value)]
    end),
    emit = emit.thermostat_operating_state(),
  }),
  tuya.dp_current_heating_setpoint(16, {
    name = "current_heating_setpoint",
    scale = 10,
    emit = emit.heating_setpoint("C"),
  }),
  tuya.dp_local_temperature(24, {
    name = "local_temperature",
    scale = 10,
    read_only = true,
    emit = emit.temperature("C"),
  }),
}

thermostat_metadata.attach(hd_t1000, { "off", "heat" }, 5, 35, 0.5)
register_device_definition(hd_t1000, ef00_helpers.ts0601_fingerprints({
  "_TZE200_spyvfeti",
}))

local beca_bvrf_l001 = {
  profile="thermostats-beca-bvrf-l001",
  package_group="wall-2",
  magic_packet=true,
  mcu_version_request_on_configure=true,
  query_on_configure=false,
  query_on_announce=false,
  time_start="off",
  datapoints={
    tuya.dp_on_off(1,{name="switch",emit=emit.switch()}),
    tuya.dp_enum(2,{
      name="system_mode",emit=emit.thermostat_mode(),
      converter=converter.lookup_from_to({cool=0,heat=1,fanonly=2,dryair=3}),
    }),
    tuya.dp_current_heating_setpoint(16,{
      emit=emit.heating_setpoint("C"),
      converter=converter.from_to(function(value) return value/10 end,
      function(value)
        if type(value)=="number" and value%1==0 and value>=16 and value<=32 then return value*10 end
      end),
    }),
    tuya.dp_local_temperature(24,{read_only=true,scale=10,emit=emit.temperature("C")}),
    tuya.dp_binary(40,{
      name="bvrf_l001_child_lock",emit=emit.bvrfL001ChildLock(),
      converter=converter.lookup_from_to({LOCK=true,UNLOCK=false}),
    }),
    tuya.dp_enum(49,{
      name="bvrf_l001_fan_mode",emit=emit.bvrfL001FanMode(),
      converter=converter.lookup_from_to({auto=0,low=1,medium=2,high=3}),
    }),
  },
}
thermostat_metadata.attach(beca_bvrf_l001,{"cool","heat","fanonly","dryair"},16,32,1)
register_device_definition(beca_bvrf_l001,ef00_helpers.ts0601_fingerprints({"_TZE204_6ewjlefg"}))

local tervix_119710 = {
  profile = "thermostats-tervix-119710",
  package_group = "wall-2",
  magic_packet = true,
  mcu_version_request_on_configure = true,
  query_on_configure = false,
  query_on_announce = false,
  time_start = "1970",
  force_time_updates = true,
  datapoints = {
    tuya.dp_binary(1, {
      name = "system_mode", emit = emit.thermostat_mode(),
      converter = converter.lookup_from_to({ off = false, heat = true }),
    }),
    tuya.dp_enum(2, {
      name = "terv119_preset", emit = emit.terv119Preset(),
      converter = converter.lookup_from_to({ manual = 0, program = 1 }),
    }),
    tuya.dp_enum(3, {
      name = "terv119_backlight", emit = emit.terv119Backlight(),
      converter = converter.lookup_from_to({ OFF = 0, ON = 1 }),
    }),
    tuya.dp_humidity(8, { scale = 1, read_only = true, emit = emit.humidity() }),
    tuya.dp_battery(9, { read_only = true, emit = emit.battery() }),
    tuya.dp_local_temperature(16, {
      read_only = true, signed = true, emit = emit.temperature("C"),
      converter = converter.signed_number_pair(10),
    }),
    tuya.dp_enum(17, {
      name = "terv119_window_state", read_only = true, emit = emit.terv119WindowState(),
      converter = converter.lookup_from_to({ close = 0, open = 1 }),
    }),
    tuya.dp_local_temperature_calibration(27, {
      name = "terv119_temp_calibration", scale = 1, emit = emit.terv119TempCalibration(),
    }),
    tuya.dp_binary(29, {
      name = "terv119_window_detection", emit = emit.terv119WindowDetection(),
      converter = converter.lookup_from_to({ OFF = false, ON = true }),
    }),
    tuya.dp_binary(31, {
      name = "terv119_frost_protection", emit = emit.terv119FrostProtection(),
      converter = converter.lookup_from_to({ OFF = false, ON = true }),
    }),
    tuya.dp_binary(39, {
      name = "terv119_child_lock", emit = emit.terv119ChildLock(),
      converter = converter.lookup_from_to({ UNLOCK = false, LOCK = true }),
    }),
    tuya.dp_current_heating_setpoint(50, { scale = 10, emit = emit.heating_setpoint("C") }),
    tuya.dp_numeric(101, { name = "terv119_initial_valve", emit = emit.terv119InitialValve() }),
    tuya.dp_comfort_temperature(102, {
      name = "terv119_comfort_temp", scale = 10, emit = emit.terv119ComfortTemp(),
    }),
    tuya.dp_numeric(103, { name = "terv119_pid_p", emit = emit.terv119PidP() }),
    tuya.dp_numeric(104, {
      name = "terv119_valve_opening", read_only = true, emit = emit.terv119ValveOpening(),
    }),
    tuya.dp_eco_temperature(105, { name = "terv119_eco_temp", scale = 10, emit = emit.terv119EcoTemp() }),
    tuya.dp_numeric(106, { name = "terv119_window_detect_time", emit = emit.terv119WindowDetectTime() }),
    tuya.dp_numeric(107, {
      name = "terv119_window_temp_drop", converter = converter.divide_by_pair(10),
      emit = emit.terv119WindowTempDrop(),
    }),
    tuya.dp_numeric(108, { name = "terv119_window_delay", emit = emit.terv119WindowDelay() }),
    tuya.dp_numeric(109, { name = "terv119_boost_time", emit = emit.terv119BoostTime() }),
    tuya.dp_numeric(110, { name = "terv119_pid_i", emit = emit.terv119PidI() }),
    tuya.dp_numeric(111, { name = "terv119_trv_count", read_only = true, emit = emit.terv119TrvCount() }),
    tuya.dp_binary(112, {
      name = "terv119_quick_pair", emit = emit.terv119QuickPair(),
      converter = converter.lookup_from_to({ OFF = false, ON = true }),
    }),
    tuya.dp_binary(113, {
      name = "terv119_display_reversed", emit = emit.terv119DisplayReversed(),
      converter = converter.lookup_from_to({ OFF = false, ON = true }),
    }),
    tuya.dp_binary(115, {
      name = "terv119_humidity_control", emit = emit.terv119HumidityControl(),
      converter = converter.lookup_from_to({ OFF = false, ON = true }),
    }),
    tuya.dp_numeric(116, { name = "terv119_humidity_setpoint", emit = emit.terv119HumiditySetpoint() }),
    tuya.dp_running_state(118, {
      name = "running_state", read_only = true, emit = emit.thermostat_operating_state(),
      converter = converter.lookup_from_to({ idle = 0, heating = 1 }),
    }),
    tuya.dp_numeric(119, { name = "terv119_heat_today", read_only = true, emit = emit.terv119HeatToday() }),
    tuya.dp_numeric(120, { name = "terv119_heat_total", read_only = true, emit = emit.terv119HeatTotal() }),
    tuya.dp_numeric(121, { name = "terv119_heat_month", read_only = true, emit = emit.terv119HeatMonth() }),
  },
}
thermostat_metadata.attach(tervix_119710, { "off", "heat" }, 5, 35, 0.1)
register_device_definition(tervix_119710, ef00_helpers.ts0601_fingerprints({ "_TZE284_xr5yfele" }))

return {
  id = "ef00.thermostats.z2m_absorption_wall",
  registrations = device_definitions,
}
