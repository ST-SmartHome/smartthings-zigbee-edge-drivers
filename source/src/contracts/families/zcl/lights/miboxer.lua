local zcl = require "protocol.zcl"
local device_helpers = require "contracts.helpers.family"

local device_definitions, register_device_definition = device_helpers.definition_registry()



local rgb_controller = {
  profile = "lights-color",
  zcl_clusters = {
    zcl.switch(),
    zcl.level(),
    zcl.color_hue(),
    zcl.color_saturation(),
    zcl.color(),
  },
}


register_device_definition(rgb_controller, {
  device_helpers.create_fingerprint("_TZ3210_778drfdt", "TS0503B"),
})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(device_definitions, {
  {1, "rpt-tot"},
})
-- ZCL REPORTING CAPABILITIES END

return {
  id = "zcl.lights.miboxer",
  registrations = device_definitions,
}
