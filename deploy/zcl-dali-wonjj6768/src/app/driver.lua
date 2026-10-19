local aZ=require"protocol.tuya"
local I=require"protocol.zcl"
local bh=require"core.registry"
local K=require"runtime.capability_metadata"
local capabilities=require"st.capabilities"
local bZ=require"st.device"
local bB=require"st.zigbee.data_types"
local ad=require"st.zigbee.generated.zcl_clusters"
local V=require"app.component_mapping"
local ak=require"app.custom_capability_runtime"
local ay=require"runtime.battery_refresh"
local bQ=require"runtime.energy_reset"
local at=require"app.switch_command_router"
local bs=require"st.zigbee.defaults.switch_defaults.on"
local bp=require"st.zigbee.defaults.switch_defaults.off"
local g=K.by_emit_name.power_poll_interval
local q=K.by_emit_name.learn_ir_code
local p=K.by_emit_name.ir_code_to_send
local T="_presetLevel"
local aj=50
local M="_tuya_power_poll_interval_seconds"
local ao=300
local o=5
local z=3600
local R=5
local S="s"
local aC=1282
local ba=0
local D=3
local W=0
local A=3
local y=300
local ax="statelessSwitchLevelStep"
local ag="stepLevel"
local aB=19
local aM=setmetatable({},{__mode="k"})
local function aH()
local by=bh.all()local x={}for _,cf in pairs(by)do
for _,e in pairs(cf)do
for _,ca in ipairs(e.additional_zcl_profiles or{})do
x[ca]=true
end
if e.zcl_clusters then
I.register_attributes_from_mappings(e.zcl_clusters)I.register_cluster_commands_from_mappings(e.zcl_clusters)I.prepare_mappings(e.zcl_clusters)
end
end
end
return x
end
local x=aH()
local function h(a)
local cb=aM[a]if cb then
return cb
end
local bo=a:get_manufacturer()local ck=a:get_model()if not bo or not ck then
return nil
end
local e=bh.find(bo,ck)if not e then
return nil
end
local b=aZ.build_base_preset(e)for cn,n in pairs(e)do
if cn~="fingerprints"and b[cn]==nil then
b[cn]=n
end
end
if b.zcl_clusters then
I.prepare_mappings(b.zcl_clusters)
end
aM[a]=b
return b
end
local function aX(_,a)
local b=h(a)if b==nil then
return false
end
return b:apply_announce(a)
end
ay.set_requester(function(a)
return I.read_attribute(a,1,32,1)
end,function(a)
local b=h(a)return b~=nil and b.zcl_clusters~=nil and
I.has_cluster(b.zcl_clusters,I.CLUSTER_POWER_CONFIGURATION)
end)
local az=require("runtime.capability_support").is_callable
local function ar(a,E)
if type(a)~="table"or type(E)~="string"then
return false
end
local bA=a.profile and a.profile.components or nil
local co=type(bA)=="table"and bA.main or nil
local aS=type(co)=="table"and co.capabilities or nil
if type(aS)~="table"then
return false
end
for _,s in ipairs(aS)do
if type(s)=="table"and s.id==E then
return true
end
end
return false
end
local function N(n)
local r=tonumber(n)if r==nil then
return nil
end
r=math.floor(r+0.5)if r<o then
r=o
elseif r>z then
r=z
end
local bK=r%R
if bK~=0 then
r=r-bK
if r<o then
r=o
end
end
return r
end
local function B(a,b)
return type(b)=="table"
and b.zcl_clusters==nil
and type(b.datapoints)=="table"
and g~=nil
and ar(a,g.capability_id)
end
local function G(a)
local cj=N(a:get_field(M))return cj or ao
end
local function U(a,b)
if not B(a,b)then
return false
end
local s=capabilities[g.capability_id]local aR=s and s[g.attribute_name]or nil
if not az(aR)and s and type(s.attributes)=="table"then
aR=s.attributes[g.attribute_name]
end
if not az(aR)then
return false
end
local ab=s and s[g.range_attribute_name]or nil
if not az(ab)and s and type(s.attributes)=="table"then
ab=s.attributes[g.range_attribute_name]
end
if az(ab)then
a:emit_event(ab({
value={
minimum=o,maximum=z,step=R,},unit=S,}))
end
a:emit_event(aR({
value=G(a),unit=S,}))return true
end
local function af(a,b)
if not B(a,b)then
return false
end
b:start_query_timer(a,G(a))U(a,b)return true
end
local function an(f)
return string.format("%s:%s",T,tostring(f or"main"))
end
local function F(a,f)
f=f or"main"
local ce=a:get_latest_state(f,capabilities.windowShadePreset.ID,"position")if type(ce)=="number"then
return ce
end
local bF=a:get_field(an(f))if type(bF)~="number"then
bF=a:get_field(T)
end
if type(bF)=="number"then
return bF
end
local bE=a.preferences and a.preferences.presetPosition or nil
if type(bE)=="number"then
return bE
end
return aj
end
local function O(a)
for _,f in ipairs(V.sorted_profile_component_ids(a))do
if a:supports_capability_by_id(capabilities.windowShadePreset.ID,f)then
a:emit_component_event(
{id=f},capabilities.windowShadePreset.position(F(a,f)))
end
end
end
local function bg(a,e)
if type(e)~="table"or type(e.button_actions)~="table"then
return
end
local bx=e.button_actions
for _,f in ipairs(V.sorted_profile_component_ids(a))do
if a:supports_capability_by_id(capabilities.button.ID,f)then
a:emit_component_event({id=f},capabilities.button.supportedButtonValues(bx))a:emit_component_event({id=f},capabilities.button.numberOfButtons({value=1}))
end
end
end
local function J(_,a,bH)
local b=h(a)if b then
b:apply_message(a,bH)
end
end
local function aV()
local i={
[aZ.EF00_CLUSTER]={
[aZ.GET_DATA]=J,[aZ.SET_DATA_RESPONSE]=J,[aZ.REPORT_STATUS]=J,[aZ.ACTIVE_STATUS_REPORT]=J,[aZ.SET_TIME]=J,[aZ.CONNECTION_STATUS]=J,[aZ.MCU_VERSION_RESPONSE]=J,},}local bj=I.build_zigbee_cluster_handlers(h)for bd,bu in pairs(bj)do
i[bd]=i[bd]or{}for bY,cl in pairs(bu)do
i[bd][bY]=cl
end
end
return i
end
local bn={
{capabilities.switch.ID,"on","switch",true},{capabilities.switch.ID,"off","switch",false},{capabilities.audioVolume.ID,"setVolume","volume","volume"},{capabilities.doorControl.ID,"open","door_control",true},{capabilities.doorControl.ID,"close","door_control",false},{capabilities.valve.ID,"open","valve","open"},{capabilities.valve.ID,"close","valve","closed"},{capabilities.switchLevel.ID,"setLevel","brightness","level"},{capabilities.windowShade.ID,"open","cover_state","open"},{capabilities.windowShade.ID,"close","cover_state","close"},{capabilities.windowShade.ID,"pause","cover_state","stop"},{capabilities.windowShadeLevel.ID,"setShadeLevel","cover_position","shadeLevel"},{capabilities.windowShadeTiltLevel.ID,"setShadeTiltLevel","cover_tilt","level"},{capabilities.thermostatHeatingSetpoint.ID,"setHeatingSetpoint","current_heating_setpoint","setpoint"},{capabilities.thermostatCoolingSetpoint.ID,"setCoolingSetpoint","current_cooling_setpoint","setpoint"},{capabilities.thermostatMode.ID,"setThermostatMode","system_mode","mode"},{capabilities.thermostatMode.ID,"auto","system_mode","auto"},{capabilities.thermostatMode.ID,"cool","system_mode","cool"},{capabilities.thermostatMode.ID,"emergencyHeat","system_mode","emergency heat"},{capabilities.thermostatMode.ID,"heat","system_mode","heat"},{capabilities.thermostatMode.ID,"off","system_mode","off"},{capabilities.fanMode.ID,"setFanMode","fan_mode","fanMode"},{capabilities.colorTemperature.ID,"setColorTemperature","color_temperature","temperature",true},{capabilities.colorControl.ID,"setHue","color_hue","hue",true},{capabilities.colorControl.ID,"setSaturation","color_saturation","saturation",true},
{capabilities.colorControl.ID,"setColor","color",function(d)
return d.args and d.args.color or nil
end,true},
}local aJ={
[capabilities.audioVolume.ID ..":"..capabilities.audioVolume.commands.setVolume.NAME]={
"volume",},[capabilities.colorTemperature.ID ..":"..capabilities.colorTemperature.commands.setColorTemperature.NAME]={
"color_temperature",},[capabilities.colorControl.ID ..":"..capabilities.colorControl.commands.setHue.NAME]={
"color_hue",},[capabilities.colorControl.ID ..":"..capabilities.colorControl.commands.setSaturation.NAME]={
"color_saturation",},[capabilities.colorControl.ID ..":"..capabilities.colorControl.commands.setColor.NAME]={
"color_hue","color_saturation",},}
local function t(a)
return type(a)=="table"and(
a.network_type==bZ.NETWORK_TYPE_CHILD or
type(a.parent_assigned_child_key)=="string")
end
local function am(j,a,aI)
if type(j)~="table"or type(a)~="table"or type(j.try_delete_device)~="function"then
return
end
if a.thread~=nil and type(a.thread.call_with_delay)=="function"then
a.thread:call_with_delay(1,function()
if type(aI)=="function"and aI()then return end
j:try_delete_device(a.id)
end,string.format("delete unexpected child %s",tostring(a.id)))
return
end
if type(aI)=="function"and aI()then return end
j:try_delete_device(a.id)
end
local u
local function aP(a,d,bw,n)
local b=h(a)if b==nil or not u(b,a,bw)then
return false
end
local k=false
if b.datapoints then
k=b:send_named_mapping(a,bw,n,{
component_id=d.component,})or k
end
if b.zcl_clusters then
k=I.send_named_command(a,b.zcl_clusters,bw,n,{
component_id=d.component,zcl_clusters=b.zcl_clusters,})or k
end
if not k and b.protocol_writers and b.protocol_writers[bw]then
k=b.protocol_writers[bw](a,n,d)==true
end
return k
end
local function P(a)
return bh.find(a:get_manufacturer(),a:get_model())
end
local function al(j,a)
if not t(a)or type(j)~="table"or
type(j.get_device_info)~="function"then
return nil
end
local bb=j:get_device_info(a.parent_device_id)if bb==nil then
return nil
end
return P(bb),bb
end
local function ah(j,a)
local e,bb=al(j,a)local bv=e~=nil and e.allow_child_devices==true
if bv and type(e.is_expected_child)=="function"then
bv=e.is_expected_child(bb,a,e)==true
end
if not bv then return false end
aM[a]=e
if type(e.child_runtime_start)=="function"then
e.child_runtime_start(a,e,bb)
end
return true
end
u=function(b,a,bw)
if not t(a)then return true end
return type(b)=="table"and
type(b.child_command_allowed)=="function"and
b.child_command_allowed(a,bw,b)==true
end
local function aw(j,a,e)
if type(e)~="table"or type(e.create_child_devices)~="function"then
return
end
local cc=function()
e.create_child_devices(j,a,e)
end
if a.thread~=nil and type(a.thread.call_with_delay)=="function"then
a.thread:call_with_delay(1,cc,"create dynamic endpoint children")return
end
cc()
end
local function aU(a)
local b=h(a)return b~=nil and b.zcl_clusters~=nil and I.has_cluster(b.zcl_clusters,I.CLUSTER_ON_OFF)
end
local function aE(a,f)
if type(a)~="table"or type(a.get_endpoint_for_component_id)~="function"then
return 1
end
local aq=a:get_endpoint_for_component_id(f or"main")if type(aq)=="table"then
aq=aq[1]
end
if type(aq)~="number"then
return 1
end
return aq
end
local function aA(a)
local b=h(a)return b~=nil and b.zcl_clusters~=nil and I.has_cluster(b.zcl_clusters,aC)
end
local function Z(a,f,n)
local m=f or"main"
if type(a)~="table"or not a:supports_capability_by_id(capabilities.alarm.ID,m)then
return
end
a:emit_component_event({id=m},capabilities.alarm.alarm[n]())
end
local function Q(a,d,cp)
local b=h(a)local n=cp~="off"
if b~=nil and b.alarm_command_modes==true then
n=cp
end
return aP(a,d,"alarm",n)
end
local function w(a,f,bT,bc,bV,ci)
if not aA(a)then
return false
end
local L=ad.IASWD.types.SirenConfiguration(0)L:set_warning_mode(bT)L:set_strobe(bc and 1 or 0)L:set_siren_level(bV)local aq=aE(a,f)local d=ad.IASWD.server.commands.StartWarning(
a,L,bB.Uint16(ci or 0),bB.Uint8(0),ad.IASWD.types.IaswdLevel(bc and A or W))a:send(d:to_endpoint(aq))return true
end
local l=ak.create({
get_preset=h,send=aP,resolve_definition=P,})
local function ap(j,a,b)
if b==nil then
return
end
if type(b.configure)=="function"then
b.configure(j,a)
end
b:start_configuration(a,j)if b.zcl_clusters then
I.start_configuration(a,b.zcl_clusters)
end
if type(b.zcl_initial_writes)=="table"then
for _,cm in ipairs(b.zcl_initial_writes)do
I.send_named_command(a,b.zcl_clusters,cm.name,cm.value)
end
end
end
local function bi(a,b)
if b and b.zcl_clusters then
I.start_runtime(a,b.zcl_clusters)I.emit_power_polling_state(a,b.zcl_clusters)if I.emit_ir_state~=nil then
I.emit_ir_state(a,b)
end
if a.thread~=nil and type(a.thread.call_with_delay)=="function"then
a.thread:call_with_delay(2,function()
I.emit_power_polling_state(a,b.zcl_clusters)if I.emit_ir_state~=nil then
I.emit_ir_state(a,b)
end
end,"zcl initial power polling state")
end
else
af(a,b)
end
if b~=nil and b.configure_options~=nil and
b.configure_options.query_interval_seconds~=nil then
b:start_query_timer(a)
end
if b~=nil and type(b.runtime_start)=="function"then
b.runtime_start(a,b)
end
end
local function ae(a,e,bq)
l.refresh_definitions(a)if bq then
l.diagnose_bindings(a)
end
bg(a,e)l.emit_numeric_metadata(a,e)l.emit_enum_metadata(a,e)
end
local function aO(a,f,aD,bG)
if type(aD)~="table"or aD[1]==nil or a.thread==nil or type(a.thread.call_with_delay)~="function"then
return
end
local b=h(a)if b==nil or b.zcl_clusters==nil then
return
end
a.thread:call_with_delay(bG or 2,function()
for _,aK in ipairs(aD)do
I.read_named_attribute(a,b.zcl_clusters,aK,{
component_id=f,})
end
end,string.format("zcl delayed read %s",tostring(f or"main")))
end
local function aW(a,f,n)
local m=f or"main"
if type(a)~="table"or not a:supports_capability_by_id(capabilities.switch.ID,m)then
return
end
local cq=n and capabilities.switch.switch.on()or capabilities.switch.switch.off()a:emit_component_event({id=m},cq)
end
local function Y(a,bG,cr)
if type(a)~="table"or a.thread==nil or type(a.thread.call_with_delay)~="function"then
return
end
a.thread:call_with_delay(bG,function()
local b=h(a)if b~=nil and b.datapoints~=nil then
b:send_state_request(a)
end
end,cr or"ef00 delayed state request")
end
local function v(a,d,n)
local f=d and d.component or"main"
local b=h(a)local bM=b and b.named_mappings_by_name
if bM==nil and b and b.datapoints then
bM=aZ.build_named_map(b.datapoints,"name")
end
local bW=bM and bM.switch
if bW==nil or bW.suppress_optimistic_state~=true then
aW(a,f,n)
end
Y(a,1,"ef00 switch state read 1s")Y(a,3,"ef00 switch state read 3s")
end
local function ac(n)
local r=tonumber(n)if r==nil then
return nil
end
r=math.floor(r+0.5)if r<0 then
return 0
end
if r>100 then
return 100
end
return r
end
local function be(a,f)
if type(a)~="table"or type(a.get_latest_state)~="function"then
return 0
end
local aG=a:get_latest_state(f or"main",capabilities.switchLevel.ID,"level")return ac(aG)or 0
end
local function av(a,f)
local m=f or"main"
if type(a)~="table"then
return 0
end
local b=h(a)local aL=K.by_emit_name[
b and b.minimum_brightness_capability or"ef00Ts0601MinimumBrightness"]if type(aL)~="table"or not a:supports_capability_by_id(aL.capability_id,m)then
return 0
end
local br=a:get_latest_state(
m,aL.capability_id,aL.attribute_name)local aY=tonumber(br)if aY==nil or aY<=0 then
return 0
end
return ac(math.ceil(aY*100/aL.default_range.maximum))or 0
end
local function aQ(a,f,aG)
local m=f or"main"
if type(a)~="table"or not a:supports_capability_by_id(capabilities.switchLevel.ID,m)then
return
end
a:emit_component_event({id=m},capabilities.switchLevel.level(aG))
end
local function ai(a,d)
local f=d and d.component or"main"
local H=d and d.args and d.args.stepSize or nil
H=tonumber(H)if H==nil then
return
end
H=math.floor(H+0.5)if H<-100 then
H=-100
elseif H>100 then
H=100
end
local C=ac(be(a,f)+H)if C==nil then
return
end
local bl=av(a,f)if C<bl then
C=bl
end
if C>0 then
aP(a,d,"switch",true)
end
local k=aP(a,d,"brightness",C)if C==0 then
k=aP(a,d,"switch",false)or k
end
if k then
aQ(a,f,C)if C==0 then
v(a,d,false)else
v(a,d,true)
end
end
end
local function aF()
local i={}for _,cd in ipairs(bn)do
local bz,cmd_name,bS,as,bL=cd[1],cd[2],cd[3],cd[4],cd[5]if i[bz]==nil then
i[bz]={}
end
i[bz][cmd_name]=function(_,a,d)
local n=as
if type(as)=="function"then
n=as(d)elseif type(as)=="string"and d.args and d.args[as]~=nil then
n=d.args[as]
end
local b=h(a)if not u(b,a,bS)then
return
end
if bL and(b==nil or b.auto_on_before_light_command~=false)then
aP(a,d,"switch",true)
end
local k=aP(a,d,bS,n)if k then
local bJ=aJ[bz ..":"..cmd_name]if bJ~=nil then
aO(a,d.component,bJ,2)
end
end
end
end
local aa={}for _,bf in pairs(bh.all())do
for _,e in pairs(bf)do
for _,X in ipairs(e.capability_commands or{})do
local E=X.capability_id
local command_name=X.command_name
local aN=E ..":"..command_name
if not aa[aN]then
aa[aN]=true
local aK=X.mapping_name
local bk=X.argument_name
local bU=X.value
i[E]=i[E]or{}
i[E][command_name]=function(_,a,d)
local n=bU
if bk~=nil then
n=d.args and d.args[bk]or nil
end
aP(a,d,aK,n)
end
end
end
end
end
i[capabilities.switch.ID]=i[capabilities.switch.ID]or{}
i[capabilities.switch.ID][capabilities.switch.commands.on.NAME]=function(j,a,d)
if not u(h(a),a,"switch")then return end
at.route({
driver=j,device=a,command=d,value=true,uses_zcl_on_off=aU,send_named=aP,
begin_power_poll_burst=function(bm)
local b=h(bm)if b~=nil and b.zcl_clusters~=nil and I.begin_power_poll_burst~=nil then
I.begin_power_poll_burst(bm,b.zcl_clusters)
end
end,
after_ef00_switch_command=v,default_handler=bs,})
end
i[capabilities.switch.ID][capabilities.switch.commands.off.NAME]=function(j,a,d)
if not u(h(a),a,"switch")then return end
at.route({
driver=j,device=a,command=d,value=false,uses_zcl_on_off=aU,send_named=aP,after_ef00_switch_command=v,default_handler=bp,})
end
i[ax]={
[ag]=function(_,a,d)
ai(a,d)
end,
}i[capabilities.alarm.ID]={
[capabilities.alarm.commands.off.NAME]=function(_,a,d)
local k=w(
a,d.component,ba,false,W,0)if not k then
k=Q(a,d,"off")
end
if k then
Z(a,d.component,"off")
end
end,
[capabilities.alarm.commands.siren.NAME]=function(_,a,d)
local k=w(
a,d.component,D,false,A,y)if not k then
k=Q(a,d,"siren")
end
if k then
Z(a,d.component,"siren")
end
end,
[capabilities.alarm.commands.strobe.NAME]=function(_,a,d)
local k=w(
a,d.component,D,true,W,y)if not k then
k=Q(a,d,"strobe")
end
if k then
Z(a,d.component,"strobe")
end
end,
[capabilities.alarm.commands.both.NAME]=function(_,a,d)
local k=w(
a,d.component,D,true,A,y)if not k then
k=Q(a,d,"both")
end
if k then
Z(a,d.component,"both")
end
end,
}i[capabilities.windowShadePreset.ID]={
[capabilities.windowShadePreset.commands.setPresetPosition.NAME]=function(_,a,d)
local aG=d.args and d.args.position or nil
if type(aG)~="number"then
return
end
a:set_field(an(d.component),aG,{persist=true})a:emit_component_event({id=d.component},capabilities.windowShadePreset.position(aG))
end,
[capabilities.windowShadePreset.commands.presetPosition.NAME]=function(_,a,d)
local aG=F(a,d.component)aP(a,d,"cover_position",aG)
end,
}i[capabilities.energyMeter.ID]=i[capabilities.energyMeter.ID]or{}i[capabilities.energyMeter.ID][capabilities.energyMeter.commands.resetEnergyMeter.NAME]=
bQ.handle_reset
i[capabilities.refresh.ID]={
[capabilities.refresh.commands.refresh.NAME]=function(j,a)
local b=h(a)if b==nil then
return
end
if t(a)and type(b.child_refresh)=="function"then
b.child_refresh(a,b)return
end
if not t(a)and type(b.parent_refresh)=="function"then
b.parent_refresh(a,b)return
end
if type(b.parent_refresh)=="function"then
b.parent_refresh(a,b,j)return
end
if b.datapoints and b.refresh_state_query~=false then
b:send_state_request(a)
end
if b.zcl_clusters then
if type(b.zcl_refresh_before_read_all)=="function"then
b.zcl_refresh_before_read_all(a,b)
end
I.read_all_attributes(a,b.zcl_clusters)
end
end,
}l.register_handlers(i)if g~=nil then
i[g.capability_id]=i[g.capability_id]or{}
i[g.capability_id][g.command_name]=function(_,a,d)
local b=h(a)if b==nil then
return
end
local n=d.args and d.args[g.argument_name]or nil
if b.zcl_clusters~=nil then
I.set_power_poll_interval(a,b.zcl_clusters,n)return
end
if not B(a,b)then
return
end
local bR=N(n)if bR==nil then
return
end
a:set_field(M,bR,{persist=true})af(a,b)
end
end
if q~=nil then
i[q.capability_id]=i[q.capability_id]or{}
i[q.capability_id][q.command_name]=function(_,a,d)
local b=h(a)if b==nil or b.ir_controller~=true then
return
end
local n=d.args and d.args[q.argument_name]or nil
if n=="start"then
I.start_ir_learning(a,b)elseif n=="stop"then
I.stop_ir_learning(a,b)
end
end
end
if p~=nil then
i[p.capability_id]=i[p.capability_id]or{}
i[p.capability_id][p.command_name]=function(_,a,d)
local b=h(a)if b==nil or b.ir_controller~=true then
return
end
local bt=d.args or{}local n=bt[p.argument_name]if type(n)~="string"and type(bt.value)=="string"then
n=bt.value
end
if type(n)~="string"or n==""then
return
end
I.send_ir_code(a,b,n)
end
end
return i
end
local bD={
supported_capabilities={},additional_zcl_profiles=x,zigbee_handlers={
cluster=aV(),global=I.build_zigbee_global_handlers(h),attr=I.build_zigbee_attr_handlers(h),zdo={
[aB]=aX,},},lifecycle_handlers={
init=function(j,a)
if t(a)then
if ah(j,a)then return end
am(j,a,function()
return ah(j,a)
end)
return
end
local e=P(a)local au=e and e.valid_parent_profiles
if e and e.profile and a.profile.id~=e.profile and
(type(au)~="table"or au[a.profile.id]~=true)then
a:try_update_metadata({profile=e.profile})
end
V.apply(a,e)ae(a,e,true)l.emit_driver_message(a,"Custom motion controls initialized.")local b=h(a)bi(a,b)ay.start_daily(a)O(a)l.maybe_request_initial_custom_state(a,b)aw(j,a,e)
end,
doConfigure=function(j,a)
if t(a)then
return
end
ap(j,a,h(a))
end,
driverSwitched=function(j,a)
if t(a)then
return
end
local b=h(a)if b==nil then
return
end
ap(j,a,b)a:try_update_metadata({provisioning_state="PROVISIONED"})
end,
infoChanged=function(j,a,_,bt)
if t(a)then
return
end
if not bt.old_st_store then
return
end
local e=P(a)local aT=a.profile.id~=bt.old_st_store.profile.id
if aT then
V.apply(a,e)ap(j,a,h(a))
end
local b=h(a)if b then
b:apply_preferences_changed(a,bt.old_st_store.preferences)if b.zcl_clusters then
I.emit_power_polling_state(a,b.zcl_clusters)else
U(a,b)
end
end
ay.start_daily(a)O(a)ae(a,e,aT)
end,
},capability_handlers=aF(),health_check=false,}local bO=require"st.zigbee"
local j=bO("tuya-universal",bD)local bC=j.zigbee_message_dispatcher
local ch=bC.dispatch
function bC:dispatch(j,a,bN,...)
if a:supports_capability_by_id(capabilities.signalStrength.ID,"main")then
local bX={visibility={displayed=false}}a:emit_event(capabilities.signalStrength.lqi(bN.lqi.value,bX))if bN.rssi.value<=0 then
a:emit_event(capabilities.signalStrength.rssi({value=bN.rssi.value,unit="dBm"},bX))
end
end
return ch(self,j,a,bN,...)
end
j:run()
