# EF00 Sensors ST-SmartHome

A SmartThings Edge driver for Tuya EF00 (`TS0601`) sensors. It is a fork of
[wonjj6768's EF00 Sensors driver](https://github.com/wonjj6768/smartthings-zigbee-edge-drivers)
and supports every device the upstream driver does. On top of that it tidies up the
**7-in-1 pool water quality meter** (`_TZE200_v1jqz5cy` / `_TZE200_d9mzkhoq`, Zigbee2MQTT `BLE-YL01`,
sold under several brands).

## What's different from upstream

| Change | Why |
|---|---|
| **pH and free chlorine limits shown as decimals** | The meter stores these limits in tenths (DP106/107 pH, DP112/113 chlorine; Tuya spec scale 1). Upstream shows the raw number, so pH 7.8 appeared as "78 pH" and 3.0 mg/L as "30 mg/L". This driver divides by 10 when reading and multiplies by 10 (rounded) when writing, so the app shows 7.8 pH and 3.0 mg/L. |
| **Meters that use hundredths** | Some meters send these limits in hundredths instead (factory pH max 1400 rather than 140). A pH limit above 140 or a chlorine limit above 40 can only be hundredths, so the driver switches to hundredths for that meter and remembers it. Chlorine follows the pH format until the meter shows its own. Until a meter shows either format, tenths are used (the Tuya spec). |
| **Limits that are not set** | After a factory reset the meter reports some limits as −1 (raw 0xFFFFFFFF). These, and negative ORP limits, are shown as 0 so the reset is visible, instead of a huge or negative number. |
| **Steppers for the decimal limits** | The SmartThings app's slider always displays whole numbers, even with a 0.1 step, so 7.8 would still show as 8. The four decimal limits use a − / + stepper (0.1 per tap), which shows the decimal. Ranges are pH 0.0–14.0 and chlorine 0.0–4.0 mg/L. |
| **ORP limits** | DP110/111 are read as signed values, so −1 (not set) is recognised. The sliders run 0–1200 mV and values are rounded to 10 mV before they are sent. The meter measures −999 to +999 mV. |
| **Readable labels** | The limit and conductivity rows are labelled *pH Max*, *pH Min*, *Chlorine Max*, *Chlorine Min*, *EC Max*, *EC Min*, *ORP Max*, *ORP Min* and *Conductivity*, instead of "Yl Pool …". |
| **Backlight row hidden** | DP105 is toggled by the driver every 30 minutes as a keepalive (the meter stops reporting without it), so a manual control is of no use. The keepalive itself is unchanged. |

The readings (pH, ORP, free chlorine, salinity, TDS, temperature, battery) use upstream's capabilities
unchanged, so routines that use them keep working. All other devices behave exactly as they do upstream.

## Pool meter notes

- **Limits after switching drivers.** The meter only reports its limits when they change (or when it rejoins).
  A refresh doesn't return them. After switching an existing meter to this driver, the limit rows are empty
  or 0 until each one is set once. Setting a limit doesn't change the readings.
- **Limits are written to the meter.** Each change is sent to the meter, and the meter echoes it back
  within a few seconds. The values are stored in the meter.
- **The meter can reset its limits by itself.** One meter reported factory limits (pH 0–14, chlorine 0–4,
  ORP not set) without being re-paired. If the limit rows suddenly show 0 or the full range, set them again.
- **ORP slider steps.** The app's slider moves in 10 mV steps from the current value. The driver rounds to
  the nearest 10 mV, so after the first change every step lands on a multiple of 10.
- The new rows use capabilities in the `aboutisland47519` namespace (`poolPhMax`, `poolPhMin`,
  `poolChlorineMax`, `poolChlorineMin`, `poolEcMax`, `poolEcMin`, `poolOrpMaximum`, `poolOrpMinimum`,
  `poolConductivity`).

## Installing

1. Enroll your hub in the channel that hosts this driver, and install **EF00 Sensors ST-SmartHome**.
2. In the SmartThings app, open the meter → ⋮ → **Driver** → select **EF00 Sensors ST-SmartHome**.
   Newly paired meters may still pick another installed driver with the same fingerprint, so check which
   driver is in use after pairing.
3. Set each limit once (see above).

## Source layout

This package (`deploy/ef00-sensors-st-smarthome/`) is a copy of `deploy/ef00-sensors-wonjj6768/` with the
changes above. The upstream package is left untouched so the fork can keep syncing with upstream. Main changes:

- `src/runtime/capability_metadata.lua`: `capability_id()` accepts a fully qualified ID; the pool limit,
  EC, ORP and conductivity rows point at the new capabilities, with decimal and signed ranges
- `src/contracts/families/ef00/sensors/temp_humidity.lua`: `pool_limit_decimal()` converter on DP106/107/112/113
  (tenths or hundredths, learned per device; −1 shown as 0); `pool_orp_limit()` on DP110/111 (signed, negative shown as 0)
- `profiles/sensors-temp-battery-pool-chlorine.yml`: new capability IDs, limits grouped together (min before max), backlight
  removed from the detail view
- `config.yml`: package name and key
