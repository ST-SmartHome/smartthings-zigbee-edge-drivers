local P=require"protocol.zcl"
local S=require"capabilities.events.all"
local w=require"contracts.helpers.family"
local O=require"st.capabilities"
local s=require"st.zigbee.device_management"
local D,q=w.definition_registry()local B=257
local c=268
local g=1
local h=8
local m="bridge-wave19-sunricher-dali-dimmer-child"
local r="bridge-wave19-sunricher-dali-cct-child"
local function K(a)
return string.format("%02X",a)
end
local function j(b)
local L=b and b.parent_assigned_child_key
if type(L)~="string"or L:match("^%x%x$")==nil then return nil end
local a=tonumber(L,16)if a==nil or a<g or a>h then
return nil
end
return a
end
local function A(b,a)
return b and b.zigbee_endpoints and b.zigbee_endpoints[a]or nil
end
local function d(b,a)
local G=A(b,a)return G and G.device_id or nil
end
local function e(b,a)
local u=d(b,a)return u==B or u==c
end
local function y(b,a)
if d(b,a)==c then
return r
end
return m
end
local function p(a,N,o)
local L=K(a)
return function(b,Y,W,X)
local u=d(b,a)if not e(b,a)or
(o~=nil and u~=o)then
return nil
end
local n=b:get_child_by_parent_assigned_key(L)
if n==nil then return nil end
local U=N(n,Y,W,X)
if U~=nil then n:emit_event(U)end
return nil
end
end
local function x(E,b)
if type(b.zigbee_endpoints)~="table"then return end
for a=g,h do
local L=K(a)local n=b:get_child_by_parent_assigned_key(L)if e(b,a)then
local I=y(b,a)if n~=nil then
if n.profile==nil or n.profile.id~=I then
n:try_update_metadata({profile=I})
end
else
E:try_create_device({
type="EDGE_CHILD",parent_assigned_child_key=L,parent_device_id=b.id,label=string.format("%s DALI %d",b.label,a),profile=I,})
end
elseif n~=nil and type(E.try_delete_device)=="function"then
E:try_delete_device(n.id)
end
end
end
local function F(k,b)
local a=j(b)
if a==nil or not e(k,a)then return false end
local t=y(k,a)
if b.profile==nil then return false end
if b.profile.id~=t then
b:try_update_metadata({profile=t})
end
return true
end
local function z(b,_,k)
local a=j(b)if a==nil or d(k,a)~=c then
return
end
b:emit_component_event(
{id="main"},O.colorTemperature.colorTemperatureRange({
value={minimum=2000,maximum=6667},unit="K",}))
end
local function C(b)
if type(b)~="table"or type(b.get_parent_device)~="function"then
return nil
end
return b:get_parent_device()
end
local function i(b,a,f)
P.read_attribute(b,6,0,a)P.read_attribute(b,8,0,a)if f then
P.read_attribute(b,768,8,a)P.read_attribute(b,768,7,a)
end
end
local function M(b)
local k=C(b)local a=j(b)
if a==nil or not e(k,a)then return end
i(
b,a,d(k,a)==c)
end
local function H(b)
if type(b.zigbee_endpoints)~="table"then return end
for a=g,h do
if e(b,a)then
i(
b,a,d(b,a)==c)
end
end
end
local function v(b,T)
local k=C(b)local a=j(b)
if a==nil or not e(k,a)then return false end
if T=="switch"or T=="brightness"then return true end
return T=="color_temperature"and
d(k,a)==c
end
local function R(E,b)
local Q=E.environment_info.hub_zigbee_eui
for a=g,h do
if e(b,a)then
for _,V in ipairs({6,8})do
b:send(s.build_bind_request(b,V,Q,a))
end
local f=
d(b,a)==c
if f then
b:send(s.build_bind_request(b,768,Q,a))
end
i(b,a,f)
end
end
end
local l={}for a=g,h do
l[#l+1]=P.switch({
endpoint=a,configure_reporting=false,emit=p(a,S.switch()),})l[#l+1]=P.level({
endpoint=a,configure_reporting=false,emit=p(a,S.level()),})l[#l+1]=P.color_temperature({
endpoint=a,configure_reporting=false,emit=p(
a,S.color_temperature(),c),})
end
local J={
profile="bridge-wave19-sunricher-dali-parent",auxiliary_profiles={m,r},package_group="wave19-dali",transport_classification="STANDARD_ZCL_DYNAMIC_ENDPOINT_CHILDREN",z2m_converter_source="sunricherDaliController",wire_cluster="OnOff 0x0006 + Level 0x0008 + optional ColorControl 0x0300",zcl_clusters=l,allow_child_devices=true,is_expected_child=F,create_child_devices=x,child_runtime_start=z,child_refresh=M,parent_refresh=H,child_command_allowed=v,configure=R,}q(J,{
w.create_fingerprint("Sunricher","Light"),})return{
id="zcl.lights.wave19_dali",registrations=D,}
