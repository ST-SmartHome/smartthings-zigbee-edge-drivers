local function t(m)
local l=require"runtime.battery_refresh"
function m.is_duplicate_attribute_event(b,i,a)
if type(i)~="table"or i.state_change==true or type(b.get_latest_state)~="function"then
return false
end
local B=type(i.capability)=="table"and i.capability.ID or nil
local v=type(i.attribute)=="table"and i.attribute.NAME or nil
if B==nil or v==nil then
return false
end
local P=i.value
if type(P)~="table"then
return false
end
local d=P.value
for ac in pairs(P)do
if ac~="value"and ac~="unit"then
return false
end
end
local z=type(d)if z~="number"and z~="string"and z~="boolean"then
return false
end
local S=a.component and a.component.id or"main"
return b:get_latest_state(S,B,v)==d
end
local function V(d,L)
if d==nil or L==nil or L==1 then
return d
end
if type(d)=="number"and type(L)=="number"and L~=0 then
return d/L
end
return d
end
local function G(d,O,h,b,a,g)
if h.from_device~=nil then
return h.from_device(d,b,a,g)
end
return O
end
local function N(h)
local A=h and h.attribute_def or nil
local Q=A and A.base_type or nil
return type(Q)=="table"and Q.NAME or nil
end
local function C(n)
if type(n)~="string"then
return false
end
return n=="Boolean"or
n=="SemiPrecisionFloat"or
n=="SinglePrecisionFloat"or
n=="DoublePrecisionFloat"or
n=="TimeOfDay"or
n=="Date"or
n=="UtcTime"or
n=="IeeeAddress"or
n=="SecurityKey"or
n:match("^Uint%d+$")~=nil or
n:match("^Int%d+$")~=nil or
n:match("String$")~=nil
end
local function p(c,h,a)
local u=a.typed_value
if u==nil or u==c or type(u)~="table"then
return false
end
if h.prefer_typed_value then
return true
end
if not h.custom_from_device then
return false
end
local R=N(h)if R~=nil then
return not C(R)
end
return type(c)~="number"and type(c)~="boolean"and type(c)~="string"
end
local function M(c,h,b,a,g)
local r=m.scale_mapping_value and
m.scale_mapping_value(b,g,c,h,a)or
V(c,h.scale)a.scaled_value=r
local H=p(c,h,a)and
a.typed_value or
r
return G(H,r,h,b,a,g)
end
local function I(b,i,a)
if i==nil then
return
end
l.maybe_schedule_after_event(b,i)if m.is_duplicate_attribute_event(b,i,a)then
return
end
if a.component~=nil and type(b.emit_component_event)=="function"then
b:emit_component_event(a.component,i)return
end
if a.endpoint~=nil and type(b.emit_event_for_endpoint)=="function"then
b:emit_event_for_endpoint(a.endpoint,i)return
end
b:emit_event(i)
end
local function W(b,D,a)
if D==nil then
return
end
if type(D)=="table"and D[1]~=nil then
for _,i in ipairs(D)do
I(b,i,a)
end
return
end
I(b,D,a)
end
local function s(k)
if type(k)~="table"then
return nil
end
local ab=k.address_header and
k.address_header.src_endpoint and
k.address_header.src_endpoint.value or nil
return m.normalize_endpoint(ab)
end
local function F(k)
if type(k)~="table"then
return nil
end
local q=k.body and k.body.zcl_header or nil
local x=q and q.frame_ctrl or nil
if x==nil or type(x.is_mfg_specific_set)~="function"or not x:is_mfg_specific_set()then
return nil
end
local y=q.mfg_code and q.mfg_code.value or nil
return type(y)=="number"and y or nil
end
local function o(d)
if type(d)=="table"and d.value~=nil then
return d.value
end
return d
end
local function w(b,g,c,e)
if g==nil then
return nil
end
local h=m.mapping_meta(g)if h==nil or h.write_only then
return nil
end
local a=m.build_mapping_context(b,g,e,c)a.raw_value=c
a.typed_value=e and e.typed_value or c
local d=M(c,h,b,a,g)if d==nil then
return nil
end
a.value=d
if m.handle_metering_value~=nil then
m.handle_metering_value(b,g,d,h,a)
end
if m.handle_switch_state~=nil and h.cluster_id==m.CLUSTER_ON_OFF and h.attribute_id==m.ATTR_ON_OFF then
m.handle_switch_state(b,a.zcl_clusters or nil,d)
end
if h.handler~=nil then
h.handler(b,d,a,g)
end
if h.emit~=nil then
W(b,h.emit(b,d,a,g),a)
end
return d
end
function m.apply_attribute(b,U,j,f,c,e)
if j==1 and(f==32 or f==33)then
l.note_report(b)
end
local Y=e or{}local T=m.find_mappings(U,j,f,b,Y)if T[1]==nil then
return false
end
local X=false
for _,g in ipairs(T)do
if w(b,g,c,Y)~=nil then
X=true
end
end
return X
end
function m.build_zigbee_attr_handlers(Z)
local function J(j,f)
return function(_,b,d,aa)
if j==1 and(f==32 or f==33)then
l.note_report(b)
end
local K=Z(b)if K and K.zcl_clusters then
local E=s(aa)local y=F(aa)local c=o(d)local e={
cluster_id=j,attribute_id=f,zb_rx=aa,src_endpoint=E,endpoint=E,mfg_code=y,typed_value=d,zcl_clusters=K.zcl_clusters,}m.handle_internal_attribute(b,j,f,d,e)m.apply_attribute(b,K.zcl_clusters,j,f,c,e)
end
end
end
return m.build_attribute_handlers(J)
end
end
return t
