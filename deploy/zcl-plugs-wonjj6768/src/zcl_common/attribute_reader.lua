local function s(t)
local v=require"st.zigbee.cluster_base"
local w=require"st.zigbee.data_types"
local function o(a,q,e,r)
if e~=nil and type(q.to_endpoint)=="function"then
q=q:to_endpoint(e)
end
if r~=nil and q.address_header and q.address_header.profile then
q.address_header.profile.value=r
end
a:send(q)return true
end
local function c(a,k,g,u,e,r)
return o(
a,v.read_manufacturer_specific_attribute(
a,k,g,u),e,r)
end
local function l(a,m,e)
return o(a,m:read(a),e)
end
local function n(a,k,g,e)
return o(
a,v.read_attribute(a,w.ClusterId(k),w.AttributeId(g)),e)
end
local function h(a,b,j,y)
if type(j)=="table"and j.mapping==b then
return j
end
return t.build_mapping_context(a,b,j,y)
end
local function i(a,b,j)
local f=t.mapping_meta(b)if f==nil or f.cluster_id==nil or f.attribute_id==nil then
return false
end
local d=h(a,b,j,nil)if f.mfg_code~=nil then
return c(
a,f.cluster_id,f.attribute_id,f.mfg_code,d.endpoint,f.profile_id)
end
if f.attribute_def~=nil and type(f.attribute_def.read)=="function"then
return l(a,f.attribute_def,d.endpoint)
end
return n(a,f.cluster_id,f.attribute_id,d.endpoint)
end
function t.read_attribute(a,k,g,e,u)
if u~=nil then
return c(a,k,g,u,e)
end
local m=t.get_generated_attribute and t.get_generated_attribute(k,g)or nil
if m~=nil then
return l(a,m,e)
end
return n(a,k,g,e)
end
function t.read_mapping(a,b,j)
return i(a,b,j)
end
function t.read_named_attribute(a,p,A,j)
local b=t.find_mapping_by_name(p,A,a,j)if b==nil then
return false
end
local f=t.mapping_meta(b)if f==nil or f.write_only then
return false
end
return i(a,b,t.build_mapping_context(a,b,j,nil))
end
function t.read_all_attributes(a,p)
if p==nil then
return
end
local x={}for _,b in ipairs(p)do
local f=type(b)=="table"and t.mapping_meta(b)or nil
if f~=nil and not f.write_only and f.read_on_refresh~=false and f.cluster_id~=nil and f.attribute_id~=nil then
local d=t.build_mapping_context(a,b,nil)local z=string.format(
"%04X:%04X:%s:%s",f.cluster_id,f.attribute_id,tostring(d.endpoint),tostring(f.mfg_code))if not x[z]then
x[z]=true
i(a,b,d)
end
end
end
end
return o,h
end
return s
