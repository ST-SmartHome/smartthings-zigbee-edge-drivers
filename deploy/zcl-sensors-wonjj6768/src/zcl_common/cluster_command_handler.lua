local function J(t)
local H=require"st.capabilities"
local ai=require"runtime.capability_metadata"
local N=require"runtime.capability_binding"
local X=require"runtime.battery_refresh"
local ao=require"protocol.zcl.runtime.handlers.command_dispatch"
local M=require"st.zigbee.generated.zcl_clusters"
local aN=require"st.zigbee.generated.types.ZclStatus"
local aF=require"st.zigbee.data_types"
local aA=require"st.zigbee.messages"
local am=require"st.zigbee.zcl"
local aG=require"st.zigbee.zcl.frame_ctrl"
local T=require"st.zigbee.zcl.global_commands.default_response"
local D=require"st.zigbee.constants"
local aR=require"log"
local Z=ai.by_emit_name.remote_action
t.schedule_battery_refresh_after_button=X.schedule_after_button
local z="__zcl_last_remote_action"
local aa=5
local v={}local y={}local p
local function r(b)
if type(b)~="table"then
return nil
end
local aI=b.address_header and
b.address_header.src_endpoint and
b.address_header.src_endpoint.value or nil
return t.normalize_endpoint(aI)
end
local function L(b)
if type(b)~="table"then
return nil
end
local C=b.address_header and b.address_header.dest_addr or nil
return C and C.value or nil
end
local function aq(b)
if type(b)~="table"then
return nil
end
local n=b.body and b.body.zcl_header or nil
local l=n and n.frame_ctrl or nil
if l==nil or type(l.is_mfg_specific_set)~="function"or not l:is_mfg_specific_set()then
return nil
end
local V=n.mfg_code and n.mfg_code.value or nil
return type(V)=="number"and V or nil
end
local function W(d)
local aM=type(d)=="table"and type(d.get_model)=="function"and d:get_model()or nil
return aM=="TS0041"or aM=="TS0041A"
end
local function ah(b)
return b and b.body and b.body.zcl_header and b.body.zcl_header.seqno and b.body.zcl_header.seqno.value or nil
end
local function A(b)
return b and b.body and b.body.zcl_header and b.body.zcl_header.cmd and b.body.zcl_header.cmd.value or nil
end
local function Q(d,g,e,av)
if type(e)~="string"or e==""then
return false
end
local au=table.concat({
tostring(g or"main"),tostring(e),tostring(av or"nil")},"|")local aJ=type(d)=="table"and d:get_field(z)or nil
if aJ==au then
return false
end
d:set_field(z,au,{persist=false})return true
end
local function K(d,j,g,e,av)
if not Q(d,g,e,av)then
return false,false
end
local aK=Z
return N.emit_state(d,g,aK,e,{state_change=true}),true
end
local function ac(ax)
if type(ax)=="table"and ax.value~=nil then
return ax.value
end
return ax
end
local function m(b,...)
local u=b and b.body and b.body.zcl_body or nil
if type(u)~="table"then
return nil
end
for _,aQ in ipairs{...}do
local al=u[aQ]local aD=ac(al)if aD~=nil then
return aD
end
end
return nil
end
local function I(d,j,b,e,g)
if type(j)~="table"or j.advanced_remote~=true or type(e)~="string"then
return false
end
local as=g or"main"
K(d,j,as,e,ah(b))p(d,b,A(b)or 0)return true
end
local function f(d,j,b)
if type(j)~="table"or j.advanced_remote~=true then
return false
end
local c=b and b.address_header and b.address_header.cluster and b.address_header.cluster.value or nil
local a=A(b)if type(c)~="number"or type(a)~="number"then
return false
end
local e
if c==t.CLUSTER_ON_OFF then
e=({
[0]="off",[1]="on",[2]="toggle"})[a]elseif c==t.CLUSTER_LEVEL_CONTROL then
if a==0 or a==4 then
e="brightness_move_to_level"
elseif a==1 or a==5 then
local i=m(b,"move_mode","movemode","mode")if i==0 or i=="up"then
e="brightness_move_up"
elseif i==1 or i=="down"then
e="brightness_move_down"
end
elseif a==2 or a==6 then
local s=m(b,"step_mode","stepmode","mode")if s==0 or s=="up"then
e="brightness_step_up"
elseif s==1 or s=="down"then
e="brightness_step_down"
end
elseif a==3 or a==7 then
e="brightness_stop"
end
elseif c==t.CLUSTER_COLOR_CONTROL then
if a==6 then
e="move_to_hue_and_saturation"
elseif a==7 then
e="color_move"
elseif a==1 then
local i=m(b,"move_mode","movemode","mode")if i==0 or i=="stop"then
e="hue_stop"
elseif i==1 or i=="up"then
e="hue_move"
elseif i==3 or i=="down"then
e="hue_down"
end
elseif a==71 then
e="hue_stop"
elseif a==10 then
e="color_temperature_move"
elseif a==75 then
local i=m(b,"move_mode","movemode","mode")if i==0 or i=="stop"then
e="color_temperature_stop"
elseif i==3 or i=="down"then
e="color_temperature_move_down"
elseif i==1 or i=="up"then
e="color_temperature_move_up"
end
elseif a==76 then
local s=m(b,"step_mode","stepmode","mode")if s==3 or s=="down"then
e="color_temperature_step_down"
elseif s==1 or s=="up"then
e="color_temperature_step_up"
end
end
elseif c==aa then
local B=m(b,"sceneid","scene_id")if a==0 then
e=B~=nil and("add_"..tostring(B))or"add"
elseif a==2 then
e=B~=nil and("remove_"..tostring(B))or"remove"
elseif a==3 then
e="remove_all"
elseif a==4 then
e=B~=nil and("store_"..tostring(B))or"store"
elseif a==5 then
e=B~=nil and("recall_"..tostring(B))or"recall"
end
end
if type(e)~="string"then
return false
end
local g="main"
return I(d,j,b,e,g)
end
local function S(ae,c,a)
if c==nil or a==nil then
return false
end
ae[c]=ae[c]or{}if ae[c][a]then
return false
end
ae[c][a]=true
return true
end
function p(d,b,a)
if type(d)~="table"or type(b)~="table"then
return false
end
local n=b.body and b.body.zcl_header or nil
local l=n and n.frame_ctrl or nil
if l~=nil and type(l.is_disable_default_response_set)=="function"and l:is_disable_default_response_set()then
return false
end
local C=L(b)if C~=nil and C>=65528 then
return false
end
local c=b.address_header and b.address_header.cluster and b.address_header.cluster.value or nil
local aB=b.address_header and b.address_header.src_addr and b.address_header.src_addr.value or nil
local h=b.address_header and b.address_header.src_endpoint and b.address_header.src_endpoint.value or nil
local az=b.address_header and b.address_header.dest_endpoint and b.address_header.dest_endpoint.value or D.HUB.ENDPOINT
if c==nil or aB==nil or h==nil then
return false
end
local w=aG(16)
if l~=nil and type(l.get_direction)=="function"and l:get_direction()==0 then
w:set_direction()
end
if l~=nil and type(l.is_mfg_specific_set)=="function"and l:is_mfg_specific_set()then
w:set_mfg_specific()
end
local aH={
cmd=aF.ZCLCommandId(T.DEFAULT_RESPONSE_ID),frame_ctrl=w,seqno=n and n.seqno or nil}if n and n.mfg_code~=nil then
aH.mfg_code=n.mfg_code
end
local aP=T.DefaultResponse(a,aN.SUCCESS)d:send(aA.ZigbeeMessageTx{
address_header=aA.AddressHeader(
D.HUB.ADDR,az,aB,h,D.HA_PROFILE_ID,c),body=am.ZclMessageBody{
zcl_header=am.ZclHeader(aH),zcl_body=aP}})return true
end
t.send_default_response=p
local function P(k)
if type(k)=="table"and(
k.raw_value~=nil or
k.typed_value~=nil or
k.attribute_id~=nil
)then
return k
end
local G=type(k)=="table"and k.value or k
return{
raw_value=G,typed_value=k}
end
local function E(d,q,c,a,b)
local h=r(b)local V=aq(b)local aw={}local an=false
local aL=t.build_mapping_index(q)if aL==nil then
return an
end
local ag=aL.by_cluster_attribute[c]if ag==nil then
return an
end
local aE={}for _,al in pairs(ag)do
for _,F in ipairs(t.collect_matching_entries(al,d,{
zb_rx=b,endpoint=h,src_endpoint=h,command_id=a,mfg_code=V}))do
if not aE[F]then
aE[F]=true
local U=t.mapping_meta(F)if U~=nil and U.command_id==a and U.command_extractor~=nil then
local k=P(U.command_extractor(b,d,F))local x=k.attribute_id or F.attribute_id
if x~=nil and aw[x]==nil then
aw[x]=k
end
end
end
end
end
for ay,k in pairs(aw)do
if t.apply_attribute(d,q,c,ay,k.raw_value,{
zb_rx=b,endpoint=h,src_endpoint=h,command_id=a,mfg_code=V,typed_value=k.typed_value})then
an=true
end
end
return an
end
function t.register_cluster_command_handler(c,a,R)
if c==nil or a==nil or type(R)~="function"then
aR.warn(string.format(
"skip invalid zcl cluster command handler registration cluster=%s command=%s handler=%s",tostring(c),tostring(a),type(R)))return nil
end
v[c]=v[c]or{}v[c][a]=R
return R
end
function t.register_cluster_commands_from_mappings(q)
if type(q)~="table"then
return q
end
for _,F in ipairs(q)do
if type(F)=="table"then
local U=t.mapping_meta(F)if U~=nil and U.cluster_id~=nil and U.command_id~=nil and U.command_extractor~=nil then
S(y,U.cluster_id,U.command_id)
end
end
end
return q
end
function t.build_zigbee_cluster_handlers(ad)
local o={}for c,aC in pairs(y)do
o[c]=o[c]or{}for a,_ in pairs(aC)do
o[c][a]=function(_,d,b)
local j=ad(d)if j==nil or j.zcl_clusters==nil then
return
end
return E(d,j.zcl_clusters,c,a,b)
end
end
end
for c,ap in pairs(v)do
o[c]=o[c]or{}for a,R in pairs(ap)do
o[c][a]=function(_,d,b)
local j=ad(d)if j==nil or j.zcl_clusters==nil then
return
end
local ab
if y[c]~=nil and y[c][a]then
ab=function()
return E(d,j.zcl_clusters,c,a,b)
end
end
return ao.dispatch(function()
return R(d,j,b)
end,ab)
end
end
end
return o
end
function t.build_zigbee_global_handlers(ad)
return require"zcl_common.reporting".global_handlers(t,{})
end
t.register_cluster_command_handler(t.CLUSTER_IAS_ZONE,1,function(d,j,b)
local q=j and j.zcl_clusters or nil
if not t.has_cluster(q,t.CLUSTER_IAS_ZONE)then
return false
end
local h=r(b)if h==nil then
return false
end
local af=M.IASZone.server.commands.ZoneEnrollResponse(
d,M.IASZone.types.EnrollResponseCode(0),0)d:send(af:to_endpoint(h))return true
end)
local function O(d,j,b)
local u=b and b.body and b.body.zcl_body or nil
local G
local h=r(b)local av=ah(b)local a=A(b)or 253
if type(u)=="table"then
if u.value~=nil then
G=u.value.value or u.value
elseif type(u.body_bytes)=="string"and #u.body_bytes>=1 then
G=string.byte(u.body_bytes,1)
end
end
if type(j)=="table"and j.advanced_remote==true then
local at=a==252 and{
[0]="rotate_right",[1]="rotate_left"}or{
[0]="single",[1]="double",[2]="hold"}local base_action=at[G]if base_action~=nil then
local g="main"
local ak=h
local e=base_action
e=ak~=nil and(tostring(ak).."_"..base_action)or base_action
K(d,j,g,e,av)
end
p(d,b,a)return true
end
local aj=({
[0]=H.button.button.pushed{state_change=true},[1]=H.button.button.double{state_change=true},[2]=H.button.button.held{state_change=true}})[G]if aj==nil then
return false
end
local g="main"
if not W(d)and h~=nil and type(d.get_component_id_for_endpoint)=="function"then
local ar=d:get_component_id_for_endpoint(h)if type(ar)=="string"and ar~=""then
g=ar
end
end
if type(d.supports_capability_by_id)=="function"and not d:supports_capability_by_id(H.button.ID,g)then
g="main"
end
d:emit_component_event({id=g},aj)X.schedule_after_button(d)p(d,b,a)return true
end
for _,a in ipairs{253,252}do
t.register_cluster_command_handler(t.CLUSTER_ON_OFF,a,O)
end
for _,a in ipairs{0,1,2,3,64}do
t.register_cluster_command_handler(t.CLUSTER_ON_OFF,a,f)
end
for _,a in ipairs{0,1,2,3,4,5,6,7}do
t.register_cluster_command_handler(t.CLUSTER_LEVEL_CONTROL,a,f)
end
for _,a in ipairs{
0,1,2,3,5,6,7,10,67,68,71,75,76}do
t.register_cluster_command_handler(t.CLUSTER_COLOR_CONTROL,a,f)
end
for _,a in ipairs{0,2,3,4,5}do
t.register_cluster_command_handler(aa,a,f)
end
end
return J
