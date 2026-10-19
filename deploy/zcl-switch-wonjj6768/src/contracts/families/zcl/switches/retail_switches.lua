local j = require "protocol.zcl"
local G = require "capabilities.events.all"
local t = require "contracts.helpers.family"
local e = t.create_fingerprint
local h = require "contracts.helpers.zcl"
local d = require "st.zigbee.data_types"
local A = require "st.capabilities"
local q = require "st.zigbee.device_management"
local V = require "st.zigbee.cluster_base"

local u, ai = t.definition_registry()

local function a(ab, am)
  ai(ab, am)
end

local function v(W, au)
  local y = {}
  for _, ay in ipairs(au) do
    y[#y + 1] = t.create_fingerprint(W, ay)
  end
  return y
end

local function b(aq, O)
  local F = {}
  for al, o in ipairs(O) do
    F[#F + 1] = j.switch({
      endpoint = o,
      component = al == 1 and "main" or ("switch" .. tostring(al)),
    })
  end
  return {
    profile = aq,
    zcl_clusters = F,
    configure = function(z, g)
      for _, o in ipairs(O) do
        g:send(q.build_bind_request(
          g,
          j.CLUSTER_ON_OFF,
          z.environment_info.hub_zigbee_eui,
          o
        ))
      end
    end,
  }
end

local s = b("switches-switch-1", { 1 })
local J = b("switches-switch-2", { 1, 2 })
local aC = b("switches-switch-3", { 1, 2, 3 })
local m = b("switches-switch-3-device-temperature", { 1, 2, 3 })
h.append_clusters(m.zcl_clusters,
  j.cluster_attribute(2, 0, {
    name = "device_temperature",
    endpoint = 1,
    emit = G.temperature("C"),
    data_type = d.Int16,
    read_on_configure = true,
  })
)
local r = m.configure
m.configure = function(z, g)
  r(z, g)
  g:send(q.build_bind_request(
    g,
    2,
    z.environment_info.hub_zigbee_eui,
    1
  ))
end
local Q = b("switches-switch-1", { 10 })
local R = b("switches-switch-2", { 10, 11 })
local S = b("switches-switch-3", { 10, 11, 12 })
local aj = b("switches-switch-4", { 1, 2, 3, 4 })
local Y = b("switches-switch-5", { 1, 2, 3, 4, 5 })
local w = b("switches-switch-5-tuya-options", { 1, 2, 3, 4, 5 })
h.append_clusters(w.zcl_clusters,
  j.tuya_magic_packet(),
  j.tuya_power_outage_memory(),
  j.child_lock()
)
local av = b("plugs-switch", { 1 })
local aw = b("plugs-switch-2", { 1, 2 })
local M = {
  profile = "switches-switch-1-battery",
  zcl_clusters = {
    j.switch(),
    j.battery(),
  },
}
local ac = {
  profile = "switches-switch-1-power-options",
  zcl_clusters = h.metering_clusters({
    include_switch = true,
    include_current = true,
  }),
}
local ah = {
  profile = "switches-switch-2-power-options",
  zcl_clusters = h.metering_clusters({
    include_switch = true,
    include_current = true,
  }),
}
local f = b("switches-switch-2-power-options", { 1, 2 })
for _, an in ipairs(h.metering_clusters({
  endpoint = 3,
  include_switch = false,
  include_current = true,
})) do
  f.zcl_clusters[#f.zcl_clusters + 1] = an
end

local function n(o, ae)
  return j.cluster_attribute(j.CLUSTER_ON_OFF, 16387, {
    name = "candeo_sm30_power_on_behavior",
    endpoint = o,
    component = ae,
    emit = G.candeoSm30PowerBehavior(),
    from_device = function(c)
      c = type(c) == "table" and c.value or c
      return ({ [0] = "off", [1] = "on", [255] = "previous" })[c]
    end,
    to_device = function(c)
      return ({ off = 0, on = 1, previous = 255 })[c]
    end,
    data_type = d.Enum8,
    write_type = d.Enum8,
    read_on_configure = true,
  })
end

f.profile = "switches-candeo-sm30-2g"
h.append_clusters(f.zcl_clusters,
  n(1, "main"),
  n(2, "switch2")
)
f.configure = function(z, g)
  for _, o in ipairs({ 1, 2 }) do
    g:send(q.build_bind_request(
      g,
      j.CLUSTER_ON_OFF,
      z.environment_info.hub_zigbee_eui,
      o
    ))
    g:send(V.configure_reporting(
      g,
      d.ClusterId(j.CLUSTER_ON_OFF),
      d.AttributeId(16387),
      d.ZigbeeDataType(d.Enum8.ID),
      0,
      65535,
      1
    ):to_endpoint(o))
  end
end
--[[
The retail metered-plug definition now belongs to the ZCL plugs catalog.
This seven-line spacer preserves the source locations of the remaining
SONOFF functions, keeping their bytecode identities stable after the move.
No plug registration or executable definition remains in this module.
The package ownership boundary is enforced by the focused catalog test.
]]
local i = 64529
local L = 4742
local D = "concertmirror08464.sonoffZbminir2"

local function C(c)
  return (c == true or c == 1) and "on" or "off"
end

local function H(c)
  return c == "on" or c == true
end

local function p(U, aB, af, x)
  x = x or {}
  return j.cluster_attribute(i, U, {
    name = aB,
    emit = G[af](),
    data_type = x.data_type or d.Boolean,
    write_type = x.write_type or d.Boolean,
    from_device = x.from_device or C,
    to_device = x.to_device or H,
    read_on_configure = true,
  })
end

local function k(g, suffix, ap)
  local P = D .. suffix
  local ad = suffix:sub(1, 1):lower() .. suffix:sub(2)
  return g:get_latest_state("main", P, ad) or ap
end

local function l(g, N, c, ao)
  local Z = k(g, "InchingControl", "off")
  local ak = tonumber(k(g, "InchingTime", 0.5)) or 0.5
  local at = k(g, "InchingMode", "off")

  if N.name == "sonoff_zbmini_r2_inching_control" then
    Z = c
  elseif N.name == "sonoff_zbmini_r2_inching_time" then
    ak = tonumber(c) or ak
  elseif N.name == "sonoff_zbmini_r2_inching_mode" then
    at = c
  end

  local B = math.floor((math.max(0.5, math.min(3599.5, ak)) * 2) + 0.5)
  local ag = (Z == "on" and 128 or 0) + (at == "on" and 1 or 0)
  local T = { 1, 23, 7, 128, ag, 0, B % 256, math.floor(B / 256), 0, 0 }
  local E = 0
  for _, aA in ipairs(T) do E = bit32.bxor(E, aA) end
  T[#T + 1] = E

  return j.send_raw_cluster_command(
    g,
    i,
    1,
    string.char(table.unpack(T)),
    ao.endpoint,
    nil,
    L
  )
end

local I = {
  profile = "switches-switch-1-sonoff-zbmini-r2",
  zcl_clusters = {
    j.switch(),
    j.cluster_attribute(j.CLUSTER_ON_OFF, 16387, {
      name = "sonoff_zbmini_r2_power_on_behavior",
      emit = G.sonoffZbminir2PowerOnBehavior(),
      data_type = d.Enum8,
      write_type = d.Enum8,
      from_device = function(c)
        return ({ [0] = "off", [1] = "on", [2] = "toggle", [255] = "previous" })[c]
      end,
      to_device = function(c)
        return ({ off = 0, on = 1, toggle = 2, previous = 255 })[c]
      end,
      read_on_configure = true,
    }),
    j.cluster_attribute(j.CLUSTER_ON_OFF, j.ATTR_ON_OFF, {
      name = "sonoff_zbmini_r2_toggle",
      emit = G.switch(),
      read_only = true,
      command_id = 2,
      command_extractor = function(_, g)
        return g:get_latest_state("main", A.switch.ID, "switch") ~= "on"
      end,
    }),
    p(1, "sonoff_zbmini_r2_network_indicator", "sonoffZbminir2NetworkIndicator"),
    p(18, "sonoff_zbmini_r2_turbo_mode", "sonoffZbminir2TurboMode", {
      data_type = d.Int16,
      write_type = d.Int16,
      from_device = function(c) return c == 20 and "on" or "off" end,
      to_device = function(c) return c == "on" and 20 or 9 end,
    }),
    p(20, "sonoff_zbmini_r2_delayed_power_on_state", "sonoffZbminir2DelayPowerState"),
    j.cluster_attribute(i, 21, {
      name = "sonoff_zbmini_r2_delayed_power_on_time",
      emit = G.sonoffZbminir2DelayPowerTime(),
      data_type = d.Uint16,
      write_type = d.Uint16,
      from_device = function(c) return c / 2 end,
      to_device = function(c) return c * 2 end,
      numeric_range = { minimum = 0.5, maximum = 3599.5, step = 0.5, unit = "s" },
      read_on_configure = true,
    }),
    p(23, "sonoff_zbmini_r2_detach_relay_mode", "sonoffZbminir2DetachRelayMode"),
    j.cluster_attribute(i, 22, {
      name = "sonoff_zbmini_r2_external_trigger_mode",
      emit = G.sonoffZbminir2ExtTriggerMode(),
      data_type = d.Uint8,
      write_type = d.Uint8,
      from_device = function(c) return ({ [0] = "edge", [1] = "pulse", [2] = "following_off", [130] = "following_on" })[c] end,
      to_device = function(c) return ({ edge = 0, pulse = 1, following_off = 2, following_on = 130 })[c] end,
      read_on_configure = true,
    }),
    j.cluster_attribute(i, nil, { name = "sonoff_zbmini_r2_inching_control", write_only = true, sender = l }),
    j.cluster_attribute(i, nil, { name = "sonoff_zbmini_r2_inching_time", write_only = true, sender = l }),
    j.cluster_attribute(i, nil, { name = "sonoff_zbmini_r2_inching_mode", write_only = true, sender = l }),
  },
}

local K = {
  profile = "buttons-zunzunbee-sswz8t",
  button_actions = { "pushed", "held" },
  zcl_clusters = {
    j.cluster_attribute(j.CLUSTER_IAS_ZONE, j.ATTR_ZONE_STATUS, {
      name = "zunzunbee_button_action",
      endpoint = 1,
      read_only = true,
      read_on_refresh = false,
      data_type = d.Bitmap16,
      command_id = 0,
      command_extractor = function(az)
        local ar = az.body.zcl_body
        local X = ar.zone_status or ar.zonestatus
        return type(X) == "table" and X.value or X
      end,
      from_device = function(c)
        c = type(c) == "table" and c.value or c
        local button = ({ [2] = 1, [4] = 2, [8] = 3, [16] = 4,
          [32] = 5, [64] = 6, [128] = 7, [256] = 8 })[bit32.band(c, 510)]
        if button == nil then return nil end
        return { component = "button" .. button, action = c % 2 == 1 and "held" or "pushed" }
      end,
      handler = function(g, aa)
        g:emit_component_event(
          { id = aa.component },
          A.button.button(aa.action, { state_change = true })
        )
        j.schedule_battery_refresh_after_button(g)
      end,
    }),
    j.battery({ endpoint = 1, minimum_interval = 3600, maximum_interval = 65000, reportable_change = 10 }),
    j.temperature({ endpoint = 1, minimum_interval = 10, maximum_interval = 3600, reportable_change = 100 }),
  },
}

a(av, {
  e("Third Reality", "3RSP0186Z"),
  e("Third Reality", "3RSPJ0187Z"),
  e("Third Reality", "3RSPE02065Z"),
  e("Third Reality", "3RSPU01080Z"),
})

a(aw, {
  e("Third Reality", "3RWP01073Z"),
})

a(M, {
  e("Third Reality, Inc", "3RSS009Z"),
  e("Third Reality, Inc", "3RSS008Z"),
})

a(s, {
  e("Third Reality, Inc", "3RSS007Z"),
})

a(I, {
  e("SONOFF", "MINI-ZBD"),
  e("SONOFF", "ZBMINIR2"),
})

a(f, {
  e("Candeo", "C-ZB-SM30-2G"),
})

a(s, {
  e("Candeo", "C205"),
  e("IKEA", "E2006"),
})

a(s, {
  e("HEIMAN", "HS2SW1A-EF-3.0"),
  e("HEIMAN", "HS2SW1A-EFR-3.0"),
})

a(s, {
  e("KlikAanKlikUit", "Built-in Switch"),
  e("Oz Smart Things", "WSP403"),
  e("Sibling", "Powerswitch-ZK(W)"),
  e("Sunricher", "SR-ZG9101SAC-HP-SWITCH-B"),
  e("BTicino", "3584C"),
  e("BTicino", "3577C"),
  e("BTicino", "FC80AC"),
  e("BTicino", "FC80CC"),
  e("BTicino", "FC80RC"),
  e("BTicino", "LN4570CWI"),
  e("Elko", "EKO07250"),
  e("Elko", "EKO07251"),
  e("Elko", "EKO07252"),
  e("Elko", "EKO07253"),
  e("Elko", "EKO20004"),
  e("Elko", "EKO30198"),
  e("Elko", "EKO30199"),
  e("Gira", "2430-100"),
  e("Gira", "2435-10"),
  e("Jung", "ZLLHS4"),
  e("Legrand", "199142"),
  e("Sunricher", "SR-ZG9100A-S"),
})

a(s, {
  e("Schneider Electric", "1GANG/SWITCH/1"),
  e("Schneider Electric", "CH10AX/SWITCH/1"),
  e("Schneider Electric", "CH2AX/SWITCH/1"),
  e("Schneider Electric", "NHPB/SWITCH/1"),
  e("Schneider Electric", "PUCK/SWITCH/1"),
  e("Schneider Electric", "U201SRY2KWZB"),
})

a(s, {
  e("TERNCY", "TERNCY-LS01"),
})

a(Q, {
  e("Schneider Electric", "A3N31SR800ZB_xx_C1"),
  e("Schneider Electric", "E8331SRY800ZB"),
})

a(R, {
  e("Schneider Electric", "A3N32SR800ZB_xx_C1"),
  e("Schneider Electric", "E8332SRY800ZB"),
})

a(S, {
  e("Schneider Electric", "A3N33SR800ZB_xx_C1"),
  e("Schneider Electric", "E8333SRY800ZB"),
})

a(s, v("Sunricher", {
  "ON/OFF",
  "ZIGBEE-SWITCH",
  "Micro Smart OnOff",
  "HK-SL-RELAY-A",
}))

a(J, {
  e("Candeo", "C-ZB-SM205-2G"),
})

a(J, {
  e("HEIMAN", "HS2SW2A-EF-3.0"),
  e("HEIMAN", "HS2SW2A-EFR-3.0"),
})

a(J, {
  e("LED-Trading", "UP-SA-9127D"),
  e("Sunricher", "ON/OFF(2CH)"),
  e("Sunricher", "SR-ZG9101SAC-HP-SWITCH-2CH"),
})

a(m, {
  e("HEIMAN", "HS2SW3A-EF-3.0"),
  e("HEIMAN", "HS2SW3A-EFR-3.0"),
})

a(aj, {
  e("Nova Digital", "TPZ-4"),
  e("Tuya", "DS-111"),
  e("MHCOZY", "TYWB 4ch-RF"),
  e("AVATTO", "TS0004_1"),
  e("AVATTO", "ZBTS60-04"),
  e("RSH", "SB04-Zigbee"),
  e("AVATTO", "ZWSM16-4"),
  e("Moes", "ZM4LT4"),
  e("iHseno", "_TZ3000_knoj8lpk"),
  e("AVATTO", "ZWOT12"),
  e("Coibeu", "ZB414"),
  e("Nova Digital", "SA-4"),
  e("Mercator Ikuü", "SSW04"),
  e("OXT", "SWTZ27"),
  e("TUYATEC", "GDKES-04TZXD"),
  e("MakeGood", "MG-ZG04W/B/G"),
  e("TERNCY", "TERNCY-WS01-S4"),
  e("_TZ3210_qjvi92wz", "TS0014"),
  e("_TZ3210_w3hl6rao", "TS0014"),
  e("_TZ3210_z4hgsevd", "TS0014"),
  e("Vizo", "VZ-221S"),
  e("Vizo", "VZ-222S"),
  e("Vizo", "VZ-223S"),
  e("LELLKI", "WP33-EU"),
})

a(Y, {
  e("Sunricher", "SR-ZG9023A-EU"),
})

a(K, {
  e("zunzunbee", "SSWZ8T"),
})

-- ZCL REPORTING CAPABILITIES BEGIN
j.attach_reporting_capabilities(u, {
  {1, "rpt-zvs"},
  {2, "rpt-zef", {["zr000600001"] = "Switch", ["zr000600002"] = "SwitchTwo"}},
  {3, "rpt-zej"},
  {4, "rpt-sit"},
  {5, "rpt-mcf"},
  {6, "rpt-cba", {["zr000600001"] = "Switch", ["zr000600002"] = "SwitchTwo"}},
  {7, "rpt-sit"},
  {8, "rpt-sit"},
  {9, "rpt-sit"},
  {10, "rpt-sit"},
  {11, "rpt-sit"},
  {12, "rpt-sit"},
  {13, "rpt-lpm", {["zr0006000010"] = "Switch", ["zr0006000011"] = "SwitchTwo"}},
  {14, "rpt-lek", {["zr0006000010"] = "Switch", ["zr0006000011"] = "SwitchTwo", ["zr0006000012"] = "SwitchThree"}},
  {15, "rpt-sit"},
  {16, "rpt-lpm", {["zr000600001"] = "Switch", ["zr000600002"] = "SwitchTwo"}},
  {17, "rpt-lpm", {["zr000600001"] = "Switch", ["zr000600002"] = "SwitchTwo"}},
  {18, "rpt-lpm", {["zr000600001"] = "Switch", ["zr000600002"] = "SwitchTwo"}},
  {19, "rpt-hns", {["zr000600001"] = "Switch", ["zr000600002"] = "SwitchTwo", ["zr000600003"] = "SwitchThree"}},
  {20, "rpt-tmr", {["zr000600001"] = "Switch", ["zr000600002"] = "SwitchTwo", ["zr000600003"] = "SwitchThree", ["zr000600004"] = "SwitchFour"}},
  {21, "rpt-swt", {["zr000600001"] = "Switch", ["zr000600002"] = "SwitchTwo", ["zr000600003"] = "SwitchThree", ["zr000600004"] = "SwitchFour", ["zr000600005"] = "SwitchFive"}},
  {22, "rpt-sfh"},
})
-- ZCL REPORTING CAPABILITIES END

return {
  id = "zcl.switches.retail_switches",
  registrations = u,
}
