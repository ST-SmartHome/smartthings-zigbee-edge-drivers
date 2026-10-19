local c=require"protocol.zcl"
local b=require"contracts.helpers.family"
local l=require"contracts.helpers.zcl"
local o=require"capabilities.events.all"
local e=require"st.zigbee.data_types"
local m=require"st.zigbee.device_management"
local j,a=b.definition_registry()
local function d(q,r)
return function(z,x)
for endpoint=1,q do
local n={
c.CLUSTER_ON_OFF,c.CLUSTER_ELECTRICAL_MEASUREMENT,c.CLUSTER_SIMPLE_METERING,}
if r then table.insert(n,2,c.CLUSTER_LEVEL_CONTROL)end
for _,w in ipairs(n)do
x:send(m.build_bind_request(
x,w,z.environment_info.hub_zigbee_eui,endpoint))
end
end
end
end
local u={
profile="plugs-switch-power-energy-voltage-current",zcl_clusters=l.metering_clusters({
include_switch=true,include_current=true,}),configure=d(1,false),}local k={
profile="plugs-shelly-power-strip-4",zcl_clusters={},configure=d(4,false),}for endpoint=1,4 do
local i=endpoint==1 and"main"or("switch"..endpoint)for _,y in ipairs({
c.switch({endpoint=endpoint,component=i}),c.power({endpoint=endpoint,component=i}),c.energy({endpoint=endpoint,component=i}),c.voltage({endpoint=endpoint,component=i}),c.current({endpoint=endpoint,component=i}),})do
k.zcl_clusters[#k.zcl_clusters+1]=y
end
end
local t={
profile="lights-dimmer-power-voltage-current",zcl_clusters={
c.switch(),c.level(),c.power(),c.voltage(),c.current(),c.energy(),},configure=d(1,true),}local v={
profile="safety-water-leak-tamper-battery-low-battery-hardware-fault-shelly",zcl_clusters={
c.water(),c.tamper(),c.battery_low(),c.hardware_fault(),c.battery(),},}local s={
profile="sensors-temp-humidity-battery",zcl_clusters={
c.temperature(),c.humidity(),c.battery(),},}local p={
profile="sensors-weather-temp-humidity-pressure-illuminance-battery-ws90",zcl_clusters={
c.temperature(),c.humidity(),c.pressure({minimum_interval=10,maximum_interval=3600,reportable_change=5,read_only=true}),c.illuminance(),c.battery(),c.battery_voltage(),c.cluster_attribute(1,64,{
name="ws90_capacitor_voltage",endpoint=1,data_type=e.Uint8,read_only=true,scale=10,minimum_interval=10,maximum_interval=3600,reportable_change=1,read_on_configure=true,emit=o.shellyWs90CapacitorVoltage(),}),c.cluster_attribute(64513,0,{
name="ws90_wind_speed",emit=o.shellyWs90WindSpeed(),data_type=e.Uint16,scale=10,read_only=true,
from_device=function(h,_,g)if g.raw_value~=65535 then return h end end,
mfg_code=5264,minimum_interval=10,maximum_interval=3600,reportable_change=1,read_on_configure=true,}),c.cluster_attribute(64513,4,{
name="ws90_wind_direction",emit=o.ws90WindDirection(),data_type=e.Uint16,scale=10,read_only=true,
from_device=function(h,_,g)if g.raw_value~=65535 then return h end end,
mfg_code=5264,minimum_interval=10,maximum_interval=3600,reportable_change=1,read_on_configure=true,}),c.cluster_attribute(64513,7,{
name="ws90_gust_speed",emit=o.shellyWs90GustSpeed(),data_type=e.Uint16,scale=10,read_only=true,
from_device=function(h,_,g)if g.raw_value~=65535 then return h end end,
mfg_code=5264,minimum_interval=10,maximum_interval=3600,reportable_change=1,read_on_configure=true,}),c.cluster_attribute(64514,0,{
name="ws90_uv_index",emit=o.shellyWs90UvIndex(),data_type=e.Uint8,scale=10,read_only=true,
from_device=function(h,_,g)if g.raw_value~=255 then return h end end,
mfg_code=5264,minimum_interval=10,maximum_interval=3600,reportable_change=1,read_on_configure=true,}),c.cluster_attribute(64515,0,{
name="ws90_rain_status",read_only=true,emit=o.ws90RainStatus(),data_type=e.Boolean,mfg_code=5264,
from_device=function(h)return h and"raining"or"dry"end,
minimum_interval=10,maximum_interval=3600,reportable_change=1,read_on_configure=true,}),c.cluster_attribute(64515,1,{
name="ws90_precipitation",emit=o.shellyWs90Precipitation(),data_type=e.Uint24,scale=10,read_only=true,
from_device=function(h,_,g)if g.raw_value~=0xFFFFFF then return h end end,
mfg_code=5264,minimum_interval=10,maximum_interval=3600,reportable_change=1,read_on_configure=true,}),},}a(u,{
b.create_fingerprint("Shelly","Plug US"),})a(k,{
b.create_fingerprint("Shelly","Power Strip"),})a(t,{
b.create_fingerprint("Shelly","Dimmer"),b.create_fingerprint("Shelly","Dimmer US"),})a(v,{
b.create_fingerprint("Shelly","Flood"),b.create_fingerprint("Shelly","Flood S"),})a(s,{
b.create_fingerprint("Shelly","BLU H&T ZB"),})a(p,{
b.create_fingerprint("Shelly","Ecowitt WS90"),})c.attach_reporting_capabilities(j,{
{1,"rpt-tcb"},{2,"rpt-pob",{["zr000600001"]="Switch",["zr000600002"]="SwitchTwo",["zr000600003"]="SwitchThree",["zr000600004"]="SwitchFour",["zr0b0405051"]="Voltage",["zr0b0405052"]="VoltageTwo",["zr0b0405053"]="VoltageThree",["zr0b0405054"]="VoltageFour",["zr0b0405081"]="Current",["zr0b0405082"]="CurrentTwo",["zr0b0405083"]="CurrentThree",["zr0b0405084"]="CurrentFour",["zr0b04050b1"]="Power",["zr0b04050b2"]="PowerTwo",["zr0b04050b3"]="PowerThree",["zr0b04050b4"]="PowerFour"}},{3,"rpt-hll"},{4,"rpt-fwi"},{5,"rpt-tgdf"},{6,"rpt-ead"},})return{
id="zcl.sensors.shelly_retail",registrations=j,}
