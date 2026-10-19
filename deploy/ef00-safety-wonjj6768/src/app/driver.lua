local aS=require"protocol.tuya"
local G=require"protocol.zcl"
local aZ=require"core.registry"
local I=require"runtime.capability_metadata"
local capabilities=require"st.capabilities"
local bQ=require"st.device"
local bs=require"st.zigbee.data_types"
local aa=require"st.zigbee.generated.zcl_clusters"
local S=require"app.component_mapping"
local ah=require"app.custom_capability_runtime"
local at=require"runtime.battery_refresh"
local bI=require"runtime.energy_reset"
local ap=require"app.switch_command_router"
local bl=require"st.zigbee.defaults.switch_defaults.on"
local bi=require"st.zigbee.defaults.switch_defaults.off"
local f=I.by_emit_name.power_poll_interval
local q=I.by_emit_name.learn_ir_code
local o=I.by_emit_name.ir_code_to_send
local Q="_presetLevel"
local ag=50
local K="_tuya_power_poll_interval_seconds"
local ak=300
local n=5
local x=3600
local O=5
local P="s"
local ax=1282
local aT=0
local B=3
local T=0
local y=3
local w=300
local as="statelessSwitchLevelStep"
local ae="stepLevel"
local aw=19
local bh=setmetatable({},{__mode="k"})
local function aC()
local bp=aZ.all()local v={}for _,bW in pairs(bp)do
for _,g in pairs(bW)do
for _,bS in ipairs(g.additional_zcl_profiles or{})do
v[bS]=true
end
if g.zcl_clusters then
G.register_attributes_from_mappings(g.zcl_clusters)G.register_cluster_commands_from_mappings(g.zcl_clusters)G.prepare_mappings(g.zcl_clusters)
end
end
end
return v
end
local v=aC()
local function i(a)
local bT=bh[a]if bT then
return bT
end
local bg=a:get_manufacturer()local cc=a:get_model()if not bg or not cc then
return nil
end
local g=aZ.find(bg,cc)if not g then
return nil
end
local c=aS.build_base_preset(g)for cf,m in pairs(g)do
if cf~="fingerprints"and c[cf]==nil then
c[cf]=m
end
end
if c.zcl_clusters then
G.prepare_mappings(c.zcl_clusters)
end
bh[a]=c
return c
end
local function aQ(_,a)
local c=i(a)if c==nil then
return false
end
return c:apply_announce(a)
end
at.set_requester(function(a)
return G.read_attribute(a,1,32,1)
end,function(a)
local c=i(a)return c~=nil and c.zcl_clusters~=nil and
G.has_cluster(c.zcl_clusters,G.CLUSTER_POWER_CONFIGURATION)
end)
local au=require("runtime.capability_support").is_callable
local function an(a,C)
if type(a)~="table"or type(C)~="string"then
return false
end
local br=a.profile and a.profile.components or nil
local cg=type(br)=="table"and br.main or nil
local aL=type(cg)=="table"and cg.capabilities or nil
if type(aL)~="table"then
return false
end
for _,s in ipairs(aL)do
if type(s)=="table"and s.id==C then
return true
end
end
return false
end
local function L(m)
local r=tonumber(m)if r==nil then
return nil
end
r=math.floor(r+0.5)if r<n then
r=n
elseif r>x then
r=x
end
local bC=r%O
if bC~=0 then
r=r-bC
if r<n then
r=n
end
end
return r
end
local function z(a,c)
return type(c)=="table"
and c.zcl_clusters==nil
and type(c.datapoints)=="table"
and f~=nil
and an(a,f.capability_id)
end
local function E(a)
local cb=L(a:get_field(K))return cb or ak
end
local function R(a,c)
if not z(a,c)then
return false
end
local s=capabilities[f.capability_id]local aK=s and s[f.attribute_name]or nil
if not au(aK)and s and type(s.attributes)=="table"then
aK=s.attributes[f.attribute_name]
end
if not au(aK)then
return false
end
local Y=s and s[f.range_attribute_name]or nil
if not au(Y)and s and type(s.attributes)=="table"then
Y=s.attributes[f.range_attribute_name]
end
if au(Y)then
a:emit_event(Y({
value={
minimum=n,maximum=x,step=O,},unit=P,}))
end
a:emit_event(aK({
value=E(a),unit=P,}))return true
end
local function ad(a,c)
if not z(a,c)then
return false
end
c:start_query_timer(a,E(a))R(a,c)return true
end
local function aj(e)
return string.format("%s:%s",Q,tostring(e or"main"))
end
local function D(a,e)
e=e or"main"
local bV=a:get_latest_state(e,capabilities.windowShadePreset.ID,"position")if type(bV)=="number"then
return bV
end
local bx=a:get_field(aj(e))if type(bx)~="number"then
bx=a:get_field(Q)
end
if type(bx)=="number"then
return bx
end
local bw=a.preferences and a.preferences.presetPosition or nil
if type(bw)=="number"then
return bw
end
return ag
end
local function M(a)
for _,e in ipairs(S.sorted_profile_component_ids(a))do
if a:supports_capability_by_id(capabilities.windowShadePreset.ID,e)then
a:emit_component_event(
{id=e},capabilities.windowShadePreset.position(D(a,e)))
end
end
end
local function aY(a,g)
if type(g)~="table"or type(g.button_actions)~="table"then
return
end
local bo=g.button_actions
for _,e in ipairs(S.sorted_profile_component_ids(a))do
if a:supports_capability_by_id(capabilities.button.ID,e)then
a:emit_component_event({id=e},capabilities.button.supportedButtonValues(bo))a:emit_component_event({id=e},capabilities.button.numberOfButtons({value=1}))
end
end
end
local function H(_,a,bz)
local c=i(a)if c then
c:apply_message(a,bz)
end
end
local function aO()
local h={
[aS.EF00_CLUSTER]={
[aS.GET_DATA]=H,[aS.SET_DATA_RESPONSE]=H,[aS.REPORT_STATUS]=H,[aS.ACTIVE_STATUS_REPORT]=H,[aS.SET_TIME]=H,[aS.CONNECTION_STATUS]=H,[aS.MCU_VERSION_RESPONSE]=H,},}local bb=G.build_zigbee_cluster_handlers(i)for aV,bn in pairs(bb)do
h[aV]=h[aV]or{}for bP,cd in pairs(bn)do
h[aV][bP]=cd
end
end
return h
end
local bf={
{capabilities.switch.ID,"on","switch",true},{capabilities.switch.ID,"off","switch",false},{capabilities.audioVolume.ID,"setVolume","volume","volume"},{capabilities.doorControl.ID,"open","door_control",true},{capabilities.doorControl.ID,"close","door_control",false},{capabilities.valve.ID,"open","valve","open"},{capabilities.valve.ID,"close","valve","closed"},{capabilities.switchLevel.ID,"setLevel","brightness","level"},{capabilities.windowShade.ID,"open","cover_state","open"},{capabilities.windowShade.ID,"close","cover_state","close"},{capabilities.windowShade.ID,"pause","cover_state","stop"},{capabilities.windowShadeLevel.ID,"setShadeLevel","cover_position","shadeLevel"},{capabilities.windowShadeTiltLevel.ID,"setShadeTiltLevel","cover_tilt","level"},{capabilities.thermostatHeatingSetpoint.ID,"setHeatingSetpoint","current_heating_setpoint","setpoint"},{capabilities.thermostatCoolingSetpoint.ID,"setCoolingSetpoint","current_cooling_setpoint","setpoint"},{capabilities.thermostatMode.ID,"setThermostatMode","system_mode","mode"},{capabilities.thermostatMode.ID,"auto","system_mode","auto"},{capabilities.thermostatMode.ID,"cool","system_mode","cool"},{capabilities.thermostatMode.ID,"emergencyHeat","system_mode","emergency heat"},{capabilities.thermostatMode.ID,"heat","system_mode","heat"},{capabilities.thermostatMode.ID,"off","system_mode","off"},{capabilities.fanMode.ID,"setFanMode","fan_mode","fanMode"},{capabilities.colorTemperature.ID,"setColorTemperature","color_temperature","temperature",true},{capabilities.colorControl.ID,"setHue","color_hue","hue",true},{capabilities.colorControl.ID,"setSaturation","color_saturation","saturation",true},
{capabilities.colorControl.ID,"setColor","color",function(d)
return d.args and d.args.color or nil
end,true},
}local aD={
[capabilities.audioVolume.ID ..":"..capabilities.audioVolume.commands.setVolume.NAME]={
"volume",},[capabilities.colorTemperature.ID ..":"..capabilities.colorTemperature.commands.setColorTemperature.NAME]={
"color_temperature",},[capabilities.colorControl.ID ..":"..capabilities.colorControl.commands.setHue.NAME]={
"color_hue",},[capabilities.colorControl.ID ..":"..capabilities.colorControl.commands.setSaturation.NAME]={
"color_saturation",},[capabilities.colorControl.ID ..":"..capabilities.colorControl.commands.setColor.NAME]={
"color_hue","color_saturation",},}
local function bv(a)
return type(a)=="table"and(
a.network_type==bQ.NETWORK_TYPE_CHILD or
type(a.parent_assigned_child_key)=="string")
end
local function ai(p,a)
if type(p)~="table"or type(a)~="table"or type(p.try_delete_device)~="function"then
return
end
if a.thread~=nil and type(a.thread.call_with_delay)=="function"then
a.thread:call_with_delay(1,function()
p:try_delete_device(a.id)
end,string.format("delete unexpected child %s",tostring(a.id)))
return
end
p:try_delete_device(a.id)
end
local function aI(a,d,bR,m)
local c=i(a)if c==nil then
return false
end
local j=false
if c.datapoints then
j=c:send_named_mapping(a,bR,m,{
component_id=d.component,})or j
end
if c.zcl_clusters then
j=G.send_named_command(a,c.zcl_clusters,bR,m,{
component_id=d.component,zcl_clusters=c.zcl_clusters,})or j
end
if not j and c.protocol_writers and c.protocol_writers[bR]then
j=c.protocol_writers[bR](a,m,d)==true
end
return j
end
local function ac(a)
return aZ.find(a:get_manufacturer(),a:get_model())
end
local function aN(a)
local c=i(a)return c~=nil and c.zcl_clusters~=nil and G.has_cluster(c.zcl_clusters,G.CLUSTER_ON_OFF)
end
local function az(a,e)
if type(a)~="table"or type(a.get_endpoint_for_component_id)~="function"then
return 1
end
local am=a:get_endpoint_for_component_id(e or"main")if type(am)=="table"then
am=am[1]
end
if type(am)~="number"then
return 1
end
return am
end
local function av(a)
local c=i(a)return c~=nil and c.zcl_clusters~=nil and G.has_cluster(c.zcl_clusters,ax)
end
local function W(a,e,m)
local l=e or"main"
if type(a)~="table"or not a:supports_capability_by_id(capabilities.alarm.ID,l)then
return
end
a:emit_component_event({id=l},capabilities.alarm.alarm[m]())
end
local function N(a,d,ch)
local c=i(a)local m=ch~="off"
if c~=nil and c.alarm_command_modes==true then
m=ch
end
return aI(a,d,"alarm",m)
end
local function u(a,e,bK,aU,bM,bZ)
if not av(a)then
return false
end
local J=aa.IASWD.types.SirenConfiguration(0)J:set_warning_mode(bK)J:set_strobe(aU and 1 or 0)J:set_siren_level(bM)local am=az(a,e)local d=aa.IASWD.server.commands.StartWarning(
a,J,bs.Uint16(bZ or 0),bs.Uint8(0),aa.IASWD.types.IaswdLevel(aU and y or T))a:send(d:to_endpoint(am))return true
end
local k=ah.create({
get_preset=i,send=aI,resolve_definition=ac,})
local function al(p,a,c)
if c==nil then
return
end
if type(c.configure)=="function"then
c.configure(p,a)
end
c:start_configuration(a,p)if c.zcl_clusters then
G.start_configuration(a,c.zcl_clusters)
end
if type(c.zcl_initial_writes)=="table"then
for _,ce in ipairs(c.zcl_initial_writes)do
G.send_named_command(a,c.zcl_clusters,ce.name,ce.value)
end
end
end
local function ba(a,c)
if c and c.zcl_clusters then
G.start_runtime(a,c.zcl_clusters)G.emit_power_polling_state(a,c.zcl_clusters)if G.emit_ir_state~=nil then
G.emit_ir_state(a,c)
end
if a.thread~=nil and type(a.thread.call_with_delay)=="function"then
a.thread:call_with_delay(2,function()
G.emit_power_polling_state(a,c.zcl_clusters)if G.emit_ir_state~=nil then
G.emit_ir_state(a,c)
end
end,"zcl initial power polling state")
end
else
ad(a,c)
end
if c~=nil and c.configure_options~=nil and
c.configure_options.query_interval_seconds~=nil then
c:start_query_timer(a)
end
if c~=nil and type(c.runtime_start)=="function"then
c.runtime_start(a,c)
end
end
local function ab(a,g,bj)
k.refresh_definitions(a)if bj then
k.diagnose_bindings(a)
end
aY(a,g)k.emit_numeric_metadata(a,g)k.emit_enum_metadata(a,g)
end
local function aH(a,e,ay,by)
if type(ay)~="table"or ay[1]==nil or a.thread==nil or type(a.thread.call_with_delay)~="function"then
return
end
local c=i(a)if c==nil or c.zcl_clusters==nil then
return
end
a.thread:call_with_delay(by or 2,function()
for _,aE in ipairs(ay)do
G.read_named_attribute(a,c.zcl_clusters,aE,{
component_id=e,})
end
end,string.format("zcl delayed read %s",tostring(e or"main")))
end
local function aP(a,e,m)
local l=e or"main"
if type(a)~="table"or not a:supports_capability_by_id(capabilities.switch.ID,l)then
return
end
local ci=m and capabilities.switch.switch.on()or capabilities.switch.switch.off()a:emit_component_event({id=l},ci)
end
local function V(a,by,cj)
if type(a)~="table"or a.thread==nil or type(a.thread.call_with_delay)~="function"then
return
end
a.thread:call_with_delay(by,function()
local c=i(a)if c~=nil and c.datapoints~=nil then
c:send_state_request(a)
end
end,cj or"ef00 delayed state request")
end
local function t(a,d,m)
local e=d and d.component or"main"
local c=i(a)local bE=c and c.named_mappings_by_name
if bE==nil and c and c.datapoints then
bE=aS.build_named_map(c.datapoints,"name")
end
local bN=bE and bE.switch
if bN==nil or bN.suppress_optimistic_state~=true then
aP(a,e,m)
end
V(a,1,"ef00 switch state read 1s")V(a,3,"ef00 switch state read 3s")
end
local function Z(m)
local r=tonumber(m)if r==nil then
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
local function aW(a,e)
if type(a)~="table"or type(a.get_latest_state)~="function"then
return 0
end
local aB=a:get_latest_state(e or"main",capabilities.switchLevel.ID,"level")return Z(aB)or 0
end
local function ar(a,e)
local l=e or"main"
if type(a)~="table"then
return 0
end
local c=i(a)local aF=I.by_emit_name[
c and c.minimum_brightness_capability or"ef00Ts0601MinimumBrightness"]if type(aF)~="table"or not a:supports_capability_by_id(aF.capability_id,l)then
return 0
end
local bk=a:get_latest_state(
l,aF.capability_id,aF.attribute_name)local aR=tonumber(bk)if aR==nil or aR<=0 then
return 0
end
return Z(math.ceil(aR*100/aF.default_range.maximum))or 0
end
local function aJ(a,e,aB)
local l=e or"main"
if type(a)~="table"or not a:supports_capability_by_id(capabilities.switchLevel.ID,l)then
return
end
a:emit_component_event({id=l},capabilities.switchLevel.level(aB))
end
local function af(a,d)
local e=d and d.component or"main"
local F=d and d.args and d.args.stepSize or nil
F=tonumber(F)if F==nil then
return
end
F=math.floor(F+0.5)if F<-100 then
F=-100
elseif F>100 then
F=100
end
local A=Z(aW(a,e)+F)if A==nil then
return
end
local bd=ar(a,e)if A<bd then
A=bd
end
if A>0 then
aI(a,d,"switch",true)
end
local j=aI(a,d,"brightness",A)if A==0 then
j=aI(a,d,"switch",false)or j
end
if j then
aJ(a,e,A)if A==0 then
t(a,d,false)else
t(a,d,true)
end
end
end
local function aA()
local h={}for _,bU in ipairs(bf)do
local bq,cmd_name,ca,ao,bD=bU[1],bU[2],bU[3],bU[4],bU[5]if h[bq]==nil then
h[bq]={}
end
h[bq][cmd_name]=function(_,a,d)
local m=ao
if type(ao)=="function"then
m=ao(d)elseif type(ao)=="string"and d.args and d.args[ao]~=nil then
m=d.args[ao]
end
local c=i(a)if bD and(c==nil or c.auto_on_before_light_command~=false)then
aI(a,d,"switch",true)
end
local j=aI(a,d,ca,m)if j then
local bB=aD[bq ..":"..cmd_name]if bB~=nil then
aH(a,d.component,bB,2)
end
end
end
end
local X={}for _,aX in pairs(aZ.all())do
for _,g in pairs(aX)do
for _,U in ipairs(g.capability_commands or{})do
local C=U.capability_id
local command_name=U.command_name
local aG=C ..":"..command_name
if not X[aG]then
X[aG]=true
local aE=U.mapping_name
local bc=U.argument_name
local bL=U.value
h[C]=h[C]or{}
h[C][command_name]=function(_,a,d)
local m=bL
if bc~=nil then
m=d.args and d.args[bc]or nil
end
aI(a,d,aE,m)
end
end
end
end
end
h[capabilities.switch.ID]=h[capabilities.switch.ID]or{}
h[capabilities.switch.ID][capabilities.switch.commands.on.NAME]=function(p,a,d)
ap.route({
driver=p,device=a,command=d,value=true,uses_zcl_on_off=aN,send_named=aI,
begin_power_poll_burst=function(be)
local c=i(be)if c~=nil and c.zcl_clusters~=nil and G.begin_power_poll_burst~=nil then
G.begin_power_poll_burst(be,c.zcl_clusters)
end
end,
after_ef00_switch_command=t,default_handler=bl,})
end
h[capabilities.switch.ID][capabilities.switch.commands.off.NAME]=function(p,a,d)
ap.route({
driver=p,device=a,command=d,value=false,uses_zcl_on_off=aN,send_named=aI,after_ef00_switch_command=t,default_handler=bi,})
end
h[as]={
[ae]=function(_,a,d)
af(a,d)
end,
}h[capabilities.alarm.ID]={
[capabilities.alarm.commands.off.NAME]=function(_,a,d)
local j=u(
a,d.component,aT,false,T,0)if not j then
j=N(a,d,"off")
end
if j then
W(a,d.component,"off")
end
end,
[capabilities.alarm.commands.siren.NAME]=function(_,a,d)
local j=u(
a,d.component,B,false,y,w)if not j then
j=N(a,d,"siren")
end
if j then
W(a,d.component,"siren")
end
end,
[capabilities.alarm.commands.strobe.NAME]=function(_,a,d)
local j=u(
a,d.component,B,true,T,w)if not j then
j=N(a,d,"strobe")
end
if j then
W(a,d.component,"strobe")
end
end,
[capabilities.alarm.commands.both.NAME]=function(_,a,d)
local j=u(
a,d.component,B,true,y,w)if not j then
j=N(a,d,"both")
end
if j then
W(a,d.component,"both")
end
end,
}h[capabilities.windowShadePreset.ID]={
[capabilities.windowShadePreset.commands.setPresetPosition.NAME]=function(_,a,d)
local aB=d.args and d.args.position or nil
if type(aB)~="number"then
return
end
a:set_field(aj(d.component),aB,{persist=true})a:emit_component_event({id=d.component},capabilities.windowShadePreset.position(aB))
end,
[capabilities.windowShadePreset.commands.presetPosition.NAME]=function(_,a,d)
local aB=D(a,d.component)aI(a,d,"cover_position",aB)
end,
}h[capabilities.energyMeter.ID]=h[capabilities.energyMeter.ID]or{}h[capabilities.energyMeter.ID][capabilities.energyMeter.commands.resetEnergyMeter.NAME]=
bI.handle_reset
h[capabilities.refresh.ID]={
[capabilities.refresh.commands.refresh.NAME]=function(p,a)
local c=i(a)if c==nil then
return
end
if type(c.parent_refresh)=="function"then
c.parent_refresh(a,c,p)return
end
if c.datapoints and c.refresh_state_query~=false then
c:send_state_request(a)
end
if c.zcl_clusters then
if type(c.zcl_refresh_before_read_all)=="function"then
c.zcl_refresh_before_read_all(a,c)
end
G.read_all_attributes(a,c.zcl_clusters)
end
end,
}k.register_handlers(h)if f~=nil then
h[f.capability_id]=h[f.capability_id]or{}
h[f.capability_id][f.command_name]=function(_,a,d)
local c=i(a)if c==nil then
return
end
local m=d.args and d.args[f.argument_name]or nil
if c.zcl_clusters~=nil then
G.set_power_poll_interval(a,c.zcl_clusters,m)return
end
if not z(a,c)then
return
end
local bJ=L(m)if bJ==nil then
return
end
a:set_field(K,bJ,{persist=true})ad(a,c)
end
end
if q~=nil then
h[q.capability_id]=h[q.capability_id]or{}
h[q.capability_id][q.command_name]=function(_,a,d)
local c=i(a)if c==nil or c.ir_controller~=true then
return
end
local m=d.args and d.args[q.argument_name]or nil
if m=="start"then
G.start_ir_learning(a,c)elseif m=="stop"then
G.stop_ir_learning(a,c)
end
end
end
if o~=nil then
h[o.capability_id]=h[o.capability_id]or{}
h[o.capability_id][o.command_name]=function(_,a,d)
local c=i(a)if c==nil or c.ir_controller~=true then
return
end
local bm=d.args or{}local m=bm[o.argument_name]if type(m)~="string"and type(bm.value)=="string"then
m=bm.value
end
if type(m)~="string"or m==""then
return
end
G.send_ir_code(a,c,m)
end
end
return h
end
local bu={
supported_capabilities={},additional_zcl_profiles=v,zigbee_handlers={
cluster=aO(),global=G.build_zigbee_global_handlers(i),attr=G.build_zigbee_attr_handlers(i),zdo={
[aw]=aQ,},},lifecycle_handlers={
init=function(p,a)
if bv(a)then
ai(p,a)return
end
local g=ac(a)local aq=g and g.valid_parent_profiles
if g and g.profile and a.profile.id~=g.profile and
(type(aq)~="table"or aq[a.profile.id]~=true)then
a:try_update_metadata({profile=g.profile})
end
S.apply(a,g)ab(a,g,true)k.emit_driver_message(a,"Custom motion controls initialized.")local c=i(a)ba(a,c)at.start_daily(a)M(a)k.maybe_request_initial_custom_state(a,c)
end,
doConfigure=function(p,a)
al(p,a,i(a))
end,
driverSwitched=function(p,a)
local c=i(a)if c==nil then
return
end
al(p,a,c)a:try_update_metadata({provisioning_state="PROVISIONED"})
end,
infoChanged=function(p,a,_,bm)
if not bm.old_st_store then
return
end
local g=ac(a)local aM=a.profile.id~=bm.old_st_store.profile.id
if aM then
S.apply(a,g)al(p,a,i(a))
end
local c=i(a)if c then
c:apply_preferences_changed(a,bm.old_st_store.preferences)if c.zcl_clusters then
G.emit_power_polling_state(a,c.zcl_clusters)else
R(a,c)
end
end
at.start_daily(a)M(a)ab(a,g,aM)
end,
},capability_handlers=aA(),health_check=false,}local bG=require"st.zigbee"
local p=bG("tuya-universal",bu)local bt=p.zigbee_message_dispatcher
local bY=bt.dispatch
function bt:dispatch(p,a,bF,...)
if a:supports_capability_by_id(capabilities.signalStrength.ID,"main")then
local bO={visibility={displayed=false}}a:emit_event(capabilities.signalStrength.lqi(bF.lqi.value,bO))if bF.rssi.value<=0 then
a:emit_event(capabilities.signalStrength.rssi({value=bF.rssi.value,unit="dBm"},bO))
end
end
return bY(self,p,a,bF,...)
end
p:run()
