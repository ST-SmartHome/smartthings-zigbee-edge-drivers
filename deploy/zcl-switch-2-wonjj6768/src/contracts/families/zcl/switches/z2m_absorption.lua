local g=require"protocol.zcl"
local k=require"capabilities.events.all"
local d=require"contracts.helpers.family"
local M=require"contracts.helpers.zcl"
local O=require"st.zigbee.device_management"
local n=require"st.zigbee.data_types"
local ax=require"st.zigbee.cluster_base"
local K,b=d.definition_registry()
local function c(aq)
return function(ay,l)
for s=1,aq do
l:send(O.build_bind_request(
l,g.CLUSTER_ON_OFF,ay.environment_info.hub_zigbee_eui,s))
end
end
end
local function v(aG,aR)
if aR==1 then
return{
profile=aG,zcl_clusters={
M.switch_cluster(),},}
end
return{
profile=aG,zcl_clusters=g.multi_switch(aR),}
end
local function h(aO,...)
return M.append_clusters(aO,...)
end
local function A(e,aX)
e.metering_kind=nil
e.scale=aX
return e
end
local function a(aY,aI,aw,ap,aE,aM,m)
m=m or{}return g.cluster_attribute(aI,aw,{
name=aY,endpoint=m.endpoint,component=m.component,emit=ap,
from_device=function(j)return aE[type(j)=="table"and j.value or j]end,
to_device=function(j)return aM[j]end,
data_type=m.data_type or n.Enum8,write_type=m.write_type or m.data_type or n.Enum8,mfg_code=m.mfg_code,prefer_plain_attribute_write=m.prefer_plain_attribute_write==true,read_on_configure=m.read_on_configure~=false,})
end
local function ai(l,as,aJ,aT)
return l:get_latest_state("main",as,aJ)or aT
end
local av={
[1]={enabled_capability="concertmirror08464.nfzb03InchingControlOne",enabled_attribute="inchingControlOne",time_capability="concertmirror08464.nfzb03InchingTimeOne",time_attribute="inchingTimeOne"},[2]={enabled_capability="concertmirror08464.nfzb03InchingControlTwo",enabled_attribute="inchingControlTwo",time_capability="concertmirror08464.nfzb03InchingTimeTwo",time_attribute="inchingTimeTwo"},[3]={enabled_capability="concertmirror08464.nfzb03InchingControlThree",enabled_attribute="inchingControlThree",time_capability="concertmirror08464.nfzb03InchingTimeThree",time_attribute="inchingTimeThree"},}local R={
[1]={enabled_capability="concertmirror08464.nfzbTwoInchingEnabledOne",enabled_attribute="nfzbTwoInchingEnabledOne",time_capability="concertmirror08464.nfzbTwoInchingTimeOne",time_attribute="nfzbTwoInchingTimeOne"},[2]={enabled_capability="concertmirror08464.nfzbTwoInchingEnabledTwo",enabled_attribute="nfzbTwoInchingEnabledTwo",time_capability="concertmirror08464.nfzbTwoInchingTimeTwo",time_attribute="nfzbTwoInchingTimeTwo"},}local t="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function af(q)
local z={}for i=1,#q,3 do
local u=q[i]local o=q[i+1]local B=q[i+2]local al=math.floor(u/4)local aj=((u%4)*16)+math.floor((o or 0)/16)local am=(((o or 0)%16)*4)+math.floor((B or 0)/64)local ah=(B or 0)%64
z[#z+1]=t:sub(al+1,al+1)z[#z+1]=t:sub(aj+1,aj+1)z[#z+1]=o and t:sub(am+1,am+1)or"="
z[#z+1]=B and t:sub(ah+1,ah+1)or"="
end
return table.concat(z)
end
local function ac(P,U,Y)
local x={}for _,V in ipairs({P,U,Y})do
if V<128 then
x[#x+1]=V
else
x[#x+1]=192+math.floor(V/64)x[#x+1]=128+(V%64)
end
end
return af(x)
end
local function E(aK)
local i=t:find(aK,1,true)return i and(i-1)or nil
end
local function ae(ak)
if type(ak)~="string"or #ak~=4 then return nil end
local u=E(ak:sub(1,1))local o=E(ak:sub(2,2))local ad=ak:sub(3,3)local X=ak:sub(4,4)local B=ad=="="and 0 or E(ad)local aL=X=="="and 0 or E(X)
if u==nil or o==nil or B==nil or aL==nil then return nil end
local q={
(u*4)+math.floor(o/16),}if ad~="="then
q[#q+1]=((o%16)*16)+math.floor(B/4)
end
if X~="="then
q[#q+1]=((B%4)*64)+aL
end
return q
end
local function W(q)
local f={}local i=1
while i<=#q do
local u=q[i]if u<128 then
f[#f+1]=u
i=i+1
elseif u>=194 and u<=223 then
local o=q[i+1]if o~=nil and o>=128 and o<=191 then
f[#f+1]=((u-192)*64)+(o-128)i=i+2
else
f[#f+1]=65533
i=i+1
end
elseif u>=224 and u<=239 then
local o=q[i+1]local B=q[i+2]local aC=o~=nil and o>=128 and o<=191 and
not(u==224 and o<160)and not(u==237 and o>159)if aC and B~=nil and B>=128 and B<=191 then
f[#f+1]=((u-224)*4096)+
((o-128)*64)+(B-128)i=i+3
else
f[#f+1]=65533
i=i+1
end
else
f[#f+1]=65533
i=i+1
end
end
return f
end
local function Z(j)
if type(j)~="string"or(#j%4)~=0 then
return nil
end
local aa={}for i=1,#j,4 do
local q=ae(j:sub(i,i+3))
if q==nil then return nil end
local f=W(q)local P=f[1]
if P==nil then return nil end
local p=1
local S=P
while S>=2 do
p=p+1
S=math.floor(S/2)
end
aa[p]={
enabled=P%2==1 and"enabled"or"disabled",time=f[3]==nil and(math.huge-math.huge)or
((f[2]or 0)*256)+f[3],}
end
return aa
end
local function T(j,ba,aN,e)
local aa=Z(j)local p=aa and aa[e.inching_channel]or nil
if p==nil then return nil end
if e.inching_kind=="enabled"and e.inching_enabled_values~=nil then
return p.enabled=="enabled"and e.inching_enabled_values.enabled or
e.inching_enabled_values.disabled
end
return p[e.inching_kind]
end
local function ag(l,e,j)
local p=e.inching_channel
local ab=e.inching_contract or av[p]local ao=e.inching_enabled_values and e.inching_enabled_values.disabled or"disabled"
local aF=ai(l,ab.enabled_capability,ab.enabled_attribute,ao)local Q=tonumber(ai(l,ab.time_capability,ab.time_attribute,1))or 1
if e.inching_kind=="enabled"then aF=j end
if e.inching_kind=="time"then Q=tonumber(j)or Q end
Q=math.max(1,math.min(65535,math.floor(Q+0.5)))local at=e.inching_enabled_values and e.inching_enabled_values.enabled or"enabled"
local P=aF==at and 1 or 0
if p>1 then P=P+(2 ^(p-1))end
local U=math.floor(Q/256)local Y=Q%256
return g.send_raw_cluster_command(
l,57344,251,ac(P,U,Y),1)
end
local function G(p,aU,ap,m)
m=m or{}local aW={
enabled=(m.name_prefix or"nfzb03").."_inching_enabled_"..({"one","two","three"})[p],time=(m.name_prefix or"nfzb03").."_inching_time_"..({"one","two","three"})[p],}local e=g.cluster_attribute(57344,53251,{
name=aW[aU],emit=ap,from_device=T,data_type=n.CharString,read_on_configure=false,sender=ag,})e.inching_channel=p
e.inching_kind=aU
e.inching_contract=m.contracts and m.contracts[p]or nil
e.inching_enabled_values=m.enabled_values
return e
end
local C=v("switches-switch-2-ay301z-two",2)h(C.zcl_clusters,g.tuya_magic_packet(),g.switch_type({
name="ay301z_two_switch_type",endpoint=1,component="main",emit=k.ay301zTwoSwitchType(),}),g.countdown_timer({
name="ay301z_two_countdown_one",endpoint=1,component="main",emit=k.ay301zTwoCountdownOne("s"),}),g.countdown_timer({
name="ay301z_two_countdown_two",endpoint=2,component="switch2",emit=k.ay301zTwoCountdownTwo("s"),}))C.configure=c(2)local w=v("switches-switch-1-mli-tint",1)h(w.zcl_clusters,g.cluster_attribute(g.CLUSTER_ON_OFF,16387,{
name="mli_tint_power_on_behavior",emit=k.mliTintPowerOnBehavior(),
from_device=function(j)
return({[0]="off",[1]="on",[2]="toggle",[255]="previous"})[j]
end,
to_device=function(j)
return({off=0,on=1,toggle=2,previous=255})[j]
end,
data_type=n.Enum8,write_type=n.Enum8,read_on_configure=true,}))w.configure=c(1)local F=v("switches-switch-3-ssw03g",3)h(F.zcl_clusters,g.tuya_magic_packet(),a("ssw03g_power_on_behavior",g.CLUSTER_ON_OFF,32770,k.sswThreePowerOnBehavior(),{[0]="off",[1]="on",[2]="previous"},{off=0,on=1,previous=2}),a("ssw03g_backlight_mode",g.CLUSTER_ON_OFF,32769,k.sswThreeBacklightMode(),{[0]="low",[1]="medium",[2]="high"},{low=0,medium=1,high=2}))F.configure=c(3)local au=v("switches-switch-2-nfzb2",2)local ar={
[1]={
countdown=k.nfzbTwoCountdownOne(),enabled=k.nfzbTwoInchingEnabledOne(),time=k.nfzbTwoInchingTimeOne(),},[2]={
countdown=k.nfzbTwoCountdownTwo(),enabled=k.nfzbTwoInchingEnabledTwo(),time=k.nfzbTwoInchingTimeTwo(),},}h(au.zcl_clusters,g.tuya_magic_packet(),a("nfzb2_power_outage_memory",g.CLUSTER_ON_OFF,32770,k.nfzbTwoPowerOutageMemory(),{[0]="off",[1]="on",[2]="restore"},{off=0,on=1,restore=2}),a("nfzb2_indicator_mode",g.CLUSTER_ON_OFF,32769,k.nfzbTwoIndicatorMode(),{[0]="off",[1]="off/on",[2]="on/off",[3]="on"},{off=0,["off/on"]=1,["on/off"]=2,on=3}),a("nfzb2_backlight_mode",g.CLUSTER_ON_OFF,20480,k.nfzbTwoBacklightMode(),{[0]="OFF",[1]="ON"},{OFF=0,ON=1},{data_type=n.Enum8,write_type=n.Enum8}))for s=1,2 do
local aZ=({"One","Two"})[s]local suffix=aZ:lower()local an=ar[s]h(au.zcl_clusters,g.countdown_timer({
name="nfzb2_countdown_"..suffix,endpoint=s,component=s==1 and"main"or"switch2",emit=an.countdown,}),G(s,"enabled",an.enabled,{
name_prefix="nfzb2",contracts=R,enabled_values={enabled="ENABLE",disabled="DISABLE"},}),G(s,"time",an.time,{
name_prefix="nfzb2",contracts=R,enabled_values={enabled="ENABLE",disabled="DISABLE"},}))
end
au.configure=c(2)local J=g.switch({
endpoint=1,minimum_interval=0,maximum_interval=65535,reportable_change=1,})local I=g.switch({
endpoint=1,minimum_interval=0,maximum_interval=65535,reportable_change=1,})
I.sender=function(l,_,j,D)
local s=D.endpoint or 1
local aV=g.send_named_command(
l,{J},"switch",j,{component_id=D.component_id,endpoint=s})if aV then
g.read_attribute(l,g.CLUSTER_ON_OFF,32768,s)
end
return aV
end
local aD={
profile="switches-candeo-ssfs",zcl_clusters={
I,A(g.power({
endpoint=1,minimum_interval=5,maximum_interval=300,reportable_change=10,}),1),A(g.voltage({
endpoint=1,minimum_interval=5,maximum_interval=600,reportable_change=5,}),1),A(g.current({
endpoint=1,minimum_interval=5,maximum_interval=900,reportable_change=10,}),1000),A(g.energy({
endpoint=1,minimum_interval=5,maximum_interval=1800,reportable_change=50,}),100),g.power_on_behavior({
name="candeo_ssfs_power_on_behavior",endpoint=1,emit=k.candeoSsfsPowerBehavior(),read_on_configure=true,}),g.child_lock({
name="candeo_ssfs_child_lock",endpoint=1,emit=k.candeoSsfsChildLock(),
from_device=function(j)
return(j==true or j==1)and"LOCK"or"UNLOCK"
end,
to_device=function(j)
return j=="LOCK"
end,
read_on_configure=true,}),},}local N=v("switches-moes-zsus1-ln",1)h(N.zcl_clusters,g.tuya_magic_packet(),a("moes_zsus1_power_on_behavior",57345,53264,k.moesZsus1PowerBehavior(),{[0]="off",[1]="on",[2]="previous"},{off=0,on=1,previous=2}),a("moes_zsus1_switch_type",57345,53296,k.moesZsus1SwitchType(),{[0]="toggle",[1]="state",[2]="momentary"},{toggle=0,state=1,momentary=2}),a("moes_zsus1_backlight_mode",g.CLUSTER_ON_OFF,20480,k.moesZsus1BacklightMode(),{[0]="off",[1]="on"},{off=0,on=1},{
data_type=n.Enum8,write_type=n.Enum8,prefer_plain_attribute_write=true,}))N.configure=c(1)b(F,d.create_fingerprints("TS0013",{
"_TZ3000_khtlvdfc",}))b(au,d.create_fingerprints("TS0002",{
"_TZ3210_5ksufhqi",}))b(C,{
d.create_fingerprint("AOYAN","AY301Z-2CH"),})b(w,{
d.create_fingerprint("MLI","tint Smart Switch"),d.create_fingerprint("MLI\0","switch01\0"),})b(aD,{
d.create_fingerprint("Candeo","C-ZB-SSFS"),})b(N,{
d.create_fingerprint("_TZ3000_bzzgvet0","TS0001"),})local y=v("switches-zemismart-kes606",1)y.zcl_clusters[1].maximum_interval=65000
h(y.zcl_clusters,g.tuya_magic_packet({read_on_configure=false}),a("kes606_power_on_behavior",57345,53264,k.kes606PowerBehavior(),{[0]="off",[1]="on",[2]="previous"},{off=0,on=1,previous=2},{read_on_configure=false}),a("kes606_indicator_mode",g.CLUSTER_ON_OFF,32769,k.kes606IndicatorMode(),{[0]="off",[1]="off/on",[2]="on/off",[3]="on"},{off=0,["off/on"]=1,["on/off"]=2,on=3},{read_on_configure=false}))y.configure=c(1)b(y,{
d.create_fingerprint("_TZ3000_w5s3mbyn","TS0001"),})local az={
profile="switches-ekaza-ts0003",zcl_clusters={
g.switch({endpoint=1,component="main",configure_reporting=false,read_on_configure=false}),g.switch({endpoint=2,component="switch2",configure_reporting=false,read_on_configure=false}),g.switch({endpoint=3,component="switch3",configure_reporting=false,read_on_configure=false}),g.tuya_magic_packet({read_on_configure=false}),a("eka_ts0003_switch_type",57345,53296,k.ekaTs0003SwitchType(),{[0]="toggle",[1]="state",[2]="momentary"},{toggle=0,state=1,momentary=2},{mfg_code=4417,read_on_configure=false}),a("eka_ts0003_indicator_mode",6,32769,k.ekaTs0003IndicatorMode(),{[0]="off",[1]="off/on",[2]="on/off",[3]="on"},{off=0,["off/on"]=1,["on/off"]=2,on=3},{read_on_configure=false}),g.countdown_timer({
name="eka_ts0003_countdown_one",endpoint=1,component="main",emit=k.ekaTs0003CountdownOne(),read_on_configure=false,}),g.countdown_timer({
name="eka_ts0003_countdown_two",endpoint=2,component="switch2",emit=k.ekaTs0003CountdownTwo(),read_on_configure=false,}),g.countdown_timer({
name="eka_ts0003_countdown_three",endpoint=3,component="switch3",emit=k.ekaTs0003CountdownThree(),read_on_configure=false,}),},configure=c(3),}b(az,{
d.create_fingerprint("_TZ3000_f6pgzqob","TS0003"),})local r=a(
"nous_b2z_switch_type",57345,53296,k.nousB2zSwitchType(),{[0]="toggle",[1]="state",[2]="momentary"},{toggle=0,state=1,momentary=2},{read_on_configure=false})
r.sender=function(l,e,j,D)
local aH=ax.write_attribute(
l,n.ClusterId(57345),n.AttributeId(53296),n.Enum8(e.to_device(j)))aH.body.zcl_header.frame_ctrl:set_disable_default_response()l:send(aH:to_endpoint(D.endpoint or 1))return true
end
local aP={
profile="switches-nous-b2z",zcl_clusters={
g.switch({endpoint=1,configure_reporting=false,read_on_configure=false}),g.electrical_measurement_power({
endpoint=1,emit=k.power(),read_only=true,minimum_interval=5,maximum_interval=3600,reportable_change=10,
from_device=function(j,l,D)
return g.scale_mapping_value(l,nil,j,{metering_kind="power",scale=1},D)
end,
}),g.electrical_measurement_voltage({
endpoint=1,emit=k.voltage(),read_only=true,minimum_interval=5,maximum_interval=3600,reportable_change=5,
from_device=function(j,l,D)
return g.scale_mapping_value(l,nil,j,{metering_kind="voltage",scale=1},D)
end,
}),g.electrical_measurement_current({
endpoint=1,emit=k.current(),scale=1000,read_only=true,minimum_interval=5,maximum_interval=3600,reportable_change=50,}),g.simple_metering({
endpoint=1,emit=k.energy(),scale=100,read_only=true,minimum_interval=5,maximum_interval=3600,reportable_change=257,}),g.tuya_magic_packet({read_on_configure=false}),r,a("nous_b2z_power_outage_memory",6,32770,k.nousB2zPowerOutageMemory(),{[0]="off",[1]="on",[2]="restore"},{off=0,on=1,restore=2},{read_on_configure=false}),},
configure=function(ay,l)
for _,aS in ipairs({6,2820,1794})do
l:send(O.build_bind_request(l,aS,ay.environment_info.hub_zigbee_eui,1))
end
end,
parent_refresh=function(l)
for _,aA in ipairs({{6,0},{6,32770},{57345,53296}})do
g.read_attribute(l,aA[1],aA[2],1)
end
end,
}b(aP,{
d.create_fingerprint("_TZ3000_ahvrgyac","TS0001"),})local H=a(
"tuya_p26_switch_type",57345,53296,k.tuyaP26SwitchType(),{[0]="toggle",[1]="state",[2]="momentary"},{toggle=0,state=1,momentary=2},{read_on_configure=false})H.sender=r.sender
local aQ={
profile="switches-tuya-p26",zcl_clusters={
g.switch({endpoint=1,configure_reporting=false,read_on_configure=false}),g.tuya_magic_packet({read_on_configure=false}),a("tuya_p26_power_behavior",57345,53264,k.tuyaP26PowerBehavior(),{[0]="off",[1]="on",[2]="previous"},{off=0,on=1,previous=2},{read_on_configure=false}),H,a("tuya_p26_backlight_mode",6,20480,k.tuyaP26BacklightMode(),{[0]="OFF",[1]="ON"},{OFF=0,ON=1},{read_on_configure=false,prefer_plain_attribute_write=true}),a("tuya_p26_indicator_mode",6,32769,k.tuyaP26IndicatorMode(),{[0]="off",[1]="off/on",[2]="on/off",[3]="on"},{off=0,["off/on"]=1,["on/off"]=2,on=3},{read_on_configure=false}),},configure=c(1),
parent_refresh=function(l)
for _,aA in ipairs({{6,0},{57345,53264},{57345,53296},{6,20480},{6,32769}})do
g.read_attribute(l,aA[1],aA[2],1)
end
end,
}b(aQ,{
d.create_fingerprint("_TZ3000_p26flek3","TS0001"),})local L=a(
"qs_s10_switch_type",57345,53296,k.qsS10SwitchType(),{[0]="toggle",[1]="state",[2]="momentary"},{toggle=0,state=1,momentary=2},{read_on_configure=false})L.sender=r.sender
local aB={
profile="switches-qs-s10-three",zcl_clusters={
g.switch({endpoint=1,component="main",configure_reporting=false,read_on_configure=false}),g.switch({endpoint=2,component="switch2",configure_reporting=false,read_on_configure=false}),g.switch({endpoint=3,component="switch3",configure_reporting=false,read_on_configure=false}),g.tuya_magic_packet({read_on_configure=false}),L,a("qs_s10_power_memory",6,32770,k.qsS10PowerMemory(),{[0]="off",[1]="on",[2]="restore"},{off=0,on=1,restore=2},{read_on_configure=false}),},configure=c(3),}b(aB,{
d.create_fingerprint("_TZ3000_ly9apzky","TS0003"),})g.attach_reporting_capabilities(K,{
{1,"rpt-tgv",{["zr000600001"]="Switch",["zr000600002"]="SwitchTwo",["zr000600003"]="SwitchThree"}},{2,"rpt-tjh",{["zr000600001"]="Switch",["zr000600002"]="SwitchTwo"}},{3,"rpt-aft",{["zr000600001"]="Switch",["zr000600002"]="SwitchTwo"}},{4,"rpt-tqs"},{5,"rpt-cbp"},{6,"rpt-tgk"},{7,"rpt-tesc"},{9,"rpt-tjs"},})return{
id="zcl.switches.z2m_absorption",registrations=K,}
