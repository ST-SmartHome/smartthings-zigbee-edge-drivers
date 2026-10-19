local k=require"protocol.tuya"
local W=require"protocol.zcl"
local n=require"capabilities.events.all"
local J=require"contracts.helpers.family"
local U=require"st.zigbee.cluster_base"
local B=require"st.zigbee.data_types"
local e=k.converter
local E,f=J.definition_registry()
local function s(q)
return type(q)=="table"
and type(q.preferences)=="table"
and q.preferences.reverse==true
end
local function R(l,q,V,Q,S)
local j=tonumber(l)
if j==nil then return nil end
if Q and j>100 then
j=j>150 and 0 or 100
end
if V then j=100-j end
if S and s(q)then j=100-j end
return j
end
local function w(m)
m=m or{}return e.from_to(
function(l,q)
return R(
l,q,m.invert_wire==true,m.overflow_guard==true,m.reverse_from~=false)
end,
function(l,q)
local j=tonumber(l)
if j==nil then return nil end
if m.invert_wire==true then j=100-j end
if m.reverse_to~=false and s(q)then j=100-j end
return j
end
)
end
local function x(m)
local af=w(m)
return e.from_only(function(l,q)
local O=af.from(l,q)
if O==nil then return nil end
if O<=0 then return"closed"end
if O>=100 then return"open"end
return"partially open"
end)
end
local function I()
return e.from_to(
function(l)
return({
[0]="open",[1]="paused",[2]="closed",[3]="partially open",})[tonumber(l)]
end,
function(l)
return({open=0,stop=1,close=2})[l]
end
)
end
local function D(P,K)
return e.from_to(
function(l,q)
local z=s(q)and K or P
local j=tonumber(l)
if j==z.open then return"open"end
if j==z.stop then return"paused"end
if j==z.close then return"closed"end
return nil
end,
function(l,q)
local z=s(q)and K or P
return({open=z.open,stop=z.stop,close=z.close})[l]
end
)
end
local function A(P,K)
return e.from_only(function(l,q)
local z=s(q)and K or P
local j=tonumber(l)
if j==z.opening then return"opening"end
if j==z.closing then return"closing"end
if z.stopped~=nil and j==z.stopped then return"stopped"end
return nil
end)
end
local function g(r,Y,m)
m=m or{}r.datapoints[#r.datapoints+1]=k.dp_numeric(Y,{
name=m.name or"cover_position",read_only=m.read_only==true,write_only=m.write_only==true,command_id=m.command_id,converter=w(m),emit=n.shade_level(),})r.datapoints[#r.datapoints+1]=k.dp_numeric(Y,{
name=(m.name or"cover_position").."_shade_state",read_only=true,converter=x(m),emit=n.shade_state(),})
end
local function p(r,Y,m)
m=m or{}r.datapoints[#r.datapoints+1]=k.dp_enum(Y,{
name=m.name or"cover_state",read_only=m.read_only==true,write_only=m.write_only==true,command_id=m.command_id,converter=I(),emit=m.emit==false and nil or n.shade_state(),})
end
local function t(r,Y)
r.datapoints[#r.datapoints+1]=k.dp_battery(Y,{
read_only=true,emit=n.battery(),})
end
local function o(ab)
return{
profile=ab,package_group="cover",transport_classification="EF00_DP",z2m_converter_source="meta.tuyaDatapoints",wire_cluster="manuSpecificTuya",magic_packet=true,datapoints={},}
end
local function C(ac,T)
return J.create_fingerprints(ac,T)
end
local i=o("covers-wave10-moes-adcbzi01")i.wire_cluster="closuresWindowCovering+manuSpecificTuya"
i.magic_packet=false
i.query_on_configure=true
i.zcl_clusters={
W.tuya_magic_packet(),W.cover_position({
read_only=false,converter=w({invert_wire=true}),}),W.window_shade_state({
read_only=true,
converter=e.from_only(function(l)
local j=tonumber(l)
if j==nil then return nil end
if j<=0 then return"open"end
if j>=100 then return"closed"end
return"partially open"
end),
}),W.cover_state({read_only=false}),W.cluster_attribute(258,61442,{
name="adcbzi_calibration",read_only=false,attribute_name="tuyaMotorReversal",data_type=B.Enum8,write_type=B.Enum8,read_on_configure=true,converter=e.lookup_from_to({
stop=0,calibrate=1,calibrate_reverse=2,}),emit=n.adcbziCalibration(),
sender=function(q,aa,l,M)
local ad=aa.converter.to(l,q,M)
if ad==nil then return false end
local N=U.write_attribute(
q,B.ClusterId(258),B.AttributeId(61442),B.Enum8(ad))if M~=nil and M.endpoint~=nil
and N.address_header~=nil and N.address_header.dest_endpoint~=nil then
N.address_header.dest_endpoint.value=M.endpoint
end
q:send(N)return true
end,
}),}i.datapoints[#i.datapoints+1]=k.dp_numeric(1,{
name="adcbzi_cover_state_report",read_only=true,converter=D(
{open=0,stop=1,close=2},{open=0,stop=1,close=2}),emit=n.shade_state(),})g(i,2,{name="adcbzi_position_control_report",read_only=true})g(i,3,{name="adcbzi_position_report",read_only=true,invert_wire=true})i.datapoints[#i.datapoints+1]=k.dp_numeric(7,{
name="adcbzi_work_state",read_only=true,
converter=e.from_only(function(l)
return({[0]="standby",[1]="opening",[2]="closing"})[tonumber(l)]
end),
emit=n.adcbziWorkState(),})i.datapoints[#i.datapoints+1]=k.dp_numeric(10,{
name="adcbzi_total_time",read_only=true,emit=n.adcbziTotalTime(),})i.datapoints[#i.datapoints+1]=k.dp_numeric(11,{
name="adcbzi_situation_set",converter=e.lookup_from_to({fully_open=0,fully_close=1}),emit=n.adcbziSituationSet(),})i.datapoints[#i.datapoints+1]=k.dp_numeric(12,{
name="adcbzi_fault",read_only=true,
converter=e.from_only(function(l)return tonumber(l)==0 and"none"or nil end),
emit=n.adcbziFault(),})t(i,13)i.datapoints[#i.datapoints+1]=k.dp_numeric(101,{
name="adcbzi_charging_status",read_only=true,
converter=e.from_only(function(l)
return({[0]="none",[1]="uncharged",[2]="charging",[3]="charged"})[tonumber(l)]
end),
emit=n.adcbziChargingStatus(),})for X,ae in ipairs({
"adcbzi_custom_week_prog_one","adcbzi_custom_week_prog_two","adcbzi_custom_week_prog_three","adcbzi_custom_week_prog_four",})do
local Z=({
n.adcbziCustomWeekProgOne,n.adcbziCustomWeekProgTwo,n.adcbziCustomWeekProgThree,n.adcbziCustomWeekProgFour,})[X]i.datapoints[#i.datapoints+1]=k.dp_string(102+X,{
name=ae,emit=Z(),})
end
i.datapoints[#i.datapoints+1]=k.dp_illuminance(107,{
read_only=true,emit=n.illuminance(),})i.datapoints[#i.datapoints+1]=k.dp_numeric(108,{
name="adcbzi_open_threshold",emit=n.adcbziOpenThreshold(),})i.datapoints[#i.datapoints+1]=k.dp_numeric(109,{
name="adcbzi_close_threshold",emit=n.adcbziCloseThreshold(),})i.datapoints[#i.datapoints+1]=k.dp_numeric(110,{
name="adcbzi_curtain_status",emit=n.adcbziCurtainStatus(),})i.datapoints[#i.datapoints+1]=k.dp_numeric(111,{
name="adcbzi_factory_test",read_only=true,emit=n.adcbziFactoryTest(),})i.datapoints[#i.datapoints+1]=k.dp_numeric(112,{
name="adcbzi_total_distance",read_only=true,emit=n.adcbziTotalDistance(),})f(i,C("TS030F",{
"_TZ3210_sxtfesc6","_TZ3210_rundhkxp",}))local H=o("covers-wave10-manhot-bl82-tyz1")H.respond_to_mcu_version_response=true
p(H,1)g(H,2)g(H,3,{name="position_report",read_only=true})H.datapoints[#H.datapoints+1]=k.dp_enum(5,{
name="bl_tyz_motor_direction",converter=e.lookup_from_to({normal=0,reversed=1}),emit=n.blTyzMotorDirection(),})t(H,13)H.datapoints[#H.datapoints+1]=k.dp_binary(6,{
name="bl_tyz_auto_power",converter=e.lookup_from_to({ON=true,OFF=false}),emit=n.blTyzAutoPower(),})f(H,C("TS0601",{
"_TZE284_7qc2wlqr","_TZE2841000000_7qc2wlqr",}))local L=o("covers-wave10-moes-zs-sr-euc")p(L,1)g(L,2,{overflow_guard=true,reverse_from=false})L.datapoints[#L.datapoints+1]=k.dp_enum(3,{
name="zs_sr_calibration",converter=e.lookup_from_to({START=0,END=1}),emit=n.zsSrCalibration(),})L.datapoints[#L.datapoints+1]=k.dp_enum(8,{
name="zs_sr_motor_steering",converter=e.lookup_from_to({FORWARD=0,BACKWARD=1}),emit=n.zsSrMotorSteering(),})f(L,C("TS0601",{"_TZE204_srmahpwl"}))local y=o("covers-wave10-moes-zc-lp01")y.datapoints[#y.datapoints+1]=k.dp_numeric(102,{
name="cover_state",command_id=k.SEND_DATA,converter=D(
{open=0,stop=2,close=1},{open=1,stop=2,close=0}),emit=n.shade_state(),})g(y,104,{command_id=k.SEND_DATA})t(y,4)y.datapoints[#y.datapoints+1]=k.dp_numeric(105,{
name="zc_lp_charging",read_only=true,
converter=e.from_only(function(l)
return tonumber(l)==1 and"charging"or"not_charging"
end),
emit=n.zcLpCharging(),})y.datapoints[#y.datapoints+1]=k.dp_numeric(106,{
name="zc_lp_automatic_mode",command_id=k.SEND_DATA,converter=e.lookup_from_to({ON=1,OFF=0}),emit=n.zcLpAutomaticMode(),})y.datapoints[#y.datapoints+1]=k.dp_enum(110,{
name="zc_lp_slow_mode",command_id=k.SEND_DATA,converter=e.lookup_from_to({ON=1,OFF=0}),emit=n.zcLpSlowMode(),})y.datapoints[#y.datapoints+1]=k.dp_numeric(112,{
name="zc_lp_button_position",command_id=k.SEND_DATA,converter=e.lookup_from_to({UP=1,DOWN=0}),emit=n.zcLpButtonPosition(),})f(y,C("TS0601",{"_TZ3210_5rta89nj"}))local v=o("covers-wave10-moes-fwjzceh18a001")v.mcu_version_request_on_configure=true
v.query_on_configure=false
v.query_on_announce=false
v.initial_custom_states=false
v.refresh_state=false
v.refresh_state_query=false
v.time_start="off"
p(v,1)
v.datapoints[1].from_device=function(l)
return({[0]="open",[1]="partially open",[2]="closed",[3]="partially open"})[l]
end
g(v,9)g(v,8,{name="position_report",read_only=true})v.datapoints[#v.datapoints+1]=k.dp_enum(11,{
name="fwjz_motor_direction",converter=e.lookup_from_to({normal=0,reversed=1}),receive_datatypes={4,3},
from_device=function(l)
if type(l)=="string"then return l=="back"and"reversed"or"normal"end
return({[0]="normal",[1]="reversed"})[l]
end,
emit=n.fwjzMotorDirection(),})v.datapoints[#v.datapoints+1]=k.dp_raw(13,{
name="battery",read_only=true,
converter=e.from_only(function(l)
if type(l)~="string"or #l<4 then return nil end
local a,b,c,d=string.byte(l,1,4)return(((a*256)+b)*256+c)*256+d
end),
emit=n.battery(),})v.datapoints[#v.datapoints+1]=k.dp_enum(16,{
name="fwjz_cover_limit",converter=e.lookup_from_to({
set_up=0,set_down=1,delete_up=2,delete_down=3,delete_both=4,}),emit=n.fwjzCoverLimit(),})f(v,C("TS0601",{"_TZE284_qoi1aqxg"}))local h=o("covers-wave10-tuya-ts0301-cover-two")p(h,1)h.datapoints[#h.datapoints+1]=k.dp_enum(3,{
name="ts_cover_two_motor_state",read_only=true,converter=A(
{opening=0,closing=1,stopped=2},{opening=0,closing=1,stopped=2}),emit=n.tsCoverTwoMotorState(),})h.datapoints[#h.datapoints+1]=k.dp_enum(7,{
name="ts_cover_two_slow_mode",converter=e.lookup_from_to({ON=1,OFF=0}),emit=n.tsCoverTwoSlowMode(),})g(h,9)g(h,8,{name="position_report",read_only=true})h.datapoints[#h.datapoints+1]=k.dp_enum(11,{
name="ts_cover_two_motor_direction",converter=e.lookup_from_to({normal=0,reversed=1}),emit=n.tsCoverTwoMotorDirection(),})t(h,13)h.datapoints[#h.datapoints+1]=k.dp_enum(15,{
name="ts_cover_two_cover_type",converter=e.lookup_from_to({
roman_pole=0,roller_blind=1,canopy_curtain=2,roman_blind=3,honeycomb_curtain=4,}),emit=n.tsCoverTwoCoverType(),})h.datapoints[#h.datapoints+1]=k.dp_enum(16,{
name="ts_cover_two_cover_limit",converter=e.lookup_from_to({
set_up=0,set_down=1,delete_up=2,delete_down=3,delete_both=4,}),emit=n.tsCoverTwoCoverLimit(),})h.datapoints[#h.datapoints+1]=k.dp_numeric(19,{
name="ts_cover_two_favorite_position",emit=n.tsCoverTwoFavoritePosition(),})h.datapoints[#h.datapoints+1]=k.dp_enum(20,{
name="ts_cover_two_click_control",converter=e.lookup_from_to({up=0,down=1}),emit=n.tsCoverTwoClickControl(),})f(h,C("TS0301",{"_TZE210_xgzzuerd"}))local G=o("covers-wave10-xenon-x7726")p(G,1)g(G,2)g(G,3,{name="position_report",read_only=true})G.datapoints[#G.datapoints+1]=k.dp_enum(102,{
name="x_seven_calibration",converter=e.lookup_from_to({start=0,finish=1}),emit=n.xSevenCalibration(),})G.datapoints[#G.datapoints+1]=k.dp_numeric(103,{
name="temperature",read_only=true,emit=n.temperature("C"),})f(G,C("TS0601",{"_TZE284_hbjwgkdh"}))local F=o("covers-wave10-zemismart-zn-usc1u-ht")p(F,1)g(F,2)F.datapoints[#F.datapoints+1]=k.dp_enum(8,{
name="zn_usc_motor_steering",converter=e.lookup_from_to({FORWARD=0,BACKWARD=1}),emit=n.znUscMotorSteering(),})F.datapoints[#F.datapoints+1]=k.dp_numeric(10,{
name="zn_usc_calibration_time",emit=n.znUscCalibrationTime(),})f(F,C("TS0601",{"_TZE204_mpg22jc1"}))local u=o("covers-wave10-zemismart-zmp1")u.datapoints[#u.datapoints+1]=k.dp_enum(1,{
name="cover_state",converter=D(
{open=0,stop=1,close=2},{open=2,stop=1,close=0}),emit=n.shade_state(),})g(u,2)g(u,3,{name="position_report",read_only=true})u.datapoints[#u.datapoints+1]=k.dp_enum(5,{
name="zmp_one_motor_direction",converter=e.lookup_from_to({normal=0,reversed=1}),emit=n.zmpOneMotorDirection(),})u.datapoints[#u.datapoints+1]=k.dp_enum(7,{
name="zmp_one_motor_state",read_only=true,converter=A(
{opening=0,closing=1},{opening=1,closing=0}),emit=n.zmpOneMotorState(),})t(u,13)f(u,C("TS0601",{"_TZE284_6hrnp30w"}))W.attach_reporting_capabilities(E,{
{1,"rpt-thj"},})return{
id="ef00.covers.wave10",registrations=E,}
