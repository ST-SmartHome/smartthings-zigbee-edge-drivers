# ZCL Switch ST-SmartHome

A SmartThings Edge driver for Zigbee switches, plugs, DIN-rail relays and valves.
It is a fork of [wonjj6768's ZCL Switch driver](https://github.com/wonjj6768/smartthings-zigbee-edge-drivers)
and supports every device the upstream driver does. On top of that it adds fixes for the
**Mercator Ikuü SPP02GIP IP54 double power point** (`TS011F` / `_TZ3210_7jnk7l3k`).

## What's different from upstream

| Change | Why |
|---|---|
| **Outlet 2 as its own device** (optional child device) | Upstream exposes outlet 2 only as a second component of one device. Alexa and Google Home only see a device's main switch, so outlet 2 couldn't be controlled from either of them. The child device is a plain switch that forwards to outlet 2 and mirrors its state. |
| **Correct energy (kWh)** | The SPP02GIP reports a bogus SimpleMetering multiplier/divisor pair (a 0x200010 ratio). Upstream trusts it, so energy showed as billions of kWh (for example 61.63 kWh displayed as 12,924,846,384 kWh). This driver always uses ÷100 for this plug, as Zigbee2MQTT does. |
| **Quieter, adjustable reporting** | Defaults: voltage on a 3 V change (at most once a minute), power on 5 W (the SmartThings default), current on 50 mA (Zigbee2MQTT's value for this plug), each with a 10-minute heartbeat. Upstream reported every 1 W / 1 mA / 1 V, up to every 5 s, which flooded device history. The thresholds and the minimum interval are adjustable in device Settings. The SPP02GIP firmware ignores the configured change threshold, so the driver also applies it itself: a reading within the threshold of the last one shown is dropped, except for a 10-minute heartbeat. |
| **Per-outlet Auto Off Timer** | An *Auto Off Timer* control (minutes, 0–720) on each outlet and on the Outlet 2 device, also usable in routines. Setting it turns the outlet on, and the plug itself turns it off again after that time, so the timer keeps running if the hub restarts. (Upstream's seconds-based countdown mapping sends a raw payload that the SmartThings SDK rejects, so it never reaches the plug: wonjj6768/smartthings-zigbee-edge-drivers#29.) |
| **No "Last Power Response Time" tile** | Upstream shows it as text, and Edge drivers only know UTC (they can't read the location's time zone), so it displayed the wrong time. The app's History tab shows the same report times, in local time. |
| **Reconfigure on driver switch** | Switching a device to this driver re-applies its reporting configuration and marks it provisioned. The default handler did neither for this driver. |

All other devices behave exactly as they do upstream.

## Mercator SPP02GIP notes

- **One meter for the whole unit.** The plug has a single meter, on endpoint 1. Outlet 2's endpoint has no
  metering clusters at all. Power, energy, voltage and current therefore appear on the main device and
  measure the **total of both outlets**. No driver can split this per outlet.
- **Outlet 2 child device.** The setting *Outlet 2 as separate device* (on by default) creates a device named
  `<plug name> Outlet 2`. Turning the setting off removes it. The parent's `switch2` component keeps working
  either way, so existing routines that target it are unaffected.
- **Reporting settings** (device → ⋮ → Settings): *Power report threshold* (1–100 W, default 5),
  *Current report threshold* (10–1000 mA, default 50), *Voltage report threshold* (1–20 V, default 3) and
  *Minimum report interval* for power and current (1–300 s, default 5). Changes are sent to the plug immediately.
- **Auto Off Timer.** Each outlet has an *Auto Off Timer* (0–720 minutes, i.e. up to 12 h), also on the Outlet 2
  device and in routine actions. Setting a value turns the outlet on and starts the countdown in the plug
  (`OnWithTimedOff`); the plug reports the off itself. Setting it again restarts the countdown, and setting 0 or
  switching the outlet off cancels it. The SPP02GIP counts `OnWithTimedOff` in whole seconds (the ZCL spec says
  tenths). The tile shows the time last set, not the time remaining: the plug's `onTime` attribute doesn't track
  it (it reports 0 mid-countdown). It returns to 0 when the outlet turns off. The app's own Timer is separate and
  run by SmartThings, not the plug The timer starts at 0 (no countdown) on every outlet, so its slider works on a newly paired plug too.
- After switching an existing plug to this driver, point Alexa and Google Home at the new
  `Outlet 2` device (run device discovery in the Alexa app).

## Installing

1. Enroll your hub in the channel that hosts this driver, and install **ZCL Switch ST-SmartHome**.
2. In the SmartThings app, open the plug → ⋮ → **Driver** → select **ZCL Switch ST-SmartHome**.
   Newly paired plugs may still pick another installed driver with the same fingerprint, so check which
   driver is in use after pairing.

## Source layout

This package (`deploy/zcl-switch-st-smarthome/`) is a copy of `deploy/zcl-switch-wonjj6768/` with the
changes above. The upstream package is left untouched so the fork can keep syncing with upstream. Main changes:

- `src/app/child_outlets.lua`: new child-device module (mirrors switch and Auto Off Timer to the child)
- `src/app/outlet_countdown.lua`: the Auto Off Timer handler (`OnWithTimedOff` with typed arguments)
- `src/app/driver.lua`: child lifecycle, command forwarding (switch, refresh, Auto Off Timer), `driverSwitched`
- `src/zcl_common/attribute_handler.lua`: mirrors outlet-2 switch state to the child, and applies the reporting deadband (the SPP02GIP ignores its configured change thresholds)
- `src/zcl_common/metering.lua`, `runtime.lua`, `cluster_mapping.lua`: the `ignore_reported_scaler` option
- `src/zcl_common/configuration.lua`: per-device preference overrides for reporting thresholds
- `src/contracts/families/zcl/switches/switches.lua`, `src/contracts/helpers/zcl.lua`: the SPP02GIP definition
- `profiles/plugs-dual-metered-outage-children.yml`, `profiles/child-outlet.yml`: new profiles

## License

MIT, the same as upstream. See the repository `LICENSE` (Copyright (c) 2026 wonjj6768). The modifications
in this package are Copyright (c) 2026 ST-SmartHome, under the same license.
