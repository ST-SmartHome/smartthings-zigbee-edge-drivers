local o=require"protocol.zcl"
local b=require"contracts.helpers.family"
local aF=require"capabilities.events.all"
local f=require"st.capabilities"
local D=require"st.zigbee.device_management"
local aw=require"st.zigbee.data_types"
local Y,a=b.definition_registry()local u=5
local H=18
local v=57348
local aC=85
local k="__namron_simplify_pending_press"
local P={
pushed=f.button.button.pushed,double=f.button.button.double,held=f.button.button.held,up=f.button.button.up,down=f.button.button.down,up_hold=f.button.button.up_hold,down_hold=f.button.button.down_hold,}local aK={
[0]="hold",[1]="single",[2]="double",[3]="triple",[4]="quadruple",[5]="quintuple",[300]="N/A",[255]="release",}local ap={
single="pushed",double="double",hold="held",}
local function V(aN)
if type(aN)~="number"then
return aN
end
local aL=math.floor((((aN-2.0)/1.0)*100)+0.5)if aL<0 then
return 0
end
if aL>100 then
return 100
end
return aL
end
local function L()
return o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_VOLTAGE,{
name="battery",endpoint=1,emit=aF.battery(),scale=10,from_device=V,read_on_configure=true,})
end
local function S()
return o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_VOLTAGE,{
name="battery_voltage",endpoint=1,emit=aF.voltage(),scale=10,})
end
local function R()
return o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_VOLTAGE,{
name="battery_voltage",endpoint=1,emit=aF.voltage(),scale=10,data_type=aw.Uint8,minimum_interval=3600,maximum_interval=7200,reportable_change=100,read_on_configure=true,read_only=true,})
end
local function aq(C)
return C==1 and"main"or("button"..tostring(C))
end
local function aG(d,j,h)
local aB=ap[h]local at=aB and P[aB]or nil
if at==nil then
return
end
if type(d.supports_capability_by_id)=="function"and not d:supports_capability_by_id(f.button.ID,j)then
return
end
d:emit_component_event({id=j},at({state_change=true}))o.schedule_battery_refresh_after_button(d)
end
local function N(C)
local j=aq(C)return o.cluster_attribute(H,aC,{
name="remote_action",endpoint=C,component=j,emit=aF.remote_action(),
from_device=function(z)
local h=aK[z]if h==nil then
return nil
end
return h.."_"..tostring(C)
end,
handler=function(d,h)
if type(h)~="string"then
return
end
aG(d,j,h:match("^([^_]+)"))
end,
})
end
local function U(aQ,E)
for C=1,E do
aQ[#aQ+1]=N(C)
end
end
local function n(aU,W)
return function(ae,d)
for C=1,W do
for _,i in ipairs(aU)do
d:send(D.build_bind_request(
d,i,ae.environment_info.hub_zigbee_eui,C))
end
end
end
end
local function l(W)
return n({o.CLUSTER_ON_OFF},W)
end
local function q(x,...)
local aP=x and x.body and x.body.zcl_body or nil
if type(aP)~="table"then
return nil
end
for _,aZ in ipairs({...})do
local z=aP[aZ]if type(z)=="table"and z.value~=nil then
return z.value
end
if z~=nil then
return z
end
end
return nil
end
local function G(m)
return m==1 and"main"or("button"..tostring(m))
end
local function au(_,i,g)
if i~=o.CLUSTER_ON_OFF then
return nil,nil,true
end
local h=({
[2]="single",[1]="double",[0]="long",})[g]return h,"main",true
end
local function av(x,i,g,c)
if type(c)~="number"or c<1 or c>4 then
return nil,nil,true
end
local h=nil
if i==o.CLUSTER_ON_OFF then
h=({
[1]="on",[0]="off",})[g]elseif i==o.CLUSTER_LEVEL_CONTROL then
if g==1 or g==5 then
local aO=q(x,"move_mode","movemode","mode")h=aO==0 and"brightness_move_up"or aO==1 and"brightness_move_down"or nil
elseif g==3 or g==7 then
h="brightness_stop"
end
end
if h==nil then
return nil,nil,true
end
return h.."_l"..tostring(c),G(c),true
end
local function Q(x,i,g,c,d)
if i~=v or g~=0 or c~=1 then
return nil,nil,true
end
local aP=x and x.body and x.body.zcl_body or nil
local J=type(aP)=="table"and aP.body_bytes or nil
if type(J)~="string"or #J<2 then
return nil,nil,true
end
local r=string.byte(J,#J-1)local ay=string.byte(J,#J)if r==nil or r<1 or r>6 then
return nil,nil,true
end
local bc=math.floor((r+1)/2)local aE=r%2==1 and"up"or"down"
local j=G(bc)if ay==0 then
if type(d)=="table"and type(d.set_field)=="function"then
d:set_field(k,r,{persist=false})
end
return aE.."_press",j,true
end
if ay==1 then
local aa=type(d)=="table"and type(d.get_field)=="function"and
d:get_field(k)or nil
if aa==r and type(d)=="table"and type(d.set_field)=="function"then
d:set_field(k,nil,{persist=false})
end
if aa==r then
return nil,j,true
end
if aa~=nil then
if type(d)=="table"and type(d.set_field)=="function"then
d:set_field(k,nil,{persist=false})
end
return nil,j,true
end
return aE.."_press",j,true
end
if ay==2 then
if type(d)=="table"and type(d.set_field)=="function"then
d:set_field(k,nil,{persist=false})
end
return aE.."_hold",j,true
end
return nil,j,true
end
local function ab(_,i,g,c)
local aj={
[1]="single",[2]="double",[3]="triple",}if i==o.CLUSTER_ON_OFF and g==2 then
return aj[c],"main",true
end
if i==u and g==5 then
local h=aj[c]return h and(h.."_long")or nil,"main",true
end
return nil,nil,true
end
local function ac(x,i,g,c)
local m=nil
local action_suffix=nil
if i==o.CLUSTER_ON_OFF then
if g==1 then
m=c==1 and 1 or c==2 and 3 or nil
elseif g==0 then
m=c==1 and 2 or c==2 and 4 or nil
elseif g==2 and c~=nil and c>=1 and c<=4 then
m=c
end
action_suffix="single"
elseif i==o.CLUSTER_LEVEL_CONTROL and(g==2 or g==6)then
local an=q(x,"step_mode","stepmode","mode")if c==1 then
m=an==0 and 1 or an==1 and 2 or nil
elseif c==2 then
m=an==0 and 3 or an==1 and 4 or nil
end
action_suffix="hold"
elseif i==u and g==5 then
local aI=q(x,"sceneid","scene_id")if c~=nil and c>=1 and c<=4 then
m=c
end
action_suffix=({
[1]="double",[2]="triple",[11]="single_long",[12]="double_long",[13]="triple_long",})[aI]
end
if m==nil or action_suffix==nil then
return nil,nil,true
end
return tostring(m).."_"..action_suffix,G(m),true
end
local function ai(x,i,g,c)
if c~=2 then
return nil,nil,true
end
if i==o.CLUSTER_ON_OFF then
return({
[1]="input_1_on",[0]="input_1_off",[2]="input_1_toggle",})[g],"main",true
end
if i==u and g==5 then
local aI=q(x,"sceneid","scene_id")return({
[1]="input_1_single",[2]="input_1_double",[3]="input_1_triple",[4]="input_1_hold",[5]="input_1_toggle",[11]="input_1_hold",})[aI],"main",true
end
return nil,nil,true
end
local function p(aM,E,aV)
local T={
profile=aM,button_actions=aV and aV.button_actions or{"pushed","double","held"},advanced_remote=true,button_count=E,zcl_initial_writes={
{name="operation_mode",value="event"},},zcl_clusters={
o.tuya_magic_packet(),o.battery(),L(),o.operation_mode(),},}for aZ,z in pairs(aV or{})do
T[aZ]=z
end
return T
end
local function e(aM,E,ad)
local T={
profile=aM,button_actions=ad and ad.button_actions or{"pushed","double","held"},advanced_remote=true,button_count=E,standard_action_endpoint_suffix=ad and ad.standard_action_endpoint_suffix==true,zcl_clusters={
o.tuya_magic_packet(),o.battery(),L(),},}if ad and ad.slacky_multistate==true then
U(T.zcl_clusters,E)
end
return T
end
local aS=p("buttons-button-1-battery-operation-mode-remote-action",1,{
unprefixed_remote_actions=true,})local az=p("buttons-button-4-battery-voltage-operation-mode-remote-action",4)az.zcl_clusters[#az.zcl_clusters+1]=S()local aT=p("buttons-button-6-battery-operation-mode-remote-action",6)local aJ=p("buttons-button-4-battery-operation-mode-remote-action",4)local aH=p("buttons-button-1-battery-operation-mode-remote-action",1,{
knob_remote=true,})
local function aA(d,j,h,x)
if not d:supports_capability_by_id(f.knob.ID,j)then
return
end
local ah=q(x,"step_size","stepsize")local ao=q(x,"transition_time","transtime")local X={id=j}local af={state_change=true}if h=="brightness_step_up"or h=="brightness_step_down"then
if type(ah)=="number"then
d:emit_component_event(X,f["concertmirror08464.tsfKnobStep"].stepSize(ah,af))d:emit_component_event(X,f["concertmirror08464.tsfKnobBrightnessDelta"].brightnessDelta(
h=="brightness_step_up"and ah or-ah,af))
end
elseif h=="color_temperature_step_up"or h=="color_temperature_step_down"then
if type(ah)=="number"then
d:emit_component_event(X,f["concertmirror08464.tsfKnobColorDelta"].colorDelta(
{value=h=="color_temperature_step_up"and ah or-ah,unit="mired"},af))
end
elseif h=="hue_move"or h=="hue_down"or h=="hue_stop"then
local bb=q(x,"rate")if type(bb)=="number"then
d:emit_component_event(X,f["concertmirror08464.tsfKnobRate"].rate(bb,af))
end
end
if type(ao)=="number"then
d:emit_component_event(X,f["concertmirror08464.tsfKnobTransition"].transitionTime(
{value=ao/10,unit="s"},af))
end
local ar=d.preferences or{}local Z=f.knob.rotateAmount
local B
if h=="rotate_left"or h=="rotate_right"then
B=tonumber(ar.knobEventStep)or 5
if h=="rotate_left"then B=-B end
elseif h=="brightness_step_up"or h=="brightness_step_down"then
if type(ah)~="number"then return end
B=ah*100/255
if h=="brightness_step_down"then B=-B end
elseif h=="color_temperature_step_up"or h=="color_temperature_step_down"then
if type(ah)~="number"then return end
Z=f.knob.heldRotateAmount
B=ah/(tonumber(ar.knobHeldMiredsPerPercent)or 10)
if h=="color_temperature_step_down"then B=-B end
else
return
end
local aY=({0.5,1,2})[tonumber(ar["stse.knobSensitivity"])]or 1
local bd=B<0 and-1 or 1
if B==0 then return end
B=bd*math.max(1,math.min(100,math.floor(math.abs(B)*aY+0.5)))d:emit_component_event({id=j},Z(
{value=B,unit="%"},{state_change=true}))
end
local function O(z,d)
local aW=({[0]="command",[1]="event",command="command",event="event"})[z]
if aW==nil then return nil end
d:set_field("__ts004f_knob_mode",aW,{persist=true})local ax=aW=="event"
d:emit_event(f.button.supportedButtonValues(ax and{"pushed","double","held"}or{"pushed","held"}))d:emit_event(f.knob.supportedAttributes(ax and{"rotateAmount"}or{"rotateAmount","heldRotateAmount"}))d:emit_event(f["concertmirror08464.tsfKnobAction"].supportedActions(ax and{
"single","double","hold","rotate_left","rotate_right",}or{
"toggle","brightness_step_up","brightness_step_down","color_temperature_step_up","color_temperature_step_down","hue_move","hue_down","hue_stop",}))return aW
end
local as=p("buttons-ts004f-knob",1,{
knob_remote=true,placeholder_custom_states=false,remote_action_handler=aA,remote_action_emit_name="tsfKnobAction",standard_action_button_events={toggle="pushed",hue_move="held",hue_down="held"},
standard_command_action_resolver=function(_,i,g)
local aR={
[o.CLUSTER_ON_OFF]={[2]=true},[o.CLUSTER_LEVEL_CONTROL]={[2]=true},[o.CLUSTER_COLOR_CONTROL]={[1]=true,[71]=true,[76]=true},}return nil,nil,not(aR[i]and aR[i][g])
end,
runtime_start=function(d)
O(d:get_field("__ts004f_knob_mode")or"event",d)if d:get_latest_state("main",f.knob.ID,"rotateAmount")==nil then
d:emit_event(f.knob.rotateAmount({value=0,unit="%"},{state_change=false}))
end
if d:get_latest_state("main",f.knob.ID,"heldRotateAmount")==nil then
d:emit_event(f.knob.heldRotateAmount({value=0,unit="%"},{state_change=false}))
end
end,
})as.zcl_clusters[4]=o.operation_mode({
emit=aF.tsfKnobMode(),from_device=O,
to_device=function(z,d)
O(z,d)return({command=0,event=1})[z]
end,
})local I=e("buttons-button-1-battery-remote-action",1,{
button_actions={"pushed","double"},})local ak=e("buttons-button-1-battery-remote-action",1,{
slacky_multistate=true,standard_action_endpoint_suffix=true,})local al=e("buttons-button-2-battery-remote-action",2,{
slacky_multistate=true,standard_action_endpoint_suffix=true,})local am=e("buttons-button-4-battery-remote-action",4,{
slacky_multistate=true,standard_action_endpoint_suffix=true,})local s=e("buttons-button-4-battery-remote-action",4,{
button_actions={"up","down","up_hold","down_hold"},})local t=e("buttons-button-1-battery-remote-action",1,{
button_actions={"pushed","double","pushed_3x","held"},})local w=e("buttons-button-4-battery-remote-action",4,{
button_actions={"pushed","double","pushed_3x","held"},})local ag={
profile="buttons-shelly-one-input",advanced_remote=true,button_count=1,button_actions={"pushed","double","pushed_3x","held"},unprefixed_remote_actions=true,standard_command_action_resolver=ai,standard_action_button_events={
input_1_single="pushed",input_1_double="double",input_1_triple="pushed_3x",input_1_hold="held",},zcl_clusters={
o.cluster_attribute(7,0,{
name="shelly_one_switch_type",endpoint=2,emit=aF.shellyOneSwitchType(),
from_device=function(z)return({[0]="toggle",[1]="momentary"})[z]end,
to_device=function(z)return({toggle=0,momentary=1})[z]end,
data_type=aw.Enum8,write_type=aw.Enum8,read_on_configure=true,}),},}
ag.configure=function(ae,d)
for _,i in ipairs({o.CLUSTER_ON_OFF,u})do
d:send(D.build_bind_request(
d,i,ae.environment_info.hub_zigbee_eui,2))
end
end
local F=e("buttons-ewelink-button-1-battery-voltage-remote-action",1,{
button_actions={"pushed","double","held"},})local K=e("buttons-button-4-battery-remote-action",4,{
button_actions={"up","down","up_hold","down_hold"},})local y=e("buttons-button-3-battery",3,{
button_actions={"up","down","up_hold","down_hold"},})aS.configure=l(1)az.configure=l(4)aT.configure=l(6)aJ.configure=l(1)aH.configure=l(1)as.configure=l(1)I.configure=l(1)local A={
H,o.CLUSTER_ON_OFF,o.CLUSTER_LEVEL_CONTROL,o.CLUSTER_COLOR_CONTROL,u,}ak.configure=n(A,1)al.configure=n(A,2)am.configure=n(A,4)t.zcl_clusters={o.battery()}t.standard_command_action_resolver=ab
t.standard_action_button_events={
single="pushed",double="double",triple="pushed_3x",single_long="held",}t.configure=n({
o.CLUSTER_ON_OFF,u,},3)w.zcl_clusters={o.battery()}w.standard_command_action_resolver=ac
w.standard_action_button_events={
["1_single"]="pushed",["2_single"]="pushed",["3_single"]="pushed",["4_single"]="pushed",["1_double"]="double",["2_double"]="double",["3_double"]="double",["4_double"]="double",["1_triple"]="pushed_3x",["2_triple"]="pushed_3x",["3_triple"]="pushed_3x",["4_triple"]="pushed_3x",["1_hold"]="held",["2_hold"]="held",["3_hold"]="held",["4_hold"]="held",["1_single_long"]="held",["2_single_long"]="held",["3_single_long"]="held",["4_single_long"]="held",}w.configure=n({
o.CLUSTER_ON_OFF,o.CLUSTER_LEVEL_CONTROL,u,},4)F.zcl_clusters={
o.battery({
endpoint=1,minimum_interval=3600,maximum_interval=7200,reportable_change=2,}),R(),}F.standard_command_action_resolver=au
F.standard_action_button_events={
single="pushed",double="double",long="held",}F.configure=l(1)K.zcl_clusters={
o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_PERCENTAGE_REMAINING,{
name="battery",endpoint=1,emit=aF.battery(),scale=2,}),}K.standard_command_action_resolver=av
K.standard_action_button_events={
on_l1="up",on_l2="up",on_l3="up",on_l4="up",off_l1="down",off_l2="down",off_l3="down",off_l4="down",brightness_move_up_l1="up_hold",brightness_move_up_l2="up_hold",brightness_move_up_l3="up_hold",brightness_move_up_l4="up_hold",brightness_move_down_l1="down_hold",brightness_move_down_l2="down_hold",brightness_move_down_l3="down_hold",brightness_move_down_l4="down_hold",}y.zcl_clusters={
o.cluster_attribute(o.CLUSTER_POWER_CONFIGURATION,o.ATTR_BATTERY_PERCENTAGE_REMAINING,{
name="battery",endpoint=1,emit=aF.battery(),scale=2,}),}y.standard_command_action_resolver=Q
y.standard_action_button_events={
up_press="up",down_press="down",up_hold="up_hold",down_hold="down_hold",}
o.register_cluster_command_handler(v,0,function(d,ba,x)
if ba~=y then
return
end
local h,j=Q(
x,v,0,1,d)local aD=h and y.standard_action_button_events[h]or nil
local at=aD and P[aD]or nil
if type(at)~="function"then
return
end
if type(d.supports_capability_by_id)=="function"and
not d:supports_capability_by_id(f.button.ID,j)then
return
end
d:emit_component_event({id=j},at({state_change=true}))o.schedule_battery_refresh_after_button(d)
end)
s.zcl_clusters={
o.battery(),}s.group_component_map={
[0]="main",[1]="button2",[2]="button3",[3]="button4",}s.standard_action_button_events={
on="up",off="down",brightness_step_up="up_hold",brightness_step_down="down_hold",}
s.configure=function(ae,d)
d:send(D.build_bind_request(
d,o.CLUSTER_ON_OFF,ae.environment_info.hub_zigbee_eui))d:send(D.build_bind_request(
d,o.CLUSTER_LEVEL_CONTROL,ae.environment_info.hub_zigbee_eui))for aX=0,3 do
ae:add_hub_to_zigbee_group(aX)
end
end
a(aJ,b.create_fingerprints("TS004F",{
"_TZ3000_g9g2xnch","_TZ3000_pcqjmcud",}))a(az,b.create_fingerprints("TS004F",{
"_TZ3000_nuombroo","_TZ3000_xabckq1v","_TZ3000_czuyt8lz","_TZ3000_0ht8dnxj","_TZ3000_b3mgfu0d","_TZ3000_11pg3ima","_TZ3000_et7afzxz","_TZ3000_pftj0i7z","_TZ3000_xffhmvhv",}))a(aT,b.create_fingerprints("TS004F",{
"_TZ3000_r0o2dahu",}))a(aS,b.create_fingerprints("TS004F",{
"_TZ3000_kjfzuycl","_TZ3000_ja5osu5g","_TZ3000_egvb1p2g","_TZ3000_lrfvzq1e","_TZ3000_kaflzta4","_TZ3000_wc3gjyp3","HOBEIAN:ZG-101ZL",}))a(I,b.create_fingerprints("TS004F",{
"_TZ3000_rco1yzb1",}))a(ak,{
b.create_fingerprint("Slacky-DIY","TS0041-M001-SlD"),b.create_fingerprint("Slacky-DIY","TS0041-M002-SlD"),b.create_fingerprint("Slacky-DIY","TS0041-M005-SlD"),})a(al,{
b.create_fingerprint("Slacky-DIY","TS0042-z-SlD"),b.create_fingerprint("Slacky-DIY","TS0042-M003-SlD"),b.create_fingerprint("Slacky-DIY","TS0042-M006-SlD"),})a(am,{
b.create_fingerprint("Slacky-DIY","TS0044-z-SlD"),b.create_fingerprint("Slacky-DIY","TS0044-M004-SlD"),})a(s,{
b.create_fingerprint("Shelly","BLU Remote Control ZB"),})a(t,{
b.create_fingerprint("Shelly","BLU Button Tough 1 ZB"),})a(w,{
b.create_fingerprint("Shelly","BLU RC Button 4 ZB"),})a(ag,{
b.create_fingerprint("Shelly","1"),})a(F,{
b.create_fingerprint("eWeLink","CK-TLSR8656-SS5-01(7000)"),b.create_fingerprint("eWeLink","WB-01"),b.create_fingerprint("eWeLink","SNZB-01"),b.create_fingerprint("SONOFF","CK-TLSR8656-SS5-01(7000)"),b.create_fingerprint("SONOFF","WB01"),b.create_fingerprint("SONOFF","WB-01"),b.create_fingerprint("SONOFF","SNZB-01"),})a(K,{
b.create_fingerprint("Namron","4512772"),})a(y,{
b.create_fingerprint("Namron AS","4512793"),})a(aH,b.create_fingerprints("TS004F",{
"_TZ3000_qja6nq5z","_TZ3000_402vrq2i","_TZ3000_4fjiwweb","_TZ3000_uri7ongn","_TZ3000_ixla93vd","_TZ3000_csflgqj2","_TZ3000_abrsvsou","_TZ3000_ugi8ky6u",}))a(as,b.create_fingerprints("TS004F",{
"_TZ3000_1fqpj6qz","_TZ3000_gwkzibhs",}))o.attach_reporting_capabilities(Y,{
{1,"rpt-top"},{2,"rpt-tew"},{3,"rpt-toe"},{4,"rpt-tnc"},{5,"rpt-tfs"},{6,"rpt-tfs"},{7,"rpt-tyq"},{8,"rpt-tom"},{9,"rpt-tom"},{10,"rpt-tfs"},{11,"rpt-tom"},{13,"rpt-chu"},{16,"rpt-tnc"},{17,"rpt-teb"},})return{
id="zcl.controls.advanced",registrations=Y,}
