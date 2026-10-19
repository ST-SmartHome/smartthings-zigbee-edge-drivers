local aJ=require"protocol.zcl"
local bT=require"capabilities.events.all"
local M=require"contracts.helpers.family"
local ce=require"st.capabilities"
local bP=require"st.zigbee.device_management"
local bF=require"st.zigbee.cluster_base"
local e=require"st.zigbee.data_types"
local bK,o=M.definition_registry()local bu="concertmirror08464."
local g=5423
local H=0
local I=2
local bf=3
local p=6
local Q=18
local h=258
local B=2821
local k=64719
local G=13
local aK=18
local bn=0
local T=16387
local ao=4316
local bE=85
local ac=8
local ar=23
local V=4098
local X=4099
local Y=8193
local aq=8194
local E=8195
local D=8196
local A=8197
local O=8198
local v=8199
local u=8200
local N=8201
local bt=12289
local ay=12290
local ag=12305
local ad=12306
local af=12307
local P=12308
local aM=16385
local aL=16386
local aC=16387
local as=16640
local ae=16641
local bl=0
local bm=4097
local aV=4098
local aW=4099
local aN=4100
local bb=4101
local bc=4102
local aB=4097
local aX=4098
local aQ=4099
local function cD(capability_id)
return assert(bT[capability_id],"missing Wave14 Sber emitter: "..capability_id)()
end
local function m(r,n)
if n.read_only==nil then n.read_only=false end
r[#r+1]=n
return n
end
local function bh(br)
local bH={}
for cy,f in pairs(br or{})do bH[cy]=f end
return bH
end
local function bw(w)
local bH={}for cy,f in pairs(w or{})do
if cy~="mapping"then bH[cy]=f end
end
return bH
end
local function F(r,ch,ck,cC,bZ)
for bd=ch,ck do
local n=r[bd]n.sber_dynamic_branch=cC
local bz=n.emit
if type(bz)=="function"then
n.emit=function(a,f,w,aG)
if not bZ(a)then return nil end
return bz(a,f,w,aG)
end
end
local bj=n.handler
if type(bj)=="function"then
n.handler=function(a,f,w,aG)
if not bZ(a)then return nil end
return bj(a,f,w,aG)
end
end
if n.read_only~=true then
local bS=bh(n)local cb={bS}
n.sender=function(a,_,f,w)
if not bZ(a)then
return bS.name=="switch"
end
return aJ.send_named_command(
a,cb,bS.name,f,bw(w))
end
end
end
end
local function t(ak,R,cp,capability_id,bk,br)
local aF=bh(br)aF.name=cp
aF.emit=cD(capability_id)aF.data_type=bk
aF.write_type=aF.write_type or bk
return aJ.cluster_attribute(ak,R,aF)
end
local function y(R,cp,capability_id,bk,br)
local aF=bh(br)aF.mfg_code=g
return t(k,R,cp,capability_id,bk,aF)
end
local function au(f)
return(f==true or f==1)and"ON"or"OFF"
end
local function ax(f)
return f==true or f=="ON"or f=="on"
end
local function cn(f)
f=math.max(0,math.min(65535,math.floor(tonumber(f)or 0)))return string.char(f%256,math.floor(f/256)%256)
end
local function z(a,n,f,w)
local aO=f
if type(n.to_device)=="function"then
aO=n.to_device(f,a,w,n)
end
if type(aO)=="number"then aO=math.floor(aO+0.5)end
if aO==nil then return false end
local be
if n.mfg_code~=nil then
be=bF.write_manufacturer_specific_attribute(
a,n.cluster_id,n.attribute_id,n.mfg_code,n.write_type,aO)else
be=bF.write_attribute(
a,e.ClusterId(n.cluster_id),e.AttributeId(n.attribute_id),n.write_type(aO))
end
if w.endpoint~=nil and type(be.to_endpoint)=="function"then
be=be:to_endpoint(w.endpoint)
end
a:send(be)return true
end
local function bW(aH)
return function(a,_,_,w)
return aJ.send_raw_cluster_command(
a,bf,0,cn(aH),w.endpoint,nil,nil,false)
end
end
local function bJ(a,_,f,w)
local bV=({open=0,close=1,stop=2})[f]
if bV==nil then return false end
return aJ.send_raw_cluster_command(
a,h,bV,"",w.endpoint,nil,nil,false)
end
local function bq(a,_,f,w)
local cr=math.max(0,math.min(100,math.floor(tonumber(f)+0.5)))local bX=100-cr
return aJ.send_raw_cluster_command(
a,h,5,string.char(bX),w.endpoint,nil,nil,false)
end
local function bv()
return function(_,f)
local bg=({[0]="held",[1]="pushed",[2]="double"})[f]
if bg==nil then return nil end
local cx=ce.button.button(bg)cx.state_change=true
return cx
end
end
local function bo(a,q,l,co)
for _,ak in ipairs(co)do
a:send(bP.build_bind_request(
a,ak,q,l))
end
end
local function aP(a,l,ak,R,bU)
aJ.read_attribute(a,ak,R,l,bU)
end
local function x(a,l,ak,cj,bU)
for _,R in ipairs(cj)do
aP(a,l,ak,R,bU)
end
end
local ci={
{Y,"LedOnEnabled","led_on_enabled",e.Boolean,au,ax,0,1,nil},{aq,"LedOnHue","led_on_hue",e.Uint16,nil,nil,0,359,"°"},{E,"LedOnSaturation","led_on_saturation",e.Uint8,nil,nil,0,254,nil},{D,"LedOnBrightness","led_on_brightness",e.Uint8,nil,nil,1,254,nil},{A,"LedOffEnabled","led_off_enabled",e.Boolean,au,ax,0,1,nil},{O,"LedOffHue","led_off_hue",e.Uint16,nil,nil,0,359,"°"},{v,"LedOffSaturation","led_off_saturation",e.Uint8,nil,nil,0,254,nil},{u,"LedOffBrightness","led_off_brightness",e.Uint8,nil,nil,1,254,nil},}
local function aj(r,c,capability_prefix,l,j,cq)
for bd,field in ipairs(ci)do
if not cq or bd>=5 then
m(r,y(
field[1],c.."_"..field[3],capability_prefix..field[2],field[4],{
endpoint=l,component=j,from_device=field[5],to_device=field[6],numeric_range=field[7]and{
minimum=field[7],maximum=field[8],step=1,unit=field[9],}or nil,}))
end
end
end
local function az(r,c,capability_prefix,l,j)
m(r,y(
V,c.."_allow_double_click",capability_prefix.."AllowDoubleClick",e.Boolean,{
endpoint=l,component=j,from_device=au,to_device=ax,}))
end
local function ah(r,c,capability_prefix,l,j)
m(r,t(
p,T,c.."_power_on_behavior",capability_prefix.."PowerOnBehavior",e.Enum8,{
endpoint=l,component=j,
from_device=function(f)
return({[0]="off",[1]="on",[2]="toggle",[255]="previous"})[f]
end,
to_device=function(f)
return({off=0,on=1,toggle=2,previous=255})[f]
end,
}))
end
local function bp(r,c,capability_prefix,l,j)
m(r,t(
p,ao,c.."_relay_mode",capability_prefix.."RelayMode",e.Boolean,{
endpoint=l,component=j,mfg_code=g,
from_device=function(f)return(f==true or f==1)and"decoupled"or"control_relay"end,
to_device=function(f)return f=="decoupled"end,
}))
end
local function aD(r,J,c,capability_prefix,l,j,aH)
local bL=c.."_identify"
m(r,aJ.cluster_attribute(bf,nil,{
name=bL,endpoint=l,component=j,write_only=true,sender=bW(aH),}))J[#J+1]={
capability_id=bu ..capability_prefix.."Identify",command_name="identify",value=true,mapping_name=bL,}
end
local function aY(r,l,j)
m(r,aJ.cluster_attribute(Q,bE,{
name="button_action",endpoint=l,component=j,read_only=true,data_type=e.SinglePrecisionFloat,emit=bv(),}))
end
local bO={
{bl,"ResetsCount","resets_count",e.Uint16,false},{bm,"Uptime","uptime",e.Uint32,true},{aV,"ButtonClicksOne","button_clicks_one",e.Uint32,true},{aW,"ButtonClicksTwo","button_clicks_two",e.Uint32,true},{aN,"ButtonClicksThree","button_clicks_three",e.Uint32,true},{bb,"RelaySwitchesOne","relay_switches_one",e.Uint32,true},{bc,"RelaySwitchesTwo","relay_switches_two",e.Uint32,true},}
local function U(r,c,capability_prefix,l,j,cz,cE,C)
m(r,y(
X,c.."_child_lock",capability_prefix.."ChildLock",e.Boolean,{
endpoint=l,component=j,from_device=au,to_device=ax,}))m(r,t(
H,G,c.."_serial_number",capability_prefix.."SerialNumber",e.CharString,{
endpoint=l,component=j,read_only=true,
from_device=function(f)return tostring(f)end,
}))for bd,field in ipairs(bO)do
local cB=bd<=2 or(bd>=3 and bd<=2+cz)or
(bd>=6 and bd<=5+cE)if cB then
m(r,t(
B,field[1],c.."_"..field[3],capability_prefix..field[2],field[4],{
endpoint=l,component=j,read_only=true,mfg_code=field[5]and g or nil,}))
end
end
if C then
m(r,y(
ae,c.."_neutral_presence",capability_prefix.."NeutralPresence",e.Enum8,{
endpoint=l,component=j,read_only=true,
from_device=function(f)return f==1 and"YES"or"NO"end,
}))m(r,y(
as,c.."_power_profile",capability_prefix.."PowerProfile",e.Enum8,{
endpoint=l,component=j,
from_device=function(f)
return({
[0]="quick",[1]="af_250",[2]="af_500",[3]="af_750",[4]="af_1000",[5]="af_1250",[6]="af_1750",[7]="af_2000",[254]="af_fallback",})[f]
end,
to_device=function(f)
return({
quick=0,af_250=1,af_500=2,af_750=3,af_1000=4,af_1250=5,af_1750=6,af_2000=7,af_fallback=254,})[f]
end,
}))m(r,y(
N,c.."_led_indication_type",capability_prefix.."LedIndicationType",e.Enum8,{
endpoint=l,component=j,
from_device=function(f)return({[0]="continuous",[1]="flashes"})[f]end,
to_device=function(f)return({continuous=0,flashes=1})[f]end,
}))
end
end
local function bR(model,C)
return function(an,a)
x(a,1,p,{bn,T})aP(a,1,p,ao,g)aP(a,1,H,G)x(a,1,k,{
Y,aq,E,D,A,O,v,u,},g)aP(a,1,k,V,g)aP(a,1,k,X,g)if C then
x(a,1,k,{
ae,as,N,},g)
end
bo(a,an.environment_info.hub_zigbee_eui,1,{
p,Q,})bo(a,an.environment_info.hub_zigbee_eui,1,{B})
end
end
local function ba(model,bM,C)
local c="sber_"..model
local capability_prefix="sber"..model
local d={}local J={}m(d,aJ.switch({endpoint=1,component="main",configure_reporting=false,read_on_configure=false}))az(d,c,capability_prefix,1,"main")aj(d,c,capability_prefix,1,"main",false)aD(d,J,c,capability_prefix,1,"main",3)ah(d,c,capability_prefix,1,"main")bp(d,c,capability_prefix,1,"main")aY(d,1,"main")U(d,c,capability_prefix,1,"main",2,1,C)return{
profile=bM,package_group="wave14-switch",transport_classification="ZCL_CUSTOM_ATTRIBUTE_COMMAND",z2m_converter_source="sdevicesExtend + local sdevices converters",wire_cluster="manuSpecificSDevices(0xFCCF) and standard ZCL",zcl_clusters=d,capability_commands=J,button_actions={"pushed","held","double"},placeholder_custom_states=false,configure=bR(model,C),}
end
local function ap(a,i,C)
local l=i and 3 or 1
if i then
aP(a,3,H,G)x(a,3,h,{
ac,ar,})x(a,3,h,{
aB,aX,aQ,},g)x(a,3,k,{
A,O,v,u,},g)aP(a,3,k,X,g)else
aP(a,1,H,G)for ab=1,2 do
x(a,ab,p,{bn,T})aP(a,ab,p,ao,g)x(a,ab,k,{
V,Y,aq,E,D,A,O,v,u,},g)
end
aP(a,1,k,X,g)
end
if C then
x(a,l,k,{
ae,as,N,},g)
end
end
local function bB(a,q,i)
if q==nil then return end
if i then
bo(a,q,3,{h})bo(a,q,3,{k})bo(a,q,3,{B})return
end
for ab=1,2 do
bo(a,q,ab,{p,Q})
end
bo(a,q,1,{k})bo(a,q,1,{B})
end
local function S(a,q,i,C)
ap(a,i,C)bB(a,q,i)
end
local function aR(model,bM,C)
local c="sber_"..model
local capability_prefix="sber"..model
local ai=bM
local am=bM .."-cover"
local Z="__wave14_sber_"..model.."_cover_enabled"
local s="__wave14_sber_"..model.."_mode_pending"
local aA="__wave14_sber_"..model.."_mode_timer"
local aT="__wave14_sber_"..model.."_hub_eui"
local aa="__wave14_sber_"..model.."_probe_action"
local L="__wave14_sber_"..model.."_profile_reconfigure"
local d={}local J={}
local function av(a,i)
local bY=i and am or ai
return a:get_field(s)~=true and
a:get_field(Z)==i and
a.profile~=nil and a.profile.id==bY
end
local function at(a,i,cG,bx)
local cg=i and am or ai
local cA=a.profile and a.profile.id or nil
if cG or cA~=cg then
if bx then
a:set_field(L,cg)
end
a:try_update_metadata({profile=cg})return true
end
return false
end
local function aZ(a)
local bN=a:get_field(aA)
if bN~=nil and a.thread~=nil and type(a.thread.cancel_timer)=="function"then
a.thread:cancel_timer(bN)
end
a:set_field(aA,nil)
end
local by=#d+1
for aw=1,2 do
local word=aw==1 and"One"or"Two"
local j=aw==1 and"main"or"switch2"
local aS=c.."_"..string.lower(word)local aE=capability_prefix..word
m(d,aJ.switch({endpoint=aw,component=j,configure_reporting=false,read_on_configure=false}))ah(d,aS,aE,aw,j)bp(d,aS,aE,aw,j)az(d,aS,aE,aw,j)aD(d,J,aS,aE,aw,j,30)aj(d,aS,aE,aw,j,false)aY(d,aw,j)
end
F(
d,by,#d,"switch",
function(a)return av(a,false)end
)local bC=#d+1
m(d,aJ.cluster_attribute(h,ac,{
name="cover_position",endpoint=3,component="cover",data_type=e.Uint8,
from_device=function(f)return 100-f end,
emit=bT.shade_level(),sender=bq,}))m(d,aJ.cluster_attribute(h,ac,{
name=c.."_cover_state_rx",endpoint=3,component="cover",read_only=true,data_type=e.Uint8,
from_device=function(f)return f==100 and"closed"or"open"end,
emit=bT.shade_state(),}))m(d,aJ.cluster_attribute(h,nil,{
name="cover_state",endpoint=3,component="cover",write_only=true,sender=bJ,}))m(d,t(
h,ar,c.."_cover_mode",capability_prefix.."CoverMode",e.Bitmap8,{
endpoint=3,component="cover",sender=z,
from_device=function(f)return f%2==1 and"reversed"or"normal"end,
to_device=function(f)return f=="reversed"and 1 or 0 end,
}))m(d,t(
h,aB,c.."_calibration_time",capability_prefix.."CalibrationTime",e.Uint16,{
endpoint=3,component="cover",mfg_code=g,sender=z,
from_device=function(f)return f*0.1 end,
to_device=function(f)return f*10 end,
numeric_range={minimum=0,maximum=3600,step=0.1,unit="s"},}))m(d,t(
h,aQ,c.."_motor_timeout",capability_prefix.."MotorTimeout",e.Uint16,{
endpoint=3,component="cover",mfg_code=g,sender=z,numeric_range={minimum=0,maximum=3600,step=1,unit="s"},}))m(d,t(
h,aX,c.."_buttons_mode",capability_prefix.."ButtonsMode",e.Enum8,{
endpoint=3,component="cover",mfg_code=g,sender=z,
from_device=function(f)return f==1 and"inverted"or"normal"end,
to_device=function(f)return f=="inverted"and 1 or 0 end,
}))aD(d,J,c.."_cover",capability_prefix.."Cover",3,"cover",30)aj(d,c.."_cover",capability_prefix.."Cover",3,"cover",true)F(
d,bC,#d,"cover",
function(a)return av(a,true)end
)local bD=#d+1
U(d,c,capability_prefix,1,"main",3,2,C)F(
d,bD,#d,"switch",
function(a)return av(a,false)end
)local bI=#d+1
U(d,c,capability_prefix,3,"cover",3,2,C)F(
d,bI,#d,"cover",
function(a)return av(a,true)end
)
local function cf(a,f)
local cc=a:get_field(Z)local bg=a:get_field(aa)or"configure"
local i=f==true or f==1
a:set_field(Z,i,{persist=true})a:set_field(aa,nil)aZ(a)local aI=at(a,i,false,true)if aI then
a:set_field(s,true)return
end
a:set_field(s,false)if bg=="refresh"and cc==i then
ap(a,i,C)else
S(a,a:get_field(aT),i,C)
end
end
m(d,aJ.cluster_attribute(H,aK,{
name=c.."_window_covering_enabled",endpoint=3,component="cover",read_only=true,data_type=e.Boolean,handler=cf,}))
local function aU(a,q,bg)
if q~=nil then a:set_field(aT,q)end
a:set_field(s,true)a:set_field(aa,bg)aZ(a)aP(a,3,H,aK)
if a.thread~=nil and type(a.thread.call_with_delay)=="function"then
local bN
bN=a.thread:call_with_delay(3,function()
if a:get_field(s)==true and a:get_field(aA)==bN then
local W=a:get_field(Z)if type(W)~="boolean"then
W=false
a:set_field(Z,W,{persist=true})
end
a:set_field(aA,nil)a:set_field(aa,nil)local aI=at(a,W,false,true)if aI then
a:set_field(s,true)return
end
a:set_field(s,false)if bg=="refresh"then
ap(a,W,C)else
S(a,q,W,C)
end
end
end,"wave14 Sber mode fallback "..model)
a:set_field(aA,bN)
end
end
local function bG(an,a)
local bi=a:get_field(L)if bi~=nil and a.profile~=nil and a.profile.id==bi then
a:set_field(L,nil)local bA=a:get_field(Z)if type(bA)=="boolean"then
a:set_field(s,false)local q=an.environment_info.hub_zigbee_eui
if q~=nil then a:set_field(aT,q)end
S(a,q or a:get_field(aT),bA,C)
end
return
end
aU(a,an.environment_info.hub_zigbee_eui,"configure")
end
local function ca(a,_,an)
local q=an~=nil and an.environment_info~=nil and
an.environment_info.hub_zigbee_eui or a:get_field(aT)aU(a,q,"refresh")
end
local function cd(a)
local bs=a:get_field(Z)if type(bs)=="boolean"then
if at(a,bs,false,true)then
a:set_field(s,true)
end
end
end
return{
profile=ai,auxiliary_profiles={am},sber_switch_profile=ai,sber_cover_profile=am,sber_mode_field=Z,sber_pending_field=s,valid_parent_profiles={[ai]=true,[am]=true},package_group="wave14-switch",transport_classification="ZCL_DYNAMIC_SWITCH_OR_COVER",z2m_converter_source="local sdevices fz/tz + dynamic exposes(device.meta.window_covering_enabled)",wire_cluster="standard ZCL + Sber 0xFCCF/0x152F",zcl_clusters=d,capability_commands=J,button_actions={"pushed","held","double"},component_to_endpoint_map={main=1,switch2=2,cover=3},endpoint_to_component_map={[1]="main",[2]="switch2",[3]="cover"},placeholder_custom_states=false,runtime_start=cd,configure=bG,parent_refresh=ca,}
end
local function bQ()
local c="sber_202"
local capability_prefix="sber202"
local d={}local J={}m(d,aJ.switch({endpoint=1,component="main",configure_reporting=false,read_on_configure=false}))aD(d,J,c,capability_prefix,1,"main",3)ah(d,c,capability_prefix,1,"main")U(d,c,capability_prefix,1,"main",1,1,false)aj(d,c,capability_prefix,1,"main",false)for _,item in ipairs({
{"EmergencyOvervoltage","emergency_overvoltage",1},{"EmergencyUndervoltage","emergency_undervoltage",2},{"EmergencyOvercurrent","emergency_overcurrent",4},{"EmergencyOverheat","emergency_overheat",8},})do
m(d,y(
bt,c.."_"..item[2],capability_prefix..item[1],e.Bitmap16,{
endpoint=1,component="main",read_only=true,
from_device=function(f)return bit32.band(f,item[3])~=0 and"active"or"clear"end,
}))
end
m(d,aJ.cluster_attribute(
I,0,{
name="device_temperature",endpoint=1,component="main",read_only=true,data_type=e.Int16,emit=bT.temperature("C"),}))m(d,aJ.cluster_attribute(k,aM,{
name="voltage",endpoint=1,component="main",read_only=true,mfg_code=g,data_type=e.Uint32,
from_device=function(f)return f*0.001 end,emit=bT.voltage(),
}))m(d,aJ.cluster_attribute(k,aL,{
name="current",endpoint=1,component="main",read_only=true,mfg_code=g,data_type=e.Uint32,
from_device=function(f)return f*0.001 end,emit=bT.current(),
}))m(d,aJ.cluster_attribute(k,aC,{
name="power",endpoint=1,component="main",read_only=true,mfg_code=g,data_type=e.Int32,
from_device=function(f)return f*0.001 end,emit=bT.power(),
}))m(d,y(
ay,c.."_emergency_recovery",capability_prefix.."EmergencyRecovery",e.Bitmap16,{
endpoint=1,component="main",
from_device=function(f)return({[0]="disabled",[1]="voltage_is_good"})[f]end,
to_device=function(f)return({disabled=0,voltage_is_good=1})[f]end,
}))local cm={
{ag,"UpperVoltageThreshold","upper_voltage_threshold",e.Uint32,230000,260000,1000,"mV"},{ad,"LowerVoltageThreshold","lower_voltage_threshold",e.Uint32,100000,230000,1000,"mV"},{af,"UpperCurrentThreshold","upper_current_threshold",e.Uint32,100,16000,100,"mA"},{P,"TemperatureThreshold","temperature_threshold",e.Int16,-200,200,1,"°C"},}for _,field in ipairs(cm)do
m(d,y(
field[1],c.."_"..field[3],capability_prefix..field[2],field[4],{
endpoint=1,component="main",numeric_range={minimum=field[5],maximum=field[6],step=field[7],unit=field[8]},}))
end
local function bG(an,a)
aP(a,1,H,G)aP(a,1,I,0)x(a,1,p,{bn,T})x(a,1,k,{
X,ay,aM,aL,aC,},g)x(a,1,k,{
Y,aq,E,D,A,O,v,u,},g)x(a,1,k,{
ag,ad,af,P,},g)bo(a,an.environment_info.hub_zigbee_eui,1,{
p,I,k,})bo(a,an.environment_info.hub_zigbee_eui,1,{B})
end
return{
profile="switches-wave14-sber-sbdv-00202",package_group="wave14-switch",transport_classification="ZCL_CUSTOM_ATTRIBUTE_COMMAND",z2m_converter_source="sdevices.fz.emergency_shutoff_state + sdevicesExtend",wire_cluster="standard ZCL + Sber 0xFCCF/0x152F",zcl_clusters=d,capability_commands=J,placeholder_custom_states=false,configure=bG,}
end
local cs=ba("196","switches-wave14-sber-sbdv-00196",false)local ct=ba("197","switches-wave14-sber-sbdv-00197",true)local cu=aR("199","switches-wave14-sber-sbdv-00199",false)local cv=aR("200","switches-wave14-sber-sbdv-00200",true)local cw=bQ()o(cs,{M.create_fingerprint("SDevices","SBDV-00196")})o(ct,{M.create_fingerprint("SDevices","SBDV-00197")})o(cu,{M.create_fingerprint("SDevices","SBDV-00199")})o(cv,{M.create_fingerprint("SDevices","SBDV-00200")})o(cw,{M.create_fingerprint("SDevices","SBDV-00202")})return{
id="wave14.sber.zcl_switches",registrations=bK,}
