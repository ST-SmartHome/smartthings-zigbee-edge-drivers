local o=require"protocol.zcl"
local b=require"contracts.helpers.family"
local ah=require"contracts.helpers.zcl"
local aO=require"capabilities.events.all"
local h=require"st.capabilities"
local ak=require"st.zigbee.device_management"
local aF=require"st.zigbee.data_types"
local af,a=b.definition_registry()local z=5
local J=18
local A=57348
local aL=85
local l="__namron_simplify_pending_press"
local V={
pushed=h.button.button.pushed,double=h.button.button.double,held=h.button.button.held,up=h.button.button.up,down=h.button.button.down,up_hold=h.button.button.up_hold,down_hold=h.button.button.down_hold}local aV={
[0]="hold",[1]="single",[2]="double",[3]="triple",[4]="quadruple",[5]="quintuple",[300]="N/A",[255]="release"}local ax={
single="pushed",double="double",hold="held"}
local function ab(aY)
if type(aY)~="number"then
return aY
end
local aX=math.floor((((aY-2.0)/1.0)*100)+0.5)if aX<0 then
return 0
end
if aX>100 then
return 100
end
return aX
end
local function P()
return o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_VOLTAGE,{
name="battery",endpoint=1,emit=aO.battery(),scale=10,from_device=ab,read_on_configure=true})
end
local function Z()
return o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_VOLTAGE,{
name="battery_voltage",endpoint=1,emit=aO.voltage(),scale=10})
end
local function W(y,_,aW)
if aW.raw_value~=255 then return y end
end
local function Y()
return o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_VOLTAGE,{
name="battery_voltage",endpoint=1,emit=aO.voltage(),scale=10,data_type=aF.Uint8,minimum_interval=3600,maximum_interval=7200,reportable_change=100,read_on_configure=true,read_only=true,from_device=W})
end
local function ay(k)
return k==1 and"main"or("button"..tostring(k))
end
local function aP(c,j,f)
local aK=ax[f]local aB=aK and V[aK]or nil
if aB==nil then
return
end
if type(c.supports_capability_by_id)=="function"and not c:supports_capability_by_id(h.button.ID,j)then
return
end
c:emit_component_event({id=j},aB{state_change=true})o.schedule_battery_refresh_after_button(c)
end
local function T(k)
local j=ay(k)return o.cluster_attribute(J,aL,{
name="remote_action",endpoint=k,component=j,emit=aO.remote_action(),
from_device=function(y)
local f=aV[y]if f==nil then
return nil
end
return f.."_"..tostring(k)
end,
handler=function(c,f)
if type(f)~="string"then
return
end
aP(c,j,f:match"^([^_]+)")
end
})
end
local function aa(bb,H)
for k=1,H do
bb[#bb+1]=T(k)
end
end
local function t(bi,ac)
return function(O,c)
for k=1,ac do
for _,i in ipairs(bi)do
c:send(ak.build_bind_request(
c,i,O.environment_info.hub_zigbee_eui,k))
end
end
end
end
local function m(ac)
return t({o.CLUSTER_ON_OFF},ac)
end
local function p(C,...)
local ba=C and C.body and C.body.zcl_body or nil
if type(ba)~="table"then
return nil
end
for _,bv in ipairs{...}do
local y=ba[bv]if type(y)=="table"and y.value~=nil then
return y.value
end
if y~=nil then
return y
end
end
return nil
end
local function w(q)
return q==1 and"main"or("button"..tostring(q))
end
local function aC(_,i,e)
if i~=o.CLUSTER_ON_OFF then
return nil,nil,true
end
local f=({
[2]="single",[1]="double",[0]="long"})[e]return f,"main",true
end
local function aD(C,i,e,d)
if type(d)~="number"or d<1 or d>4 then
return nil,nil,true
end
local f
if i==o.CLUSTER_ON_OFF then
f=({
[1]="on",[0]="off"})[e]elseif i==o.CLUSTER_LEVEL_CONTROL then
if e==1 or e==5 then
local aZ=p(C,"move_mode","movemode","mode")f=aZ==0 and"brightness_move_up"or aZ==1 and"brightness_move_down"or nil
elseif e==3 or e==7 then
f="brightness_stop"
end
end
if f==nil then
return nil,nil,true
end
return f.."_l"..tostring(d),w(d),true
end
local function X(C,i,e,d,c)
if i~=A or e~=0 or d~=1 then
return nil,nil,true
end
local ba=C and C.body and C.body.zcl_body or nil
local M=type(ba)=="table"and ba.body_bytes or nil
if type(M)~="string"or #M<2 then
return nil,nil,true
end
local u=string.byte(M,#M-1)local aH=string.byte(M,#M)if u==nil or u<1 or u>6 then
return nil,nil,true
end
local by=math.floor((u+1)/2)local aN=u%2==1 and"up"or"down"
local j=w(by)if aH==0 then
if type(c)=="table"and type(c.set_field)=="function"then
c:set_field(l,u,{persist=false})
end
return aN.."_press",j,true
end
if aH==1 then
local ai=type(c)=="table"and type(c.get_field)=="function"and
c:get_field(l)or nil
if ai==u and type(c)=="table"and type(c.set_field)=="function"then
c:set_field(l,nil,{persist=false})
end
if ai==u then
return nil,j,true
end
if ai~=nil then
if type(c)=="table"and type(c.set_field)=="function"then
c:set_field(l,nil,{persist=false})
end
return nil,j,true
end
return aN.."_press",j,true
end
if aH==2 then
if type(c)=="table"and type(c.set_field)=="function"then
c:set_field(l,nil,{persist=false})
end
return aN.."_hold",j,true
end
return nil,j,true
end
local function s(c,rx,bl)
bl=bl or"__shelly_blu_transactions"
local bd=rx.body.zcl_header
if bd.frame_ctrl:is_mfg_specific_set()or bd.frame_ctrl:is_direction_set()then return true end
local k,bs=rx.address_header.src_endpoint.value,bd.seqno.value
if ah.duplicate_transaction(c,k,bs,bl)then return true end
c:set_field("__zcl_last_remote_action",nil,{persist=false})return false
end
local function aj(rx,i,e,d,c)
local ar={
[1]="single",[2]="double",[3]="triple"}if i==o.CLUSTER_ON_OFF and e==2 then
if c and s(c,rx)then return nil,nil,true end
return ar[d],"main",true
end
if i==z and e==5 then
if c and s(c,rx)then return nil,nil,true end
local f=ar[d]return f and(f.."_long")or nil,"main",true
end
return nil,nil,true
end
local function ad(rx,i,e,_,c)
local f
if i==o.CLUSTER_ON_OFF then
f=({[0]="off",[1]="on",[2]="toggle",[64]="off"})[e]elseif i==o.CLUSTER_LEVEL_CONTROL then
if e==0 or e==4 then f="brightness_move_to_level"
elseif e==1 or e==5 then
f=p(rx,"move_mode","movemode")==1 and"brightness_move_down"or"brightness_move_up"
elseif e==2 or e==6 then
f=p(rx,"step_mode","stepmode")==1 and"brightness_step_down"or"brightness_step_up"
elseif e==3 or e==7 then f="brightness_stop"end
end
if f and s(c,rx)then return nil,nil,true end
return f,nil,true
end
local function al(C,i,e,d)
local q
local action_suffix
if i==o.CLUSTER_ON_OFF then
if e==1 then
q=d==1 and 1 or d==2 and 3 or nil
elseif e==0 then
q=d==1 and 2 or d==2 and 4 or nil
elseif e==2 and d~=nil and d>=1 and d<=4 then
q=d
end
action_suffix="single"
elseif i==o.CLUSTER_LEVEL_CONTROL and(e==2 or e==6)then
local av=p(C,"step_mode","stepmode","mode")if d==1 then
q=av==0 and 1 or av==1 and 2 or nil
elseif d==2 then
q=av==0 and 3 or av==1 and 4 or nil
end
action_suffix="hold"
elseif i==z and e==5 then
local aS=p(C,"sceneid","scene_id")if d~=nil and d>=1 and d<=4 then
q=d
end
action_suffix=({
[1]="double",[2]="triple",[11]="single_long",[12]="double_long",[13]="triple_long"})[aS]
end
if q==nil or action_suffix==nil then
return nil,nil,true
end
return tostring(q).."_"..action_suffix,w(q),true
end
local function aq(C,i,e,d)
if d~=2 then
return nil,nil,true
end
if i==o.CLUSTER_ON_OFF then
return({
[1]="input_1_on",[0]="input_1_off",[2]="input_1_toggle"})[e],"main",true
end
if i==z and e==5 then
local aS=p(C,"sceneid","scene_id")return({
[1]="input_1_single",[2]="input_1_double",[3]="input_1_triple",[4]="input_1_hold",[5]="input_1_toggle",[11]="input_1_hold"})[aS],"main",true
end
return nil,nil,true
end
local function r(aE,H,bk)
local x={
profile=aE,button_actions=bk and bk.button_actions or{"pushed","double","held"},advanced_remote=true,button_count=H,zcl_initial_writes={
{name="operation_mode",value="event"}},zcl_clusters={
o.tuya_magic_packet(),o.battery(),P(),o.operation_mode()}}for bv,y in pairs(bk or{})do
x[bv]=y
end
return x
end
local function g(aE,H,am)
local x={
profile=aE,button_actions=am and am.button_actions or{"pushed","double","held"},advanced_remote=true,button_count=H,standard_action_endpoint_suffix=am and am.standard_action_endpoint_suffix==true,zcl_clusters={
o.tuya_magic_packet(),o.battery(),P()}}if am and am.slacky_multistate==true then
aa(x.zcl_clusters,H)
end
return x
end
local be=r("buttons-button-1-battery-operation-mode-remote-action",1,{
unprefixed_remote_actions=true})local aI=r("buttons-button-4-battery-voltage-operation-mode-remote-action",4)aI.zcl_clusters[#aI.zcl_clusters+1]=Z()local bf=r("buttons-button-6-battery-operation-mode-remote-action",6)local aU=r("buttons-button-4-battery-operation-mode-remote-action",4)local aR=r("buttons-button-1-battery-operation-mode-remote-action",1,{
knob_remote=true})
local function aJ(c,j,f,C)
if not c:supports_capability_by_id(h.knob.ID,j)then
return
end
local ap=p(C,"step_size","stepsize")local aw=p(C,"transition_time","transtime")local ae={id=j}local an={state_change=true}if f=="brightness_step_up"or f=="brightness_step_down"then
if type(ap)=="number"then
c:emit_component_event(ae,h["concertmirror08464.tsfKnobStep"].stepSize(ap,an))c:emit_component_event(ae,h["concertmirror08464.tsfKnobBrightnessDelta"].brightnessDelta(
f=="brightness_step_up"and ap or-ap,an))
end
elseif f=="color_temperature_step_up"or f=="color_temperature_step_down"then
if type(ap)=="number"then
c:emit_component_event(ae,h["concertmirror08464.tsfKnobColorDelta"].colorDelta(
{value=f=="color_temperature_step_up"and ap or-ap,unit="mired"},an))
end
elseif f=="hue_move"or f=="hue_down"or f=="hue_stop"then
local bx=p(C,"rate")if type(bx)=="number"then
c:emit_component_event(ae,h["concertmirror08464.tsfKnobRate"].rate(bx,an))
end
end
if type(aw)=="number"then
c:emit_component_event(ae,h["concertmirror08464.tsfKnobTransition"].transitionTime(
{value=aw/10,unit="s"},an))
end
local az=c.preferences or{}local ag=h.knob.rotateAmount
local G
if f=="rotate_left"or f=="rotate_right"then
G=tonumber(az.knobEventStep)or 5
if f=="rotate_left"then G=-G end
elseif f=="brightness_step_up"or f=="brightness_step_down"then
if type(ap)~="number"then return end
G=ap*100/255
if f=="brightness_step_down"then G=-G end
elseif f=="color_temperature_step_up"or f=="color_temperature_step_down"then
if type(ap)~="number"then return end
ag=h.knob.heldRotateAmount
G=ap/(tonumber(az.knobHeldMiredsPerPercent)or 10)
if f=="color_temperature_step_down"then G=-G end
else
return
end
local bu=({0.5,1,2})[tonumber(az["stse.knobSensitivity"])]or 1
local bB=G<0 and-1 or 1
if G==0 then return end
G=bB*math.max(1,math.min(100,math.floor(math.abs(G)*bu+0.5)))c:emit_component_event({id=j},ag(
{value=G,unit="%"},{state_change=true}))
end
local function U(y,c)
local bm=({[0]="command",[1]="event",command="command",event="event"})[y]
if bm==nil then return nil end
c:set_field("__ts004f_knob_mode",bm,{persist=true})local aG=bm=="event"
c:emit_event(h.button.supportedButtonValues(aG and{"pushed","double","held"}or{"pushed","held"}))c:emit_event(h.knob.supportedAttributes(aG and{"rotateAmount"}or{"rotateAmount","heldRotateAmount"}))c:emit_event(h["concertmirror08464.tsfKnobAction"].supportedActions(aG and{
"single","double","hold","rotate_left","rotate_right"}or{
"toggle","brightness_step_up","brightness_step_down","color_temperature_step_up","color_temperature_step_down","hue_move","hue_down","hue_stop"}))return bm
end
local aA=r("buttons-ts004f-knob",1,{
knob_remote=true,remote_action_handler=aJ,remote_action_emit_name="tsfKnobAction",standard_action_button_events={toggle="pushed",hue_move="held",hue_down="held"},
standard_command_action_resolver=function(_,i,e)
local bc={
[o.CLUSTER_ON_OFF]={[2]=true},[o.CLUSTER_LEVEL_CONTROL]={[2]=true},[o.CLUSTER_COLOR_CONTROL]={[1]=true,[71]=true,[76]=true}}return nil,nil,not(bc[i]and bc[i][e])
end,
runtime_start=function(c)
U(c:get_field"__ts004f_knob_mode"or"event",c)if c:get_latest_state("main",h.knob.ID,"rotateAmount")==nil then
c:emit_event(h.knob.rotateAmount({value=0,unit="%"},{state_change=false}))
end
if c:get_latest_state("main",h.knob.ID,"heldRotateAmount")==nil then
c:emit_event(h.knob.heldRotateAmount({value=0,unit="%"},{state_change=false}))
end
end
})aA.zcl_clusters[4]=o.operation_mode{
emit=aO.tsfKnobMode(),from_device=U,
to_device=function(y,c)
U(y,c)return({command=0,event=1})[y]
end
}local L=g("buttons-button-1-battery-remote-action",1,{
button_actions={"pushed","double"}})local as=g("buttons-button-1-battery-remote-action",1,{
slacky_multistate=true,standard_action_endpoint_suffix=true})local at=g("buttons-button-2-battery-remote-action",2,{
slacky_multistate=true,standard_action_endpoint_suffix=true})local au=g("buttons-button-4-battery-remote-action",4,{
slacky_multistate=true,standard_action_endpoint_suffix=true})local n=g("buttons-shelly-rc",4,{
button_actions={"up","down","up_hold","down_hold"}})local v=g("buttons-shelly-tough",1,{
button_actions={"pushed","double","pushed_3x","held"}})local B=g("buttons-button-4-battery-remote-action",4,{
button_actions={"pushed","double","pushed_3x","held"}})local ao={
profile="buttons-shelly-one-input",advanced_remote=true,button_count=1,button_actions={"pushed","double","pushed_3x","held"},unprefixed_remote_actions=true,standard_command_action_resolver=aq,standard_action_button_events={
input_1_single="pushed",input_1_double="double",input_1_triple="pushed_3x",input_1_hold="held"},zcl_clusters={
o.cluster_attribute(7,0,{
name="shelly_one_switch_type",endpoint=2,emit=aO.shellyOneSwitchType(),
from_device=function(y)return({[0]="toggle",[1]="momentary"})[y]end,
to_device=function(y)return({toggle=0,momentary=1})[y]end,
data_type=aF.Enum8,write_type=aF.Enum8,read_on_configure=true})}}
ao.configure=function(O,c)
for _,i in ipairs{o.CLUSTER_ON_OFF,z}do
c:send(ak.build_bind_request(
c,i,O.environment_info.hub_zigbee_eui,2))
end
end
local I=g("buttons-ewelink-button-1-battery-voltage-remote-action",1,{
button_actions={"pushed","double","held"}})local N=g("buttons-button-4-battery-remote-action",4,{
button_actions={"up","down","up_hold","down_hold"}})local D=g("buttons-button-3-battery",3,{
button_actions={"up","down","up_hold","down_hold"}})be.configure=m(1)aI.configure=m(4)bf.configure=m(6)aU.configure=m(1)aR.configure=m(1)aA.configure=m(1)L.configure=m(1)local E={
J,o.CLUSTER_ON_OFF,o.CLUSTER_LEVEL_CONTROL,o.CLUSTER_COLOR_CONTROL,z}as.configure=t(E,1)at.configure=t(E,2)au.configure=t(E,4)v.standard_command_action_resolver=aj
v.remote_action_emit_name="shellyToughAction"
v.standard_action_button_events={
single="pushed",double="double",triple="pushed_3x",single_long="held",double_long="held",triple_long="held"}
v.configure=function(O,c)
for _,k in pairs(c.zigbee_endpoints)do
for _,F in ipairs{o.CLUSTER_ON_OFF,z}do
o.bind_cluster(c,F,O.environment_info.hub_zigbee_eui,k.id)
end
end
end
B.zcl_clusters={o.battery()}B.standard_command_action_resolver=al
B.standard_action_button_events={
["1_single"]="pushed",["2_single"]="pushed",["3_single"]="pushed",["4_single"]="pushed",["1_double"]="double",["2_double"]="double",["3_double"]="double",["4_double"]="double",["1_triple"]="pushed_3x",["2_triple"]="pushed_3x",["3_triple"]="pushed_3x",["4_triple"]="pushed_3x",["1_hold"]="held",["2_hold"]="held",["3_hold"]="held",["4_hold"]="held",["1_single_long"]="held",["2_single_long"]="held",["3_single_long"]="held",["4_single_long"]="held"}B.configure=t({
o.CLUSTER_ON_OFF,o.CLUSTER_LEVEL_CONTROL,z},4)I.zcl_clusters={
o.battery{
endpoint=1,minimum_interval=3600,maximum_interval=7200,reportable_change=2,from_device=W},Y()}I.standard_command_action_resolver=aC
I.standard_action_button_events={
single="pushed",double="double",long="held"}I.configure=m(1)N.zcl_clusters={
o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_PERCENTAGE_REMAINING,{
name="battery",endpoint=1,emit=aO.battery(),scale=2})}N.standard_command_action_resolver=aD
N.standard_action_button_events={
on_l1="up",on_l2="up",on_l3="up",on_l4="up",off_l1="down",off_l2="down",off_l3="down",off_l4="down",brightness_move_up_l1="up_hold",brightness_move_up_l2="up_hold",brightness_move_up_l3="up_hold",brightness_move_up_l4="up_hold",brightness_move_down_l1="down_hold",brightness_move_down_l2="down_hold",brightness_move_down_l3="down_hold",brightness_move_down_l4="down_hold"}D.zcl_clusters={
o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_PERCENTAGE_REMAINING,{
name="battery",endpoint=1,emit=aO.battery(),scale=2})}D.standard_command_action_resolver=X
D.standard_action_button_events={
up_press="up",down_press="down",up_hold="up_hold",down_hold="down_hold"}
o.register_cluster_command_handler(A,0,function(c,bw,C)
if bw~=D then
return
end
local f,j=X(
C,A,0,1,c)local aM=f and D.standard_action_button_events[f]or nil
local aB=aM and V[aM]or nil
if type(aB)~="function"then
return
end
if type(c.supports_capability_by_id)=="function"and
not c:supports_capability_by_id(h.button.ID,j)then
return
end
c:emit_component_event({id=j},aB{state_change=true})o.schedule_battery_refresh_after_button(c)
end)
n.standard_command_action_resolver=ad
n.remote_action_emit_name="shellyRcAction"
n.standard_action_metadata_emit_names={
action_group="shellyRcGroup",action_level="shellyRcLevel",action_rate="shellyRcRate",action_step_size="shellyRcStep",action_transition_time="shellyRcTransition"}n.group_component_map={
[0]="main",[1]="button2",[2]="button3",[3]="button4"}n.standard_action_button_events={
on="up",off="down",brightness_step_up="up_hold",brightness_step_down="down_hold"}
n.configure=function(O,c)
for _,k in pairs(c.zigbee_endpoints)do
for _,F in ipairs(k.client_clusters or{})do
if F==o.CLUSTER_ON_OFF or F==o.CLUSTER_LEVEL_CONTROL then
o.bind_cluster(c,F,O.environment_info.hub_zigbee_eui,k.id)
end
end
end
for br=0,3 do
O:add_hub_to_zigbee_group(br)
end
end
local function Q(y,_,aW)
if aW.raw_value~=255 then return y end
end
local function K(aE,aT,S)
local aQ
if S>1 then
aQ={}
for k=1,S do aQ[w(k)]=k end
end
return{
profile=aE,advanced_remote=true,magic_packet=false,initial_custom_state_query=false,remote_action_emit_name=aT.."Action",standard_action_metadata_emit_names={action_group=aT.."Group"},component_to_endpoint_map=aQ,
standard_command_action_resolver=function(rx,F,bj,k,c)
if S>1 and(k<1 or k>S)then return nil,nil,true end
local f
if F==o.CLUSTER_ON_OFF then
f=({[0]="off",[1]="on",[2]="toggle",[64]="off"})[bj]elseif F==o.CLUSTER_WINDOW_COVERING then
f=({[0]="open",[1]="close",[2]="stop"})[bj]
end
if f and s(c,rx,"__somfy_ysia_transactions")then return nil,nil,true end
return f,S>1 and w(k)or"main",true
end,
configure=function(O,c)
for _,k in pairs(c.zigbee_endpoints)do
if S==1 or(k.id>=1 and k.id<=S)then
for _,F in ipairs(k.client_clusters or{})do
if F==o.CLUSTER_ON_OFF or F==o.CLUSTER_WINDOW_COVERING then
o.bind_cluster(c,F,O.environment_info.hub_zigbee_eui,k.id)
end
end
end
end
end,
parent_refresh=function(c)
for _,bo in ipairs{33,32}do
pcall(o.read_attribute,c,1,bo,c:get_endpoint(1))
end
end,
zcl_clusters={o.battery{read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=Q}}}
end
local bt=K("buttons-ysia-one","ysiaOne",1)local bp=K("buttons-ysia-five","ysiaFive",5)local bn=K("buttons-situo-four","situoFour",4)for _,bA in ipairs{
{n,"shellyRcIdentify","shelly_rc"},{v,"shellyToughIdentify","shelly_tough"}}do
local x,capability,aT=table.unpack(bA)local bh=aT.."_identify"
x.magic_packet,x.initial_custom_state_query=false,false
x.zcl_clusters={o.battery{read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=Q}}x.protocol_writers={[bh]=ah.identify}x.capability_commands={
{capability_id="concertmirror08464."..capability,command_name="identify",mapping_name=bh,value=3},{capability_id="concertmirror08464."..capability,command_name="setIdentifyTime",argument_name="identifyTime",mapping_name=bh}}
end
a(aU,b.create_fingerprints("TS004F",{
"_TZ3000_g9g2xnch","_TZ3000_pcqjmcud"}))a(aI,b.create_fingerprints("TS004F",{
"_TZ3000_nuombroo","_TZ3000_xabckq1v","_TZ3000_czuyt8lz","_TZ3000_0ht8dnxj","_TZ3000_b3mgfu0d","_TZ3000_11pg3ima","_TZ3000_et7afzxz","_TZ3000_pftj0i7z","_TZ3000_xffhmvhv"}))a(bf,b.create_fingerprints("TS004F",{
"_TZ3000_r0o2dahu"}))a(be,b.create_fingerprints("TS004F",{
"_TZ3000_kjfzuycl","_TZ3000_ja5osu5g","_TZ3000_egvb1p2g","_TZ3000_lrfvzq1e","_TZ3000_kaflzta4","_TZ3000_wc3gjyp3","HOBEIAN:ZG-101ZL"}))a(L,b.create_fingerprints("TS004F",{
"_TZ3000_rco1yzb1"}))a(as,{
b.create_fingerprint("Slacky-DIY","TS0041-M001-SlD"),b.create_fingerprint("Slacky-DIY","TS0041-M002-SlD"),b.create_fingerprint("Slacky-DIY","TS0041-M005-SlD")})a(at,{
b.create_fingerprint("Slacky-DIY","TS0042-z-SlD"),b.create_fingerprint("Slacky-DIY","TS0042-M003-SlD"),b.create_fingerprint("Slacky-DIY","TS0042-M006-SlD")})a(au,{
b.create_fingerprint("Slacky-DIY","TS0044-z-SlD"),b.create_fingerprint("Slacky-DIY","TS0044-M004-SlD")})a(n,{
b.create_fingerprint("Shelly","BLU Remote Control ZB")})a(v,{
b.create_fingerprint("Shelly","BLU Button Tough 1 ZB")})a(B,{
b.create_fingerprint("Shelly","BLU RC Button 4 ZB")})a(ao,{
b.create_fingerprint("Shelly","1")})a(I,{
b.create_fingerprint("eWeLink","CK-TLSR8656-SS5-01(7000)"),b.create_fingerprint("eWeLink","WB-01"),b.create_fingerprint("eWeLink","WB01"),b.create_fingerprint("eWeLink","SNZB-01"),b.create_fingerprint("SONOFF","CK-TLSR8656-SS5-01(7000)"),b.create_fingerprint("SONOFF","WB01"),b.create_fingerprint("SONOFF","WB-01"),b.create_fingerprint("SONOFF","SNZB-01")})a(N,{
b.create_fingerprint("Namron","4512772")})a(D,{
b.create_fingerprint("Namron AS","4512793")})a(aR,b.create_fingerprints("TS004F",{
"_TZ3000_qja6nq5z","_TZ3000_402vrq2i","_TZ3000_4fjiwweb","_TZ3000_uri7ongn","_TZ3000_ixla93vd","_TZ3000_csflgqj2","_TZ3000_abrsvsou","_TZ3000_ugi8ky6u"}))a(aA,b.create_fingerprints("TS004F",{
"_TZ3000_1fqpj6qz","_TZ3000_gwkzibhs"}))a(bt,{
b.create_fingerprint("SOMFY","Ysia 1 Zigbee Europe"),b.create_fingerprint("SOMFY","Ysia 1 HP Zigbee"),b.create_fingerprint("SOMFY","Situo 1 Zigbee")})a(bp,{b.create_fingerprint("SOMFY","Ysia 5 HP Zigbee")})a(bn,{b.create_fingerprint("SOMFY","Situo 4 Zigbee")})o.attach_reporting_capabilities(af,{
{1,"rpt-top"},{2,"rpt-tew"},{3,"rpt-toe"},{4,"rpt-tnc"},{5,"rpt-tfs"},{6,"rpt-tfs"},{7,"rpt-tyq"},{8,"rpt-tom"},{9,"rpt-bii"},{10,"rpt-biz"},{11,"rpt-tom"},{13,"rpt-chu"},{16,"rpt-tnc"},{17,"rpt-teb"},{18,"rpt-ybg"},{19,"rpt-yab"},{20,"rpt-snl"}})return{
id="zcl.controls.advanced",registrations=af}
