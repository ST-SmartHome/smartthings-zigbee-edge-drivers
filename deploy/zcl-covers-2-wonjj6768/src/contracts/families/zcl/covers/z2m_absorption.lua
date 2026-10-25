local e=require"protocol.zcl"
local n=require"capabilities.events.all"
local f=require"contracts.helpers.family"
local c=require"st.zigbee.data_types"
local x=require"st.zigbee.cluster_base"
local o,r=f.definition_registry()local h={
from=function(a)return a>=0 and a<=100 and 100-a or nil end,
to=function(a)return 100-a end
}
local q={from=function(a)
if a<0 or a>100 then return nil end
return a==0 and"open"or a==100 and"closed"or"partially open"
end}
local w={
profile="covers-somfy-glydea2",
component_to_endpoint=function()return 1 end,
parent_refresh=function(b)
e.read_attribute(b,258,8,1)
for _,j in ipairs{33,32}do pcall(e.read_attribute,b,1,j,232)end
end,
zcl_clusters={
e.cover_position{
endpoint=1,component="main",minimum_interval=1,maximum_interval=65000,reportable_change=1,converter=h},e.window_shade_state{
endpoint=1,component="main",configure_reporting=false,read_on_configure=false,converter=q},e.cover_state{endpoint=1,component="main"},e.battery{
endpoint=232,component="main",minimum_interval=3600,maximum_interval=65000,reportable_change=10,
from_device=function(a,_,k)if k.raw_value~=255 then return a end end
}},
configure=function(y,b)
local l=y.environment_info.hub_zigbee_eui
e.bind_cluster(b,258,l,1)e.bind_cluster(b,1,l,232)
end
}r(w,{
f.create_fingerprint("SOMFY","Glydea 2 Ultra WF Curtain")})
local function i(b,_,a,k)
local m=a or 3
if type(m)~="number"or m<1 or m>30 or m%1~=0 then return false end
return e.send_raw_cluster_command(b,3,0,string.char(m,0),k.endpoint or 1)
end
local v={
profile="covers-allesin-roller-shade",zcl_clusters={
e.cover_position{
endpoint=1,component="main",minimum_interval=1,maximum_interval=65000,reportable_change=1,converter=h},e.window_shade_state{
endpoint=1,component="main",configure_reporting=false,read_on_configure=false,converter=q},e.cover_state{endpoint=1,component="main"},e.battery{
endpoint=1,component="main",scale=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,
converter={from=function(a)return a<255 and a or nil end}
},e.cluster_attribute(3,nil,{
name="allesin_identify",endpoint=1,component="main",write_only=true,sender=i})},capability_commands={
{capability_id="concertmirror08464.allesinIdentify",command_name="identify",argument_name="seconds",mapping_name="allesin_identify"}},
configure=function(y,b)
local l=y.environment_info.hub_zigbee_eui
e.bind_cluster(b,258,l,1)e.bind_cluster(b,1,l,1)
end
}r(v,{
f.create_fingerprint("Aubor","TLSR82xx")})
local function d(F,s,j,D,C,u)
local t={}
for G,a in pairs(C)do t[a]=G end
local A=e.cluster_attribute(s,j,{
name=F,endpoint=1,component="main",emit=D,data_type=c.Enum8,write_type=c.Enum8,read_only=u,read_on_configure=false,converter={
from=function(a)
if type(a)=="table"then a=a.value end
return C[a]
end,
to=function(a)return t[a]end
}})if not u then
A.sender=function(b,_,a,k)
local B=x.write_attribute(
b,c.ClusterId(s),c.AttributeId(j),c.Enum8(t[a]))
if s==57345 then B.body.zcl_header.frame_ctrl:set_disable_default_response()end
b:send(B:to_endpoint(k.endpoint or 1))return true
end
end
return A
end
local p=d(
"zm108m_switch_type",57345,53296,n.zm108mSwitchType(),{[0]="flip-switch",[1]="sync-switch",[2]="button-switch",[3]="button2-switch"})
local function g(a,b)
if a<0 or a>100 then return nil end
return b.preferences.invertCover==true and 100-a or a
end
local z={
profile="covers-moes-zm108m",zcl_clusters={
e.tuya_magic_packet{read_on_configure=false},e.cluster_attribute(258,8,{
name="cover_position",endpoint=1,data_type=c.Uint8,emit=n.shade_level(),read_on_configure=false,converter={from=g,to=g}}),e.cluster_attribute(258,8,{
name="window_shade_state",endpoint=1,data_type=c.Uint8,emit=n.shade_state(),read_only=true,read_on_configure=false,
converter={from=function(a,b)
local h=g(a,b)
if h==nil then return nil end
return h==0 and"closed"or h==100 and"open"or"partially open"
end}
}),e.cover_state{endpoint=1},d("zm108m_moving",258,61440,n.zm108mMoving(),{[0]="UP",[1]="STOP",[2]="DOWN"},true),d("zm108m_motor_reversal",258,61442,n.zm108mMotorReversal(),{[0]="OFF",[1]="ON"}),d("zm108m_calibration",258,61441,n.zm108mCalibration(),{[0]="ON",[1]="OFF"}),e.cluster_attribute(258,61443,{
name="zm108m_calibration_time",endpoint=1,read_only=true,read_on_configure=false,data_type=c.Uint16,scale=10,emit=n.zm108mCalibrationTime()}),d("zm108m_indicator_mode",6,32769,n.zm108mIndicatorMode(),{[0]="off",[1]="off/on",[2]="on/off",[3]="on"}),d("zm108m_backlight_mode",6,20480,n.zm108mBacklightMode(),{[0]="OFF",[1]="ON"}),p},
parent_refresh=function(b)
for _,E in ipairs{{258,8},{258,61440},{258,61441},{258,61442},{258,61443},{6,32769},{6,20480},{57345,53296}}do
e.read_attribute(b,E[1],E[2],1)
end
return true
end
}r(z,{
f.create_fingerprint("_TZ3210_mldzab8w","TS130F")})e.attach_reporting_capabilities(o,{
{1,"rpt-gtd"},{2,"rpt-tqk"}})return{
id="zcl.covers.z2m_absorption",registrations=o}
