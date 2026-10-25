local zcl = require "protocol.zcl"
local emit = require "capabilities.events.all"
local device_helpers = require "contracts.helpers.family"
local shelly = require "contracts.helpers.shelly_gen4"
local device_management = require "st.zigbee.device_management"
local data_types = require "st.zigbee.data_types"

local device_definitions, register_device_definition = device_helpers.definition_registry()

local function clamp_smartthings_numeric(value)
  if type(value) ~= "number" then return value end
  return math.max(0, math.min(2147483647, value))
end

local function bind(driver, device, endpoint, cluster_id)
  device:send(device_management.build_bind_request(
    device,
    cluster_id,
    driver.environment_info.hub_zigbee_eui,
    endpoint
  ))
end

local clusters = {
  zcl.switch({
    endpoint = 1,
    minimum_interval = 0,
    maximum_interval = 65000,
    read_on_configure = true,
  }),
}

for channel = 2, 3 do
  local component = "meter" .. tostring(channel)
  for _, mapping in ipairs({
    zcl.power({
      endpoint = channel, component = component,
      minimum_interval = 10, maximum_interval = 65000, physical_reportable_change = 5,
      read_on_configure = true,
    }),
    zcl.voltage({
      endpoint = channel, component = component,
      minimum_interval = 10, maximum_interval = 65000, physical_reportable_change = 5,
      read_on_configure = true,
    }),
    zcl.current({
      endpoint = channel, component = component,
      minimum_interval = 10, maximum_interval = 65000, physical_reportable_change = 0.05,
      read_on_configure = true,
    }),
    zcl.energy({
      endpoint = channel, component = component,
      minimum_interval = 10, maximum_interval = 65000, physical_reportable_change = 0.1,
      read_on_configure = true,
    }),
    zcl.cluster_attribute(zcl.CLUSTER_SIMPLE_METERING, 0x0001, {
      name = "shelly_em_produced_energy_" .. tostring(channel),
      endpoint = channel,
      component = component,
      emit = (channel == 2 and emit.shellyEmProducedEnergyTwo or emit.shellyEmProducedEnergyThree)(),
      data_type = data_types.Uint48,
      metering_kind = "energy",
      from_device = clamp_smartthings_numeric,
      minimum_interval = 10,
      maximum_interval = 65000,
      physical_reportable_change = 0.1,
      read_on_configure = true,
    }),
    zcl.cluster_attribute(zcl.CLUSTER_ELECTRICAL_MEASUREMENT, 0x0300, {
      name = "shelly_em_ac_frequency_" .. tostring(channel),
      endpoint = channel,
      component = component,
      emit = (channel == 2 and emit.shellyEmAcFrequencyTwo or emit.shellyEmAcFrequencyThree)(),
      data_type = data_types.Uint16,
      metering_kind = "frequency",
      minimum_interval = 10,
      maximum_interval = 65000,
      physical_reportable_change = 1,
      read_on_configure = true,
    }),
  }) do
    clusters[#clusters + 1] = mapping
  end
end

shelly.append_wifi_mappings(clusters, "shelly_em", "shellyEm")

local shelly_em = {
  profile = "switches-shelly-em-gen4",
  zcl_clusters = clusters,
  zcl_refresh_before_read_all = shelly.begin_wifi_refresh,
  configure = function(driver, device)
    bind(driver, device, 1, zcl.CLUSTER_ON_OFF)
    for _, endpoint in ipairs({ 2, 3 }) do
      bind(driver, device, endpoint, zcl.CLUSTER_ELECTRICAL_MEASUREMENT)
      bind(driver, device, endpoint, zcl.CLUSTER_SIMPLE_METERING)
    end
    shelly.refresh_wifi(device)
  end,
}

register_device_definition(shelly_em, {
  device_helpers.create_fingerprint("Shelly", "EM"),
})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(device_definitions, {
  {1, "rpt-eqx", {zr070200002 = "Energy", zr070200003 = "EnergyTwo", zr070200012 = "Export", zr070200013 = "ExportTwo", zr0b0403002 = "Frequency", zr0b0403003 = "FrequencyTwo", zr0b0405052 = "Voltage", zr0b0405053 = "VoltageTwo", zr0b0405082 = "Current", zr0b0405083 = "CurrentTwo", zr0b04050b2 = "Power", zr0b04050b3 = "PowerTwo"}},
})
-- ZCL REPORTING CAPABILITIES END

return {
  id = "zcl.switches.shelly_em",
  registrations = device_definitions,
}
