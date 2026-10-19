local d=require"protocol.zcl"
local D=require"capabilities.events.all"
local b=require"contracts.helpers.family"
local e=require"contracts.helpers.zcl"
local m=require"st.zigbee.data_types"
local t=require"st.zigbee.device_management"
local av=require("st.zigbee.zcl.clusters").OnOff
local aj=require"st.zigbee.constants"
local s,a=b.definition_registry()
local function p(ao,aD)
local Q={}for _,aE in ipairs(aD)do
Q[#Q+1]=b.create_fingerprint(ao,aE)
end
return Q
end
local function f(Y,w)
return{
profile=Y,zcl_clusters=w,}
end
local function g(L,ab,ag)
return function(K,k)
for _,i in ipairs(L)do
k:send(t.build_bind_request(
k,d.CLUSTER_ON_OFF,K.environment_info.hub_zigbee_eui,i))if ab then
d.configure_reporting(k,{
cluster=av.ID,attribute=av.attributes.OnOff.ID,data_type=av.attributes.OnOff.base_type,minimum_interval=0,maximum_interval=3600,},i,{auto_endpoint=not ag,defer_on_override=true})
end
end
end
end
local function H(Y,L,P)
P=P or{}local w={}for al,i in ipairs(L)do
w[#w+1]=d.switch({
endpoint=i,component=al==1 and"main"or("switch"..tostring(al)),})
end
e.append_clusters(w,e.metering_clusters({
endpoint=L[1],include_switch=false,include_current=true,energy_scale=100,}))if P.tuya_magic then
e.append_clusters(w,d.tuya_magic_packet())
end
if P.power_outage_memory then
e.append_clusters(w,d.tuya_power_outage_memory())
end
local y=f(Y,w)if P.bind_on_off then
y.configure=g(L,P.configure_on_off_reporting,true)
end
return y
end
local function z(ak)
return e.metering_clusters({
include_switch=true,include_current=ak,})
end
local v=f("plugs-switch",{
d.switch(),})local o=f("plugs-switch",{
d.switch(),d.tuya_magic_packet(),})o.configure=g({1},true)local M=f("plugs-lidl-hg06337",{
d.switch({endpoint=11,component="main"}),d.tuya_magic_packet(),d.indicator_mode({endpoint=11}),})M.configure=g({11},true,true)local T=f("plugs-switch-child-lock",{
d.switch(),d.tuya_magic_packet(),d.child_lock(),})T.configure=g({1},true)local S=f("plugs-switch-tuya-options",{
d.switch(),d.tuya_magic_packet(),d.tuya_power_outage_memory(),d.indicator_mode(),d.child_lock(),d.countdown_timer(),})S.configure=g({1},true)local G=f("plugs-zemismart-zmo606-20a",{
d.switch(),d.tuya_magic_packet(),d.indicator_mode(),d.child_lock(),d.countdown_timer(),})G.configure=g({1},true)
local function ae(h)
if type(h)=="table"and type(h.is_alarm1_set)=="function"and type(h.is_alarm2_set)=="function"then
return{
water=h:is_alarm1_set(),tank=h:is_alarm2_set()and"full"or"normal",}
end
if type(h)=="table"and h.value~=nil then
h=h.value
end
if type(h)~="number"then
return nil
end
return{
water=h%2==1,tank=math.floor(h/2)%2==1 and"full"or"normal",}
end
local function aa(aw)
local ay=aw and aw.body and aw.body.zcl_body or nil
local A=ay and(ay.zone_status or ay.zonestatus)or nil
if A==nil then
return nil
end
return{
raw_value=type(A)=="table"and A.value or A,typed_value=A,}
end
local c={}for i=1,5 do
c[#c+1]=d.switch({
endpoint=i,component=i==1 and"main"or("switch"..tostring(i)),})
end
for i=1,3 do
c[#c+1]=d.cluster_attribute(d.CLUSTER_ON_OFF,61443,{
name="bacchus_pump_duration",endpoint=i,component=i==1 and"main"or("switch"..tostring(i)),emit=D.bacchusPumpDuration(),data_type=m.Uint16,write_type=m.Uint16,numeric_range={minimum=0,maximum=600,step=1},read_on_configure=true,})
end
c[#c+1]=d.cluster_attribute(d.CLUSTER_ON_OFF,61445,{
name="bacchus_beeper_on_leak",endpoint=1,component="main",emit=D.bacchusBeeperOnLeak(),
from_device=function(h)return h and"on"or"off"end,
to_device=function(h)return h=="on"end,
data_type=m.Boolean,write_type=m.Boolean,read_on_configure=true,})local X=D.water()local N=D.bacchusTankFull()c[#c+1]=d.ias_zone({
name="bacchus_tank_full",endpoint=6,component="tank",
emit=function(k,h)
return X(k,h.water)
end,
handler=function(k,h)
local aA=N(k,h.tank)if aA~=nil then
k:emit_component_event({id="tank"},aA)
end
end,
from_device=ae,prefer_typed_value=true,ias_configure_method=aj.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=aa,})local B=f("plugs-bacchus-water-station",c)
B.configure=function(K,k)
g({1,2,3,4,5},true,true)(K,k)k:send(t.build_bind_request(
k,d.CLUSTER_IAS_ZONE,K.environment_info.hub_zigbee_eui,6))
end
local V=f("plugs-switch-2",{
d.switch({
endpoint=1,component="main",}),d.switch({
endpoint=7,component="switch2",}),d.tuya_magic_packet(),})V.configure=g({1,7})local ap=f("plugs-switch-power-energy-voltage",z(false))local q=f("plugs-switch-power-energy-voltage-current",z(true))local j=f("plugs-switch-power-energy-voltage-current",{
d.switch(),d.power(),d.energy({scale=100}),d.voltage(),d.current(),d.tuya_magic_packet(),})
j.configure=function(K,k)
for _,C in ipairs({d.CLUSTER_ON_OFF,2820,1794})do
k:send(t.build_bind_request(
k,C,K.environment_info.hub_zigbee_eui,1))
end
end
local r=f("plugs-switch-power-voltage-current",{
d.switch(),d.power(),d.voltage(),d.current(),})
r.configure=function(K,k)
for _,C in ipairs({d.CLUSTER_ON_OFF,2820})do
k:send(t.build_bind_request(
k,C,K.environment_info.hub_zigbee_eui,1))
end
end
local ad=f("switch-power-energy",{
d.switch(),d.power(),d.energy(),})local R=f("switches-switch-1-power-energy-voltage-current",e.metering_clusters({
endpoint=2,switch_component="main",include_current=true,}))local ai=H("plugs-wp30-power-strip",{1,2,3},{
tuya_magic=true,power_outage_memory=true,bind_on_off=true,configure_on_off_reporting=true,})
local function af(at)
return function(h)
return at[h]
end
end
local function ah(at)
return function(h)
return at[h]
end
end
local function l(aF,i,U,C,an,aC,au,ax)
return d.cluster_attribute(C,an,{
name=aF,endpoint=i,component=U,emit=aC,from_device=af(au),to_device=ah(ax),data_type=m.Enum8,write_type=m.Enum8,read_on_configure=true,})
end
local function J(Y,ac)
local y=f(Y,{
d.switch(),d.power(),d.energy({scale=100}),d.voltage(),d.current(),d.tuya_magic_packet(),l("ts011f_plug1_power_outage_memory",1,"main",d.CLUSTER_ON_OFF,32770,D.ts011fPlug1PowerOutageMemory(),{[0]="off",[1]="on",[2]="restore"},{off=0,on=1,restore=2}),l("ts011f_plug1_indicator_mode",1,"main",d.CLUSTER_ON_OFF,32769,D.ts011fPlug1IndicatorMode(),{[0]="off",[1]="off_on",[2]="on_off",[3]="on"},{off=0,off_on=1,on_off=2,on=3}),d.cluster_attribute(d.CLUSTER_ON_OFF,32768,{
name="ts011f_plug1_child_lock",endpoint=1,component="main",emit=D.ts011fPlug1ChildLock(),data_type=m.Boolean,write_type=m.Boolean,
from_device=function(h)return h and"on"or"off"end,
to_device=function(h)return h=="on"end,read_on_configure=true,
}),d.countdown_timer({name="ts011f_plug1_countdown",endpoint=1,component="main",emit=D.ts011fPlug1Countdown()}),})if ac then
e.append_clusters(y.zcl_clusters,l("ts011f_plug1_switch_type_button",1,"main",57345,53296,D.ts011fPlug1SwitchTypeButton(),{[0]="release",[1]="press"},{release=0,press=1}))
end
y.configure=j.configure
return y
end
local as=J("plugs-switch-power-energy-voltage-current-ts011f-plug1",true)local W=J("plugs-switch-power-energy-voltage-current-ts011f-plug1-no-button",false)
local function Z(k,_,h,aB)
if h~="identify"then
return false
end
return d.send_raw_cluster_command(
k,3,0,string.char(3,0),aB.endpoint or 1)
end
local u=H("plugs-nous-a11z",{1,2,3})e.append_clusters(u.zcl_clusters,d.tuya_magic_packet())for al,i in ipairs({1,2,3})do
local U=al==1 and"main"or("switch"..tostring(al))e.append_clusters(u.zcl_clusters,l(
"nous_a11z_power_on_behavior",i,U,57345,53264,D.nousA11zPowerBehavior(),{[0]="off",[1]="on",[2]="previous"},{off=0,on=1,previous=2}),d.countdown_timer({
name="nous_a11z_countdown",endpoint=i,component=U,emit=D.nousA11zCountdown(),}))
end
e.append_clusters(u.zcl_clusters,l(
"nous_a11z_indicator_mode",1,"main",d.CLUSTER_ON_OFF,32769,D.nousA11zIndicatorMode(),{[0]="off",[1]="off_on",[2]="on_off",[3]="on"},{off=0,off_on=1,on_off=2,on=3}),d.cluster_attribute(d.CLUSTER_ON_OFF,32768,{
name="nous_a11z_child_lock",endpoint=1,component="main",emit=D.nousA11zChildLock(),
from_device=function(h)return h and"on"or"off"end,
to_device=function(h)return h=="on"end,
data_type=m.Boolean,write_type=m.Boolean,read_on_configure=true,}),l(
"nous_a11z_switch_type",1,"main",57345,53296,D.nousA11zSwitchType(),{[0]="release",[1]="press"},{release=0,press=1}),d.cluster_attribute(3,nil,{
name="nous_a11z_identify",endpoint=1,component="main",write_only=true,enum_values={"identify"},sender=Z,}))local az={
profile="plugs-switch-5",zcl_clusters=d.multi_switch({1,2,3,4,7}),}a(o,b.create_fingerprints("TS011F",{
"_TZ3000_oiymh3qu",}))a(o,b.create_fingerprints("TS0101",{
"_TZ3000_br3laukf","_TZ3000_pnzfdr9y","_TYZB01_ijihzffk",}))a(v,b.create_fingerprints("TS0101",{
"_TZ3210_eymunffl","_TZ3210_tfxwxklq","_TZ3210_2dfy6tol",}))a(V,b.create_fingerprints("TS0108",{
"_TYZB01_7yidyqxd",}))a(T,b.create_fingerprints("TS011F",{
"_TZ3000_wxtp7c5y","_TYZB01_mtunwanm",}))a(S,b.create_fingerprints("TS011F",{
"_TZ3000_hyfvrar3","_TZ3000_v1pdxuqq","_TZ3000_8a833yls","_TZ3000_bfn1w0mm","_TZ3000_nzkqcvvs","_TZ3000_rtcrrvia","_TZ3000_ysiog9xi","_TZ3000_o1jzcxou","_TZ3210_nhqka112","_TZ3000_uyrhiafs",}))a(o,b.create_fingerprints("TS011F",{
"_TZ3000_8fdayfch","_TZ3000_1hwjutgo","_TZ3000_lnggrqqi","_TZ3000_tvuarksa",}))a(M,b.create_fingerprints("TS011F",{
"_TZ3000_00mk2xzy","_TZ3000_upjrsxh1","_TZ3000_plyvnuf5","_TZ3000_wamqdr3f",}))a(G,b.create_fingerprints("TS011F",{
"_TZ3000_b1q8kwmh",}))a(B,{
b.create_fingerprint("Bacchus","Water_Station"),b.create_fingerprint("Bacchus","Water_Station.Modkam"),})a(j,b.create_fingerprints("TS011F",{
"_TZ3000_ko6v90pg","_TZ3008_1a8m8wd6","_TZ3008_reatplte","_TZ3210_2putqrmw","_TZ3210_2uollq9d","_TZ3210_4ux0ondb","_TZ3210_zifx0xoj","_TZ3000_4ux0ondb","_TZ3000_b28wrpvx","_TZ3000_2uollq9d","_TZ3000_cehuw1lw","_TZ3000_9ni6xxld","_TZ3210_5ct6e7ye","_TZ3000_2putqrmw","_TZ3000_ksw8qtmt","_TZ3000_yujkchbz","_TZ3000_ss98ec5d","_TZ3000_y4ona9me","_TZ3000_266azbg3","_TZ3000_3ias4w4o","_TZ3210_ddigca5n","_TZ3210_rwmitwj4","_TZ3000_gjnozsaz","_TZ3210_jlf1nepw","_TZ3000_cjrngdr3","_TZ3210_cjrngdr3","_TZ3000_amdymr7l","_TZ3000_zloso4jk",}))a(as,b.create_fingerprints("TS011F",{
"_TZ3008_tary5dvv","_TZ3210_iooniers","_TZ3008_iooniers","_TZ3008_xvfd3nkp","_TZ3008_qziabvzj","_TZ3210_w0qqde0g",}))a(W,b.create_fingerprints("TS011F",{
"_TZ3000_w0qqde0g",}))a(j,{
{manufacturer="AOYAN  ",model="TS011F"},})a(ap,{
b.create_fingerprint("LUMI","lumi.ctrl_86plug"),b.create_fingerprint("LUMI","lumi.ctrl_86plug.aq1"),b.create_fingerprint("LUMI","lumi.plug"),b.create_fingerprint("LUMI","lumi.plug.aq1"),b.create_fingerprint("LUMI","lumi.plug.mitw01"),})a(q,{
b.create_fingerprint("LUMI","lumi.plug.aeu001"),b.create_fingerprint("LUMI","lumi.plug.macn01"),b.create_fingerprint("LUMI","lumi.plug.maeu01"),b.create_fingerprint("LUMI","lumi.plug.maus01"),b.create_fingerprint("LUMI","lumi.plug.mmeu01"),b.create_fingerprint("LUMI","lumi.plug.sacn02"),})a(R,{
b.create_fingerprint("frient A/S","SMRZB-153"),})a(ad,{
b.create_fingerprint("Schneider Electric","SMARTPLUG/1"),})a(j,b.create_fingerprints("TS011F",{
"_TZ3000_3uimvkn6","_TZ3000_j1v25l17","_TZ3000_ynmowqk2","_TZ3000_0yxeawjt",}))a(r,{
b.create_fingerprint("AduroSmart ERIA","ONOFF_METER_RELAY"),b.create_fingerprint("HEIMAN","SmartPlug-N"),})a(v,{
b.create_fingerprint("Third Reality, Inc","3RSP019BZ"),})a(q,{
b.create_fingerprint("Third Reality, Inc","3RSP02028BZ"),b.create_fingerprint("Third Reality, Inc","3RSPE01044BZ"),})a(q,{
b.create_fingerprint("Heiman","SmartPlug"),b.create_fingerprint("HEIMAN","SmartPlug"),b.create_fingerprint("HEIMAN","SmartPlug-EF-3.0"),})a(v,p("LEDVANCE",{
"Outdoor Plug","PLUG COMPACT EU T","PLUG OUTDOOR EU T","Plug Value",}))a(q,p("LEDVANCE",{
"PLUG COMPACT OUTDOOR EU EM T","PLUG COMPACT EU EM T",}))a(v,p("OSRAM",{
"Plug 01","Plug Z3",}))a(ai,b.create_fingerprints("TS011F",{
"_TZ3000_c7nc9w3c","_TZ3210_c7nc9w3c",}))a(u,b.create_fingerprints("TS011F",{
"_TZ3210_6cmeijtd",}))
local function E()
local n=require"contracts.helpers.family"
local O=require"contracts.helpers.zcl"
local am,aq=n.definition_registry()local I={
profile="plugs-switch-power-energy-voltage",zcl_clusters=O.metering_clusters({
include_switch=true,include_current=false,}),}aq(I,{
n.create_fingerprint("SONOFF","S60ZBTPG"),})aq(I,{
n.create_fingerprint("Innr","SP 242"),n.create_fingerprint("Innr","SP 244"),})return am
end
for _,ar in ipairs(E())do
s[#s+1]=ar
end
local F=f("plugs-switch-power-energy-voltage-current",{
d.switch(),d.power({configure_reporting=false}),d.energy({scale=100}),d.voltage({configure_reporting=false}),d.current({configure_reporting=false}),d.tuya_magic_packet(),})a(F,{
b.create_fingerprint("_TZ3000_okaz9tjs","TS011F"),})local x=f("plugs-switch-power-energy-voltage-current",{
d.switch(),d.power({configure_reporting=false}),d.energy({scale=100}),d.voltage(),d.current(),d.tuya_magic_packet(),})a(x,b.create_fingerprints("TS011F",{
"_TZ3000_ww6drja5","Zbeacon","_TZ3000_cicwjqth",}))d.attach_reporting_capabilities(s,{
{1,"rpt-zvs"},{2,"rpt-zvs"},{3,"rpt-zvs"},{4,"rpt-zef",{["zr000600001"]="Switch",["zr000600007"]="SwitchTwo"}},{5,"rpt-tpg"},{6,"rpt-tct"},{7,"rpt-zvs"},{8,"rpt-tqr"},{9,"rpt-tcp"},{10,"rpt-wzp",{["zr000600001"]="Switch",["zr000600002"]="SwitchTwo",["zr000600003"]="SwitchThree",["zr000600004"]="SwitchFour",["zr000600005"]="SwitchFive"}},{11,"rpt-tcb"},{12,"rpt-txn"},{13,"rpt-trp"},{14,"rpt-tcb"},{15,"rpt-lsu"},{16,"rpt-tcb"},{17,"rpt-sho"},{18,"rpt-sbv"},{19,"rpt-tcb"},{20,"rpt-ogk"},{21,"rpt-zvs"},{22,"rpt-tcb"},{23,"rpt-tcb"},{24,"rpt-zvs"},{25,"rpt-tcb"},{26,"rpt-zvs"},{27,"rpt-txa",{["zr000600001"]="Switch",["zr000600002"]="SwitchTwo",["zr000600003"]="SwitchThree"}},{28,"rpt-ttq",{["zr000600001"]="Switch",["zr000600002"]="SwitchTwo",["zr000600003"]="SwitchThree"}},{29,"rpt-lsu"},{30,"rpt-lsu"},{31,"rpt-tpp"},{32,"rpt-tzo"},})return{
id="zcl.plugs",registrations=s,}
