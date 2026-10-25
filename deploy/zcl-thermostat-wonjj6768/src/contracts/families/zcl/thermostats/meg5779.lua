local function w(c)
return type(c)=="table"and c.value or c
end
local function R(c,an,am)
return type(c)=="number"and c==c and c>=an and c<=am
end
local function z(c)
if not R(c,4,30)then return end
local T=c*2
local P=math.floor(T)local D,ae=math.frexp(T)D=math.floor(D*9007199254740992)
if D*20>=(P*20+9)*(1<<(53-ae))then P=P+1 end
return P*50
end
local function I(c)
return math.floor(w(c)*100/255+0.5)
end
local al=require"protocol.zcl"
local A=require"capabilities.events.all"
local U=require"contracts.helpers.family"
local p=require"st.capabilities"
local i=require"st.zigbee.data_types"
local Z=require"st.zigbee.cluster_base"
local b,X,g=513,516,4190
local B,ah=U.definition_registry()local y,C,L={},{},{}
local function E(name)
return assert(A[name],"Missing actual MEG5779 generated metadata: "..name)()
end
local function J(a,aj,component)
if aj then a:emit_component_event({id=component or"main"},aj)end
end
local function ak(tx)
tx.body.zcl_header.frame_ctrl:set_disable_default_response()return tx
end
local function o(a,j)
local G={}for _,d in pairs(a.zigbee_endpoints or{})do
if a:supports_server_cluster(j,d.id)then G[#G+1]=d.id end
end
table.sort(G)return G
end
local function K(a,j,e,k,d)
local tx=k and Z.read_manufacturer_specific_attribute(a,j,e,k)or Z.read_attribute(a,i.ClusterId(j),i.AttributeId(e))a:send(ak(tx:to_endpoint(d or a:get_endpoint(j))))
end
local function Q(a,j,e,aa,c,k,d)
local tx=k and Z.write_manufacturer_specific_attribute(a,j,e,k,aa,c)or Z.write_attribute(a,i.ClusterId(j),i.AttributeId(e),aa(c))
if not pcall(a.send,a,ak(tx:to_endpoint(d or a:get_endpoint(j))))then return false end
return pcall(K,a,j,e,k,d)
end
local function u(aC,aD,f,aB,c)
C[#C+1]={capability_id=aC,command_name=aD,mapping_name=f,argument_name=aB,value=c}
end
local function M(j,e,name,aa,aA,v,l)
l=l or{}l.name,l.data_type,l.from_device,l.emit=name,aa,aA,v
l.read_on_configure,l.read_on_refresh=false,false
if l.read_only==nil then l.read_only=true end
local f=al.cluster_attribute(j,e,l)y[#y+1]=f
return f
end
local function t(aw)
return function(c,_,H,f)
local rx=H and H.zb_rx
local ao=rx and rx.body and rx.body.zcl_body and rx.body.zcl_body.attr_records
for _,m in ipairs(ao or{})do
if m.attr_id.value==f.attribute_id and m.data==H.typed_value then
if(m.status and m.status.value~=0)or not m.data_type or m.data_type.value~=41 then return end
c=w(c)
if not R(c,-32767,32767)or c%1~=0 then return end
c=c/100
if not aw or c>=-273.15 then return c end
return
end
end
end
end
local function S(q)
return function(c)return q[w(c)]end
end
local ab=M(b,0,"meg5779_local_temperature",i.Int16,t(true),A.temperature"C")ab.reporting_defaults={minimum_interval=0,maximum_interval=3600,reportable_change=10}local ad={
{18,"main",A.heating_setpoint"C",true},{20,"unoccupied",A.heating_setpoint"C",false},{17,"main",A.cooling_setpoint"C",false},{19,"unoccupied",A.cooling_setpoint"C",false}}for _,row in ipairs(ad)do
local f=M(b,row[1],"meg5779_setpoint_"..row[1],i.Int16,t(row[4]),row[3],{
component=row[2],endpoint=function(a)return a:get_endpoint(b)end
})f.reporting_defaults={minimum_interval=0,maximum_interval=3600,reportable_change=10}
end
for _,row in ipairs{{"heat","thermostatHeatingSetpoint","heatingSetpoint",18,20},{"cool","thermostatCoolingSetpoint","coolingSetpoint",17,19}}do
local s="meg5779_"..row[1].."_setpoint"
L[s]=function(a,c,ap)
local component=ap.component or"main"
if component~="main"and component~="unoccupied"then return false end
local n=z(c)
if n==nil then return false end
return Q(a,b,component=="main"and row[4]or row[5],i.Int16,n)
end
u(row[2],row[1]=="heat"and"setHeatingSetpoint"or"setCoolingSetpoint",s,"setpoint")
end
local ay={[0]="off",[3]="cool",[4]="heat"}local af=M(b,28,"meg5779_mode_rx",i.Enum8,S(ay),A.thermostat_mode())af.reporting_defaults={minimum_interval=0,maximum_interval=3600}
L.meg5779_mode=function(a,c)
local n=({off=0,cool=3,heat=4})[c]
if n==nil then return false end
return Q(a,b,28,i.Enum8,n)
end
u("thermostatMode","setThermostatMode","meg5779_mode","mode")
for _,au in ipairs{"off","heat","cool"}do u("thermostatMode",au,"meg5779_mode",nil,au)end
local ar=M(b,8,"meg5779_heatDemand",i.Uint8,I,E"meg5779HeatDemand")ar.reporting_defaults={minimum_interval=0,maximum_interval=3600,reportable_change=0}local N={[0]="idle",[1]="heating",[2]="cooling",[4]="fan only",[5]="heating",[6]="cooling",[8]="heating",[9]="heating",[10]="cooling",[12]="cooling",[14]="cooling",[15]="cooling",[22]="cooling",[33]="heating",[34]="cooling",[65]="heating",[66]="cooling",[32768]="idle",[32769]="heating"}M(b,41,"meg5779_native_state_rx",i.Bitmap16,S(N),A.thermostat_operating_state())local ai={
{b,21,i.Int16,"meg5779HeatMin","heatMin",nil,4,30,true,true},{b,22,i.Int16,"meg5779HeatMax","heatMax",nil,4,30,true,true},{b,23,i.Int16,"meg5779CoolMin","coolMin",nil,4,30,true,false},{b,24,i.Int16,"meg5779CoolMax","coolMax",nil,4,30,true,false},{X,57344,i.Uint8,"meg5779ActiveBrightness","activeBrightness",g,0,100},{X,57345,i.Uint8,"meg5779InactiveBrightness","inactiveBrightness",g,0,100},{X,57346,i.Uint16,"meg5779DisplayTimeout","displayTimeout",g,5,600}}for _,row in ipairs(ai)do
local v=E(row[4])local s="meg5779_"..row[5]local f=M(row[1],row[2],s,row[3],row[9]and t(row[10])or w,v,{read_only=false,mfg_code=row[6]})
f.sender=function(a,_,c)
if not R(c,row[7],row[8])then return false end
local n=row[9]and z(c)or math.modf(c)return Q(a,row[1],row[2],row[3],n,row[6])
end
u("concertmirror08464."..row[4],"set"..row[5]:sub(1,1):upper()..row[5]:sub(2),s,row[5])
end
local av={
{X,0,"meg5779DisplayUnit","displayUnit",nil,{[0]="celsius",[1]="fahrenheit"}},{X,1,"meg5779Keypad","keypad",nil,{[0]="unlock",[1]="lock1"}},{b,57878,"meg5779Application","application",g,{[0]="Occupied Space",[1]="Floor",[255]="Not known"}},{b,57879,"meg5779HeatingFuel","heatingFuel",g,{[0]="electricity",[1]="gas",[2]="oil",[3]="solid_fuel",[4]="solar",[5]="community_heating",[6]="heat_pump",[255]="not_specified"}},{b,57880,"meg5779TransferMedium","transferMedium",g,{[0]="nothing",[1]="hydronic",[2]="air"}},{b,57882,"meg5779HeatingEmitter","heatingEmitter",g,{[0]="None",[1]="Radiator",[2]="Fan Assisted Radiator",[3]="Radiant Panel",[4]="Floor",[255]="Not specified"}}}for _,row in ipairs(av)do
local v,V=E(row[3]),{}
for aE,ax in pairs(row[6])do V[ax]=aE end
local s="meg5779_"..row[4]local f=M(row[1],row[2],s,i.Enum8,S(row[6]),v,{read_only=false,mfg_code=row[5]})
f.sender=function(a,_,c)
local n=V[c]
if n==nil then return false end
return Q(a,row[1],row[2],i.Enum8,n,row[5])
end
u("concertmirror08464."..row[3],"set"..row[4]:sub(1,1):upper()..row[4]:sub(2),s,row[4])
end
M(b,57362,"meg5779_windowOpen",i.Uint8,function(c)
return w(c)==1 and"active"or"inactive"
end,E"meg5779WindowOpen",{mfg_code=g})
local function O(a,rx)
local F=rx.body and rx.body.zcl_header
if not F or F.frame_ctrl:is_cluster_specific_set()or(F.cmd.value~=1 and F.cmd.value~=10)then return end
if rx.address_header.cluster.value~=b then return end
local q={}for _,m in ipairs(rx.body.zcl_body.attr_records or{})do
if m.data and(not m.status or m.status.value==0)then q[m.attr_id.value]=w(m.data)end
end
local c,state
if q[8]~=nil then c,state=q[8],"heating"
elseif q[7]~=nil then c,state=q[7],"cooling"end
if c~=nil then J(a,p.thermostatOperatingState.thermostatOperatingState(c>0 and state or"idle"))end
end
local function W(a)
for _,d in ipairs(o(a,b))do
for _,e in ipairs{0,18,20,17,19,28,8,22,21,24,23}do K(a,b,e,nil,d)end
end
for _,d in ipairs(o(a,X))do
for _,e in ipairs{57344,57345,57346}do K(a,X,e,g,d)end
K(a,X,0,nil,d)K(a,X,1,nil,d)
end
for _,d in ipairs(o(a,b))do
for _,e in ipairs{57878,57879,57880,57882,57362}do K(a,b,e,g,d)end
end
end
local at={
profile="thermostats-schneider-meg5779",zcl_clusters=y,capability_commands=C,protocol_writers=L,zigbee_message_handler=O,
component_to_endpoint=function(a)return a:get_endpoint(b)end,
endpoint_to_component=function()return"main"end,
runtime_start=function(a)
J(a,p.thermostatMode.supportedThermostatModes({"off","heat","cool"},{visibility={displayed=false}}))J(a,p.thermostatOperatingState.supportedThermostatOperatingStates({"idle","heating","cooling","fan only"},{visibility={displayed=false}}))
end,
configure=function(as,a)
for _,d in ipairs(o(a,b))do al.bind_cluster(a,b,as.environment_info.hub_zigbee_eui,d)end
for _,f in ipairs(y)do
local x=f.reporting_defaults
if x then
for _,d in ipairs(o(a,f.cluster_id))do
al.configure_reporting(a,{
cluster=f.cluster_id,attribute=f.attribute_id,data_type=f.data_type,minimum_interval=x.minimum_interval,maximum_interval=x.maximum_interval,reportable_change=x.reportable_change},d,{auto_endpoint=true,disable_default_response=true})
end
end
end
W(a)
end,
parent_refresh=function(a)W(a)end
}ah(at,{U.create_fingerprint("Schneider Electric","MEG5779")})al.attach_reporting_capabilities(B,{
{1,"rpt-men",{zr02010011auto="CoolSet",zr02010012auto="HeatSet",zr02010013auto="CoolSetTwo",zr02010014auto="HeatSetTwo"}}})return{id="zcl.thermostats.meg5779",registrations=B}
