local b=require"protocol.zcl"
local F=require"contracts.helpers.family"
local g=require"capabilities.events.all"
local O=require"st.capabilities"
local c=require"st.zigbee.data_types"
local x=require"st.zigbee.device_management"
local W=require"st.zigbee.cluster_base"
local S=require"contracts.helpers.zcl_sensor_definitions"
local f=F.create_fingerprint
local t,ae=F.definition_registry()
local function a(ab,ag)
ae(ab,ag)
end
local function e(ad)
return function(X,A)
for _,aa in ipairs(ad)do
for _,L in ipairs(aa.clusters)do
A:send(x.build_bind_request(
A,L,X.environment_info.hub_zigbee_eui,aa.endpoint))
end
end
end
end
local function h(H)
H.minimum_interval=nil
H.maximum_interval=nil
H.reportable_change=nil
H.read_on_configure=false
return H
end
local ah={
profile="safety-motion-battery",zcl_clusters={
b.motion(),b.battery(),},}local K={
profile="safety-motion-battery-low-battery-voltage",zcl_clusters={
b.motion(),b.battery_low(),b.battery(),b.battery_voltage(),},}local G={
profile="safety-motion-battery-low-battery-voltage-ewelink-pending",zcl_clusters={
h(b.motion()),h(b.battery_low()),b.battery({
minimum_interval=3600,maximum_interval=7200,}),b.battery_voltage({
minimum_interval=3600,maximum_interval=7200,reportable_change=100,}),},}local o={
profile="safety-motion-battery-low-battery-voltage-3rms-pending",zcl_clusters={
b.motion(),b.battery_low(),b.battery(),b.battery_voltage(),},}local m={
profile="safety-motion-battery-low-battery-voltage-3rsmr-pending",zcl_clusters={
b.motion(),b.battery_low(),b.battery(),b.battery_voltage(),},}local k={
profile="safety-motion-battery-3rps-pending",zcl_clusters={
b.motion(),b.battery(),b.cluster_attribute(65281,96,{
name="rps_sensitivity",endpoint=1,mfg_code=5127,data_type=c.Uint8,write_type=c.Uint8,read_on_configure=true,emit=g.rpsSensitivity(),}),b.cluster_attribute(65281,3,{
name="rps_calibration",endpoint=1,mfg_code=5127,data_type=c.Uint8,write_type=c.Uint8,read_on_configure=true,emit=g.rpsCalibration(),
from_device=function(d)return d==1 and"Press"or nil end,
to_device=function(d)return d=="Press"and 1 or nil end,
}),},}local i={
profile="safety-motion-tamper-battery-battery-low",zcl_clusters={
b.motion(),b.tamper(),b.battery_low(),b.battery(),},}local j={
profile="safety-motion-illuminance",zcl_clusters={
b.occupancy({emit=g.motion()}),b.illuminance(),},}local V={
profile="safety-motion-illuminance-battery",zcl_clusters={
b.motion(),b.illuminance(),b.battery(),},}local n={
profile="safety-motion-illuminance-battery-candeo-pending",datapoints={
{dp=9,datatype=4,name="candeo_motion_sensitivity",emit=g.candeoMotionSensitivity(),
from_device=function(d)return({[0]="low","medium","high"})[d]end,
to_device=function(d)return({low=0,medium=1,high=2})[d]end},
{dp=10,datatype=4,name="candeo_motion_keep_time",emit=g.candeoMotionKeepTime(),
from_device=function(d)return({[0]="10","30","60","120"})[d]end,
to_device=function(d)return({["10"]=0,["30"]=1,["60"]=2,["120"]=3})[d]end},
{dp=102,datatype=2,name="candeo_light_interval",emit=g.candeoLightInterval("min")},},zcl_clusters={
b.tuya_magic_packet(),b.motion(),b.illuminance({configure_reporting=false,
converter={from=function(ao)
local R=10 ^((ao-1)/10000)if R<=2200 then R=-7.969192+0.0151988*R
elseif R<=2500 then R=-1069.189434+0.4950663*R
else R=78029.21628-61.73575*R+0.01223567*R*R end
return math.floor(math.max(1,R)+0.5)
end},
}),b.battery(),},}local E={
profile="safety-contact-battery",zcl_clusters={
b.contact(),b.battery(),},}local v={
profile="safety-contact-battery-low-battery",zcl_clusters={
b.contact(),b.battery_low(),b.battery(),},}local I={
profile="safety-contact-tamper-battery-low-battery",zcl_clusters={
b.contact_alarm_1_or_2(),b.tamper(),b.battery_low(),b.battery(),},}local C={
profile="safety-contact-battery-low-battery-voltage",zcl_clusters={
b.contact(),b.battery_low(),b.battery(),b.battery_voltage(),},}local y={
profile="safety-contact-battery-low-battery-voltage",zcl_clusters={
b.contact(),b.battery_low(),b.battery(),b.battery_voltage(),},}local z={
profile="safety-contact-battery-low-battery",zcl_clusters={
b.contact(),b.battery_low(),b.battery(),},}local T={
profile="safety-water-leak-battery",zcl_clusters={
b.water(),b.battery(),},}local p=S.water_battery_low_battery_sensor
local l={
profile="safety-water-leak-battery-low-battery-3rws18bz-pending",zcl_clusters={
b.water(),b.battery_low(),b.battery(),},}local M={
profile="sensors-temp-humidity-battery",zcl_clusters={
b.temperature(),b.humidity(),b.battery(),},}local s={
profile="sensors-temp-humidity-battery-voltage",zcl_clusters={
b.temperature(),b.humidity(),b.battery(),b.battery_voltage(),},}local u={
profile="sensors-temp-humidity-battery-voltage",zcl_clusters={
b.temperature({endpoint=38}),b.humidity({endpoint=38}),b.battery({endpoint=38}),b.battery_voltage({endpoint=38}),},configure=e({
{endpoint=38,clusters={1026,1029,1}},}),}local w={
profile="sensors-temp-humidity-battery-3rths-pending",zcl_clusters={
b.temperature(),b.humidity(),b.battery(),},}local r={
profile="sensors-temp-humidity-battery-3rths0324-pending",advanced_remote=true,zcl_clusters={
b.temperature(),b.humidity(),b.battery(),b.cluster_attribute(65281,49,{
name="third_rths0324_celsius_calibration",emit=g.thirdRths0324CelsiusCal(),data_type=c.Int16,scale=100,mfg_code=5127,minimum_interval=0,maximum_interval=3600,reportable_change=100,}),b.cluster_attribute(65281,50,{
name="third_rths0324_humidity_calibration",emit=g.thirdRths0324HumidityCal(),data_type=c.Int16,scale=100,mfg_code=5127,minimum_interval=0,maximum_interval=3600,reportable_change=100,}),b.cluster_attribute(65281,51,{
name="third_rths0324_fahrenheit_calibration",emit=g.thirdRths0324FahrenheitCal(),data_type=c.Int16,scale=100,mfg_code=5127,minimum_interval=0,maximum_interval=3600,reportable_change=100,}),},}local N={
profile="sensors-temp-humidity-battery",zcl_clusters={
b.temperature({endpoint=1}),b.humidity({endpoint=2}),b.battery({endpoint=2}),},configure=e({
{endpoint=1,clusters={1026}},{endpoint=2,clusters={1029,1}},}),}local Q={
profile="sensors-temp-humidity-battery",zcl_clusters={
b.temperature({endpoint=1}),b.humidity({endpoint=2}),b.battery({endpoint=1}),},configure=e({
{endpoint=1,clusters={1026,1}},{endpoint=2,clusters={1029}},}),}local B={
profile="sensors-temp-humidity-battery-zg9032b",zcl_clusters={
b.temperature({endpoint=1}),b.humidity({endpoint=2}),b.battery({endpoint=1}),b.cluster_attribute(1026,4096,{
name="zg9032b_temperature_compensation",endpoint=1,emit=g.zg9032bTemperatureCompensation(),data_type=c.Int8,write_type=c.Int8,mfg_code=4644,numeric_range={minimum=-5,maximum=5,step=1,unit="C"},read_on_configure=true,}),b.cluster_attribute(1026,4097,{
name="zg9032b_temperature_display_unit",endpoint=1,emit=g.zg9032bTemperatureDisplayUnit(),data_type=c.Enum8,write_type=c.Enum8,mfg_code=4644,
from_device=function(d)
return({[0]="celsius",[1]="fahrenheit"})[d]
end,
to_device=function(d)
return({celsius=0,fahrenheit=1})[d]
end,
read_on_configure=true,}),b.cluster_attribute(1029,4096,{
name="zg9032b_humidity_compensation",endpoint=2,emit=g.zg9032bHumidityCompensation(),data_type=c.Int8,write_type=c.Int8,mfg_code=4644,numeric_range={minimum=-5,maximum=5,step=1,unit="%"},read_on_configure=true,}),},configure=e({
{endpoint=1,clusters={1026,1}},{endpoint=2,clusters={1029}},}),}local ak={
profile="safety-smoke-detector-battery",zcl_clusters={
b.smoke(),b.battery(),},}local D={
profile="safety-smoke-temp-tamper-battery-low-battery-voltage-schneider-pending",magic_packet=false,zcl_clusters={
b.smoke({minimum_interval=0,maximum_interval=65000,reportable_change=0,read_on_configure=true}),b.temperature({minimum_interval=10,maximum_interval=3600,reportable_change=100}),b.tamper({minimum_interval=0,maximum_interval=65000,reportable_change=0,read_on_configure=false}),b.battery_low({minimum_interval=0,maximum_interval=65000,reportable_change=0,read_on_configure=false,
emit=function(_,d)
return d and O.batteryLevel.battery.critical()or O.batteryLevel.battery.normal()
end}),
b.battery({minimum_interval=3600,maximum_interval=65000,reportable_change=10,
from_device=function(d,_,q)if q.raw_value~=255 then return d end end}),
b.battery_voltage({minimum_interval=3600,maximum_interval=65000,reportable_change=10,
from_device=function(d,_,q)if q.raw_value~=255 then return d end end}),
},}local ac={
profile="sensors-illuminance-battery",zcl_clusters={
b.illuminance(),b.battery(),},}local P={
profile="sensors-heiman-hs2aq-air-quality",zcl_clusters={
b.temperature(),b.humidity(),b.battery(),b.cluster_attribute(1066,0,{
name="pm25",emit=g.pm25(),data_type=c.Uint16,minimum_interval=0,maximum_interval=3600,reportable_change=1,}),b.cluster_attribute(1067,0,{
name="formaldehyde",emit=g.formaldehyde(),data_type=c.Uint16,scale=1000,minimum_interval=0,maximum_interval=3600,reportable_change=1,}),b.cluster_attribute(64641,61442,{
name="heiman_battery_state",emit=g.heimanHs2aqBatteryState(),data_type=c.Uint8,mfg_code=4619,
from_device=function(d)
return({[0]="not_charging",[1]="charging",[2]="charged"})[d]
end,
minimum_interval=0,maximum_interval=3600,reportable_change=1,}),b.cluster_attribute(64641,61443,{
name="heiman_pm10",emit=g.heimanHs2aqPm10(),data_type=c.Uint16,mfg_code=4619,minimum_interval=0,maximum_interval=3600,reportable_change=1,}),b.cluster_attribute(64641,61444,{
name="voc",emit=g.voc(),data_type=c.Uint16,mfg_code=4619,minimum_interval=0,maximum_interval=3600,reportable_change=1,}),b.cluster_attribute(64641,61445,{
name="heiman_aqi",emit=g.heimanHs2aqAqi(),data_type=c.Uint16,mfg_code=4619,minimum_interval=0,maximum_interval=3600,reportable_change=1,}),},
configure=function(X,A)
for _,L in ipairs({1,10,1026,1029,1066,1067,64641})do
A:send(x.build_bind_request(
A,L,X.environment_info.hub_zigbee_eui,1))
end
local am=os.time()local U,Y=os.date("*t",am),os.date("!*t",am)Y.isdst=U.isdst
local ai=os.difftime(os.time(U),os.time(Y))local tx
for _,af in ipairs({{1,c.Bitmap8(3)},{0,c.UtcTime(am-946684800)},{2,c.Int32(ai)}})do
local aj=W.write_attribute(A,c.ClusterId(10),c.AttributeId(af[1]),af[2])if tx then tx.body.zcl_body.attr_records[#tx.body.zcl_body.attr_records+1]=aj.body.zcl_body.attr_records[1]
else tx=aj end
end
A:send(tx:to_endpoint(1))
end,
}local Z={
profile="safety-contact-temp-battery",zcl_clusters={
b.cluster_attribute(15,85,{
name="contact",emit=g.contact(),data_type=c.SinglePrecisionFloat,
from_device=function(d)
return d==0
end,
minimum_interval=0,maximum_interval=300,reportable_change=1,}),b.temperature({scale=10}),b.cluster_attribute(b.CLUSTER_POWER_CONFIGURATION,b.ATTR_BATTERY_PERCENTAGE_REMAINING,{
name="battery",emit=g.battery(),data_type=c.Uint8,scale=1,minimum_interval=300,maximum_interval=21600,reportable_change=1,}),},}local J={
profile="safety-contact-battery",zcl_clusters={
h(b.contact({
endpoint=1,read_only=true,read_on_refresh=false,
from_device=function(_,_,q)
if q.command_id~=0 then return nil end
return bit32.band(q.raw_value,1)~=0
end,
})),b.cluster_attribute(b.CLUSTER_POWER_CONFIGURATION,b.ATTR_BATTERY_PERCENTAGE_REMAINING,{
name="battery",emit=g.battery(),data_type=c.Uint8,scale=2,
from_device=function(d,_,q)
if q.raw_value==255 then return nil end
return d
end,
minimum_interval=300,maximum_interval=21600,reportable_change=1,}),},}a(i,{
f("LDS","ZHA-PirSensor"),})a(j,{
f("Leedarson","ZHA-PIRSensor"),})a(G,{
f("eWeLink","CK-TLSR8656-SS5-01(7002)"),f("eWeLink","MS01"),f("eWeLink","MSO1"),f("eWeLink","SNZB-03"),f("SONOFF","CK-TLSR8656-SS5-01(7002)"),f("SONOFF","MS01"),f("SONOFF","MSO1"),f("SONOFF","SNZB-03"),})a(n,{
f("Candeo","C-ZB-SEMO"),})a(E,{
f("Candeo","C-ZB-SEDC"),})a(E,{
f("Sunricher","HK-SENSOR-CT-A"),})a(v,{
f("Sunricher","HK-SENSOR-CT-MINI"),})a(I,{
f("Shyugj","DoorSensor-ZB3.0"),})a(C,{
f("eWeLink","CK-TLSR8656-SS5-01(7003)"),f("eWeLink","SNZB-04"),})a(T,{
f("Candeo","C-ZB-SEWA"),})a(l,{
f("Third Reality, Inc","3RWS18BZ"),})a(T,{
f("Third Reality, Inc","3RWS0218Z"),})a(p,{
f("eWeLink","CK-TLSR8656-SS5-01(7019)"),f("eWeLink","SNZB-05"),})a(M,{
f("Candeo","C-ZB-SETE"),})a(u,{
f("Frient","HMSZB-120"),})a(w,{
f("Third Reality, Inc","3RTHS24BZ"),f("Third Reality, Inc","3RTHS0224Z"),})a(r,{
f("Third Reality, Inc","3RTHS0324Z"),})a(N,{
f("HEIMAN","HT-EM"),f("HEIMAN","TH-EM"),f("HEIMAN","TH-T_V14"),})a(Q,{
f("HEIMAN","HT-N"),f("HEIMAN","HT-EF-3.0"),f("HEIMAN","HS3HT-EFA-3.0"),})a(B,{
f("Sunricher","ZG9032B"),})a(s,{
f("eWeLink","CK-TLSR8656-SS5-01(7014)"),f("Zbeacon","TH01"),})a(P,{
f("HEIMAN","HS2AQ-EM"),f("HEIMAN","HS2AQ-EM-3.0"),})a(Z,{
f("TERNCY","TERNCY-DC01"),})a(J,{
f("Sunricher","TERNCY-DC01"),})a(D,{
f("Schneider Electric","755WSA"),f("Schneider Electric","W599501"),f("Schneider Electric","W599001"),})a(o,{
f("Third Reality, Inc","3RMS16BZ"),})a(m,{
f("Third Reality, Inc","3RSMR01067Z"),})a(k,{
f("Third Reality, Inc","3RPS01083Z"),})a(y,{
f("Third Reality, Inc","3RDS17BZ"),})a(z,{
f("Third Reality, Inc","3RDTS01056Z"),})b.attach_reporting_capabilities(t,{
{1,"rpt-txk"},{2,"rpt-zcl"},{3,"rpt-cep"},{4,"rpt-cgl"},{5,"rpt-cvm"},{6,"rpt-cvm"},{7,"rpt-hqa"},{8,"rpt-rab"},{9,"rpt-tku"},{10,"rpt-cxv"},{11,"rpt-tml"},{12,"rpt-cxv"},{13,"rpt-tml"},{14,"rpt-tgdf"},{15,"rpt-sgy"},{16,"rpt-tgdf"},{17,"rpt-zkk"},{18,"rpt-tgdf"},{19,"rpt-tgdf"},{20,"rpt-zzw"},{21,"rpt-sgy"},{22,"rpt-hlk"},{23,"rpt-trc",{["zr000f0055auto"]=false}},{24,"rpt-tcg"},{25,"rpt-zxh"},{26,"rpt-tctq"},{27,"rpt-tctq"},{28,"rpt-zjr"},{29,"rpt-tku"},{30,"rpt-hqa"},})return{
id="zcl.sensors.retail_sensors",registrations=t,}
