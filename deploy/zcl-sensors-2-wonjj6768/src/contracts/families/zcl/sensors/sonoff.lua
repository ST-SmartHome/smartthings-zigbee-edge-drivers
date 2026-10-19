local p=require"protocol.zcl"
local at=require"capabilities.events.all"
local o=require"st.capabilities"
local T=require"contracts.helpers.family"
local U=T.create_fingerprint
local X=require"st.zigbee.device_management"
local a=require"st.zigbee.data_types"
local K,h=T.definition_registry()local ae=1
local V=32
local G=1026
local Z=1027
local N=1029
local i=1030
local C=1280
local F=64529
local M=4742
local l=0
local B=2
local aa=0
local k=32
local x=33
local L=34
local function J(capability_id)
return assert(at[capability_id],"missing SONOFF emitter: "..capability_id)()
end
local function f(aI,A)
A:send(X.build_bind_request(
A,V,aI.environment_info.hub_zigbee_eui,1))
end
local function E(d)
d=d or{}return p.battery({
endpoint=1,minimum_interval=d.minimum_interval or 3600,maximum_interval=d.maximum_interval or 65000,reportable_change=d.reportable_change==nil and 10 or d.reportable_change,read_only=true,})
end
local function P(d)
d=d or{}return p.battery_voltage({
endpoint=1,minimum_interval=d.minimum_interval or 3600,maximum_interval=d.maximum_interval or 65000,reportable_change=d.reportable_change==nil and 10 or d.reportable_change,read_only=true,})
end
local function m(d)
d=d or{}return p.temperature({
endpoint=1,minimum_interval=d.minimum_interval or 10,maximum_interval=d.maximum_interval or 3600,reportable_change=d.reportable_change==nil and 100 or d.reportable_change,read_only=true,handler=d.handler,})
end
local function H(d)
d=d or{}return p.humidity({
endpoint=1,minimum_interval=d.minimum_interval or 10,maximum_interval=d.maximum_interval or 3600,reportable_change=d.reportable_change==nil and 100 or d.reportable_change,read_only=true,handler=d.handler,})
end
local function c(au,capability_id,ah,af,aA,az,aM)
return p.cluster_attribute(F,ah,{
name=au,endpoint=1,emit=J(capability_id),data_type=af,write_type=af,scale=100,
to_device=function(b)
return type(b)=="number"and b+1e-9 or b
end,
numeric_range={minimum=aA,maximum=az,step=0.1,unit=aM},read_on_configure=true,})
end
local function w(au,capability_id)
local an={[0]="celsius",[1]="fahrenheit"}local aq={celsius=0,fahrenheit=1}return p.cluster_attribute(F,7,{
name=au,endpoint=1,emit=J(capability_id),data_type=a.Uint16,write_type=a.Uint16,
from_device=function(b)return an[b]end,
to_device=function(b)return aq[b]end,
read_on_configure=true,})
end
local aE={
profile="sonoff-snzb02p-temp-humidity",zcl_clusters={
m(),H(),E(),c(
"sonoff_snzb02p_temperature_calibration","sonoffSnzb02pTemperatureCal",8195,a.Int16,-50,50,"C"),c(
"sonoff_snzb02p_humidity_calibration","sonoffSnzb02pHumidityCal",8196,a.Int16,-50,50,"%"),},configure=f,}h(aE,{
U("eWeLink","SNZB-02P"),U("SONOFF","SNZB-02P"),})local aC={
profile="sonoff-snzb02d-temp-humidity-display",zcl_clusters={
m(),H(),E(),c(
"sonoff_snzb02d_comfort_temperature_min","sonoffSnzb02dComfortTempMin",4,a.Int16,-10,60,"C"),c(
"sonoff_snzb02d_comfort_temperature_max","sonoffSnzb02dComfortTempMax",3,a.Int16,-10,60,"C"),c(
"sonoff_snzb02d_comfort_humidity_min","sonoffSnzb02dComfortHumidityMin",5,a.Uint16,5,95,"%"),c(
"sonoff_snzb02d_comfort_humidity_max","sonoffSnzb02dComfortHumidityMax",6,a.Uint16,5,95,"%"),w("sonoff_snzb02d_temperature_units","sonoffSnzb02dTemperatureUnits"),c(
"sonoff_snzb02d_temperature_calibration","sonoffSnzb02dTemperatureCal",8195,a.Int16,-50,50,"C"),c(
"sonoff_snzb02d_humidity_calibration","sonoffSnzb02dHumidityCal",8196,a.Int16,-50,50,"%"),},configure=f,}h(aC,{
U("SONOFF","SNZB-02D"),})local av={
profile="sonoff-snzb02ld-temperature-display",zcl_clusters={
m({minimum_interval=5,maximum_interval=3600,reportable_change=20}),E(),w("sonoff_snzb02ld_temperature_units","sonoffSnzb02ldTemperatureUnits"),c(
"sonoff_snzb02ld_temperature_calibration","sonoffSnzb02ldTemperatureCal",8195,a.Int16,-50,50,"C"),},configure=f,}h(av,{
U("SONOFF","SNZB-02LD"),})local aw={
profile="sonoff-snzb02wd-temp-humidity-display",zcl_clusters={
m({minimum_interval=5,maximum_interval=3600,reportable_change=20}),H({minimum_interval=5,maximum_interval=3600,reportable_change=100}),E(),P(),w("sonoff_snzb02wd_temperature_units","sonoffSnzb02wdTemperatureUnits"),c(
"sonoff_snzb02wd_temperature_calibration","sonoffSnzb02wdTemperatureCal",8195,a.Int16,-50,50,"C"),c(
"sonoff_snzb02wd_humidity_calibration","sonoffSnzb02wdHumidityCal",8196,a.Int16,-50,50,"%"),},configure=f,}h(aw,{
U("SONOFF","SNZB-02WD"),})local ak={
profile="sonoff-ewelink-7014-temp-humidity",zcl_clusters={
m(),H(),E(),},}h(ak,{
U("eWeLink","CK-TLSR8656-SS5-02(7014)"),})local aF={
profile="sonoff-snzb03p-occupancy",zcl_clusters={
p.occupancy({
endpoint=1,minimum_interval=0,maximum_interval=3600,reportable_change=0,read_on_configure=true,read_only=true,}),p.cluster_attribute(i,k,{
name="sonoff_snzb03p_motion_timeout",endpoint=1,emit=J("sonoffSnzb03pMotionTimeout"),data_type=a.Uint16,write_type=a.Uint16,numeric_range={minimum=5,maximum=60,step=1,unit="s"},read_on_configure=true,}),p.cluster_attribute(F,8193,{
name="sonoff_snzb03p_illumination",endpoint=1,emit=J("sonoffSnzb03pIllumination"),data_type=a.Uint8,mfg_code=M,
from_device=function(b)return({[0]="dim",[1]="bright"})[b]end,
read_only=true,read_on_configure=false,read_on_refresh=false,}),E({maximum_interval=7200,reportable_change=2}),P({maximum_interval=7200,reportable_change=100}),},}h(aF,{
U("eWeLink","SNZB-03P"),U("SONOFF","SNZB-03P"),})local aJ={
profile="sonoff-mg35rz-occupancy",zcl_clusters={
p.cluster_attribute(i,aa,{
name="occupancy",endpoint=1,emit=at.occupancy(),data_type=a.Bitmap8,
from_device=function(b)
b=type(b)=="table"and b.value or b
if type(b)~="number"then return nil end
return b%2==1
end,
read_only=true,read_on_configure=false,}),p.cluster_attribute(i,k,{
name="sonoff_mg35rz_occupied_delay",endpoint=1,emit=J("sonoffMg35rzOccupiedDelay"),data_type=a.Uint16,write_type=a.Uint16,numeric_range={minimum=60,maximum=65535,step=1,unit="s"},read_on_configure=true,}),p.cluster_attribute(i,x,{
name="sonoff_mg35rz_unoccupied_delay",endpoint=1,emit=J("sonoffMg35rzUnoccupiedDelay"),data_type=a.Uint16,write_type=a.Uint16,numeric_range={minimum=0,maximum=65535,step=1,unit="s"},read_on_configure=true,}),p.cluster_attribute(i,L,{
name="sonoff_mg35rz_sensitivity",endpoint=1,emit=J("sonoffMg35rzSensitivity"),data_type=a.Uint8,write_type=a.Uint8,
from_device=function(b)return({[1]="low",[2]="medium",[3]="high"})[b]end,
to_device=function(b)return({low=1,medium=2,high=3})[b]end,
read_on_configure=true,}),},}h(aJ,{
U("eWeLink","CK-BL702-MWS-01(7016)"),U("SONOFF","MG1_5RZ"),})
local function W(aL)
return function(A,b)
A:set_field(aL,b,{persist=false})
end
end
local function ay(b,aH)
local al=10 ^ aH
local am=b*al
if am>=0 then
return math.floor(am+0.5)/al
end
return math.ceil(am-0.5)/al
end
local function n(Y,ab,capability_id)
local ar=J(capability_id)
return function(A)
local j=A:get_field(Y)local v=A:get_field(ab)if type(j)~="number"or type(v)~="number"then
return nil
end
local ag=0.61078*math.exp((17.27*j)/(j+237.3))local aG=(v/100)*ag
local aj={ar(A,ay(ag-aG,2))}if v>0 then
local ax=(17.27*j)/(j+237.7)+math.log(v/100)local ap=ay((237.7*ax)/(17.27-ax),1)aj[#aj+1]=o.dewPoint.dewpoint({value=ap,unit="C"})
end
return aj
end
end
local s="__sonoff_snzb02m_temperature"
local z="__sonoff_snzb02m_humidity"
local u=n(
s,z,"sonoffSnzb02mVpd")local aD={
profile="sonoff-snzb02m-environment",zcl_clusters={
m({
minimum_interval=5,reportable_change=20,handler=W(s),}),H({
minimum_interval=5,reportable_change=100,handler=W(z),}),E(),p.cluster_attribute(Z,4,{
name="pressure",endpoint=1,
emit=function(_,b)
return o.atmosphericPressureMeasurement.atmosphericPressure({value=b,unit="hPa"})
end,
data_type=a.Int32,scale=100,minimum_interval=5,maximum_interval=3600,reportable_change=50,read_only=true,read_on_configure=true,}),c(
"sonoff_snzb02m_temperature_calibration","sonoffSnzb02mTemperatureCal",8195,a.Int16,-50,50,"C"),c(
"sonoff_snzb02m_humidity_calibration","sonoffSnzb02mHumidityCal",8196,a.Int16,-50,50,"%"),c(
"sonoff_snzb02m_pressure_calibration","sonoffSnzb02mPressureCal",8199,a.Int16,-200,200,"hPa"),p.cluster_attribute(G,l,{
name="sonoff_snzb02m_vpd",endpoint=1,emit=u,data_type=a.Int16,scale=100,read_only=true,read_on_configure=false,}),p.cluster_attribute(N,l,{
name="sonoff_snzb02m_calculated_humidity_trigger",endpoint=1,emit=u,data_type=a.Uint16,scale=100,read_only=true,read_on_configure=false,}),},configure=f,}h(aD,{
U("SONOFF","SNZB-02M"),})local r="__sonoff_snzb02b_temperature"
local y="__sonoff_snzb02b_humidity"
local t=n(
r,y,"sonoffSnzb02bVpd")local aB={
profile="sonoff-snzb02b-environment",zcl_clusters={
m({
minimum_interval=5,reportable_change=20,handler=W(r),}),H({
minimum_interval=5,reportable_change=100,handler=W(y),}),E(),c(
"sonoff_snzb02b_temperature_calibration","sonoffSnzb02bTemperatureCal",8195,a.Int16,-50,50,"C"),c(
"sonoff_snzb02b_humidity_calibration","sonoffSnzb02bHumidityCal",8196,a.Int16,-50,50,"%"),p.cluster_attribute(G,l,{
name="sonoff_snzb02b_vpd",endpoint=1,emit=t,data_type=a.Int16,scale=100,read_only=true,read_on_configure=false,}),p.cluster_attribute(N,l,{
name="sonoff_snzb02b_calculated_humidity_trigger",endpoint=1,emit=t,data_type=a.Uint16,scale=100,read_only=true,read_on_configure=false,}),},configure=f,}h(aB,{
U("SONOFF","SNZB-02B"),})
local function q(ao)
local as=ao and ao.body and ao.body.zcl_body or nil
local I=as and(as.zone_status or as.zonestatus)or nil
local b=type(I)=="table"and I.value or I
return{raw_value=b,typed_value=I}
end
local aN={
profile="sonoff-ws01-rain",zcl_clusters={
p.cluster_attribute(C,B,{
name="rain",endpoint=1,
emit=function(_,b)
return b=="possiblePrecipitation"
and o.precipitationSensor.precipitationIntensity.possiblePrecipitation()or o.precipitationSensor.precipitationIntensity.none()
end,
data_type=a.Bitmap16,
from_device=function(b)
b=type(b)=="table"and b.value or b
if type(b)~="number"then return nil end
return b%2==1 and"possiblePrecipitation"or"none"
end,
command_id=0,command_extractor=q,read_only=true,read_on_configure=false,}),},}h(aN,{
U("eWeLink","WS01"),})
local function R(A,aK)
return p.read_configured_attributes(A,aK.zcl_clusters)
end
local function Q(D,ai)
return p.battery({
endpoint=1,minimum_interval=3600,maximum_interval=D,reportable_change=ai,read_only=true,
from_device=function(b)
if type(b)=="number"and b>=0 and b<127.5 then return b end
end,
})
end
local function S(D,ai)
return p.battery_voltage({
endpoint=1,minimum_interval=3600,maximum_interval=D,reportable_change=ai,read_only=true,
from_device=function(b)
if type(b)=="number"and b>=0 and b<25.5 then return b end
end,
})
end
local ac={
profile="sonoff-snzb02-classic-temp-humidity",magic_packet=false,zcl_clusters={
p.temperature({
endpoint=1,minimum_interval=30,maximum_interval=3600,reportable_change=20,read_on_configure=false,read_only=true,
from_device=function(b)
if type(b)=="number"and b>-33 and b<100 then return b end
end,
}),p.humidity({
endpoint=1,minimum_interval=30,maximum_interval=3600,reportable_change=100,read_on_configure=false,read_only=true,
from_device=function(b)
if type(b)=="number"and b>=0 and b<=100 then return b end
end,
}),Q(65000,0),S(65000,0),},parent_refresh=R,}h(ac,{
U("SONOFF","SNZB-02"),U("SONOFF","TH01"),U("SONOFF","CK-TLSR8656-SS5-01(7014)"),U("eWeLink","TH01"),})
local function O(aO)
return function(b)
b=type(b)=="table"and b.value or b
if type(b)~="number"or b<0 or b>65535 or b%1~=0 then return nil end
return math.floor(b/(2 ^ aO))%2==1
end
end
local ad={
profile="sonoff-snzb04-classic-contact",magic_packet=false,zcl_clusters={
p.cluster_attribute(C,B,{
name="contact",endpoint=1,emit=at.contact(),data_type=a.Bitmap16,from_device=O(0),command_id=0,command_extractor=q,ias_configure_method=0,read_only=true,read_on_configure=false,}),p.cluster_attribute(C,B,{
name="battery_low",endpoint=1,
emit=function(_,b)
return b and o.batteryLevel.battery.critical()or o.batteryLevel.battery.normal()
end,
data_type=a.Bitmap16,from_device=O(3),command_id=0,command_extractor=q,ias_configure_method=0,read_only=true,read_on_configure=false,}),Q(7200,2),S(7200,100),},parent_refresh=R,}h(ad,{
U("SONOFF","SNZB-04"),U("SONOFF","DS01"),U("SONOFF","CK-TLSR8656-SS5-01(7003)"),})p.attach_reporting_capabilities(K,{
{1,"rpt-slf"},{2,"rpt-spr"},{3,"rpt-sxo"},{4,"rpt-swu"},{5,"rpt-lrf"},{6,"rpt-smq"},{8,"rpt-son"},{9,"rpt-scz"},{11,"rpt-sxh"},{12,"rpt-svu"},})return{
id="zcl.sensors.sonoff",registrations=K,}
