local W=require"st.capabilities"
local b=require"protocol.tuya"
local c=require"capabilities.events.all"
local Y=require"protocol.zcl"
local f=require"contracts.helpers.family"
local T=require"contracts.helpers.ef00_presence"
local a=b.converter
local x,i=T.isolated_definition_registry(f.definition_registry)
local function d(N,Q,X)
return T.register_presence_definition(
i,N,Q,X)
end
local e=T.ts0601_fingerprints
local n=a.lookup_from_to({on=1,off=0})local m=a.lookup_from_to({standard=0,["local"]=1})local E=a.lookup_from_to({
default=0,bathroom=1,bedroom=2,sleeping=3,unknown=4,})local A=a.lookup_from_to({only_move=0,exist_move=1})local h=a.lookup_from_to({
on=0,off=1,occupied=2,unoccupied=3,})local B={
profile="safety-presence-zym10024g-illuminance",package_group="presence-advanced",named_datapoints=true,b.dp_numeric(102,{name="illuminance_threshold_max"}),b.dp_numeric(103,{name="illuminance_threshold_min"}),b.dp_illuminance(104,{emit=c.illuminance()}),b.dp_enum(105,{
name="state",read_only=true,emit=c.zym10024gState(),converter=a.lookup_from_to({
none=0,presence=1,move=2,}),}),b.dp_numeric(106,{
name="move_sensitivity",emit=c.zym10024gMoveSensitivity(),converter=a.divide_by_from_only(10),}),b.dp_numeric(107,{
name="max_range",emit=c.zym10024gMaxRange(),converter=a.divide_by_pair(100),}),b.dp_numeric(109,{
name="target_distance",read_only=true,emit=c.zym10024gTargetDistance(),converter=a.divide_by_from_only(100),}),b.dp_numeric(110,{name="presence_timeout",emit=c.zym10024gTimeout()}),b.dp_numeric(111,{
name="presence_sensitivity",emit=c.zym10024gSensitivity(),converter=a.divide_by_from_only(10),}),b.dp_presence(112,{emit=c.presence(),converter=a.true_false1()}),}d(B,e({
"_TZE204_ijxvkhd0",}))local u={
profile="safety-presence-zym10024gv2-move-range-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_enum(1,{
name="state",read_only=true,emit=c.zym24gv2State(),converter=a.from_only(a.lookup_value({
[0]="none",[1]="presence",[2]="move",})),}),b.dp_numeric(2,{name="move_sensitivity",emit=c.zym24gv2MoveSensitivity()}),b.dp_numeric(3,{
name="min_range",emit=c.zym24gv2MinRange(),converter=a.divide_by_pair(100),}),b.dp_numeric(4,{
name="max_range",emit=c.zym24gv2MaxRange(),converter=a.divide_by_pair(100),}),b.dp_numeric(9,{
name="target_distance",read_only=true,emit=c.zym24gv2TargetDistance(),converter=a.divide_by_from_only(10),}),b.dp_numeric(102,{name="presence_sensitivity",emit=c.zym24gv2Sensitivity()}),b.dp_illuminance(103,{emit=c.illuminance()}),b.dp_presence(104,{emit=c.presence(),converter=a.true_false1()}),b.dp_numeric(105,{name="presence_timeout",emit=c.zym24gv2Timeout()}),},}d(u,e({
"_TZE204_7gclukjs",}))
local function w()
local S=c.presence()
return function(U,value,R,p)
return S(U,value=="presence"or value=="move",R,p)
end
end
local H=a.from_only(a.lookup_value({
[0]="none",[1]="presence",[2]="move",}))
local function j(P,O)
return{
b.dp_enum(1,{
name="presence_state",read_only=true,emit=c.all(c.zym24gv3State(),w()),converter=H,}),b.dp_numeric(2,{name="move_sensitivity",emit=c.zym24gv3MoveSensitivity()}),b.dp_numeric(3,{
name="min_range",emit=P,converter=a.divide_by_pair(100),}),b.dp_numeric(4,{
name="max_range",emit=O,converter=a.divide_by_pair(100),}),b.dp_numeric(9,{
name="target_distance",read_only=true,emit=c.zym24gv3TargetDistance(),converter=a.divide_by_from_only(10),}),b.dp_binary(101,{name="find_switch"}),b.dp_numeric(102,{name="presence_sensitivity",emit=c.zym24gv3Sensitivity()}),b.dp_illuminance(103,{emit=c.illuminance()}),b.dp_numeric(105,{name="presence_timeout",emit=c.zym24gv3Timeout()}),}
end
local r={
profile="safety-presence-zym10024gv3-move-range-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints=j(c.zym24gv3bMinRange(),c.zym24gv3bMaxRange()),}d(r,e({
"_TZE204_ya4ft0w4","_TZE200_ya4ft0w4",}))local q={
profile="safety-presence-zym10024gv3a-move-range-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints=j(c.zym24gv3aMinRange(),c.zym24gv3aMaxRange()),}d(q,e({
"_TZE204_gkfbdvyx","_TZE200_gkfbdvyx",}))local I={
profile="safety-presence-yxzbrb58-range-delay-scene-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_presence(1,{emit=c.presence(),converter=a.true_false1()}),b.dp_numeric(2,{name="radar_sensitivity",emit=c.yxzbrb58Sensitivity()}),b.dp_numeric(3,{
name="min_range",emit=c.yxzbrb58MinRange(),converter=a.divide_by_pair(100),}),b.dp_numeric(4,{
name="max_range",emit=c.yxzbrb58MaxRange(),converter=a.divide_by_pair(100),}),b.dp_illuminance(101,{emit=c.illuminance()}),b.dp_numeric(102,{
name="detection_delay",emit=c.yxzbrb58DetectionDelay(),converter=a.divide_by_pair(10),}),b.dp_numeric(103,{
name="fading_time",emit=c.yxzbrb58FadingTime(),converter=a.divide_by_pair(10),}),b.dp_enum(104,{
name="radar_scene",emit=c.yxzbrb58RadarScene(),converter=E,}),b.dp_numeric(105,{
name="target_distance",read_only=true,emit=c.yxzbrb58TargetDistance(),converter=a.divide_by_from_only(100),}),},}d(I,e({
"_TZE204_sooucan5","_TZE204_oqtpvx51",}))local o={
profile="safety-presence-ctlr1-threshold-min-delay-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_presence(1,{emit=c.presence(),converter=a.true_false1()}),b.dp_numeric(2,{name="presence_sensitivity",emit=c.ctlr1Sensitivity()}),b.dp_numeric(4,{
name="detection_range",emit=c.ctlr1DetectionRange(),converter=a.divide_by_pair(10),}),b.dp_illuminance(101,{emit=c.illuminance()}),b.dp_numeric(102,{name="illuminance_threshold_max",emit=c.ctlr1ThresholdMax()}),b.dp_numeric(103,{name="illuminance_threshold_min",emit=c.ctlr1ThresholdMin()}),b.dp_numeric(104,{name="detection_delay",emit=c.ctlr1DetectionDelay()}),b.dp_binary(105,{
name="light_switch",read_only=true,emit=c.ctlr1LightSwitch(),converter=a.lookup_from_to({ON=true,OFF=false}),}),b.dp_enum(106,{
name="light_linkage",emit=c.ctlr1LightLinkage(),converter=n,}),b.dp_enum(107,{
name="indicator_light",emit=c.ctlr1IndicatorLight(),converter=a.lookup_from_to({
presence=0,off=1,on=2,}),}),b.dp_enum(108,{
name="detection_method",emit=c.ctlr1DetectionMethod(),converter=A,}),b.dp_enum(109,{
name="illuminance_switch",emit=c.ctlr1ThresholdSwitch(),converter=n,}),},}d(o,e({
"_TZE204_e9ajs4ft",}))local G={
profile="safety-presence-rtzcz03z-range-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_presence(1,{emit=c.presence(),converter=a.true_false(4)}),b.dp_numeric(101,{
name="target_distance",read_only=true,emit=c.rtzcz03zTargetDistance(),}),b.dp_illuminance(102,{emit=c.illuminance()}),b.dp_numeric(103,{name="fading_time",emit=c.rtzcz03zFadingTime()}),b.dp_binary(104,{
name="indicator",emit=c.rtzcz03zIndicator(),converter=a.lookup_from_to({ON=true,OFF=false}),}),b.dp_numeric(107,{name="max_distance",emit=c.rtzcz03zMaxDistance()}),b.dp_numeric(108,{name="min_distance",emit=c.rtzcz03zMinDistance()}),b.dp_numeric(111,{name="presence_sensitivity",emit=c.rtzcz03zSensitivity()}),},}d(G,e({
"_TZE204_uxllnywp",}))local y={
profile="safety-presence-mtg075-entry-controls-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_presence(1,{emit=c.presence(),converter=a.true_false1()}),b.dp_numeric(2,{name="radar_sensitivity",emit=c.mtg075RadarSensitivity()}),b.dp_numeric(3,{
name="shield_range",emit=c.mtg075ShieldRange(),converter=a.divide_by_pair(100),}),b.dp_numeric(4,{
name="detection_range",emit=c.mtg075DetectionRange(),converter=a.divide_by_pair(100),}),b.dp_numeric(6,{name="equipment_status",read_only=true}),b.dp_numeric(9,{
name="target_distance",read_only=true,emit=c.mtg075TargetDistance(),converter=a.divide_by_from_only(100),}),b.dp_numeric(101,{
name="entry_filter_time",emit=c.mtg075EntryFilterTime(),converter=a.divide_by_pair(10),}),b.dp_numeric(102,{name="departure_delay",emit=c.mtg075DepartureDelay()}),b.dp_illuminance(104,{emit=c.illuminance(),scale=10}),b.dp_numeric(105,{name="entry_sensitivity",emit=c.mtg075EntrySensitivity()}),b.dp_numeric(106,{
name="entry_distance_indentation",emit=c.mtg075EntryIndentation(),converter=a.divide_by_pair(100),}),b.dp_enum(107,{
name="breaker_mode",emit=c.mtg075BreakerMode(),converter=m,}),b.dp_enum(108,{
name="breaker_status",emit=c.mtg075BreakerStatus(),converter=a.lookup_from_to({OFF=0,ON=1}),}),b.dp_enum(109,{
name="status_indication",emit=c.mtg075StatusIndication(),converter=a.lookup_from_to({OFF=0,ON=1}),}),b.dp_numeric(110,{
name="illuminance_threshold",emit=c.mtg075IlluminanceThreshold(),converter=a.divide_by_pair(10),}),b.dp_enum(111,{
name="breaker_polarity",emit=c.mtg075BreakerPolarity(),converter=a.lookup_from_to({NC=0,NO=1}),}),b.dp_numeric(112,{
name="block_time",emit=c.mtg075BlockTime(),converter=a.divide_by_pair(10),}),b.dp_enum(115,{
name="sensor_state",emit=c.mtg075SensorState(),converter=h,}),},}d(y,e({
"_TZE204_sbyx0lm6","_TZE204_clrdrnya","_TZE204_iaeejhvf","_TZE204_mtoaryre","_TZE200_mp902om5","_TZE204_pfayrzcw","_TZE284_4qznlkbu","_TZE200_clrdrnya","_TZE200_sbyx0lm6",}))local z={
placeholder_custom_states=false,profile="safety-presence-mtg275-entry-controls-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_presence(1,{emit=c.presence(),converter=a.true_false1()}),b.dp_numeric(2,{name="radar_sensitivity",emit=c.mtg275RadarSensitivity()}),b.dp_numeric(3,{name="shield_range",emit=c.mtg275ShieldRange(),converter=a.divide_by_pair(100)}),b.dp_numeric(4,{name="detection_range",emit=c.mtg275DetectionRange(),converter=a.divide_by_pair(100)}),b.dp_numeric(6,{name="equipment_status",read_only=true}),b.dp_numeric(9,{name="target_distance",read_only=true,emit=c.mtg275TargetDistance(),converter=a.divide_by_from_only(100)}),b.dp_numeric(101,{name="entry_filter_time",emit=c.mtg275EntryFilterTime(),converter=a.divide_by_pair(10)}),b.dp_numeric(102,{name="departure_delay",emit=c.mtg275DepartureDelay()}),b.dp_illuminance(104,{emit=c.illuminance(),scale=10}),b.dp_numeric(105,{name="entry_sensitivity",emit=c.mtg275EntrySensitivity()}),b.dp_numeric(106,{name="entry_distance_indentation",emit=c.mtg275EntryIndentation(),converter=a.divide_by_pair(100)}),b.dp_enum(107,{name="breaker_mode",emit=c.mtg275BreakerMode(),converter=m}),b.dp_enum(108,{name="breaker_status",emit=c.mtg275BreakerStatus(),converter=a.lookup_from_to({OFF=0,ON=1})}),b.dp_enum(109,{name="status_indication",emit=c.mtg275StatusIndication(),converter=a.lookup_from_to({OFF=0,ON=1})}),b.dp_numeric(110,{name="illuminance_threshold",emit=c.mtg275IlluminanceThreshold(),converter=a.divide_by_pair(10)}),b.dp_numeric(112,{name="block_time",emit=c.mtg275BlockTime(),converter=a.divide_by_pair(10)}),b.dp_enum(115,{name="sensor_state",emit=c.mtg275SensorState(),converter=h}),b.dp_enum(116,{name="distance_report",emit=c.mtg275DistanceReport(),converter=a.lookup_from_to({OFF=0,ON=1})}),},}d(z,e({"_TZE204_dtzziy1e"}))local s=a.lookup_from_to({
low=0,medium=1,high=2,})local v=a.lookup_from_to({
["30"]=0,["60"]=1,["120"]=2,})local C={
profile="safety-presence-zym100s3-keep-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_presence(1,{emit=c.presence(),converter=a.true_false0()}),b.dp_enum(9,{
name="sensitivity",emit=c.zym100s3Sensitivity(),converter=s,}),b.dp_enum(10,{
name="keep_time",emit=c.zym100s3KeepTime(),converter=v,}),b.dp_illuminance(12,{emit=c.illuminance()}),},}d(C,e({
"_TZE204_nbkshs6k",}))
local function D()
local S=c.presence()
return function(U,value,R,p)
return S(U,value~="none",R,p)
end
end
local L={
profile="safety-presence-zg205z-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_enum(1,{
name="presence_state",read_only=true,emit=c.all(c.zg205zPresenceState(),D()),converter=a.from_only(a.lookup_value({
[0]="none",[1]="presence",[2]="peaceful",[3]="small_movement",[4]="large_movement",})),}),b.dp_numeric(101,{
name="target_distance",read_only=true,emit=c.zg205zTargetDistance(),converter=a.divide_by_from_only(100),}),b.dp_illuminance(102,{emit=c.illuminance()}),b.dp_numeric(103,{name="none_delay_time",emit=c.zg205zNoneDelayTime()}),b.dp_binary(104,{
name="indicator",emit=c.zg205zIndicator(),converter=a.lookup_from_to({ON=true,OFF=false}),}),b.dp_numeric(107,{
name="move_detection_max",emit=c.zg205zMoveMax(),converter=a.divide_by_pair(100),}),b.dp_numeric(108,{
name="move_detection_min",emit=c.zg205zMoveMin(),converter=a.divide_by_pair(100),}),b.dp_numeric(109,{
name="breath_detection_max",emit=c.zg205zBreathMax(),converter=a.divide_by_pair(100),}),b.dp_numeric(110,{
name="breath_detection_min",emit=c.zg205zBreathMin(),converter=a.divide_by_pair(100),}),b.dp_numeric(114,{
name="small_move_detection_max",emit=c.zg205zSmallMoveMax(),converter=a.divide_by_pair(100),}),b.dp_numeric(115,{
name="small_move_detection_min",emit=c.zg205zSmallMoveMin(),converter=a.divide_by_pair(100),}),b.dp_numeric(116,{name="move_sensitivity",emit=c.zg205zMoveSensitivity()}),b.dp_numeric(117,{name="small_move_sensitivity",emit=c.zg205zSmallMoveSensitivity()}),b.dp_numeric(118,{name="breath_sensitivity",emit=c.zg205zBreathSensitivity()}),},}d(L,e({
"_TZE204_dapwryy7",}))local J={
profile="safety-presence-zg205za-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_presence(1,{emit=c.presence(),converter=a.true_false1()}),b.dp_numeric(2,{
name="large_motion_sensitivity",emit=c.zg205zaLargeSensitivity(),}),b.dp_numeric(4,{
name="large_motion_distance",emit=c.zg205zaLargeDistance(),converter=a.divide_by_pair(100),}),b.dp_enum(101,{
name="motion_state",read_only=true,emit=c.zg205zaMotionState(),converter=a.from_only(a.lookup_value({
[0]="none",[1]="large",[2]="medium",[3]="small",[4]="far",[5]="near",})),}),b.dp_numeric(102,{name="fading_time",emit=c.zg205zaFadingTime()}),b.dp_numeric(104,{
name="medium_motion_distance",emit=c.zg205zaMediumDistance(),converter=a.divide_by_pair(100),}),b.dp_numeric(105,{
name="medium_motion_sensitivity",emit=c.zg205zaMediumSensitivity(),}),b.dp_illuminance(106,{emit=c.illuminance()}),b.dp_binary(107,{
name="indicator",emit=c.zg205zaIndicator(),converter=a.lookup_from_to({ON=true,OFF=false}),}),b.dp_numeric(108,{
name="small_detection_distance",emit=c.zg205zaSmallDistance(),converter=a.divide_by_pair(100),}),b.dp_numeric(109,{
name="small_detection_sensitivity",emit=c.zg205zaSmallSensitivity(),}),b.dp_numeric(122,{
name="target_distance",read_only=true,emit=c.zg205zaTargetDistance(),converter=a.divide_by_from_only(100),}),b.dp_numeric(123,{
name="minimum_range",emit=c.zg205zaMinimumRange(),converter=a.divide_by_pair(100),}),},}d(J,{
f.create_fingerprint("_TZE200_2aaelwxk","TS0225"),f.create_fingerprint("_TZE200_crq3r3la","TS0225"),f.create_fingerprint("HOBEIAN","CK-BL702-MWS-01(7016)"),f.create_fingerprint("_TZE200_crq3r3la","CK-BL702-MWS-01(7016)"),})local K={
profile="safety-presence-zg205zl-illuminance",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_presence(1,{emit=c.presence(),converter=a.true_false1()}),b.dp_enum(11,{
name="motion_state",read_only=true,emit=c.zg205zlMotionState(),converter=a.from_only(a.lookup_value({
[0]="none",[1]="large",[2]="small",[3]="static",[4]="far",[5]="near",})),}),b.dp_numeric(12,{name="fading_time",emit=c.zg205zlFadingTime()}),b.dp_numeric(13,{
name="large_motion_distance",emit=c.zg205zlLargeDistance(),converter=a.divide_by_pair(100),}),b.dp_numeric(14,{
name="small_motion_distance",emit=c.zg205zlSmallDistance(),converter=a.divide_by_pair(100),}),b.dp_numeric(15,{
name="large_motion_sensitivity",emit=c.zg205zlLargeSensitivity(),}),b.dp_numeric(16,{
name="small_motion_sensitivity",emit=c.zg205zlSmallSensitivity(),}),b.dp_illuminance(20,{emit=c.illuminance()}),b.dp_binary(24,{
name="light_mode",emit=c.zg205zlLightMode(),converter=a.lookup_from_to({ON=true,OFF=false}),}),b.dp_numeric(101,{name="alarm_time",emit=c.zg205zlAlarmTime()}),b.dp_enum(102,{
name="alarm_volume",emit=c.zg205zlAlarmVolume(),converter=a.lookup_from_to({
low=0,medium=1,high=2,mute=3,}),}),b.dp_numeric(103,{
name="static_distance",emit=c.zg205zlStaticDistance(),converter=a.divide_by_pair(100),}),b.dp_numeric(104,{
name="static_sensitivity",emit=c.zg205zlStaticSensitivity(),}),b.dp_enum(105,{
name="working_mode",emit=c.zg205zlMode(),converter=a.lookup_from_to({
arm=0,off=1,alarm=2,doorbell=3,}),}),},}d(K,{
f.create_fingerprint("_TZE200_hl0ss9oa","TS0225"),f.create_fingerprint("ZGAF-205L","CK-BL702-MWS-01(7016)"),f.create_fingerprint("_TZE200_y4mdop0b","TS0225"),})local l=a.lookup_from_to({
on=0,occupied=1,unoccupied=2,})local g=a.lookup_from_to({
OFF=0,ON=1,})local t=a.lookup_from_to({
custom=0,toilet=1,kitchen=2,hallway=3,bedroom=4,livingroom=5,meetingroom=6,factory_default=7,})local k=a.lookup_from_to({
normal=0,occupancy_detection=1,})local F={
profile="safety-occupancy-mtd085-illuminance",package_group="presence-advanced",datapoints={
b.dp_numeric(101,{
name="entry_sensitivity",emit=c.mtd085EntrySensitivity(),command_id=b.SEND_DATA,}),b.dp_numeric(102,{
name="entry_distance",emit=c.mtd085EntryDistance(),converter=a.divide_by_pair(100),command_id=b.SEND_DATA,}),b.dp_numeric(103,{
name="departure_delay",emit=c.mtd085DepartureDelay(),command_id=b.SEND_DATA,}),b.dp_numeric(104,{
name="entry_filter_time",emit=c.mtd085EntryFilterTime(),converter=a.divide_by_pair(100),command_id=b.SEND_DATA,}),b.dp_numeric(105,{
name="block_time",emit=c.mtd085BlockTime(),converter=a.divide_by_pair(10),command_id=b.SEND_DATA,}),b.dp_illuminance(107,{
emit=c.illuminance(),converter=a.divide_by_pair(10),read_only=true,}),b.dp_enum(108,{
name="debug_mode",emit=c.mtd085DebugMode(),converter=g,command_id=b.SEND_DATA,}),b.dp_numeric(109,{
name="debug_distance",emit=c.mtd085DebugDistance(),converter=a.divide_by_pair(100),read_only=true,}),b.dp_numeric(110,{
name="debug_countdown",emit=c.mtd085DebugCountdown(),read_only=true,}),b.dp_enum(111,{
name="scene_preset",emit=c.mtd085ScenePreset(),converter=t,command_id=b.SEND_DATA,}),b.dp_enum(112,{
name="sensor",emit=c.mtd085Sensor(),converter=l,command_id=b.SEND_DATA,}),b.dp_numeric(113,{name="cline",read_only=true}),b.dp_enum(114,{
name="status_indication",emit=c.mtd085StatusIndication(),converter=g,command_id=b.SEND_DATA,}),b.dp_numeric(115,{
name="radar_sensitivity",emit=c.mtd085RadarSensitivity(),command_id=b.SEND_DATA,}),b.dp_numeric(116,{
name="shield_range",emit=c.mtd085ShieldRange(),converter=a.divide_by_pair(100),command_id=b.SEND_DATA,}),b.dp_numeric(117,{
name="detection_range",emit=c.mtd085DetectionRange(),converter=a.divide_by_pair(100),command_id=b.SEND_DATA,}),b.dp_numeric(118,{name="equipment_status",read_only=true}),b.dp_numeric(119,{
name="target_distance",emit=c.mtd085TargetDistance(),converter=a.divide_by_pair(100),read_only=true,}),b.dp_enum(120,{
name="distance_report_mode",emit=c.mtd085DistanceReportMode(),converter=k,command_id=b.SEND_DATA,}),},zcl_clusters={
Y.occupancy({ias_zone=true,read_only=true}),},query_on_configure=false,}i(F,{
f.create_fingerprint("_TZ321C_fkzihax8","TS0225"),f.create_fingerprint("_TZ321C_4slreunp","TS0225"),})local M={
profile="safety-presence-zp301z-time-cycle-illuminance-battery",package_group="presence-advanced",named_datapoints=true,datapoints={
b.dp_presence(1,{emit=c.presence(),converter=a.true_false1()}),b.dp_battery(14,{emit=c.battery()}),b.dp_illuminance(20,{emit=c.illuminance()}),b.dp_numeric(100,{name="brightness_value",emit=c.zp301zBrightnessValue()}),b.dp_numeric(101,{name="illuminance_trigger",emit=c.zp301zIlluminanceTrigger()}),b.dp_numeric(102,{name="presence_time",emit=c.zp301zPresenceTime()}),b.dp_numeric(103,{name="presence_delay",emit=c.zp301zPresenceDelay()}),b.dp_numeric(104,{name="detection_cycle",emit=c.zp301zDetectionCycle()}),},}d(M,{
f.create_fingerprint("_TZE284_d4h8j2n6","ZP-301Z"),f.create_fingerprint("B3876M9","ZP-301Z"),})Y.attach_reporting_capabilities(x,{
{14,"rpt-tai"},})return{
id="ef00.presence.advanced",registrations=x,}
