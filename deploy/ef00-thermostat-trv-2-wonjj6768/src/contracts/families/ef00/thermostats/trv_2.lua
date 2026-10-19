local b=require"protocol.tuya"
local a=require"capabilities.events.all"
local N=require"contracts.helpers.family"
local g=require"contracts.helpers.ef00"
local f=require"contracts.helpers.ef00_thermostats"
local c=b.converter
local H,d=N.definition_registry()local u=f.valve_position_to_running_state
local k=f.variant1_mode_from_device
local p=f.variant1_mode_to_device
local z={
profile="thermostats-thermostat-battery-ar331",package_group="trv-2",b.dp_enum(2,{
name="preset",emit=a.ar331Preset(),converter=c.lookup_from_to({auto=0,manual=1,leave=2}),}),b.dp_running_state(3,{
converter=c.lookup_from_to({heating=1,idle=0}),emit=a.thermostat_operating_state(),}),b.dp_current_heating_setpoint(4,{scale=10,emit=a.heating_setpoint("C")}),b.dp_local_temperature(5,{scale=10,emit=a.temperature("C")}),b.dp_battery(6,{emit=a.battery()}),b.dp_child_lock(7,{
name="child_lock",emit=a.ar331ChildLock(),converter=c.lookup_from_to({lock=false,unlock=true}),}),}d(z,g.ts0601_fingerprints({
"_TZE284_noixx2uz",}))local E={
profile="thermostats-thermostat-s366",package_group="trv-2",force_time_updates=true,b.dp_system_mode(1,{
datatype=b.DP_TYPE_BOOL,converter=c.lookup_from_to({
heat=true,off=false,}),emit=a.thermostat_mode(),}),b.dp_enum(2,{
name="preset",emit=a.s366Preset(),converter=c.lookup_from_to({manual=0,holiday=1,program=2}),}),b.dp_open_window(8,{emit=a.s366OpenWindow()}),b.dp_frost_protection(10,{emit=a.s366FrostProtection()}),b.dp_current_heating_setpoint(16,{scale=10,emit=a.heating_setpoint("C")}),b.dp_local_temperature(24,{scale=10,emit=a.temperature("C")}),b.dp_local_temperature_calibration(27,{scale=10,emit=a.s366TempCalibration()}),b.dp_binary(35,{
name="battery_low",read_only=true,emit=a.s366BatteryLow(),
converter=c.from_only(function(e)
return(e==false or e==0)and"low"or"normal"
end),
}),b.dp_child_lock(40,{emit=a.s366ChildLock()}),b.dp_numeric(45,{
name="error_status",read_only=true,emit=a.s366ErrorStatus(),}),}d(E,g.ts0601_fingerprints({
"_TZE200_0hg58wyk",}))local F={
profile="thermostats-thermostat-trv4",package_group="trv-2",force_time_updates=true,b.dp_system_mode(49,{
converter=c.lookup_from_to({
off=0,heat=1,}),emit=a.thermostat_mode(),}),b.dp_enum(2,{
name="preset",emit=a.trv4Preset(),converter=c.lookup_from_to({
schedule=0,holiday=1,manual=2,comfort=3,eco=4,}),}),b.dp_current_heating_setpoint(4,{scale=10,emit=a.heating_setpoint("C")}),b.dp_local_temperature(5,{scale=10,emit=a.temperature("C")}),b.dp_battery(6,{emit=a.battery()}),b.dp_child_lock(7,{emit=a.trv4ChildLock()}),b.dp_holiday_temperature(21,{scale=10,emit=a.trv4HolidayTemperature()}),b.dp_comfort_temperature(24,{scale=10,emit=a.trv4ComfortTemperature()}),b.dp_eco_temperature(25,{scale=10,emit=a.trv4EcoTemperature()}),b.dp_bitmap(35,{
name="battery_low",read_only=true,emit=a.trv4BatteryLow(),converter=c.from_only(f.error_or_battery_low_state),}),b.dp_frost_protection(36,{emit=a.trv4FrostProtection()}),b.dp_boost_heating(37,{emit=a.trv4BoostHeating()}),b.dp_scale_protection(39,{emit=a.trv4ScaleProtection()}),b.dp_local_temperature_calibration(47,{scale=1,emit=a.trv4TempCalibration()}),}d(F,g.ts0601_fingerprints({
"_TZE204_pcdmj88b","_TZE284_pcdmj88b",}))
local function j(e)
local K=tonumber(e)if K==nil then
return nil
end
if K==6 then
return"off"
end
return"heat"
end
local function l(e)
if e=="off"then
return 6
end
if e=="heat"then
return 0
end
return nil
end
local B={
profile="thermostats-thermostat-trv14",package_group="trv-2",force_time_updates=true,b.dp_system_mode(2,{
from_device=j,to_device=l,emit=a.thermostat_mode(),}),b.dp_enum(2,{
name="preset",emit=a.trv14Preset(),converter=c.lookup_from_to({
manual=0,schedule=1,eco=2,comfort=3,frostProtection=4,holiday=5,off=6,}),}),b.dp_running_state(3,{
converter=c.lookup_from_to({
heating=1,idle=0,}),emit=a.thermostat_operating_state(),}),b.dp_current_heating_setpoint(4,{scale=10,emit=a.heating_setpoint("C")}),b.dp_local_temperature(5,{scale=10,emit=a.temperature("C")}),b.dp_battery(6,{emit=a.battery()}),b.dp_child_lock(7,{emit=a.trv14ChildLock()}),b.dp_window_detection(14,{emit=a.trv14WindowDetection()}),b.dp_enum(15,{
name="window_open",read_only=true,emit=a.trv14WindowOpen(),converter=c.from_only(c.lookup_value({[0]="close",[1]="open"})),}),b.dp_holiday_temperature(21,{scale=10,emit=a.trv14HolidayTemperature()}),b.dp_bitmap(35,{
name="battery_low",read_only=true,emit=a.trv14BatteryLow(),converter=c.from_only(f.error_or_battery_low_state),}),b.dp_frost_protection(36,{emit=a.trv14FrostProtection()}),b.dp_boost_heating(37,{emit=a.trv14BoostHeating()}),b.dp_scale_protection(39,{emit=a.trv14ScaleProtection()}),b.dp_local_temperature_calibration(47,{scale=10,emit=a.trv14TempCalibration()}),b.dp_eco_temperature(103,{scale=10,emit=a.trv14EcoTemperature()}),b.dp_comfort_temperature(104,{scale=10,emit=a.trv14ComfortTemperature()}),}d(B,g.ts0601_fingerprints({
"_TZE204_vjpaih9f","_TZE284_vjpaih9f",}))
local function r(e)
local K=tonumber(e)local v={
[0]="heat",[1]="auto",[2]="heat",[3]="heat",[4]="heat",[5]="off",}return v[K]
end
local function t(e)
local v={
heat=0,auto=1,off=5,}return v[e]
end
local s={
profile="thermostats-thermostat-gtz10",package_group="trv-2",force_time_updates=true,time_start="1970",b.dp_system_mode(2,{
from_device=r,to_device=t,emit=a.thermostat_mode(),}),b.dp_enum(2,{
name="preset",emit=a.gtz10Preset(),converter=c.lookup_from_to({
manual=0,auto=1,holiday=2,comfort=3,eco=4,off=5,}),}),b.dp_running_state(49,{
from_device=u,emit=a.thermostat_operating_state(),read_only=true,}),b.dp_current_heating_setpoint(4,{scale=10,emit=a.heating_setpoint("C")}),b.dp_local_temperature(5,{scale=10,emit=a.temperature("C")}),b.dp_battery(6,{emit=a.battery()}),b.dp_child_lock(7,{emit=a.gtz10ChildLock()}),b.dp_max_temperature_limit(9,{
name="max_temperature",scale=10,emit=a.gtz10MaxTemperature(),}),b.dp_min_temperature_limit(10,{
name="min_temperature",scale=10,emit=a.gtz10MinTemperature(),}),b.dp_window_detection(14,{emit=a.gtz10WindowDetection()}),b.dp_window_open(15,{
read_only=true,emit=a.gtz10WindowOpen(),
converter=c.from_only(function(e)
return e and"open"or"close"
end),
}),b.dp_open_window_temperature(16,{scale=10,emit=a.gtz10OpenWindowTemperature()}),b.dp_numeric(35,{
name="error_status",read_only=true,emit=a.gtzFault(),}),b.dp_frost_protection(36,{emit=a.gtz10FrostProtection()}),b.dp_boost_heating(37,{emit=a.gtz10BoostHeating()}),b.dp_numeric(38,{
name="boost_timeset_countdown",emit=a.gtz10BoostCountdown(),}),b.dp_local_temperature_calibration(47,{scale=10,emit=a.gtz10TempCalibration()}),b.dp_binary(113,{
name="switch_type",emit=a.gtz10SwitchType(),converter=c.lookup_from_to({off=false,on=true}),}),b.dp_numeric(115,{name="position",emit=a.gtz10Position()}),b.dp_enum(119,{
name="screen_orientation",emit=a.gtz10ScreenOrientation(),converter=c.lookup_from_to({up=0,down=1,left=2,right=3}),}),}for index,O in ipairs({a.gtzMonday,a.gtzTuesday,a.gtzWednesday,a.gtzThursday,a.gtzFriday,a.gtzSaturday,a.gtzSunday})do
s[#s+1]=b.dp_raw(27+index,{
name="gtz_schedule_"..index,converter=f.daily_schedule(index,4),emit=O(),})
end
d(s,g.ts0601_fingerprints({
"_TZE200_pbo8cj0z","_TZE200_eo6xhfbo",}))local n={
profile="thermostats-thermostat-tr-m3z",package_group="trv-2",time_start="1970",b.dp_system_mode(101,{
converter=c.lookup_from_to({
off=false,heat=true,}),emit=a.thermostat_mode(),}),b.dp_enum(2,{
name="preset",emit=a.trm3zPreset(),converter=c.lookup_from_to({
manual=0,schedule=1,eco=2,comfort=3,frostProtection=4,holiday=5,off=6,}),}),b.dp_running_state(3,{
converter=c.lookup_from_to({
heating=1,idle=0,}),emit=a.thermostat_operating_state(),}),b.dp_current_heating_setpoint(4,{scale=10,emit=a.heating_setpoint("C")}),b.dp_local_temperature(5,{scale=10,emit=a.temperature("C")}),b.dp_battery(6,{emit=a.battery()}),b.dp_child_lock(7,{emit=a.trm3zChildLock()}),b.dp_window_detection(14,{emit=a.trm3zWindowDetection()}),b.dp_enum(15,{
name="window_open",read_only=true,emit=a.trm3zWindowOpen(),converter=c.from_only(c.lookup_value({[0]="close",[1]="open"})),}),b.dp_holiday_temperature(21,{scale=10,emit=a.trm3zHolidayTemperature()}),b.dp_bitmap(35,{
name="battery_low",read_only=true,emit=a.trm3zBatteryLow(),converter=c.from_only(f.error_or_battery_low_state),}),b.dp_bitmap(35,{name="fault_alarm",read_only=true,emit=a.trmFault()}),b.dp_frost_protection(36,{emit=a.trm3zFrostProtection()}),b.dp_scale_protection(39,{emit=a.trm3zScaleProtection()}),b.dp_local_temperature_calibration(47,{scale=10,emit=a.trm3zTempCalibration()}),b.dp_numeric(102,{
name="temperature_accuracy",converter=c.divide_by_pair(10),emit=a.trm3zTemperatureAccuracy(),}),b.dp_eco_temperature(103,{scale=10,emit=a.trm3zEcoTemperature()}),b.dp_comfort_temperature(104,{scale=10,emit=a.trm3zComfortTemperature()}),b.dp_temperature(105,{
name="frost_protection_temperature",scale=10,emit=a.trm3zFrostTemperature(),}),}for index,O in ipairs({a.trmMonday,a.trmTuesday,a.trmWednesday,a.trmThursday,a.trmFriday,a.trmSaturday,a.trmSunday})do
n[#n+1]=b.dp_raw(27+index,{
name="trm_schedule_"..index,converter=f.daily_schedule(index,6),emit=O(),})
end
d(n,g.ts0601_fingerprints({
"_TZE204_eekpf0ft","_TZE284_eekpf0ft",}))local m="tv02_heating_stop"
local q="tv02_preset_mode"
local function w(e,G)
local v={
[0]="auto",[1]="heat",[2]="heat",[3]="heat",}local P=v[tonumber(e)]if P==nil then
return nil
end
G:set_field(q,P,{persist=false})if G:get_field(m)==true then
return"off"
end
return P
end
local function x(e,G)
local I=e==true
G:set_field(m,I,{persist=false})if I then
return"off"
end
return G:get_field(q)or"heat"
end
local function A(_,e)
if e=="off"then
return{
{dp=107,datatype=b.DP_TYPE_BOOL,value=true},}
end
if e=="auto"then
return{
{dp=2,datatype=b.DP_TYPE_ENUM,value=0},}
end
if e=="heat"then
return{
{dp=2,datatype=b.DP_TYPE_ENUM,value=1},}
end
return nil
end
local C=b.dp_current_heating_setpoint(16,{
scale=10,emit=a.heating_setpoint("C"),})local M={
profile="thermostats-thermostat-tv02",package_group="trv-2",force_time_updates=true,named_mapping={
named_mappings={
system_mode=A,current_heating_setpoint=C,},},b.dp_system_mode(2,{
from_device=w,emit=a.thermostat_mode(),read_only=true,}),b.dp_open_window(8,{emit=a.tv02OpenWindow()}),b.dp_frost_protection(10,{emit=a.tv02FrostProtection()}),C,b.dp_local_temperature(24,{
scale=10,emit=a.temperature("C"),}),b.dp_local_temperature_calibration(27,{scale=10,emit=a.tv02TempCalibration()}),b.dp_enum(31,{
name="working_day",converter=c.lookup_from_to({
mon_sun=0,mon_fri_sat_sun=1,separate=2,}),emit=a.workingDayTv02ScheduleMode(),}),b.dp_holiday_temperature(32,{scale=10,emit=a.tv02HolidayTemperature()}),b.dp_binary(35,{
name="battery_low",
converter=c.from_only(function(e)
if e==false or e==0 then return"low"end
if e==true or e==1 then return"normal"end
return nil
end),
read_only=true,emit=a.tv02BatteryLow(),}),b.dp_child_lock(40,{emit=a.tv02ChildLock()}),b.dp_numeric(45,{name="error_status",read_only=true,emit=a.tv02ErrorStatus()}),b.dp_raw(46,{name="holiday_start_stop"}),b.dp_numeric(101,{name="boost_timeset_countdown",emit=a.tv02BoostCountdown()}),b.dp_open_window_temperature(102,{scale=10,emit=a.tv02OpenWindowTemperature()}),b.dp_comfort_temperature(104,{scale=10,emit=a.tv02ComfortTemperature()}),b.dp_eco_temperature(105,{scale=10,emit=a.tv02EcoTemperature()}),b.dp_raw(106,{name="schedule"}),b.dp_binary(107,{
name="system_mode",from_device=x,emit=a.thermostat_mode(),read_only=true,}),b.dp_raw(108,{name="schedule_monday"}),b.dp_raw(109,{name="schedule_wednesday"}),b.dp_raw(110,{name="schedule_friday"}),b.dp_raw(111,{name="schedule_sunday"}),b.dp_raw(112,{name="schedule_tuesday"}),b.dp_raw(113,{name="schedule_thursday"}),b.dp_raw(114,{name="schedule_saturday"}),b.dp_binary(115,{
name="online",read_only=true,emit=a.tv02Online(),converter=c.lookup_from_to({off=false,on=true}),}),}d(M,g.ts0601_fingerprints({
"_TZE200_sur6q7ko","_TZE200_hue3yfsn","_TZE200_e9ba97vf","_TZE200_husqqvux","_TZE200_lnbfnyxd","_TZE200_fsow0qsk","_TZE200_lllliz3p","_TZE200_mudxchsu","_TZE200_7yoranx2","_TZE200_kds0pmmv","_TZE200_py4cm3he","_TZE200_wsbfwodu","_TZE200_x9axofse","_TZE200_lhzapfg9","_TZE200_k1tumq4t",}))
local function y(Q,i)
return{
profile=Q,b.dp_system_mode(1,{
from_device=k,to_device=p,emit=a.thermostat_mode(),}),b.dp_enum(1,{
name="preset",emit=i.preset,converter=c.lookup_from_to({auto=0,manual=1,off=2,on=3}),}),b.dp_current_heating_setpoint(2,{scale=10,emit=a.heating_setpoint("C")}),b.dp_local_temperature(3,{scale=10,emit=a.temperature("C")}),b.dp_running_state(6,{
converter=c.lookup_from_to({heating=1,idle=0}),emit=a.thermostat_operating_state(),}),b.dp_enum(7,{
name="window",read_only=true,emit=i.window,converter=c.from_only(c.lookup_value({[0]="close",[1]="open"})),}),b.dp_window_detection(8,{emit=i.window_detection}),b.dp_child_lock(12,{emit=i.child_lock}),b.dp_battery(13,{emit=a.battery()}),b.dp_binary(14,{
name="alarm_switch",read_only=true,emit=i.alarm_switch,
converter=c.from_only(function(e)
if e==true or e==1 then return"on"end
if e==false or e==0 then return"off"end
end),
}),b.dp_min_temperature_limit(15,{
name="min_temperature",scale=10,emit=i.min_temperature,}),b.dp_max_temperature_limit(16,{
name="max_temperature",scale=10,emit=i.max_temperature,}),b.dp_local_temperature_calibration(101,{scale=10,emit=i.calibration}),b.dp_numeric(108,{
name="position",read_only=true,converter=c.divide_by_pair(10),emit=i.position,}),b.dp_enum(111,{
name="display_brightness",emit=i.display_brightness,converter=c.lookup_from_to(i.brightness_map),}),b.dp_enum(113,{
name="screen_orientation",emit=i.screen_orientation,converter=c.lookup_from_to(i.orientation_map),}),b.dp_enum(114,{
name="hysteresis_mode",emit=i.hysteresis,converter=c.lookup_from_to({comfort=0,eco=1}),}),}
end
local o=y("thermostats-thermostat-trv601",{
preset=a.trv601Preset(),window=a.trv601Window(),window_detection=a.trv601WindowDetection(),child_lock=a.trv601ChildLock(),alarm_switch=a.trv601AlarmSwitch(),min_temperature=a.trv601MinTemperature(),max_temperature=a.trv601MaxTemperature(),calibration=a.trv601TempCalibration(),position=a.trv601Position(),display_brightness=a.trv601DisplayBrightness(),brightness_map={high=0,medium=1,low=2},screen_orientation=a.trv601ScreenOrientation(),orientation_map={up=0,right=1,down=2,left=3},hysteresis=a.trv601Hysteresis(),})o.package_group="trv-2"
o.force_time_updates=true
d(o,g.ts0601_fingerprints({
"_TZE204_rtrmfadk","_TZE204_cvcu2p6e",}))local h=y("thermostats-thermostat-trv602",{
preset=a.trv602Preset(),window=a.trv602Window(),window_detection=a.trv602WindowDetection(),child_lock=a.trv602ChildLock(),alarm_switch=a.trv602AlarmSwitch(),min_temperature=a.trv602MinTemperature(),max_temperature=a.trv602MaxTemperature(),calibration=a.trv602TempCalibration(),position=a.trv602Position(),display_brightness=a.trv602DisplayBrightness(),brightness_map={high=0,middle=1,low=2},screen_orientation=a.trv602ScreenOrientation(),orientation_map={up=0,down=2},hysteresis=a.trv602Hysteresis(),})h.package_group="trv-2"
h.force_time_updates=true
h[#h+1]=b.dp_numeric(115,{
name="switch_deviation_eco",converter=c.divide_by_pair(10),emit=a.trv602SwitchDeviationEco(),})d(h,g.ts0601_fingerprints({
"_TZE204_9mjy74mp","_TZE200_rtrmfadk","_TZE200_9mjy74mp",}))local J={
profile="thermostats-thermostat-trv602z",package_group="trv-2",time_start="2000",b.dp_system_mode(2,{
from_device=function(e)
local v={
[0]="off",[1]="auto",[2]="auto",[3]="auto",[4]="auto",[5]="heat",}return v[tonumber(e)]
end,
to_device=function(e)
local v={off=0,auto=4,heat=5}return v[e]
end,
emit=a.thermostat_mode(),}),b.dp_enum(2,{
name="preset",emit=a.trv602zPreset(),converter=c.lookup_from_to({
off=0,antifrost=1,eco=2,comfort=3,auto=4,on=5,}),}),b.dp_running_state(3,{
converter=c.lookup_from_to({heating=1,idle=0}),emit=a.thermostat_operating_state(),}),b.dp_current_heating_setpoint(4,{scale=10,emit=a.heating_setpoint("C")}),b.dp_local_temperature(5,{scale=10,emit=a.temperature("C")}),b.dp_battery(6,{emit=a.battery()}),b.dp_child_lock(7,{emit=a.trv602zChildLock()}),b.dp_max_temperature_limit(9,{
name="max_temperature",scale=10,emit=a.trv602zMaxTemperature(),}),b.dp_min_temperature_limit(10,{
name="min_temperature",scale=10,emit=a.trv602zMinTemperature(),}),b.dp_window_detection(14,{emit=a.trv602zWindowDetection()}),b.dp_enum(15,{
name="window",read_only=true,emit=a.trv602zWindow(),converter=c.from_only(c.lookup_value({[0]="close",[1]="open"})),}),b.dp_local_temperature_calibration(47,{scale=10,emit=a.trv602zTempCalibration()}),b.dp_enum(110,{
name="motor_thrust",emit=a.trv602zMotorThrust(),converter=c.lookup_from_to({strong=0,middle=1,weak=2}),}),b.dp_enum(111,{
name="display_brightness",emit=a.trv602zDisplayBrightness(),converter=c.lookup_from_to({high=0,medium=1,low=2}),}),b.dp_enum(113,{
name="screen_orientation",emit=a.trv602zScreenOrientation(),converter=c.lookup_from_to({up=0,down=1}),}),b.dp_numeric(114,{
name="position",read_only=true,converter=c.divide_by_pair(10),emit=a.trv602zPosition(),}),b.dp_numeric(118,{
name="boost_timeset_countdown",emit=a.trv602zBoostCountdown(),}),b.dp_comfort_temperature(119,{scale=10,emit=a.trv602zComfortTemperature()}),b.dp_eco_temperature(120,{scale=10,emit=a.trv602zEcoTemperature()}),b.dp_holiday_temperature(121,{scale=10,emit=a.trv602zHolidayTemperature()}),b.dp_frost_protection(122,{emit=a.trv602zFrostProtection()}),b.dp_enum(127,{
name="hysteresis_mode",emit=a.trv602zHysteresis(),converter=c.lookup_from_to({comfort=0,eco=1}),}),}d(J,g.ts0601_fingerprints({
"_TZE204_qyr2m29i","_TZE204_ltwbm23f","_TZE284_ltwbm23f",}))local D={
profile="thermostats-thermostat-battery-ar331pro",package_group="trv-2",b.dp_binary(1,{
name="preheat",read_only=true,emit=a.ar331proPreheat(),converter=c.lookup_from_to({off=false,on=true}),}),b.dp_enum(2,{
name="preset",emit=a.thermostatPresetAr331proSixMode(),converter=c.lookup_from_to({
auto=0,manual=1,holiday=2,eco=3,comfort=4,standby=5,}),}),b.dp_running_state(3,{
converter=c.lookup_from_to({
heating=0,idle=1,}),emit=a.thermostat_operating_state(),}),b.dp_current_heating_setpoint(4,{scale=10}),b.dp_local_temperature(5,{scale=10}),b.dp_battery(6,{emit=a.battery()}),b.dp_child_lock(7,{
emit=a.ar331proChildLock(),converter=c.lookup_from_to({
lock=false,unlock=true,}),}),b.dp_window_detection(14,{emit=a.ar331proWindowDetection()}),b.dp_enum(15,{
name="window_open",read_only=true,emit=a.ar331proWindowOpen(),converter=c.from_only(c.lookup_value({
[0]="open",[1]="closed",})),}),b.dp_temperature(16,{
name="window_temperature",scale=10,emit=a.ar331proWindowTemp(),}),b.dp_numeric(18,{
name="display_brightness",emit=a.ar331proDisplayBrightness(),}),b.dp_numeric(35,{
name="fault_code",read_only=true,emit=a.ar331proFaultCode(),}),b.dp_local_temperature_calibration(47,{scale=10,emit=a.ar331proTempCalibration()}),b.dp_enum(49,{
name="valve_state",read_only=true,emit=a.ar331proValveState(),converter=c.from_only(c.lookup_value({
[0]="open",[1]="close",})),}),b.dp_boost_heating(101,{emit=a.ar331proBoostHeating()}),b.dp_numeric(102,{
name="boost_time",converter=c.divide_by_pair(60),emit=a.ar331proBoostTime(),}),b.dp_eco_temperature(103,{scale=10,emit=a.ar331proEcoTemperature()}),b.dp_comfort_temperature(104,{scale=10,emit=a.ar331proComfortTemperature()}),b.dp_numeric(105,{
name="window_delay",converter=c.divide_by_pair(60),emit=a.ar331proWindowDelay(),}),b.dp_temperature(107,{
name="frost_protection_temperature",scale=10,emit=a.ar331proFrostTemperature(),}),b.dp_numeric(108,{
name="window_close_delay",converter=c.divide_by_pair(60),emit=a.ar331proWindowCloseDelay(),}),b.dp_binary(109,{
name="heating_cooling_mode",emit=a.ar331proHeatCoolMode(),converter=c.lookup_from_to({heat=false,cool=true}),}),b.dp_binary(110,{
name="battery_status",read_only=true,emit=a.ar331proBatteryStatus(),converter=c.lookup_from_to({normal=false,low=true}),}),b.dp_enum(111,{
name="screen_orientation",emit=a.ar331proScreenOrientation(),converter=c.lookup_from_to({up=0,right=90,down=180,left=270}),}),b.dp_binary(113,{
name="summer_mode",emit=a.ar331proSummerMode(),converter=c.lookup_from_to({off=false,on=true}),}),b.dp_temperature(114,{
name="override_temperature",scale=10,emit=a.ar331proOverrideTemperature(),}),b.dp_binary(115,{
name="override_active",emit=a.ar331proOverrideActive(),converter=c.lookup_from_to({off=false,on=true}),}),}d(D,g.ts0601_fingerprints({
"_TZE284_nbv4tdaz",}))return{
id="ef00.thermostats.trv_2",registrations=H,}
