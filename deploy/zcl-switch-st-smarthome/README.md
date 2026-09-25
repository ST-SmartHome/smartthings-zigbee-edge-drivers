# ZCL Switch ST-SmartHome

A SmartThings Edge driver for Zigbee switches, plugs, DIN-rail relays and valves.
It is a fork of [wonjj6768's ZCL Switch driver](https://github.com/wonjj6768/smartthings-zigbee-edge-drivers)
and supports every device the upstream driver does. On top of that it adds fixes for the
**Mercator Ikuü SPP02GIP IP54 double power point** (`TS011F` / `_TZ3210_7jnk7l3k`).

## What's different from upstream

| Change | Why |
|---|---|
| **Outlet 2 as its own device** (optional child device) | Upstream exposes outlet 2 only as a second component of one device. Alexa and Google Home only see a device's main switch, and the app's built-in device **Timer** only switches the main one, so outlet 2 couldn't be controlled from any of them. The child device is a plain switch that forwards to outlet 2 and mirrors its state. |
| **Correct energy (kWh)** | The SPP02GIP reports a bogus SimpleMetering multiplier/divisor pair (a 0x200010 ratio). Upstream trusts it, so energy showed as billions of kWh (for example 61.63 kWh displayed as 12,924,846,384 kWh). This driver always uses ÷100 for this plug, as Zigbee2MQTT does. |
| **Quieter voltage reporting** | Voltage now reports only on a change of 3 V or more, at most once a minute, with a heartbeat every 10 minutes. Upstream used 1 V / 5 s / 5 min, which flooded device history. |
| **Reconfigure on driver switch** | Switching a device to this driver re-applies its reporting configuration and marks it provisioned. The default handler did neither for this driver. |

All other devices behave exactly as they do upstream.

## Mercator SPP02GIP notes

- **One meter for the whole unit.** The plug has a single meter, on endpoint 1. Outlet 2's endpoint has no
  metering clusters at all. Power, energy, voltage and current therefore appear on the main device and
  measure the **total of both outlets**. No driver can split this per outlet.
- **Outlet 2 child device.** The setting *Outlet 2 as separate device* (on by default) creates a device named
  `<plug name> Outlet 2`. Turning the setting off removes it. The parent's `switch2` component keeps working
  either way, so existing routines that target it are unaffected.
- After switching an existing plug to this driver, point Alexa, Google Home and any timers at the new
  `Outlet 2` device (run device discovery in the Alexa app).

## Installing

1. Enroll your hub in the channel that hosts this driver, and install **ZCL Switch ST-SmartHome**.
2. In the SmartThings app, open the plug → ⋮ → **Driver** → select **ZCL Switch ST-SmartHome**.
   Newly paired plugs may still pick another installed driver with the same fingerprint, so check which
   driver is in use after pairing.

## Source layout

This package (`deploy/zcl-switch-st-smarthome/`) is a copy of `deploy/zcl-switch-wonjj6768/` with the
changes above. The upstream package is left untouched so the fork can keep syncing with upstream. Main changes:

- `src/app/child_outlets.lua`: new child-device module
- `src/app/driver.lua`: child lifecycle, command forwarding, `driverSwitched`
- `src/zcl_common/attribute_handler.lua`: mirrors outlet-2 switch state to the child
- `src/zcl_common/metering.lua`, `runtime.lua`, `cluster_mapping.lua`: the `ignore_reported_scaler` option
- `src/contracts/families/zcl/switches/switches.lua`, `src/contracts/helpers/zcl.lua`: the SPP02GIP definition
- `profiles/plugs-dual-metered-outage-children.yml`, `profiles/child-outlet.yml`: new profiles

## License

MIT, the same as upstream. See the repository `LICENSE` (Copyright (c) 2026 wonjj6768). The modifications
in this package are Copyright (c) 2026 ST-SmartHome, under the same license.
