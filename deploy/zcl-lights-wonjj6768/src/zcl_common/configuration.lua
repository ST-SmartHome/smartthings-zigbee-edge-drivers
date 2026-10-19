local function x(j)
local B=require"st.zigbee.constants"
local q=require"st.zigbee.device_management"
local r=require"zcl_common.reporting"
local F=0
local s={4,0,1,5,7,65534}
function j.attach_reporting_capabilities(H,N)
return r.attach(j,H,N)
end
function j.bind_cluster(c,L,Q,k)
c:send(q.build_bind_request(
c,L,Q,k))return true
end
function j.configure_reporting(c,m,k,v)
v=v or{}local e={
cluster_id=m.cluster,attribute_id=m.attribute,data_type=m.data_type,endpoint=k,mfg_code=m.mfg_code,reporting_defaults={
minimum_interval=m.minimum_interval,maximum_interval=m.maximum_interval,reportable_change=m.reportable_change,key=v.key,},}
if v.auto_endpoint then e.endpoint=nil end
local P,M=r.configuration(j,c,e)
if v.defer_on_override and M then return false end
c:send(q.attr_config(c,P or m):to_endpoint(k))return true
end
local z=require("runtime.capability_support").is_callable
local function n(i,b)
if b==nil or(type(i)=="table"and i.is_discrete)then
return nil
end
if type(b)=="function"then
return b
end
if type(i)=="table"and type(b)=="table"and
b.ID==i.ID then
return b
end
if z(i)then
if i.ID==57 then
local R=require"st.buf".Reader
return i.deserialize(R(string.pack("<f",b)))
end
return i(b)
end
return b
end
local function o(d)
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
cluster=d.cluster_id,attribute=d.attribute_id,minimum_interval=d.minimum_interval or 0,maximum_interval=d.maximum_interval or 300,data_type=d.data_type,reportable_change=n(d.data_type,d.reportable_change),mfg_code=d.mfg_code,}
end
function j.build_configured_attributes(a)
if type(a)~="table"then
return{}
end
local f={}local y={}for _,e in ipairs(a)do
if type(e)=="table"then
local d=j.mapping_meta(e)local p=d and o(d)or nil
if p~=nil then
local E=string.format("%04X:%04X",p.cluster,p.attribute)local l=y[E]if l==nil then
y[E]=#f+1
f[#f+1]=p
elseif f[l].mfg_code==nil and p.mfg_code~=nil then
f[l]=p
end
end
end
end
return f
end
function j.read_configured_attributes(c,a)
if type(a)~="table"then
return false
end
local J=false
local y={}for _,e in ipairs(a)do
if type(e)=="table"then
local d=j.mapping_meta(e)if d~=nil and d.read_on_configure and not d.write_only then
local h=j.build_mapping_context(c,e,nil)local E=string.format(
"%04X:%04X:%s:%s",d.cluster_id,d.attribute_id,tostring(h.endpoint),tostring(d.mfg_code))if not y[E]then
y[E]=true
j.read_mapping(c,e,h)J=true
end
end
end
end
return J
end
local function t(c,a)
if type(a)~="table"then
return false
end
local J=false
local y={}for _,e in ipairs(a)do
local d=type(e)=="table"and j.mapping_meta(e)or nil
if d~=nil and d.name=="tuya_magic_packet"then
local h=j.build_mapping_context(c,e,nil)local k=h and h.endpoint or nil
local E=tostring(k or"main")if not y[E]then
y[E]=true
for _,I in ipairs(s)do
j.read_attribute(c,F,I,k)
end
J=true
end
end
end
return J
end
function j.start_configuration(c,a)
if type(a)~="table"then
return false
end
local g=nil
for _,e in ipairs(a)do
if type(e)=="table"then
local d=j.mapping_meta(e)if d~=nil and d.cluster_id==j.CLUSTER_IAS_ZONE then
g=d.ias_configure_method or B.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE
break
end
end
end
if g~=nil and type(c.set_ias_zone_config_method)=="function"then
c:set_ias_zone_config_method(g)
end
local w=r.groups(j,c,a)local f=j.build_configured_attributes(a)
if #f>0 and type(c.add_configured_attribute)=="function"then
for _,p in ipairs(f)do
if w[string.format("%04x:%04x",p.cluster,p.attribute)]then
c:remove_configured_attribute(p.cluster,p.attribute)else
c:add_configured_attribute(p)
end
end
end
local D=t(c,a)local C=j.read_metering_scalers and j.read_metering_scalers(c,a)or false
local A=#f>0 or g~=nil
local u=false
if A and type(c.configure)=="function"then
c:configure()u=true
end
r.send(j,c,a,w,true)local O=j.read_configured_attributes(c,a)local K=j.start_runtime and j.start_runtime(c,a)or false
return u or D or C or O or K
end
end
return x
