local d=require"protocol.tuya"
local h=require"capabilities.events.all"
local f=require"contracts.helpers.family"
local k=require"st.capabilities"
local E=require"protocol.zcl"
local b=d.converter
local m,c=f.definition_registry()local e=b.from_only(b.lookup_value{
[0]="pushed",[1]="double",[2]="held"})local i=b.lookup_from_to{
on=1,off=0}local g=b.from_only(b.lookup_value{
[false]="pushed",[0]="pushed"})
local function a(_,w)
local B=k.button and k.button.button or nil
local o=B and B[w]or nil
if type(o)~="function"then
return nil
end
return o{state_change=true}
end
local function l(C,w)
if w~="emergency"then
return nil
end
local q={}local p=a(C,"pushed")if p~=nil then
q[#q+1]=p
end
local j=h.security_remote_action()(C,w)if j~=nil then
q[#q+1]=j
end
return q
end
local u={
profile="buttons-button-2-battery",button_actions={"pushed","double","held"},datapoints={
d.dp_enum(1,{
name="button_1_action",component="main",converter=e,emit=a}),d.dp_enum(2,{
name="button_2_action",component="button2",converter=e,emit=a}),d.dp_battery(10,{emit=h.battery()})},query_on_configure=true}local v={
profile="buttons-button-6-battery",button_actions={"pushed","double","held"},datapoints={
d.dp_enum(1,{
name="button_1_action",component="main",converter=e,emit=a}),d.dp_enum(2,{
name="button_2_action",component="button2",converter=e,emit=a}),d.dp_enum(3,{
name="button_3_action",component="button3",converter=e,emit=a}),d.dp_enum(4,{
name="button_4_action",component="button4",converter=e,emit=a}),d.dp_enum(5,{
name="button_5_action",component="button5",converter=e,emit=a}),d.dp_enum(6,{
name="button_6_action",component="button6",converter=e,emit=a}),d.dp_battery(10,{emit=h.battery()})},query_on_configure=true}local s={
profile="buttons-button-18",button_actions={"pushed"},datapoints={
d.dp_enum(1,{name="button_1_action",component="main",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(2,{name="button_2_action",component="button2",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(3,{name="button_3_action",component="button3",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(4,{name="button_4_action",component="button4",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(5,{name="button_5_action",component="button5",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(6,{name="button_6_action",component="button6",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(7,{name="button_7_action",component="button7",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(8,{name="button_8_action",component="button8",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(9,{name="button_9_action",component="button9",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(10,{name="button_10_action",component="button10",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(11,{name="button_11_action",component="button11",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(12,{name="button_12_action",component="button12",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(13,{name="button_13_action",component="button13",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(14,{name="button_14_action",component="button14",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(15,{name="button_15_action",component="button15",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(16,{name="button_16_action",component="button16",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(101,{name="button_17_action",component="button17",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(102,{name="button_18_action",component="button18",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a})},query_on_configure=true}local n={
profile="buttons-button-4-foria-options",button_actions={"pushed"},datapoints={
d.dp_enum(1,{
name="button_1_action",component="main",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(2,{
name="button_2_action",component="button2",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(3,{
name="button_3_action",component="button3",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(4,{
name="button_4_action",component="button4",converter=b.from_only(b.lookup_value{[0]="pushed"}),emit=a}),d.dp_enum(105,{
name="foria_scene_backlight",converter=i,emit=h.foriaSceneBacklight()}),d.dp_enum(106,{
name="foria_scene_illumination_detection",converter=i,emit=h.foriaSceneIlluminationDetection()}),d.dp_enum(107,{
name="foria_scene_approach_detection",converter=i,emit=h.foriaSceneApproachDetection()}),d.dp_enum(108,{
name="foria_scene_vibration",converter=i,emit=h.foriaSceneVibration()})},query_on_configure=true}local y={
profile="buttons-button-4",button_actions={"pushed","double","held"},datapoints={
d.dp_enum(1,{name="button_1_action",component="main",converter=e,emit=a}),d.dp_enum(2,{name="button_2_action",component="button2",converter=e,emit=a}),d.dp_enum(3,{name="button_3_action",component="button3",converter=e,emit=a}),d.dp_enum(4,{name="button_4_action",component="button4",converter=e,emit=a}),d.dp_raw(52,{name="binding_confirmation"}),d.dp_raw(102,{name="binding_config"})},query_on_configure=true}local x={
profile="buttons-button-6-battery",button_actions={"pushed"},datapoints={
d.dp_binary(1,{name="side_1",component="main",converter=g,emit=a}),d.dp_binary(2,{name="side_2",component="button2",converter=g,emit=a}),d.dp_binary(3,{name="side_3",component="button3",converter=g,emit=a}),d.dp_binary(4,{name="side_4",component="button4",converter=g,emit=a}),d.dp_binary(5,{name="knock",component="button5",converter=g,emit=a}),d.dp_binary(6,{name="shake",component="button6",converter=g,emit=a}),d.dp_battery(10,{emit=h.battery()})},query_on_configure=true}local A={
profile="security-remotes-sos-battery",button_actions={"pushed"},datapoints={
d.dp_enum(23,{
name="security_remote_action",
converter=b.from_only(function()
return"emergency"
end),
emit=l}),d.dp_battery(3,{emit=h.battery()})},query_on_configure=true}local r={
profile="security-remotes-sos-battery-low",button_actions={"pushed"},datapoints={
d.dp_enum(26,{
name="sos_action",
converter=b.from_only(function()
return"emergency"
end),
emit=l}),d.dp_enum(29,{
name="emergency_action",
converter=b.from_only(function()
return"emergency"
end),
emit=l})},zcl_clusters={
E.battery_low{read_only=true,emit=function(_,F)
return F and k.batteryLevel.battery.critical()or k.batteryLevel.battery.normal()
end}
},query_on_configure=true}c(u,f.create_fingerprints("TS0021",{
"_TZ3210_3ulg9kpo"}))c(v,f.create_fingerprints("TS0601",{
"_TZE200_2m38mh6k"}))c(s,f.create_fingerprints("TS0601",{
"_TZE200_dhke3p9w","_TZE284_dhke3p9w"}))c(n,f.create_fingerprints("TS0601",{
"_TZE200_mfamvsdb"}))c(y,f.create_fingerprints("TS0601",{
"_TZE284_nj7sfid2"}))c(x,f.create_fingerprints("TS0601",{
"_TZE284_5ys44kzo"}))c(A,f.create_fingerprints("TS0601",{
"_TZE284_2baujqot"}))c(r,f.create_fingerprints("TS0601",{
"_TZE200_nojsjtj2","_TZE200_vrcfo4i0"}))local t={
profile="controllers-zrf01",magic_packet=true,query_on_configure=false,named_datapoints=true,datapoints={
d.dp_binary(117,{name="zrf01_learning_mode",emit=h.zrf01LearningMode(),converter=b.lookup_from_to{on=true,off=false}}),d.dp_binary(118,{name="zrf01_packet_mode",emit=h.zrf01PacketMode(),converter=b.lookup_from_to{on=true,off=false}}),d.dp_illuminance(119,{name="illuminance",read_only=true,emit=h.illuminance()})}}for D,z in ipairs{
{"zrf01_code_1",h.zrf01Code1(),"zrf01_transmit_1",h.zrf01Transmit1()},{"zrf01_code_2",h.zrf01Code2(),"zrf01_transmit_2",h.zrf01Transmit2()},{"zrf01_code_3",h.zrf01Code3(),"zrf01_transmit_3",h.zrf01Transmit3()},{"zrf01_code_4",h.zrf01Code4(),"zrf01_transmit_4",h.zrf01Transmit4()},{"zrf01_code_5",h.zrf01Code5(),"zrf01_transmit_5",h.zrf01Transmit5()},{"zrf01_code_6",h.zrf01Code6(),"zrf01_transmit_6",h.zrf01Transmit6()},{"zrf01_code_7",h.zrf01Code7(),"zrf01_transmit_7",h.zrf01Transmit7()},{"zrf01_code_8",h.zrf01Code8(),"zrf01_transmit_8",h.zrf01Transmit8()}}do
t.datapoints[#t.datapoints+1]=d.dp_enum(100+D,{
name=z[1],emit=z[2],converter=b.lookup_from_to{Learn=0,Delete=2,Saved=1}})t.datapoints[#t.datapoints+1]=d.dp_enum(108+D,{
name=z[3],emit=z[4],converter=b.lookup_from_to{Transmit=0},write_only=true,suppress_optimistic_state=true})
end
c(t,f.create_fingerprints("TS0601",{"_TZE284_tdg4ckyh"}))E.attach_reporting_capabilities(m,{
{8,"rpt-til"}})return{
id="ef00.controls",registrations=m}
