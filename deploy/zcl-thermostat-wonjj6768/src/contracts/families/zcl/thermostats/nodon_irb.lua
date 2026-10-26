local K=require"protocol.zcl"
local n=require"capabilities.events.all"
local E=require"contracts.helpers.family"
local B=require"contracts.helpers.zcl"
local f=require"st.capabilities"
local e=require"st.zigbee.data_types"
local Q=require"st.zigbee.cluster_base"
local q,M=E.definition_registry()
local function t(c,j,u)
return type(c)=="number"and c==c and c>=j and c<=u
end
local function A(c)
local D=c*2
local v=math.floor(D)local s,L=math.frexp(D)s=math.floor(s*9007199254740992)
if s*20>=(v*20+9)*(1<<(53-L))then v=v+1 end
return v*50
end
local function y(c,_,h,a)
local rx=h.zb_rx
for _,o in ipairs(rx.body.zcl_body.attr_records or{})do
if o.attr_id.value==a.attribute_id and o.data==h.typed_value then
if(o.status and o.status.value~=0)or o.data_type.value~=a.data_type.ID then return end
c=type(c)=="table"and c.value or c
if type(c)=="number"and c%1==0 then return c end
end
end
end
local function k(C,j,u)
return function(c,b,h,a)
c=y(c,b,h,a)
if c~=nil and t(c/C,j,u)then return c/C end
end
end
local function w(W)
return function(c,b,h,a)return W[y(c,b,h,a)]end
end
local function p(b,a,c)
if c==nil then return false end
local g=Q.write_attribute(b,e.ClusterId(a.cluster_id),e.AttributeId(a.attribute_id),a.data_type(c)):to_endpoint(b:get_endpoint(a.cluster_id))if a.mfg_code then
g.body.zcl_header.frame_ctrl:set_mfg_specific()g.body.zcl_header.mfg_code=e.Uint16(a.mfg_code)
end
g.body.zcl_header.frame_ctrl:set_disable_default_response()return pcall(b.send,b,g)
end
local function z(b,a,c)
local j=a.attribute_id==18 and 16 or 18
return p(b,a,t(c,j,30)and A(c)or nil)
end
local O={[0]="off",[1]="auto",[3]="cool",[4]="heat",[5]="emergency heat",[6]="precooling",[7]="fanonly",[8]="dryair",[9]="asleep"}local P={off=0,auto=1,cool=3,heat=4,fanonly=7,dryair=8}local T={[0]="off",[1]="low",[2]="medium",[3]="high",[4]="on",[5]="auto",[6]="smart"}local U={off=0,low=1,medium=2,high=3,auto=5}local G={[0]="fully_closed",[1]="fully_closed",[2]="fully_open",[3]="quarter_open",[4]="half_open",[5]="three_quarters_open"}local H={fully_closed=1,fully_open=2,quarter_open=3,half_open=4,three_quarters_open=5}local i={}
local function d(N,id,ab,aa,Z,X,I,J,x)
i[#i+1]=K.cluster_attribute(N,id,{
name=ab,data_type=aa,from_device=Z,emit=X,sender=J,mfg_code=x,read_only=J==nil,read_on_configure=false,read_on_refresh=true,suppress_optimistic_state=true,reporting_defaults=I})
end
d(1029,0,"nodon_irb_humidity",e.Uint16,k(100,0,100),n.humidity(),{minimum_interval=10,maximum_interval=3600,reportable_change=100})d(513,0,"nodon_irb_temperature",e.Int16,k(100,-273.15,327.67),n.temperature"C",{minimum_interval=0,maximum_interval=3600,reportable_change=10})d(513,16,"nodon_irb_local_calibration",e.Int8,k(10,-12.8,12.7),n.nodonIrbLocalCalibration(),nil,
function(b,a,c)return p(b,a,t(c,-2.5,2.5)and math.floor(c*10+0.5)or nil)end)
d(513,18,"current_heating_setpoint",e.Int16,k(100,-273.15,327.67),n.heating_setpoint"C",{minimum_interval=0,maximum_interval=3600,reportable_change=10},z)d(513,17,"current_cooling_setpoint",e.Int16,k(100,-327.68,327.67),n.cooling_setpoint"C",{minimum_interval=0,maximum_interval=3600,reportable_change=10},z)d(513,28,"system_mode",e.Enum8,w(O),n.thermostat_mode(),{minimum_interval=0,maximum_interval=3600},
function(b,a,c)return p(b,a,P[c])end)
d(514,0,"nodon_irb_fan",e.Enum8,w(T),n.value(f.airConditionerFanMode.fanMode),{minimum_interval=0,maximum_interval=3600},
function(b,a,c)return p(b,a,type(c)=="string"and U[c:lower()]or nil)end)
d(513,69,"nodon_irb_louver",e.Enum8,w(G),n.nodonIrbLouver(),{minimum_interval=0,maximum_interval=3600},
function(b,a,c)return p(b,a,H[c])end)
d(64642,32769,"nodon_irb_holder_calibration",e.Int16,k(10,-3276.8,3276.7),n.nodonIrbHolderCalibration(),nil,
function(b,a,c)return p(b,a,t(c,-10,10)and math.floor(c*10+0.5)or nil)end,4747)
local function V(b,a)
local g=Q.read_attribute(b,e.ClusterId(a.cluster_id),e.AttributeId(a.attribute_id),a.mfg_code):to_endpoint(b:get_endpoint(a.cluster_id))if a.mfg_code then
g.body.zcl_header.frame_ctrl:set_mfg_specific()g.body.zcl_header.mfg_code=e.Uint16(a.mfg_code)
end
g.body.zcl_header.frame_ctrl:set_disable_default_response()return pcall(b.send,b,g)
end
local S={
profile="thermostats-nodon-irb",magic_packet=false,initial_custom_state_query=false,zcl_clusters=i,thermostat_supported_modes={"off","heat","cool","auto","dryair","fanonly"},
component_to_endpoint=function(b)return b:get_endpoint(513)end,
protocol_writers={nodon_irb_identify=B.identify},capability_commands={
{capability_id="airConditionerFanMode",command_name="setFanMode",mapping_name="nodon_irb_fan",argument_name="fanMode"},{capability_id="concertmirror08464.nodonIrbIdentify",command_name="identify",mapping_name="nodon_irb_identify",value=3},{capability_id="concertmirror08464.nodonIrbIdentify",command_name="setIdentifyTime",mapping_name="nodon_irb_identify",argument_name="identifyTime"}},
runtime_start=function(b)
b:emit_event(f.thermostatMode.supportedThermostatModes({"off","heat","cool","auto","dryair","fanonly"},{visibility={displayed=false}}))b:emit_event(f.thermostatHeatingSetpoint.heatingSetpointRange{value={minimum=16,maximum=30,step=0.5},unit="C"})b:emit_event(f.thermostatCoolingSetpoint.coolingSetpointRange{value={minimum=18,maximum=30,step=0.5},unit="C"})b:emit_event(f.airConditionerFanMode.supportedAcFanModes({"off","low","medium","high","auto"},{visibility={displayed=false}}))
end,
parent_refresh=function(b,m)
if m.zcl_refresh_before_read_all then m.zcl_refresh_before_read_all(b,m)end
for _,a in ipairs(i)do V(b,a)end
end,
configure=function(R,b)
local Y=R.environment_info.hub_zigbee_eui
for F=1,8 do
local a=i[F]local r=b:get_endpoint(a.cluster_id)
if F==2 or F==7 then K.bind_cluster(b,a.cluster_id,Y,r)end
local l=a.reporting_defaults
if l then
K.bind_cluster(b,a.cluster_id,Y,r)K.configure_reporting(b,{
cluster=a.cluster_id,attribute=a.attribute_id,data_type=a.data_type,minimum_interval=l.minimum_interval,maximum_interval=l.maximum_interval,reportable_change=l.reportable_change},r,{defer_on_override=true,disable_default_response=true})
end
V(b,a)
end
end
}M(S,{E.create_fingerprint("NodOn","IRB-4-1-00")})K.attach_reporting_capabilities(q,{
{1,"rpt-iyj"}})return{id="zcl.thermostats.nodon_irb",registrations=q}
