local j=require"protocol.zcl"
local e=require"contracts.helpers.family"
local R=require"contracts.helpers.zcl"
local g=require"capabilities.events.all"
local m=require"st.capabilities"
local V=require"st.zigbee.device_management"
local c=require"st.zigbee.data_types"
local N=require"st.zigbee.cluster_base"
local cF=require"st.buf"
local cC=require"st.json"
local aq,d=e.definition_registry()local aR=5
local L=18
local bI=57348
local bc=85
local bi="__namron_simplify_pending_press"
local ad={
pushed=m.button.button.pushed,double=m.button.button.double,held=m.button.button.held,up=m.button.button.up,down=m.button.button.down,up_hold=m.button.button.up_hold,down_hold=m.button.button.down_hold,}local bD={
[0]="hold",[1]="single",[2]="double",[3]="triple",[4]="quadruple",[5]="quintuple",[300]="N/A",[255]="release",}local X={
single="pushed",double="double",hold="held",}
local function P(E)
if type(E)~="number"then return E end
local aV=math.floor((((E-2.0)/1.0)*100)+0.5)
if aV<0 then return 0 end
if aV>100 then return 100 end
return aV
end
local bq={
profile="buttons-button-3-battery",button_actions={"pushed","double","held"},zcl_clusters={
j.tuya_magic_packet(),j.cluster_attribute(
j.CLUSTER_POWER_CONFIGURATION,j.ATTR_BATTERY_PERCENTAGE_REMAINING,{name="battery",endpoint=1,emit=g.battery(),scale=2}),j.cluster_attribute(
j.CLUSTER_POWER_CONFIGURATION,j.ATTR_BATTERY_VOLTAGE,{
name="battery",endpoint=1,emit=g.battery(),scale=10,from_device=P,}),},}d(bq,{
e.create_fingerprint("_TZ3000_9zc1ilmb","TS0043"),})
local function Y(endpoint)
return endpoint==1 and"main"or("button"..tostring(endpoint))
end
local function be(a,O,action)
local K=X[action]local bZ=K and ad[K]or nil
if type(bZ)~="function"then
return
end
if type(a.supports_capability_by_id)=="function"and not a:supports_capability_by_id(m.button.ID,O)then
return
end
a:emit_component_event({id=O},bZ({state_change=true}))j.schedule_battery_refresh_after_button(a)
end
local function ac(endpoint)
local O=Y(endpoint)return j.cluster_attribute(L,bc,{
name="remote_action",endpoint=endpoint,component=O,emit=g.remote_action(),
from_device=function(value)
local action=bD[value]if action==nil then
return nil
end
return action.."_"..tostring(endpoint)
end,
handler=function(a,action)
if type(action)~="string"then
return
end
be(a,O,action:match("^([^_]+)"))
end,
})
end
local function ak(aA,I)
for endpoint=1,I do
aA[#aA+1]=ac(endpoint)
end
end
local function aE(aL,bF)
return function(w,a)
for endpoint=1,bF do
for _,t in ipairs(aL)do
a:send(V.build_bind_request(
a,t,w.environment_info.hub_zigbee_eui,endpoint))
end
end
end
end
local function i(y,...)
local ct=y and y.body and y.body.zcl_body or nil
if type(ct)~="table"then
return nil
end
for _,cv in ipairs({...})do
local value=ct[cv]if type(value)=="table"and value.value~=nil then
return value.value
end
if value~=nil then
return value
end
end
return nil
end
local bt={
[0]={name="click",button_event="pushed"},[2]={name="double_click",button_event="double"},[4]={name="hold",button_event="held"},}
local function at(v,I)
if type(v)=="table"and v.value~=nil then
v=v.value
end
if type(v)~="number"or v%1~=0 or
v<1 or v>(I*6)-1 then
return nil
end
local bA=(v-1)%6
local action=bt[bA]if action==nil then
return nil
end
local F=math.floor((v-1)/6)+1
return{
action="button_"..tostring(F).."_"..action.name,button_event=action.button_event,component=F==1 and"main"or("button"..tostring(F)),}
end
local function Z(I,bX)
return j.cluster_attribute(j.CLUSTER_IAS_ZONE,j.ATTR_ZONE_STATUS,{
name="linxura_button_action_"..tostring(I),endpoint=1,read_only=true,command_id=0,
command_extractor=function(y)
return i(y,"zonestatus","zone_status")
end,
from_device=function(value)
return at(value,I)
end,
handler=function(a,x)
if type(x)~="table"then
return
end
if type(a.supports_capability_by_id)=="function"and
not a:supports_capability_by_id(m.button.ID,x.component)then
return
end
a:emit_component_event(
{id=x.component},m.button.button(x.button_event,{state_change=true}))if bX then
j.schedule_battery_refresh_after_button(a)
end
end,
})
end
local function ae(w,a)
a:send(V.build_bind_request(
a,j.CLUSTER_IAS_ZONE,w.environment_info.hub_zigbee_eui,1))
end
local bx={
profile="buttons-button-12-battery",button_actions={"pushed","double","held"},button_count=12,zcl_clusters={
Z(12,true),j.battery({
endpoint=1,minimum_interval=3600,maximum_interval=0,reportable_change=1,read_on_configure=true,}),},configure=ae,}local by={
profile="buttons-button-4",button_actions={"pushed","double","held"},button_count=4,zcl_clusters={
Z(4,false),},configure=ae,}d(bx,{
e.create_fingerprint("Linxura","Aura Smart Button"),})d(by,{
e.create_fingerprint("Linxura","Smart Controller"),})
local function ce(F)
return F==1 and"main"or("button"..tostring(F))
end
local function ao(y,t,k,M)
if type(M)~="number"or M<1 or M>3 then
return nil,nil,true
end
local action=nil
if t==j.CLUSTER_ON_OFF then
action=({
[0]="off",[1]="on",[2]="toggle",[64]="off",})[k]elseif t==j.CLUSTER_LEVEL_CONTROL then
if k==0 or k==4 then
action="brightness_move_to_level"
elseif k==1 or k==5 then
local au=i(y,"move_mode","movemode","mode")action=au==1 and"brightness_move_down"or"brightness_move_up"
elseif k==2 or k==6 then
local au=i(y,"step_mode","stepmode","mode")action=au==1 and"brightness_step_down"or"brightness_step_up"
elseif k==3 or k==7 then
action="brightness_stop"
end
elseif t==j.CLUSTER_COLOR_CONTROL then
if k==75 then
action=({
[0]="color_temperature_move_stop",[1]="color_temperature_move_up",[3]="color_temperature_move_down",})[i(y,"move_mode","movemode","mode")]elseif k==71 then
action="stop_move_step"
elseif k==76 then
local au=i(y,"step_mode","stepmode","mode")action=au==1 and"color_temperature_step_up"or"color_temperature_step_down"
elseif k==67 then
action="enhanced_move_to_hue_and_saturation"
elseif k==6 then
action="move_to_hue_and_saturation"
elseif k==2 then
local au=i(y,"step_mode","stepmode","mode")action=au==1 and"color_hue_step_up"or"color_hue_step_down"
elseif k==5 then
local au=i(y,"step_mode","stepmode","mode")action=au==1 and"color_saturation_step_up"or"color_saturation_step_down"
elseif k==68 then
action="color_loop_set"
elseif k==10 then
action="color_temperature_move"
elseif k==7 then
action="color_move"
elseif k==1 then
action=({[1]="hue_move",[3]="hue_down"})[
i(y,"move_mode","movemode","mode")]or"hue_stop"
elseif k==3 then
action="move_to_saturation"
elseif k==0 then
action="move_to_hue"
end
elseif t==aR then
local bb=i(y,"sceneid","scene_id")if k==0 then
action="add"
elseif k==2 then
action="remove"
elseif k==3 then
action="remove_all"
elseif k==4 then
action=bb~=nil and("store_"..tostring(bb))or"store"
elseif k==5 then
action=bb~=nil and("recall_"..tostring(bb))or"recall"
end
end
return action,Y(M),true
end
local l={
profile="buttons-button-3-battery-remote-action-slacky",button_actions={"pushed","double","held"},advanced_remote=true,button_count=3,standard_action_endpoint_suffix=true,standard_command_action_resolver=ao,zcl_clusters={
j.battery({
endpoint=1,minimum_interval=3600,maximum_interval=14400,reportable_change=0,read_on_configure=true,}),},}ak(l.zcl_clusters,3)local ax={[0]="off",[1]="on",[2]="toggle"}local aG={off=0,on=1,toggle=2}local T={
[0]="toggle",[1]="momentary",[2]="multifunction",[3]="brightness_level",[4]="brightness_level_up",[5]="brightness_level_down",[6]="move_to_color_temperature",[7]="move_to_color_temperature_up",[8]="move_to_color_temperature_down",[9]="scene",}local af={}
for cG,value in pairs(T)do af[value]=cG end
local function ar(ba,endpoint,p,t,ay,am,bW,cn)
return j.cluster_attribute(t,ay,{
name=ba,endpoint=endpoint,component=p,emit=am,
from_device=function(value)return bW[value]end,
to_device=function(value)return cn[value]end,
data_type=c.Enum8,write_type=c.Enum8,read_on_configure=true,})
end
local function B(ba,endpoint,p,t,ay,am,aH)
return j.cluster_attribute(t,ay,{
name=ba,endpoint=endpoint,component=p,emit=am,data_type=aH,write_type=aH,read_on_configure=true,})
end
local aT={
[1]={
switch_action=g.slackyThreeSwitchActionOne(),switch_type=g.slackyThreeSwitchTypeOne(),scene_id=g.slackyThreeSceneIdOne(),group_id=g.slackyThreeGroupIdOne(),min_level=g.slackyThreeMinLevelOne(),max_level=g.slackyThreeMaxLevelOne(),},[2]={
switch_action=g.slackyThreeSwitchActionTwo(),switch_type=g.slackyThreeSwitchTypeTwo(),scene_id=g.slackyThreeSceneIdTwo(),group_id=g.slackyThreeGroupIdTwo(),min_level=g.slackyThreeMinLevelTwo(),max_level=g.slackyThreeMaxLevelTwo(),},[3]={
switch_action=g.slackyThreeSwitchActionThree(),switch_type=g.slackyThreeSwitchTypeThree(),scene_id=g.slackyThreeSceneIdThree(),group_id=g.slackyThreeGroupIdThree(),min_level=g.slackyThreeMinLevelThree(),max_level=g.slackyThreeMaxLevelThree(),},}for endpoint=1,3 do
local cE=({"One","Two","Three"})[endpoint]local suffix=cE:lower()local p=endpoint==1 and"main"or("button"..endpoint)local an=aT[endpoint]l.zcl_clusters[#l.zcl_clusters+1]=ar(
"slacky3_switch_action_"..suffix,endpoint,p,7,16,an.switch_action,ax,aG)l.zcl_clusters[#l.zcl_clusters+1]=ar(
"slacky3_switch_type_"..suffix,endpoint,p,7,61440,an.switch_type,T,af)l.zcl_clusters[#l.zcl_clusters+1]=B(
"slacky3_scene_id_"..suffix,endpoint,p,5,61440,an.scene_id,c.Uint8)l.zcl_clusters[#l.zcl_clusters+1]=B(
"slacky3_group_id_"..suffix,endpoint,p,5,61441,an.group_id,c.Uint16)l.zcl_clusters[#l.zcl_clusters+1]=B(
"slacky3_min_level_"..suffix,endpoint,p,j.CLUSTER_LEVEL_CONTROL,2,an.min_level,c.Uint8)l.zcl_clusters[#l.zcl_clusters+1]=B(
"slacky3_max_level_"..suffix,endpoint,p,j.CLUSTER_LEVEL_CONTROL,3,an.max_level,c.Uint8)
end
local aF={
L,j.CLUSTER_ON_OFF,j.CLUSTER_LEVEL_CONTROL,j.CLUSTER_COLOR_CONTROL,aR,}l.configure=aE(aF,3)d(l,{
e.create_fingerprint("Slacky-DIY","TS0043-z-SlD"),e.create_fingerprint("Slacky-DIY","TS0043-M007-SlD"),})
local function bL(w,a,endpoint,aL)
for _,t in ipairs(aL)do
a:send(V.build_bind_request(
a,t,w.environment_info.hub_zigbee_eui,endpoint))
end
end
local bd={
profile="controllers-candeo-rd1p-rem",advanced_remote=true,unprefixed_remote_actions=true,remote_action_emit_name="candeoRd1pRemAction",standard_command_action_resolver=R.resolve_rd1p_rotary_action,zcl_clusters={
j.power({
endpoint=1,minimum_interval=5,maximum_interval=300,reportable_change=10,}),j.voltage({
endpoint=1,minimum_interval=5,maximum_interval=600,reportable_change=500,}),j.current({
endpoint=1,minimum_interval=5,maximum_interval=900,reportable_change=10,}),j.energy({
endpoint=1,minimum_interval=5,maximum_interval=1800,reportable_change=50,}),},
configure=function(w,a)
bL(w,a,2,{
j.CLUSTER_ON_OFF,j.CLUSTER_LEVEL_CONTROL,})
end,
}d(bd,{
e.create_fingerprint("Candeo","C-ZB-RD1Pv2-REM"),})
local function W(_,value)
if type(value)=="string"then
local aW=cF.Reader(value)while aW:remain()>1 do
local cv,aZ=aW:read_u8(),aW:read_u8()local ck=aZ==16 and 1 or
(aZ>=32 and aZ<=47 and((aZ%8)+1))or
(aZ==57 and 4)or(aZ==58 and 8)
if ck==nil or aW:remain()<ck then return nil end
if cv==1 then
value=c.parse_data_type(aZ,aW).value
break
end
aW:seek(ck)
end
elseif type(value)=="table"then
value=value[1]or value["1"]value=type(value)=="table"and value.value or value
end
if type(value)~="number"or value==0 then return nil end
local aV=math.max(0,math.min(100,((value-2850)*100)/150))return{
m.battery.battery(math.floor(aV+0.5)),m.voltageMeasurement.voltage({value=value/1000,unit="V"}),}
end
local bl=g.aqH1Action()
local function aI(a,action)
local J=bl(a,action)J.state_change=true
a:emit_component_event({id="main"},J)local K=X[action]if K~=nil then
a:emit_component_event({id="main"},m.button.button(K,{state_change=true}))
end
end
local function bm(value,_,al)
local cs=al.zb_rx.body.zcl_body.attr_records or{}for _,aa in ipairs(cs)do
if aa.attr_id.value==570 then
return type(value)=="table"and value.value or value
end
end
return nil
end
local as={
profile="controllers-aqara-h1",button_actions={"pushed","double","held"},zcl_clusters={
j.cluster_attribute(18,85,{
name="aq_h1_action",endpoint=1,read_only=true,handler=aI,
from_device=function(value)
return({[0]="hold",[1]="single",[2]="double",[255]="release"})[value]
end,
}),j.cluster_attribute(64704,570,{
name="aq_h1_action",endpoint=1,read_only=true,handler=aI,
from_device=function(value)
return({[1]="start_rotating",[2]="rotation",[3]="stop_rotating"})[value&~128]
end,
}),j.cluster_attribute(64704,570,{
name="aq_h1_rotation_button_state",endpoint=1,read_only=true,emit=g.aqH1RotationButtonState(),
from_device=function(value)return(value&128)==128 and"pressed"or"released"end,
}),j.cluster_attribute(64704,1,{
name="aq_h1_battery_voltage",endpoint=1,read_only=true,emit=W,}),j.cluster_attribute(64704,247,{
name="aq_h1_battery_struct",endpoint=1,read_only=true,emit=W,}),j.cluster_attribute(64704,65281,{
name="aq_h1_battery_nested",endpoint=1,read_only=true,emit=W,}),j.cluster_attribute(64704,9,{
name="aq_h1_operation_mode",endpoint=1,write_only=true,mfg_code=4447,data_type=c.Uint8,write_type=c.Uint8,emit=g.aqH1OperationMode(),
to_device=function(value)return({event=1,command=0})[value]end,
}),j.cluster_attribute(64704,564,{
name="aq_h1_sensitivity",endpoint=1,data_type=c.Uint16,write_type=c.Uint16,emit=g.aqH1Sensitivity(),
from_device=function(value)return({[720]="low",[360]="medium",[180]="high"})[value]end,
to_device=function(value)return({low=720,medium=360,high=180})[value]end,
sender=function(a,bj,value)
a:send(N.write_manufacturer_specific_attribute(a,64704,564,4447,c.Uint16,bj.to_device(value)):to_endpoint(1))
end,
}),j.cluster_attribute(0,65520,{
name="aq_h1_prevent_reset",endpoint=1,read_only=true,
handler=function(a,value,al)
if al.zb_rx.body.zcl_header.cmd.value==10 and
type(value)=="string"and value:sub(1,5)==string.char(170,16,5,65,135)then
a:send(N.write_manufacturer_specific_attribute(a,0,65520,4447,c.OctetString,string.char(170,16,5,65,71,1,1,16,1)):to_endpoint(1))
end
end,
}),},
configure=function(_,a)
a:send(N.write_manufacturer_specific_attribute(a,64704,9,4447,c.Uint8,1):to_endpoint(1))j.read_attribute(a,64704,564,1)
end,
parent_refresh=function(a)
j.read_attribute(a,64704,9,1,4447)j.read_attribute(a,64704,564,1,4447)
end,
}for _,cf in ipairs({
{558,"aq_h1_rotation_angle",g.aqH1RotationAngle()},{560,"aq_h1_rotation_angle_speed",g.aqH1RotationAngleSpeed()},{563,"aq_h1_rotation_percent",g.aqH1RotationPercent()},{562,"aq_h1_rotation_percent_speed",g.aqH1RotationPercentSpeed()},{561,"aq_h1_rotation_time",g.aqH1RotationTime()},})do
as.zcl_clusters[#as.zcl_clusters+1]=j.cluster_attribute(64704,cf[1],{
name=cf[2],endpoint=1,read_only=true,emit=cf[3],from_device=bm,})
end
d(as,{
e.create_fingerprint("LUMI","lumi.remote.rkba01"),})local aU={
[1]="single_up",[2]="double_up",[3]="release_up",[4]="hold_up",[11]="single_down",[12]="double_down",[13]="release_down",[14]="hold_down",}local aD={[1]="single_up",[2]="double_up",[3]="release_up",[4]="hold_up"}
local function C(endpoint,suffix,cy,ci,ba,am)
local bY=ci and aU or aD
return j.cluster_attribute(18,85,{
name=ba,endpoint=endpoint,read_only=true,
from_device=function(value)
return bY[value]and bY[value].."_"..suffix or nil
end,
handler=function(a,action)
local J=am(a,action)J.state_change=true
a:emit_component_event({id="main"},J)local aZ=action:match("^([^_]+)")local az=({single="pushed",double="double",release="up",hold="held"})[aZ]local p=ci and action:find("_down_",1,true)and ci or cy
a:emit_component_event({id=p},ad[az]({state_change=true}))
end,
})
end
local function u(a)
return a:get_endpoint(1)
end
local function U()
return{
j.cluster_attribute(1,33,{
name="battery",endpoint=u,component="main",read_only=true,data_type=c.Uint8,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
emit=function(a,value)
if value<255 then return g.battery()(a,value/2)end
end,
}),j.cluster_attribute(1,32,{
name="battery_voltage",endpoint=u,component="main",read_only=true,data_type=c.Uint8,
emit=function(a,value)
if value==255 then return nil end
local E=value*100
local S=100
if E<2100 then S=0
elseif E<2440 then S=6-(2440-E)*6/340
elseif E<2740 then S=18-(2740-E)*12/300
elseif E<2900 then S=42-(2900-E)*24/160
elseif E<3000 then S=100-(3000-E)*58/100 end
return{g.battery()(a,math.floor(S+0.5)),g.voltage()(a,value/10)}
end,
}),j.cluster_attribute(1,53,{
name="battery_low",endpoint=u,component="main",read_only=true,data_type=c.Bitmap8,
emit=function(_,value)
return value==1 and m.batteryLevel.battery.critical()or m.batteryLevel.battery.normal()
end,
}),}
end
local function Q(w,a)
j.bind_cluster(a,1,w.environment_info.hub_zigbee_eui,u(a))
end
local function ab(a)
for _,o in ipairs({33,32})do
j.read_attribute(a,1,o,u(a))
end
end
local function s(cq)
local aA={}for _,aK in ipairs(cq)do
local G={endpoint=aK[1],component=aK[2],configure_reporting=false}R.append_clusters(aA,j.switch(G),j.level({endpoint=aK[1],component=aK[2],configure_reporting=false}),j.color_hue({endpoint=aK[1],component=aK[2],configure_reporting=false}),j.color_saturation({endpoint=aK[1],component=aK[2],configure_reporting=false}),j.color({endpoint=aK[1],component=aK[2]}))
end
return aA
end
local function z(q,cq,bU,cu)
q.auto_on_before_light_command=false
for _,bM in ipairs(bU)do
q.zcl_clusters[#q.zcl_clusters+1]=j.switch({
endpoint=bM[1],component=bM[2],minimum_interval=0,maximum_interval=65000,})
end
q.configure=function(w,a)
for endpoint in pairs(a.zigbee_endpoints)do
if a:supports_server_cluster(768,endpoint)then
for _,o in ipairs({16394,16395,16396})do
j.read_attribute(a,768,o,endpoint)
end
end
if #bU>0 and a:supports_server_cluster(6,endpoint)then
j.bind_cluster(a,6,w.environment_info.hub_zigbee_eui,endpoint)j.read_attribute(a,6,0,endpoint)
end
end
end
q.parent_refresh=function(a)
for _,aK in ipairs(cq)do
j.read_attribute(a,6,0,aK[1])j.read_attribute(a,8,0,aK[1])for _,o in ipairs({0,1,3,4,8})do
j.read_attribute(a,768,o,aK[1])
end
end
for _,bM in ipairs(bU)do j.read_attribute(a,6,0,bM[1])end
if cu then
j.read_attribute(a,6,0,3)for _,o in ipairs({0,16,18,19,17,16384,15})do
j.read_attribute(a,8,o,3)
end
end
end
end
local aN={
profile="controllers-streda-bn0s",button_actions={"pushed","double","held","up"},component_to_endpoint_map={main=3,button1Down=3},zcl_clusters=U(),configure=Q,parent_refresh=ab,}aN.zcl_clusters[#aN.zcl_clusters+1]=
C(3,"button_1","main","button1Down","streda_bn0s_action",g.stredaBn0sAction())d(aN,{e.create_fingerprint("TKHTechnology","BN0-S-03/PW")})local aO={
profile="controllers-streda-bn0t",button_actions={"pushed","double","held","up"},component_to_endpoint_map={main=3,button1Down=3,button2Up=4,button2Down=4},zcl_clusters=U(),configure=Q,parent_refresh=ab,}for index,endpoint in ipairs({3,4})do
aO.zcl_clusters[#aO.zcl_clusters+1]=C(endpoint,"button_"..index,index==1 and"main"or"button2Up","button"..index.."Down","streda_bn0t_action",g.stredaBn0tAction())
end
d(aO,{e.create_fingerprint("TKHTechnology","BN0-T-03/PW")})local bn={
profile="controllers-streda-led1",zcl_clusters=s({{2,"main"}}),}z(bn,{{2,"main"}},{})d(bn,{
e.create_fingerprint("TKHTechnology","BN1-1-03/PW"),e.create_fingerprint("TKHTechnology","BN3-110-03/PW"),})local bo={
profile="controllers-streda-led2",zcl_clusters=s({{2,"main"},{4,"led2"}}),}z(bo,{{2,"main"},{4,"led2"}},{})d(bo,{e.create_fingerprint("TKHTechnology","DF3-11R-03/PW")})local aX={
profile="controllers-streda-ceiling",zcl_clusters=s({{2,"main"},{4,"led2"}}),}z(aX,{{2,"main"},{4,"led2"}},{{3,"outlet"}})d(aX,{
e.create_fingerprint("TKHTechnology","BN1-C-03/PW"),e.create_fingerprint("TKHTechnology","HN1-CW-4-03/PW"),})local aj={
profile="controllers-streda-sn2",zcl_clusters=s({{2,"main"},{4,"led2"}}),capability_commands={
{capability_id="concertmirror08464.stredaSn2OnLevel",command_name="usePreviousOnLevel",mapping_name="streda_sn2_on_level",value="previous"},{capability_id="concertmirror08464.stredaSn2StartupLevel",command_name="useMinimumStartupLevel",mapping_name="streda_sn2_startup_level",value="minimum"},{capability_id="concertmirror08464.stredaSn2StartupLevel",command_name="usePreviousStartupLevel",mapping_name="streda_sn2_startup_level",value="previous"},{capability_id="concertmirror08464.stredaSn2OnTransitionTime",command_name="disableOnTransitionTime",mapping_name="streda_sn2_on_transition_time",value="disabled"},{capability_id="concertmirror08464.stredaSn2OffTransitionTime",command_name="disableOffTransitionTime",mapping_name="streda_sn2_off_transition_time",value="disabled"},},}R.append_clusters(aj.zcl_clusters,j.switch({endpoint=3,component="dimmer",configure_reporting=false}),j.level({endpoint=3,component="dimmer",configure_reporting=false}))for _,bH in ipairs({
{18,"streda_sn2_on_transition_time",g.stredaSn2OnTransitionTime()},{19,"streda_sn2_off_transition_time",g.stredaSn2OffTransitionTime()},{15,"streda_sn2_execute_if_off",g.stredaSn2ExecuteIfOff()},{17,"streda_sn2_on_level",g.stredaSn2OnLevel()},{16384,"streda_sn2_startup_level",g.stredaSn2StartupLevel()},{16,"streda_sn2_on_off_transition_time",g.stredaSn2OnOffTransitionTime()},})do
local o=bH[1]local bG=o==16 or o==18 or o==19
aj.zcl_clusters[#aj.zcl_clusters+1]=j.cluster_attribute(8,o,{
name=bH[2],endpoint=3,component="dimmer",emit=bH[3],data_type=bG and c.Uint16 or o==15 and c.Bitmap8 or c.Uint8,prefer_plain_attribute_write=true,
from_device=function(value)
value=type(value)=="table"and value.value or value
if o==15 then return(value&1)==1 and"on"or"off"end
return bG and value/10 or value
end,
to_device=function(value)
if o==15 then return value=="on"and 1 or 0 end
if value=="disabled"then return 65535 end
if value=="previous"then return 255 end
if value=="minimum"then return 0 end
if bG then return math.max(0,math.min(65535,math.floor(value*10+0.5)))end
return math.max(o==17 and 1 or 0,math.min(255,math.floor(value+0.5)))
end,
})
end
z(aj,{{2,"main"},{4,"led2"}},{},true)d(aj,{e.create_fingerprint("TKHTechnology","SN2-E-03/PW")})local bB={
profile="controllers-streda-sn3",zcl_clusters=s({{2,"main"}}),button_actions={"pushed","double","held","up"},component_to_endpoint_map={main=2,socket=3,light=7,button1Up=4,button1Down=4,button2Up=5,button2Down=5},}local aP={
profile="controllers-streda-sn3k",zcl_clusters=s({{2,"main"}}),button_actions={"pushed","double","held","up"},component_to_endpoint_map={main=2,socket=3,light=7,button1Up=4,button1Down=4,button2Up=5,button2Down=5,doorbellButton=8},}for _,bw in ipairs({
{bB,"streda_sn3",g.stredaSn3Action(),g.stredaSn3Doorbell()},{aP,"streda_sn3k",g.stredaSn3kButtonAction(),g.stredaSn3kDoorbell()},})do
local q,bT,action=bw[1],bw[2],bw[3]for index,endpoint in ipairs({4,5})do
q.zcl_clusters[#q.zcl_clusters+1]=C(endpoint,"button_"..index,"button"..index.."Up","button"..index.."Down",bT.."_action",action)
end
if q==aP then
q.zcl_clusters[#q.zcl_clusters+1]=C(8,"doorbell_button","doorbellButton",nil,bT.."_action",action)
end
q.zcl_clusters[#q.zcl_clusters+1]=j.cluster_attribute(6,65535,{
name=bT.."_doorbell",component="main",write_only=true,suppress_optimistic_state=true,
emit=bw[4],sender=function(a)
local bk=j.get_generated_cluster(6).commands.On(a):to_endpoint(6)bk.body.zcl_header.frame_ctrl:set_disable_default_response()a:send(bk)
end,
})z(q,{{2,"main"}},{{3,"socket"},{7,"light"}})
end
d(bB,{
e.create_fingerprint("TKHTechnology","SN3-1TB5-03/PW"),e.create_fingerprint("TKHTechnology","HNB-W-1TB5-03/PW"),})d(aP,{
e.create_fingerprint("TKHTechnology","SN3-1TB5K-03/PW"),e.create_fingerprint("TKHTechnology","HNB-W-1TB5K-03/PW"),})local bp={
[0]="hold",[1]="single",[2]="double",[3]="triple",[4]="quadruple",[255]="release",}local aC={
hold="held",single="pushed",double="double",triple="pushed_3x",quadruple="pushed_4x",release="up",}local aQ={
profile="buttons-third-reality-3rsb22bz",button_actions={"pushed","double","held","pushed_3x","pushed_4x","up"},button_count=1,zcl_clusters={
j.cluster_attribute(18,85,{
name="r3sb22bz_action",endpoint=1,read_only=true,
from_device=function(value)
if value==nil then return nil end
return bp[value]or"many"
end,
handler=function(a,action)
local J=g.r3sb22bzAction()(a,action)J.state_change=true
a:emit_component_event({id="main"},J)local az=aC[action]if az then
a:emit_component_event({id="main"},m.button.button(az,{state_change=true}))
end
end,
}),j.cluster_attribute(1,33,{
name="battery",endpoint=1,read_only=true,data_type=c.Uint8,minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true,emit=g.battery(),
from_device=function(value)
if value<255 then return value/2 end
end,
}),},
configure=function(w,a)
j.bind_cluster(a,1,w.environment_info.hub_zigbee_eui,1)
end,
parent_refresh=function(a)
j.read_attribute(a,1,33,1)j.read_attribute(a,1,32,1)return true
end,
}d(aQ,{
e.create_fingerprint("Third Reality, Inc","3RSB22BZ"),})
local function aY(y,a,bj)
local A,command=bj.cluster_id,bj.command_id
local cH=y.body.zcl_header.seqno.value
local bR=tostring(A)..":"..tostring(command)..":"..tostring(cH)
if a:get_field("__sunricher_cct_last_command")==bR then return end
a:set_field("__sunricher_cct_last_command",bR)local action,p,az=nil,"main","pushed"
if A==6 then
action=({[0]="off",[1]="on",[2]="toggle",[64]="off"})[command]p=action=="off"and"offButton"or"main"
elseif A==8 or A==768 then
local au=i(y,"step_mode","stepmode")local up=A==8 and au~=1 or A==768 and au==1
action=(A==8 and"brightness_step_"or"color_temperature_step_")..(up and"up"or"down")p=(A==8 and"brightness"or"temperature")..(up and"Up"or"Down")local cj=i(y,"step_size","stepsize")if cj~=nil then
a:emit_event(g.srCctStepSize()(a,cj))if A==768 then
a:emit_event(g.srCctTemperatureDelta()(a,up and cj or-cj))
end
end
local bC=i(y,"transition_time","transtime")
if bC~=nil then a:emit_event(g.srCctTransitionTime()(a,bC/10))end
elseif A==5 then
local bN=i(y,"scene_id","sceneid")
if bN==nil then return end
action=(command==4 and"store_"or"recall_")..tostring(bN)p=bN==1 and"sceneOne"or bN==2 and"sceneTwo"or nil
az=command==4 and"held"or"pushed"
end
local J=g.srCctAction()(a,action)J.state_change=true
a:emit_event(J)if p then
a:emit_component_event({id=p},m.button.button(az,{state_change=true}))
end
local ch=y.address_header.dest_addr.value
if ch>=1 and ch<=65527 then a:emit_event(g.srCctGroup()(a,ch))end
end
local av={
profile="buttons-sunricher-cct",button_actions={"pushed","held"},placeholder_custom_states=false,zcl_clusters={
j.cluster_attribute(1,33,{
name="battery",endpoint=1,read_only=true,data_type=c.Uint8,minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true,
emit=g.battery(),from_device=function(value)if value<255 then return value/2 end end,
}),},
configure=function(w,a)
for _,A in ipairs({1,6,8,768,5})do
j.bind_cluster(a,A,w.environment_info.hub_zigbee_eui,1)
end
end,
parent_refresh=function(a)j.read_attribute(a,1,33,1)end,
}for _,item in ipairs({{6,0},{6,1},{6,2},{6,64},{8,2},{8,6},{768,76},{5,4},{5,5}})do
av.zcl_clusters[#av.zcl_clusters+1]=j.cluster_attribute(item[1],nil,{
name="sr_cct_action",endpoint=1,read_only=true,command_id=item[2],command_extractor=aY,})
end
d(av,{e.create_fingerprint("Sunricher","ZGRC-KEY-008")})
local function ag(a)
local bk=N.write_attribute(a,c.ClusterId(64512),c.AttributeId(16),c.Uint32(os.time()-946684800))a:send(bk:to_endpoint(10))return true
end
local H={
{4200,200},{4180,196},{4160,192},{4140,188},{4120,184},{4100,180},{4080,176},{4060,171},{4040,166},{4020,160},{4000,154},{3980,148},{3960,142},{3940,135},{3920,128},{3900,120},{3880,112},{3860,104},{3840,96},{3820,88},{3800,80},{3780,72},{3760,64},{3740,56},{3720,48},{3700,40},{3680,32},{3660,25},{3640,19},{3620,14},{3600,10},{3580,7},{3560,5},{3540,3},{3520,2},{3500,1},{3400,0},}
local function bv(value)
if value<2500 or value>4400 then return nil end
if value>=4200 then return 100 end
for index=2,#H do
local co,ca=H[index-1],H[index]if value>=ca[1]then
return(ca[2]+math.floor(((value-ca[1])*(co[2]-ca[2])+math.floor((co[1]-ca[1])/2))/(co[1]-ca[1])))/2
end
end
return 0
end
local function ap(value,a,al)
if value<=0 or value>=0xFFFFFFFF then return"—"end
local bA=a:get_field("airwick_timezone_minutes")or 180
for _,aa in ipairs(al.zb_rx.body.zcl_body.attr_records or{})do
if aa.attr_id.value==6 and aa.data then bA=aa.data.value end
end
return os.date("!%d.%m.%Y %H:%M",value+946684800+bA*60)
end
local function aw(value)
if value<0 or value>1439 then return"—"end
return string.format("%02d:%02d",math.floor(value/60),value%60)
end
local function ah(value)
local cp,cm=value:match("^%s*(%d%d?):(%d%d)%s*$")
if cp==nil or tonumber(cp)>23 or tonumber(cm)>59 then return nil end
return tonumber(cp)*60+tonumber(cm)
end
local function n(o,ba,am,aH,G)
G=G or{}G.name=ba;G.endpoint=10;G.emit=am;G.data_type=aH
G.read_on_configure=not G.write_only
G.prefer_plain_attribute_write=true
return j.cluster_attribute(64512,o,G)
end
local bE={
profile="controllers-airwick",magic_packet=false,placeholder_custom_states=false,component_to_endpoint_map={main=10},
configure=function(w,a)
j.bind_cluster(a,64512,w.environment_info.hub_zigbee_eui,10)ag(a)
end,
runtime_start=function(a)
a.thread:call_with_delay(0.8,function()ag(a)end)
end,
announce_handler=function(a)
a.thread:call_with_delay(1.2,function()ag(a)end)
end,
capability_commands={
{capability_id="concertmirror08464.airwickSpray",command_name="spray",value=true,mapping_name="airwick_spray"},{capability_id="concertmirror08464.airwickResetCounter",command_name="reset",value=true,mapping_name="airwick_reset_counter"},},zcl_clusters={
n(0,"airwick_mode",function(a,value)
return{g.airwickMode()(a,value),g.airwickScheduleInfo()(a,"Mon–Fri 07:00–22:00; Sat–Sun 09:00–22:00; every 30 min; duration is configured separately")}
end,c.Enum8,{read_only=true,minimum_interval=0,maximum_interval=3600,
from_device=function(value)return({[0]="OFF","AUTO","SCHEDULE","PROGRAMMABLE"})[value]or"UNKNOWN"end}),
n(1,"airwick_auto_interval",g.airwickAutoInterval(),c.Uint16),n(6,"airwick_time_zone",g.airwickTimeZone(),c.Int16,{scale=60,
from_device=function(value,a)a:set_field("airwick_timezone_minutes",value*60,{persist=true});return value end}),
n(7,"airwick_spray_count",g.airwickSprayCount(),c.Uint32,{read_only=true,minimum_interval=0,maximum_interval=3600,reportable_change=1}),n(8,"airwick_last_reason",g.airwickLastReason(),c.Uint8,{read_only=true,minimum_interval=0,maximum_interval=3600,reportable_change=1,
from_device=function(value)return({[0]="None","Zigbee","Button","AUTO","SCHEDULE","PROGRAM"})[value]end}),
n(9,"airwick_last_spray",g.airwickLastSpray(),c.UtcTime,{read_only=true,minimum_interval=0,maximum_interval=3600,reportable_change=1,from_device=ap}),n(10,"airwick_next_spray",g.airwickNextSpray(),c.UtcTime,{read_only=true,minimum_interval=0,maximum_interval=3600,reportable_change=1,from_device=ap}),n(11,"airwick_time_valid",g.airwickTimeValid(),c.Boolean,
{read_only=true,minimum_interval=0,maximum_interval=3600,from_device=function(value,a)
if not value and os.time()-(a:get_field("airwick_last_sync_attempt")or 0)>=60 then
a:set_field("airwick_last_sync_attempt",os.time());ag(a)
end
return value and"ON"or"OFF"
end}),
n(14,"airwick_reset_counter",nil,c.Boolean,{write_only=true,
sender=function(a)
a:send(N.write_attribute(a,c.ClusterId(64512),c.AttributeId(14),c.Boolean(true)):to_endpoint(10))a:emit_component_event({id="main"},g.airwickSprayCount()(a,0))return true
end}),
n(17,"airwick_battery_level",function(a,value)
local bQ={g.voltage()(a,value/1000)}local cr=bv(value)
if cr then bQ[#bQ+1]=g.airwickBatteryLevel()(a,cr)end
return bQ
end,c.Uint16,{read_only=true,minimum_interval=30,maximum_interval=3600,reportable_change=10}),
n(18,"airwick_duration",g.airwickDuration(),c.Uint16),j.cluster_attribute(6,nil,{name="airwick_spray",endpoint=10,write_only=true,
sender=function(a)return j.send_raw_cluster_command(a,6,1,"",10)end}),
},}for index,day in ipairs({"Mon","Tue","Wed","Thu","Fri","Sat","Sun"})do
local cA=32+(index-1)*8
for _,item in ipairs({
{0,"Enabled",c.Boolean,
function(value)return value and"ON"or"OFF"end,
function(value)return value=="ON"end},
{2,"Start",c.Uint16,aw,ah},{3,"End",c.Uint16,aw,ah},{4,"Interval",c.Uint16},})do
bE.zcl_clusters[#bE.zcl_clusters+1]=n(cA+item[1],"airwick_"..day:lower().."_"..item[2]:lower(),g["airwick"..day..item[2]](),item[3],{from_device=item[4],to_device=item[5]})
end
end
d(bE,{e.create_fingerprint("DIY","AirWick_nRF52840")})local bK={[0]="zigbee",[2]="keypad",[3]="fingerprintsensor",[4]="rfid",[5]="unattributed",[10]="self"}local bO={
LastLockUser=g.nimlyCodeLastLockUser(),LastUnlockUser=g.nimlyCodeLastUnlockUser(),LastLockSource=g.nimlyCodeLastLockSource(),LastUnlockSource=g.nimlyCodeLastUnlockSource(),Action=g.nimlyCodeAction(),ActionUser=g.nimlyCodeActionUser(),ActionSource=g.nimlyCodeActionSource(),EventSource=g.nimlyCodeEventSource(),Pin=g.nimlyCodePin(),}
local function r(a,ba,value)
local J=bO[ba](a,value)
if J then J.state_change=true;a:emit_component_event({id="main"},J)end
end
local function bS(value,a)
local bh=bK[(value>>24)&255]or"unknown"
local action=({[1]="Lock",[2]="Unlock"})[(value>>16)&255]
if not action then return end
local bV=value&65535
r(a,"Last"..action.."User",tostring(bV))r(a,"Last"..action.."Source",bh)r(a,"Action",action:lower());r(a,"ActionUser",bV)r(a,"ActionSource",bh)
end
local function bs(value,a,al)
local cb=a:get_field("nimly_min_pin_length")or 4
for _,aa in ipairs(al.zb_rx.body.zcl_body.attr_records or{})do
if aa.attr_id.value==24 and aa.data and aa.data.value>0 then cb=aa.data.value end
end
value=value:gsub("%z+$","")
if #value>=cb and value:match("^%d+$")then return value end
local bP={}for index=1,#value do
local cd=value:byte(index)if cd>>4>9 or cd&15>9 then
return(value:gsub(".",function(cl)return string.format("%02x",cl:byte())end))
end
bP[#bP+1]=tostring(cd>>4)..tostring(cd&15)
end
return table.concat(bP)
end
local function bz(a,_,value)
local x=cC.decode(value)
if type(x)~="table"or type(x.user)~="number"or x.user%1~=0 or x.user<0 or x.user>=50 then return false end
local payload=string.pack("<I2",x.user)local command=7
if x.pin_code~=nil then
local pin=tostring(x.pin_code)
if not pin:match("^%d+$")then return false end
local bJ=({unrestricted=0,year_day_schedule=1,week_day_schedule=2,master=3,non_access=4})[x.user_type or"unrestricted"]
if not bJ then return false end
command=5;payload=payload..string.char(x.user_enabled==false and 3 or 1,bJ,#pin)..pin
end
a:set_field("nimly_pending_pin_user",x.user)a:set_field("nimly_pending_pin_value",value)return j.send_raw_cluster_command(a,257,command,payload,11)
end
local function bg(command)
return function(rx,a)
local bV=a:get_field("nimly_pending_pin_user")local value=a:get_field("nimly_pending_pin_value")a:set_field("nimly_pending_pin_user",nil);a:set_field("nimly_pending_pin_value",nil)
if i(rx,"status")~=0 then return end
r(a,"Action",command==5 and"pin_code_added"or"pin_code_deleted")
if bV~=nil then r(a,"ActionUser",bV)end
if value then r(a,"Pin",value)end
end
end
local aB={
[0]="unknown","lock","unlock","lock_failure_invalid_pin_or_id","lock_failure_invalid_schedule","unlock_failure_invalid_pin_or_id","unlock_failure_invalid_schedule","one_touch_lock","key_lock","key_unlock","auto_lock","schedule_lock","schedule_unlock","manual_lock","manual_unlock","non_access_user_operational_event",}local aS={[0]="unknown","master_code_changed","pin_code_added","pin_code_deleted","pin_code_changed","rfid_code_added","rfid_code_deleted"}
local function bf(aM)
return function(rx,a)
local bh=i(rx,aM and"program_event_source"or"operation_event_source")local cB=i(rx,aM and"program_event_code"or"operation_event_code")r(a,"Action",(aM and aS or aB)[cB])r(a,"ActionUser",i(rx,"user_id"))r(a,"EventSource",bh)r(a,"ActionSource",({[0]="keypad","rf","manual","rfid","fingerprint"})[bh])
end
end
local ai={
profile="locks-nimly-code-pro",magic_packet=false,placeholder_custom_states=false,component_to_endpoint_map={main=11},capability_commands={
{capability_id="lock",command_name="lock",value=1,mapping_name="nimly_lock"},{capability_id="lock",command_name="unlock",value=0,mapping_name="nimly_lock"},},
configure=function(w,a)
for _,A in ipairs({257,1})do j.bind_cluster(a,A,w.environment_info.hub_zigbee_eui,11)end
end,
zcl_clusters={
j.cluster_attribute(257,0,{name="nimly_lock_state",endpoint=11,read_only=true,data_type=c.Enum8,minimum_interval=0,maximum_interval=3600,reportable_change=0,read_on_configure=true,
from_device=function(value)
value=type(value)=="table"and value.value or value
return({[0]="not fully locked","locked","unlocked"})[value]
end,
emit=function(_,value)return m.lock.lock(value)end}),
j.cluster_attribute(257,nil,{name="nimly_lock",endpoint=11,write_only=true,
sender=function(a,_,value)return j.send_raw_cluster_command(a,257,value==1 and 0 or 1,"\0",11)end}),
j.battery({endpoint=11,scale=1,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=false,
from_device=function(value)if value~=255 then return value end end}),
j.cluster_attribute(1,32,{name="nimly_voltage",endpoint=11,data_type=c.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=false,scale=10,emit=g.voltage()}),j.cluster_attribute(257,256,{name="nimly_code_action",endpoint=11,data_type=c.Uint32,read_only=true,
read_on_configure=false,handler=function(a,value)bS(value,a)end}),
j.cluster_attribute(257,257,{name="nimly_code_lastPin",endpoint=11,data_type=c.OctetString,read_only=true,read_on_configure=false,from_device=bs,emit=g.nimlyCodeLastPin()}),j.cluster_attribute(257,36,{name="nimly_code_sound_volume",endpoint=11,data_type=c.Uint8,read_on_configure=true,
from_device=function(value)
value=type(value)=="table"and value.value or value
return({[0]="silent_mode","low_volume","high_volume"})[value]
end,
to_device=function(value)return({silent_mode=0,low_volume=1,high_volume=2})[value]end,emit=g.nimlyCodeSoundVolume()}),
j.cluster_attribute(257,35,{name="nimly_code_auto_relock",endpoint=11,data_type=c.Uint32,read_on_configure=true,
from_device=function(value)return value==0 and"OFF"or"ON"end,
to_device=function(value)return value=="ON"and 1 or 0 end,emit=g.nimlyCodeAutoRelock()}),
j.cluster_attribute(257,35,{name="nimly_code_relock_time",endpoint=11,data_type=c.Uint32,read_on_configure=true,emit=g.nimlyCodeRelockTime()}),j.cluster_attribute(257,nil,{name="nimly_code_pin",endpoint=11,write_only=true,suppress_optimistic_state=true,sender=bz}),},}for _,field in ipairs({{18,"PinCapacity",c.Uint16},{24,"MinPinLength",c.Uint8},{23,"MaxPinLength",c.Uint8}})do
ai.zcl_clusters[#ai.zcl_clusters+1]=j.cluster_attribute(257,field[1],{
name="nimly_code_"..field[2]:sub(1,1):lower()..field[2]:sub(2),endpoint=11,data_type=field[3],read_only=true,read_on_configure=true,
handler=field[1]==24 and function(a,value)if value>0 then a:set_field("nimly_min_pin_length",value)end end or nil,
emit=g["nimlyCode"..field[2]](),})
end
for _,command in ipairs({5,7,32,33})do
ai.zcl_clusters[#ai.zcl_clusters+1]=j.cluster_attribute(257,nil,{
name="nimly_response_"..command,endpoint=11,read_only=true,command_id=command,command_extractor=command<32 and bg(command)or bf(command==33),})
end
d(ai,{e.create_fingerprint("Onesti Products AS","NimlyCodePRO")})j.attach_reporting_capabilities(aq,{
{2,"rpt-aes"},{4,"rpt-tcpu"},{5,"rpt-cwf"},{7,"rpt-brz"},{8,"rpt-bzx"},{11,"rpt-bic"},{13,"rpt-sgys",{["zr000600003"]="Switch",["zr000600007"]="SwitchTwo"}},{14,"rpt-sbl",{["zr000600003"]="Switch",["zr000600007"]="SwitchTwo"}},{15,"rpt-zjz"},{16,"rpt-zny"},{18,"rpt-nnm"},})return{
id="zcl.controls.z2m_absorption",registrations=aq,}
