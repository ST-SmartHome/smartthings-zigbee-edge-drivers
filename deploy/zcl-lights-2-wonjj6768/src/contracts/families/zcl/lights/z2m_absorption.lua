local b=require"protocol.zcl"
local p=require"capabilities.events.all"
local g=require"contracts.helpers.family"
local u=require"contracts.helpers.zcl"
local G=require"st.zigbee.device_management"
local k=require"st.capabilities"
local d=require"st.zigbee.data_types"
local t,v=g.definition_registry()local y={
"AduroSmart ERIA","ERIA","AduroSmart Eria",}
local function f(e,R)
v(e,R)
end
local function m(W)
local A={}for _,aa in ipairs(W)do
for _,O in ipairs(y)do
A[#A+1]=g.create_fingerprint(O,aa)
end
end
return A
end
local function o(K,Z)
local e
e={
profile=K,color_temperature_range={
minimum=math.floor((1000000/500)+0.5),maximum=math.floor((1000000/153)+0.5),},zcl_clusters={
b.switch({endpoint=1,configure_reporting=false}),b.level({endpoint=1,configure_reporting=false}),b.color_temperature({endpoint=1,configure_reporting=false}),},
runtime_start=function(c)
c:emit_component_event(
{id="main"},k.colorTemperature.colorTemperatureRange({
value=e.color_temperature_range,unit="K",}))return true
end,
}if Z then
e.zcl_clusters[#e.zcl_clusters+1]=
b.color_hue({endpoint=1,configure_reporting=false})e.zcl_clusters[#e.zcl_clusters+1]=
b.color_saturation({endpoint=1,configure_reporting=false})e.zcl_clusters[#e.zcl_clusters+1]=b.color({endpoint=1})
end
return e
end
local z=o("lights-color-temperature",false)local C=o("lights-color-temperature-color",true)
local function r(value,V,U)
value=tonumber(value)
if value==nil then return nil end
return math.max(V,math.min(U,math.floor(value+0.5)))
end
local function h(value)
value=tonumber(value)
if value==nil then return nil end
return value/10
end
local function i(value)
if value=="disabled"then return 65535 end
value=tonumber(value)
if value==nil then return nil end
if value>=6553.5 then return 65535 end
return math.max(0,math.min(65534,math.floor((value*10)+0.5)))
end
local H={
profile="lights-candeo-rd1p-dpm",capability_commands={
{
capability_id="concertmirror08464.candeoRd1pDpmOnLevel",command_name="usePreviousOnLevel",mapping_name="candeo_rd1p_dpm_on_level",value="previous",},{
capability_id="concertmirror08464.candeoRd1pDpmStartupLevel",command_name="useMinimumStartupLevel",mapping_name="candeo_rd1p_dpm_startup_level",value="minimum",},{
capability_id="concertmirror08464.candeoRd1pDpmStartupLevel",command_name="usePreviousStartupLevel",mapping_name="candeo_rd1p_dpm_startup_level",value="previous",},{
capability_id="concertmirror08464.candeoRd1pDpmOnTransitionTime",command_name="disableOnTransitionTime",mapping_name="candeo_rd1p_dpm_on_transition_time",value="disabled",},{
capability_id="concertmirror08464.candeoRd1pDpmOffTransitionTime",command_name="disableOffTransitionTime",mapping_name="candeo_rd1p_dpm_off_transition_time",value="disabled",},},advanced_remote=true,unprefixed_remote_actions=true,remote_action_emit_name="candeoRd1pDpmAction",standard_command_action_resolver=u.resolve_rd1p_rotary_action,zcl_clusters={
b.switch({
endpoint=1,minimum_interval=0,maximum_interval=65000,}),b.level({
endpoint=1,minimum_interval=1,maximum_interval=3600,reportable_change=1,}),b.power({
endpoint=1,minimum_interval=5,maximum_interval=300,reportable_change=10,}),b.voltage({
endpoint=1,minimum_interval=5,maximum_interval=600,reportable_change=500,}),b.current({
endpoint=1,minimum_interval=5,maximum_interval=900,reportable_change=10,}),b.energy({
endpoint=1,minimum_interval=5,maximum_interval=1800,reportable_change=50,}),b.cluster_attribute(b.CLUSTER_ON_OFF,16387,{
name="candeo_rd1p_dpm_power_on_behavior",emit=p.candeoRd1pDpmPowerBehavior(),endpoint=1,
from_device=function(value)
return({[0]="off",[1]="on",[2]="toggle",[255]="previous"})[value]
end,
to_device=function(value)
return({off=0,on=1,toggle=2,previous=255})[value]
end,
data_type=d.Enum8,write_type=d.Enum8,read_on_configure=true,}),b.cluster_attribute(b.CLUSTER_LEVEL_CONTROL,17,{
name="candeo_rd1p_dpm_on_level",emit=p.candeoRd1pDpmOnLevel(),endpoint=1,
from_device=function(value)return r(value,0,255)end,
to_device=function(value)
if value=="previous"then return 255 end
return r(value,1,255)
end,
numeric_range={minimum=0,maximum=255,step=1},data_type=d.Uint8,write_type=d.Uint8,read_on_configure=true,}),b.cluster_attribute(b.CLUSTER_LEVEL_CONTROL,16384,{
name="candeo_rd1p_dpm_startup_level",emit=p.candeoRd1pDpmStartupLevel(),endpoint=1,
from_device=function(value)return r(value,0,255)end,
to_device=function(value)
if value=="minimum"then return 0 end
if value=="previous"then return 255 end
return r(value,0,255)
end,
numeric_range={minimum=0,maximum=255,step=1},data_type=d.Uint8,write_type=d.Uint8,read_on_configure=true,}),b.cluster_attribute(b.CLUSTER_LEVEL_CONTROL,18,{
name="candeo_rd1p_dpm_on_transition_time",emit=p.candeoRd1pDpmOnTransitionTime(),endpoint=1,from_device=h,to_device=i,numeric_range={minimum=0,maximum=6553.5,step=0.1,unit="s"},data_type=d.Uint16,write_type=d.Uint16,read_on_configure=true,}),b.cluster_attribute(b.CLUSTER_LEVEL_CONTROL,19,{
name="candeo_rd1p_dpm_off_transition_time",emit=p.candeoRd1pDpmOffTransitionTime(),endpoint=1,from_device=h,to_device=i,numeric_range={minimum=0,maximum=6553.5,step=0.1,unit="s"},data_type=d.Uint16,write_type=d.Uint16,read_on_configure=true,}),},
configure=function(L,c)
for _,P in ipairs({
{endpoint=1,cluster_id=b.CLUSTER_ON_OFF},{endpoint=1,cluster_id=b.CLUSTER_LEVEL_CONTROL},{endpoint=1,cluster_id=b.CLUSTER_ELECTRICAL_MEASUREMENT},{endpoint=1,cluster_id=b.CLUSTER_SIMPLE_METERING},{endpoint=2,cluster_id=b.CLUSTER_ON_OFF},{endpoint=2,cluster_id=b.CLUSTER_LEVEL_CONTROL},})do
c:send(G.build_bind_request(
c,P.cluster_id,L.environment_info.hub_zigbee_eui,P.endpoint))
end
end,
}local l
l={
profile="lights-paulmann-rgbww",auto_on_before_light_command=false,capability_commands={
{
capability_id="concertmirror08464.paulmannRgbwwStartupCct",command_name="restorePaulmannRgbwwPreviousCct",mapping_name="paulmann_rgbww_startup_color_temperature",value=65535,},},color_temperature_range={
minimum=math.floor((1000000/454)+0.5),maximum=math.floor((1000000/153)+0.5),},zcl_clusters={
b.switch({configure_reporting=false}),b.level({configure_reporting=false}),b.color_temperature({
configure_reporting=false,
to_device=function(value)return math.max(153,math.min(454,math.floor(1000000/value+0.5)))end,
}),b.color_hue({configure_reporting=false}),b.color_saturation({configure_reporting=false}),b.color(),b.cluster_attribute(b.CLUSTER_ON_OFF,16387,{
name="paulmann_rgbww_power_on_behavior",emit=p.paulmannRgbwwPowerOnBehavior(),
from_device=function(value)
value=type(value)=="table"and value.value or value
return({[0]="off",[1]="on",[2]="toggle",[255]="previous"})[value]
end,
to_device=function(value)
return({off=0,on=1,toggle=2,previous=255})[value]
end,
data_type=d.Enum8,write_type=d.Enum8,}),b.cluster_attribute(b.CLUSTER_COLOR_CONTROL,16400,{
name="paulmann_rgbww_startup_color_temperature",emit=p.paulmannRgbwwStartupCct(),
from_device=function(value)return value end,
to_device=function(value)
value=tonumber(value)
if value==65535 then return value end
if value==nil then return nil end
return math.max(153,math.min(454,math.floor(value+0.5)))
end,
data_type=d.Uint16,write_type=d.Uint16,}),b.cluster_attribute(3,65535,{
name="paulmann_rgbww_effect",emit=p.paulmannRgbwwEffect(),write_only=true,sender=b.send_light_effect,}),},
configure=function(_,c)
for _,s in ipairs({16394,16395,16396})do
b.read_mapping(c,b.cluster_attribute(768,s,{endpoint=1}))
end
end,
runtime_start=function(c)
c:emit_component_event(
{id="main"},k.colorTemperature.colorTemperatureRange({
value=l.color_temperature_range,unit="K",}))return true
end,
}u.append_clusters(l.zcl_clusters,b.color_xy({endpoint=1}))local D
D={
profile="lights-color-temperature-color",color_temperature_range={
minimum=math.floor((1000000/500)+0.5),maximum=math.floor((1000000/153)+0.5),},zcl_clusters={
b.switch({endpoint=1}),b.level({endpoint=1}),b.color_temperature({endpoint=1}),b.color_hue({endpoint=1}),b.color_saturation({endpoint=1}),b.color({endpoint=1}),b.cluster_attribute(0,1,{
name="hejhome_z26_app_version_keepalive",endpoint=1,read_only=true,data_type=d.Uint8,read_on_configure=true,poll_interval=120,}),},
runtime_start=function(c)
c:emit_component_event(
{id="main"},k.colorTemperature.colorTemperatureRange({
value=D.color_temperature_range,unit="K",}))return true
end,
}
local function n(c,F,value,x)
if F.name=="luumr_g9_do_not_disturb"then
return b.send_raw_cluster_command(c,768,250,string.char(value=="enabled"and 1 or 0),x.endpoint or 1)
end
local M=({blink=0,breathe=1,okay=2,channel_change=11,finish_effect=254,stop_effect=255})[value]return b.send_raw_cluster_command(c,3,64,string.char(M,0),x.endpoint or 1)
end
local Q={
profile="lights-luumr-g9",auto_on_before_light_command=false,color_temperature_range={minimum=2000,maximum=6536},zcl_clusters={
b.tuya_magic_packet({read_on_configure=false}),b.switch({endpoint=1,minimum_interval=0,maximum_interval=65000}),b.level({endpoint=1,minimum_interval=5,maximum_interval=65000,reportable_change=1}),b.color_temperature({
endpoint=1,minimum_interval=10,maximum_interval=65000,reportable_change=1,
to_device=function(value)return math.max(153,math.min(500,math.floor(1000000/value+0.5)))end,
}),b.cluster_attribute(8,61440,{
name="luumr_g9_tuya_brightness",endpoint=1,data_type=d.Uint16,read_only=true,emit=p.level(),
from_device=function(value)return math.floor(value/10+0.5)end,
}),b.cluster_attribute(3,65535,{
name="luumr_g9_effect",endpoint=1,write_only=true,suppress_optimistic_state=true,emit=p.luumrG9Effect(),sender=n,}),b.cluster_attribute(768,65534,{
name="luumr_g9_do_not_disturb",endpoint=1,write_only=true,emit=p.luumrG9DoNotDisturb(),sender=n,}),},
configure=function(L,c)
local T=L.environment_info.hub_zigbee_eui
for _,S in ipairs({6,8,768})do b.bind_cluster(c,S,T,1)end
for _,s in ipairs({16394,16395,16396})do b.read_attribute(c,768,s,1)end
end,
runtime_start=function(c)
c:emit_component_event({id="main"},k.colorTemperature.colorTemperatureRange({value={minimum=2000,maximum=6536},unit="K"}))return true
end,
parent_refresh=function(c)
for _,N in ipairs({{6,0},{8,0},{768,7}})do b.read_attribute(c,N[1],N[2],1)end
return true
end,
}
local function j(c,F,value,x)
if F.name:sub(-7)=="_effect"then
local E=x.endpoint or 1
if value=="colorloop"or value=="stop_colorloop"then
local X=b.send_raw_cluster_command(c,768,1,string.char(value=="colorloop"and 1 or 0,value=="colorloop"and 17 or 1,0,0),E)if value=="stop_colorloop"and X~=false then
c.thread:call_with_delay(0.1,function()
b.read_attribute(c,768,0,E)b.read_attribute(c,768,8,E)
end)
end
return X
end
local M=({blink=0,breathe=1,okay=2,channel_change=11,finish_effect=254,stop_effect=255})[value]return b.send_raw_cluster_command(c,3,64,string.char(M,0),E)
end
if F.name:find("_do_not_disturb",1,true)then
return b.send_raw_cluster_command(c,768,250,string.char(value=="enabled"and 1 or 0),x.endpoint or 1)
end
local ab=({initial=0,previous=1,customized=2})[value]return b.send_raw_cluster_command(c,768,249,string.char(0,ab)..string.rep("\0",10),x.endpoint or 1)
end
local function q(K,B,w)
local e={
profile=K,auto_on_before_light_command=false,placeholder_custom_states=false,initial_custom_state_query=false,zcl_clusters={
b.switch({endpoint=1,configure_reporting=false}),b.level({endpoint=1,configure_reporting=false}),b.color_hue({endpoint=1,configure_reporting=false}),b.color_saturation({endpoint=1,configure_reporting=false}),b.color({endpoint=1}),b.cluster_attribute(8,61440,{
name=B.."_tuya_brightness",endpoint=1,data_type=d.Uint16,read_only=true,
emit=p.level(),from_device=function(value)return math.floor(value/10+0.5)end,
}),b.cluster_attribute(3,65535,{
name=B.."_effect",endpoint=1,write_only=true,suppress_optimistic_state=true,emit=p[B.."Effect"](),sender=j,}),b.cluster_attribute(768,65534,{
name=B.."_do_not_disturb",endpoint=1,write_only=true,emit=p[B.."DoNotDisturb"](),sender=j,}),b.cluster_attribute(768,65533,{
name=B.."_color_power_on_behavior",endpoint=1,write_only=true,emit=p[B.."ColorPowerOnBehavior"](),sender=j,}),},
configure=function(_,c)
for _,s in ipairs({16394,16395,16396})do b.read_attribute(c,768,s,1)end
end,
parent_refresh=function(c)
for _,N in ipairs({{6,0},{8,0},{768,0},{768,1},{768,8}})do
b.read_attribute(c,N[1],N[2],1)
end
if w then b.read_attribute(c,768,7,1)end
return true
end,
}if w then
e.color_temperature_range={minimum=2000,maximum=6536}e.zcl_clusters[#e.zcl_clusters+1]=b.color_temperature({
endpoint=1,configure_reporting=false,
to_device=function(value)return math.max(153,math.min(500,math.floor(1000000/value+0.5)))end,
})
e.runtime_start=function(c)
c:emit_component_event({id="main"},k.colorTemperature.colorTemperatureRange({value={minimum=2000,maximum=6536},unit="K"}))return true
end
end
return e
end
local J=q("lights-tuya-ts0505b-hs","ts0505bHs",true)local I=q("lights-tuya-ts0503b-hs","ts0503bHs",false)f(H,{
g.create_fingerprint("Candeo","C-ZB-RD1Pv2-DPM"),})f(l,{
g.create_fingerprint("Paulmann Licht GmbH","RGBWW"),})f(D,{
g.create_fingerprint("_TZ3210_cnicaghm","TS0505B"),})f(z,m({
"AD-DL4CT3001","AD-DL4CTW3001","AD-DL6CT3001","AD-DL6CTW3001","AD-FLMCT3001",}))f(C,m({
"AD-DL4RGBW3001","AD-DL6RGBW3001","AD-GU10RGB3001","AD-GU10RGBW3001",}))f(Q,{
g.create_fingerprint("_TZ3210_tqwyiitv","TS0502B"),})f(J,{
g.create_fingerprint("_TZ3210_ffuna0nr","TS0505B"),})f(I,{
g.create_fingerprint("_TZ3210_rbixajyp","TS0503B"),g.create_fingerprint("_TZ3210_w7ge4ldo","TS0503B"),})b.attach_reporting_capabilities(t,{
{1,"rpt-cxt"},{3,"rpt-tkj"},{6,"rpt-tcn"},})return{
id="zcl.lights.z2m_absorption",registrations=t,}
