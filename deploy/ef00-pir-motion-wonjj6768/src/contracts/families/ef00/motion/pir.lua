local c=require"protocol.tuya"
local b=require"capabilities.events.all"
local aG=require"contracts.helpers.family"
local bd=require"contracts.helpers.ef00"
local e=c.converter
local p=e.lookup_from_to({
[1]=0,[2]=1,[3]=2,})local o=e.lookup_from_to({
[1]=1,[3]=0,},0)local D=e.lookup_from_to({
[10]=0,[30]=1,[60]=2,[120]=3,})local k=e.lookup_from_to({
low=0,medium=1,high=2,})local n=e.lookup_from_to({
["10"]=0,["30"]=1,["60"]=2,["120"]=3,})local x=e.lookup_from_to({
high=0,low=1,})local A=e.lookup_from_to({
arm=0,silent=1,disarm=2,})local s=e.lookup_from_to({
speed_priority=0,normal_priority=1,accuracy_priority=2,})local r=e.lookup_from_to({
sensitive=0,normal=1,cautious=2,})local I=e.lookup_from_to({
general_model=0,temporaty_stay=1,basic_detection=2,sensor_test=3,})local y=e.lookup_from_to({
ON=0,OFF=1,})local w=e.lookup_from_to({
low=0,middle=1,high=2,})local z=e.from_only(e.lookup_value({
[0]="presence",[1]="none",[2]="presence_5min",[3]="presence_30min",[4]="none_5min",[5]="none_30min",}))local B=e.lookup_from_to({
[15]=0,[30]=1,[60]=2,})local v=e.lookup_from_to({
on=true,off=false,})local L=v
local i=e.lookup_from_to({
on=1,off=0,})local J=e.lookup_from_to({
on=0,off=1,})local K=e.lookup_from_to({
standard=0,["local"]=1,})local aa=e.lookup_from_to({
only_pir=0,pir_and_radar=1,only_radar=2,})local aU=e.lookup_from_to({
default=0,area=1,toilet=2,bedroom=3,parlour=4,office=5,hotel=6,})local aV=e.lookup_from_to({
default=0,bathroom=1,bedroom=2,sleeping=3,unknown=4,})local G=e.lookup_from_to({
only_move=0,exist_move=1,})local F=e.lookup_from_to({
on=0,off=1,occupied=2,unoccupied=3,})local ad=e.lookup_from_to({
off=0,all=1,ch1=1,ch2=2,ch3=3,ch1_2=4,ch2_3=5,ch1_3=6,})local M=e.lookup_from_to({
off=0,all=1,ch1=1,ch2=2,ch3=3,ch1_and_ch2=4,ch2_and_ch3=5,ch1_and_ch3=6,})local T=e.lookup_from_to({
ch1=0,ch2=1,ch3=2,})local ag,d=aG.definition_registry()
local function aX(l)
local j={}if type(l)=="table"then
for bL,X in pairs(l)do
j[bL]=X
end
end
return j
end
local function ax(l,bG,bI)
local j=aX(l)j.name=j.name or bG
j.emit=j.emit or bI
return j
end
local function C(l)
return l.converter~=nil or l.from_device~=nil or l.to_device~=nil or l.lookup~=nil
end
local function a(bB,bG,aD,H)
return function(dp,l)
local j=ax(l,bG,aD())if H~=nil and not C(j)then
j.converter=H
end
return bB(dp,j)
end
end
local az=a(c.dp_numeric,"presence_sensitivity",b.presence_sensitivity)local Z=a(c.dp_pir_sensitivity,"presence_sensitivity",b.presence_sensitivity,p)local aw=a(c.dp_enum,"presence_sensitivity",b.presence_sensitivity,o)local aC=a(c.dp_static_detection_sensitivity,"presence_sensitivity",b.presence_sensitivity)local aB=a(c.dp_motion_detection_sensitivity,"presence_sensitivity",b.presence_sensitivity)local aM=a(c.dp_numeric,"presence_detection_range",b.presence_detection_range)local aq=a(c.dp_static_detection_distance,"presence_detection_range",b.presence_detection_range)local bj=a(c.dp_fading_time,"presence_fading_time",b.presence_fading_time)local aN=a(c.dp_target_distance,"presence_target_distance",b.presence_target_distance)local at=a(c.dp_numeric,"presence_illuminance_threshold",b.presence_illuminance_threshold)local bw=a(c.dp_binary,"light_switch",b.light_switch,v)local ar=a(c.dp_enum,"presence_illuminance_switch",b.presence_illuminance_switch,i)local bq=a(c.dp_enum,"light_linkage",b.light_linkage,i)local bv=a(c.dp_enum,"breaker_mode",b.breaker_mode,K)local bp=a(c.dp_enum,"breaker_status",b.breaker_status,i)local ba=a(c.dp_enum,"sensor_state_mode",b.sensor_state_mode,F)local bb=a(c.dp_enum,"status_indication",b.status_indication,i)local aH=a(c.dp_motion_detection_mode,"motion_detection_mode",b.motion_detection_mode)local bz=a(c.dp_enum,"radar_scene",b.radar_scene)local bf=a(c.dp_enum,"detection_method",b.detection_method,G)local bx=a(c.dp_binary,"radar_switch",b.radar_switch,L)local bs=a(c.dp_enum,"tumble_switch",b.tumble_switch,J)local an=a(c.dp_static_detection_sensitivity,"static_detection_sensitivity",b.static_detection_sensitivity)local am=a(c.dp_motion_detection_sensitivity,"motion_detection_sensitivity",b.motion_detection_sensitivity)local bi=a(c.dp_numeric,"move_sensitivity",b.move_sensitivity)local bh=a(c.dp_numeric,"keep_sensitivity",b.keep_sensitivity)local aQ=a(c.dp_numeric,"trigger_sensitivity",b.trigger_sensitivity)local aZ=a(c.dp_numeric,"entry_sensitivity",b.entry_sensitivity)local bg=a(c.dp_numeric,"fall_sensitivity",b.fall_sensitivity)local bc=a(c.dp_numeric,"tumble_alarm_time",b.tumble_alarm_time)local R=a(c.dp_numeric,"large_motion_detection_sensitivity",b.large_motion_detection_sensitivity)local P=a(c.dp_numeric,"medium_motion_detection_sensitivity",b.medium_motion_detection_sensitivity)local S=a(c.dp_numeric,"small_motion_detection_sensitivity",b.small_motion_detection_sensitivity)local aF=a(c.dp_numeric,"small_move_sensitivity",b.small_move_sensitivity)local aR=a(c.dp_numeric,"breath_sensitivity",b.breath_sensitivity)local ab=a(c.dp_numeric,"large_motion_detection_distance",b.large_motion_detection_distance)local Y=a(c.dp_numeric,"medium_motion_detection_distance",b.medium_motion_detection_distance)local ac=a(c.dp_numeric,"small_motion_detection_distance",b.small_motion_detection_distance)local ao=a(c.dp_numeric,"move_detection_max_distance",b.move_detection_max_distance)local ap=a(c.dp_numeric,"move_detection_min_distance",b.move_detection_min_distance)local V=a(c.dp_numeric,"small_move_detection_max_distance",b.small_move_detection_max_distance)local W=a(c.dp_numeric,"small_move_detection_min_distance",b.small_move_detection_min_distance)local ah=a(c.dp_numeric,"breath_detection_max_distance",b.breath_detection_max_distance)local ai=a(c.dp_numeric,"breath_detection_min_distance",b.breath_detection_min_distance)local br=a(c.dp_numeric,"minimum_range",b.minimum_range)local bm=a(c.dp_numeric,"detection_delay",b.detection_delay)local bF=a(c.dp_keep_time,"keep_time",b.keep_time,D)local Q=a(c.dp_numeric,"presence_delay",b.presence_delay)local aP=a(c.dp_enum,"presence_delay",b.presence_delay,B)local U=a(c.dp_numeric,"presence_time",b.presence_time)local bl=a(c.dp_numeric,"detection_cycle",b.detection_cycle)local av=a(c.dp_numeric,"illuminance_threshold_min",b.illuminance_threshold_min)local by=a(c.dp_numeric,"shield_range",b.shield_range)local aY=a(c.dp_numeric,"entry_filter_time",b.entry_filter_time)local as=a(c.dp_numeric,"entry_distance_indentation",b.entry_distance_indentation)local bE=a(c.dp_numeric,"block_time",b.block_time)
local function g(aJ,aI,bH,be)
local aE={
minimum=aJ,maximum=aI,step=bH,}if type(be)=="string"and be~=""then
aE.unit=be
end
return aE
end
local function af(aJ,aI,bH,O,be)
local aE=g(aJ,aI,bH,be)if type(O)=="table"then
aE.allowed_values=O
end
return aE
end
local function bD(bM)
return{
allowed_values=bM,}
end
local bK={"on","off"}local bo={"standard","local"}local aW={"on","off","occupied","unoccupied"}
local function aL(h,t,bC)
local E=true
if type(h)=="table"and h.query_on_configure~=nil then
E=h.query_on_configure
end
if type(bC)=="table"then
d({
datapoints=h,presence_capability_ranges=bC,query_on_configure=E,},t)return
end
if type(h)=="table"then
local aS={}for bL,X in pairs(h)do
aS[bL]=X
end
if aS.query_on_configure==nil then
aS.query_on_configure=true
end
d(aS,t)return
end
d({
datapoints=h,query_on_configure=true,},t)
end
local function f(aj)
return bd.ts0601_fingerprints(aj)
end
local N=g(1,3,1)local bk={
minimum=10,maximum=120,step=1,unit="s",allowed_values={10,30,60,120},}local aO=g(1,10,1)local aA=g(1,10,1)local ae=g(0.75,9.0,0.75,"m")local ay=g(1,1500,1,"s")local au=g(1,15000,1,"s")
local function bu()
return{
emit=b.humidity(),scale=1,}
end
local bn=e.from_only(function(X)
local ak=tonumber(X)return ak~=nil and ak~=0
end)
local aT=e.from_only(function(X)
return tonumber(X)==1
end)
local bN={
profile="safety-motion-pir-illuminance-battery",datapoints={
c.dp_occupancy(1,{emit=b.motion(),read_only=true}),c.dp_battery(4,{emit=b.battery(),read_only=true}),c.dp_illuminance(101,{emit=b.illuminance(),read_only=true}),},query_on_configure=false,respond_to_mcu_version_response=true,}local u=f({
"_TZE200_f1pvdgoh","_TZE200_me6wtiqs",})u[#u+1]={
manufacturer="_TZE200_f1pvdgoh",model=string.char(0).."B",}d(bN,u)local aK={
profile="safety-motion-pir-illuminance",datapoints={
c.dp_occupancy(1,{emit=b.motion(),read_only=true}),c.dp_illuminance(101,{emit=b.illuminance(),read_only=true}),},query_on_configure=false,respond_to_mcu_version_response=true,}d(aK,f({
"_TZE200_ghynnvos",}))local al={
profile="safety-motion-zg204zl-keep-illuminance-battery",datapoints={
c.dp_occupancy(1,{emit=b.motion(),read_only=true}),c.dp_battery(4,{emit=b.battery(),read_only=true}),c.dp_enum(9,{
name="sensitivity",emit=b.zg204zlSensitivity(),converter=k,}),c.dp_enum(10,{
name="keep_time",emit=b.zg204zlKeepTime(),converter=n,}),c.dp_illuminance(12,{emit=b.illuminance(),read_only=true}),c.dp_numeric(102,{
name="illuminance_interval",emit=b.zg204zlIlluminanceInterval(),}),},query_on_configure=false,}d(al,f({
"_TZE200_3towulqd","_TZE200_1ibpyhdc","_TZE200_bh3n6gk8","_TZE200_ttcovulf","_TZE200_gjldowol","_TZE200_jxyhl4eq","_TZE200_qxyh4r7g","_TZE200_na5qlzow",}))local q={
profile="safety-motion-zg204zl-keep-illuminance-battery",datapoints={
c.dp_occupancy(1,{emit=b.motion(),read_only=true}),c.dp_battery(4,{emit=b.battery(),read_only=true}),c.dp_enum(9,{
name="sensitivity",emit=b.zg204zlSensitivity(),converter=k,}),c.dp_enum(10,{
name="keep_time",emit=b.zg204zlKeepTime(),converter=n,}),c.dp_illuminance(101,{emit=b.illuminance(),read_only=true}),c.dp_numeric(102,{
name="illuminance_interval",emit=b.zg204zlIlluminanceInterval(),}),},query_on_configure=false,}d(q,f({
"_TZE200_s6hzw8g2",}))local m={
c.dp_occupancy(1,{emit=b.motion(),read_only=true}),c.dp_battery(4,{emit=b.battery(),read_only=true}),c.dp_illuminance(101,{emit=b.illuminance(),read_only=true}),}d({
profile="safety-motion-zpir10-illuminance-battery",datapoints=m,query_on_configure=false,},f({
"_TZE200_ppuj1vem",}))d({
profile="safety-motion-zpir10-illuminance-battery",datapoints=m,query_on_configure=false,respond_to_mcu_version_response=true,},f({
"_TZE200_oc7xqqbs",}))local bA={
profile="safety-motion-pir-solar-battery",datapoints={
c.dp_occupancy(1,{emit=b.motion(),read_only=true}),c.dp_battery(4,{emit=b.battery(),read_only=true}),c.dp_numeric(9,{
name="pir_sensitivity",emit=b.tre6haifPirSensitivity(),converter=x,}),c.dp_numeric(101,{
name="alarm_time",emit=b.tre6haifAlarmTime(),}),c.dp_enum(102,{
name="alarm_mode",emit=b.tre6haifAlarmMode(),converter=A,}),},query_on_configure=false,}d(bA,f({
"_TZE284_tre6haif",}))local bt={
profile="safety-motion-legacy-illuminance",datapoints={
c.dp_occupancy(1,{
emit=b.motion(),converter=e.true_false1(),read_only=true,}),c.dp_enum(101,{
name="v_sensitivity",emit=b.auin8mzrVSensitivity(),converter=s,}),c.dp_enum(102,{
name="o_sensitivity",emit=b.auin8mzrOSensitivity(),converter=r,}),c.dp_numeric(103,{
name="vacancy_delay",emit=b.auin8mzrVacancyDelay(),}),c.dp_enum(104,{
name="mode",emit=b.auin8mzrMode(),converter=I,}),c.dp_numeric(105,{
name="vacant_confirm_time",emit=b.auin8mzrVacantConfirmTime(),read_only=true,}),c.dp_numeric(106,{
name="reference_luminance",emit=b.auin8mzrReferenceLuminance(),read_only=true,}),c.dp_numeric(107,{
name="light_on_luminance_prefer",emit=b.auin8mzrLightOnLuminance(),}),c.dp_numeric(108,{
name="light_off_luminance_prefer",emit=b.auin8mzrLightOffLuminance(),}),c.dp_numeric(109,{
name="luminance_level",emit=b.auin8mzrLuminanceLevel(),read_only=true,}),c.dp_enum(110,{
name="led_status",emit=b.auin8mzrLedStatus(),converter=y,}),},magic_packet=false,query_on_configure=false,}d(bt,f({
"_TZE200_auin8mzr",}))local bJ={
profile="safety-motion-bed-time-illuminance-battery",datapoints={
c.dp_occupancy(1,{emit=b.motion(),read_only=true}),c.dp_battery(4,{emit=b.battery(),read_only=true}),c.dp_enum(9,{
name="sensitivity",emit=b.seq9cm6uSensitivity(),converter=w,}),c.dp_illuminance(12,{emit=b.illuminance(),read_only=true}),c.dp_numeric(101,{
name="interval_time",emit=b.seq9cm6uIntervalTime(),}),Q(102),U(103),c.dp_enum(104,{
name="work_state",emit=b.seq9cm6uWorkState(),converter=z,read_only=true,}),},presence_capability_ranges={
presence_delay=g(0,3600,1,"s"),presence_time=g(0,3600,1,"s"),},query_on_configure=false,}d(bJ,f({
"_TZE200_seq9cm6u",}))return{
id="ef00.motion.pir",registrations=ag,}
