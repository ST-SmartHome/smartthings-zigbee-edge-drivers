local a=require"protocol.tuya"
local e=require"capabilities.events.all"
local i=require"contracts.helpers.family"
local z=require"protocol.zcl"
local d=a.converter
local u,c=i.definition_registry()
local function j()
return d.from_only(function(b)
local g=tonumber(b)if g==nil then
return nil
end
g=100-g
if g<=0 then
return"closed"
end
if g>=100 then
return"open"
end
return"partially open"
end)
end
local h=d.lookup_from_to({
open=0,stop=1,close=2,})
local f=d.from_only(function(b)
return({
[0]="open",[1]="partially open",[2]="closed",[3]="partially open",})[tonumber(b)]
end)
local function n(r)
return type(r)=="table"
and type(r.preferences)=="table"
and r.preferences.reverse==true
end
local k=d.from_to(
function(b,r)
local g=tonumber(b)
if g==nil then return nil end
return n(r)and(100-g)or g
end,
function(b,r)
local g=tonumber(b)
if g==nil then return nil end
return n(r)and(100-g)or g
end
)
local l=d.from_only(function(b,r)
local v=k.from(b,r)
if v==nil then return nil end
if v<=0 then return"closed"end
if v>=100 then return"open"end
return"partially open"
end)
local t={
profile="covers-cover-gm25teq",a.dp_enum(1,{
name="cover_state",converter=h,write_only=true,}),a.dp_enum(1,{
name="cover_action_state",emit=e.shade_state(),converter=f,read_only=true,}),a.dp_cover_position_inverted(9,{emit=e.shade_level()}),a.dp_numeric(9,{
name="window_shade_state_command_position",emit=e.shade_state(),converter=j(),read_only=true,}),a.dp_cover_position_inverted(8,{
name="cover_position_state",emit=e.shade_level(),read_only=true,}),a.dp_numeric(8,{
name="window_shade_state",emit=e.shade_state(),converter=j(),read_only=true,}),a.dp_numeric(11,{
name="motor_direction",emit=e.gm25TeqMotorDirection(),
converter=d.from_to(function(b)
return(b==1 or b=="back"or b=="reversed")and"reversed"or"normal"
end,function(b)
return({normal=0,reversed=1})[b]
end),
}),query_on_configure=false,time_start="off",}local p={
profile="covers-cover-moes-zs-sf-euc-wh-ms",query_on_configure=false,time_start="off",a.dp_enum(3,{
name="moes_sf_calibration",emit=e.moesSfCalibration(),
converter=d.lookup_from_to({start=0,["end"]=1}),
}),a.dp_binary(7,{
name="moes_sf_backlight",emit=e.moesSfBacklight(),converter=d.lookup_from_to({on=true,off=false}),}),a.dp_enum(8,{
name="moes_sf_direction",emit=e.moesSfDirection(),converter=d.lookup_from_to({normal=0,reversed=1}),}),a.dp_numeric(10,{
name="moes_sf_travel_time",emit=e.moesSfTravelTime(),}),a.dp_enum(1,{
name="cover_state",converter=h,write_only=true,}),a.dp_enum(1,{
name="cover_action_state",emit=e.shade_state(),converter=f,read_only=true,}),a.dp_cover_position(2,{
name="cover_position",emit=e.shade_level(),converter=k,}),a.dp_numeric(2,{
name="window_shade_state",emit=e.shade_state(),converter=l,read_only=true,}),}c(t,i.create_fingerprints("TS0601",{
"_TZE204_xtrnjaoz","_TZE200_xtrnjaoz","_TZE284_8whfphjv",}))c(p,i.create_fingerprints("TS0601",{
"_TZE284_upt8lzi0","_TZE28C1000000_i8sdouy0",}))local q={
profile="covers-nova-zcmr1-core",package_group="covers",transport_classification="EF00_DP",z2m_converter_source="meta.tuyaDatapoints",wire_cluster="manuSpecificTuya",magic_packet=true,mcu_version_request_on_configure=true,query_on_configure=true,named_datapoints=true,time_start="off",placeholder_custom_states=false,datapoints={
a.dp_enum(1,{
name="cover_state",converter=h,write_only=true,transaction=1,}),a.dp_enum(1,{
name="cover_action_state",converter=f,read_only=true,transaction=1,emit=e.shade_state(),}),a.dp_cover_position(2,{
name="cover_position",transaction=1,emit=e.shade_level(),}),a.dp_numeric(2,{
name="cover_position_shade_state",
converter=d.from_only(function(b)
if b<=0 then return"closed"end
if b>=100 then return"open"end
return"partially open"
end),
read_only=true,transaction=1,emit=e.shade_state(),}),a.dp_cover_position(3,{
name="cover_position_report",read_only=true,transaction=1,emit=e.shade_level(),}),a.dp_numeric(3,{
name="cover_position_report_shade_state",
converter=d.from_only(function(b)
if b<=0 then return"closed"end
if b>=100 then return"open"end
return"partially open"
end),
read_only=true,transaction=1,emit=e.shade_state(),}),},}c(q,{
i.create_fingerprint("_TZE204_dqy15zxy","TS0601"),})local s={
profile="covers-tuya-limited-switch",magic_packet=true,mcu_version_request_on_configure=true,query_on_configure=false,query_on_announce=false,time_start="off",datapoints={
a.dp_enum(1,{name="cover_state",converter=h,write_only=true}),a.dp_enum(1,{name="cover_action_state",converter=f,emit=e.shade_state(),read_only=true}),a.dp_on_off(7,{name="switch",component="main"}),a.dp_enum(8,{
name="limited_cover_motor_direction",emit=e.limitedCoverMotorDirection(),receive_datatypes={4,3},converter=d.lookup_from_to({normal=0,reversed=1}),
from_device=function(b)
if type(b)=="string"then return b=="back"and"reversed"or"normal"end
return({[0]="normal",[1]="reversed"})[b]
end,
}),},}c(s,{
i.create_fingerprint("_TZE204_pxbjch8m","TS0601"),})
local m=d.from_to(function(b)
if type(b)=="string"then return b=="back"and"reversed"or"normal"end
return({[0]="normal",[1]="reversed"})[b]
end,function(b)
return({normal=0,reversed=1})[b]
end)
local x={
profile="covers-tuya-cover5-px",magic_packet=true,mcu_version_request_on_configure=true,query_on_configure=false,query_on_announce=false,initial_custom_states=false,refresh_state=false,refresh_state_query=false,time_start="off",datapoints={
a.dp_enum(1,{name="cover_state",converter=h,write_only=true}),a.dp_enum(1,{
name="cover_action_state",emit=e.shade_state(),read_only=true,
converter=d.from_only(function(b)
return({[0]="open",[1]="partially open",[2]="closed"})[b]
end),
}),a.dp_cover_position(2,{emit=e.shade_level(),converter=k}),a.dp_numeric(2,{name="window_shade_state",emit=e.shade_state(),converter=l,read_only=true}),a.dp_enum(3,{
name="cover5_px_calibration",emit=e.cover5PxCalibration(),converter=d.lookup_from_to({START=0,END=1}),}),a.dp_binary(7,{
name="cover5_px_backlight",emit=e.cover5PxBacklight(),converter=d.lookup_from_to({ON=true,OFF=false}),}),a.dp_enum(8,{
name="cover5_px_motor_direction",emit=e.cover5PxMotorDirection(),converter=m,receive_datatypes={4,3},}),a.dp_binary(103,{
name="cover5_px_child_lock",emit=e.cover5PxChildLock(),converter=d.lookup_from_to({ON=true,OFF=false}),}),},}c(x,{
i.create_fingerprint("_TZE284_pxwixtky","TS0601"),})
local o=d.from_only(function(b)
if b<=0 then return"closed"end
if b>=100 then return"open"end
return"partially open"
end)
local w={
profile="covers-tuya-cover14-a0",magic_packet=true,mcu_version_request_on_configure=true,query_on_configure=false,query_on_announce=false,initial_custom_states=false,refresh_state=false,refresh_state_query=false,time_start="off",datapoints={
a.dp_enum(1,{name="cover_state",converter=h,write_only=true}),a.dp_enum(1,{name="cover_action_state",converter=f,emit=e.shade_state(),read_only=true}),a.dp_cover_position(2,{emit=e.shade_level()}),a.dp_numeric(2,{name="window_shade_state",emit=e.shade_state(),converter=o,read_only=true}),a.dp_cover_position(3,{name="cover_position_report",emit=e.shade_level(),read_only=true}),a.dp_numeric(3,{name="window_shade_state_report",emit=e.shade_state(),converter=o,read_only=true}),a.dp_enum(5,{
name="cover14_a0_motor_direction",emit=e.cover14A0MotorDirection(),converter=m,receive_datatypes={4,3},}),a.dp_enum(7,{
name="cover14_a0_motor_state",emit=e.cover14A0MotorState(),read_only=true,converter=d.lookup_from_to({opening=0,closing=1,stopped=2}),}),a.dp_numeric(10,{name="cover14_a0_total_time",emit=e.cover14A0TotalTime(),read_only=true}),a.dp_enum(11,{
name="cover14_a0_situation_set",emit=e.cover14A0SituationSet(),converter=d.lookup_from_to({fully_close=0,fully_open=1}),}),a.dp_numeric(19,{name="cover14_a0_favorite_position",emit=e.cover14A0FavoritePosition()}),},}c(w,{
i.create_fingerprint("_TZE284_a0hirjnh","TS0601"),})local y={
profile="covers-moes-fwjz-16eb",magic_packet=true,mcu_version_request_on_configure=true,query_on_configure=false,query_on_announce=false,initial_custom_states=false,refresh_state=false,refresh_state_query=false,time_start="off",datapoints={
a.dp_enum(1,{name="cover_state",converter=h,write_only=true}),a.dp_enum(1,{name="cover_action_state",converter=f,emit=e.shade_state(),read_only=true}),a.dp_cover_position(9,{emit=e.shade_level(),converter=k}),a.dp_numeric(9,{name="window_shade_state",emit=e.shade_state(),converter=l,read_only=true}),a.dp_cover_position(8,{name="cover_position_report",emit=e.shade_level(),converter=k,read_only=true}),a.dp_numeric(8,{name="window_shade_state_report",emit=e.shade_state(),converter=l,read_only=true}),a.dp_enum(11,{
name="fwjz_16eb_motor_direction",emit=e.fwjz16ebMotorDirection(),converter=m,receive_datatypes={4,3},}),a.dp_raw(13,{
name="battery",read_only=true,receive_datatypes={0,2},emit=e.battery(),
from_device=function(b)
if type(b)=="number"then return b end
if type(b)=="string"and #b>=4 then return string.unpack(">I4",b)end
end,
}),a.dp_enum(16,{
name="fwjz_16eb_cover_limit",emit=e.fwjz16ebCoverLimit(),converter=d.lookup_from_to({set_up=0,set_down=1,delete_up=2,delete_down=3}),}),},zcl_clusters={
z.cluster_attribute(1,33,{
name="battery",endpoint=1,read_only=true,scale=2,emit=e.battery(),}),},}c(y,{
i.create_fingerprint("_TZE2841000000_u68q868h","TS0601"),})return{
id="ef00.covers.z2m_absorption",registrations=u,}
