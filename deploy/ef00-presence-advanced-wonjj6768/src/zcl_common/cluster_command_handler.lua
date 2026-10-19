local function ap(u)
local z=require"st.capabilities"
local B=require"runtime.capability_metadata"
local F=require"runtime.capability_binding"
local ak=require"runtime.battery_refresh"
local aZ=require"protocol.zcl.runtime.handlers.command_dispatch"
local W=require"st.zigbee.generated.zcl_clusters"
local bG=require"st.zigbee.generated.types.ZclStatus"
local bu=require"st.zigbee.data_types"
local bj=require"st.zigbee.messages"
local aV=require"st.zigbee.zcl"
local bw=require"st.zigbee.zcl.frame_ctrl"
local aA=require"st.zigbee.zcl.global_commands.default_response"
local ae=require"st.zigbee.constants"
local bK=require"log"
local bx=W.IASACE
local aI=B.by_emit_name.remote_action
local ah=B.by_emit_name.security_remote_action
u.schedule_battery_refresh_after_button=ak.schedule_after_button
local V="__zcl_last_remote_action"
local aJ=5
local aY={
[0]="disarm",[1]="arm_day_zones",[2]="arm_night_zones",[3]="arm_all_zones",[4]="exit_delay",}local P={}local T={}local k
local function l(a)
if type(a)~="table"then
return nil
end
local bB=a.address_header and
a.address_header.src_endpoint and
a.address_header.src_endpoint.value or nil
return u.normalize_endpoint(bB)
end
local function E(a)
if type(a)~="table"then
return nil
end
local y=a.address_header and a.address_header.dest_addr or nil
return y and y.value or nil
end
local function bb(a)
if type(a)~="table"then
return nil
end
local t=a.body and a.body.zcl_header or nil
local q=t and t.frame_ctrl or nil
if q==nil or type(q.is_mfg_specific_set)~="function"or not q:is_mfg_specific_set()then
return nil
end
local aq=t.mfg_code and t.mfg_code.value or nil
return type(aq)=="number"and aq or nil
end
local function aD(d)
local bF=type(d)=="table"and type(d.get_model)=="function"and d:get_model()or nil
return bF=="TS0041"or bF=="TS0041A"
end
local function au(a)
return a and a.body and a.body.zcl_header and a.body.zcl_header.seqno and a.body.zcl_header.seqno.value or nil
end
local function D(a)
return a and a.body and a.body.zcl_header and a.body.zcl_header.cmd and a.body.zcl_header.cmd.value or nil
end
local function by(a)
return a and a.body and a.body.zcl_body and a.body.zcl_body.body_bytes or nil
end
local function O(d,bh,e)
return type(d)=="table"and
type(d.supports_capability_by_id)=="function"and
d:supports_capability_by_id(bh,e or"main")
end
local function s(d,f,aT)
local e=aT or"main"
if f~=nil and type(d)=="table"and type(d.get_component_id_for_endpoint)=="function"then
local ad=d:get_component_id_for_endpoint(f)if type(ad)=="string"and ad~=""then
e=ad
end
end
return e
end
local function aE(d,c,scene_index,f)
local R=type(c)=="table"and c.scene_component_map or nil
local e=type(R)=="table"and(R[scene_index]or R[f])or nil
if type(e)~="string"or e==""then
e=s(d,f,scene_index==1 and"main"or("button"..tostring(scene_index)))
end
return e
end
local function A(d,e,bm)
local as=z.button and z.button.button and z.button.button[bm]or nil
if as==nil then
return false
end
local o=e or"main"
if not O(d,z.button.ID,o)then
o="main"
end
if not O(d,z.button.ID,o)then
return false
end
d:emit_component_event({id=o},as({state_change=true}))ak.schedule_after_button(d)return true
end
local function U(d,e,h,ar)
if type(h)~="string"or h==""then
return false
end
local bd=table.concat({
tostring(e or"main"),tostring(h),tostring(ar or"nil"),},"|")local bC=type(d)=="table"and d:get_field(V)or nil
if bC==bd then
return false
end
d:set_field(V,bd,{persist=false})return true
end
local function C(d,c,e,h,ar)
if not U(d,e,h,ar)then
return false,false
end
local K=aI
if type(c)=="table"and type(c.remote_action_emit_name)=="string"then
K=B.by_emit_name[c.remote_action_emit_name]or K
end
return F.emit_state(d,e,K,h,{state_change=true}),true
end
local function at(d,c,h,ar)
if not U(d,"main",h,ar)then
return false
end
local K=ah
if type(c)=="table"and type(c.security_remote_action_emit_name)=="string"then
K=B.by_emit_name[c.security_remote_action_emit_name]or K
end
return F.emit_state(d,"main",K,h)
end
local function aM(aO)
if type(aO)=="table"and aO.value~=nil then
return aO.value
end
return aO
end
local function i(a,...)
local L=a and a.body and a.body.zcl_body or nil
if type(L)~="table"then
return nil
end
for _,bJ in ipairs({...})do
local ag=L[bJ]local bp=aM(ag)if bp~=nil then
return bp
end
end
return nil
end
local function am(d,c,e,a,g,b)
local be=type(c)=="table"and c.standard_action_metadata_emit_names or nil
if type(be)~="table"then
return false
end
local aW=false
local function Z(bD,aO)
local bg=be[bD]local K=type(bg)=="string"and B.by_emit_name[bg]or nil
if K~=nil and type(aO)=="number"then
aW=F.emit_state(d,e,K,aO,{state_change=true})or aW
end
end
local y=E(a)if type(y)=="number"and y>=1 and y<=65527 then
Z("action_group",y)
end
if g~=u.CLUSTER_LEVEL_CONTROL then
return aW
end
if b==0 or b==4 then
Z("action_level",i(a,"level"))local J=i(a,"transition_time","transtime")if type(J)=="number"then
Z("action_transition_time",J/10)
end
elseif b==1 or b==5 then
Z("action_rate",i(a,"rate"))elseif b==2 or b==6 then
local bI=i(a,"step_size","stepsize")Z("action_step_size",bI)local J=i(a,"transition_time","transtime")if type(J)=="number"then
Z("action_transition_time",J/10)
end
end
return aW
end
local function M(d,c,a,h,e)
if type(c)~="table"or c.advanced_remote~=true or type(h)~="string"then
return false
end
local o=e or"main"
local m=type(c.standard_action_button_events)=="table"and
c.standard_action_button_events[h]or nil
local ao,ai=C(d,c,o,h,au(a))if ai and type(m)=="string"then
A(d,o,m)
end
if ao then
if type(c.remote_action_handler)=="function"then
c.remote_action_handler(d,o,h,a)
end
local g=a and a.address_header and a.address_header.cluster and a.address_header.cluster.value or nil
am(d,c,o,a,g,D(a))
end
k(d,a,D(a)or 0)return true
end
local function N(d,c,a,h)
if type(c)~="table"or c.security_remote~=true or type(h)~="string"then
return false
end
A(d,"main","pushed")at(d,c,h,au(a))k(d,a,D(a)or 0)return true
end
local function aU(d,c,a)
if type(c)~="table"or c.security_remote~=true then
return false
end
local bA=i(a,"armmode","arm_mode")local bs=type(c.arm_mode_action_map)=="table"and c.arm_mode_action_map or aY
local h=bs[bA]if type(h)~="string"then
return false
end
return N(d,c,a,h)
end
local function aH(d,c,a)
if type(c)~="table"or c.advanced_remote~=true or type(c.ias_zone_action_map)~="table"then
return false
end
local bo=i(a,"zonestatus","zone_status")local h=c.ias_zone_action_map[bo]if type(h)~="string"then
return false
end
return M(d,c,a,h,"main")
end
local function aB(d,c,a)
if type(c)~="table"or c.security_remote~=true then
return false
end
return N(d,c,a,"emergency")
end
local function aa(d,c,a)
local f=l(a)local aR=E(a)local an=type(c)=="table"and c.group_component_map or nil
local al=type(an)=="table"and an[aR]or nil
if type(al)=="string"and al~=""then
return al
end
if type(c)=="table"and c.knob_remote==true then
return"main"
end
return s(d,f,"main")
end
local function j(d,c,a)
if type(c)~="table"or c.advanced_remote~=true then
return false
end
local g=a and a.address_header and a.address_header.cluster and a.address_header.cluster.value or nil
local b=D(a)if type(g)~="number"or type(b)~="number"then
return false
end
local h=nil
local X=nil
local resolver_handled=false
if type(c.standard_command_action_resolver)=="function"then
h,X,resolver_handled=c.standard_command_action_resolver(
a,g,b,l(a))if resolver_handled==true and type(h)~="string"then
return false
end
end
if resolver_handled~=true and g==u.CLUSTER_ON_OFF then
h=({
[0]="off",[1]="on",[2]="toggle",})[b]elseif resolver_handled~=true and g==u.CLUSTER_LEVEL_CONTROL then
if b==0 or b==4 then
h="brightness_move_to_level"
elseif b==1 or b==5 then
local n=i(a,"move_mode","movemode","mode")if n==0 or n=="up"then
h="brightness_move_up"
elseif n==1 or n=="down"then
h="brightness_move_down"
end
elseif b==2 or b==6 then
local I=i(a,"step_mode","stepmode","mode")if I==0 or I=="up"then
h="brightness_step_up"
elseif I==1 or I=="down"then
h="brightness_step_down"
end
elseif b==3 or b==7 then
h="brightness_stop"
end
elseif resolver_handled~=true and g==u.CLUSTER_COLOR_CONTROL then
if b==6 then
h="move_to_hue_and_saturation"
elseif b==7 then
h="color_move"
elseif b==1 then
local n=i(a,"move_mode","movemode","mode")if n==0 or n=="stop"then
h="hue_stop"
elseif n==1 or n=="up"then
h="hue_move"
elseif n==3 or n=="down"then
h="hue_down"
end
elseif b==71 then
h="hue_stop"
elseif b==10 then
h="color_temperature_move"
elseif b==75 then
local n=i(a,"move_mode","movemode","mode")if n==0 or n=="stop"then
h="color_temperature_stop"
elseif n==3 or n=="down"then
h="color_temperature_move_down"
elseif n==1 or n=="up"then
h="color_temperature_move_up"
end
elseif b==76 then
local I=i(a,"step_mode","stepmode","mode")if I==3 or I=="down"then
h="color_temperature_step_down"
elseif I==1 or I=="up"then
h="color_temperature_step_up"
end
end
elseif resolver_handled~=true and g==aJ then
local Y=i(a,"sceneid","scene_id")if b==0 then
h=Y~=nil and("add_"..tostring(Y))or"add"
elseif b==2 then
h=Y~=nil and("remove_"..tostring(Y))or"remove"
elseif b==3 then
h="remove_all"
elseif b==4 then
h=Y~=nil and("store_"..tostring(Y))or"store"
elseif b==5 then
h=Y~=nil and("recall_"..tostring(Y))or"recall"
end
end
if type(h)~="string"then
return false
end
local e=type(X)=="string"and X or
aa(d,c,a)local f=l(a)if c.standard_action_endpoint_suffix==true and f~=nil then
h=h.."_"..tostring(f)
end
return M(d,c,a,h,e)
end
local function az(aN,g,b)
if g==nil or b==nil then
return false
end
aN[g]=aN[g]or{}if aN[g][b]then
return false
end
aN[g][b]=true
return true
end
function k(d,a,b)
if type(d)~="table"or type(a)~="table"then
return false
end
local t=a.body and a.body.zcl_header or nil
local q=t and t.frame_ctrl or nil
if q~=nil and type(q.is_disable_default_response_set)=="function"and q:is_disable_default_response_set()then
return false
end
local y=E(a)if y~=nil and y>=65528 then
return false
end
local g=a.address_header and a.address_header.cluster and a.address_header.cluster.value or nil
local bl=a.address_header and a.address_header.src_addr and a.address_header.src_addr.value or nil
local f=a.address_header and a.address_header.src_endpoint and a.address_header.src_endpoint.value or nil
local bi=a.address_header and a.address_header.dest_endpoint and a.address_header.dest_endpoint.value or ae.HUB.ENDPOINT
if g==nil or bl==nil or f==nil then
return false
end
local Q=bw(16)
if q~=nil and type(q.get_direction)=="function"and q:get_direction()==0 then
Q:set_direction()
end
if q~=nil and type(q.is_mfg_specific_set)=="function"and q:is_mfg_specific_set()then
Q:set_mfg_specific()
end
local bz={
cmd=bu.ZCLCommandId(aA.DEFAULT_RESPONSE_ID),frame_ctrl=Q,seqno=t and t.seqno or nil,}if t and t.mfg_code~=nil then
bz.mfg_code=t.mfg_code
end
local bH=aA.DefaultResponse(b,bG.SUCCESS)d:send(bj.ZigbeeMessageTx({
address_header=bj.AddressHeader(
ae.HUB.ADDR,bi,bl,f,ae.HA_PROFILE_ID,g),body=aV.ZclMessageBody({
zcl_header=aV.ZclHeader(bz),zcl_body=bH,}),}))return true
end
u.send_default_response=k
local function ax(p)
if type(p)=="table"and(
p.raw_value~=nil or
p.typed_value~=nil or
p.attribute_id~=nil
)then
return p
end
local w=type(p)=="table"and p.value or p
return{
raw_value=w,typed_value=p,}
end
local function af(d,r,g,b,a)
local f=l(a)local aq=bb(a)local bf={}local aK=false
for _,H in ipairs(r)do
if H.cluster_id==g and H.attribute_id==nil then
for _,ag in ipairs(u.collect_matching_entries(H,d,{
zb_rx=a,endpoint=f,src_endpoint=f,command_id=b,mfg_code=aq,}))do
local ac=u.mapping_meta(ag)if ac.command_id==b and ac.command_extractor~=nil then
ac.command_extractor(a,d,ag)aK=true
end
end
end
end
local bE=u.build_mapping_index(r)if bE==nil then
return aK
end
local aQ=bE.by_cluster_attribute[g]if aQ==nil then
return aK
end
local br={}for _,ag in pairs(aQ)do
for _,H in ipairs(u.collect_matching_entries(ag,d,{
zb_rx=a,endpoint=f,src_endpoint=f,command_id=b,mfg_code=aq,}))do
if not br[H]then
br[H]=true
local ac=u.mapping_meta(H)if ac~=nil and ac.command_id==b and ac.command_extractor~=nil then
local p=ax(ac.command_extractor(a,d,H))local S=p.attribute_id or H.attribute_id
if S~=nil and bf[S]==nil then
bf[S]=p
end
end
end
end
end
for aj,p in pairs(bf)do
if u.apply_attribute(d,r,g,aj,p.raw_value,{
zb_rx=a,endpoint=f,src_endpoint=f,command_id=b,mfg_code=aq,typed_value=p.typed_value,})then
aK=true
end
end
return aK
end
function u.register_cluster_command_handler(g,b,ay)
if g==nil or b==nil or type(ay)~="function"then
bK.warn(string.format(
"skip invalid zcl cluster command handler registration cluster=%s command=%s handler=%s",tostring(g),tostring(b),type(ay)))return nil
end
P[g]=P[g]or{}P[g][b]=ay
return ay
end
function u.register_cluster_commands_from_mappings(r)
if type(r)~="table"then
return r
end
for _,H in ipairs(r)do
if type(H)=="table"then
local ac=u.mapping_meta(H)if ac~=nil and ac.cluster_id~=nil and ac.command_id~=nil and ac.command_extractor~=nil then
az(T,ac.cluster_id,ac.command_id)
end
end
end
return r
end
function u.build_zigbee_cluster_handlers(av)
local v={}for g,bn in pairs(T)do
v[g]=v[g]or{}for b,_ in pairs(bn)do
v[g][b]=function(_,d,a)
local c=av(d)if c==nil or c.zcl_clusters==nil then
return
end
return af(d,c.zcl_clusters,g,b,a)
end
end
end
for g,ba in pairs(P)do
v[g]=v[g]or{}for b,ay in pairs(ba)do
v[g][b]=function(_,d,a)
local c=av(d)if c==nil or c.zcl_clusters==nil then
return
end
local aL=nil
if T[g]~=nil and T[g][b]then
aL=function()
return af(d,c.zcl_clusters,g,b,a)
end
end
return aZ.dispatch(function()
return ay(d,c,a)
end,aL)
end
end
end
return v
end
function u.build_zigbee_global_handlers(av)
return require("zcl_common.reporting").global_handlers(u,{
[0]={
[2]=function(_,d,a)
local c=av(d)if type(c)~="table"or c.accept_basic_write_attributes~=true then
return
end
local bq=a and a.body and a.body.zcl_body and a.body.zcl_body.attr_records or nil
if type(bq)~="table"then
return
end
local f=l(a)for _,bk in ipairs(bq)do
local aj=bk.attr_id and bk.attr_id.value or nil
local bt=bk.data
local w=type(bt)=="table"and bt.value or bt
if type(aj)=="number"then
u.apply_attribute(d,c.zcl_clusters,0,aj,w,{
zb_rx=a,endpoint=f,src_endpoint=f,typed_value=bt,})
end
end
end,
},})
end
u.register_cluster_command_handler(u.CLUSTER_IAS_ZONE,1,function(d,c,a)
local r=c and c.zcl_clusters or nil
if not u.has_cluster(r,u.CLUSTER_IAS_ZONE)then
return false
end
local f=l(a)if f==nil then
return false
end
local aP=W.IASZone.server.commands.ZoneEnrollResponse(
d,W.IASZone.types.EnrollResponseCode(0),0)d:send(aP:to_endpoint(f))return true
end)
local function aw(d,c,a)
local L=a and a.body and a.body.zcl_body or nil
local w=nil
local f=l(a)local ar=au(a)local b=D(a)or 253
if type(L)=="table"then
if L.value~=nil then
w=L.value.value or L.value
elseif type(L.body_bytes)=="string"and #L.body_bytes>=1 then
w=string.byte(L.body_bytes,1)
end
end
if type(c)=="table"and c.scene_switch==true then
local aG=type(c.scene_action_map)=="table"and(c.scene_action_map[f]or c.scene_action_map[w])or f or w
if aG~=nil then
local aF=type(c.scene_action_name_map)=="table"and c.scene_action_name_map or nil
local h=type(aF)=="table"and aF[aG]or nil
if type(h)~="string"or h==""then
h="scene_"..tostring(aG)
end
local e=aE(d,c,aG,f)A(d,e,"pushed")C(d,c,e,h,ar)
end
k(d,a,b)return true
end
if type(c)=="table"and c.advanced_remote==true then
local ab=type(c.tuya_action_map)=="table"and c.tuya_action_map[w]or nil
if type(ab)~="string"and type(c.tuya_action_name)=="string"then
ab=c.tuya_action_name
end
if type(ab)=="string"then
local aC=type(c.tuya_action_components)=="table"and c.tuya_action_components[w]or nil
local e=type(aC)=="string"and aC or s(d,f,"main")local m=type(c.tuya_action_button_events)=="table"and c.tuya_action_button_events[w]or nil
if type(m)=="string"then
A(d,e,m)
end
C(d,c,e,ab,ar)k(d,a,b)return true
end
local bc=b==252 and{
[0]="rotate_right",[1]="rotate_left",}or{
[0]="single",[1]="double",[2]="hold",}local base_action=bc[w]if base_action~=nil then
local e=s(d,f,"main")if c.knob_remote==true then
local ao,ai=C(d,c,"main",base_action,ar)if ao then
if type(c.remote_action_handler)=="function"then
c.remote_action_handler(d,"main",base_action,a)
end
end
if ai and(base_action=="single"or base_action=="double"or base_action=="hold")then
local m=({
single="pushed",double="double",hold="held",})[base_action]if m~=nil then
A(d,e,m)
end
end
else
local aS=type(c.button_count)=="number"and f or f
local h=base_action
if c.unprefixed_remote_actions~=true then
h=aS~=nil and(tostring(aS).."_"..base_action)or base_action
end
local m=({
single="pushed",double="double",hold="held",})[base_action]if m~=nil then
A(d,e,m)
end
C(d,c,e,h,ar)
end
end
k(d,a,b)return true
end
local m=({
[0]=z.button.button.pushed({state_change=true}),[1]=z.button.button.double({state_change=true}),[2]=z.button.button.held({state_change=true}),})[w]if m==nil then
return false
end
local e="main"
if not aD(d)and f~=nil and type(d.get_component_id_for_endpoint)=="function"then
local ad=d:get_component_id_for_endpoint(f)if type(ad)=="string"and ad~=""then
e=ad
end
end
if type(d.supports_capability_by_id)=="function"and not d:supports_capability_by_id(z.button.ID,e)then
e="main"
end
d:emit_component_event({id=e},m)ak.schedule_after_button(d)k(d,a,b)return true
end
for _,b in ipairs({253,252})do
u.register_cluster_command_handler(u.CLUSTER_ON_OFF,b,function(d,c,a)
return aw(d,c,a)
end)
end
for _,b in ipairs({0,1,2,3,64})do
u.register_cluster_command_handler(u.CLUSTER_ON_OFF,b,function(d,c,a)
return j(d,c,a)
end)
end
for _,b in ipairs({0,1,2,3,4,5,6,7})do
u.register_cluster_command_handler(u.CLUSTER_LEVEL_CONTROL,b,function(d,c,a)
return j(d,c,a)
end)
end
for _,b in ipairs({0,1,2})do
u.register_cluster_command_handler(u.CLUSTER_WINDOW_COVERING,b,function(d,c,a)
return j(d,c,a)
end)
end
for _,b in ipairs({
0,1,2,3,5,6,7,10,67,68,71,75,76,})do
u.register_cluster_command_handler(u.CLUSTER_COLOR_CONTROL,b,function(d,c,a)
return j(d,c,a)
end)
end
for _,b in ipairs({0,2,3,4,5})do
u.register_cluster_command_handler(aJ,b,function(d,c,a)
return j(d,c,a)
end)
end
u.register_cluster_command_handler(bx.ID,0,function(d,c,a)
return aU(d,c,a)
end)
for _,b in ipairs({2,4})do
u.register_cluster_command_handler(bx.ID,b,function(d,c,a)
return aB(d,c,a)
end)
end
u.register_cluster_command_handler(u.CLUSTER_IAS_ZONE,0,function(d,c,a)
return aH(d,c,a)
end)
for _,b in ipairs({0,2,3,4,5})do
u.register_cluster_command_handler(60672,b,function(d,c,a)
if type(c)~="table"or c.ir_controller~=true or u.handle_ir_transmit_command==nil then
return false
end
return u.handle_ir_transmit_command(d,c,a)
end)
end
end
return ap
