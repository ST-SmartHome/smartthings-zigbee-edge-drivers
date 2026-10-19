local c=require"protocol.tuya"
local f=require"capabilities.events.all"
local b=require"contracts.helpers.family"
local au=require"protocol.zcl"
local al=require"st.zigbee.zcl.clusters"
local ad=require"st.zigbee.device_management"
local d=c.converter
local H,a=b.definition_registry()
local function e()
return d.from_only(function(i)
local o=tonumber(i)if o==nil then
return nil
end
if o<=0 then
return"closed"
end
if o>=100 then
return"open"
end
return"partially open"
end)
end
local function h()
return d.from_only(function(i)
local o=tonumber(i)if o==nil then
return nil
end
o=100-o
if o<=0 then
return"closed"
end
if o>=100 then
return"open"
end
return"partially open"
end)
end
local g=d.lookup_from_to({
open=0,stop=1,close=2,})
local t=d.from_only(function(i)
return({
[0]="open",[1]="partially open",[2]="closed",[3]="partially open",})[tonumber(i)]
end)
local r=d.lookup_from_to({
open=0,close=1,stop=2,})local s=d.lookup_from_to({
open=2,stop=1,close=0,})local w=d.lookup_from_to({
open=1,close=0,stop=2,})local M=d.lookup_from_to({
open=2,stop=0,close=1,})local F={
profile="covers-cover-switch-1",c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_on_off(101,{
name="switch",component="switch2",}),}local G={
profile="covers-cover-switch-2",c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_on_off(101,{
name="switch",component="switch2",}),c.dp_on_off(102,{
name="switch",component="switch3",}),}local J={
profile="covers-cover-switch-2-trwaxi57",datapoints={
c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_enum(3,{
name="calibration",emit=f.trwaxi57Calibration(),converter=d.lookup_from_to({
start=0,
["end"]=1,
}),}),c.dp_backlight_mode_off_on(7,{
name="backlight_mode",emit=f.trwaxi57Backlight(),converter=d.lookup_from_to({off=false,on=true}),}),c.dp_enum(8,{
name="motor_steering",emit=f.trwaxi57MotorSteering(),converter=d.lookup_from_to({
forward=0,backward=1,}),}),c.dp_child_lock(102,{
name="child_lock",emit=f.trwaxi57ChildLock(),converter=d.lookup_from_to({off=false,on=true}),}),c.dp_on_off(108,{name="switch",component="switch2"}),c.dp_on_off(107,{name="switch",component="switch3"}),},query_on_configure=true,}local n={
c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),}local k={
c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position_inverted(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=h(),read_only=true,}),}local aq={
profile="covers-cover-six",magic_packet=true,mcu_version_request_on_configure=true,time_start="off",c.dp_enum(1,{name="cover_state",converter=g,write_only=true}),c.dp_enum(1,{name="cover_action_report",converter=t,emit=f.shade_state(),read_only=true}),c.dp_cover_position_inverted(2,{emit=f.shade_level()}),c.dp_numeric(2,{name="window_shade_state",converter=h(),emit=f.shade_state(),read_only=true}),c.dp_cover_position_inverted(3,{name="position_report",emit=f.shade_level(),read_only=true}),c.dp_numeric(3,{name="window_shade_report",converter=h(),emit=f.shade_state(),read_only=true}),c.dp_enum(4,{name="cover_six_opening",converter=d.lookup_from_to({tilt=0,lift=1}),emit=f.coverSixOpening()}),c.dp_enum(7,{name="cover_six_work_state",converter=d.lookup_from_to({standby=0,success=1,learning=2}),emit=f.coverSixWorkState(),read_only=true}),c.dp_battery(13,{emit=f.battery(),read_only=true}),c.dp_enum(101,{name="cover_six_direction",converter=d.lookup_from_to({left=0,right=1}),emit=f.coverSixDirection()}),c.dp_enum(102,{name="cover_six_upper_limit",converter=d.lookup_from_to({start=1,stop=0}),emit=f.coverSixUpperLimit()}),c.dp_numeric(104,{name="cover_six_illumination",emit=f.coverSixIllumination(),read_only=true}),}local B={
c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position_inverted(8,{emit=f.shade_level()}),c.dp_numeric(8,{
name="window_shade_state",emit=f.shade_state(),converter=h(),read_only=true,}),}
local function R(i,j)
return j.preferences.reverse==true and(100-i)or i
end
local D={from=R,to=R}
local I=d.from_only(function(i,j)
local position=R(i,j)return position<=0 and"closed"or position>=100 and"open"or"partially open"
end)
local aa={
c.dp_enum(2,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(7,{converter=D,emit=f.shade_level()}),c.dp_numeric(7,{
name="window_shade_state",emit=f.shade_state(),converter=I,read_only=true,}),c.dp_cover_position(8,{name="cover_position_report",converter=D,emit=f.shade_level(),read_only=true}),c.dp_numeric(8,{
name="window_shade_state_report",emit=f.shade_state(),converter=I,read_only=true,}),}local L={
c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(8,{emit=f.shade_level()}),c.dp_numeric(8,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),}local ah={
profile="covers-cover",datapoints={
c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_enum(3,{
name="calibration",converter=d.lookup_from_to({on=0,off=1}),}),c.dp_enum(8,{
name="motor_reversal",converter=d.lookup_from_to({on=1,off=0}),}),c.dp_numeric(10,{
name="calibration_time",scale=10,read_only=true,}),c.dp_enum(12,{
name="switch_type",converter=d.lookup_from_to({momentary=0,toggle=1}),}),c.dp_enum(14,{
name="backlight_mode",converter=d.lookup_from_to({on=0,off=1}),}),},query_on_configure=true,}local ac={
profile="covers-cover-zsm01",c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(9,{write_only=true}),c.dp_numeric(8,{
name="cover_position_state",emit=f.shade_level(),read_only=true,}),c.dp_numeric(8,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_enum(11,{
name="control_back_mode",emit=f.zsm01ControlBackMode(),converter=d.lookup_from_to({forward=0,back=1}),}),c.dp_numeric(19,{
name="position_best",emit=f.zsm01PositionBest(),}),c.dp_enum(20,{
name="click_control",emit=f.zsm01ClickControl(),converter=d.lookup_from_to({up=0,down=1}),}),}local O={
c.dp_enum(1,{
name="cover_state",converter=M,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),}local an={
profile="covers-cover-zb-sm",c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_numeric(3,{name="arrived_position"}),c.dp_enum(5,{
name="motor_direction",emit=f.motorDirectionZbSmNormalRev(),converter=d.lookup_from_to({normal=0,reversed=1}),}),c.dp_numeric(10,{
name="cycle_time",read_only=true,emit=f.zbSmCycleTime(),}),c.dp_enum(101,{
name="motor_type",read_only=true,emit=f.zbSmMotorType(),converter=d.from_only(d.lookup_value({
[0]="",[1]="AM0/6-28R-Sm",[2]="AM0/10-19R-Sm",[3]="AM1/10-13R-Sm",[4]="AM1/20-13R-Sm",[5]="AM1/30-13R-Sm",})),}),c.dp_numeric(102,{
name="cycle_count",read_only=true,emit=f.zbSmCycleCount(),}),c.dp_enum(103,{
name="bottom_limit",emit=f.zbSmBottomLimit(),converter=d.lookup_from_to({set=0,clear=1}),}),c.dp_enum(104,{
name="top_limit",emit=f.zbSmTopLimit(),converter=d.lookup_from_to({set=0,clear=1}),}),c.dp_numeric(109,{
name="active_power",read_only=true,emit=f.zbSmActivePower(),}),c.dp_cover_position(115,{name="favorite_position",emit=f.favoritePositionZbSm()}),c.dp_enum(121,{
name="motor_state",read_only=true,emit=f.zbSmMotorState(),converter=d.from_only(d.lookup_value({
[0]="opening",[1]="stopped",[2]="closing",})),}),}local W={
c.dp_enum(1,{
name="cover_state",converter=s,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),}local ao={
profile="covers-cover-battery",magic_packet=true,mcu_version_request_on_configure=true,time_start="off",query_on_configure=true,query_on_announce=true,query_interval_seconds=86400,c.dp_enum(1,{name="cover_state",converter=g,write_only=true}),c.dp_enum(1,{name="cover_action_report",converter=t,emit=f.shade_state(),read_only=true}),c.dp_cover_position_inverted(2,{emit=f.shade_level()}),c.dp_numeric(2,{name="window_shade_state",converter=h(),emit=f.shade_state(),read_only=true}),c.dp_cover_position_inverted(3,{name="position_report",emit=f.shade_level(),read_only=true}),c.dp_numeric(3,{name="window_shade_report",converter=h(),emit=f.shade_state(),read_only=true}),c.dp_battery(13,{emit=f.battery(),read_only=true}),}a(ao,b.create_fingerprints("TS0601",{"_TZE284_koxaopnk"}))local ar={
magic_packet=true,mcu_version_request_on_configure=true,time_start="off",c.dp_enum(1,{name="cover_state",converter=s,write_only=true}),c.dp_enum(1,{name="cover_action_report",read_only=true,emit=f.shade_state(),
from_device=function(i)return({[0]="closed",[1]="partially open",[2]="open"})[i]end}),
c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{name="window_shade_state",converter=e(),emit=f.shade_state(),read_only=true}),c.dp_numeric(3,{name="position_report",emit=f.shade_level(),read_only=true}),c.dp_numeric(3,{name="window_shade_report",converter=e(),emit=f.shade_state(),read_only=true}),}local ag={
c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{
write_only=true,}),c.dp_numeric(3,{
name="cover_position_state",emit=f.shade_level(),read_only=true,}),c.dp_numeric(3,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),}local V={
profile="covers-cover-pims3028",c.dp_enum(1,{
name="cover_state",converter=d.lookup_from_to({
open=0,stop=1,close=2,lock=3,unlock=4,}),write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_cover_position_inverted(3,{name="position_inverted"}),c.dp_enum(4,{
name="mode",emit=f.pims3028Mode(),converter=d.lookup_from_to({
up=0,up_delete=1,remove_up_down=2,}),}),c.dp_enum(5,{
name="control_back",emit=f.pims3028ControlBack(),converter=d.lookup_from_to({forward=0,back=1}),}),c.dp_binary(6,{
name="auto_power",emit=f.pims3028AutoPower(),converter=d.lookup_from_to({off=false,on=true}),}),c.dp_enum(7,{
name="work_state",emit=f.coverWorkPimsActual(),converter=d.from_only(d.lookup_value({
[0]="opening",[1]="closing",[2]="value_123",})),}),c.dp_numeric(10,{
name="time_total",read_only=true,emit=f.pims3028TimeTotal(),}),c.dp_enum(11,{
name="situation_set",read_only=true,emit=f.pims3028SituationSet(),converter=d.from_only(d.lookup_value({
[0]="fully_open",[1]="fully_close",})),}),c.dp_binary(12,{
name="fault",read_only=true,emit=f.pims3028Fault(),
converter=d.from_only(function(i)
return i and"fault"or"normal"
end),
}),c.dp_enum(16,{
name="border",emit=f.pims3028Border(),converter=d.lookup_from_to({
down_delete=0,remove_top_bottom=1,}),}),c.dp_numeric(19,{
name="position_best",emit=f.pims3028PositionBest(),}),c.dp_numeric(21,{
name="angle_horizontal",emit=f.pims3028AngleHorizontal(),}),c.dp_enum(101,{
name="calibration",emit=f.coverCalibrationPims3028StartEnd(),converter=d.lookup_from_to({
start=0,
["end"]=1,
}),}),c.dp_numeric(102,{
name="quick_calibration",emit=f.pims3028QuickCalibration(),}),c.dp_binary(103,{
name="best_position_trigger",emit=f.pims3028BestTrigger(),converter=d.lookup_from_to({off=false,on=true}),}),c.dp_enum(104,{
name="reset",emit=f.pims3028Reset(),converter=d.lookup_from_to({reset=0}),}),}local ai={
profile="covers-cover-battery-rm28-le",c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_numeric(3,{name="position_report",emit=f.coverPositionReportRm28Le()}),c.dp_enum(4,{
name="mode",emit=f.rm28leMode(),converter=d.lookup_from_to({morning=0,night=1}),}),c.dp_enum(5,{
name="reverse_direction",converter=d.lookup_from_to({
forward=0,back=1,}),}),c.dp_binary(6,{
name="auto_power",emit=f.rm28leAutoPower(),converter=d.lookup_from_to({off=false,on=true}),}),c.dp_enum(7,{
name="work_state",emit=f.coverWorkRmOpeningClosing(),converter=d.from_only(d.lookup_value({
[0]="closing",[1]="opening",})),}),c.dp_enum(8,{
name="countdown",emit=f.rm28leCountdown(),converter=d.lookup_from_to({
cancel=0,["1h"]=1,["2h"]=2,["3h"]=3,["4h"]=4,}),}),c.dp_numeric(9,{
name="countdown_left",read_only=true,emit=f.rm28leCountdownLeft(),}),c.dp_numeric(10,{
name="time_total",read_only=true,emit=f.rm28leTimeTotal(),}),c.dp_enum(11,{
name="situation_set",read_only=true,emit=f.rm28leSituationSet(),converter=d.from_only(d.lookup_value({
[0]="fully_open",[1]="fully_close",})),}),c.dp_numeric(12,{
name="motor_fault",read_only=true,emit=f.rm28leMotorFault(),
converter=d.from_only(function(i)
return(tonumber(i)or 0)~=0 and"fault"or"normal"
end),
}),c.dp_battery(13,{emit=f.battery()}),c.dp_enum(16,{
name="border",emit=f.rm28leBorder(),converter=d.lookup_from_to({
up=0,down=1,up_delete=2,down_delete=3,remove_top_bottom=4,}),}),c.dp_numeric(19,{
name="position_best",emit=f.rm28lePositionBest(),}),c.dp_enum(20,{
name="click_control",emit=f.rm28leClickControl(),converter=d.lookup_from_to({up=0,down=1}),}),}local am={
profile="covers-cover-battery-cover-three",c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_cover_position(3,{name="position_report",emit=f.shade_level()}),c.dp_numeric(3,{
name="window_shade_state_report",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_enum(5,{
name="reverse_direction",emit=f.coverThreeReverseDirection(),converter=d.lookup_from_to({forward=0,back=1}),}),c.dp_numeric(12,{
name="motor_fault",read_only=true,emit=f.coverThreeMotorFault(),
converter=d.from_only(function(i)
return(tonumber(i)or 0)~=0 and"fault"or"normal"
end),
}),c.dp_battery(13,{emit=f.battery()}),c.dp_enum(16,{
name="cover_limit",emit=f.coverThreeLimit(),converter=d.lookup_from_to({
set_up=0,set_down=1,delete_up=2,delete_down=3,delete_both=4,}),}),c.dp_enum(20,{
name="click_control",emit=f.coverThreeClickControl(),converter=d.lookup_from_to({up=0,down=1}),}),}local Y={
profile="covers-cover-cover-one",c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_cover_position(3,{name="position_report",emit=f.shade_level()}),c.dp_numeric(3,{
name="window_shade_state_report",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_enum(5,{
name="reverse_direction",emit=f.coverOneReverseDirection(),converter=d.lookup_from_to({forward=0,back=1}),}),c.dp_numeric(105,{
name="motor_speed",emit=f.coverOneMotorSpeed(),}),}
local function K(i,j)
return j.preferences.invertCover and(100-i)or i
end
local q=d.from_to(K,K)
local v=d.from_only(function(i,j)
local position=K(i,j)return position==0 and"closed"or position==100 and"open"or"partially open"
end)
local ap={
profile="covers-rinn-wser40",magic_packet=true,mcu_version_request_on_configure=true,query_on_configure=false,query_on_announce=false,initial_custom_state_query=false,refresh_state_query=false,time_start="off",datapoints={
c.dp_enum(1,{name="cover_state",write_only=true,converter=r}),c.dp_enum(1,{name="cover_action_state",read_only=true,emit=f.shade_state(),
converter=d.from_only(function(i)
return({[0]="open",[1]="closed",[2]="partially open"})[i]
end)}),
c.dp_cover_position(102,{emit=f.shade_level(),converter=q}),c.dp_numeric(102,{name="window_shade_state",read_only=true,emit=f.shade_state(),converter=v}),c.dp_cover_position(103,{name="position_report",read_only=true,emit=f.shade_level(),converter=q}),c.dp_numeric(103,{name="window_shade_state_report",read_only=true,emit=f.shade_state(),converter=v}),},}
local function A(ax,as)
local aw={d.lookup_from_to(ax),d.lookup_from_to(as)}
return d.from_to(function(i,j)
return aw[j.preferences.invertCover and 2 or 1].from(i)
end,function(i,j)
return aw[j.preferences.invertCover and 2 or 1].to(i)
end)
end
local N=d.lookup_from_to({normal=0,reversed=1})local ay={
profile="covers-zm25rx",magic_packet=true,mcu_version_request_on_configure=true,query_on_configure=false,query_on_announce=false,initial_custom_state_query=false,refresh_state_query=false,time_start="off",datapoints={
c.dp_enum(1,{name="cover_state",write_only=true,converter=A({open=0,stop=1,close=2},{open=2,stop=1,close=0})}),c.dp_cover_position(2,{emit=f.shade_level(),converter=q}),c.dp_numeric(2,{name="window_shade_state",read_only=true,emit=f.shade_state(),converter=v}),c.dp_cover_position(3,{name="position_report",read_only=true,emit=f.shade_level(),converter=q}),c.dp_numeric(3,{name="window_shade_state_report",read_only=true,emit=f.shade_state(),converter=v}),c.dp_enum(5,{name="zm25rx_motor_direction",emit=f.zm25rxMotorDirection(),receive_datatypes={4,3},
converter=d.from_to(function(i)
if type(i)=="string"then return i=="back"and"reversed"or"normal"end
return N.from(i)
end,N.to)}),
c.dp_enum(7,{name="zm25rx_motor_state",read_only=true,emit=f.zm25rxMotorState(),converter=A({opening=0,closing=1,stopped=2},{opening=1,closing=0,stopped=2})}),c.dp_battery(13,{read_only=true,emit=f.battery()}),c.dp_enum(101,{name="zm25rx_program",write_only=true,suppress_optimistic_state=true,converter=A({set_bottom=1,set_upper=0,reset=4},{set_bottom=0,set_upper=1,reset=4})}),c.dp_enum(101,{name="zm25rx_click_control",write_only=true,suppress_optimistic_state=true,converter=A({upper=2,upper_micro=5,lower=3,lower_micro=6},{upper=3,upper_micro=6,lower=2,lower_micro=5})}),c.dp_battery(103,{name="battery_report",read_only=true,emit=f.battery()}),},}local u={
from=function(i)
local position=i%256
if position<=100 then return position end
end,
to=function(i)return i end,
}
local x=d.from_only(function(i)
local position=u.from(i)
if position==nil then return nil end
return position==0 and"closed"or position==100 and"open"or"partially open"
end)
local ae={
profile="covers-dream-blinds-tilt",magic_packet=false,mcu_version_request_on_configure=false,query_on_configure=false,query_on_announce=false,initial_custom_state_query=false,refresh_state_query=false,time_start="off",datapoints={
c.dp_enum(1,{name="cover_state",write_only=true,converter=g}),c.dp_cover_position(2,{emit=f.shade_level(),converter=u}),c.dp_numeric(2,{name="window_shade_state",read_only=true,emit=f.shade_state(),converter=x}),c.dp_cover_position(3,{name="position_report",read_only=true,emit=f.shade_level(),converter=u}),c.dp_numeric(3,{name="window_shade_state_report",read_only=true,emit=f.shade_state(),converter=x}),c.dp_enum(5,{
name="dream_blinds_reverse_direction",write_only=true,emit=f.dreamBlindsReverseDirection(),converter=d.lookup_from_to({forward=0,back=1}),}),c.dp_numeric(105,{name="dream_blinds_motor_speed",emit=f.dreamBlindsMotorSpeed()}),c.dp_numeric(21,{
name="cover_tilt",emit=f.shade_tilt_level(),converter={
from=function(i)return math.floor(math.min(180,i)*100/180+0.5)end,
to=function(i)return math.min(180,math.max(0,math.floor(i*180/100+0.5)))end,
},}),c.dp_numeric(21,{
name="dream_blinds_flip_angle",emit=f.dreamBlindsFlipAngle(),converter={
from=function(i)return math.min(180,i)end,
to=function(i)return math.min(180,math.max(0,math.floor(i+0.5)))end,
},}),},}local U={
profile="covers-cover-zm79e-dt",c.dp_enum(1,{
name="cover_state",converter=s,write_only=true,}),c.dp_cover_position_inverted(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=h(),read_only=true,}),c.dp_cover_position_inverted(3,{name="position_report",emit=f.coverPositionReportZm79eDt()}),c.dp_enum(4,{
name="opening_mode",emit=f.zm79eOpeningMode(),converter=d.lookup_from_to({tilt=0,lift=1}),}),c.dp_enum(7,{
name="work_state",emit=f.coverWorkStateZm79eDtLearning(),converter=d.from_only(d.lookup_value({
[0]="standby",[1]="success",[2]="learning",})),}),c.dp_enum(101,{
name="motor_direction",emit=f.motorDirectionZm79eDtLeftRight(),converter=d.lookup_from_to({
left=0,right=1,}),}),c.dp_enum(102,{
name="set_upper_limit",emit=f.zm79eSetUpperLimit(),converter=d.lookup_from_to({stop=0,start=1}),}),c.dp_enum(107,{
name="factory_reset",emit=f.zm79eFactoryReset(),converter=d.lookup_from_to({set=0}),}),}local S={
profile="covers-cover-bx82-tyz1",c.dp_enum(1,{
name="cover_state",converter=s,write_only=true,}),c.dp_cover_position(2,{emit=f.shade_level()}),c.dp_numeric(2,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_numeric(3,{name="position_report",emit=f.coverPositionReportBx82Tyz1()}),c.dp_enum(5,{
name="motor_direction",emit=f.motorDirectionBxTyzNormalRev(),converter=d.lookup_from_to({normal=0,reversed=1}),}),}local ab={
profile="covers-cover-battery-mb60l",c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position_inverted(9,{emit=f.shade_level()}),c.dp_numeric(9,{
name="window_shade_state",emit=f.shade_state(),converter=h(),read_only=true,}),c.dp_enum(11,{
name="motor_direction",emit=f.motorDirectionMbNormalRev(),converter=d.lookup_from_to({normal=0,reversed=1}),}),c.dp_battery(13,{emit=f.battery()}),c.dp_enum(16,{
name="set_limits",emit=f.mb60lSetLimits(),converter=d.lookup_from_to({up=0,down=1,reset=2}),}),c.dp_binary(101,{
name="child_lock",emit=f.mb60lChildLock(),converter=d.lookup_from_to({off=false,on=true}),}),c.dp_binary(103,{
name="tilt_mode",emit=f.tiltModeMb60l(),converter=d.lookup_from_to({on=true,off=false}),}),}local ak={
profile="covers-cover-battery-epj-zb",c.dp_enum(102,{
name="cover_state",converter=r,command_id=c.SEND_DATA,write_only=true,}),c.dp_cover_position(104,{
command_id=c.SEND_DATA,emit=f.shade_level(),}),c.dp_numeric(104,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),c.dp_battery(4,{emit=f.battery()}),c.dp_binary(105,{name="charge_state"}),c.dp_enum(106,{
name="manual_mode",emit=f.manualModeEpjZbEnableDisable(),converter=d.lookup_from_to({
enable=0,disable=1,}),}),c.dp_enum(107,{
name="fault",converter=d.lookup_from_to({
Normal=0,None=1,Fault=2,}),}),c.dp_numeric(108,{name="countdown"}),c.dp_enum(109,{
name="motor_direction",emit=f.motorDirectionEpjZbSide(),converter=d.lookup_from_to({
right_side=0,left_side=1,}),}),c.dp_enum(110,{
name="mode",converter=d.lookup_from_to({
Disable=0,Enable=1,}),}),c.dp_enum(112,{
name="fixed_window_sash",converter=d.lookup_from_to({
Down=0,Up=1,}),}),c.dp_enum(114,{
name="window_detection",emit=f.windowDetectionEpjZbState(),converter=d.lookup_from_to({
opened=0,closed=1,pending=2,}),}),}
local E=d.from_to(function(i,j)
return j.preferences.reverse==true and(100-i)or i
end,function(i,j)
return j.preferences.reverse==true and(100-i)or i
end)
local C=d.from_only(function(i,j)
local position=E.from(i,j)
if position<=0 then return"closed"end
if position>=100 then return"open"end
return"partially open"
end)
local af={
profile="covers-ts0301-one",query_on_configure=false,time_start="off",c.dp_enum(1,{name="cover_state",converter=g,write_only=true}),c.dp_enum(1,{name="cover_action_state",converter=t,read_only=true,emit=f.shade_state()}),c.dp_cover_position(2,{emit=f.shade_level(),converter=E}),c.dp_numeric(2,{name="window_shade_command_state",converter=C,read_only=true,emit=f.shade_state()}),c.dp_numeric(3,{name="cover_position_state",converter=E,read_only=true,emit=f.shade_level()}),c.dp_numeric(3,{name="window_shade_state",converter=C,read_only=true,emit=f.shade_state()}),c.dp_enum(5,{name="ts0301_direction",converter=d.lookup_from_to({forward=0,back=1}),emit=f.ts0301Direction()}),c.dp_battery(13,{emit=f.battery()}),}
local function y(l,Z,j)
if type(Z)=="table"then Z=Z.value end
if Z>100 then return end
if l=="shade2"then return Z<50 and 0 or(Z-50)*2 end
if l=="shade3"then
local az=Z>50 and 0 or Z*2
return j.preferences.invertTopRail==true and 100-az or az
end
return Z
end
local function z(l)
return function(j,_,i)
local T=al.WindowCovering.server.commands
if i=="stop"then j:send(T.Stop(j):to_endpoint(1));return true end
if l=="main"and type(i)=="string"then
if i=="open"then j:send(T.UpOrOpen(j):to_endpoint(1))elseif i=="close"then j:send(T.DownOrClose(j):to_endpoint(1))
else return false end
return true
end
if i=="open"then i=100 elseif i=="close"then i=0 end
if type(i)~="number"then return false end
local at=i
if l=="shade2"then at=i==0 and 0 or 50+i/2
elseif l=="shade3"then at=(j.preferences.invertTopRail==true and 100-i or i)/2 end
j:send(T.GoToLiftPercentage(j,math.floor(math.max(0,math.min(100,at))+0.5)):to_endpoint(1))return true
end
end
local p={
profile="covers-ts0301-combined-rail",magic_packet=false,query_on_configure=false,time_start="off",zcl_clusters={au.battery({read_only=true})},
configure=function(av,j)
j:send(ad.build_bind_request(j,258,av.environment_info.hub_zigbee_eui,1))
end,
}
local function P(j,Z)
for _,l in ipairs({"main","shade2","shade3"})do
local position=y(l,Z,j)if position~=nil then
j:emit_component_event(j.profile.components[l],f.shade_level()(j,position))j:emit_component_event(j.profile.components[l],f.shade_state()(j,position==0 and"closed"or"open"))
end
end
end
for _,l in ipairs({"main","shade2","shade3"})do
local aj=function(i,j)return y(l,i,j)end
p.zcl_clusters[#p.zcl_clusters+1]=au.cover_position({
endpoint=1,component=l,sender=z(l),from_device=aj,emit=P,read_only=false,write_only=l~="main",read_on_configure=false,minimum_interval=1,maximum_interval=65000,reportable_change=1,})p.zcl_clusters[#p.zcl_clusters+1]=au.cover_state({
endpoint=1,component=l,sender=z(l),read_only=false,})
end
local X={
profile="covers-cover",c.dp_enum(1,{
name="cover_state",converter=g,write_only=true,}),c.dp_cover_position(2,{
write_only=true,}),c.dp_numeric(3,{
name="cover_position_state",emit=f.shade_level(),read_only=true,}),c.dp_numeric(3,{
name="window_shade_state",emit=f.shade_state(),converter=e(),read_only=true,}),}local Q={
profile="covers-ts0301-dual-rail",query_on_configure=false,time_start="off",c.dp_battery(13,{emit=f.battery()}),c.dp_enum(109,{
name="cover_state",component="main",converter=r,write_only=true,}),c.dp_cover_position_inverted(101,{
component="main",emit=f.shade_level(),}),c.dp_numeric(102,{
name="cover_position_state",component="main",emit=f.shade_level(),converter=d.cover_position_inverted(),read_only=true,}),c.dp_numeric(102,{
name="window_shade_state",component="main",emit=f.shade_state(),converter=h(),read_only=true,}),c.dp_enum(1,{
name="cover_state",component="shade2",converter=w,write_only=true,}),c.dp_cover_position(2,{
component="shade2",emit=f.shade_level(),}),c.dp_numeric(3,{
name="cover_position_state",component="shade2",emit=f.shade_level(),read_only=true,}),c.dp_numeric(3,{
name="window_shade_state",component="shade2",emit=f.shade_state(),converter=e(),read_only=true,}),}a(Y,b.create_fingerprints("TS0601",{
"_TZE200_bqcqqjpb","_TZE200_gaj531w3","_TZE284_gaj531w3","_TZE200_en3wvcbx","_TZE200_g5wdnuow","_TZE200_udank5zs","_TZE200_nv6nxo0c","_TZE200_3ylew7b4","_TZE200_llm0epxg","_TZE200_n1aauwb4","_TZE200_bjzrowv2","_TZE204_bjzrowv2","_TZE284_bjzrowv2","_TZE204_guvc7pdy","_TZE204_57hjqelq","_TZE204_vvvtcehj","_TZE28C1000000_vvvtcehj","_TZE200_axgvo9jh","_TZE200_zxxfv8wi","_TZE204_lh3arisb","_TZE204_zuq5xxib","_TZE284_zuq5xxib","_TZE200_nueqqe6k","_TZE200_1fuxihti","_TZE204_1fuxihti","_TZE284_1fuxihti","_TZE28C1000000_1fuxihti","_TZE200_5zbp6j0u","_TZE200_nkoabg8w","_TZE200_4vobcgd3","_TZE284_4vobcgd3","_TZE200_m6lwazh9","_TZE200_swlgvdlh","_TZE200_fdtjuw7u","_TZE200_rmymn92d","_TZE200_feolm6rk","_TZE200_tvrvdj6o","_TZE200_b2u1drdv","_TZE200_ol5jlkkr","_TZE204_a2jcoyuk","_TZE200_yia0p3tr","_TZE200_rsj5pu8y","_TZE200_yrugsphv","_TZE204_yrugsphv","_TZE200_odlldrxx","_TZE204_odlldrxx","_TZE200_7shyddj3","_TZE284_udank5zs","_TZE284_b7kbnl6q","_TZE204_dpqsvdbi","_TZE204_ic7jtutb","_TZE204_m1wl5fvq","_TZE204_nladmfvf","_TZE204_tgl8i2np","_TZE200_2jwrgrro",}))a(Y,{
b.create_fingerprint("HOBEIAN","ZG-301Z-MOTO"),{manufacturer="_TYST11_fzo2pocs",model="zo2pocs"..string.char(0)},{manufacturer="_TYST11_udank5zs",model="dank5zs"..string.char(0)},})a(Y,{
b.create_fingerprint("Yushun","YS-MT750"),b.create_fingerprint("Yushun","YS-MT750L"),b.create_fingerprint("Zemismart","ZM79E-DT"),b.create_fingerprint("Binthen","BCM100D"),b.create_fingerprint("Binthen","CV01A"),b.create_fingerprint("Zemismart","M515EGB"),b.create_fingerprint("Oz Smart Things","ZM85EL-1Z"),b.create_fingerprint("Tuya","M515EGZT"),b.create_fingerprint("Tuya","DT82LEMA-1.2N"),b.create_fingerprint("Tuya","ZD82TN"),b.create_fingerprint("Larkkey","ZSTY-SM-1SRZG-EU"),b.create_fingerprint("Zemismart","AM43"),b.create_fingerprint("A-OK","AM25"),b.create_fingerprint("Alutech","AM/R-Sm"),b.create_fingerprint("Roximo","CRTZ01"),b.create_fingerprint("Quoya","AT8510-TY"),b.create_fingerprint("Somgoms","ZSTY-SM-1DMZG-US-W_1"),b.create_fingerprint("HUARUI","CMD900LE"),b.create_fingerprint("Novato","WPK"),b.create_fingerprint("Zemismart","ZMS1-TYZ"),})a(n,b.create_fingerprints("TS0601",{
"_TZE200_eegnwoyw","_TZE200_fu14oapz",}))a(n,b.create_fingerprints("TS0105",{
"_TZE600_ogyg1y6b",}))a(am,b.create_fingerprints("TS0601",{
"_TZE200_68nvbio9","_TZE200_pw7mji0l","_TZE200_cf1sl3tj","_TZE200_nw1r9hp6","_TZE200_9p5xmj5r","_TZE200_eevqq1uv","_TZE204_ejh6owwz","_TZE200_ba69l9ol","_TZE200_68nvbi09","_TZE284_n73badib","_TZE200_vexa5o82","_TZE200_sfqyhvpv",}))a(n,{
b.create_fingerprint("Zemismart","ZM16EL-03/33"),b.create_fingerprint("Zemismart","ZM25EL"),b.create_fingerprint("Zemismart","ZM85EL-2Z"),b.create_fingerprint("Hiladuo","B09M3R35GC"),b.create_fingerprint("Tuya","MYQ-RM25-1.3/25-BZ"),b.create_fingerprint("Shaman","25EB-1/30-TYZ"),})a(n,b.create_fingerprints("TS0601",{
"_TZE200_zah67ekd","_TZE200_icka1clh",}))a(ah,b.create_fingerprints("TS130F",{
"_TZE20C_xbexmf8h",}))a(n,{
b.create_fingerprint("Moes","AM43-0.45/40-ES-EB"),})a(n,b.create_fingerprints("TS0601",{
"_TZE200_5sbebbzs","_TZE200_hsgrhjpf","_TZE200_ergbiejo","_TZE200_nhyj64w2","_TZE200_127x7wnl","_TZE204_5slehgeo","_TZE284_5slehgeo","_TZE200_fctwhugx","_TZE200_p6vz3wzt","_TZE204_p6vz3wzt","_TZE284_uqfph8ah","_TZE284_waa352qv",}))a(n,{
b.create_fingerprint("Homeetec","37022483"),})a(aq,b.create_fingerprints("TS0601",{
"_TZE200_cpbo62rn","_TZE200_libht6ua","_TZE284_libht6ua",}))a(n,b.create_fingerprints("TS0601",{
"_TZE200_zvo63cmo",}))a(k,b.create_fingerprints("TS0601",{
"_TZE204_r0jdjrvi","_TZE200_r0jdjrvi","_TZE200_g5xqosu7","_TZE204_g5xqosu7","_TZE200_fzo2pocs","_TZE284_fzo2pocs","_TZE200_9vpe3fl1","_TZE28C1000000_alh14edn",}))a(k,{
b.create_fingerprint("Tuya","TS0601_alh14edn"),})a(ay,b.create_fingerprints("TS0601",{
"_TZE200_7eue9vhc","_TZE200_bv1jcqqu","_TZE200_wehza30a",}))a(n,b.create_fingerprints("TS0601",{
"_TZE200_p2qzzazi",}))a(k,b.create_fingerprints("TS0601",{
"_TZE204_xu4a5rhj","_TZE200_xu4a5rhj","_TZE204_q9xty0ad",}))a(n,b.create_fingerprints("TS0601",{
"_TZE200_1vxgqfba","_TZE200_wdfurkoa","_TZE200_sq6affpe","_TZE284_wdfurkoa","_TZE284_6fopvb6v",}))a(n,b.create_fingerprints("TS0601",{
"_TZE200_gubdgai2","_TZE200_vdiuwbkq",}))a(n,b.create_fingerprints("TS0601",{
"_TZE200_yenbr4om","_TZE204_bdblidq3","_TZE200_bdblidq3",}))a(n,b.create_fingerprints("TS0601",{
"_TZE200_mlglxwp3",}))a(aa,b.create_fingerprints("TS0601",{
"_TZE200_a8z0g46u","_TZE204_a8z0g46u",}))a(L,b.create_fingerprints("TS0601",{
"_TZE284_3mzb0sdz","_TZE2841000000_3mzb0sdz",}))a(ac,b.create_fingerprints("TS0601",{
"_TZE284_zofmmt9s",}))a(k,b.create_fingerprints("TS0601",{
"_TZE200_2odrmqwq","_TZE200_hojryzzd",}))a(ar,b.create_fingerprints("TS0601",{
"_TZE200_clm4gdw4","_TZE200_2vfxweng","_TZE200_gnw1rril","_TZE204_ycke4deo","_TZE284_clm4gdw4",}))a(W,b.create_fingerprints("TS0601",{
"_TZE200_cowvfni3",}))a(O,b.create_fingerprints("TS0601",{
"_TZE200_rddyvrci",}))a(B,b.create_fingerprints("TS0601",{
"_TZE284_r3szw0xr",}))a(k,b.create_fingerprints("TS0601",{
"_TZE200_wmcdj3aq","_TZE200_xuzcvlku","_TZE200_xaabybja","_TZE200_zuz7f94z","_TZE200_3i3exuay","_TZE200_nogaemzt","_TZE200_dng9fn0k","_TZE200_zpzndjez",}))a(F,b.create_fingerprints("TS0601",{
"_TZE200_jhkttplm",}))a(F,{
b.create_fingerprint("Homeetec","37022493"),})a(G,b.create_fingerprints("TS0601",{
"_TZE200_5nldle7w",}))a(G,{
b.create_fingerprint("Homeetec","37022173"),})a(J,b.create_fingerprints("TS0601",{
"_TZE204_trwaxi57",}))a(ag,b.create_fingerprints("TS0601",{
"_TZE200_iossyxra","_TZE200_cxu0jkjk",}))a(V,b.create_fingerprints("TS0601",{
"_TZE200_eqpaxqdv",}))a(ai,b.create_fingerprints("TS0601",{
"_TZE200_fodv6bkr",}))a(ak,{
b.create_fingerprint("_TZ3210_emqmwtym","TS0601"),})a(U,b.create_fingerprints("TS0601",{
"_TZE200_ax8a8ahx",}))a(S,b.create_fingerprints("TS0601",{
"_TZE204_2rvvqjoa",}))a(ab,b.create_fingerprints("TS0601",{
"_TZE284_2gi1hy8s","_TZE2841000000_2gi1hy8s",}))a(an,b.create_fingerprints("TS0601",{
"_TZE200_zyrdrmno","_TZE200_osmxri8y",}))a(af,b.create_fingerprints("TS0301",{
"_TZE210_m6lwazh9",}))a(p,b.create_fingerprints("TS0301",{
"_TZE200_eatmkx5j",}))a(X,{
b.create_fingerprint("Yoolax","Day-Night Shade"),})a(Q,b.create_fingerprints("TS0301",{
"_TZE210_inpjmc0h","_TZE210_yqwse3h5",}))a(ae,{
b.create_fingerprint("_TZE204_wzre8hu2","TS0601"),})a(ap,{
b.create_fingerprint("_TZE200_pk0sfzvr","TS0601"),})au.attach_reporting_capabilities(H,{
{48,"rpt-trw"},})return{
id="ef00.covers",registrations=H,}
