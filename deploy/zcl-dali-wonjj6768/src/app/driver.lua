local aZ=require"protocol.tuya"
local J=require"protocol.zcl"
local bi=require"core.registry"
local L=require"runtime.capability_metadata"
local capabilities=require"st.capabilities"
local ca=require"st.device"
local bB=require"st.zigbee.data_types"
local ad=require"st.zigbee.generated.zcl_clusters"
local V=require"app.component_mapping"
local ak=require"app.custom_capability_runtime"
local ay=require"runtime.battery_refresh"
local bQ=require"runtime.energy_reset"
local at=require"app.switch_command_router"
local bt=require"st.zigbee.defaults.switch_defaults.on"
local bq=require"st.zigbee.defaults.switch_defaults.off"
local g=L.by_emit_name.power_poll_interval
local q=L.by_emit_name.learn_ir_code
local p=L.by_emit_name.ir_code_to_send
local T="_presetLevel"
local aj=50
local N="_tuya_power_poll_interval_seconds"
local ao=300
local o=5
local B=3600
local R=5
local S="s"
local aC=1282
local ba=0
local F=3
local W=0
local C=3
local A=300
local ax="statelessSwitchLevelStep"
local ag="stepLevel"
local aB=19
local aM=setmetatable({},{__mode="k"})
local function aH()
local by=bi.all()local z={}for _,cg in pairs(by)do
for _,e in pairs(cg)do
for _,cb in ipairs(e.additional_zcl_profiles or{})do
z[cb]=true
end
if e.zcl_clusters then
J.register_attributes_from_mappings(e.zcl_clusters)J.register_cluster_commands_from_mappings(e.zcl_clusters)J.prepare_mappings(e.zcl_clusters)
end
end
end
return z
end
local z=aH()
local function h(a)
local cc=aM[a]if cc then
return cc
end
local bp=a:get_manufacturer()local cl=a:get_model()if not bp or not cl then
return nil
end
local e=bi.find(bp,cl)if not e then
return nil
end
local b=aZ.build_base_preset(e)for co,n in pairs(e)do
if co~="fingerprints"and b[co]==nil then
b[co]=n
end
end
if b.zcl_clusters then
J.prepare_mappings(b.zcl_clusters)
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
return J.read_attribute(a,1,32,a:get_endpoint(1))
end,function(a)
local b=h(a)return b~=nil and b.zcl_clusters~=nil and
J.has_cluster(b.zcl_clusters,J.CLUSTER_POWER_CONFIGURATION)
end)
local az=require"runtime.capability_support".is_callable
local function ar(a,u)
if type(a)~="table"or type(u)~="string"then
return false
end
local bA=a.profile and a.profile.components or nil
local cp=type(bA)=="table"and bA.main or nil
local aS=type(cp)=="table"and cp.capabilities or nil
if type(aS)~="table"then
return false
end
for _,s in ipairs(aS)do
if type(s)=="table"and s.id==u then
return true
end
end
return false
end
local function x(n)
local r=tonumber(n)if r==nil then
return nil
end
r=math.floor(r+0.5)if r<o then
r=o
elseif r>B then
r=B
end
local bM=r%R
if bM~=0 then
r=r-bM
if r<o then
r=o
end
end
return r
end
local function D(a,b)
return type(b)=="table"
and b.zcl_clusters==nil
and type(b.datapoints)=="table"
and g~=nil
and ar(a,g.capability_id)
end
local function H(a,b)
local ck=x(a:get_field(N))local bI=x(b and b.default_power_poll_interval_seconds)return ck or bI or ao
end
local function U(a,b)
if not D(a,b)then
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
a:emit_event(ab{
value={
minimum=o,maximum=B,step=R},unit=S})
end
a:emit_event(aR{
value=H(a,b),unit=S})return true
end
local function af(a,b)
if not D(a,b)then
return false
end
b:start_query_timer(a,H(a,b))U(a,b)return true
end
local function an(f)
return string.format("%s:%s",T,tostring(f or"main"))
end
local function G(a,f)
f=f or"main"
local cf=a:get_latest_state(f,capabilities.windowShadePreset.ID,"position")if type(cf)=="number"then
return cf
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
{id=f},capabilities.windowShadePreset.position(G(a,f)))
end
end
end
local function bh(a,e)
if type(e)~="table"or type(e.button_actions)~="table"then
return
end
local bx=e.button_actions
for _,f in ipairs(V.sorted_profile_component_ids(a))do
if a:supports_capability_by_id(capabilities.button.ID,f)then
a:emit_component_event({id=f},capabilities.button.supportedButtonValues(bx))a:emit_component_event({id=f},capabilities.button.numberOfButtons{value=1})
end
end
end
local function K(_,a,bJ)
local b=h(a)if b then
b:apply_message(a,bJ)
end
end
local function aV()
local i={
[aZ.EF00_CLUSTER]={
[aZ.GET_DATA]=K,[aZ.SET_DATA_RESPONSE]=K,[aZ.REPORT_STATUS]=K,[aZ.ACTIVE_STATUS_REPORT]=K,[aZ.SET_TIME]=K,[aZ.CONNECTION_STATUS]=K,[aZ.MCU_VERSION_RESPONSE]=K}}local bk=J.build_zigbee_cluster_handlers(h)for be,bu in pairs(bk)do
i[be]=i[be]or{}for bZ,cm in pairs(bu)do
i[be][bZ]=cm
end
end
return i
end
local bn={
{capabilities.switch.ID,"on","switch",true},{capabilities.switch.ID,"off","switch",false},{capabilities.audioVolume.ID,"setVolume","volume","volume"},{capabilities.doorControl.ID,"open","door_control",true},{capabilities.doorControl.ID,"close","door_control",false},{capabilities.valve.ID,"open","valve","open"},{capabilities.valve.ID,"close","valve","closed"},{capabilities.switchLevel.ID,"setLevel","brightness","level"},{capabilities.windowShade.ID,"open","cover_state","open"},{capabilities.windowShade.ID,"close","cover_state","close"},{capabilities.windowShade.ID,"pause","cover_state","stop"},{capabilities.windowShadeLevel.ID,"setShadeLevel","cover_position","shadeLevel"},{capabilities.windowShadeTiltLevel.ID,"setShadeTiltLevel","cover_tilt","level"},{capabilities.thermostatHeatingSetpoint.ID,"setHeatingSetpoint","current_heating_setpoint","setpoint"},{capabilities.thermostatCoolingSetpoint.ID,"setCoolingSetpoint","current_cooling_setpoint","setpoint"},{capabilities.thermostatMode.ID,"setThermostatMode","system_mode","mode"},{capabilities.thermostatMode.ID,"auto","system_mode","auto"},{capabilities.thermostatMode.ID,"cool","system_mode","cool"},{capabilities.thermostatMode.ID,"emergencyHeat","system_mode","emergency heat"},{capabilities.thermostatMode.ID,"heat","system_mode","heat"},{capabilities.thermostatMode.ID,"off","system_mode","off"},{capabilities.fanMode.ID,"setFanMode","fan_mode","fanMode"},{capabilities.colorTemperature.ID,"setColorTemperature","color_temperature","temperature",true},{capabilities.colorControl.ID,"setHue","color_hue","hue",true},{capabilities.colorControl.ID,"setSaturation","color_saturation","saturation",true},
{capabilities.colorControl.ID,"setColor","color",function(d)
return d.args and d.args.color or nil
end,true}
}local aK={
[capabilities.audioVolume.ID ..":"..capabilities.audioVolume.commands.setVolume.NAME]={
"volume"},[capabilities.colorTemperature.ID ..":"..capabilities.colorTemperature.commands.setColorTemperature.NAME]={
"color_temperature"},[capabilities.colorControl.ID ..":"..capabilities.colorControl.commands.setHue.NAME]={
"color_hue"},[capabilities.colorControl.ID ..":"..capabilities.colorControl.commands.setSaturation.NAME]={
"color_saturation"},[capabilities.colorControl.ID ..":"..capabilities.colorControl.commands.setColor.NAME]={
"color_hue","color_saturation"}}
local function t(a)
return type(a)=="table"and(
a.network_type==ca.NETWORK_TYPE_CHILD or
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
local v
local function aP(a,d,bw,n)
local b=h(a)if b==nil or not v(b,a,bw)then
return false
end
local k=false
if b.datapoints then
k=b:send_named_mapping(a,bw,n,{
component_id=d.component})or k
end
if b.zcl_clusters then
k=J.send_named_command(a,b.zcl_clusters,bw,n,{
component_id=d.component,zcl_clusters=b.zcl_clusters})or k
end
if not k and b.protocol_writers and b.protocol_writers[bw]then
k=b.protocol_writers[bw](a,n,d)==true
end
return k
end
local function P(a)
return bi.find(a:get_manufacturer(),a:get_model())
end
local function al(j,a)
if not t(a)or type(j)~="table"or
type(j.get_device_info)~="function"then
return nil
end
local bc=j:get_device_info(a.parent_device_id)if bc==nil then
return nil
end
return P(bc),bc
end
local function ah(j,a)
local e,bc=al(j,a)local bv=e~=nil and e.allow_child_devices==true
if bv and type(e.is_expected_child)=="function"then
bv=e.is_expected_child(bc,a,e)==true
end
if not bv then return false end
aM[a]=e
if type(e.child_runtime_start)=="function"then
e.child_runtime_start(a,e,bc)
end
return true
end
v=function(b,a,bw)
if not t(a)then return true end
return type(b)=="table"and
type(b.child_command_allowed)=="function"and
b.child_command_allowed(a,bw,b)==true
end
local function aw(j,a,e)
if type(e)~="table"or type(e.create_child_devices)~="function"then
return
end
local cd=function()
e.create_child_devices(j,a,e)
end
if a.thread~=nil and type(a.thread.call_with_delay)=="function"then
a.thread:call_with_delay(1,cd,"create dynamic endpoint children")return
end
cd()
end
local function aU(a)
local b=h(a)return b~=nil and b.zcl_clusters~=nil and J.has_cluster(b.zcl_clusters,J.CLUSTER_ON_OFF)
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
local b=h(a)return b~=nil and b.zcl_clusters~=nil and J.has_cluster(b.zcl_clusters,aC)
end
local function Y(a,f,n)
local m=f or"main"
if type(a)~="table"or not a:supports_capability_by_id(capabilities.alarm.ID,m)then
return
end
a:emit_component_event({id=m},capabilities.alarm.alarm[n]())
end
local function Q(a,d,cq)
local b=h(a)local n=cq~="off"
if b~=nil and b.alarm_command_modes==true then
n=cq
end
return aP(a,d,"alarm",n)
end
local function y(a,f,bV,bd,bW,cj)
if not aA(a)then
return false
end
local M=ad.IASWD.types.SirenConfiguration(0)M:set_warning_mode(bV)M:set_strobe(bd and 1 or 0)M:set_siren_level(bW)local aq=aE(a,f)local d=ad.IASWD.server.commands.StartWarning(
a,M,bB.Uint16(cj or 0),bB.Uint8(0),ad.IASWD.types.IaswdLevel(bd and C or W))a:send(d:to_endpoint(aq))return true
end
local l=ak.create{
get_preset=h,send=aP,resolve_definition=P}
local function ap(j,a,b)
if b==nil then
return
end
if type(b.configure)=="function"then
b.configure(j,a)
end
b:start_configuration(a,j)if b.zcl_clusters then
J.start_configuration(a,b.zcl_clusters)
end
if type(b.zcl_initial_writes)=="table"then
for _,cn in ipairs(b.zcl_initial_writes)do
J.send_named_command(a,b.zcl_clusters,cn.name,cn.value)
end
end
end
local function bj(a,b)
if b and b.zcl_clusters then
J.start_runtime(a,b.zcl_clusters)J.emit_power_polling_state(a,b.zcl_clusters)if J.emit_ir_state~=nil then
J.emit_ir_state(a,b)
end
if a.thread~=nil and type(a.thread.call_with_delay)=="function"then
a.thread:call_with_delay(2,function()
J.emit_power_polling_state(a,b.zcl_clusters)if J.emit_ir_state~=nil then
J.emit_ir_state(a,b)
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
local function ae(a,e,br)
l.refresh_definitions(a)if br then
l.diagnose_bindings(a)
end
bh(a,e)l.emit_numeric_metadata(a,e)l.emit_enum_metadata(a,e)
end
local function aO(a,f,aD,bH)
if type(aD)~="table"or aD[1]==nil or a.thread==nil or type(a.thread.call_with_delay)~="function"then
return
end
local b=h(a)if b==nil or b.zcl_clusters==nil then
return
end
a.thread:call_with_delay(bH or 2,function()
for _,bU in ipairs(aD)do
J.read_named_attribute(a,b.zcl_clusters,bU,{
component_id=f})
end
end,string.format("zcl delayed read %s",tostring(f or"main")))
end
local function aW(a,f,n)
local m=f or"main"
if type(a)~="table"or not a:supports_capability_by_id(capabilities.switch.ID,m)then
return
end
local cr=n and capabilities.switch.switch.on()or capabilities.switch.switch.off()a:emit_component_event({id=m},cr)
end
local function X(a,bH,cs)
if type(a)~="table"or a.thread==nil or type(a.thread.call_with_delay)~="function"then
return
end
a.thread:call_with_delay(bH,function()
local b=h(a)if b~=nil and b.datapoints~=nil then
b:send_state_request(a)
end
end,cs or"ef00 delayed state request")
end
local function w(a,d,n)
local f=d and d.component or"main"
local b=h(a)if b==nil or b.datapoints==nil then
return
end
local bO=b and b.named_mappings_by_name
if bO==nil and b and b.datapoints then
bO=aZ.build_named_map(b.datapoints,"name")
end
local bX=bO and bO.switch
if bX==nil or bX.suppress_optimistic_state~=true then
aW(a,f,n)
end
if b.post_switch_state_query~=false then
X(a,1,"ef00 switch state read 1s")X(a,3,"ef00 switch state read 3s")
end
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
local function bf(a,f)
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
local b=h(a)local aL=L.by_emit_name[
b and b.minimum_brightness_capability or"ef00Ts0601MinimumBrightness"]if type(aL)~="table"or not a:supports_capability_by_id(aL.capability_id,m)then
return 0
end
local bs=a:get_latest_state(
m,aL.capability_id,aL.attribute_name)local aY=tonumber(bs)if aY==nil or aY<=0 then
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
local I=d and d.args and d.args.stepSize or nil
I=tonumber(I)if I==nil then
return
end
I=math.floor(I+0.5)if I<-100 then
I=-100
elseif I>100 then
I=100
end
local E=ac(bf(a,f)+I)if E==nil then
return
end
local bl=av(a,f)if E<bl then
E=bl
end
if E>0 then
aP(a,d,"switch",true)
end
local k=aP(a,d,"brightness",E)if E==0 then
k=aP(a,d,"switch",false)or k
end
if k then
aQ(a,f,E)if E==0 then
w(a,d,false)else
w(a,d,true)
end
end
end
local function aF()
local i={}for _,ce in ipairs(bn)do
local bz,cmd_name,bT,as,bN=ce[1],ce[2],ce[3],ce[4],ce[5]if i[bz]==nil then
i[bz]={}
end
i[bz][cmd_name]=function(_,a,d)
local n=as
if type(as)=="function"then
n=as(d)elseif type(as)=="string"and d.args and d.args[as]~=nil then
n=d.args[as]
end
local b=h(a)if not v(b,a,bT)then
return
end
if bN and(b==nil or b.auto_on_before_light_command~=false)then
aP(a,d,"switch",true)
end
local k=aP(a,d,bT,n)if k then
local bL=aK[bz ..":"..cmd_name]if bL~=nil then
aO(a,d.component,bL,2)
end
end
end
end
l.register_handlers(i)local Z={}for _,bg in pairs(bi.all())do
for _,e in pairs(bg)do
for _,bb in ipairs(e.capability_commands or{})do
local u=bb.capability_id
local command_name=bb.command_name
local aN=u ..":"..command_name
if not Z[aN]then
Z[aN]=true
i[u]=i[u]or{}local bR=i[u][command_name]
i[u][command_name]=function(j,a,d)
local b=h(a)for _,aa in ipairs(b and b.capability_commands or{})do
if aa.capability_id==u and aa.command_name==command_name then
local n=aa.value
if aa.argument_name~=nil then
n=d.args and d.args[aa.argument_name]or nil
end
return aP(a,d,aa.mapping_name,n)
end
end
if bR~=nil then return bR(j,a,d)end
end
end
end
end
end
i[capabilities.switch.ID]=i[capabilities.switch.ID]or{}
i[capabilities.switch.ID][capabilities.switch.commands.on.NAME]=function(j,a,d)
if not v(h(a),a,"switch")then return end
at.route{
driver=j,device=a,command=d,value=true,uses_zcl_on_off=aU,send_named=aP,
begin_power_poll_burst=function(bm)
local b=h(bm)if b~=nil and b.zcl_clusters~=nil and J.begin_power_poll_burst~=nil then
J.begin_power_poll_burst(bm,b.zcl_clusters)
end
end,
after_ef00_switch_command=w,default_handler=bt}
end
i[capabilities.switch.ID][capabilities.switch.commands.off.NAME]=function(j,a,d)
if not v(h(a),a,"switch")then return end
at.route{
driver=j,device=a,command=d,value=false,uses_zcl_on_off=aU,send_named=aP,after_ef00_switch_command=w,default_handler=bq}
end
i[ax]={
[ag]=function(_,a,d)
ai(a,d)
end
}i[capabilities.alarm.ID]={
[capabilities.alarm.commands.off.NAME]=function(_,a,d)
local k=y(
a,d.component,ba,false,W,0)if not k then
k=Q(a,d,"off")
end
if k then
Y(a,d.component,"off")
end
end,
[capabilities.alarm.commands.siren.NAME]=function(_,a,d)
local k=y(
a,d.component,F,false,C,A)if not k then
k=Q(a,d,"siren")
end
if k then
Y(a,d.component,"siren")
end
end,
[capabilities.alarm.commands.strobe.NAME]=function(_,a,d)
local k=y(
a,d.component,F,true,W,A)if not k then
k=Q(a,d,"strobe")
end
if k then
Y(a,d.component,"strobe")
end
end,
[capabilities.alarm.commands.both.NAME]=function(_,a,d)
local k=y(
a,d.component,F,true,C,A)if not k then
k=Q(a,d,"both")
end
if k then
Y(a,d.component,"both")
end
end
}i[capabilities.windowShadePreset.ID]={
[capabilities.windowShadePreset.commands.setPresetPosition.NAME]=function(_,a,d)
local aG=d.args and d.args.position or nil
if type(aG)~="number"then
return
end
a:set_field(an(d.component),aG,{persist=true})a:emit_component_event({id=d.component},capabilities.windowShadePreset.position(aG))
end,
[capabilities.windowShadePreset.commands.presetPosition.NAME]=function(_,a,d)
local aG=G(a,d.component)aP(a,d,"cover_position",aG)
end
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
J.read_all_attributes(a,b.zcl_clusters)
end
end
}if g~=nil then
i[g.capability_id]=i[g.capability_id]or{}
i[g.capability_id][g.command_name]=function(_,a,d)
local b=h(a)if b==nil then
return
end
local n=d.args and d.args[g.argument_name]or nil
if b.zcl_clusters~=nil then
J.set_power_poll_interval(a,b.zcl_clusters,n)return
end
if not D(a,b)then
return
end
local bS=x(n)if bS==nil then
return
end
a:set_field(N,bS,{persist=true})af(a,b)
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
J.start_ir_learning(a,b)elseif n=="stop"then
J.stop_ir_learning(a,b)
end
end
end
if p~=nil then
i[p.capability_id]=i[p.capability_id]or{}
i[p.capability_id][p.command_name]=function(_,a,d)
local b=h(a)if b==nil or b.ir_controller~=true then
return
end
local bo=d.args or{}local n=bo[p.argument_name]if type(n)~="string"and type(bo.value)=="string"then
n=bo.value
end
if type(n)~="string"or n==""then
return
end
J.send_ir_code(a,b,n)
end
end
return i
end
local bD={
supported_capabilities={},additional_zcl_profiles=z,zigbee_handlers={
cluster=aV(),global=J.build_zigbee_global_handlers(h),attr=J.build_zigbee_attr_handlers(h),zdo={
[aB]=aX}},lifecycle_handlers={
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
not(type(e.parent_profile_matches)=="function"and e.parent_profile_matches(a))and
(type(au)~="table"or au[a.profile.id]~=true)then
a:try_update_metadata{profile=e.profile}
end
V.apply(a,e)ae(a,e,true)l.emit_driver_message(a,"Custom motion controls initialized.")local b=h(a)bj(a,b)ay.start_daily(a)O(a)l.maybe_request_initial_custom_state(a,b)aw(j,a,e)
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
ap(j,a,b)a:try_update_metadata{provisioning_state="PROVISIONED"}
end,
infoChanged=function(j,a,_,bo)
if t(a)then
return
end
if not bo.old_st_store then
return
end
local e=P(a)local aT=a.profile.id~=bo.old_st_store.profile.id
if aT then
V.apply(a,e)ap(j,a,h(a))
end
local b=h(a)
if e~=nil and type(e.preferences_changed)=="function"then
e.preferences_changed(a,bo.old_st_store.preferences)
end
if b then
b:apply_preferences_changed(a,bo.old_st_store.preferences)if b.zcl_clusters then
J.emit_power_polling_state(a,b.zcl_clusters)else
U(a,b)
end
end
ay.start_daily(a)O(a)ae(a,e,aT)
end
},capability_handlers=aF(),health_check=false}local bP=require"st.zigbee"
local j=bP("tuya-universal",bD)local bC=j.zigbee_message_dispatcher
local ci=bC.dispatch
function bC:dispatch(j,a,bG,...)
local b=h(a)if b and b.zigbee_message_handler then
b.zigbee_message_handler(a,bG)
end
if a:supports_capability_by_id(capabilities.signalStrength.ID,"main")then
local bY={visibility={displayed=false}}a:emit_event(capabilities.signalStrength.lqi(bG.lqi.value,bY))if bG.rssi.value<=0 then
a:emit_event(capabilities.signalStrength.rssi({value=bG.rssi.value,unit="dBm"},bY))
end
end
return ci(self,j,a,bG,...)
end
j:run()
