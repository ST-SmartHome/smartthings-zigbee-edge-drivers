local function af(M)
local O="__zcl_mapping_bucket"
local ad=setmetatable({},{__mode="k"})local ab=setmetatable({},{__mode="k"})local R=setmetatable({},{__mode="k"})local S=require"runtime.capability_support".is_callable
local function r(g)
if type(g)~="number"or g%1~=0 then
return nil
end
return g
end
local function n(c,b)
if type(b)~="table"then
return nil
end
local e=b.component_id or b.component
if type(e)=="string"and e~=""then
return e
end
local g=r(b.endpoint or b.src_endpoint)
if g~=nil and type(c.get_component_id_for_endpoint)=="function"then
local G=c:get_component_id_for_endpoint(g)if type(G)=="string"and G~=""then
return G
end
end
return nil
end
local function k(c,b)
if type(b)~="table"then
return nil
end
local g=r(b.endpoint or b.src_endpoint)if g~=nil then
return g
end
local e=b.component_id or b.component
if type(e)=="string"and e~=""and type(c.get_endpoint_for_component_id)=="function"then
local G=c:get_endpoint_for_component_id(e)if type(G)=="table"then
G=G[1]
end
return r(G)
end
return nil
end
local function w(a,ah)
local Z=ad[a]if Z~=nil then
return Z
end
local A=type(a.converter)=="table"and a.converter or nil
local P=type(a.from_device)=="function"and a.from_device or nil
local L=A and type(A.from)=="function"and A.from or nil
local aa=a.prefer_typed_value==true or
(A and A.prefer_typed_value==true)or
false
local B=S(a.data_type)and a.data_type or nil
local K=S(a.write_type)and a.write_type or B
local l
if a.cluster_id~=nil and a.attribute_id~=nil and M.get_generated_attribute~=nil then
l=M.get_generated_attribute(a.cluster_id,a.attribute_id)
end
if l==nil and a.cluster_id~=nil and a.attribute_id~=nil and M.build_dynamic_attribute~=nil then
local Q=B or K
if Q~=nil then
l=M.build_dynamic_attribute(
a.cluster_id,a.attribute_id,Q,a.read_only~=true,a.attribute_name,a.complex_type==true)
end
end
local ae={
from_device=P or L,custom_from_device=P~=nil,converter_from_device=L~=nil,prefer_typed_value=aa,prefer_plain_attribute_write=a.prefer_plain_attribute_write==true,
to_device=type(a.to_device)=="function"and a.to_device or
(A and type(A.to)=="function"and A.to or nil),
emit=type(a.emit)=="function"and a.emit or nil,
handler=type(a.handler)=="function"and a.handler or nil,
sender=type(a.sender)=="function"and a.sender or nil,
command_id=type(a.command_id)=="number"and a.command_id or nil,
command_extractor=type(a.command_extractor)=="function"and a.command_extractor or nil,
tx_command_id=type(a.tx_command_id)=="number"and a.tx_command_id or nil,tx_command_direction=a.tx_command_direction=="client"and"client"or"server",
endpoint=(type(a.endpoint)=="number"or type(a.endpoint)=="function")and a.endpoint or nil,
component=(type(a.component)=="string"or type(a.component)=="function")and a.component or nil,
read_only=a.read_only==true,write_only=a.write_only==true,minimum_interval=a.minimum_interval,maximum_interval=a.maximum_interval,reportable_change=a.reportable_change,reporting_defaults=a.reporting_defaults,physical_reportable_change=type(a.physical_reportable_change)=="number"and
a.physical_reportable_change or nil,read_on_configure=a.read_on_configure==true,read_on_refresh=a.read_on_refresh,poll_interval=type(a.poll_interval)=="number"and a.poll_interval or nil,ias_configure_method=a.ias_configure_method,mfg_code=type(a.mfg_code)=="number"and a.mfg_code or nil,profile_id=type(a.profile_id)=="number"and a.profile_id or nil,metering_kind=type(a.metering_kind)=="string"and a.metering_kind or nil,scale=type(a.scale)=="number"and a.scale or nil,ignore_reported_scaler=a.ignore_reported_scaler==true,attribute_def=l,data_type=B or
(l and l.base_type or nil),write_type=K or
(l and l.base_type or nil),name=a.name,cluster_id=a.cluster_id,attribute_id=a.attribute_id}
if ah~=false then ad[a]=ae end
return ae
end
local function t(c,a,b)
local ae=w(a)local g=ae.endpoint
if type(g)=="function"then
g=g(c,a,b)
end
return r(g)
end
local function o(c,a,b)
local ae=w(a)local e=ae.component
if type(e)=="function"then
e=e(c,a,b)
end
if type(e)=="string"and e~=""then
return e
end
return nil
end
local function W(c,a,b,ai)
local f={
mapping=a,value=ai}if type(b)=="table"then
for aj,am in pairs(b)do
f[aj]=am
end
end
if f.cluster_id==nil and type(a)=="table"then
f.cluster_id=a.cluster_id
end
if f.attribute_id==nil and type(a)=="table"then
f.attribute_id=a.attribute_id
end
local g=t(c,a,f)if g==nil then
g=k(c,f)
end
local e=o(c,a,f)if e==nil then
if g~=nil and type(c.get_component_id_for_endpoint)=="function"then
e=c:get_component_id_for_endpoint(g)else
e=n(c,f)
end
end
f.endpoint=g
f.component_id=e
f.component=e and c.profile and c.profile.components and c.profile.components[e]or nil
return f
end
local function u(a,c,b)
if type(a)~="table"or c==nil then
return 0
end
local x=t(c,a,b)local z=o(c,a,b)local H=w(a).mfg_code
local v=k(c,b)local m=n(c,b)local ac=type(b)=="table"and b.mfg_code or nil
if v==nil and m~=nil then
v=k(c,{component_id=m})
end
if m==nil and v~=nil and type(c.get_component_id_for_endpoint)=="function"then
m=c:get_component_id_for_endpoint(v)
end
if x~=nil and v~=x then
return-1
end
local N=x~=nil and type(b)=="table"and b.zb_rx~=nil
if z~=nil and m~=z and not N then
return-1
end
local T=type(b)=="table"and(
b.mfg_code~=nil or
b.zb_rx~=nil or
b.command_id~=nil)if T and H~=nil and ac~=H then
return-1
end
local C=0
if x~=nil then
C=C+2
end
if z~=nil then
C=C+1
end
if T and H~=nil then
C=C+4
end
return C
end
local function I(h)
return type(h)=="table"and h[O]==true
end
local function U(q,aj,a)
local X=q[aj]if X==nil then
q[aj]=a
return
end
if I(X)then
X[#X+1]=a
return
end
q[aj]={
[O]=true,X,a}
end
local function D(h,c,b)
if h==nil then
return nil
end
if not I(h)then
if c==nil or u(h,c,b)>=0 then
return h
end
return nil
end
if c==nil then
return h[1]
end
local J
local p=-1
for _,a in ipairs(h)do
local C=u(a,c,b)if C>p then
J=a
p=C
end
end
return J
end
local function F(h,c,b)
if h==nil then
return{}
end
if not I(h)then
if c==nil or u(h,c,b)>=0 then
return{h}
end
return{}
end
local J={}local p
for _,a in ipairs(h)do
local C=c==nil and 0 or u(a,c,b)if C>=0 then
if p==nil or C>p then
J={a}p=C
elseif C==p then
J[#J+1]=a
end
end
end
return J
end
local function j(d)
if d==nil then
return nil
end
local Z=ab[d]if Z~=nil then
return Z
end
local s={}local ag={}local V={}local Y={}for _,a in ipairs(d)do
if type(a)=="table"then
local i=a.cluster_id
local y=a.attribute_id
if i~=nil and y~=nil then
s[i]=s[i]or{}U(s[i],y,a)if not Y[i]then
Y[i]=true
V[#V+1]=i
end
end
if a.name~=nil then
U(ag,a.name,a)
end
end
end
local q={
by_cluster_attribute=s,by_name=ag,cluster_ids=V}ab[d]=q
return q
end
function M.normalize_endpoint(g)
return r(g)
end
function M.mapping_meta(a,ah)
if type(a)~="table"then
return nil
end
return w(a,ah)
end
function M.resolve_context_component_id(c,b)
return n(c,b)
end
function M.resolve_context_endpoint(c,b)
return k(c,b)
end
function M.resolve_mapping_endpoint(c,a,b)
return t(c,a,b)
end
function M.resolve_mapping_component_id(c,a,b)
return o(c,a,b)
end
function M.build_mapping_context(c,a,b,ai)
return W(c,a,b,ai)
end
function M.select_mapping_entry(h,c,b)
return D(h,c,b)
end
function M.collect_matching_entries(h,c,b)
return F(h,c,b)
end
function M.build_mapping_index(d)
return j(d)
end
function M.prepare_mappings(d)
if type(d)~="table"then
return d
end
if not R[d]then
R[d]=true
j(d)
end
return d
end
function M.find_mapping(d,i,y,c,b)
local q=j(d)if q==nil then
return nil
end
local E=q.by_cluster_attribute[i]if E==nil then
return nil
end
return D(E[y],c,b)
end
function M.find_mappings(d,i,y,c,b)
local q=j(d)if q==nil then
return{}
end
local E=q.by_cluster_attribute[i]if E==nil then
return{}
end
return F(E[y],c,b)
end
function M.find_mapping_by_name(d,al,c,b)
if d==nil or al==nil then
return nil
end
local q=j(d)if q==nil then
return nil
end
return D(q.by_name[al],c,b)
end
function M.has_cluster(d,i)
if d==nil then
return false
end
local q=j(d)return q~=nil and q.by_cluster_attribute[i]~=nil
end
function M.get_cluster_ids(d)
if d==nil then
return{}
end
local q=j(d)if q==nil then
return{}
end
local ak={}for _,i in ipairs(q.cluster_ids)do
ak[#ak+1]=i
end
return ak
end
end
return af
