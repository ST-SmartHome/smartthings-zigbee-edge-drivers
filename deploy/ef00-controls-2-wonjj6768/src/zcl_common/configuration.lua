local function x(i)
local B=require"st.zigbee.constants"
local r=require"st.zigbee.device_management"
local o=require"zcl_common.reporting"
local F=0
local t={4,0,1,5,7,65534}
function i.attach_reporting_capabilities(H,O)
return o.attach(i,H,O)
end
function i.discard_unsupported_reporting(b)
return o.discard_unsupported(i,b)
end
function i.bind_cluster(b,M,R,k)
b:send(r.build_bind_request(
b,M,R,k))return true
end
function i.configure_reporting(b,m,k,s)
s=s or{}local e={
cluster_id=m.cluster,attribute_id=m.attribute,data_type=m.data_type,endpoint=k,mfg_code=m.mfg_code,reporting_defaults={
minimum_interval=m.minimum_interval,maximum_interval=m.maximum_interval,reportable_change=m.reportable_change,key=s.key}}
if s.auto_endpoint then e.endpoint=nil end
local Q,N=o.configuration(i,b,e)
if s.defer_on_override and N then return false end
local L=r.attr_config(b,Q or m):to_endpoint(k)
if s.disable_default_response then L.body.zcl_header.frame_ctrl:set_disable_default_response()end
b:send(L)return true
end
local z=require"runtime.capability_support".is_callable
local function n(j,c)
if c==nil or(type(j)=="table"and j.is_discrete)then
return nil
end
if type(c)=="function"then
return c
end
if type(j)=="table"and type(c)=="table"and
c.ID==j.ID then
return c
end
if z(j)then
if j.ID==57 then
local S=require"st.buf".Reader
return j.deserialize(S(string.pack("<f",c)))
end
return j(c)
end
return c
end
local function p(d)
if d.physical_reportable_change~=nil then
return nil
end
local G=d.minimum_interval~=nil or
d.maximum_interval~=nil or
d.reportable_change~=nil
if not G or d.write_only then
return nil
end
if d.cluster_id==nil or d.attribute_id==nil or d.data_type==nil then
return nil
end
return{
cluster=d.cluster_id,attribute=d.attribute_id,minimum_interval=d.minimum_interval or 0,maximum_interval=d.maximum_interval or 300,data_type=d.data_type,reportable_change=n(d.data_type,d.reportable_change),mfg_code=d.mfg_code}
end
function i.build_configured_attributes(a)
if type(a)~="table"then
return{}
end
local f={}local y={}for _,e in ipairs(a)do
if type(e)=="table"then
local d=i.mapping_meta(e)local q=d and p(d)or nil
if q~=nil then
local E=string.format("%04X:%04X",q.cluster,q.attribute)local l=y[E]if l==nil then
y[E]=#f+1
f[#f+1]=q
elseif f[l].mfg_code==nil and q.mfg_code~=nil then
f[l]=q
end
end
end
end
return f
end
function i.read_configured_attributes(b,a)
if type(a)~="table"then
return false
end
local J=false
local y={}for _,e in ipairs(a)do
if type(e)=="table"then
local d=i.mapping_meta(e)if d~=nil and d.read_on_configure and not d.write_only then
local h=i.build_mapping_context(b,e,nil)local E=string.format(
"%04X:%04X:%s:%s",d.cluster_id,d.attribute_id,tostring(h.endpoint),tostring(d.mfg_code))if not y[E]then
y[E]=true
i.read_mapping(b,e,h)J=true
end
end
end
end
return J
end
local function u(b,a)
if type(a)~="table"then
return false
end
local J=false
local y={}for _,e in ipairs(a)do
local d=type(e)=="table"and i.mapping_meta(e)or nil
if d~=nil and d.name=="tuya_magic_packet"then
local h=i.build_mapping_context(b,e,nil)local k=h and h.endpoint or nil
local E=tostring(k or"main")if not y[E]then
y[E]=true
for _,I in ipairs(t)do
i.read_attribute(b,F,I,k)
end
J=true
end
end
end
return J
end
function i.start_configuration(b,a)
if type(a)~="table"then
return false
end
local g
for _,e in ipairs(a)do
if type(e)=="table"then
local d=i.mapping_meta(e)if d~=nil and d.cluster_id==i.CLUSTER_IAS_ZONE then
g=d.ias_configure_method or B.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE
break
end
end
end
if g~=nil and type(b.set_ias_zone_config_method)=="function"then
b:set_ias_zone_config_method(g)
end
local w=o.groups(i,b,a)local f=i.build_configured_attributes(a)
if #f>0 and type(b.add_configured_attribute)=="function"then
for _,q in ipairs(f)do
if w[string.format("%04x:%04x",q.cluster,q.attribute)]then
b:remove_configured_attribute(q.cluster,q.attribute)else
b:add_configured_attribute(q)
end
end
end
local D=u(b,a)local C=i.read_metering_scalers and i.read_metering_scalers(b,a)or false
local A=#f>0 or g~=nil
local v=false
if A and type(b.configure)=="function"then
b:configure()v=true
end
o.send(i,b,a,w,true)local P=i.read_configured_attributes(b,a)local K=i.start_runtime and i.start_runtime(b,a)or false
return v or D or C or P or K
end
end
return x
