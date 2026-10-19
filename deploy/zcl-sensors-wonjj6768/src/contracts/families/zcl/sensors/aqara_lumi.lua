local g=require"protocol.zcl"
local T=require"contracts.helpers.family"
local V=T.create_fingerprint
local c=require"st.capabilities"
local s=require"capabilities.events.all"
local L=require"st.zigbee.data_types"
local H,l=T.definition_registry()local j=0
local m=65281
local function h(A)
local F=((A-2850)*100)/150
if F<0 then
return 0
elseif F>100 then
return 100
end
return math.floor(F+0.5)
end
local function i(an,aq)
if type(an)~="table"then
return nil
end
return an[aq]or an[tostring(aq)]
end
local function k(_,e)
local v=e
if type(v)=="table"and v.value~=nil then
v=v.value
end
if type(v)=="table"and v[65281]~=nil then
v=v[65281]elseif type(v)=="table"and v["65281"]~=nil then
v=v["65281"]
end
if type(v)~="table"then
return nil
end
local a={}local A=i(v,1)local q=i(v,100)local ak=i(v,101)local al=i(v,102)if type(A)=="number"then
a[#a+1]=c.battery.battery(h(A))a[#a+1]=c.voltageMeasurement.voltage({value=A/1000,unit="V"})
end
if type(q)=="number"then
local ag=q/100
if ag>-65 and ag<65 then
a[#a+1]=c.temperatureMeasurement.temperature({value=ag,unit="C"})
end
end
if type(ak)=="number"then
local F=ak/100
if F>=0 and F<=100 then
a[#a+1]=c.relativeHumidityMeasurement.humidity(F)
end
end
if type(al)=="number"then
a[#a+1]=c.atmosphericPressureMeasurement.atmosphericPressure({value=al/1000,unit="kPa"})
end
return a[1]~=nil and a or nil
end
local O={
profile="sensors-temp-humidity-battery-voltage",reporting_capability_exclusions={["*"]="Z2M WSDCGQ01LM uses Lumi Basic reports/check-in; standard reporting control support is unconfirmed."},zcl_clusters={
g.cluster_attribute(j,m,{
name="lumi_basic",emit=k,read_only=true,}),g.temperature(),g.humidity(),g.battery(),},}local R={
profile="sensors-temp-humidity-pressure-battery-voltage",reporting_capability_exclusions={["*"]="Z2M WSDCGQ11LM uses Lumi Basic/measurement reports; standard reporting control support is unconfirmed."},zcl_clusters={
g.cluster_attribute(j,m,{
name="lumi_basic",emit=k,read_only=true,}),g.temperature(),g.humidity(),g.pressure(),g.cluster_attribute(1027,20,{
read_only=true,read_on_configure=true,configure_reporting=false,
from_device=function(e,d)
d:set_field("pressure_scale",e~=-128 and e or nil)
end,
}),g.cluster_attribute(1027,16,{
read_only=true,configure_reporting=false,
from_device=function(e,d)
local aw=d:get_field("pressure_scale")
if aw and e~=-32768 then return e/(10 ^ aw)/1000 end
end,
emit=s.atmospheric_pressure(),}),g.battery(),g.battery_voltage(),},}local ap={
profile="sensors-illuminance-battery-voltage-lumi-pending",zcl_clusters={
g.illuminance(),g.battery(),g.battery_voltage(),},}
local function b(e)
return type(e)=="table"and e.value or e
end
local function J(d,aa)
local am=d:get_field("__lumi_motion_timer")
if am then am:cancel()end
d:set_field("__lumi_motion_timer",nil)if aa>0 then
d:set_field("__lumi_motion_timer",d.thread:call_with_delay(aa,function()
d:set_field("__lumi_motion_timer",nil)d:emit_event(c.motionSensor.motion.inactive())
end,"Aqara motion reset"))
end
end
local function ae(y,z)
return function(d,af)
af=b(af)local E=d:get_field("__lumi_detection_interval")or y
local K=tonumber(d.preferences.occupancyTimeout)local aa=z and(K or 90)or((K and K>=E)and K or E+2)J(d,aa)local aD=z and af or(af>130536 and 0 or af-65536)return{c.motionSensor.motion.active(),c.illuminanceMeasurement.illuminance(math.max(0,aD))}
end
end
local function w(Q,u,p1,p)
return function(d,e)
local f=b(e)if type(f)=="string"then
local S,r={},1
while r+1<=#f do
local aq,M=f:byte(r,r+1)local width=M>=32 and M<=47 and((M%8)+1)or M==16 and 1
if not width or r+1+width>#f then break end
S[aq]=string.unpack("<"..(M>=40 and"i"or"I")..width,f,r+2)r=r+2+width
end
f=S
end
if type(f)~="table"then return end
local a={}local G=b(f[1]or f["1"])if type(G)=="number"then
a[#a+1]=c.battery.battery(h(G))a[#a+1]=c.voltageMeasurement.voltage({value=G/1000,unit="V"})
end
local q=b(f[3]or f["3"])
if Q and type(q)=="number"then a[#a+1]=Q(d,q)end
local N=b(f[5]or f["5"])
if p and type(N)=="number"then a[#a+1]=p(d,N-1)end
local E=b(f[105]or f["105"])if p1 and type(E)=="number"then
d:set_field("__lumi_detection_interval",E)a[#a+1]=u(d,E)
end
if p1 then
local ac=({[1]="low",[2]="medium",[3]="high"})[b(f[106]or f["106"])]
if ac then a[#a+1]=s.aqP1Sensitivity()(d,ac)end
local indicator=b(f[107]or f["107"])
if indicator~=nil then a[#a+1]=s.aqP1Indicator()(d,indicator==1 and"on"or"off")end
end
return #a>0 and a or nil
end
end
local function P(d,e)
local f=b(e)if type(f)=="string"then
local S,r={},1
while r+1<=#f do
local aq,M=f:byte(r,r+1)local width=M>=32 and M<=47 and((M%8)+1)or M==16 and 1
if not width or r+1+width>#f then break end
S[aq]=string.unpack("<"..(M>=40 and"i"or"I")..width,f,r+2)r=r+2+width
end
f=S
end
if type(f)~="table"then return end
local a=k(d,{
[1]=b(i(f,1)),[100]=b(i(f,100)),[101]=b(i(f,101)),})or{}local q=b(i(f,3))if type(q)=="number"then
a[#a+1]=s.t1HtDeviceTemperature("C")(d,q)
end
local ar=b(i(f,5))if type(ar)=="number"then
a[#a+1]=s.t1HtPowerOutageCount()(d,ar-1)
end
return #a>0 and a or nil
end
local ao={
profile="sensors-aqara-t1-ht",magic_packet=false,
parent_refresh=function(d)
for _,ai in ipairs({{1026,0},{1029,0},{1027,0},{1,33},{1,32}})do
g.read_attribute(d,ai[1],ai[2],1)
end
end,
zcl_clusters={
g.cluster_attribute(0,65281,{
name="t1_ht_basic_heartbeat",endpoint=1,read_only=true,read_on_configure=false,emit=P,}),g.cluster_attribute(64704,247,{
name="t1_ht_heartbeat",endpoint=1,read_only=true,read_on_configure=false,emit=P,}),g.temperature({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),g.humidity({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100}),g.pressure({endpoint=1,scale=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,
emit=function(_,e)
return c.atmosphericPressureMeasurement.atmosphericPressure({value=e,unit="hPa"})
end}),
g.battery({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
from_device=function(e,_,ah)return ah.raw_value<255 and e or nil end}),
g.battery_voltage({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
from_device=function(e,_,ah)return ah.raw_value<255 and e or nil end,
emit=function(_,e)
return{c.voltageMeasurement.voltage({value=e,unit="V"}),c.battery.battery(h(e*1000))}
end}),
},}
local function U(d,e)
if b(e)~=1 then return end
J(d,tonumber(d.preferences.occupancyTimeout)or 90)return c.motionSensor.motion.active()
end
local function C(p)
return g.cluster_attribute(0,65282,{
name="lumi_struct_battery",read_only=true,read_on_configure=false,
emit=function(d,e)
local D,a=e.elements,{}local G=D and D[2]and b(D[2].data)if type(G)=="number"then
a[#a+1]=c.battery.battery(h(G))a[#a+1]=c.voltageMeasurement.voltage({value=G/1000,unit="V"})
end
local N=D and D[5]and b(D[5].data)
if p and type(N)=="number"then a[#a+1]=p(d,N-1)end
return #a>0 and a or nil
end,
})
end
local az={
profile="safety-lumi-motion",zcl_clusters={
g.cluster_attribute(1030,0,{
name="lumi_occupancy",read_only=true,read_on_configure=false,emit=U,}),g.cluster_attribute(j,m,{
name="lumi_basic",read_only=true,read_on_configure=false,emit=w(nil,nil,nil,s.miMotionRestarts()),}),C(s.miMotionRestarts()),},}
local function o(ax,Q,u,aj,y,p1,p)
local z=u==nil
local n={profile=ax,zcl_clusters={
g.cluster_attribute(z and 1024 or 64704,z and 0 or 274,{
name="lumi_motion_light",read_only=true,read_on_configure=false,emit=ae(y,z),}),g.cluster_attribute(z and 0 or 64704,z and 65281 or 247,{
name="lumi_motion_diagnostics",read_only=true,read_on_configure=false,emit=w(Q,u,p1,p),}),}}if z then
n.zcl_clusters[#n.zcl_clusters+1]=C(p)n.zcl_clusters[#n.zcl_clusters+1]=g.cluster_attribute(1030,0,{
name="lumi_occupancy",read_only=true,read_on_configure=false,emit=U,})else
local Z=g.battery({read_on_configure=false,read_only=true})Z.minimum_interval,Z.maximum_interval,Z.reportable_change=nil,nil,nil
n.zcl_clusters[#n.zcl_clusters+1]=Z
n.zcl_clusters[#n.zcl_clusters+1]=g.cluster_attribute(64704,258,{
name=aj,mfg_code=4447,read_only=true,read_on_configure=true,emit=u,from_device=b,
handler=function(d,e)d:set_field("__lumi_detection_interval",e)end,
})n.zcl_clusters[#n.zcl_clusters+1]=g.cluster_attribute(1,32,{
name="lumi_battery_voltage",read_only=true,read_on_configure=true,
emit=function(_,e)
local af=b(e)
if af==255 then return end
return{c.battery.battery(h(af*100)),c.voltageMeasurement.voltage({value=af/10,unit="V"})}
end,
})
end
return n
end
local as=o("safety-aqara-motion-m11",s.aqM11DeviceTemp("C"),nil,nil,nil,nil,s.aqM11Restarts())local av=o("safety-aqara-motion-t1",s.aqT1DeviceTemp("C"),s.aqT1Interval("s"),"aq_t_one_interval",60,nil,s.aqT1Restarts())local au=o("safety-aqara-motion-e1",s.aqE1DeviceTemp("C"),s.aqE1Interval("s"),"aq_e_one_interval",60,nil,s.aqE1Restarts())local I=o("safety-aqara-motion-p1",s.aqP1DeviceTemp("C"),s.aqP1Interval("s"),"aq_p_one_interval",30,true)I.zcl_clusters[#I.zcl_clusters+1]=g.cluster_attribute(64704,268,{
name="aq_p_one_sensitivity",data_type=L.Uint8,write_type=L.Uint8,mfg_code=4447,read_on_configure=true,emit=s.aqP1Sensitivity(),
from_device=function(e)return({[1]="low",[2]="medium",[3]="high"})[b(e)]end,
to_device=function(e)return({low=1,medium=2,high=3})[e]end,
})I.zcl_clusters[#I.zcl_clusters+1]=g.cluster_attribute(64704,338,{
name="aq_p_one_indicator",data_type=L.Uint8,write_type=L.Uint8,mfg_code=4447,read_on_configure=true,emit=s.aqP1Indicator(),
from_device=function(e)return b(e)==1 and"on"or"off"end,
to_device=function(e)return({on=1,off=0})[e]end,
})
local function B()
return g.switch("contact",{
emit=s.contact(),read_only=true,})
end
local ad={
profile="safety-contact-battery-voltage",zcl_clusters={
B(),g.cluster_attribute(j,m,{
name="lumi_basic",emit=k,read_only=true,}),},}local ab={
profile="safety-contact-tamper-battery-voltage",zcl_clusters={
B(),g.tamper(),g.cluster_attribute(j,m,{
name="lumi_basic",emit=k,read_only=true,}),g.battery(),g.battery_voltage(),},}local X={
profile="safety-contact-battery-low-battery-voltage",zcl_clusters={
g.contact(),g.battery_low(),g.battery(),g.battery_voltage(),},}local Y={
profile="safety-contact-battery-voltage",zcl_clusters={
g.contact(),g.battery(),g.battery_voltage(),},}local x={
profile="safety-water-leak-battery-low-battery-voltage",zcl_clusters={
g.water(),g.battery_low(),g.cluster_attribute(j,m,{
name="lumi_basic",emit=k,read_only=true,}),g.battery(),g.battery_voltage(),},}local t={
profile="safety-water-leak-tamper-battery-low-battery-voltage",zcl_clusters={
g.water(),g.tamper(),g.battery_low(),g.cluster_attribute(j,m,{
name="lumi_basic",emit=k,read_only=true,}),g.battery(),g.battery_voltage(),},}local ay={
profile="lights-dimmer",zcl_clusters={
g.switch(),g.level(),},}local aB={
profile="switches-switch-1",zcl_clusters={
g.switch(),},}l(O,{
V("LUMI","lumi.sens"),V("LUMI","lumi.sensor_ht"),})l(R,{
V("LUMI","lumi.weather"),})l(ao,{
V("LUMI","lumi.sensor_ht.agl02"),})l(ap,{
V("LUMI","lumi.sen_ill.agl01"),V("LUMI","lumi.sen_ill.mgl01"),})l(az,{
V("LUMI","lumi.sensor_motion"),})l(I,{
V("LUMI","lumi.motion.ac02"),})l(au,{
V("LUMI","lumi.motion.acn001"),})l(av,{
V("LUMI","lumi.motion.agl02"),})l(as,{
V("LUMI","lumi.sensor_motion.aq2"),})l(ab,{
V("LUMI","lumi.magnet.ac01"),})l(X,{
V("LUMI","lumi.magnet.acn001"),})l(Y,{
V("LUMI","lumi.magnet.agl02"),})l(ad,{
V("LUMI","lumi.sensor_magnet"),V("LUMI","lumi.sensor_magnet.aq2"),})l(x,{
V("LUMI","lumi.flood.acn001"),V("LUMI","lumi.sensor_wleak.aq1"),})l(t,{
V("LUMI","lumi.flood.agl02"),})g.attach_reporting_capabilities(H,{
{1,"sensors-temp-humidity-battery-voltage",{["zr00010021auto"]=false,["zr04020000auto"]=false,["zr04050000auto"]=false}},{2,"sensors-temp-humidity-pressure-battery-voltage",{["zr00010020auto"]=false,["zr00010021auto"]=false,["zr04020000auto"]=false,["zr04030000auto"]=false,["zr04050000auto"]=false}},{3,"rpt-lno"},{4,"rpt-lvz"},{10,"rpt-lzl"},{11,"rpt-tku"},{12,"rpt-tvc"},{13,"rpt-lhf"},{14,"rpt-lbp"},{15,"rpt-ljh"},})return{
id="zcl.sensors.aqara_lumi",registrations=H,}
