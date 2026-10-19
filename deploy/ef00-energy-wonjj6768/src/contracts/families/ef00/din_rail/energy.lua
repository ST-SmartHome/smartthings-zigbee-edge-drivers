local a=require"protocol.tuya"
local b=require"capabilities.events.all"
local e=require"contracts.helpers.family"
local A=require"contracts.helpers.ef00_din_rail"
local z,c=e.definition_registry()local d=a.converter
local f=A.emit_metric_bundle
local h=A.circuit_breaker_faults_converter
local s=A.BREAKER_EVENT_LOOKUP
local C=b.voltage()local B=b.current()local D=b.power()local g={ignore=0,alarm=1,trip=2}local i={closed=0,alarm=1,trip=2}local l={
profile="din-rail-switch-power-energy-voltage-current-din1",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_phase_variant1(6,{
emit=f({voltage=true,current=true}),}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_numeric(101,{
name="total_energy",scale=100,read_only=true,emit=b.din1TotalEnergy(),}),a.dp_energy(102,{name="produced_energy",scale=100,emit=b.producedEnergyDin()}),a.dp_power(103,{emit=b.power()}),a.dp_ac_frequency(105,{
scale=100,read_only=true,emit=b.din1AcFrequency(),}),a.dp_numeric(109,{
name="energy_reactive",scale=100,read_only=true,emit=b.din1EnergyReactive(),}),a.dp_numeric(110,{name="power_reactive",emit=b.reactivePowerDin1()}),a.dp_power_factor(111,{
scale=10,read_only=true,emit=b.din1PowerFactor(),}),a.dp_numeric(9,{
name="faults",read_only=true,emit=b.din1Faults(),converter=h,}),a.dp_raw(17,{name="alarm_set_1"}),a.dp_raw(18,{name="alarm_set_2"}),}c(l,e.create_fingerprints("TS0601",{
"_TZE200_bkkmqmyo","_TZE200_eaac7dkw","_TZE204_bkkmqmyo",}))c(l,{
e.create_fingerprint("Hiking","DDS238-2"),e.create_fingerprint("Tuya","RC-MCB"),})local m={
profile="din-rail-switch-power-energy-voltage-current-din2",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_numeric(3,{name="monthly_energy"}),a.dp_numeric(4,{name="daily_energy"}),a.dp_phase_variant2(6,{
emit=f({voltage=true,current=true,power=true}),}),a.dp_enum(10,{
name="fault",read_only=true,emit=b.din2Fault(),converter=d.from_only(d.lookup_value({
[0]="clear",[1]="over_current_threshold",[2]="over_power_threshold",[4]="over_voltage_threshold",[8]="wrong_frequency_threshold",})),}),a.dp_raw(11,{name="frozen"}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_threshold(17,{}),a.dp_string(18,{
name="meter_id",read_only=true,emit=b.din2MeterId(),}),a.dp_on_off(20,{
name="clear_fault",emit=b.clearFaultDin2(),converter=d.lookup_from_to({on=true,off=false}),}),a.dp_numeric(21,{name="forward_energy_t1"}),a.dp_numeric(22,{name="forward_energy_t2"}),a.dp_numeric(23,{name="forward_energy_t3"}),a.dp_numeric(24,{name="forward_energy_t4"}),}c(m,e.create_fingerprints("TS0601",{
"_TZE200_lsanae15","_TZE204_l6llgoxq","_TZE204_lsanae15",}))c(m,{
e.create_fingerprint("MatSee Plus","DAC2161C"),})local n={
profile="din-rail-switch-power-energy-voltage-current-din3",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_energy(2,{name="produced_energy",scale=100,emit=b.producedEnergyDin()}),a.dp_numeric(3,{name="monthly_energy"}),a.dp_numeric(4,{name="daily_energy"}),a.dp_phase_variant2(6,{
emit=f({voltage=true,current=true,power=true}),}),a.dp_enum(10,{
name="fault",read_only=true,emit=b.din3Fault(),converter=d.from_only(d.lookup_value({
[0]="clear",[1]="over_current_threshold",[2]="over_power_threshold",[4]="over_voltage_threshold",[8]="wrong_frequency_threshold",})),}),a.dp_raw(11,{name="frozen"}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_threshold(17,{}),a.dp_string(18,{
name="meter_id",read_only=true,emit=b.din3MeterId(),}),a.dp_on_off(20,{
name="clear_fault",emit=b.clearFaultDin3(),converter=d.lookup_from_to({on=true,off=false}),}),a.dp_numeric(21,{name="forward_energy_t1"}),a.dp_numeric(22,{name="forward_energy_t2"}),a.dp_numeric(23,{name="forward_energy_t3"}),a.dp_numeric(24,{name="forward_energy_t4"}),}c(n,e.create_fingerprints("TS0601",{
"_TZE200_rhblgy0z","_TZE204_rhblgy0z",}))c(n,{
e.create_fingerprint("XOCA","DAC2161C"),})local r={
package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_phase_variant2(6,{
emit=f({voltage=true,current=true,power=true}),}),a.dp_on_off(16,{name="switch",emit=b.switch()}),}c(r,e.create_fingerprints("TS0601",{
"_TZE200_byzdayie","_TZE200_ewxhg6o9","_TZE200_fsb6zw01",}))local u={
profile="din-rail-switch-power-energy-voltage-current-din4",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_phase_variant2(6,{
emit=f({voltage=true,current=true,power=true}),}),a.dp_numeric(9,{
name="faults",read_only=true,emit=b.din4Faults(),converter=h,}),a.dp_binary(12,{
name="clear_energy",emit=b.din4ClearEnergy(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_numeric(15,{
name="leakage",read_only=true,emit=b.din4Leakage(),}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_numeric(102,{
name="reclosing_allowed_times",emit=b.din4ReclosingTimes(),}),a.dp_temperature(103,{
name="temperature",scale=1,read_only=true,emit=b.din4Temperature(),}),a.dp_binary(104,{
name="reclosing_enable",emit=b.din4ReclosingEnable(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_numeric(105,{name="timer",emit=b.din4Timer()}),a.dp_enum(127,{
name="status",read_only=true,emit=b.din4Status(),converter=d.from_only(d.lookup_value({
[0]="standby",[1]="active",})),}),a.dp_power_on_behavior(134,{emit=b.din4PowerOnBehavior()}),}c(u,e.create_fingerprints("TS0601",{
"_TZE200_abatw3kj","_TZE204_4bjixefp","_TZE204_fhvdgeuh",}))local q={
profile="din-rail-switch-power-energy-voltage-current-leakage-protector",package_group="energy",query_on_configure=true,named_datapoints=true,datapoints={
a.dp_on_off(1,{name="switch",component="main",emit=b.switch()}),a.dp_energy(17,{emit=b.energy(),scale=100}),a.dp_current(18,{emit=b.current(),scale=100}),a.dp_power(19,{emit=b.power(),scale=10}),a.dp_voltage(20,{emit=b.voltage(),scale=10}),a.dp_numeric(9,{
name="faults",read_only=true,emit=b.smkg2knlFaults(),converter=h,}),a.dp_numeric(41,{name="leakage_threshold",emit=b.leakageThresholdProtector100ma()}),a.dp_numeric(42,{name="over_voltage_threshold",emit=b.smkg2knlOverVoltageThreshold()}),a.dp_numeric(43,{name="under_voltage_threshold",emit=b.smkg2knlUnderVoltageThreshold()}),a.dp_numeric(44,{name="over_current_threshold",emit=b.smkg2knlOverCurrentThreshold()}),a.dp_numeric(45,{name="temperature_threshold",emit=b.smkg2knlTemperatureThreshold()}),a.dp_temperature(47,{
name="temperature",scale=1,read_only=true,emit=b.temperature(),}),a.dp_numeric(53,{name="leakage_current",emit=b.leakageCurrentProtector()}),},}c(q,e.create_fingerprints("TS0601",{
"_TZE284_5m4nchbm",}))local w={
profile="din-rail-switch-power-energy-voltage-current-rcbo",package_group="energy",datapoints={
a.dp_on_off(1,{name="switch",emit=b.switch()}),a.dp_numeric(9,{name="countdown_timer",emit=b.rcboCountdownTimer()}),a.dp_enum(26,{
name="alarm",read_only=true,emit=b.rcboAlarm(),converter=d.from_only(d.lookup_value({
[0]="clear",[1]="over_voltage_threshold",[2]="under_voltage_threshold",[4]="over_current_threshold",[8]="over_temperature_threshold",[10]="over_leakage_current_threshold",[16]="trip_test",[128]="safety_lock",})),}),a.dp_power_on_behavior(27,{
name="power_on_behavior",emit=b.rcboPowerOnBehavior(),converter=d.lookup_from_to({off=0,on=1,previous=2}),}),a.dp_child_lock(29,{name="child_lock",emit=b.rcboChildLock()}),a.dp_raw(101,{name="voltage",converter=d.raw_uint_be(10,{length=2}),emit=C}),a.dp_raw(102,{name="current",converter=d.raw_uint_be(1000,{start=2,length=2}),emit=B}),a.dp_raw(103,{name="power",converter=d.raw_uint_be(10,{start=2,length=2}),emit=D}),a.dp_temperature(105,{
name="temperature",scale=1,read_only=true,emit=b.temperature(),}),a.dp_raw(110,{name="voltage_threshold"}),a.dp_numeric(111,{name="current_threshold",emit=b.currentThresholdRcbo63a()}),a.dp_raw(112,{name="temperature_threshold"}),a.dp_energy(113,{emit=b.energy(),scale=100}),a.dp_string(114,{name="meter_number",read_only=true,emit=b.rcboMeterNumber()}),a.dp_on_off(115,{name="clear_energy",emit=b.clearEnergyRcbo(),converter=d.lookup_from_to({on=true,off=false})}),a.dp_binary(116,{name="trip_test",emit=b.tripTestRcboTripClear(),converter=d.lookup_from_to({trip=true,clear=false})}),a.dp_raw(118,{
name="voltage_rms",converter=d.raw_uint_be(10,{length=2}),emit=b.rcboVoltageRms(),}),a.dp_raw(119,{
name="current_average",converter=d.raw_uint_be(1000,{start=2,length=2}),emit=b.rcboCurrentAverage(),}),},}c(w,{
e.create_fingerprint("_TZE200_hkdl5fmv","TS0601"),e.create_fingerprint("HOCH","ZJSBL7-100Z"),e.create_fingerprint("WDYK","ZJSBL7-100Z"),})local t={
profile="din-rail-switch-power-energy-voltage-current-toqjzt",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_phase_variant2(6,{
emit=f({
voltage=true,current=true,power=true,}),}),a.dp_numeric(13,{name="test1"}),a.dp_numeric(15,{name="leakage_current",emit=b.leakageCurrentToqJzt()}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_ac_frequency(32,{
name="ac_frequency",scale=1,read_only=true,emit=b.toqjztAcFrequency(),}),a.dp_power_factor(50,{
name="power_factor",read_only=true,emit=b.toqjztPowerFactor(),}),a.dp_enum(102,{
name="over_voltage_setting",emit=b.toqjztOverVoltageSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(103,{
name="under_voltage_setting",emit=b.toqjztUnderVoltageSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(104,{
name="over_current_setting",emit=b.toqjztOverCurrentSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(105,{
name="over_power_setting",emit=b.toqjztOverPowerSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(107,{
name="temperature_setting",emit=b.toqjztTemperatureSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(108,{
name="control_mode",emit=b.toqjztControlMode(),converter=d.lookup_from_to({
local_lock=0,local_mode=1,remote_mode=2,full_control=3,}),}),a.dp_enum(110,{
name="event",read_only=true,emit=b.toqjztEvent(),converter=d.from_only(d.lookup_value(s)),}),a.dp_numeric(114,{name="over_current_threshold",emit=b.toqjztOverCurrentThreshold()}),a.dp_numeric(115,{name="over_voltage_threshold",emit=b.toqjztOverVoltageThreshold()}),a.dp_numeric(116,{name="under_voltage_threshold",emit=b.toqjztUnderVoltageThreshold()}),a.dp_temperature(118,{
name="temperature_threshold",scale=10,emit=b.toqjztTemperatureThreshold(),}),a.dp_numeric(119,{name="over_power_threshold",emit=b.toqjztOverPowerThreshold()}),a.dp_numeric(125,{name="test5"}),a.dp_temperature(131,{
name="temperature",scale=10,read_only=true,emit=b.temperature(),}),}c(t,{
e.create_fingerprint("_TZE284_6ocnqlhn","TS0601"),})local p={
profile="din-rail-switch-power-energy-voltage-current-towsmr1",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_phase_variant2(6,{
emit=f({
voltage=true,current=true,power=true,}),}),a.dp_numeric(15,{name="leakage_current",read_only=true,emit=b.towsmr1LeakageCurrent()}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_enum(102,{
name="over_voltage_setting",emit=b.towsmr1OverVoltageSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(103,{
name="under_voltage_setting",emit=b.towsmr1UnderVoltageSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(104,{
name="over_current_setting",emit=b.towsmr1OverCurrentSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(105,{
name="over_power_setting",emit=b.towsmr1OverPowerSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(107,{
name="temperature_setting",emit=b.towsmr1TemperatureSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(108,{
name="leakage_setting",emit=b.towsmr1LeakageSetting(),converter=d.lookup_from_to(g),}),a.dp_enum(110,{
name="event",read_only=true,emit=b.towsmr1Event(),converter=d.from_only(d.lookup_value(s)),}),a.dp_on_off(112,{
name="auto_reclosing",emit=b.towsmr1AutoReclosing(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_on_off(113,{
name="restore_default",emit=b.towsmr1RestoreDefault(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_numeric(114,{name="over_current_threshold",emit=b.towsmr1OverCurrentThreshold()}),a.dp_numeric(115,{name="over_voltage_threshold",emit=b.towsmr1OverVoltageThreshold()}),a.dp_numeric(116,{name="under_voltage_threshold",emit=b.towsmr1UnderVoltageThreshold()}),a.dp_numeric(117,{name="leakage_threshold",emit=b.towsmr1LeakageThreshold()}),a.dp_temperature(118,{
name="temperature_threshold",scale=10,emit=b.towsmr1TemperatureThreshold(),}),a.dp_numeric(119,{name="over_power_threshold",emit=b.towsmr1OverPowerThreshold()}),a.dp_temperature(131,{
name="temperature",scale=10,read_only=true,emit=b.temperature(),}),a.dp_on_off(143,{
name="overcurrent_recloser",emit=b.towsmr1OvercurrentRecloser(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_on_off(144,{
name="leakage_recloser",emit=b.towsmr1LeakageRecloser(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_on_off(145,{
name="overpower_recloser",emit=b.towsmr1OverpowerRecloser(),converter=d.lookup_from_to({off=false,on=true}),}),}c(p,e.create_fingerprints("TS0601",{
"_TZE204_kobbcyum","_TZE284_kobbcyum","_TZE284_hecsejsb","_TZE284_432zhuwe","_TZE204_432zhuwe","_TZE284_s5vuaadg","_TZE284_tuhfx7tf","_TZE204_tuhfx7tf",}))c(p,{
e.create_fingerprint("Tongou","TOWSMR1-40A-AC"),e.create_fingerprint("Tongou","TOWSMR1-40A-A"),e.create_fingerprint("Tongou","TOWSMR1-20A-AC"),})local y={
profile="din-rail-switch-power-energy-voltage-current-zbnjt63",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_numeric(3,{name="monthly_energy"}),a.dp_numeric(4,{name="daily_energy"}),a.dp_phase_variant3(6,{
emit=f({
voltage=true,current=true,power=true,}),}),a.dp_enum(10,{
name="fault",read_only=true,emit=b.zbnjt63Fault(),converter=d.from_only(d.lookup_value({
[0]="clear",[1]="ov_cr",[2]="unbalance_alarm",[4]="ov_vol",[8]="undervoltage_alarm",[16]="miss_phase_alarm",[32]="outage_alarm",[64]="magnetism_alarm",[128]="terminal_alarm",[256]="cover_alarm",[512]="credit_alarm",[1024]="no_balance_alarm",[2048]="battery_alarm",[4096]="meter_hardware_alarm",})),}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_raw(18,{
name="meter_id",read_only=true,emit=b.zbnjt63MeterId(),converter=d.raw_identifier(),}),a.dp_power_outage_memory(23,{
name="power_outage_memory",emit=b.zbnjt63PowerOutageMemory(),converter=d.lookup_from_to({on=0,off=1,restore=2}),}),}c(y,e.create_fingerprints("TS0601",{
"_TZE204_jcwbwckh",}))local v={
profile="din-rail-switch-power-energy-voltage-current",package_group="energy",a.dp_on_off(1,{name="switch",emit=b.switch()}),a.dp_energy(17,{emit=b.energy(),scale=100}),a.dp_current(18,{emit=b.current(),scale=1000}),a.dp_power(19,{emit=b.power(),scale=10}),a.dp_voltage(20,{emit=b.voltage(),scale=10}),}c(v,e.create_fingerprints("TS0601",{
"_TZE204_byzdayie",}))local j={
profile="din-rail-switch-power-energy-voltage-current-rmdzb1pnl63",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_phase_variant2(6,{
signed_power=true,emit=f({
voltage=true,current=true,power=true,}),}),a.dp_numeric(9,{
name="faults",read_only=true,emit=b.rmdzb1pnl63Faults(),converter=h,}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_threshold(17,{}),a.dp_threshold(18,{}),a.dp_temperature(103,{
name="temperature",scale=1,read_only=true,emit=b.temperature(),}),}c(j,e.create_fingerprints("TS0601",{
"_TZE204_m64smti7",}))c(j,{
e.create_fingerprint("TNCE","RMDZB-1PNL63"),})local k={
profile="din-rail-switch-power-energy-3phase-stb3l125zj",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_phase_variant2(6,{
signed_power=true,phase="a",component="l1",emit=f({voltage=true,current=true,power=true}),}),a.dp_phase_variant2(7,{
signed_power=true,phase="b",component="l2",emit=f({voltage=true,current=true,power=true}),}),a.dp_phase_variant2(8,{
signed_power=true,phase="c",component="l3",emit=f({voltage=true,current=true,power=true}),}),a.dp_numeric(9,{
name="faults",read_only=true,emit=b.stb3l125zjFaults(),converter=h,}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_threshold(17,{}),a.dp_threshold(18,{}),a.dp_on_off(21,{
name="leakage_test",emit=b.stb3l125zjLeakageTest(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_temperature(102,{
name="temperature",scale=10,read_only=true,emit=b.temperature(),}),}c(k,e.create_fingerprints("TS0601",{
"_TZE200_wbhaespm","_TZE204_wbhaespm","_TZE284_wbhaespm",}))c(k,{
e.create_fingerprint("SUTON","STB3L-125/ZJ"),})local x={
profile="din-rail-switch-power-energy-voltage-current-zbndj63",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_phase_variant2(6,{
emit=f({
voltage=true,current=true,power=true,}),}),a.dp_enum(9,{
name="faults",read_only=true,emit=b.zbndj63Faults(),converter=d.from_only(d.lookup_value({
[0]="clear",[1]="short_circuit_alarm",[2]="surge_alarm",[4]="overload_alarm",[8]="leakagecurr_alarm",[16]="temp_dif_fault",[32]="fire_alarm",[64]="high_power_alarm",[128]="self_test_alarm",[256]="ov_cr",[512]="unbalance_alarm",[1024]="ov_vol",[2048]="undervoltage_alarm",[4096]="miss_phase_alarm",[8192]="outage_alarm",[16384]="magnetism_alarm",[32768]="credit_alarm",[65536]="no_balance_alarm",})),}),a.dp_on_off(11,{
name="switch_prepayment",emit=b.zbndj63SwitchPrepayment(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_on_off(12,{
name="clear_energy",emit=b.zbndj63ClearEnergy(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_energy(13,{
name="balance_energy",scale=100,read_only=true,emit=b.zbndj63BalanceEnergy(),}),a.dp_energy(14,{name="charge_energy",scale=100,emit=b.zbndj63ChargeEnergy()}),a.dp_numeric(15,{
name="leakage_current",read_only=true,emit=b.zbndj63LeakageCurrent(),}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_threshold(17,{}),a.dp_threshold(18,{}),a.dp_numeric(102,{name="recover_count",emit=b.zbndj63RecoverCount()}),a.dp_temperature(103,{
name="temperature",scale=1,read_only=true,emit=b.zbndj63Temperature(),}),a.dp_on_off(104,{
name="recover_enable",emit=b.zbndj63RecoverEnable(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_numeric(105,{name="countdown",emit=b.zbndj63Countdown()}),a.dp_numeric(107,{name="leakage_delay",emit=b.zbndj63LeakageDelay()}),a.dp_energy(110,{
name="reverse_energy",scale=100,read_only=true,emit=b.zbndj63ReverseEnergy(),}),a.dp_numeric(119,{name="power_on_delay",emit=b.zbndj63PowerOnDelay()}),a.dp_numeric(124,{name="alarm_over_current_count"}),a.dp_numeric(125,{name="alarm_low_current_count"}),a.dp_numeric(127,{name="status"}),a.dp_numeric(134,{
name="relay_power_on_state",emit=b.zbndj63RelayPowerOnState(),converter=d.lookup_from_to({
off=0,on=1,restore=2,}),}),}c(x,e.create_fingerprints("TS0601",{
"_TZE204_lb0fsvba",}))local o={
profile="din-rail-switch-power-energy-voltage-current-toqcb2",package_group="energy",a.dp_energy(1,{emit=b.energy(),scale=100}),a.dp_phase_variant2(6,{
signed_power=true,phase="a",component="l1",emit=f({
voltage=true,current=true,power=true,}),}),a.dp_phase_variant2(7,{
signed_power=true,phase="b",component="l2",emit=f({voltage=true,current=true,power=true}),}),a.dp_phase_variant2(8,{
signed_power=true,phase="c",component="l3",emit=f({voltage=true,current=true,power=true}),}),a.dp_on_off(16,{name="switch",emit=b.switch()}),a.dp_enum(102,{
name="over_voltage_setting",emit=b.toqcb2OverVoltageSetting(),converter=d.lookup_from_to(i),}),a.dp_enum(103,{
name="under_voltage_setting",emit=b.toqcb2UnderVoltageSetting(),converter=d.lookup_from_to(i),}),a.dp_enum(104,{
name="over_current_setting",emit=b.toqcb2OverCurrentSetting(),converter=d.lookup_from_to(i),}),a.dp_enum(105,{
name="over_power_setting",emit=b.toqcb2OverPowerSetting(),converter=d.lookup_from_to(i),}),a.dp_enum(107,{
name="temperature_setting",emit=b.toqcb2TemperatureSetting(),converter=d.lookup_from_to(i),}),a.dp_enum(110,{
name="last_event",read_only=true,emit=b.toqcb2LastEvent(),converter=d.from_only(d.lookup_value({
[0]="normal",[1]="trip_over_current",[2]="trip_over_power",[3]="trip_over_temperature",[4]="trip_voltage_1",[5]="trip_voltage_2",[6]="alarm_over_current",[7]="alarm_over_power",[8]="alarm_over_temperature",[9]="alarm_voltage_1",[10]="alarm_voltage_2",[11]="remote_on",[12]="remote_off",[13]="manual_on",[14]="manual_off",[15]="value_15",[16]="value_16",[17]="factory_reset",})),}),a.dp_on_off(112,{
name="clear_fault",emit=b.clearFaultBreaker(),converter=d.lookup_from_to({on=true,off=false}),}),a.dp_on_off(113,{
name="factory_reset",emit=b.toqcb2FactoryReset(),converter=d.lookup_from_to({off=false,on=true}),}),a.dp_numeric(114,{name="current_threshold",emit=b.currentThresholdToqcb2A63()}),a.dp_numeric(115,{name="over_voltage_threshold",emit=b.toqcb2OverVoltageThreshold()}),a.dp_numeric(116,{name="under_voltage_threshold",emit=b.toqcb2UnderVoltageThreshold()}),a.dp_temperature(118,{
name="temperature_threshold",scale=10,emit=b.toqcb2TemperatureThreshold(),}),a.dp_numeric(119,{name="over_power_threshold",emit=b.toqcb2OverPowerThreshold()}),a.dp_temperature(131,{
name="temperature",scale=10,read_only=true,emit=b.temperature(),}),}c(o,e.create_fingerprints("TS0601",{
"_TZE284_q22avxbv","_TZE204_q22avxbv","_TZE204_mrffaamu","_TZE204_tzreobvu","_TZE284_mrffaamu","_TZE284_tzreobvu","_TZE284_9xstqowh","_TZE284_kv1nvirl","_TZE284_lyqazpe6","_TZE204_lyqazpe6",}))c(o,{
e.create_fingerprint("Tongou","TOQCB2-80-2P"),})return{
id="ef00.din_rail.energy",registrations=z,}
