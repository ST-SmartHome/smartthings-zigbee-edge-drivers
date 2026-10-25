local h=require"protocol.zcl"
local t=require"capabilities.events.all"
local ak=require"contracts.helpers.family"
local m=ak.create_fingerprints
local p=ak.create_fingerprint
local i=require"contracts.helpers.zcl"
local G=require"st.zigbee.device_management"
local y=require"st.zigbee.data_types"
local bt=require"st.zigbee.cluster_base"
local am,b=ak.definition_registry()
local function c(bo)
return function(aa,r)
for endpoint=1,bo do
r:send(G.build_bind_request(
r,h.CLUSTER_ON_OFF,aa.environment_info.hub_zigbee_eui,endpoint))
end
end
end
local function g(q,Z,e)
if Z==1 then
return{
profile=q,zcl_clusters={
i.switch_cluster()}}
end
return{
profile=q,zcl_clusters=h.multi_switch(Z,e)}
end
local a=i.append_clusters
local function av(q,Z,e)
local f=g(q,Z,e).zcl_clusters
a(f,h.tuya_magic_packet(),h.tuya_power_outage_memory(),h.child_lock())return{
profile=q,zcl_clusters=f,configure=c(Z)}
end
local function L(q,Z,e)
local f=g(q,Z,e).zcl_clusters
a(f,h.tuya_magic_packet(),h.switch_type(),h.countdown_timer())return{
profile=q,zcl_clusters=f,configure=c(Z)}
end
local function N()
return h.cluster_attribute(57345,53264,{
name="power_on_behavior",emit=t.power_on_behavior(),
from_device=function(v)
return({[0]="off",[1]="on",[2]="previous"})[v]
end,
to_device=function(v)
return({off=0,on=1,previous=2})[v]
end,
data_type=y.Enum8,write_type=y.Enum8,read_on_configure=true})
end
local function j(bG,Y,bs,bn,bu,bA,e)
e=e or{}return h.cluster_attribute(Y,bs,{
name=bG,endpoint=e.endpoint,component=e.component,emit=bn,
from_device=function(v)
if type(v)=="table"then v=v.value end
return bu[v]
end,
to_device=function(v)return bA[v]end,
data_type=e.data_type or y.Enum8,write_type=e.write_type or e.data_type or y.Enum8,mfg_code=e.mfg_code,read_on_configure=e.read_on_configure~=false})
end
local function aY(r,bp,bx,bD)
return r:get_latest_state("main",bp,bx)or bD
end
local br={
[1]={enabled_capability="concertmirror08464.nfzb03InchingControlOne",enabled_attribute="inchingControlOne",time_capability="concertmirror08464.nfzb03InchingTimeOne",time_attribute="inchingTimeOne"},[2]={enabled_capability="concertmirror08464.nfzb03InchingControlTwo",enabled_attribute="inchingControlTwo",time_capability="concertmirror08464.nfzb03InchingTimeTwo",time_attribute="inchingTimeTwo"},[3]={enabled_capability="concertmirror08464.nfzb03InchingControlThree",enabled_attribute="inchingControlThree",time_capability="concertmirror08464.nfzb03InchingTimeThree",time_attribute="inchingTimeThree"}}local bi={
[1]={
countdown=t.nfzb03CountdownOne(),control=t.nfzb03InchingControlOne(),time=t.nfzb03InchingTimeOne()},[2]={
countdown=t.nfzb03CountdownTwo(),control=t.nfzb03InchingControlTwo(),time=t.nfzb03InchingTimeTwo()},[3]={
countdown=t.nfzb03CountdownThree(),control=t.nfzb03InchingControlThree(),time=t.nfzb03InchingTimeThree()}}local C="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function aS(F)
local O={}for ac=1,#F,3 do
local bj=F[ac]local ay=F[ac+1]local aM=F[ac+2]local be=math.floor(bj/4)local aZ=((bj%4)*16)+math.floor((ay or 0)/16)local bg=(((ay or 0)%16)*4)+math.floor((aM or 0)/64)local aX=(aM or 0)%64
O[#O+1]=C:sub(be+1,be+1)O[#O+1]=C:sub(aZ+1,aZ+1)O[#O+1]=ay and C:sub(bg+1,bg+1)or"="
O[#O+1]=aM and C:sub(aX+1,aX+1)or"="
end
return table.concat(O)
end
local function aK(aC,az,aE)
return aS{aC,az,aE}
end
local function X(by)
local ac=C:find(by,1,true)return ac and(ac-1)or nil
end
local function aR(ba)
if type(ba)~="string"or #ba~=4 then return nil end
local bj=X(ba:sub(1,1))local ay=X(ba:sub(2,2))local aN=ba:sub(3,3)local aD=ba:sub(4,4)local aM=aN=="="and 0 or X(aN)local bz=aD=="="and 0 or X(aD)
if bj==nil or ay==nil or aM==nil or bz==nil then return nil end
local F={
(bj*4)+math.floor(ay/16)}if aN~="="then
F[#F+1]=((ay%16)*16)+math.floor(aM/4)
end
if aD~="="then
F[#F+1]=((aM%4)*64)+bz
end
return F
end
local function aG(v)
if type(v)~="string"or(#v%4)~=0 then
return nil
end
local aH={}for ac=1,#v,4 do
local F=aR(v:sub(ac,ac+3))
if F==nil or #F~=3 then return nil end
local aC=F[1]local u=1
local aw=aC
while aw>=2 do
u=u+1
aw=math.floor(aw/2)
end
aH[u]={
enabled=aC%2==1 and"enabled"or"disabled",time=(F[2]*256)+F[3]}
end
return aH
end
local function ax(v,bI,bB,l)
local aH=aG(v)local u=aH and aH[l.inching_channel]or nil
if u==nil then return nil end
if l.inching_kind=="enabled"and l.inching_enabled_values~=nil then
return u.enabled=="enabled"and l.inching_enabled_values.enabled or
l.inching_enabled_values.disabled
end
return u[l.inching_kind]
end
local function aU(r,l,v)
local u=l.inching_channel
local aJ=l.inching_contract or br[u]local bm=l.inching_enabled_values and l.inching_enabled_values.disabled or"disabled"
local bv=aY(r,aJ.enabled_capability,aJ.enabled_attribute,bm)local au=tonumber(aY(r,aJ.time_capability,aJ.time_attribute,1))or 1
if l.inching_kind=="enabled"then bv=v end
if l.inching_kind=="time"then au=tonumber(v)or au end
au=math.max(1,math.min(65535,math.floor(au+0.5)))local bq=l.inching_enabled_values and l.inching_enabled_values.enabled or"enabled"
local aC=bv==bq and 1 or 0
if u>1 then aC=aC+(2 ^(u-1))end
local az=math.floor(au/256)local aE=au%256
return h.send_raw_cluster_command(
r,57344,251,aK(aC,az,aE),1)
end
local function ab(u,bE,bn,e)
e=e or{}local bF={
enabled=(e.name_prefix or"nfzb03").."_inching_enabled_"..({"one","two","three"})[u],time=(e.name_prefix or"nfzb03").."_inching_time_"..({"one","two","three"})[u]}local l=h.cluster_attribute(57344,53251,{
name=bF[bE],emit=bn,from_device=ax,data_type=y.CharString,read_on_configure=false,sender=aU})l.inching_channel=u
l.inching_kind=bE
l.inching_contract=e.contracts and e.contracts[u]or nil
l.inching_enabled_values=e.enabled_values
return l
end
local R=t.lellkiWp33PowerOnBehavior()
local function af()
local l=N()l.name="lellki_wp33_power_on_behavior"
l.emit=R
return l
end
local function d(q,e)
e=e or{}local f=g("switches-switch-1",1).zcl_clusters
a(f,h.tuya_magic_packet())
if e.power_outage_memory then a(f,h.tuya_power_outage_memory())end
if e.power_on_behavior_2 then a(f,N())end
if e.switch_type then a(f,h.switch_type())end
if e.gen_on_off_switch_type then a(f,h.gen_on_off_switch_type())end
if e.countdown then a(f,h.countdown_timer())end
if e.indicator_mode then a(f,h.indicator_mode())end
return{
profile=q,zcl_clusters=f,configure=c(1)}
end
local function M(q,aT)
local f=i.metering_clusters{
include_switch=true,include_current=true,energy_scale=100}a(f,h.power_outage_memory(),h.tuya_magic_packet())
if aT~=false then a(f,h.switch_type())end
return{
profile=q,zcl_clusters=f,
configure=function(aa,r)
for _,Y in ipairs{h.CLUSTER_ON_OFF,2820,1794}do
r:send(G.build_bind_request(
r,Y,aa.environment_info.hub_zigbee_eui,1))
end
end
}
end
local function al(q,Z)
local f=g(q,Z).zcl_clusters
a(f,h.tuya_magic_packet(),h.power_outage_memory(),h.gen_on_off_switch_type())return{
profile=q,zcl_clusters=f,configure=c(Z)}
end
local function aB(q)
local f={
i.switch_cluster(1),i.switch_cluster(2,"switch2")}a(f,h.power{endpoint=1,component="main",minimum_interval=5,maximum_interval=3600,reportable_change=10,poll_interval=300},h.voltage{endpoint=1,component="main",minimum_interval=5,maximum_interval=3600,reportable_change=5,poll_interval=300},h.current{endpoint=1,component="main",scale=1000,ignore_reported_scaler=true,minimum_interval=5,maximum_interval=3600,reportable_change=50,poll_interval=300},h.energy{endpoint=1,component="main",scale=100,ignore_reported_scaler=true,minimum_interval=5,maximum_interval=3600,reportable_change=257,poll_interval=900},h.tuya_magic_packet(),h.tuya_power_outage_memory{endpoint=1,name="nous_b3z_power_behavior",emit=t.nousB3zPowerBehavior()},h.switch_type{endpoint=1,name="nous_b3z_switch_type",emit=t.nousB3zSwitchType(),
sender=function(r,l,v)
local bw=bt.write_attribute(r,y.ClusterId(57345),y.AttributeId(53296),y.Enum8(l.converter.to(v)))bw.body.zcl_header.frame_ctrl:set_disable_default_response()r:send(bw:to_endpoint(1));return true
end},
h.countdown_timer{endpoint=1,component="main",name="nous_b3z_countdown1",emit=t.nousB3zCountdown1()},h.countdown_timer{endpoint=2,component="switch2",name="nous_b3z_countdown2",emit=t.nousB3zCountdown2()})return{
profile=q,zcl_clusters=f,component_to_endpoint_map={main=1,switch2=2},
configure=function(aa,r)
for _,bC in ipairs{6,2820,1794}do
h.bind_cluster(r,bC,aa.environment_info.hub_zigbee_eui,1)
end
h.bind_cluster(r,6,aa.environment_info.hub_zigbee_eui,2)
end
}
end
local as={
profile="plugs-switch-2-power-energy-voltage",zcl_clusters={
i.switch_cluster(1),i.switch_cluster(2,"switch2")}}a(as.zcl_clusters,i.metering_clusters{
endpoint=1,include_switch=false,include_current=false})
local function U(aa,r)
for _,Y in ipairs{h.CLUSTER_ON_OFF,2820,1794}do
r:send(G.build_bind_request(
r,Y,aa.environment_info.hub_zigbee_eui,1))
end
r:send(G.build_bind_request(
r,h.CLUSTER_ON_OFF,aa.environment_info.hub_zigbee_eui,2))
end
local function k(q,e)
e=e or{}local f={
i.switch_cluster(1),i.switch_cluster(2,"switch2")}a(f,i.metering_clusters{
endpoint=1,include_switch=false,include_current=true,energy_scale=100,energy_ignore_reported_scaler=e.energy_ignore_reported_scaler},h.tuya_magic_packet())
if e.outage_memory then a(f,h.tuya_power_outage_memory())end
if e.indicator_mode then a(f,h.indicator_mode())end
if e.child_lock then a(f,h.child_lock())end
if e.countdown then a(f,h.countdown_timer())end
return{
profile=q,zcl_clusters=f,configure=U}
end
local bd=k"plugs-dual-metered"local aA=k("plugs-dual-metered-outage",{
outage_memory=true})local bc=k("plugs-mercator-spp02gip",{
outage_memory=true,energy_ignore_reported_scaler=true})local bk={
profile="plugs-mercator-spp04g",component_to_endpoint_map={main=1,switch2=2},zcl_clusters={
h.switch{endpoint=1,component="main",maximum_interval=3600},h.switch{endpoint=2,component="switch2",maximum_interval=3600},h.power{endpoint=1,minimum_interval=5,maximum_interval=3600,reportable_change=1,poll_interval=300},h.voltage{endpoint=1,minimum_interval=5,maximum_interval=3600,reportable_change=5,poll_interval=300},h.current{endpoint=1,scale=1000,ignore_reported_scaler=true,minimum_interval=5,maximum_interval=3600,reportable_change=50,poll_interval=300},h.energy{endpoint=1,scale=100,ignore_reported_scaler=true,poll_interval=900},h.tuya_magic_packet(),h.tuya_power_outage_memory{endpoint=1,name="spp04_power_behavior",emit=t.spp04PowerBehavior()}},configure=U}local S=k("plugs-dual-metered-outage-indicator",{
outage_memory=true,indicator_mode=true})local J=k("plugs-dual-metered-outage-indicator-lock",{
outage_memory=true,indicator_mode=true,child_lock=true})local ad=k("plugs-dual-metered-full-options",{
outage_memory=true,indicator_mode=true,child_lock=true,countdown=true})local H=g("plugs-dual-outage",2)a(H.zcl_clusters,h.tuya_magic_packet(),h.tuya_power_outage_memory())H.configure=c(2)local aQ=g("switches-switch-1",1)local n=g("switches-switch-1",1)a(n.zcl_clusters,h.tuya_magic_packet())n.configure=c(1)local aj=M"switches-switch-1-power-options"local aq=M("switches-switch-1-power-outage",false)local A=g("switches-switch-2",2)A.configure=c(2)local o=g("switches-switch-2",2,{index_offset=1})a(o.zcl_clusters,h.tuya_magic_packet())o.configure=c(2)local aP=g("switches-ts0002-rux",2,{index_offset=1})a(aP.zcl_clusters,h.tuya_magic_packet(),j("ts0002_rux_power_outage_memory",h.CLUSTER_ON_OFF,32770,t.ts0002RuxPowerOutageMemory(),{[0]="off",[1]="on",[2]="restore"},{off=0,on=1,restore=2}),j("ts0002_rux_switch_type",57345,53296,t.ts0002RuxSwitchType(),{[0]="toggle",[1]="state",[2]="momentary"},{toggle=0,state=1,momentary=2}))aP.configure=c(2)local bb=aB"switches-nous-b3z"local ai=g("switches-switch-3",3,{index_offset=1})ai.configure=c(3)local z=g("switches-switch-3",3,{index_offset=1})a(z.zcl_clusters,h.tuya_magic_packet())z.configure=c(3)local bf=g("switches-switch-4",4,{index_offset=1})bf.configure=c(4)local s=g("switches-switch-4",4,{index_offset=1})a(s.zcl_clusters,h.tuya_magic_packet())s.configure=c(4)local K={
profile="switches-switch-4",zcl_clusters=h.multi_switch(4,{configure_reporting=false,index_offset=1}),configure=c(4)}a(K.zcl_clusters,h.tuya_magic_packet())local I={
profile="switches-switch-4",zcl_clusters=h.multi_switch(4,{configure_reporting=false,index_offset=1})}a(I.zcl_clusters,h.tuya_magic_packet())local at=av("switches-switch-5-tuya-options",5,{index_offset=1})local an=g("switches-lellki-wp33-5",5,{index_offset=1})a(an.zcl_clusters,h.tuya_magic_packet(),af())local aL=g("switches-switch-6-basic",6,{index_offset=1})a(aL.zcl_clusters,h.tuya_magic_packet())aL.configure=c(6)local D=L("switches-switch-1-countdown-switch-type",1)local aW=L("switches-switch-2-countdown-switch-type",2)local aO=L("switches-switch-3-countdown-switch-type",3,{index_offset=1})local ao=al("switches-switch-1-poweron-switch-type",1)local ap=al("switches-switch-2-poweron-switch-type",2)local w=g("switches-switch-1",1)w.configure=c(1)local aI=d("switches-switch-1-countdown",{
countdown=true})local Q=d("switches-switch-1-switch-type",{
switch_type=true})local ae=d("switches-switch-1-outage-switch-type",{
power_outage_memory=true,switch_type=true})local T=d("switches-switch-1-outage-switch-type",{
power_outage_memory=true,gen_on_off_switch_type=true})local ar=d("switches-switch-1-module-options",{
power_outage_memory=true,switch_type=true,countdown=true,indicator_mode=true})local E=d(
"switches-switch-1-countdown-switch-type-indicator",{switch_type=true,countdown=true,indicator_mode=true})local W=d(
"switches-switch-1-countdown-indicator",{countdown=true,indicator_mode=true})local ah=d(
"switches-switch-1-poweron-indicator",{power_on_behavior_2=true,indicator_mode=true})local aV=d(
"switches-switch-1-poweron",{power_on_behavior_2=true})local ag=d(
"switches-switch-1-poweron-countdown",{power_on_behavior_2=true,countdown=true})local B=d(
"switches-switch-1-poweron-countdown-switch-type-indicator",{power_on_behavior_2=true,switch_type=true,countdown=true,indicator_mode=true})local aF=g("switches-switch-1-ts0001-bbeb",1)a(aF.zcl_clusters,h.tuya_magic_packet(),j("ts0001_bbeb_power_on_behavior",57345,53264,t.ts0001BbebPowerOnBehavior(),{[0]="off",[1]="on",[2]="previous"},{off=0,on=1,previous=2}),j("ts0001_bbeb_backlight_mode",h.CLUSTER_ON_OFF,20480,t.ts0001BbebBacklightMode(),{[0]="off",[1]="on",[false]="off",[true]="on"},{off=false,on=true},{data_type=y.Boolean}),j("ts0001_bbeb_indicator_mode",h.CLUSTER_ON_OFF,32769,t.ts0001BbebIndicatorPattern(),{[0]="off",[1]="off/on",[2]="on/off",[3]="on"},{off=0,["off/on"]=1,["on/off"]=2,on=3}))aF.configure=c(1)local P=g("switches-switch-3-ts0003-module2",3,{index_offset=1})local V={
t.ts0003Module2CountdownOne(),t.ts0003Module2CountdownTwo(),t.ts0003Module2CountdownThree()}a(P.zcl_clusters,h.tuya_magic_packet(),j("ts0003_module2_switch_type",57345,53296,t.ts0003Module2SwitchType(),{[0]="toggle",[1]="state",[2]="momentary"},{toggle=0,state=1,momentary=2},{mfg_code=4417}),j("ts0003_module2_indicator_mode",h.CLUSTER_ON_OFF,32769,t.ts0003Module2IndicatorMode(),{[0]="off",[1]="off_on",[2]="on_off",[3]="on"},{off=0,off_on=1,on_off=2,on=3}))for endpoint=1,3 do
local word=({"One","Two","Three"})[endpoint]a(P.zcl_clusters,h.countdown_timer{
name="ts0003_module2_countdown_"..word:lower(),endpoint=endpoint,component=endpoint==1 and"main"or("switch"..endpoint),emit=V[endpoint]})
end
P.configure=c(3)local bl=g("switches-switch-3-nfzb03",3,{index_offset=1})a(bl.zcl_clusters,h.tuya_magic_packet(),j("nfzb03_power_outage_memory",h.CLUSTER_ON_OFF,32770,t.nfzb03PowerOutageMemory(),{[0]="off",[1]="on",[2]="restore"},{off=0,on=1,restore=2}),j("nfzb03_switch_type",57345,53296,t.nfzb03SwitchType(),{[0]="toggle",[1]="state",[2]="momentary"},{toggle=0,state=1,momentary=2},{mfg_code=4417}),j("nfzb03_indicator_mode",h.CLUSTER_ON_OFF,32769,t.nfzb03IndicatorMode(),{[0]="off",[1]="off_on",[2]="on_off",[3]="on"},{off=0,off_on=1,on_off=2,on=3}),j("nfzb03_backlight_mode",h.CLUSTER_ON_OFF,20480,t.nfzb03BacklightMode(),{[0]="off",[1]="on",[false]="off",[true]="on"},{off=false,on=true},{data_type=y.Boolean}))for endpoint=1,3 do
local word=({"One","Two","Three"})[endpoint]local bh=bi[endpoint]a(bl.zcl_clusters,h.countdown_timer{name="nfzb03_countdown_"..word:lower(),endpoint=endpoint,component=endpoint==1 and"main"or("switch"..endpoint),emit=bh.countdown},ab(endpoint,"enabled",bh.control,{
enabled_values={enabled="ENABLE",disabled="DISABLE"}}),ab(endpoint,"time",bh.time,{
enabled_values={enabled="ENABLE",disabled="DISABLE"}}))
end
bl.configure=c(3)b(aF,m("TS0001",{"_TZ3000_bbebkwjk"}))b(P,m("TS0003",{"_TZ3000_bu47m8pv"}))b(bl,m("TS0003",{
"_TZ3000_fawk5xjv","_TZ3000_bvij6kod","_TZ3000_aracgljk","_TZ3210_fawk5xjv"}))b(aj,m("TS0001",{
"_TZ3000_xkap8wtb","_TZ3000_qnejhcsu","_TZ3000_x3ewpzyr","_TZ3000_mkhkxx1p","_TZ3000_tgddllx4","_TZ3000_kqvb5akv","_TZ3000_q8r0bbvy","_TZ3000_g92baclx","_TZ3000_qlai3277","_TZ3000_qaabwu5c","_TZ3000_qorepo2x","_TZ3000_ikuxinvo","_TZ3000_hzlsaltw","_TZ3000_jsfzkftc","_TZ3000_0ghwhypc","_TZ3000_1adss9de","_TZ3000_x8mbwtsz","_TZ3000_iktiy8ue","_TZ3000_zojh9vz7","_TZ3000_gsat0axs","_TZ3000_olo5jhjk"}))b(bb,m("TS0002",{
"_TZ3000_aaifmpuq","_TZ3000_irrmjcgi","_TZ3000_huvxrx4i","_TZ3000_pxfjrzyj","_TZ3000_hopb2kjm"}))b(aj,m("TS000F",{
"_TZ3000_xkap8wtb"}))b(n,m("SM0001",{
"_TZ3000_jcqs2mrv"}))b(w,m("TS0001",{
"_TZ3000_bezfthwc"}))b(D,m("TS0001",{
"_TZ3000_hktqahrq","_TZ3000_q6a3tepg","_TZ3000_skueekg3","_TZ3000_npzfdcof","_TZ3000_5ng23zjs","_TZ3000_rmjr4ufz","_TZ3000_v7gnj3ad","_TZ3000_3a9beq8a","_TZ3000_ark8nv4y","_TZ3000_mx3vgyea","_TZ3000_fdxihpp7","_TZ3000_qsp2pwtf","_TZ3000_kycczpw8","_TZ3000_46t1rvdu","_TZ3000_bhcpnvud","_TZ3000_i9oy2rdq"}))b(n,m("TS0001",{
"_TZ3000_8n7lqbm0","_TZ3000_cb3aangp","_TZ3000_ctftgjwb","_TZ3000_g8n1n7lg","_TZ3000_udl7uyd2"}))b(aV,m("TS0001",{
"_TZ3000_bmqxalil","_TZ3000_w1tcofu8","_TZ3000_ma3mhpx2","_TZ3000_wijoqjk1"}))b(B,m("TS0001",{
"_TZ3000_5rpu3r0d"}))b(ar,m("TS0001",{
"_TZ3000_tqlv4ug4","_TZ3210_tqlv4ug4","_TZ3000_gjrubzje","_TZ3000_tygpxwqa","_TZ3000_4rbqgcuv","_TZ3000_veu2v775","_TZ3000_prits6g4","_TZ3210_9hbau615","_TZ3000_afgzktgb","_TZ3000_qamj2vnn","_TZ3000_n6fqajob"}))b(ae,m("TS0001",{
"_TZ3000_xfxpoxe0"}))b(W,m("TS0001",{
"_TZ3000_myaaknbq","_TZ3000_cpozgbrx","_TZ3000_drc9tuqb"}))b(ah,m("TS0001",{
"_TZ3000_gbshwgag","_TZ3000_blhvsaqf","_TZ3000_65ajyxua","_TZ3000_qq9ahj6z"}))b(E,m("TS0001",{
"_TZ3000_pgq7ormg"}))b(ag,m("TS0001",{
"_TZ3000_qvmiyxuk"}))b(aI,m("TS0001",{
"_TZ3210_fhx7lk3d"}))b(w,m("TS0001",{
"_TYZB01_4vgantdz","_TYZB01_reyozfcg","_TZ3000_wrhhi5h2"}))b(Q,m("TS0001",{
"_TZ3000_6axxqqi2","_TZ3000_gtdswg8k","_TZ3000_majwnphg","_TZ3000_qh6qjuan","_TZ3000_zw7yf6yk"}))b(n,m("TS0001",{
"_TZ3000_dov0a3p1","_TZ3000_t3s9qmmg","_TZ3000_ehgouyvu"}))b(n,m("TS0011",{
"_TZ3000_uaa34g7v","_TZ3000_l8fsgo6p","_TZ3000_abjodzas","_TZ3000_hhiodade"}))b(D,m("TS0011",{
"_TZ3000_hbxsdd6k"}))b(D,m("TS0011",{
"_TZ3000_qmi1cfuq","_TZ3000_txpirhfq","_TZ3000_ji4araar","_TZ3000_tw4ztbp4"}))b(w,m("TS011F",{
"_TZ3000_twqctvna"}))b(n,{
p("_TYZB01_iuepbmpv","TS0121"),p("_TZ3000_bkfe0bab","TS011F"),p("_TZ3000_zmy1waw6","TS011F")})b(aq,m("TS011F",{
"_TZ3000_z6fgd73r"}))b(D,m("TS000F",{
"_TZ3000_hktqahrq","_TZ3000_m9af2l6g","_TZ3000_mx3vgyea","_TZ3000_skueekg3","_TZ3000_dlhhrhs8","_TZ3000_fdxihpp7"}))b(n,m("TS000F",{
"_TZ3210_a2erlvb8"}))b(aQ,{
{manufacturer="_TZ3210_hjxqqofs"..string.char(0),model="TS000F"}})b(Q,m("TS000F",{
"_TZ3000_hdc8bbha"}))b(T,m("TS000F",{
"_TZ3218_hdc8bbha"}))b(ao,m("TS000F",{
"_TZ3218_n0jsuogs"}))b(bd,m("TS011F",{
"_TZ3000_bep7ccew"}))b(bc,m("TS011F",{
"_TZ3210_7jnk7l3k"}))b(aA,m("TS011F",{
"_TZ3210_raqjcxo5","_TZ3210_pfbzs1an"}))b(bk,{
p("_TZ3210_yvxjawlt","TS011F")})b(S,m("TS011F",{
"_TZ3000_dd8wwzcy"}))b(J,m("TS011F",{
"_TZ3000_jak16dll","_TZ3000_rqbjepe8","_TZ3000_uwkja6z1"}))b(ad,m("TS011F",{
"_TZ3210_bep7ccew","_TZ3210_qlmnxmac"}))b(H,m("TS011F",{
"_TZ3000_gazjngjl"}))b(as,{
p("LUMI","lumi.plug.acn005"),p("LUMI","lumi.plug.sacn03")})b(aQ,{
p("Aqara","lumi.switch.acn048"),p("LUMI","lumi.ctrl_ln1"),p("LUMI","lumi.ctrl_ln1.aq1"),p("LUMI","lumi.ctrl_neutral1"),p("LUMI","lumi.switch.acn029"),p("LUMI","lumi.switch.acn048"),p("LUMI","lumi.switch.acn056"),p("LUMI","lumi.switch.acn061"),p("LUMI","lumi.switch.b1laus01"),p("LUMI","lumi.switch.b1lacn01"),p("LUMI","lumi.switch.b1nacn01"),p("LUMI","lumi.switch.b1nacn02"),p("LUMI","lumi.switch.b1naus01"),p("LUMI","lumi.switch.b1lc04"),p("LUMI","lumi.switch.b1nc01"),p("LUMI","lumi.switch.l0acn1"),p("LUMI","lumi.switch.l0agl1"),p("LUMI","lumi.switch.l1acn1"),p("LUMI","lumi.switch.l1aeu1"),p("LUMI","lumi.switch.n0acn2"),p("LUMI","lumi.switch.n0agl1"),p("LUMI","lumi.switch.n1acn1"),p("LUMI","lumi.switch.n1aeu1")})b(A,{
p("Aqara","lumi.switch.acn047"),p("Aqara","lumi.switch.acn049"),p("Aqara","lumi.switch.acn057"),p("LUMI","lumi.ctrl_ln2"),p("LUMI","lumi.ctrl_ln2.aq1"),p("LUMI","lumi.ctrl_neutral2"),p("LUMI","lumi.relay.c2acn01"),p("LUMI","lumi.switch.acn030"),p("LUMI","lumi.switch.acn047"),p("LUMI","lumi.switch.acn049"),p("LUMI","lumi.switch.acn057"),p("LUMI","lumi.switch.b2laus01"),p("LUMI","lumi.switch.b2lacn01"),p("LUMI","lumi.switch.b2nacn01"),p("LUMI","lumi.switch.b2nacn02"),p("LUMI","lumi.switch.b2naus01"),p("LUMI","lumi.switch.b2lc04"),p("LUMI","lumi.switch.b2nc01"),p("LUMI","lumi.switch.l2acn1"),p("LUMI","lumi.switch.l2aeu1"),p("LUMI","lumi.switch.n2acn1"),p("LUMI","lumi.switch.n2aeu1")})b(ai,{
p("Aqara","lumi.switch.acn055"),p("Aqara","lumi.switch.acn059"),p("LUMI","lumi.switch.acn031"),p("LUMI","lumi.switch.acn040"),p("LUMI","lumi.switch.acn054"),p("LUMI","lumi.switch.acn055"),p("LUMI","lumi.switch.acn058"),p("LUMI","lumi.switch.acn059"),p("LUMI","lumi.switch.b3l01"),p("LUMI","lumi.switch.b3n01"),p("LUMI","lumi.switch.l3acn1"),p("LUMI","lumi.switch.l3acn3"),p("LUMI","lumi.switch.n3acn1"),p("LUMI","lumi.switch.n3acn3"),p("LUMI","lumi.switch.n4acn4")})b(o,m("TS011F",{
"_TZ3000_46vasa5h","_TZ3000_mvn6jl7x","_TZ3000_raviyuvk","_TYZB01_hlla45kx","_TZ3000_92qd4sqa","_TZ3000_zwaadvus","_TZ3000_k6fvknrr","_TZ3000_6s5dc9lx","_TZ3000_helyqdvs","_TZ3000_rgpqqmbj","_TZ3000_8nyaanzb","_TZ3000_iy2c3n6p","_TZ3000_qlmnxmac","_TZ3000_sgb0xhwn","_TZ3210_ph1joc22","_TZ3210_sgb0xhwn","_TZ3000_iv6ph5tr","_TZ3000_pmz6mjyu","_TZ3000_rul9yxcc","_TZ3000_mlswgkc3","_TZ3000_v4mevirn","_TZ3000_zigisuyh","_TZ3000_xeumnff9","_TZ3000_2xlvlnez","_TZ3000_cymsnfvf","_TZ3210_2uk4z8ce"}))b(o,{
p("HOBEIAN","ZG-305Z")})b(o,m("TS000F",{
"_TZ3000_m8f3z8ju"}))b(ap,m("TS000F",{
"_TZ3218_sgbsg6mr"}))b(aP,m("TS0002",{
"_TZ3000_ruxexjfz"}))b(o,m("TS0002",{
"_TZ3000_01gpyda5","_TZ3000_bvrlqyj7","_TZ3000_7ed9cqgi","_TZ3000_zmy4lslw","_TZ3000_4xfqlgqo","_TZ3000_hojntt34","_TZ3000_eei0ubpy","_TZ3000_qaa59zqd","_TZ3000_lmlsduws","_TZ3000_fbjdkph9","_TZ3000_zbfya6h0","_TZ3000_hznzbl0x","_TZ3000_fisb3ajo","_TZ3000_5gey1ohx","_TZ3000_mtnpt6ws","_TZ3000_mufwv0ry","_TZ3000_54hjn4vs","_TZ3000_aa5t61rh","_TZ3000_in5qxhtt","_TZ3000_ogpla3lh","_TZ3000_i9w5mehz","_TZ3000_dershnvx","_TZ3000_ywubfuvt","_TZ3000_wnzoyohq","_TZ3000_5ksufhqi","_TZ3210_nuenzetq","_TZ3000_zxrfobzw","_TZ3000_criiahcg","_TZ3000_lugaswf8","_TZ3000_nuenzetq","_TZ3000_ruldv5dt","_TZ3000_gkesadus","_TZ3000_rfjctviq","_TZ3000_yxmafzmd","_TZ3210_a2erlvb8","_TZ3210_pdnwpnz5"}))b(o,{
p("HOBEIAN","ZG-301Z-2CH")})b(o,m("TS0012",{
"_TZ3000_biakwrag","_TZ3000_18ejxno0"}))b(A,m("TS0003",{
"_TYZB01_digziiav","_TYZB01_zsl6z0pw","_TYZB01_uqkphoed"}))b(A,m("TS0002",{
"_TYZB01_digziiav","_TYZB01_zsl6z0pw","_TYZB01_uqkphoed","_TZ3000_iwtv2jwo","_TZ3000_h1ipgkwn","_TZ3000_tas0zemd"}))b(o,m("TS0002",{
"_TZ3210_6smingw0"}))b(A,{
p("Somfy","ON/OFF (2CH)"),p("Sunricher","ON/OFF (2CH)")})b(aW,m("TS0012",{
"_TZ3000_jl7qyupf","_TZ3000_nPGIPl5D","_TZ3000_kpatq5pq","_TZ3000_ljhbw1c9","_TZ3000_4zf0crgo"}))b(z,m("TS0003",{
"_TZ3000_vjhcenzo","_TZ3000_f09j9qjb","_TZ3000_rhkfbfcv","_TZ3000_empogkya","_TZ3000_lubfc1t5","_TZ3000_lsunm46z","_TZ3000_v4l4b0lp","_TZ3000_uilitwsy","_TZ3000_66fekqhh","_TZ3000_ok0ggpk7","_TZ3210_ok0ggpk7","_TZ3000_aknpkt02","_TZ3210_aksyshpw","_TZ3000_nwidmc4n","_TZ3000_pfc7i3kt","_TZ3000_dyzkbcip","_TZ3000_ouwfc1qj","_TZ3000_eqsair32","_TZ3000_4o16jdca","_TZ3000_odzoiovu","_TZ3000_hbic3ka3","_TZ3000_lvhy15ix","_TZ3000_mhhxxjrs","_TZ3000_iv4eq7eh","_TZ3000_mzcp0of6","_TZ3000_pf7swkqp","_TZ3000_ju82pu2b","_TZ3000_vsasbzkf","_TZ3000_nnwehhst","_TZ3000_mw1pqqqt","_TZ3000_pv4puuxi","_TZ3000_avky2mvc","_TZ3000_785olaiq","_TZ3000_qxcnwv26","_TZ3000_g9chy2ib","_TZ3000_0q5fjqgw","_TZ3000_pmsxmttq","_TZ3000_zeuulson","_TZ33000_d9yfgzur"}))b(aO,m("TS0013",{
"_TZ3000_ypgri8yz","_TZ3000_sznawwyw","_TZ3000_avotanj3","_TZ3000_t7ugva7q"}))b(z,{
p("HOBEIAN","ZG-301Z-3CH")})b(w,m("TS0003",{
"_TYZB01_aneiicmq","_TYZB01_ncutbjdi","_TYZB01_u9kkqh5o"}))b(K,m("TS0004",{
"_TZ3000_ltt60asa","_TZ3000_mmkbptmx","_TZ3000_liygxtcq","_TZ3000_mdj7kra9","_TZ3000_u3oupgdy","_TZ3000_imaccztn","_TZ3000_iymfxdis","_TZ3000_nivavasg","_TZ3000_gexniqbq","_TZ3000_r9e2w7dn","_TZ3000_5ajpkyq6","_TZ3000_knoj8lpk","_TZ3000_3n2minvf","_TZ3000_tyg4yiat","_TZ3210_imaccztn","_TZ3210_wts1g2oh"}))b(s,{
p("_TZ3210_iymfxdis","TS0004")})b(I,m("TS0004",{
"_TZ3000_a37eix1s","_TZ3000_nsa76jai","_TZ3000_wwtnshol"}))b(aL,m("TS0006",{
"_TZ3000_cvis4qmw"}))b(s,m("TS011F",{
"_TZ3000_3zofvcaa","_TZ3000_pvlvoxvt","_TZ3000_lqb7lcq9","_TZ3210_lqb7lcq9","_TZ3210_urjf5u18","_TZ3210_8n4dn1ne"}))b(bf,{
p("_TZ3000_qiutut5y","TS011F")})b(z,m("TS011F",{
"_TZ3000_wzauvbcs","_TZ3000_oznonj5q","_TZ3000_1obwwnmq","_TZ3000_4uf3d0ax","_TZ3000_vzopcetz","_TZ3000_vmpbygs5","_TZ3000_dlug3kbc","_TZ3000_9tg32trw"}))b(an,m("TS011F",{
"_TZ3000_air9m6af","_TZ3000_9djocypn","_TZ3000_bppxj3sf"}))b(at,m("TS011F",{
"_TZ3000_in5s3wn1","_TZ3000_wbloefbf"}))b(at,m("TS011F",{
"_TZ3000_cfnprab5","_TZ3000_o005nuxx","_TZ3000_gdyjfvgm","_TZ3000_pl5v1yyy","_TZ3000_djgzdba9"}))h.attach_reporting_capabilities(am,{
{1,"rpt-tuj"},{2,"rpt-tkg",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree"}},{3,"rpt-tcm",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree"}},{4,"rpt-tzt"},{5,"rpt-tkp",{zr000600001="Switch",zr000600002="SwitchTwo"}},{6,"rpt-tzt"},{7,"rpt-sit"},{8,"rpt-sit"},{9,"rpt-tss"},{10,"rpt-sit"},{11,"rpt-tbx"},{12,"rpt-tpl"},{13,"rpt-tmp"},{14,"rpt-tks"},{15,"rpt-tet"},{16,"rpt-tlp"},{17,"rpt-tma"},{18,"rpt-tce"},{19,"rpt-twp"},{20,"rpt-sit"},{21,"rpt-tlc"},{22,"rpt-sit"},{23,"rpt-sit"},{24,"rpt-tss"},{25,"rpt-tss"},{26,"rpt-sit"},{27,"rpt-sit"},{28,"rpt-txu"},{29,"rpt-tss"},{30,"rpt-sit"},{31,"rpt-sit"},{32,"rpt-tlc"},{33,"rpt-tks"},{34,"rpt-tpe"},{35,"rpt-tye",{zr000600001="Switch",zr000600002="SwitchTwo"}},{36,"rpt-too",{zr000600001="Switch",zr000600002="SwitchTwo"}},{37,"rpt-too",{zr000600001="Switch",zr000600002="SwitchTwo"}},{38,"rpt-tve",{zr000600001="Switch",zr000600002="SwitchTwo"}},{39,"rpt-tfo",{zr000600001="Switch",zr000600002="SwitchTwo"}},{40,"rpt-tzz",{zr000600001="Switch",zr000600002="SwitchTwo"}},{41,"rpt-tum",{zr000600001="Switch",zr000600002="SwitchTwo"}},{42,"rpt-tev",{zr000600001="Switch",zr000600002="SwitchTwo"}},{43,"rpt-lvk",{zr000600001="Switch",zr000600002="SwitchTwo"}},{44,"rpt-sit"},{45,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{46,"rpt-lek",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree"}},{47,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{48,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{49,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{50,"rpt-tsl",{zr000600001="Switch",zr000600002="SwitchTwo"}},{51,"rpt-tqv",{zr000600001="Switch",zr000600002="SwitchTwo"}},{52,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{53,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{54,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{55,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{56,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{57,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{58,"rpt-lpm",{zr000600001="Switch",zr000600002="SwitchTwo"}},{59,"rpt-tkw",{zr000600001="Switch",zr000600002="SwitchTwo"}},{60,"rpt-lek",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree"}},{61,"rpt-tiu",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree"}},{62,"rpt-lek",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree"}},{63,"rpt-sit"},{65,"rpt-tmr",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree",zr000600004="SwitchFour"}},{67,"rpt-tqvv",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree",zr000600004="SwitchFour",zr000600005="SwitchFive",zr000600006="SwitchSix"}},{68,"rpt-tmr",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree",zr000600004="SwitchFour"}},{69,"rpt-tmr",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree",zr000600004="SwitchFour"}},{70,"rpt-lek",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree"}},{71,"rpt-tsh",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree",zr000600004="SwitchFour",zr000600005="SwitchFive"}},{72,"rpt-tfx",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree",zr000600004="SwitchFour",zr000600005="SwitchFive"}},{73,"rpt-tfx",{zr000600001="Switch",zr000600002="SwitchTwo",zr000600003="SwitchThree",zr000600004="SwitchFour",zr000600005="SwitchFive"}}})return{
id="zcl.switches.switches",registrations=am}
