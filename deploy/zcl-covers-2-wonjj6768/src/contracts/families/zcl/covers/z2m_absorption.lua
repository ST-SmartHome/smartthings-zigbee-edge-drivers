local f=require"protocol.zcl"
local k=require"capabilities.events.all"
local e=require"contracts.helpers.family"
local c=require"st.zigbee.data_types"
local w=require"st.zigbee.cluster_base"
local l,o=e.definition_registry()local v={
profile="covers-somfy-glydea2",zcl_clusters={
f.cover_position({
endpoint=1,component="main",minimum_interval=1,maximum_interval=65000,reportable_change=1,converter={
from=function(a)return a>=0 and a<=100 and 100-a or nil end,
to=function(a)return 100-a end,
},}),f.window_shade_state({
endpoint=1,component="main",configure_reporting=false,read_on_configure=false,
converter={from=function(a)
if a<0 or a>100 then return nil end
return a==0 and"open"or a==100 and"closed"or"partially open"
end},
}),f.cover_state({endpoint=1,component="main"}),f.battery({
endpoint=232,component="main",minimum_interval=3600,maximum_interval=65000,reportable_change=10,}),},
configure=function(x,b)
local i=x.environment_info.hub_zigbee_eui
f.bind_cluster(b,258,i,1)f.bind_cluster(b,1,i,232)
end,
}o(v,{
e.create_fingerprint("SOMFY","Glydea 2 Ultra WF Curtain"),})
local function h(b,_,a,q)
local j=a or 3
if type(j)~="number"or j<1 or j>30 or j%1~=0 then return false end
return f.send_raw_cluster_command(b,3,0,string.char(j,0),q.endpoint or 1)
end
local u={
profile="covers-allesin-roller-shade",zcl_clusters={
f.cover_position({
endpoint=1,component="main",minimum_interval=1,maximum_interval=65000,reportable_change=1,converter={
from=function(a)return a>=0 and a<=100 and 100-a or nil end,
to=function(a)return 100-a end,
},}),f.window_shade_state({
endpoint=1,component="main",configure_reporting=false,read_on_configure=false,
converter={from=function(a)
if a<0 or a>100 then return nil end
return a==0 and"open"or a==100 and"closed"or"partially open"
end},
}),f.cover_state({endpoint=1,component="main"}),f.battery({
endpoint=1,component="main",scale=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
converter={from=function(a)return a<255 and a or nil end},
}),f.cluster_attribute(3,nil,{
name="allesin_identify",endpoint=1,component="main",write_only=true,sender=h,}),},capability_commands={
{capability_id="concertmirror08464.allesinIdentify",command_name="identify",argument_name="seconds",mapping_name="allesin_identify"},},
configure=function(x,b)
local i=x.environment_info.hub_zigbee_eui
f.bind_cluster(b,258,i,1)f.bind_cluster(b,1,i,1)
end,
}o(u,{
e.create_fingerprint("Aubor","TLSR82xx"),})
local function d(E,p,s,C,B,t)
local r={}
for F,a in pairs(B)do r[a]=F end
local z=f.cluster_attribute(p,s,{
name=E,endpoint=1,component="main",emit=C,data_type=c.Enum8,write_type=c.Enum8,read_only=t,read_on_configure=false,converter={
from=function(a)
if type(a)=="table"then a=a.value end
return B[a]
end,
to=function(a)return r[a]end,
},})if not t then
z.sender=function(b,_,a,q)
local A=w.write_attribute(
b,c.ClusterId(p),c.AttributeId(s),c.Enum8(r[a]))
if p==57345 then A.body.zcl_header.frame_ctrl:set_disable_default_response()end
b:send(A:to_endpoint(q.endpoint or 1))return true
end
end
return z
end
local m=d(
"zm108m_switch_type",57345,53296,k.zm108mSwitchType(),{[0]="flip-switch",[1]="sync-switch",[2]="button-switch",[3]="button2-switch"})
local function g(a,b)
if a<0 or a>100 then return nil end
return b.preferences.invertCover==true and 100-a or a
end
local y={
profile="covers-moes-zm108m",zcl_clusters={
f.tuya_magic_packet({read_on_configure=false}),f.cluster_attribute(258,8,{
name="cover_position",endpoint=1,data_type=c.Uint8,emit=k.shade_level(),read_on_configure=false,converter={from=g,to=g},}),f.cluster_attribute(258,8,{
name="window_shade_state",endpoint=1,data_type=c.Uint8,emit=k.shade_state(),read_only=true,read_on_configure=false,
converter={from=function(a,b)
local n=g(a,b)
if n==nil then return nil end
return n==0 and"closed"or n==100 and"open"or"partially open"
end},
}),f.cover_state({endpoint=1}),d("zm108m_moving",258,61440,k.zm108mMoving(),{[0]="UP",[1]="STOP",[2]="DOWN"},true),d("zm108m_motor_reversal",258,61442,k.zm108mMotorReversal(),{[0]="OFF",[1]="ON"}),d("zm108m_calibration",258,61441,k.zm108mCalibration(),{[0]="ON",[1]="OFF"}),f.cluster_attribute(258,61443,{
name="zm108m_calibration_time",endpoint=1,read_only=true,read_on_configure=false,data_type=c.Uint16,scale=10,emit=k.zm108mCalibrationTime(),}),d("zm108m_indicator_mode",6,32769,k.zm108mIndicatorMode(),{[0]="off",[1]="off/on",[2]="on/off",[3]="on"}),d("zm108m_backlight_mode",6,20480,k.zm108mBacklightMode(),{[0]="OFF",[1]="ON"}),m,},
parent_refresh=function(b)
for _,D in ipairs({{258,8},{258,61440},{258,61441},{258,61442},{258,61443},{6,32769},{6,20480},{57345,53296}})do
f.read_attribute(b,D[1],D[2],1)
end
return true
end,
}o(y,{
e.create_fingerprint("_TZ3210_mldzab8w","TS130F"),})f.attach_reporting_capabilities(l,{
{1,"rpt-gtd"},{2,"rpt-tqk"},})return{
id="zcl.covers.z2m_absorption",registrations=l,}
