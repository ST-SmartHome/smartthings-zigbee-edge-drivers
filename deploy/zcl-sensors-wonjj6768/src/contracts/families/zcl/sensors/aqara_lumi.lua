local i=require"protocol.zcl"
local ai=require"contracts.helpers.family"
local fp=ai.create_fingerprint
local e=require"st.capabilities"
local v=require"capabilities.events.all"
local C=require"st.zigbee.data_types"
local U,n=ai.definition_registry()local k=0
local p=65281
local function j(N)
local H=((N-2850)*100)/150
if H<0 then
return 0
elseif H>100 then
return 100
end
return math.floor(H+0.5)
end
local function g(aV,aP)
if type(aV)~="table"then
return nil
end
return aV[aP]or aV[tostring(aP)]
end
local function m(_,b)
local G=b
if type(G)=="table"and G.value~=nil then
G=G.value
end
if type(G)=="table"and G[65281]~=nil then
G=G[65281]elseif type(G)=="table"and G["65281"]~=nil then
G=G["65281"]
end
if type(G)~="table"then
return nil
end
local c={}local N=g(G,1)local x=g(G,100)local aS=g(G,101)local aU=g(G,102)if type(N)=="number"then
c[#c+1]=e.battery.battery(j(N))c[#c+1]=e.voltageMeasurement.voltage{value=N/1000,unit="V"}
end
if type(x)=="number"then
local aL=x/100
if aL>-65 and aL<65 then
c[#c+1]=e.temperatureMeasurement.temperature{value=aL,unit="C"}
end
end
if type(aS)=="number"then
local H=aS/100
if H>=0 and H<=100 then
c[#c+1]=e.relativeHumidityMeasurement.humidity(H)
end
end
if type(aU)=="number"then
c[#c+1]=e.atmosphericPressureMeasurement.atmosphericPressure{value=aU/1000,unit="kPa"}
end
return c[1]~=nil and c or nil
end
local ad={
profile="sensors-temp-humidity-battery-voltage",reporting_capability_exclusions={["*"]="Z2M WSDCGQ01LM uses Lumi Basic reports/check-in; standard reporting control support is unconfirmed."},zcl_clusters={
i.cluster_attribute(k,p,{
name="lumi_basic",emit=m,read_only=true}),i.temperature(),i.humidity(),i.battery()}}local ah={
profile="sensors-temp-humidity-pressure-battery-voltage",reporting_capability_exclusions={["*"]="Z2M WSDCGQ11LM uses Lumi Basic/measurement reports; standard reporting control support is unconfirmed."},zcl_clusters={
i.cluster_attribute(k,p,{
name="lumi_basic",emit=m,read_only=true}),i.temperature(),i.humidity(),i.pressure(),i.cluster_attribute(1027,20,{
read_only=true,read_on_configure=true,configure_reporting=false,
from_device=function(b,a)
a:set_field("pressure_scale",b~=-128 and b or nil)
end
}),i.cluster_attribute(1027,16,{
read_only=true,configure_reporting=false,
from_device=function(b,a)
local bm=a:get_field"pressure_scale"
if bm and b~=-32768 then return b/(10 ^ bm)/1000 end
end,
emit=v.atmospheric_pressure()}),i.battery(),i.battery_voltage()}}local aZ={
profile="sensors-illuminance-battery-voltage-lumi-pending",zcl_clusters={
i.illuminance(),i.battery(),i.battery_voltage()}}
local function d(b)
return type(b)=="table"and b.value or b
end
local function X(a,S)
local aa=a:get_field"__lumi_motion_timer"
if aa then aa:cancel()end
a:set_field("__lumi_motion_timer",nil)if S>0 then
a:set_field("__lumi_motion_timer",a.thread:call_with_delay(S,function()
a:set_field("__lumi_motion_timer",nil)a:emit_event(e.motionSensor.motion.inactive())
end,"Aqara motion reset"))
end
end
local function aH(K,M)
return function(a,ao)
ao=d(ao)local s=a:get_field"__lumi_detection_interval"or K
local B=tonumber(a.preferences.occupancyTimeout)local S=M and(B or 90)or((B and B>=s)and B or s+2)X(a,S)local bp=M and ao or(ao>130536 and 0 or ao-65536)return{e.motionSensor.motion.active(),e.illuminanceMeasurement.illuminance(math.max(0,bp))}
end
end
local function A(ag,E,p1,w)
return function(a,b)
local h=d(b)if type(h)=="string"then
local y,l={},1
while l+1<=#h do
local aP,z=h:byte(l,l+1)local width=z>=32 and z<=47 and((z%8)+1)or z==16 and 1
if not width or l+1+width>#h then break end
y[aP]=string.unpack("<"..(z>=40 and"i"or"I")..width,h,l+2)l=l+2+width
end
h=y
end
if type(h)~="table"then return end
local c={}local T=d(h[1]or h["1"])if type(T)=="number"then
c[#c+1]=e.battery.battery(j(T))c[#c+1]=e.voltageMeasurement.voltage{value=T/1000,unit="V"}
end
local x=d(h[3]or h["3"])
if ag and type(x)=="number"then c[#c+1]=ag(a,x)end
local ac=d(h[5]or h["5"])
if w and type(ac)=="number"then c[#c+1]=w(a,ac-1)end
local s=d(h[105]or h["105"])if p1 and type(s)=="number"then
a:set_field("__lumi_detection_interval",s)c[#c+1]=E(a,s)
end
if p1 then
local I=({[1]="low",[2]="medium",[3]="high"})[d(h[106]or h["106"])]
if I then c[#c+1]=v.aqP1Sensitivity()(a,I)end
local indicator=d(h[107]or h["107"])
if indicator~=nil then c[#c+1]=v.aqP1Indicator()(a,indicator==1 and"on"or"off")end
end
return #c>0 and c or nil
end
end
local function af(a,b)
local h=d(b)if type(h)=="string"then
local y,l={},1
while l+1<=#h do
local aP,z=h:byte(l,l+1)local width=z>=32 and z<=47 and((z%8)+1)or z==16 and 1
if not width or l+1+width>#h then break end
y[aP]=string.unpack("<"..(z>=40 and"i"or"I")..width,h,l+2)l=l+2+width
end
h=y
end
if type(h)~="table"then return end
local c=m(a,{
[1]=d(g(h,1)),[100]=d(g(h,100)),[101]=d(g(h,101))})or{}local x=d(g(h,3))if type(x)=="number"then
c[#c+1]=v.t1HtDeviceTemperature"C"(a,x)
end
local bc=d(g(h,5))if type(bc)=="number"then
c[#c+1]=v.t1HtPowerOutageCount()(a,bc-1)
end
return #c>0 and c or nil
end
local aY={
profile="sensors-aqara-t1-ht",magic_packet=false,
parent_refresh=function(a)
for _,t in ipairs{{1026,0},{1029,0},{1027,0},{1,33},{1,32}}do
i.read_attribute(a,t[1],t[2],1)
end
end,
zcl_clusters={
i.cluster_attribute(0,65281,{
name="t1_ht_basic_heartbeat",endpoint=1,read_only=true,read_on_configure=false,emit=af}),i.cluster_attribute(64704,247,{
name="t1_ht_heartbeat",endpoint=1,read_only=true,read_on_configure=false,emit=af}),i.temperature{endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100},i.humidity{endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=100},i.pressure{endpoint=1,scale=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,
emit=function(_,b)
return e.atmosphericPressureMeasurement.atmosphericPressure{value=b,unit="hPa"}
end},
i.battery{endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
from_device=function(b,_,L)return L.raw_value<255 and b or nil end},
i.battery_voltage{endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
from_device=function(b,_,L)return L.raw_value<255 and b or nil end,
emit=function(_,b)
return{e.voltageMeasurement.voltage{value=b,unit="V"},e.battery.battery(j(b*1000))}
end}
}}
local function am(a,b)
if d(b)~=1 then return end
X(a,tonumber(a.preferences.occupancyTimeout)or 90)return e.motionSensor.motion.active()
end
local function Q(w)
return i.cluster_attribute(0,65282,{
name="lumi_struct_battery",read_only=true,read_on_configure=false,
emit=function(a,b)
local R,c=b.elements,{}local T=R and R[2]and d(R[2].data)if type(T)=="number"then
c[#c+1]=e.battery.battery(j(T))c[#c+1]=e.voltageMeasurement.voltage{value=T/1000,unit="V"}
end
local ac=R and R[5]and d(R[5].data)
if w and type(ac)=="number"then c[#c+1]=w(a,ac-1)end
return #c>0 and c or nil
end
})
end
local bq={
profile="safety-lumi-motion",zcl_clusters={
i.cluster_attribute(1030,0,{
name="lumi_occupancy",read_only=true,read_on_configure=false,emit=am}),i.cluster_attribute(k,p,{
name="lumi_basic",read_only=true,read_on_configure=false,emit=A(nil,nil,nil,v.miMotionRestarts())}),Q(v.miMotionRestarts())}}
local function u(bn,ag,E,aQ,K,p1,w)
local M=E==nil
local q={profile=bn,zcl_clusters={
i.cluster_attribute(M and 1024 or 64704,M and 0 or 274,{
name="lumi_motion_light",read_only=true,read_on_configure=false,emit=aH(K,M)}),i.cluster_attribute(M and 0 or 64704,M and 65281 or 247,{
name="lumi_motion_diagnostics",read_only=true,read_on_configure=false,emit=A(ag,E,p1,w)})}}if M then
q.zcl_clusters[#q.zcl_clusters+1]=Q(w)q.zcl_clusters[#q.zcl_clusters+1]=i.cluster_attribute(1030,0,{
name="lumi_occupancy",read_only=true,read_on_configure=false,emit=am})else
local aA=i.battery{read_on_configure=false,read_only=true}aA.minimum_interval,aA.maximum_interval,aA.reportable_change=nil,nil,nil
q.zcl_clusters[#q.zcl_clusters+1]=aA
q.zcl_clusters[#q.zcl_clusters+1]=i.cluster_attribute(64704,258,{
name=aQ,mfg_code=4447,read_only=true,read_on_configure=true,emit=E,from_device=d,
handler=function(a,b)a:set_field("__lumi_detection_interval",b)end
})q.zcl_clusters[#q.zcl_clusters+1]=i.cluster_attribute(1,32,{
name="lumi_battery_voltage",read_only=true,read_on_configure=true,
emit=function(_,b)
local ao=d(b)
if ao==255 then return end
return{e.battery.battery(j(ao*100)),e.voltageMeasurement.voltage{value=ao/10,unit="V"}}
end
})
end
return q
end
local bd=u("safety-aqara-motion-m11",v.aqM11DeviceTemp"C",nil,nil,nil,nil,v.aqM11Restarts())local bf=u("safety-aqara-motion-t1",v.aqT1DeviceTemp"C",v.aqT1Interval"s","aq_t_one_interval",60,nil,v.aqT1Restarts())local be=u("safety-aqara-motion-e1",v.aqE1DeviceTemp"C",v.aqE1Interval"s","aq_e_one_interval",60,nil,v.aqE1Restarts())local o=u("safety-aqara-motion-p1",v.aqP1DeviceTemp"C",v.aqP1Interval"s","aq_p_one_interval",30,true)o.zcl_clusters[#o.zcl_clusters+1]=i.cluster_attribute(64704,268,{
name="aq_p_one_sensitivity",data_type=C.Uint8,write_type=C.Uint8,mfg_code=4447,read_on_configure=true,emit=v.aqP1Sensitivity(),
from_device=function(b)return({[1]="low",[2]="medium",[3]="high"})[d(b)]end,
to_device=function(b)return({low=1,medium=2,high=3})[b]end
})o.zcl_clusters[#o.zcl_clusters+1]=i.cluster_attribute(64704,338,{
name="aq_p_one_indicator",data_type=C.Uint8,write_type=C.Uint8,mfg_code=4447,read_on_configure=true,emit=v.aqP1Indicator(),
from_device=function(b)return d(b)==1 and"on"or"off"end,
to_device=function(b)return({on=1,off=0})[b]end
})
local function P()
return i.switch("contact",{
emit=v.contact(),read_only=true})
end
local aD={
profile="safety-contact-battery-voltage",zcl_clusters={
P(),i.cluster_attribute(k,p,{
name="lumi_basic",emit=m,read_only=true})}}local f={
profile="safety-contact-tamper-battery-voltage",zcl_clusters={
P(),i.tamper(),i.cluster_attribute(k,p,{
name="lumi_basic",emit=m,read_only=true}),i.battery(),i.battery_voltage()}}do
local au=require"st.zigbee.cluster_base"
local as,W={persist=true},{persist=false}local V="aqara_p1:"
local aM=v.aqP1IntervalV2"s"local aj=v.aqContactP1Distance()local ba=v.aqP1NoOccupancySince"s"local aO={[1]="10mm",[2]="20mm",[3]="30mm"}local aG={["10mm"]=1,["20mm"]=2,["30mm"]=3}
local function ak(b)
return type(b)=="number"and b==b and b>-math.huge and b<math.huge
end
local function az(b)
return ak(b)and b%1==0 and b>=2 and b<=255
end
local function h(b)
b=d(b)
if type(b)=="table"then return b end
if type(b)~="string"then return{}end
local bi,l={},1
while l+1<=#b do
local aP,z=b:byte(l,l+1)local width=(z>=32 and z<=37 or z>=40 and z<=45)and(z%8+1)or z==16 and 1 or z==57 and 4 or z==58 and 8
if not width or l+width+1>#b then break end
local format=z==57 and"f"or z==58 and"d"or
((z>=40 and"i"or"I")..width)bi[aP]=string.unpack("<"..format,b,l+2)l=l+width+2
end
return bi
end
local function ae(a,b,L)
local aJ=L and L.typed_value
if type(aJ)=="table"and(aJ.ID==57 or aJ.ID==58)then
b=string.unpack(aJ.ID==57 and"<f"or"<d",aJ:_serialize())
end
if type(b)=="table"then b=b.value end
if type(b)=="boolean"then b=b and 1 or 0 end
if not ak(b)then return end
a:set_field("__lumi_detection_interval",b,as)return aM(a,b)
end
local function ab(a,t,r)
local ap=au.read_manufacturer_specific_attribute(a,64704,t,4447):to_endpoint(1)
if r then ap.body.zcl_header.frame_ctrl:set_disable_default_response()end
return a:send(ap)~=false
end
local function aX(a,aB,b)
local t=aB.attribute_id
if t==258 then
if not az(b)then return false end
elseif aB.to_device then
b=aB.to_device(b)
if b==nil then return false end
else
if type(b)~="string"then return false end
b=aG[b:lower()]
if b==nil then return false end
end
local ap=au.write_manufacturer_specific_attribute(a,64704,t,4447,C.Uint8,b):to_endpoint(1)local r=aB.name~="aq_contact_p_one_distance"
if r then ap.body.zcl_header.frame_ctrl:set_disable_default_response()end
if not pcall(a.send,a,ap)then return false end
pcall(ab,a,t,r)return true
end
o.zcl_clusters[4]=i.cluster_attribute(64704,258,{
name="aq_p_one_interval",endpoint=1,mfg_code=4447,write_type=C.Uint8,sender=aX,suppress_optimistic_state=true,read_on_configure=false,emit=ae})for _,Y in ipairs{6,7}do
o.zcl_clusters[Y].read_on_configure=false
o.zcl_clusters[Y].sender=aX
o.zcl_clusters[Y].suppress_optimistic_state=true
end
o.configure=function(_,a)
for _,t in ipairs{258,268,338}do ab(a,t,true)end
end
o.parent_refresh=function(a)
i.read_attribute(a,1,32,1)
for _,t in ipairs{258,268,338}do ab(a,t,true)end
end
local aC=A(v.aqP1DeviceTemp"C",nil,false)
o.zcl_clusters[2].emit=function(a,ao)
local y=h(ao)local c=aC(a,y)or{}local s=ae(a,g(y,105))
if s then c[#c+1]=s end
local I=({[1]="low",[2]="medium",[3]="high"})[d(g(y,106))]
if I then c[#c+1]=v.aqP1Sensitivity()(a,I)end
local indicator=d(g(y,107))
if indicator~=nil then c[#c+1]=v.aqP1Indicator()(a,indicator==1 and"on"or"off")end
return #c>0 and c or nil
end
local function aF(a)
local aW=a.preferences.aqP1NoOccupancySeconds
if aW==nil or type(aW)=="string"and aW:match"^%s*$"then
a:set_field(V.."since_thresholds",{},as)return{}
end
if type(aW)~="string"then return a:get_field(V.."since_thresholds")or{}end
local aK={}for bv in(aW..","):gmatch"(.-),"do
local b=tonumber(bv)
if not ak(b)or b<0 then return a:get_field(V.."since_thresholds")or{}end
aK[#aK+1]=b
end
a:set_field(V.."since_thresholds",aK,as)return aK
end
local function aI(bo)
local Z=bo*1000
if Z<1 or Z>2147483647 then return 0.001 end
return math.floor(Z)/1000
end
o.zcl_clusters[1].emit=function(a,ao)
local aa=a:get_field"__lumi_motion_timer"if aa then
a.thread:cancel_timer(aa)a:set_field("__lumi_motion_timer",nil,W)
end
local ay=a:get_field(V.."since_timers")or{}
for _,bu in ipairs(ay)do a.thread:cancel_timer(bu)end
ay={}a:set_field(V.."since_timers",ay,W)for _,b in ipairs(aF(a))do
ay[#ay+1]=a.thread:call_with_delay(aI(b),function()
local bl=ba(a,b)bl.state_change=true
a:emit_event(bl)
end,"Aqara P1 no occupancy since")
end
local s=a:get_field"__lumi_detection_interval"
if s==nil then s=30 end
local B=tonumber(a.preferences.occupancyTimeout)local S=B~=nil and B>=s and B or s+2
if S~=0 then
a:set_field("__lumi_motion_timer",a.thread:call_with_delay(aI(S),function()
a:set_field("__lumi_motion_timer",nil,W)a:emit_event(e.motionSensor.motion.inactive())
end,"Aqara P1 motion reset"),W)
end
local bg=d(ao)local bp=bg>130536 and 0 or bg-65536
return{e.motionSensor.motion.active(),e.illuminanceMeasurement.illuminance(math.max(0,bp))}
end
local function av(a,ar)
if not ak(ar)then return end
local an,maximum=a.preferences.aqContactP1BatteryMinMv,a.preferences.aqContactP1BatteryMaxMv
if not ak(an)or not ak(maximum)or an>=maximum then an,maximum=2850,3000 end
local H=math.floor(math.max(0,math.min(100,(ar-an)*100/(maximum-an)))+0.5)return{e.battery.battery(H),e.voltageMeasurement.voltage{value=ar/1000,unit="V"}}
end
f.profile="safety-aqara-contact-p1"
f.button_actions={"pushed"}f.reporting_capability_exclusions={
["*"]="Z2M MCCGQ13LM uses native reports and check-in; configurable reporting support is unconfirmed."}f.zcl_clusters[#f.zcl_clusters+1]=i.contact()f.zcl_clusters[5].scale=nil
f.zcl_clusters[5].from_device=function(_,_,L)return L.raw_value end
f.zcl_clusters[5].emit=function(a,b)
b=d(b)
if b==255 then return end
return av(a,b*100)
end
f.zcl_clusters[#f.zcl_clusters+1]=i.cluster_attribute(64704,247,{
name="aq_contact_p_one_heartbeat",endpoint=1,read_only=true,read_on_configure=false,
emit=function(a,b)
local y=h(b)local c=av(a,d(g(y,1)))or{}local aR=aO[d(g(y,159))]
if aR then c[#c+1]=aj(a,aR)end
return #c>0 and c or nil
end
})f.zcl_clusters[#f.zcl_clusters+1]=i.cluster_attribute(64704,268,{
name="aq_contact_p_one_distance",endpoint=1,mfg_code=4447,write_type=C.Uint8,sender=aX,suppress_optimistic_state=true,read_on_configure=false,
from_device=function(b)return aO[d(b)]end,emit=aj
})
f.zigbee_message_handler=function(a,rx)
local al,bb=rx.body and rx.body.zcl_header,rx.address_header
if not al or bb.src_endpoint.value~=1 or bb.cluster.value~=0 or
al.cmd.value~=10 or al.frame_ctrl:is_cluster_specific_set()or
not al.frame_ctrl:is_direction_set()then return end
local aE=al.seqno and al.seqno.value
if aE~=nil then
local br=math.floor(require"cosock.socket".gettime()*1000)local F=a:get_field(V.."action_transactions")or{}for _,bk in ipairs(F)do
if bk.sequence==aE and bk.expires>br then return end
end
for Y=#F,1,-1 do if F[Y].expires<=br then table.remove(F,Y)end end
if #F>4 then
local aT=1
for Y=2,#F do if F[Y].expires<F[aT].expires then aT=Y end end
table.remove(F,aT)
end
F[#F+1]={sequence=aE,expires=br+10000}a:set_field(V.."action_transactions",F,W)
end
for _,bh in ipairs(rx.body.zcl_body.attr_records or{})do
if bh.attr_id.value==5 and bh.data.value=="lumi.magnet.ac01"then
a:emit_event(e.button.button.pushed{state_change=true})break
end
end
end
end
local at={
profile="safety-contact-battery-low-battery-voltage",zcl_clusters={
i.contact(),i.battery_low(),i.battery(),i.battery_voltage()}}local ax={
profile="safety-contact-battery-voltage",zcl_clusters={
i.contact(),i.battery(),i.battery_voltage()}}local J={
profile="safety-water-leak-battery-low-battery-voltage",zcl_clusters={
i.water(),i.battery_low(),i.cluster_attribute(k,p,{
name="lumi_basic",emit=m,read_only=true}),i.battery(),i.battery_voltage()}}local D={
profile="safety-water-leak-tamper-battery-low-battery-voltage",zcl_clusters={
i.water(),i.tamper(),i.battery_low(),i.cluster_attribute(k,p,{
name="lumi_basic",emit=m,read_only=true}),i.battery(),i.battery_voltage()}}n(ad,{
fp("LUMI","lumi.sens"),fp("LUMI","lumi.sensor_ht")})n(ah,{
fp("LUMI","lumi.weather")})n(aY,{
fp("LUMI","lumi.sensor_ht.agl02")})n(aZ,{
fp("LUMI","lumi.sen_ill.agl01"),fp("LUMI","lumi.sen_ill.mgl01")})n(bq,{
fp("LUMI","lumi.sensor_motion")})n(o,{
fp("LUMI","lumi.motion.ac02")})n(be,{
fp("LUMI","lumi.motion.acn001")})n(bf,{
fp("LUMI","lumi.motion.agl02")})n(bd,{
fp("LUMI","lumi.sensor_motion.aq2")})n(f,{
fp("LUMI","lumi.magnet.ac01")})n(at,{
fp("LUMI","lumi.magnet.acn001")})n(ax,{
fp("LUMI","lumi.magnet.agl02")})n(aD,{
fp("LUMI","lumi.sensor_magnet"),fp("LUMI","lumi.sensor_magnet.aq2")})n(J,{
fp("LUMI","lumi.flood.acn001"),fp("LUMI","lumi.sensor_wleak.aq1")})n(D,{
fp("LUMI","lumi.flood.agl02")})i.attach_reporting_capabilities(U,{
{1,"sensors-temp-humidity-battery-voltage",{zr00010021auto=false,zr04020000auto=false,zr04050000auto=false}},{2,"sensors-temp-humidity-pressure-battery-voltage",{zr00010020auto=false,zr00010021auto=false,zr04020000auto=false,zr04030000auto=false,zr04050000auto=false}},{3,"rpt-lno"},{4,"rpt-lvz"},{10,"safety-aqara-contact-p1",{zr00010020auto=false,zr00010021auto=false,zr00060000auto=false,zr05000002auto=false}},{11,"rpt-tku"},{12,"rpt-tvc"},{13,"rpt-lhf"},{14,"rpt-lbp"},{15,"rpt-ljh"}})return{
id="zcl.sensors.aqara_lumi",registrations=U}
