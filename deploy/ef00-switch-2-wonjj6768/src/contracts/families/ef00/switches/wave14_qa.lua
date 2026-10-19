local v=require"protocol.tuya"
local u=require"capabilities.events.all"
local d=require"contracts.helpers.family"
local i=require"st.zigbee.device_management"
local h,a=d.definition_registry()local k=6
local function c(m)
return function(t,o)
for p=1,m do
o:send(i.build_bind_request(
o,k,t.environment_info.hub_zigbee_eui,p))
end
end
end
local function g(s,j)
local f={}local b={}local e={[1]="main"}for l=1,j do
local n=l==1 and"main"or("switch"..tostring(l))f[#f+1]=v.dp_on_off(l,{
name="switch",component=n,endpoint=1,emit=u.switch(),})b[n]=1
end
return{
profile=s,package_group="wave14-switch",transport_classification="EF00_LEGACY_DP",z2m_converter_source="legacy.fz.tuya_switch + legacy.tz.tuya_switch_state",wire_cluster="manuSpecificTuya",magic_packet=false,query_on_configure=false,datapoints=f,component_to_endpoint_map=b,endpoint_to_component_map=e,configure=c(j),}
end
local q=g("switches-wave14-qa-qat44z4h",4)local r=g("switches-wave14-qa-qat44z6h",6)a(q,{
d.create_fingerprint("_TZE204_kyzjsjo3","TS0601"),})a(r,{
d.create_fingerprint("_TZE204_4cl0dzt4","TS0601"),})return{
id="wave14.qa.legacy_switches",registrations=h,}
