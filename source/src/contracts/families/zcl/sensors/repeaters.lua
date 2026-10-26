local device_helpers = require "contracts.helpers.family"
local fps = device_helpers.create_fingerprints
local fp = device_helpers.create_fingerprint

local device_definitions, register = device_helpers.definition_registry()

local repeater = {
  profile = "network-repeater",
}

register(repeater, fps("TS0207", {
  "_TZ3000_5k5vh43t",
  "_TZ3000_gszjt2xx",
  "_TZ3000_kxlmv9ag",
  "_TZ3000_m0vaazab",
  "_TZ3000_misw04hq",
  "_TZ3000_n0lphcok",
  "_TZ3000_nkkl7uzv",
  "_TZ3000_nlsszmzl",
  "_TZ3000_r80pzsb9",
  "_TZ3000_sgpbz53b",
  "_TZ3000_shopg9ss",
  "_TZ3000_ufttklsz",
  "_TZ3000_hgm6k8ku",
  "_TZ3000_mmzmkkd4",
  "_TZ3000_piuensvr",
  "_TZ3000_wlquqiiz",
  "_TZ3000_wmlc9p9z",
}))

register(repeater, fps("TS0001", {
  "_TZ3000_gdsvhfao",
  "_TZ3000_n0lphcok",
  "_TZ3000_trdx8uxs",
  "_TZ3000_wn65ixz9",
}))

register(repeater, {
  fp("Aeotec", "ZGA008"),
  fp("eWeLink", "CK-BL702-ROUTER-01(7018)"),
  fp("Espressif", "ZigbeeRangeExtender"),
  fp("NabuCasa", "SkyConnect"),
  fp("NabuCasa", "ZBT-2"),
  fp("SMLIGHT", "SLZB-06M"),
  fp("SMLIGHT", "SLZB-06MU"),
  fp("SMLIGHT", "SLZB-06MG24"),
  fp("SMLIGHT", "SLZB-06MG24U"),
  fp("SMLIGHT", "SLZB-06MG26"),
  fp("SMLIGHT", "SLZB-06MG26U"),
  fp("SMLIGHT", "SLZB-07"),
  fp("SMLIGHT", "SLZB-07MG24"),
  fp("SMLIGHT", "SLZB-MR1U"),
  fp("SMLIGHT", "SLZB-MR2U"),
  fp("SMLIGHT", "SLZB-MR3U"),
  fp("SMLIGHT", "SLZB-MR4U"),
  fp("SMLIGHT", "SLZB-MR5U"),
  fp("Inswift", "ZBM-MG24"),
  fp("SONOFF", "DONGLE-E"),
  fp("SONOFF", "Dongle-LMG21"),
  fp("SONOFF", "Dongle-M"),
  fp("SONOFF", "Dongle-PMG24"),
  fp("SparkFun", "MGM240P"),
  fp("TubesZB", "BM24"),
  fp("TubesZB", "MGM24"),
  fp("easyiot", "ZB-GW04"),
  fp("easyiot", "ZB-GW04-1v1"),
  fp("easyiot", "ZB-GW04-1v2"),
})

return {
  id = "zcl.sensors.repeaters",
  registrations = device_definitions,
}
