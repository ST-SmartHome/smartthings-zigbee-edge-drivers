local c=require"protocol.zcl"
local j=require"capabilities.events.all"
local d=require"st.capabilities"
local f=require"st.zigbee.data_types"
local k=require"st.zigbee.device_management"
local V=require"st.zigbee.zcl.clusters"
local aj=require"st.zigbee.cluster_base"
local aL=require"contracts.helpers.family"
local m=aL.create_fingerprint
local Y,h=aL.definition_registry()
local function g(q)
q.minimum_interval=nil
q.maximum_interval=nil
q.reportable_change=nil
q.read_on_configure=false
return q
end
local function e(a,_,context)
if context.raw_value==255 then return nil end
return a
end
local aJ={
profile="safety-contact-temp-humidity-battery",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1026,0,1)c.read_attribute(b,1029,0,1)c.read_attribute(b,1,33,1)
end,
zcl_clusters={
g(c.contact({endpoint=1})),c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,from_device=e}),},
configure=function(n,b)
b:send(k.build_bind_request(
b,1280,n.environment_info.hub_zigbee_eui,1))
end,
}h(aJ,{
m("AduroSmart ERIA","CSW_81909"),m("ERIA","CSW_81909"),m("AduroSmart Eria","CSW_81909"),})local bv={
profile="safety-contact-trust808",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)
end,
zcl_clusters={
g(c.contact({endpoint=1,from_device=function(a)
if type(a)=="table"then
if type(a.is_alarm1_set)=="function"then return a:is_alarm1_set()end
a=a.value
end
if type(a)~="number"then return nil end
return(a&1)~=0
end})),
g(c.tamper({endpoint=1})),g(c.battery_low({endpoint=1,name="trust808_battery_low",emit=j.trust808BatteryLow()})),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=e}),},}h(bv,{
m("Trust International B.V.","CSW_ADUROLIGHT"),m("Trust International B.V.\0","CSW_ADUROLIGHT"),m("ADUROLIGHT","CSW_ADUROLIGHT"),})local bL={
profile="sensors-rtitek-sthzb-core",magic_packet=false,zcl_clusters={
c.cluster_attribute(1026,0,{name="temperature",endpoint=1,data_type=f.Int16,scale=100,read_only=true,read_on_configure=true,emit=j.temperature()}),c.cluster_attribute(1029,0,{name="humidity",endpoint=1,data_type=f.Uint16,scale=100,read_only=true,read_on_configure=true,emit=j.humidity()}),c.cluster_attribute(1,33,{name="battery",endpoint=1,data_type=f.Uint8,scale=2,read_only=true,read_on_configure=true,from_device=e,emit=j.battery()}),},
configure=function(_,b)c.read_attribute(b,1,32,1)end,
parent_refresh=function(b)
c.read_attribute(b,1026,0,1)c.read_attribute(b,1029,0,1)c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
}h(bL,{
m("Rti-Tek","STHZB"),})local bD={
profile="safety-water-ezviz-cst10c-core",magic_packet=false,zcl_clusters={
g(c.water({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
g(c.tamper({endpoint=1})),
g(c.battery_low({endpoint=1,emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
}h(bD,{
m("EZVIZ","CS-T10C-A0-BG"),m("EZVIZ","CS-T10C-A0-BG\000\000\000\000"),})local bX={
profile="safety-presence-owon-ocp305-core",magic_packet=false,zcl_clusters={
c.cluster_attribute(1030,0,{name="owon_ocp305_presence",endpoint=1,data_type=f.Bitmap8,read_only=true,read_on_configure=true,minimum_interval=0,maximum_interval=3600,reportable_change=0,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,emit=j.presence()}),
},}h(bX,{
m("OWON","OCP305"),})local bH={
profile="safety-presence-multir-he300-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1024,0,1)
end,
zcl_clusters={
g(c.occupancy({name="multir_he300_presence",endpoint=1,emit=j.presence(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&3)~=0
end})),
c.illuminance({name="multir_he300_illuminance",endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),},}h(bH,{
m("MultIR","HE300_ZB"),})local aN={
profile="sensors-zigbeetlc-zg303z-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=10}),c.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.cluster_attribute(1029,0,{name="zg303z_soil_moisture",endpoint=2,component="main",data_type=f.Uint16,scale=100,read_only=true,read_on_configure=true,minimum_interval=10,maximum_interval=3600,reportable_change=100,
from_device=function(a,_,context)if context.raw_value~=65535 then return a end end,
emit=j.zg303zSoilMoisture()}),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),},}h(aN,{
m("Sonoff","ZG-303Z-z"),})local bC={
profile="safety-presence-ekaza-ts0225-core",magic_packet=true,query_on_configure=false,query_on_announce=false,time_start="off",
parent_refresh=function()end,
zcl_clusters={
g(c.motion({name="ekaza_presence",endpoint=1,emit=j.presence()})),},
configure=function(_,b)
c.read_attribute(b,1280,2,1)
end,
}h(bC,{
m("_TZ3210_eep3fewj","TS0225"),})local aG={
profile="sensors-smartthings-tagv4-core",magic_packet=false,parent_refresh=function()end,
zcl_clusters={
c.cluster_attribute(15,85,{name="tagv4_heartbeat",endpoint=1,data_type=f.Boolean,read_only=true,read_on_configure=false,minimum_interval=10,maximum_interval=60,reportable_change=true,
emit=function(b)
local aa="tagv4_presence_timer";local ct=b:get_field(aa)
if ct then ct:cancel()end
b:set_field(aa,b.thread:call_with_delay(100,function()
b:set_field(aa,nil);b:emit_event(j.presence()(b,false))
end,"Tagv4 absent"))
return j.presence()(b,true)
end}),
c.cluster_attribute(1,32,{name="tagv4_voltage",endpoint=1,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,
emit=function(_,a)
if a==255 then return end
return{d.voltageMeasurement.voltage({value=a/10,unit="V"}),d.battery.battery(math.max(0,math.min(100,(a-25)*20)))}
end}),
c.cluster_attribute(1,62,{name="tagv4_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(aG,{
m("SmartThings","tagv4"),})
local function ba(b,a)
local D=type(a)=="table"and a.value or a
if D==nil then D=a end
if type(D)=="string"then
local cz,t={},1
while t+1<=#D do
local aa,J=D:byte(t,t+1)local width=J>=32 and J<=47 and((J%8)+1)or J==16 and 1
if not width or t+1+width>#D then break end
cz[aa]=string.unpack("<"..(J>=40 and"i"or"I")..width,D,t+2)t=t+2+width
end
D=cz
end
if type(D)~="table"then return end
local alarm=D[160]or D["160"]
if alarm~=nil then return j.gas()(b,alarm==1)end
end
local aO={
profile="safety-aqara-gas-acn02-core",magic_packet=false,zcl_clusters={
c.cluster_attribute(64704,314,{name="aqara_gas_alarm",endpoint=1,mfg_code=4447,data_type=f.Uint8,
read_only=true,read_on_configure=true,from_device=function(a)return a==1 end,emit=j.gas()}),
c.cluster_attribute(64704,247,{name="aqara_gas_heartbeat",endpoint=1,read_only=true,read_on_configure=false,emit=ba}),},
configure=function(_,b)
b:send(aj.write_manufacturer_specific_attribute(b,64704,331,4447,f.Uint8,1):to_endpoint(1))
end,
parent_refresh=function(b)
b:send(aj.read_manufacturer_specific_attribute(b,64704,314,4447):to_endpoint(1))
end,
}h(aO,{
m("LUMI","lumi.sensor_gas.acn02"),})local aS={
profile="safety-frient-heszb120-core",magic_packet=false,zcl_clusters={
c.smoke({endpoint=35,component="main",minimum_interval=0,maximum_interval=65000,reportable_change=0,read_on_configure=true,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,emit=function(_,a)
return a and d.temperatureAlarm.temperatureAlarm.heat()or d.temperatureAlarm.temperatureAlarm.cleared()
end}),
g(c.battery_low({endpoint=35,component="main",emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
c.temperature({endpoint=38,component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100}),g(c.battery({endpoint=35,component="main",from_device=e})),c.cluster_attribute(1,32,{name="heszb120_voltage",endpoint=35,component="main",data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
emit=function(_,a)
if a==255 then return end
return{d.voltageMeasurement.voltage({value=a/10,unit="V"}),d.battery.battery(math.max(0,math.min(100,(a-25)*20)))}
end}),
},
parent_refresh=function(b)
b:send(V.TemperatureMeasurement.attributes.MeasuredValue:read(b):to_endpoint(38))b:send(V.PowerConfiguration.attributes.BatteryPercentageRemaining:read(b):to_endpoint(35))b:send(V.PowerConfiguration.attributes.BatteryVoltage:read(b):to_endpoint(35))
end,
}h(aS,{
m("frient A/S","HESZB-120"),})local af={
profile="safety-tuya-ts0210-vibration-core",magic_packet=false,parent_refresh=function()end,
zcl_clusters={
g(c.motion({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,handler=function(b,_,context)
if context.command_id~=0 then return end
local aa="ts0210_core_clear_timer"
local ct=b:get_field(aa)
if ct then ct:cancel()end
b:set_field(aa,b.thread:call_with_delay(90,function()
b:set_field(aa,nil)b:emit_event(j.acceleration()(b,false))
end,"TS0210 clear"))
end,emit=function(b,a,context)
if context.command_id==0 then return j.acceleration()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=1,emit=function(_,a,context)
if context.command_id==0 then return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()end
end})),
g(c.battery({endpoint=1,from_device=e})),g(c.battery_voltage({endpoint=1,from_device=e})),c.cluster_attribute(1,62,{name="ts0210_core_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(af,{
m("_TYZB01_3zv6oleo","TS0210"),m("_TZ3000_bmfw9ykl","TS0210"),m("_TZ3000_fkxmyics","TS0210"),m("_TZ3000_jqge2fjx","TS0210"),m("_TZ3000_lqpt3mvr","TS0210"),})local bw={
profile="safety-visonic-gb540-core",magic_packet=false,parent_refresh=function()end,
zcl_clusters={
g(c.motion({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,emit=function(b,a,context)
if context.command_id==0 then return j.acceleration()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=1,emit=function(_,a,context)
if context.command_id==0 then return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()end
end})),
},}h(bw,{
m("Visonic","GB-540"),})local bU={
profile="safety-lumi-natgas-core",magic_packet=false,parent_refresh=function()end,
zcl_clusters={
g(c.gas({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,emit=function(b,a,context)
if context.command_id==0 then return j.gas()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=1,emit=function(_,a,context)
if context.command_id==0 then return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()end
end})),
},}h(bU,{
m("LUMI","lumi.sensor_natgas"),})local aY={
profile="safety-tuya-ts0204-gas-core",magic_packet=false,parent_refresh=function()end,
zcl_clusters={
g(c.gas({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,emit=function(b,a,context)
if context.command_id==0 then return j.gas()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=1,emit=function(_,a,context)
if context.command_id==0 then return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()end
end})),
},}h(aY,{
m("_TYZB01_18pkine6","TS0204"),m("_TYZB01_mfccmeio","TS0204"),})local bg={
profile="safety-feibit-sga01zb-core",magic_packet=false,parent_refresh=function()end,
zcl_clusters={
g(c.gas_alarm_2({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.gas()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=1,emit=function(_,a,context)
if context.command_id==0 then return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()end
end})),
},}h(bg,{
m("feibit","FNB56-GAS05FB1.4"),})local ca={
profile="safety-trust-co-em-core",magic_packet=false,parent_refresh=function()end,
zcl_clusters={
g(c.carbon_monoxide({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,emit=function(b,a,context)
if context.command_id==0 then return j.carbon_monoxide()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=1,emit=function(_,a,context)
if context.command_id==0 then return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()end
end})),
c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),c.cluster_attribute(1,62,{name="trust_co_battery_alarm",endpoint=1,data_type=f.Bitmap32,read_only=true,read_on_configure=false,
emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(ca,{
m("Trust","COSensor-EM"),})local bf={
profile="safety-feibit-sca01zb-core",magic_packet=false,parent_refresh=function()end,
zcl_clusters={
g(c.carbon_monoxide({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,emit=function(b,a,context)
if context.command_id==0 then return j.carbon_monoxide()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=1,emit=function(_,a,context)
if context.command_id==0 then return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()end
end})),
c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),c.cluster_attribute(1,62,{name="feibit_co_battery_alarm",endpoint=1,data_type=f.Bitmap32,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,
emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(bf,{
m("feibit","FNB56-COS06FB1.7"),m("Heiman","1ccaa94c49a84abaa9e38687913947ba"),})local bK={
profile="safety-motion-owon-pir313p-core",magic_packet=false,zcl_clusters={
g(c.occupancy({endpoint=1,ias_zone=true,emit=j.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
g(c.tamper({endpoint=1})),
g(c.battery_low({endpoint=1,emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},}h(bK,{
m("OWON","PIR313-P"),})local cr={
profile="safety-motion-tis-ed6xx-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
g(c.occupancy({endpoint=1,ias_zone=true,emit=j.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
g(c.tamper({endpoint=1})),
g(c.battery_low({endpoint=1,emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},}h(cr,{
m("JHL","ED6XX"),})local bJ={
profile="safety-motion-owon-pir313e-core",magic_packet=false,
configure=function(_,b)
for l in pairs(b.zigbee_endpoints)do
if b:supports_server_cluster(1024,l)then
c.read_attribute(b,1024,0,l)
end
end
end,
zcl_clusters={
g(c.occupancy({endpoint=1,ias_zone=true,emit=j.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
g(c.tamper({endpoint=1})),
g(c.battery_low({endpoint=1,emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),c.temperature({endpoint=2,component="main",minimum_interval=60,maximum_interval=3600,reportable_change=50,read_on_configure=false}),c.humidity({endpoint=2,component="main",minimum_interval=60,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.illuminance({component="main",minimum_interval=300,maximum_interval=3600,reportable_change=100,read_on_configure=false}),},}h(bJ,{
m("OWON","PIR313-E"),})local bj={
profile="safety-motion-owon-pir323pth-core",magic_packet=false,
configure=function(n,b)
b:send(k.build_bind_request(b,1026,n.environment_info.hub_zigbee_eui,2))b:send(k.build_bind_request(b,1029,n.environment_info.hub_zigbee_eui,2))
end,
zcl_clusters={
g(c.occupancy({endpoint=1,ias_zone=true,emit=j.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
g(c.battery_low({endpoint=1,emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
g(c.temperature({endpoint=2,component="main"})),g(c.humidity({endpoint=2,component="main"})),},}h(bj,{
m("OWON","PIR323-PTH"),})local bG={
profile="safety-motion-lds-pfmot001-core",magic_packet=false,zcl_clusters={
g(c.occupancy({endpoint=1,ias_zone=true,emit=j.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
g(c.tamper({endpoint=1})),
g(c.battery_low({endpoint=1,emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},}h(bG,{
m("LDS","PFMOT001"),})local bY={
profile="sensors-owon-ths317-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=2,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.humidity({endpoint=2,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.battery({endpoint=2,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=e}),c.battery_voltage({endpoint=2,minimum_interval=3600,maximum_interval=65000,reportable_change=0,
from_device=function()return nil end}),
},}h(bY,{
m("OWON","THS317"),})
local function u(N)
return g(c.occupancy({endpoint=1,ias_zone=true,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
emit=function(b,a,context)
if not N or context.command_id==0 then return j.motion()(b,a)end
end,
}))
end
local function p(N)
return g(c.battery_low({endpoint=1,emit=function(_,a,context)
if not N or context.command_id==0 then
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end
end}))
end
local function Q()
return{
u(true),p(true),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery({endpoint=1,from_device=e})),c.cluster_attribute(1,62,{name="immax_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
}
end
local bF={
profile="safety-motion-immax-core",magic_packet=false,zcl_clusters=Q(),}h(bF,{
m("IMMAX","Motion-Sensor-ZB3.0"),})local aW={
profile="safety-motion-leedarson-s0000-core",magic_packet=false,zcl_clusters={u(true),g(c.battery({endpoint=1,from_device=e}))},}h(aW,{
m("Leedarson","ZB-MotionSensor-S0000"),})local bO={
profile="safety-motion-somfy-core",magic_packet=false,zcl_clusters={
u(false),p(false),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},}h(bO,{
m("SOMFY","1811681"),})local bW={
profile="sensors-orvibo-st30-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},}h(bW,{
m("ORVIBO","898ca74409a740b28d5841661e72268d"),m("ORVIBO","50938c4c3c0b4049923cd5afbc151bde"),})local H={
profile="sensors-immax-four-core",magic_packet=false,zcl_clusters=Q(),}table.insert(H.zcl_clusters,c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}))table.insert(H.zcl_clusters,c.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}))table.insert(H.zcl_clusters,c.illuminance({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}))h(H,{
m("IMMAX","4in1-Sensor-ZB3.0"),})
local function E()
return c.occupancy({endpoint=1,emit=j.motion(),minimum_interval=0,maximum_interval=3600,
reportable_change=0,read_on_configure=true,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})
end
local aH={
profile="sensors-sunricher-dim-pir-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1030,0,2)c.read_attribute(b,1024,0,3)
end,
zcl_clusters={
c.occupancy({endpoint=2,component="main",emit=j.motion(),minimum_interval=0,maximum_interval=3600,
reportable_change=0,read_on_configure=true,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end}),
c.illuminance({endpoint=3,component="main",minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),},}h(aH,{
m("Sunricher","HK-DIM-PIR"),})local au={
profile="sensors-sunricher-presence-core",magic_packet=false,zcl_clusters={
E(),c.cluster_attribute(1024,0,{name="sunricher_presence_lux",endpoint=1,data_type=f.Uint16,read_only=true,emit=j.illuminance(),minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),},}h(au,{
m("Sunricher","HK-SENSOR-PRE"),})local ae={
profile="sensors-heiman-hs2fd-presence-core",magic_packet=false,
parent_refresh=function()end,
zcl_clusters={
c.cluster_attribute(1030,0,{name="heiman_hs2fd_occupancy",endpoint=1,data_type=f.Bitmap8,read_only=true,read_on_configure=false,minimum_interval=0,maximum_interval=3600,reportable_change=0,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,emit=j.motion()}),
},}h(ae,{
m("HEIMAN","HS2FD-EF1-3.0"),})local bE={
profile="sensors-heiman-hs8os-core",magic_packet=false,zcl_clusters={
E(),c.cluster_attribute(1024,0,{name="heiman_hs8os_lux",endpoint=1,data_type=f.Uint16,read_only=true,emit=j.illuminance(),read_on_configure=true}),},
configure=function(n,b)
b:send(k.build_bind_request(b,1024,n.environment_info.hub_zigbee_eui,1))
end,
}h(bE,{
m("HEIMAN","HS8OS-EF1-3.0"),})local bt={
profile="sensors-robb-presence-core",magic_packet=false,zcl_clusters={
E(),g(c.tamper({endpoint=1})),p(false),c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.illuminance({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},}h(bt,{
m("ROBB smarrt","ROB_200-070-0"),})local bQ={
profile="sensors-climax-rs23-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),g(c.humidity({endpoint=1})),},
configure=function(n,b)
b:send(k.build_bind_request(b,1029,n.environment_info.hub_zigbee_eui,1))
end,
}h(bQ,{
m("Climax Technology Co.","RS_00.00.02.06TC"),})local by={
profile="safety-smoke-climax-core",magic_packet=false,zcl_clusters={
g(c.smoke({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
g(c.tamper({endpoint=1})),p(false),g(c.battery({endpoint=1,from_device=e})),c.cluster_attribute(1,62,{name="climax_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(by,{
m("Climax Technology Co.","SD8SC_00.00.03.12TC"),})
local function bh()
local q=u(false)
q.emit=function(b,a)
local G=b:get_field("__imou_motion_timer")
if G then G:cancel()end
b:set_field("__imou_motion_timer",b.thread:call_with_delay(90,function()
b:set_field("__imou_motion_timer",nil)b:emit_event(d.motionSensor.motion.inactive())
end,"Motion reset"))
return j.motion()(b,a)
end
return q
end
local cw={
profile="safety-motion-imou-zp1-core",magic_packet=false,zcl_clusters={
bh(),g(c.tamper({endpoint=1})),p(false),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},}h(cw,{
m("MultIR","ZP1-EN"),})
local function F(a)
if a==255 then return nil end
local r=a*100
local L=100
if r<2100 then L=0
elseif r<2440 then L=6-(2440-r)*6/340
elseif r<2740 then L=18-(2740-r)*12/300
elseif r<2900 then L=42-(2900-r)*24/160
elseif r<3000 then L=100-(3000-r)*58/100 end
return math.floor(L+0.5)
end
local function R(cG)
local cC={
g(c.contact({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.contact()(b,a)end
end})),
p(true),c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.cluster_attribute(1,32,{name="iris_contact_battery",endpoint=1,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=F,emit=j.battery()}),c.cluster_attribute(1,62,{name="iris_contact_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
}
if cG then cC[#cC+1]=g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end}))end
return cC
end
local co={
profile="sensors-iris-1116-core",magic_packet=false,zcl_clusters=R(true),}h(co,{
m("iMagic by GreatStar","1116-S"),})local cp={
profile="sensors-iris-3320-core",magic_packet=false,zcl_clusters=R(false),}h(cp,{
m("iMagic by GreatStar","3320-L"),})local bT={
profile="safety-smoke-konke-core",magic_packet=false,zcl_clusters={
g(c.smoke({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),p(false),
},}h(bT,{
m("Konke","3AFE010104020028"),m("iHorn","LH05121"),})local at={
profile="safety-motion-lifecontrol-core",magic_packet=false,zcl_clusters={
u(false),g(c.tamper({endpoint=1})),p(false),g(c.battery({endpoint=1,scale=1,from_device=e})),},}h(at,{
m("Nexturn","Motion_Sensor"),})local cn={
profile="safety-motion-gs-smhm-core",magic_packet=false,zcl_clusters={
u(false),g(c.tamper({endpoint=1})),p(false),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
from_device=function(a,_,context)
local bo=context.zb_rx.body.zcl_body
local r=type(bo.get_attribute_data)=="function"and bo:get_attribute_data(32)
if type(r)=="table"then r=r.value end
if type(r)=="number"and r<255 then return nil end
return e(a,nil,context)
end}),
c.cluster_attribute(1,32,{name="gs_motion_voltage",endpoint=1,data_type=f.Uint8,
read_only=true,read_on_configure=false,emit=function(_,a)
if a==255 then return nil end
return{d.battery.battery(math.floor(math.max(0,math.min(100,(a-25)*20))+0.5)),d.voltageMeasurement.voltage({value=a/10,unit="V"})}
end}),
},}h(cn,{
m("GS","SMHM-I1"),})local cj={
profile="sensors-slacky-lcd-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=10}),c.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=10}),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=21600,reportable_change=0,from_device=e}),c.battery_voltage({endpoint=1,minimum_interval=3600,maximum_interval=21600,reportable_change=0,from_device=e}),},}h(cj,{
m("Slacky-DIY","TS0201-z2C-SlD"),})
local function aq()
local q=E()q.read_on_configure=false
return q
end
local bz={
profile="sensors-datek-motion-core",magic_packet=false,zcl_clusters={
aq(),u(false),p(false),c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.illuminance({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),c.cluster_attribute(1,62,{name="datek_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},
configure=function(n,b)
b:send(k.build_bind_request(b,1280,n.environment_info.hub_zigbee_eui,1))
for _,bn in ipairs({16,0,17})do c.read_attribute(b,1280,bn,1)end
end,
}h(bz,{
m("Datek","Motion Sensor"),})local aE={
profile="sensors-schneider-w564100-core",magic_packet=false,zcl_clusters={
g(c.occupancy({endpoint=20,ias_zone=true,emit=j.motion(),from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&2)~=0
end})),
c.temperature({endpoint=20,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.cluster_attribute(1024,0,{name="schneider_w564100_lux",endpoint=20,data_type=f.Uint16,read_only=true,emit=j.illuminance(),minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),},}h(aE,{
m("Schneider Electric","W564100"),})local bV={
profile="safety-motion-niko-core",magic_packet=false,zcl_clusters={
u(true),p(true),c.cluster_attribute(1,32,{name="niko_motion_battery",endpoint=1,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=F,emit=j.battery()}),c.cluster_attribute(1,62,{name="niko_motion_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(bV,{
m("Niko NV","Connectable motion sensor,Zigbee"),})local bI={
profile="safety-smoke-multir-sm200-core",magic_packet=false,zcl_clusters={
g(c.smoke({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
g(c.tamper({endpoint=1})),p(false),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},}h(bI,{
m("MultIR","MIR-SM200"),})local cg={
profile="sensors-hzc-s093th-core",magic_packet=false,zcl_clusters={
g(c.temperature({endpoint=1})),
g(c.humidity({endpoint=1,from_device=function(a)
if a>=0 and a<=100 then return a end
end})),
},}h(cg,{
m("Shyugj","TempAndHumSensor-ZB3.0"),})local bN={
profile="safety-smoke-slacky-core",magic_packet=false,zcl_clusters={
g(c.smoke({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
g(c.tamper({endpoint=1})),p(false),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=21600,reportable_change=0,from_device=e}),c.battery_voltage({endpoint=1,minimum_interval=3600,maximum_interval=21600,reportable_change=0,from_device=e}),},}h(bN,{
m("Slacky-DIY","Smoke_Sensor_TLSR8258"),})local K={
profile="sensors-imou-ztm1-core",magic_packet=false,zcl_clusters={},
configure=function(n,b)
b:send(k.build_bind_request(b,1,n.environment_info.hub_zigbee_eui,1))c.configure_reporting(b,{cluster=1,attribute=33,data_type=f.Uint8,minimum_interval=3600,maximum_interval=65000,reportable_change=10},1)c.read_attribute(b,1,33,1)
end,
}for _,l in ipairs({1,2})do
for _,q in ipairs({
c.temperature({endpoint=l,component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.humidity({endpoint=l,component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100}),g(c.battery({endpoint=l,component="main",from_device=e})),
})do K.zcl_clusters[#K.zcl_clusters+1]=q end
end
h(K,{
m("MultIR","ZTM1-EN"),})local bx={
profile="sensors-casaia-probe-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=3,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.cluster_attribute(1,32,{name="casaia_probe_battery",endpoint=3,data_type=f.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,
from_device=function(a)
if a==255 then return nil end
return math.max(0,math.min(100,(a*100-2500)/5))
end,emit=j.battery()}),
c.cluster_attribute(1,33,{name="casaia_probe_percentage_config",endpoint=3,data_type=f.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true}),c.cluster_attribute(1,62,{name="casaia_probe_battery_alarm",endpoint=3,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(bx,{
m("CASAIA","CTHS317ET"),})local bZ={
profile="sensors-pushok-soil-core",magic_packet=false,zcl_clusters={
c.cluster_attribute(1026,0,{name="pushok_soil_temperature",endpoint=1,data_type=f.Int16,scale=100,read_only=true,read_on_configure=true,emit=j.temperature()}),c.cluster_attribute(1029,0,{name="pushok_soil_moisture",endpoint=1,data_type=f.Uint16,scale=100,read_only=true,read_on_configure=true,emit=j.humidity()}),g(c.battery({endpoint=1,from_device=e})),g(c.battery_voltage({endpoint=1,from_device=e})),},}h(bZ,{
m("PushOk Hardware","POK002"),m("PushOk Hardware","POK007"),})local aD={
profile="sensors-pushok-contact-th-core",magic_packet=false,zcl_clusters={
c.cluster_attribute(15,85,{name="pushok_contact",endpoint=1,data_type=f.Boolean,
read_only=true,read_on_configure=true,emit=function(_,a)
return(a==1 or a==true)and d.contactSensor.contact.closed()or d.contactSensor.contact.open()
end}),
c.cluster_attribute(1026,0,{name="pushok_contact_temperature",endpoint=1,data_type=f.Int16,scale=100,read_only=true,read_on_configure=true,emit=j.temperature()}),g(c.humidity({endpoint=1})),g(c.battery({endpoint=1,from_device=e})),g(c.battery_voltage({endpoint=1,from_device=e})),},}h(aD,{
m("PushOk Hardware","POK010"),})local bm={
profile="sensors-tapestry-thpz1-core",magic_packet=false,
configure=function(n,b)
b:send(k.build_bind_request(b,1026,n.environment_info.hub_zigbee_eui,1))b:send(k.build_bind_request(b,1029,n.environment_info.hub_zigbee_eui,1))
end,
zcl_clusters={
c.cluster_attribute(1030,0,{name="tapestry_occupancy",endpoint=1,data_type=f.Bitmap8,read_only=true,minimum_interval=1,maximum_interval=600,read_on_configure=false,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,emit=j.motion()}),
g(c.temperature({endpoint=1})),g(c.humidity({endpoint=1})),},}h(bm,{
m("Tapestry","THPZ1"),})
local function aw(b,ci)
local cs=b:get_field("__tradfri_core_version")or""
local ch,cx,patch,ck=cs:match("^[v= ]*(%d+)%.(%d+)%.(%d+)(.*)$")local ct=false
if ch and(ck==""or ck:sub(1,1)=="-"or ck:sub(1,1)=="+")then
ch,cx,patch=tonumber(ch),tonumber(cx),tonumber(patch)ct=ch<2 or(ch==2 and(cx<4 or(cx==4 and patch==0 and ck:sub(1,1)=="-")))
end
return j.battery()(b,ct and ci or ci/2)
end
local al={
profile="safety-motion-ikea-tradfri-core",magic_packet=false,zcl_clusters={
c.cluster_attribute(6,66,{name="tradfri_timed_motion",endpoint=1,read_only=true,read_on_configure=false,
command_id=66,command_extractor=function(rx)
return rx.body.zcl_body
end,
emit=function(b,bo,context)
if context.command_id~=66 then return nil end
local cE=bo.on_off_control.value
local cA=bo.on_time.value/10
local G=b:get_field("__tradfri_core_timer")
if(cE&1)~=0 and not G then return nil end
if G then G:cancel()end
b:set_field("__tradfri_core_timer",nil)if cA~=0 then
b:set_field("__tradfri_core_timer",b.thread:call_with_delay(cA,function()
b:set_field("__tradfri_core_timer",nil)b:emit_event(d.motionSensor.motion.inactive())
end,"Motion reset"))
end
return d.motionSensor.motion.active()
end}),
c.cluster_attribute(1,33,{name="tradfri_battery",endpoint=1,data_type=f.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true,
emit=function(b,ci)
if ci==255 then return nil end
b:set_field("__tradfri_core_battery",ci)return aw(b,ci)
end}),
c.cluster_attribute(0,16384,{name="tradfri_software_build",endpoint=1,data_type=f.CharString,
read_only=true,read_on_configure=true,emit=function(b,cs)
b:set_field("__tradfri_core_version",cs,{persist=true})local ci=b:get_field("__tradfri_core_battery")
if ci~=nil then return aw(b,ci)end
end}),
},}h(al,{
m("IKEA of Sweden","TRADFRI motion sensor"),})local cy={
profile="safety-smoke-co-halo-wx-core",magic_packet=false,
configure=function(n,b)
for _,l in ipairs({1,3})do
b:send(k.build_bind_request(b,1280,n.environment_info.hub_zigbee_eui,l))c.read_attribute(b,1280,2,l)
end
for l in pairs(b.zigbee_endpoints)do
for _,o in ipairs({1026,1029})do
if b:supports_server_cluster(o,l)then c.read_attribute(b,o,0,l)end
end
end
end,
zcl_clusters={
g(c.smoke({endpoint=1})),g(c.tamper({endpoint=1})),
g(c.battery_low({endpoint=1,emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
g(c.carbon_monoxide({endpoint=3,component="main"})),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),c.battery_voltage({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),c.temperature({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.humidity({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),},}h(cy,{
m("HaloSmartLabs","haloWX"),})local bs={
profile="sensors-nexelec-openr-core",magic_packet=false,
configure=function(_,b)
for l in pairs(b.zigbee_endpoints)do
for _,s in ipairs({{1026,0},{1029,0},{1037,0},{1,33}})do
if b:supports_server_cluster(s[1],l)then c.read_attribute(b,s[1],s[2],l)end
end
end
end,
zcl_clusters={
c.temperature({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.humidity({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.cluster_attribute(1037,0,{name="nexelec_co2",component="main",data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=false,minimum_interval=10,maximum_interval=3600,reportable_change=f.SinglePrecisionFloat(0,-15,5355287/8388608),
from_device=function(a)
if type(a)=="table"then a=a.value end
return math.floor(a*1000000+0.5)
end,emit=j.co2(),
}),c.battery({component="main",minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=false,from_device=e}),},}h(bs,{
m("Nexelec","Air Quality Sensor Nexelec"),})local aI={
profile="sensors-viessmann-7963223-core",magic_packet=false,zcl_clusters={
g(c.temperature({endpoint=1})),g(c.humidity({endpoint=1})),g(c.battery({endpoint=1,from_device=e})),},}h(aI,{
m("Viessmann","7963223"),})local aX={
profile="sensors-titan-tpzrco2ht-core",magic_packet=false,
configure=function(n,b)
for _,o in ipairs({1,1026,1037})do
b:send(k.build_bind_request(b,o,n.environment_info.hub_zigbee_eui,1))
end
c.read_attribute(b,1,32,1)b:send(k.build_bind_request(b,1029,n.environment_info.hub_zigbee_eui,2))
end,
zcl_clusters={
g(c.temperature({endpoint=1})),g(c.humidity({endpoint=2,component="main"})),c.cluster_attribute(1037,0,{name="titan_co2",endpoint=1,data_type=f.SinglePrecisionFloat,
read_only=true,read_on_configure=false,from_device=function(a)
if type(a)=="table"then a=a.value end
return math.floor(a*1000000)
end,emit=j.co2(),
}),g(c.battery_voltage({component="main",from_device=e})),c.cluster_attribute(1,62,{name="titan_battery_alarm",component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
if type(a)=="table"then a=a.value end
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),},}h(aX,{
m("Titan Products Ltd","TPZRCO2HT-Z3"),})local ab={
profile="safety-motion-sihas-osm300z-core",magic_packet=false,
configure=function(n,b)
local l=b:get_endpoint(1)b:send(k.build_bind_request(b,1,n.environment_info.hub_zigbee_eui,l))c.configure_reporting(b,{cluster=1,attribute=32,data_type=f.Uint8,minimum_interval=3600,maximum_interval=65000,reportable_change=10},l,{auto_endpoint=true})c.read_attribute(b,1,32,l)for ep in pairs(b.zigbee_endpoints)do
if b:supports_server_cluster(1030,ep)then c.read_attribute(b,1030,0,ep)end
end
end,
zcl_clusters={
c.occupancy({component="main",minimum_interval=0,maximum_interval=3600,reportable_change=0,read_on_configure=false,
emit=j.motion(),from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
}),c.cluster_attribute(1,32,{name="sihas_osm_voltage",component="main",data_type=f.Uint8,
read_only=true,read_on_configure=false,emit=function(_,a)
if a==255 then return nil end
return{d.battery.battery(math.floor(math.max(0,math.min(100,(a-21)*100/9))+0.5)),d.voltageMeasurement.voltage({value=a/10,unit="V"})}
end,
}),
g(c.battery({component="main",from_device=function(a,_,context)
local bo=context.zb_rx.body.zcl_body
local r=type(bo.get_attribute_data)=="function"and bo:get_attribute_data(32)
if type(r)=="table"then r=r.value end
if type(r)=="number"and r<255 then return nil end
return e(a,nil,context)
end})),
},}h(ab,{
m("ShinaSystem","OSM-300Z"),})local P={
profile="sensors-sylvania-contact-temperature-core",magic_packet=false,zcl_clusters={
g(c.contact({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.contact()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
p(true),c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.cluster_attribute(1,32,{name="sylvania_contact_battery",endpoint=1,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,
from_device=function(a)
if a==255 then return nil end
return math.floor(math.max(0,math.min(100,(a-25)*100/3))+0.5)
end,emit=j.battery(),
}),},}h(P,{
m("CentraLite","Contact Sensor-A"),})local I={
profile="safety-motion-thirdreality-gen2-core",magic_packet=false,
configure=function(n,b)
local l=b:get_endpoint(1)b:send(k.build_bind_request(b,1,n.environment_info.hub_zigbee_eui,l))c.configure_reporting(b,{cluster=1,attribute=33,data_type=f.Uint8,minimum_interval=3600,maximum_interval=65000,reportable_change=10},l,{auto_endpoint=true})c.read_attribute(b,1,33,l)for ep in pairs(b.zigbee_endpoints)do
for _,s in ipairs({{1280,2},{1024,0}})do
if b:supports_server_cluster(s[1],ep)then c.read_attribute(b,s[1],s[2],ep)end
end
end
end,
zcl_clusters={
c.occupancy({component="main",ias_zone=true,emit=j.motion(),minimum_interval=0,maximum_interval=65000,reportable_change=0,read_on_configure=false,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
}),g(c.tamper({component="main"})),g(c.battery({component="main",from_device=e})),c.illuminance({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=false}),},}h(I,{
m("Third Reality, Inc","3RMS26Z"),})local bu={
profile="sensors-sihas-usm300z-core",magic_packet=false,
configure=function(_,b)
for ep in pairs(b.zigbee_endpoints)do
if b:supports_server_cluster(1024,ep)then c.read_attribute(b,1024,0,ep)end
end
end,
zcl_clusters={
c.temperature({endpoint=1,minimum_interval=20,maximum_interval=300,reportable_change=10,read_on_configure=false}),c.humidity({endpoint=1,minimum_interval=20,maximum_interval=300,reportable_change=40,read_on_configure=false}),c.occupancy({endpoint=1,minimum_interval=1,maximum_interval=600,reportable_change=1,read_on_configure=false,
emit=j.motion(),from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
}),c.cluster_attribute(1,32,{name="sihas_usm_voltage",endpoint=1,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=30,maximum_interval=21600,reportable_change=1,
emit=function(_,a)
local L=F(a)
if L==nil then return nil end
return{d.battery.battery(L),d.voltageMeasurement.voltage({value=a/10,unit="V"})}
end,
}),c.illuminance({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=5,
read_on_configure=false,from_device=function(a)return a end}),
},}h(bu,{
m("ShinaSystem","USM-300Z"),})local ad={
profile="sensors-thirdreality-air-core",magic_packet=false,
configure=function(_,b)
for l in pairs(b.zigbee_endpoints)do
for _,o in ipairs({1026,1029,1037})do
if b:supports_server_cluster(o,l)then c.read_attribute(b,o,0,l)end
end
end
end,
zcl_clusters={
c.temperature({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.humidity({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.cluster_attribute(1037,0,{name="thirdreality_co2",component="main",data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=false,minimum_interval=10,maximum_interval=3600,reportable_change=f.SinglePrecisionFloat(0,-15,5355287/8388608),
from_device=function(a)
if type(a)=="table"then a=a.value end
return math.floor(a*1000000+0.5)
end,emit=j.co2(),
}),},}h(ad,{
m("Third Reality, Inc","3RAQ1096Z"),})local X={
profile="sensors-adeo-pirth-v3-core",magic_packet=false,
configure=function(n,b)
local l=b:get_endpoint(1)b:send(k.build_bind_request(b,1,n.environment_info.hub_zigbee_eui,l))c.configure_reporting(b,{cluster=1,attribute=33,data_type=f.Uint8,minimum_interval=3600,maximum_interval=65000,reportable_change=10},l,{auto_endpoint=true})c.read_attribute(b,1,33,l)for ep in pairs(b.zigbee_endpoints)do
for _,s in ipairs({{1280,2},{1024,0},{1026,0},{1029,0}})do
if b:supports_server_cluster(s[1],ep)then c.read_attribute(b,s[1],s[2],ep)end
end
end
end,
zcl_clusters={
c.occupancy({component="main",ias_zone=true,emit=j.motion(),minimum_interval=0,maximum_interval=65000,reportable_change=0,read_on_configure=false,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
}),g(c.tamper({component="main"})),
g(c.battery_low({component="main",emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
g(c.battery({component="main",from_device=e})),c.illuminance({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=false}),c.temperature({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.humidity({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),},}h(X,{
m("ADEO","ZB-SMART-PIRTH-V3"),})local S={
profile="safety-motion-multir-ir100-core",magic_packet=false,
configure=function(n,b)
local l=b:get_endpoint(1)b:send(k.build_bind_request(b,1,n.environment_info.hub_zigbee_eui,l))c.configure_reporting(b,{cluster=1,attribute=33,data_type=f.Uint8,minimum_interval=3600,maximum_interval=65000,reportable_change=10},l,{auto_endpoint=true})c.read_attribute(b,1,33,l)for ep in pairs(b.zigbee_endpoints)do
for _,s in ipairs({{1280,2},{1024,0}})do
if b:supports_server_cluster(s[1],ep)then c.read_attribute(b,s[1],s[2],ep)end
end
end
end,
zcl_clusters={
c.occupancy({component="main",ias_zone=true,emit=j.motion(),minimum_interval=0,maximum_interval=65000,reportable_change=0,read_on_configure=false,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
}),g(c.tamper({component="main"})),
g(c.battery_low({component="main",emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
g(c.battery({component="main",from_device=e})),c.illuminance({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=false}),},}h(S,{
m("MultIR","MIR-IR100"),})local ar={
profile="sensors-leedarson-pirth-v1-core",magic_packet=false,
configure=function(_,b)
for ep in pairs(b.zigbee_endpoints)do
if b:supports_server_cluster(1024,ep)then c.read_attribute(b,1024,0,ep)end
end
end,
zcl_clusters={
g(c.occupancy({component="main",ias_zone=true,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
emit=function(b,a,context)
if context.command_id==0 then return j.motion()(b,a)end
end,
})),
g(c.tamper({component="main",emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({component="main",emit=function(_,a,context)
if context.command_id==0 then
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end
end})),
g(c.temperature({component="main"})),g(c.humidity({component="main"})),g(c.battery({component="main",from_device=e})),g(c.battery_voltage({component="main",from_device=e})),c.cluster_attribute(1,62,{name="leedarson_pirth_battery_alarm",component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
if type(a)=="table"then a=a.value end
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),c.illuminance({component="main",minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=false}),},}h(ar,{
m("Leedarson","ZB-SMART-PIRTH-V1"),})local bi={
profile="safety-motion-konke-kkbsj01w-core",magic_packet=false,zcl_clusters={
g(c.occupancy({component="main",ias_zone=true,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
emit=function(b,a,context)
if context.command_id~=0 then return nil end
local aa="__konke_motion_timer_"..context.src_endpoint
local G=b:get_field(aa)
if G then G:cancel()end
b:set_field(aa,b.thread:call_with_delay(90,function()
b:set_field(aa,nil)b:emit_event(d.motionSensor.motion.inactive())
end,"Motion reset"))
return j.motion()(b,a)
end,
})),
g(c.tamper({component="main",emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({component="main",emit=function(_,a,context)
if context.command_id==0 then
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end
end})),
g(c.battery({component="main",from_device=e})),g(c.battery_voltage({component="main",from_device=e})),c.cluster_attribute(1,62,{name="konke_kkbs_battery_alarm",component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
if type(a)=="table"then a=a.value end
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),},}h(bi,{
m("Konke","3AFE07010402100D"),m("Konke","3AFE08010402100D"),})local bb={
profile="sensors-efekta-eon213z-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=1,minimum_interval=0,maximum_interval=21600,reportable_change=0}),c.humidity({endpoint=1,minimum_interval=0,maximum_interval=21600,reportable_change=0}),c.battery({endpoint=1,minimum_interval=0,maximum_interval=21600,reportable_change=0,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),},}h(bb,{
m("efektalab.com","EFEKTA_eON213z"),})local ce={
profile="sensors-efekta-thp-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=1,minimum_interval=0,maximum_interval=21600,reportable_change=0}),c.humidity({endpoint=1,minimum_interval=0,maximum_interval=21600,reportable_change=0}),c.pressure({endpoint=1,minimum_interval=0,maximum_interval=21600,reportable_change=0,read_on_configure=true}),c.battery({endpoint=1,minimum_interval=0,maximum_interval=21600,reportable_change=0,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),},}h(ce,{
m("EfektaLab","EFEKTA_THP"),})local aM={
profile="sensors-efekta-t1-ntc10k-core",magic_packet=false,
parent_refresh=function(b)c.read_attribute(b,1,33,1)end,
zcl_clusters={
c.temperature({endpoint=1,minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.battery({endpoint=1,minimum_interval=10,maximum_interval=600,reportable_change=1,from_device=e}),c.cluster_attribute(1,62,{name="efekta_ntc10k_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
if type(a)=="table"then a=a.value end
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),},}h(aM,{
m("EfektaLab","EFEKTA_T1_NTC10K"),m("EfektaLab_for_Zigbee-Shop.ru","EFEKTA_T1_NTC10K"),})local ag={
profile="sensors-efekta-t1-pow-ntc10k-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,0,1)
end,
zcl_clusters={
c.temperature({endpoint=1,minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.battery({endpoint=1,minimum_interval=10,maximum_interval=600,reportable_change=1,from_device=e}),c.cluster_attribute(1,62,{name="efekta_pow_ntc10k_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
if type(a)=="table"then a=a.value end
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),c.cluster_attribute(1,0,{name="efekta_pow_ntc10k_mains_voltage",endpoint=1,data_type=f.Uint16,read_only=true,read_on_configure=true,scale=10,emit=j.voltage(),}),},}h(ag,{
m("EfektaLab","EFEKTA_T1_POW_NTC10K"),m("EfektaLab_for_Zigbee-Shop.ru","EFEKTA_T1_POW_NTC10K"),})local Z={
profile="sensors-efekta-th-duo-standard-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.temperature({endpoint=1,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.humidity({endpoint=1,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.temperature({endpoint=2,component="external",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.humidity({endpoint=2,component="external",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.battery({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,reportable_change=1,from_device=e}),c.battery_voltage({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,from_device=e}),c.cluster_attribute(1,62,{name="efekta_th_duo_standard_battery_alarm",endpoint=1,component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
if type(a)=="table"then a=a.value end
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),},}h(Z,{
m("EfektaLab","EFEKTA_TH_DUO"),m("EfektaLab_for_Zigbee-Shop.ru","EFEKTA_TH_DUO"),})local ai={
profile="sensors-sonoff-snzb02-efekta-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=1,minimum_interval=30,maximum_interval=1800,reportable_change=10}),c.humidity({endpoint=1,minimum_interval=120,maximum_interval=3600,reportable_change=25}),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=21600,reportable_change=1,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),},}h(ai,{
m("EfektaLab_for_you","SNZB-02_EFEKTA"),})local br={
profile="sensors-heiman-hs8mis-core",magic_packet=false,
configure=function(n,b)
b:send(k.build_bind_request(b,1024,n.environment_info.hub_zigbee_eui,1))c.read_attribute(b,1024,0,1)
end,
zcl_clusters={
c.occupancy({endpoint=1,minimum_interval=0,maximum_interval=3600,reportable_change=0,read_on_configure=true,
emit=j.motion(),from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
}),
g(c.illuminance({endpoint=1,from_device=function(a)return a end})),
},}h(br,{
m("HEIMAN","HS8MIS-EF1-3.0"),})local as={
profile="sensors-lifecontrol-mclh08-core",magic_packet=false,
parent_refresh=function(b)c.read_attribute(b,1,33,1)end,
zcl_clusters={
g(c.temperature({endpoint=1,scale=1,from_device=function(a)
return(a<-1000 and(-(a+32767)*5)/3 or a)/100
end})),
c.cluster_attribute(1026,1,{name="lifecontrol_voc_humidity",endpoint=1,data_type=f.Int16,read_only=true,read_on_configure=false,scale=100,emit=j.humidity(),}),g(c.battery({endpoint=1,scale=1,from_device=e})),},}h(as,{
m("Nexturn","VOC_Sensor"),})local be={
profile="safety-motion-feibit-sbm01zb-core",magic_packet=false,zcl_clusters={
u(true),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
p(true),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),c.cluster_attribute(1,62,{name="feibit_sbm01_battery_alarm",endpoint=1,data_type=f.Bitmap32,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,
emit=function(_,a)
if type(a)=="table"then a=a.value end
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),},}h(be,{
m("Feibit Inc co.","FB56-BOT02HM1.2"),m("Feibit Inc co.","FNB56-BOT06FB2.3"),m("Feibit Inc co.","FNB56-BOT06FB2.8"),})local ap={
profile="sensors-bacchus-presence26-core",magic_packet=false,zcl_clusters={
c.occupancy({endpoint=1,minimum_interval=0,maximum_interval=3600,reportable_change=0,read_on_configure=true,
emit=j.motion(),from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
}),c.illuminance({endpoint=1,minimum_interval=0,maximum_interval=3600,reportable_change=0,read_on_configure=true}),},}h(ap,{
m("Bacchus","Presence_Sensor_v2.6"),})local O={
profile="sensors-bacchus-presence2-core",magic_packet=false,
configure=function(n,b)
b:send(k.build_bind_request(b,1030,n.environment_info.hub_zigbee_eui,1))c.configure_reporting(b,{cluster=1030,attribute=0,data_type=f.Bitmap8,minimum_interval=0,maximum_interval=3600},1)c.read_attribute(b,1030,0,1)
end,
zcl_clusters={
g(c.occupancy({endpoint=1,emit=j.motion(),from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
c.illuminance({endpoint=1,minimum_interval=0,maximum_interval=3600,reportable_change=0,read_on_configure=true}),},}h(O,{
m("Bacchus","Presence_Sensor_v2"),})local A={
profile="sensors-diyruz-airsense-core",magic_packet=false,
configure=function(n,b)
for _,s in ipairs({{1026,f.Int16},{1029,f.Uint16},{1037,f.SinglePrecisionFloat}})do
b:send(k.build_bind_request(b,s[1],n.environment_info.hub_zigbee_eui,1))local cF=s[1]==1037 and f.SinglePrecisionFloat(0,-127,0)or 0
c.configure_reporting(b,{cluster=s[1],attribute=0,data_type=s[2],minimum_interval=0,maximum_interval=3600,reportable_change=cF},1)
end
end,
zcl_clusters={
g(c.temperature({endpoint=1})),g(c.humidity({endpoint=1})),c.cluster_attribute(1037,0,{name="diyruz_airsense_co2",endpoint=1,data_type=f.SinglePrecisionFloat,
read_only=true,read_on_configure=false,from_device=function(a)
if type(a)=="table"then a=a.value end
return math.floor(a*1000000)
end,emit=j.co2(),
}),},}h(A,{
m("modkam.ru","DIYRuZ_AirSense"),})local bc={
profile="sensors-efekta-eth-pow-core",magic_packet=false,
parent_refresh=function(b)c.read_attribute(b,1,33,1)end,
zcl_clusters={
g(c.temperature({endpoint=1})),g(c.humidity({endpoint=1})),g(c.battery({endpoint=1,from_device=e})),c.cluster_attribute(1,0,{name="efekta_eth_pow_mains_voltage",endpoint=1,data_type=f.Uint16,read_only=true,read_on_configure=false,scale=10,emit=j.voltage(),}),c.cluster_attribute(1,62,{name="efekta_eth_pow_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
if type(a)=="table"then a=a.value end
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),},}h(bc,{
m("EfektaLab","EFEKTA_eTH_POW_E_LR"),m("EfektaLab","EFEKTA_eTH_POW_R_LR"),})local U={
profile="sensors-wirenboard-msw4-official-core",magic_packet=false,
configure=function(_,b)
for _,o in ipairs({1026,1029,1024,1037})do
if b:supports_server_cluster(o,1)then c.read_attribute(b,o,0,1)end
end
end,
zcl_clusters={
g(c.temperature({endpoint=1})),g(c.humidity({endpoint=1})),g(c.illuminance({endpoint=1})),
g(c.occupancy({endpoint=1,emit=j.motion(),from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
c.cluster_attribute(1037,0,{name="wirenboard_msw4_co2",endpoint=1,data_type=f.SinglePrecisionFloat,
read_only=true,read_on_configure=false,from_device=function(a)
if type(a)=="table"then a=a.value end
return math.floor(a*1000000+0.5)
end,emit=j.co2(),
}),},}h(U,{
m("Wiren Board","WB-MSW-ZIGBEE v.4"),})
local function ac()
return c.cluster_attribute(1037,0,{name="slacky_co2",endpoint=1,data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=true,minimum_interval=10,maximum_interval=300,reportable_change=f.SinglePrecisionFloat(0,-20,407485/8388608),
from_device=function(a)
if type(a)=="table"then a=a.value end
return math.floor(a*1000000+0.5)
end,emit=j.co2(),
})
end
local bk={
profile="sensors-slacky-co2-r01-core",magic_packet=false,zcl_clusters={ac()},}h(bk,{
m("Slacky-DIY","Tuya_CO2Sensor_r01"),})local bl={
profile="sensors-slacky-co2-r02-core",magic_packet=false,zcl_clusters={
ac(),c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),},}h(bl,{
m("Slacky-DIY","Tuya_CO2Sensor_r02"),})
local function ao(_,a)
if type(a)=="table"then a=a.value end
if type(a)=="number"then return d.battery.battery(a)end
end
local cc={
profile="sensors-aqara-w100-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1026,0,1)c.read_attribute(b,1029,0,1)
end,
zcl_clusters={
c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.cluster_attribute(64704,102,{name="aqara_w100_battery",endpoint=1,data_type=f.Uint8,read_only=true,read_on_configure=false,emit=ao,}),c.cluster_attribute(64704,247,{name="aqara_w100_diagnostics",endpoint=1,
read_only=true,read_on_configure=false,emit=function(b,a)
if type(a)=="table"and a.value~=nil then a=a.value end
if type(a)=="table"then return ao(b,a[102]or a["102"])end
if type(a)~="string"then return end
local t=1
while t+1<=#a do
local aa,J=a:byte(t,t+1)local width=J>=32 and J<=47 and((J%8)+1)or J==16 and 1
if not width or t+1+width>#a then return end
if aa==102 then
return ao(b,string.unpack("<"..(J>=40 and"i"or"I")..width,a,t+2))
end
t=t+2+width
end
end,
}),},}h(cc,{
m("Aqara","lumi.sensor_ht.agl001"),})local aT={
profile="sensors-frient-wiszb120-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1026,0,38)c.read_attribute(b,1,33,35)c.read_attribute(b,1,32,35)
end,
zcl_clusters={
g(c.contact({endpoint=35,emit=function(b,a,context)
if context.command_id==0 then return j.contact()(b,a)end
end})),
g(c.tamper({endpoint=35,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=35,emit=function(_,a,context)
if context.command_id==0 then
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end
end})),
c.temperature({endpoint=38,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.battery({endpoint=35,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),c.battery_voltage({endpoint=35,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),},}h(aT,{
m("frient A/S","WISZB-120"),})
local function B(cq,cu)
return{
g(c.contact({endpoint=1,emit=function(b,a,context)
if cq or context.command_id==0 then return j.contact()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if cq or context.command_id==0 then return j.tamper()(b,a)end
end})),
p(not cq),c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.cluster_attribute(1,32,{name="smartthings_multi_voltage",endpoint=1,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,
emit=function(_,a)
if a==255 then return end
return{d.battery.battery(cu(a)),d.voltageMeasurement.voltage({value=a/10,unit="V"})}
end,
}),c.cluster_attribute(1,62,{name="smartthings_multi_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),}
end
local aF={
profile="sensors-smartthings-3321s-core",magic_packet=false,zcl_clusters=B(true,F),}h(aF,{
m("CentraLite","3321-S"),})local an={
profile="sensors-smartthings-multiv4-core",magic_packet=false,
zcl_clusters=B(false,function(a)
return math.floor(math.max(0,math.min(100,235-370000/(a*100+1)))+0.5)
end),
}h(an,{
m("SmartThings","multiv4"),})local aV={
profile="sensors-heiman-hs8mis86-core",magic_packet=false,
configure=function(n,b)
b:send(k.build_bind_request(b,1024,n.environment_info.hub_zigbee_eui,1))c.read_attribute(b,1024,0,1)
end,
zcl_clusters={
c.occupancy({endpoint=1,minimum_interval=0,maximum_interval=3600,reportable_change=0,read_on_configure=true,
emit=j.motion(),from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
}),
g(c.illuminance({endpoint=1,from_device=function(a)return a end})),
},}h(aV,{
m("HEIMAN","HS8MIS-86-EF1-3.0"),})local W={
profile="sensors-thirdreality-soil-gen2-core",magic_packet=false,zcl_clusters={
c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),c.cluster_attribute(1032,0,{name="third_reality_soil_gen2",endpoint=1,data_type=f.Uint16,read_only=true,read_on_configure=true,minimum_interval=10,maximum_interval=3600,reportable_change=100,scale=100,emit=j.humidity()}),},}h(W,{
m("Third Reality, Inc","3RSM0347Z"),})
local function z(b)
return b:supports_server_cluster(1032)and 1032 or 1029
end
local M={
profile="sensors-thirdreality-soil-core",magic_packet=false,
configure=function(n,b)
local o=z(b)local l=b:get_endpoint(o)b:send(k.build_bind_request(b,o,n.environment_info.hub_zigbee_eui,l))c.configure_reporting(b,{cluster=o,attribute=0,data_type=f.Uint16,minimum_interval=10,maximum_interval=3600,reportable_change=100},l,{key="zrThirdSoil"})
end,
parent_refresh=function(b)
local o=z(b)c.read_attribute(b,o,0,b:get_endpoint(o))c.read_attribute(b,1026,0,1)c.read_attribute(b,1,33,1)
end,
zcl_clusters={
c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),c.cluster_attribute(1032,0,{name="third_reality_soil",data_type=f.Uint16,read_only=true,read_on_configure=false,scale=100,emit=j.humidity()}),c.cluster_attribute(1029,0,{name="third_reality_soil_legacy",data_type=f.Uint16,read_only=true,read_on_configure=false,scale=100,
from_device=function(a,b)
if not b:supports_server_cluster(1032)then return a end
end,emit=j.humidity()}),
},}h(M,{
m("Third Reality, Inc","3RSM0147Z"),})local aQ={
profile="sensors-efekta-aq-smart-core",magic_packet=false,
parent_refresh=function()end,
zcl_clusters={
c.temperature({endpoint=1,minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.humidity({endpoint=1,minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.cluster_attribute(1037,0,{name="aq_smart_co2",endpoint=1,data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=false,minimum_interval=10,maximum_interval=600,reportable_change=f.SinglePrecisionFloat(0,-20,407485/8388608),
from_device=function(a)return math.floor(a*1000000+0.5)end,emit=j.co2()}),
},}h(aQ,{
m("EfektaLab","EFEKTA_AQ_Smart_Monitor"),})local bA={
profile="sensors-efekta-aqs2c-core",magic_packet=false,
parent_refresh=function()end,
zcl_clusters={
g(c.temperature({endpoint=3})),g(c.humidity({endpoint=3})),g(c.illuminance({endpoint=2})),c.cluster_attribute(1037,0,{name="aqs2c_co2",endpoint=2,data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=false,
from_device=function(a)return math.floor(a*1000000+0.5)end,emit=j.co2()}),
c.cluster_attribute(1066,0,{name="aqs2c_pm25",endpoint=1,data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=false,
from_device=function(a)return math.floor(a+0.5)end,emit=j.pm25()}),
},}h(bA,{
m("EfektaLab","EFEKTA_Air_Quality_Station_2c"),})
local function cv(b,a)
if type(a)=="table"and a.value~=nil then a=a.value end
if type(a)=="string"then
local D,t={},1
while t+1<=#a do
local aa,J=a:byte(t,t+1)local width=J>=32 and J<=47 and((J%8)+1)or J==16 and 1
if not width or t+1+width>#a then return end
D[aa]=string.unpack("<"..(J>=40 and"i"or"I")..width,a,t+2)t=t+2+width
end
a=D
end
if type(a)~="table"then return end
b:set_field("fp300_battery_received",os.time(),{persist=false})local cf={}for _,cB in ipairs({{23,"voltage"},{24,"battery"}})do
local v=a[cB[1]]or a[tostring(cB[1])]
if type(v)=="table"then v=v.value end
if type(v)=="number"then
cf[#cf+1]=cB[2]=="voltage"and d.voltageMeasurement.voltage({value=v/1000,unit="V"})or d.battery.battery(v)
end
end
return #cf>0 and cf or nil
end
local bP={
profile="sensors-aqara-fp300-core",magic_packet=false,
runtime_start=function(b)
if b:get_field("fp300_battery_timer")or not b.thread then return end
b:set_field("fp300_battery_timer",b.thread:call_on_schedule(3600,function()
if os.time()-(b:get_field("fp300_battery_received")or 0)>=14400 then
c.read_attribute(b,64704,247,1,4447)
end
end,"FP300 battery freshness"),{persist=false})
end,
parent_refresh=function(b)
for _,bn in ipairs({322,333,247})do c.read_attribute(b,64704,bn,1,4447)end
for _,o in ipairs({1026,1029,1024})do c.read_attribute(b,o,0,1)end
end,
zcl_clusters={
c.cluster_attribute(64704,322,{name="fp300_presence",endpoint=1,mfg_code=4447,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=0,maximum_interval=3600,reportable_change=1,
from_device=function(a)return a==1 end,emit=j.presence()}),
c.cluster_attribute(64704,333,{name="fp300_pir",endpoint=1,mfg_code=4447,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=0,maximum_interval=3600,reportable_change=1,
from_device=function(a)return a==1 end,emit=j.motion()}),
c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),c.illuminance({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),c.cluster_attribute(64704,247,{name="fp300_battery",endpoint=1,mfg_code=4447,read_only=true,read_on_configure=true,emit=cv}),c.cluster_attribute(64704,23,{name="fp300_voltage",endpoint=1,mfg_code=4447,data_type=f.Uint16,read_only=true,read_on_configure=false,scale=1000,emit=j.voltage()}),c.cluster_attribute(64704,24,{name="fp300_percentage",endpoint=1,mfg_code=4447,data_type=f.Uint8,read_only=true,read_on_configure=false,emit=j.battery()}),c.cluster_attribute(64704,252,{name="fp300_paired",endpoint=1,mfg_code=4447,data_type=f.Boolean,
read_only=true,read_on_configure=false,handler=function(b,a,context)
if type(a)=="table"then a=a.value end
if a==false and context.zb_rx.body.zcl_header.cmd.value==10 then
b:send(aj.write_manufacturer_specific_attribute(b,64704,252,4447,f.Boolean,true):to_endpoint(1))
end
end}),
},}h(bP,{
m("Aqara","lumi.sensor_occupy.agl8"),})local bM={
profile="sensors-samjin-multi-core",magic_packet=false,
configure=function(_,b)
b:send(V.PollControl.attributes.CheckInInterval:write(b,14400):to_endpoint(1))
end,
zcl_clusters={
g(c.contact({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.contact()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
p(true),c.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=false}),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),c.cluster_attribute(1,62,{name="samjin_multi_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),},}h(bM,{
m("Samjin","multi"),})
local function C(b)
if b:get_field("bosch_bsd2_default_queued")then return end
b:send(V.IASZone.attributes.CurrentZoneSensitivityLevel:write(b,0):to_endpoint(1))b:set_field("bosch_bsd2_default_queued",true,{persist=false})
end
local cd={
profile="sensors-bosch-bsd2-core",magic_packet=false,runtime_start=C,
configure=function(_,b)C(b)end,
zcl_clusters={
c.smoke({endpoint=1,minimum_interval=0,maximum_interval=65000,reportable_change=0,read_on_configure=true,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end,
}),c.battery({endpoint=1,minimum_interval=0,maximum_interval=65000,reportable_change=1,from_device=e}),c.cluster_attribute(1,62,{name="bosch_bsd2_battery_alarm",endpoint=1,data_type=f.Bitmap32,read_only=true,read_on_configure=true,minimum_interval=0,maximum_interval=65000,
emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end,
}),},}h(cd,{
m("BOSCH","RBSH-SD-ZB-EU"),})local ax={
profile="sensors-airsense-reloaded-core",magic_packet=false,
parent_refresh=function(b)
for _,o in ipairs({1026,1029,1027,1037})do c.read_attribute(b,o,0,1)end
end,
zcl_clusters={
c.temperature({endpoint=1,minimum_interval=20,maximum_interval=1200,reportable_change=15}),c.humidity({endpoint=1,minimum_interval=20,maximum_interval=1200,reportable_change=15}),c.cluster_attribute(1027,0,{name="airsense_reloaded_pressure",endpoint=1,data_type=f.Int16,read_only=true,read_on_configure=true,minimum_interval=60,maximum_interval=1800,reportable_change=1,scale=10,emit=j.atmospheric_pressure()}),c.cluster_attribute(1037,0,{name="airsense_reloaded_co2",endpoint=1,data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=true,minimum_interval=20,maximum_interval=600,reportable_change=f.SinglePrecisionFloat(0,-20,407485/8388608),
from_device=function(a)return math.floor(a*1000000+0.5)end,emit=j.co2()}),
},}h(ax,{
m("EfektaLab","DIYRuZ_AirSense_Reloaded"),})
local function w(b)
return b:supports_server_cluster(1032,1)and 1032 or 1029
end
local av={
profile="sensors-efekta-pws-core",magic_packet=false,
configure=function(n,b)
local o=w(b)b:send(k.build_bind_request(b,o,n.environment_info.hub_zigbee_eui,1))c.configure_reporting(b,{cluster=o,attribute=0,data_type=f.Uint16,minimum_interval=0,maximum_interval=21600,reportable_change=0},1,{key="zrPwsSoil"})c.read_attribute(b,o,0,1)
end,
parent_refresh=function(b)
c.read_attribute(b,w(b),0,1)c.read_attribute(b,1026,0,1)c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.temperature({endpoint=1,minimum_interval=0,maximum_interval=21600,reportable_change=0}),c.battery({endpoint=1,minimum_interval=0,maximum_interval=21600,reportable_change=0,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),c.cluster_attribute(1032,0,{name="efekta_pws_soil",endpoint=1,data_type=f.Uint16,
read_only=true,read_on_configure=false,scale=100,emit=function(b,a)
if w(b)==1032 then return j.humidity()(b,a)end
end}),
c.cluster_attribute(1029,0,{name="efekta_pws_soil_zha",endpoint=1,data_type=f.Uint16,
read_only=true,read_on_configure=false,scale=100,emit=function(b,a)
if w(b)==1029 then return j.humidity()(b,a)end
end}),
},}h(av,{
m("efektalab.ru","EFEKTA_PWS"),})
local function x(o)
return function(b)return b:get_endpoint(o)end
end
local aP={
profile="sensors-develco-gwa1513-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1026,0,b:get_endpoint(1026))c.read_attribute(b,1,33,b:get_endpoint(1))c.read_attribute(b,1,32,b:get_endpoint(1))
end,
zcl_clusters={
g(c.contact({endpoint=x(1280),component="main",emit=function(b,a,context)
if context.command_id==0 then return j.contact()(b,a)end
end})),
g(c.tamper({endpoint=x(1280),component="main",emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=x(1280),component="main",emit=function(_,a,context)
if context.command_id==0 then return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()end
end})),
c.temperature({endpoint=x(1026),component="main",minimum_interval=10,maximum_interval=3600,reportable_change=100}),g(c.battery({endpoint=x(1),component="main",from_device=e})),c.cluster_attribute(1,32,{name="gwa1513_voltage",endpoint=x(1),component="main",data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
emit=function(b,a)
if a==255 then return nil end
return{j.battery()(b,math.max(0,math.min(100,(a*100-2500)/5))),j.voltage()(b,a/10)}
end}),
},}h(aP,{
m("Develco Products A/S","GWA1513_WindowSensor"),})local aU={
profile="sensors-frient-wiszb138-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1026,0,38)c.read_attribute(b,1,33,35)c.read_attribute(b,1,32,35)
end,
zcl_clusters={
g(c.contact({endpoint=35,emit=function(b,a,context)
if context.command_id==0 then return j.contact()(b,a)end
end})),
g(c.tamper({endpoint=35,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=35,emit=function(_,a,context)
if context.command_id==0 then return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()end
end})),
c.temperature({endpoint=38,minimum_interval=10,maximum_interval=3600,reportable_change=100}),g(c.battery({endpoint=35,from_device=e})),c.cluster_attribute(1,32,{name="wiszb138_voltage",endpoint=35,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
emit=function(b,a)
if a==255 then return nil end
return{j.battery()(b,math.max(0,math.min(100,(a*100-2500)/5))),j.voltage()(b,a/10)}
end}),
},}h(aU,{
m("frient A/S","WISZB-138"),})local aC={
profile="sensors-multir-ir100e-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
g(c.motion({endpoint=1})),g(c.tamper({endpoint=1})),p(false),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),g(c.battery_voltage({endpoint=1,from_device=e})),},}h(aC,{
m("MultIR","MIR-IR100-E"),m("MultiIR","MIR-IR100-E"),})local bd={
profile="sensors-efekta-pws-max-core",magic_packet=false,
parent_refresh=function(b)
for _,o in ipairs({1026,1029,1024,1032})do c.read_attribute(b,o,0,1)end
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.temperature({endpoint=1,component="main",minimum_interval=0,maximum_interval=21600,reportable_change=0}),c.humidity({endpoint=1,component="main",minimum_interval=0,maximum_interval=21600,reportable_change=0}),c.illuminance({endpoint=1,component="main",minimum_interval=0,maximum_interval=21600,reportable_change=0,read_on_configure=true}),c.cluster_attribute(1032,0,{name="pws_max_soil",endpoint=1,component="soil",data_type=f.Uint16,read_only=true,read_on_configure=true,minimum_interval=0,maximum_interval=21600,reportable_change=0,
from_device=function(a)return a/100 end,emit=j.humidity()}),
c.battery({endpoint=1,component="main",minimum_interval=0,maximum_interval=21600,reportable_change=0,from_device=e}),g(c.battery_voltage({endpoint=1,component="main",from_device=e})),},}h(bd,{
m("EFEKTA_FOR_BELOUSOV.A","EFEKTA_PWS_Max"),})local aK={
profile="sensors-develco-wiszb137-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1026,0,38)c.read_attribute(b,1,33,45)c.read_attribute(b,1,32,45)
end,
zcl_clusters={
g(c.motion({endpoint=45})),g(c.motion({name="wiszb137_vibration",endpoint=45,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&2)~=0
end,emit=j.acceleration()})),
g(c.tamper({endpoint=45})),
g(c.battery_low({endpoint=45,emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end})),
c.temperature({endpoint=38,minimum_interval=10,maximum_interval=3600,reportable_change=100}),g(c.battery({endpoint=45,from_device=e})),c.cluster_attribute(1,32,{name="wiszb137_voltage",endpoint=45,data_type=f.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
emit=function(b,a)
if a==255 then return nil end
return{j.battery()(b,F(a)),j.voltage()(b,a/10)}
end}),
},}h(aK,{
m("frient A/S","WISZB-137"),m("Develco Products A/S","WISZB-137"),})local cb={
profile="sensors-tuya-ts020c-core",magic_packet=true,query_on_configure=true,query_on_announce=true,announce_delay=0,time_start="off",
parent_refresh=function()end,
{dp=1,datatype=4,name="occupancy",field="occupancy",read_only=true,
from_device=function(a)return a==0 end,emit=j.motion()},
{dp=4,datatype=2,name="battery",field="battery",read_only=true,emit=j.battery()},{dp=12,datatype=2,name="illuminance",field="illuminance",read_only=true,emit=j.illuminance()},zcl_clusters={
g(c.motion({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.motion()(b,a)end
end})),
g(c.tamper({endpoint=1,emit=function(b,a,context)
if context.command_id==0 then return j.tamper()(b,a)end
end})),
g(c.battery_low({endpoint=1,emit=function(_,a,context)
if context.command_id==0 then
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end
end})),
g(c.battery({endpoint=1,from_device=e})),g(c.battery_voltage({endpoint=1,from_device=e})),c.cluster_attribute(1,62,{name="ts020c_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
c.cluster_attribute(57346,57345,{name="ts020c_lux",endpoint=1,read_only=true,read_on_configure=false,
emit=function(b,a,context)
if context.zb_rx.body.zcl_header.cmd.value==10 then return j.illuminance()(b,a)end
end}),
},}h(cb,{
m("_TZ3040_wc6kfjtc","TS020C"),})local aA={
profile="sensors-efekta-pixel-air2-core",magic_packet=false,
parent_refresh=function()end,
zcl_clusters={
c.temperature({endpoint=2,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.humidity({endpoint=2,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.cluster_attribute(1037,0,{name="pixel_air2_co2",endpoint=1,component="main",data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=false,minimum_interval=10,maximum_interval=600,reportable_change=f.SinglePrecisionFloat(0,-20,407485/8388608),
from_device=function(a)return math.floor(a*1000000+0.5)end,emit=j.co2()}),
},}h(aA,{
m("EfektaLab for you","EFEKTA_Pixel_Open_Air_II"),})local bB={
profile="sensors-efekta-iaqs2-core",magic_packet=false,
parent_refresh=function()end,
zcl_clusters={
c.temperature({endpoint=1,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.humidity({endpoint=1,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.temperature({endpoint=2,component="external",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.humidity({endpoint=2,component="external",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.illuminance({endpoint=2,component="external",minimum_interval=0,maximum_interval=300,reportable_change=0,read_on_configure=false}),c.cluster_attribute(1027,0,{name="iaqs2_pressure",endpoint=2,component="external",data_type=f.Int16,read_only=true,read_on_configure=false,minimum_interval=30,maximum_interval=1800,reportable_change=1,
from_device=function(a)return a/10 end,emit=j.atmospheric_pressure()}),
c.cluster_attribute(1037,0,{name="iaqs2_co2",endpoint=1,component="main",data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=false,minimum_interval=10,maximum_interval=600,reportable_change=f.SinglePrecisionFloat(0,-20,407485/8388608),
from_device=function(a)return math.floor(a*1000000+0.5)end,emit=j.co2()}),
},}h(bB,{
m("EfektaLab","EFEKTA_iAQ_S_II"),})local bS={
profile="sensors-efekta-iaq3-core",magic_packet=false,
parent_refresh=function()end,
zcl_clusters={
c.temperature({endpoint=1,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.humidity({endpoint=1,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.temperature({endpoint=2,component="external",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.humidity({endpoint=2,component="external",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),c.illuminance({endpoint=2,component="external",minimum_interval=0,maximum_interval=300,reportable_change=0,read_on_configure=false}),c.cluster_attribute(1037,0,{name="iaq3_co2",endpoint=1,component="main",data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=false,minimum_interval=10,maximum_interval=600,reportable_change=f.SinglePrecisionFloat(0,-20,407485/8388608),
from_device=function(a)return math.floor(a*1000000+0.5)end,emit=j.co2()}),
},}h(bS,{
m("EfektaLab","EFEKTA_iAQ3"),})local bp={
profile="sensors-efekta-eflora-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.temperature({endpoint=1,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.humidity({endpoint=1,component="main",minimum_interval=300,maximum_interval=3600,reportable_change=50,read_on_configure=false}),c.illuminance({endpoint=1,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.cluster_attribute(1032,0,{name="eflora_base_soil",endpoint=1,component="soil",data_type=f.Uint16,minimum_interval=600,maximum_interval=7200,reportable_change=100,read_only=true,read_on_configure=false,scale=100,emit=j.humidity()}),c.battery({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,reportable_change=1,from_device=e}),c.battery_voltage({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,from_device=e}),c.cluster_attribute(1,62,{name="eflora_base_battery_alarm",endpoint=1,component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(bp,{
m("EfektaLab","EFEKTA_eFlora"),})local aB={
profile="sensors-efekta-zflora-pro-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.temperature({endpoint=1,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.humidity({endpoint=1,component="main",minimum_interval=300,maximum_interval=3600,reportable_change=50,read_on_configure=false}),c.illuminance({endpoint=1,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.cluster_attribute(1032,0,{name="zflora_pro_soil",endpoint=1,component="soil",data_type=f.Uint16,minimum_interval=600,maximum_interval=7200,reportable_change=100,read_only=true,read_on_configure=false,scale=100,emit=j.humidity()}),c.battery({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,reportable_change=1,from_device=e}),c.battery_voltage({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,from_device=e}),c.cluster_attribute(1,62,{name="zflora_pro_battery_alarm",endpoint=1,component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(aB,{
m("EfektaLab","zFlora_Pro"),m("EfektaLab","zFlora_S_Max"),m("EfektaLab_for_Zigbee-Shop.ru","zFlora_S_Max"),})local aR={
profile="sensors-efekta-zflora-s-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.temperature({endpoint=1,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.humidity({endpoint=1,component="main",minimum_interval=300,maximum_interval=3600,reportable_change=50,read_on_configure=false}),c.cluster_attribute(1032,0,{name="zflora_s_soil",endpoint=1,component="soil",data_type=f.Uint16,minimum_interval=600,maximum_interval=7200,reportable_change=100,read_only=true,read_on_configure=false,scale=100,emit=j.humidity()}),c.battery({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,reportable_change=1,from_device=e}),c.battery_voltage({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,from_device=e}),c.cluster_attribute(1,62,{name="zflora_s_battery_alarm",endpoint=1,component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(aR,{
m("EfektaLab","zFlora_S"),})local ah={
profile="sensors-efekta-zflora-promax-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.temperature({endpoint=1,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.humidity({endpoint=1,component="main",minimum_interval=300,maximum_interval=3600,reportable_change=50,read_on_configure=false}),c.illuminance({endpoint=1,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.cluster_attribute(1032,0,{name="zflora_promax_soil",endpoint=1,component="soil",data_type=f.Uint16,minimum_interval=600,maximum_interval=7200,reportable_change=100,read_only=true,read_on_configure=false,scale=100,emit=j.humidity()}),c.battery({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,reportable_change=1,from_device=e}),c.battery_voltage({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,from_device=e}),c.cluster_attribute(1,62,{name="zflora_promax_battery_alarm",endpoint=1,component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(ah,{
m("EfektaLab","zFlora_ProMax"),})local az={
profile="sensors-efekta-eflora-pro-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.temperature({endpoint=2,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.humidity({endpoint=2,component="main",minimum_interval=300,maximum_interval=3600,reportable_change=50,read_on_configure=false}),c.illuminance({endpoint=2,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.cluster_attribute(1032,0,{name="eflora_pro_soil",endpoint=3,component="soil",data_type=f.Uint16,minimum_interval=600,maximum_interval=7200,reportable_change=100,read_only=true,read_on_configure=false,scale=100,emit=j.humidity()}),c.battery({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,reportable_change=1,from_device=e}),c.battery_voltage({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,from_device=e}),c.cluster_attribute(1,62,{name="eflora_pro_battery_alarm",endpoint=1,component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(az,{
m("EfektaLab","EFEKTA_eFlora_Pro"),})local ay={
profile="sensors-efekta-eflora-max-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.temperature({endpoint=2,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.humidity({endpoint=2,component="main",minimum_interval=300,maximum_interval=3600,reportable_change=50,read_on_configure=false}),c.illuminance({endpoint=2,component="main",minimum_interval=120,maximum_interval=3600,reportable_change=25,read_on_configure=false}),c.cluster_attribute(1032,0,{name="eflora_soil",endpoint=3,component="soil",data_type=f.Uint16,minimum_interval=600,maximum_interval=7200,reportable_change=100,read_only=true,read_on_configure=false,scale=100,emit=j.humidity()}),c.battery({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,reportable_change=1,from_device=e}),c.battery_voltage({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,from_device=e}),c.cluster_attribute(1,62,{name="eflora_battery_alarm",endpoint=1,component="main",data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(ay,{
m("EfektaLab","EFEKTA_eFlora_Max_Pro"),})local ak={
profile="sensors-efekta-zflora-x-max-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
g(c.temperature({endpoint=1})),g(c.illuminance({endpoint=1})),c.cluster_attribute(1032,0,{name="zflora_x_max_soil",endpoint=1,data_type=f.Uint16,read_only=true,read_on_configure=false,scale=100,emit=j.humidity()}),c.cluster_attribute(1,33,{name="zflora_x_max_battery",endpoint=1,data_type=f.Uint8,read_only=true,read_on_configure=true,scale=2,from_device=e,emit=j.battery()}),},}h(ak,{
m("EfektaLab","zFlora_X_Max"),})local bR={
profile="sensors-efekta-eair-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1,33,1)c.read_attribute(b,1,32,1)
end,
zcl_clusters={
c.cluster_attribute(1037,0,{name="eair_co2",endpoint=1,data_type=f.SinglePrecisionFloat,read_only=true,read_on_configure=false,
from_device=function(a)return math.floor(a*1000000+0.5)end,emit=j.co2()}),
c.cluster_attribute(1,33,{name="eair_battery",endpoint=1,data_type=f.Uint8,read_only=true,read_on_configure=true,scale=2,from_device=e,emit=j.battery()}),c.cluster_attribute(1,62,{name="eair_battery_alarm",endpoint=1,data_type=f.Bitmap32,
read_only=true,read_on_configure=false,emit=function(_,a)
return(a&0xF03C0F)~=0 and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(bR,{
m("EfektaLab","EFEKTA_eAir_Monitor"),})local aZ={
profile="sensors-aircube-common-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1026,0,10)c.read_attribute(b,1029,0,10)c.read_attribute(b,64513,0,10)c.read_attribute(b,64513,1,10)c.read_attribute(b,64513,2,10)
end,
zcl_clusters={
c.temperature({endpoint=10,minimum_interval=10,maximum_interval=60,reportable_change=50}),c.humidity({endpoint=10,minimum_interval=10,maximum_interval=60,reportable_change=100}),c.cluster_attribute(64513,0,{name="aircube_equivalent_co2",endpoint=10,data_type=f.Uint16,read_only=true,read_on_configure=true,minimum_interval=10,maximum_interval=60,reportable_change=50,emit=j.airCubeEquivalentCo2()}),c.cluster_attribute(64513,1,{name="voc",endpoint=10,data_type=f.Uint16,read_only=true,read_on_configure=true,minimum_interval=10,maximum_interval=60,reportable_change=10,emit=j.voc("ppb")}),c.cluster_attribute(64513,2,{name="aircube_voc_level",endpoint=10,data_type=f.Uint16,read_only=true,read_on_configure=true,minimum_interval=10,maximum_interval=60,reportable_change=5,emit=j.airCubeVocLevel()}),},}h(aZ,{
m("StuckAtPrototype","AirCube"),})local am={
profile="safety-motion-nodieby-nd01-core",magic_packet=false,
parent_refresh=function(b)
c.read_attribute(b,1280,2,1)
end,
configure=function(_,b)
c.read_attribute(b,1280,2,1)
end,
zcl_clusters={
g(c.occupancy({endpoint=1,ias_zone=true,read_only=true,emit=j.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
if type(a)~="number"then return nil end
return(a&1)~=0
end})),
},}h(am,{
m("NoDieby","ND-01"),})local cl={
profile="sensors-besisglas-ms01",magic_packet=false,placeholder_custom_states=false,zcl_clusters={
c.motion({endpoint=1,configure_reporting=false,read_on_configure=false,read_only=true,
emit=function(b,a)
return{j.motion()(b,a),j.presence()(b,a)}
end}),
c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),c.battery_low({endpoint=1,configure_reporting=false,read_on_configure=false,
emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},protocol_writers={
besis_ms01_identify=function(b)
b:send(V.Identify.commands.Identify(b,3):to_endpoint(1))return true
end,
},}h(cl,{
m("zbeacon","MS01"),})local cm={
profile="sensors-besisglas-wl01",magic_packet=false,zcl_clusters={
g(c.water({endpoint=1,read_only=true})),c.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=e}),c.battery_low({endpoint=1,configure_reporting=false,read_on_configure=false,
emit=function(_,a)
return a and d.batteryLevel.battery.critical()or d.batteryLevel.battery.normal()
end}),
},}h(cm,{
m("Zbeacon","SNZB-05P"),})for _,s in ipairs({
{K,1,33,1,3600,65000,10},{ab,1,32,false,3600,65000,10},{I,1,33,false,3600,65000,10},{X,1,33,false,3600,65000,10},{S,1,33,false,3600,65000,10},{O,1030,0,1,0,3600,0},{A,1026,0,1,0,3600,0},{A,1029,0,1,0,3600,0},{A,1037,0,1,0,3600,0},})do
for _,q in ipairs(s[1].zcl_clusters)do
if q.cluster_id==s[2]and q.attribute_id==s[3]and
(s[4]==false or q.endpoint==s[4])then
q.reporting_defaults={minimum_interval=s[5],maximum_interval=s[6],reportable_change=s[7]}
end
end
end
for _,s in ipairs({
{M,z,10,3600,100,"zrThirdSoil"},{av,w,0,21600,0,"zrPwsSoil"},})do
for _,q in ipairs(s[1].zcl_clusters)do
if q.cluster_id==1032 or q.cluster_id==1029 then
local o=q.cluster_id
q.reporting_defaults={
minimum_interval=s[3],maximum_interval=s[4],reportable_change=s[5],
key=s[6],label="Soil moisture",supported=function(b)return s[2](b)==o end,
}
end
end
end
c.attach_reporting_capabilities(Y,{
{1,"rpt-com"},{2,"rpt-ceh"},{4,"rpt-cwy"},{5,"rpt-oof"},{6,"rpt-hqj"},{7,"rpt-zwu",{["zr040500001"]="Humidity",["zr040500002"]="HumidityTwo"}},{9,"rpt-tdw"},{11,"rpt-hvw"},{17,"rpt-cpj"},{18,"rpt-fgk"},{19,"rpt-sfw"},{20,"rpt-sfw"},{21,"rpt-psd"},{23,"rpt-sfw"},{24,"rpt-zfz"},{27,"rpt-zgg"},{28,"rpt-lrf"},{29,"rpt-zbf"},{30,"rpt-hux"},{31,"rpt-hux"},{32,"rpt-hah"},{33,"rpt-heu"},{34,"rpt-rzz"},{35,"rpt-riy"},{37,"rpt-sfw"},{38,"rpt-zuk"},{39,"rpt-zin"},{42,"rpt-zqa"},{43,"rpt-sxh"},{44,"rpt-muo"},{45,"rpt-wcq"},{46,"rpt-cid"},{47,"rpt-ska"},{49,"rpt-sbo"},{50,"rpt-zes",{["zr040200001"]="Temp",["zr040200002"]="TempTwo",["zr040500001"]="Humidity",["zr040500002"]="HumidityTwo"}},{51,"rpt-cbe"},{54,"rpt-tjf"},{55,"rpt-zsl"},{56,"rpt-hjr"},{57,"rpt-abc"},{60,"rpt-ovs"},{61,"rpt-cxe"},{62,"rpt-zqz"},{63,"rpt-uts"},{64,"rpt-zuh"},{65,"rpt-zmc"},{66,"rpt-mlr"},{67,"rpt-zlr"},{69,"rpt-cfw"},{70,"rpt-eal"},{71,"rpt-eff"},{72,"rpt-els"},{73,"rpt-eoa",{["zr040200001"]="Temp",["zr040200002"]="TempTwo",["zr040500001"]="Humidity",["zr040500002"]="HumidityTwo"}},{74,"rpt-tjc"},{75,"rpt-heu"},{77,"rpt-fje"},{78,"rpt-hux"},{79,"rpt-hux"},{80,"rpt-zuh"},{83,"rpt-txf"},{84,"rpt-tlps"},{85,"rpt-ldk"},{86,"rpt-wzu"},{87,"rpt-uti"},{88,"rpt-uti"},{89,"rpt-heu"},{90,"rpt-zea"},{91,"rpt-zea"},{92,"rpt-evv"},{94,"rpt-lhh"},{95,"rpt-mke"},{96,"rpt-rmm"},{97,"rpt-dkk"},{98,"rpt-evu"},{99,"rpt-uti"},{100,"rpt-uti"},{101,"rpt-zqa"},{102,"rpt-ezx"},{103,"rpt-wfi"},{105,"rpt-evv"},{106,"rpt-edu",{["zr040200001"]="Temp",["zr040200002"]="TempTwo",["zr040500001"]="Humidity",["zr040500002"]="HumidityTwo"}},{107,"rpt-etn",{["zr040200001"]="Temp",["zr040200002"]="TempTwo",["zr040500001"]="Humidity",["zr040500002"]="HumidityTwo"}},{108,"rpt-epb"},{109,"rpt-epb"},{110,"rpt-zbu"},{111,"rpt-epb"},{112,"rpt-epb"},{113,"rpt-epb"},{116,"rpt-ahd"},{118,"rpt-mml"},{119,"rpt-sdm"},})return{
id="zcl.sensors.simple_sensors",registrations=Y,}
