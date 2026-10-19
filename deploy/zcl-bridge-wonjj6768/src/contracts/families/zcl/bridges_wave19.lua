local G=require"protocol.zcl"
local bi=require"capabilities.events.all"
local j=require"contracts.helpers.family"
local A=require"st.zigbee.device_management"
local B=require"st.zigbee.data_types"
local D=require"st.capabilities"
local y,d=j.definition_registry()local at="concertmirror08464."
local ao=6
local aK=0
local as=1
local l=64642
local ak=4619
local function E(capability_id)
return assert(bi[capability_id],"missing Wave19 bridge emitter: "..capability_id)()
end
local function au(a,w)
if w~=nil and type(a.emit_event)=="function"then
a:emit_event(w)
end
end
local V={
[1]="single",[2]="double",[3]="triple",[4]="quadruple",[5]="quintuple",}local H=E("candeoRfHubAction")
local function z(a,bk)
if type(a.get_field)~="function"then return nil end
return a:get_field(bk)
end
local function i(a,bk,b)
if type(a.set_field)=="function"then
a:set_field(bk,b,{persist=false})
end
end
local function aF(a,T)
if T==nil then return end
if type(a.thread)=="table"and type(a.thread.cancel_timer)=="function"then
a.thread:cancel_timer(T)
elseif type(T)=="table"and type(T.cancel)=="function"then
T:cancel()
end
end
local function u(a,g,aC)
local bc=V[aC]
if bc==nil then return false end
local w=H(a,string.format("button_%d_%s_pressed",g,bc))
if w==nil then return false end
w.state_change=true
au(a,w)return true
end
local function ai(c)
local aW=c and c.zb_rx and c.zb_rx.body and c.zb_rx.body.zcl_header or nil
local aS=aW and aW.seqno or nil
local b=type(aS)=="table"and aS.value or aS
return type(b)=="number"and b or nil
end
local function Q(a,_,c)
local g=tonumber(c and(c.src_endpoint or c.endpoint))
if g==nil or g<1 or g>10 or g%1~=0 then return end
local aj=ai(c)if aj~=nil then
local N=string.format("__wave19_candeo_rf_sequences_%d",g)local F=z(a,N)
if type(F)~="table"then F={}end
for _,bo in ipairs(F)do
if bo==aj then return end
end
local ar={aj}for aP=1,math.min(#F,4)do
ar[#ar+1]=F[aP]
end
i(a,N,ar)
end
local q=string.format("__wave19_candeo_rf_count_%d",g)local x=string.format("__wave19_candeo_rf_timer_%d",g)local aC=(tonumber(z(a,q))or 0)+1
i(a,q,aC)local aq=z(a,x)aF(a,aq)
if type(a.thread)~="table"or type(a.thread.call_with_delay)~="function"then
i(a,q,0)i(a,x,nil)u(a,g,aC)return
end
local T=a.thread:call_with_delay(1,function()
local aL=tonumber(z(a,q))or 0
i(a,q,0)i(a,x,nil)u(a,g,aL)
end,string.format("Candeo RF button %d multi-press",g))
i(a,x,T)
end
local aw={
profile="bridges-wave19-candeo-rf-hub",package_group="wave19-bridge",transport_classification="CUSTOM_ZCL",z2m_converter_source="fzLocal.kinetic_rf_button_multi_press",wire_cluster="genOnOff attribute 0x0000 endpoints 1..10",placeholder_custom_states=false,zcl_clusters={
G.cluster_attribute(ao,aK,{
name="candeo_rf_hub_press",read_only=true,handler=Q,}),},}d(aw,{
j.create_fingerprint("Candeo","C-RFZB-HUB"),})
local function O(t)
local bh=t and t.body and t.body.zcl_body or nil
return type(bh)=="table"and bh.body_bytes or nil
end
local function aU(b)
local Z=tonumber(b)
if Z==nil or Z%1~=0 or Z<0 or Z>255 then return nil end
return Z
end
local function aR(b)
if type(b)~="string"then return nil end
local P,second=string.match(b,"^%s*(%d+)%s*[:/,]%s*(%d+)%s*$")P,second=aU(P),aU(second)
if P==nil or second==nil then return nil end
return P,second
end
local function aI(b)
if type(b)~="string"and type(b)~="number"then return nil end
if type(b)=="string"then
b=string.match(b,"^%s*(%d+)%s*$")
end
return aU(b)
end
local function m(a,n,e,c)
return G.send_raw_cluster_command(
a,l,n,e,c and c.endpoint or 1,nil,nil,false)
end
local function I(n)
return function(a,_,b,c)
local P,second=aR(b)
if P==nil then return false end
return m(a,n,string.char(P,second),c)
end
end
local function az(a,_,b,c)
local o=aI(b)
if o==nil then return false end
return m(a,244,string.char(o),c)
end
local function aM(a,_,_,c)
return m(a,246,"",c)
end
local function al(bn,bm)
return G.cluster_attribute(l,nil,{
name=bn,endpoint=1,write_only=true,sender=bm,})
end
local function R(t)
local e=O(t)
if type(e)~="string"or #e~=3 then return nil end
local id,ah,bl=string.byte(e,1,3)return{id=id,key_code=ah,result=bl}
end
local function L(t)
local e=O(t)
if type(e)~="string"or #e~=2 then return nil end
local id,o=string.byte(e,1,2)return{id=id,model_type=o}
end
local function am(M)
local ap={}for _,aa in ipairs(M)do
local bb={}
for _,ah in ipairs(aa.key_codes)do bb[#bb+1]=tostring(ah)end
ap[#ap+1]=string.format("%d:%d:%s",aa.id,aa.model_type,table.concat(bb,","))
end
local b=table.concat(ap,";")
if #b>2048 then return nil end
return b
end
local function ae(t,a,prefix)
local aD="__wave19_"..prefix.."_ir_list"
local function ab()
i(a,aD,nil)return nil
end
local e=O(t)
if type(e)~="string"or #e<3 then return ab()end
local an,K,aX=string.byte(e,1,3)
if an<1 or K<1 or K>an or aX>70 or #e~=aX+3 then return ab()end
local M={}local s=4
local aO=#e
while s<=aO do
if s+2>aO then return ab()end
local id,o,Y=string.byte(e,s,s+2)
if s+2+Y>aO then return ab()end
local X={}for aP=s+3,s+2+Y do
X[#X+1]=string.byte(e,aP)
end
M[#M+1]={id=id,model_type=o,key_codes=X}s=s+3+Y
end
local C=z(a,aD)if K==1 then
C={total=an,next_packet=1,records={}}
end
if type(C)~="table"or C.total~=an or C.next_packet~=K then
return ab()
end
for _,aa in ipairs(M)do C.records[#C.records+1]=aa end
C.next_packet=K+1
if K<an then
i(a,aD,C)return nil
end
i(a,aD,nil)return am(C.records)
end
local function h(a,be,b,aJ)
if b==nil then return end
local w=be(a,b)
if w~=nil and aJ then w.state_change=true end
au(a,w)
end
local function r(aE,n,aV,bf)
return G.cluster_attribute(l,aE,{
name=string.format("heiman_ir_response_%02x",n),endpoint=1,read_only=true,command_id=n,command_extractor=aV,handler=bf,mfg_code=ak,})
end
local function U(W,a)
a:send(A.build_bind_request(
a,l,W.environment_info.hub_zigbee_eui,1))
end
local function p(ad)
local capability_prefix=ad.capability_prefix
local v=ad.mapping_prefix
local af=E(capability_prefix.."Action")local ag=E(capability_prefix.."ActionResult")local aN=E(capability_prefix.."ActionId")local ba=E(capability_prefix.."ActionKeyCode")local aQ=E(capability_prefix.."ActionModelType")local aH=E(capability_prefix.."Devices")local k={}if ad.has_battery then
k[#k+1]=G.battery({
endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,})
end
local ay={
{"send_key",I(240)},{"create_id",az},{"learn_key",I(241)},{"delete_key",I(243)},{"request_list",aM},}for _,spec in ipairs(ay)do
k[#k+1]=al(v.."_"..spec[1],spec[2])
end
k[#k+1]=r(61953,242,R,function(a,b)
h(a,af,"learn",true)h(a,ag,b.result==1 and"success"or"error",true)h(a,ba,b.key_code)
if b.result==1 then h(a,aN,b.id)end
end)
k[#k+1]=r(62721,245,L,function(a,b)
h(a,af,"create",true)h(a,ag,b.id==255 and"error"or"success",true)h(a,aQ,b.model_type)
if b.id~=255 then h(a,aN,b.id)end
end)
k[#k+1]=r(63233,247,function(t,a)
return ae(t,a,v)
end,function(a,b)
h(a,aH,b)
end)
local function J(capability_suffix,aG,av,mapping_suffix,b)
return{
capability_id=at ..capability_prefix..capability_suffix,command_name=aG,argument_name=av,mapping_name=v.."_"..mapping_suffix,value=b,}
end
return{
profile=ad.profile,package_group="wave19-bridge",transport_classification="CUSTOM_ZCL",z2m_converter_source="fzLocal/tzLocal.heiman_ir_remote",wire_cluster="0xFC82 commands F0/F1/F3/F4/F6 responses F2/F5/F7 endpoint 1",placeholder_custom_states=false,zcl_clusters=k,configure=U,capability_commands={
J("SendKey","sendKey","key","send_key"),J("CreateId","createId","modelType","create_id"),J("LearnKey","learnKey","key","learn_key"),J("DeleteKey","deleteKey","key","delete_key"),J("RequestList","requestList",nil,"request_list",true),},}
end
local aA=p({
profile="bridges-wave19-heiman-hs-one-ir",capability_prefix="heimanHsOneIr",mapping_prefix="heiman_hs_one_ir",has_battery=true,})local aB=p({
profile="bridges-wave19-heiman-hs-two-ir",capability_prefix="heimanHsTwoIr",mapping_prefix="heiman_hs_two_ir",has_battery=false,})d(aA,{
j.create_fingerprint("HEIMAN","IRControl-EM"),})d(aB,{
j.create_fingerprint("HEIMAN","IRControl2-EF-3.0"),})local S=bi.tiRouterTransmitPower()local aY={
profile="bridges-ti-router",zcl_clusters={
G.cluster_attribute(0,4919,{
name="ti_router_transmit_power",endpoint=8,data_type=B.Int8,write_type=B.Int8,prefer_plain_attribute_write=true,
emit=function(a,b,c)
return{S(a,b),D.signalStrength.lqi({value=c.zb_rx.lqi.value})}
end,
}),G.cluster_attribute(0,0,{
name="ti_router_heartbeat",endpoint=8,read_only=true,data_type=B.Uint8,minimum_interval=0,maximum_interval=3600,reportable_change=0,
emit=function(_,_,c)return D.signalStrength.lqi({value=c.zb_rx.lqi.value})end,
}),},
configure=function(W,a)
a:send(A.build_bind_request(a,0,W.environment_info.hub_zigbee_eui,8))
end,
parent_refresh=function(a)
return G.read_mapping(a,G.cluster_attribute(0,4919,{endpoint=8}))
end,
}d(aY,{j.create_fingerprint("TexasInstruments","ti.router")})local aT={
profile="bridges-slzb07mg26",magic_packet=false,placeholder_custom_states=false,zcl_clusters={
G.cluster_attribute(0,0,{
name="slzb07_link_quality",endpoint=1,read_only=true,data_type=B.Uint8,minimum_interval=3600,maximum_interval=14400,reportable_change=0,read_on_configure=true,
emit=function(_,_,c)
return D.signalStrength.lqi({value=c.zb_rx.lqi.value})
end,
}),G.cluster_attribute(0,nil,{
name="slzb07_reset",endpoint=1,write_only=true,
sender=function(a)return G.send_raw_cluster_command(a,0,0,"",1,nil,nil,true)end,
}),},capability_commands={
{capability_id=at.."slzb07Reset",command_name="reset",value=true,mapping_name="slzb07_reset"},},
configure=function(W,a)
G.bind_cluster(a,0,W.environment_info.hub_zigbee_eui,1)
end,
}d(aT,{j.create_fingerprint("SMLIGHT","SLZB-07MG26")})G.attach_reporting_capabilities(y,{
{2,"rpt-itx"},{4,"rpt-tcea"},{5,"rpt-snc"},})return{
id="zcl.bridges.wave19",registrations=y,}
