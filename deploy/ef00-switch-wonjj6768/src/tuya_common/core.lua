local E=require"st.zigbee.data_types"
local s=require"st.zigbee.constants"
local p=require"st.zigbee.zcl"
local D=require"st.zigbee.messages"
local K=require"st.zigbee.generic_body"
local k=require"st.zigbee.zcl.global_commands.read_attribute"
local J=require"st.zigbee.cluster_base"
local ab=require"st.utils"
local F=require"tuya_common.foundation"
local ad=F.log
local a={}for ac,f in pairs(F)do
a[ac]=f
end
a.data_types=E
a.constants=s
a.zcl_messages=p
a.messages=D
a.generic_body=K
a.read_attribute=k
a.cluster_base=J
a.utils=ab
a.REPORT_COMMANDS={
[a.GET_DATA]=true,[a.SET_DATA_RESPONSE]=true,[a.REPORT_STATUS]=true,[a.ACTIVE_STATUS_REPORT]=true,}local m=a.BASIC_CLUSTER
local r=a.PACKET_ID_FIELD
local n=a.PERSIST_FALSE
local w=a.BASIC_ENDPOINT_FIELD
local P=a.string_byte
local A=a.string_char
local B=a.string_pack
local R=a.string_len
local x=a.math_floor
local d=a.type_check
local M=a.table_concat
local function H(j)
local e=j:get_field(r)if d(e)~="number"or e%1~=0 then
e=0
end
local u=e+1
if u>=65536 then
u=1
end
j:set_field(r,u,n)return u
end
local function h(j,Q,o)
local T=o and j:get_field(o)or nil
if T then
return T
end
local g=j:get_endpoint(Q)if g and o then
j:set_field(o,g,n)
end
return g
end
local function t(c)
if d(c)=="string"then
return c
end
if d(c)~="table"then
return nil
end
return c.body and c.body.zcl_body and c.body.zcl_body.body_bytes or nil
end
local function z(c)
if d(c)~="table"then
return nil
end
return c.body and
c.body.zcl_header and
c.body.zcl_header.cmd and
c.body.zcl_header.cmd.value or nil
end
local function q(c)
if d(c)~="table"then
return nil
end
local g=c.address_header and
c.address_header.src_endpoint and
c.address_header.src_endpoint.value or nil
if d(g)=="number"then
return g
end
return nil
end
local function i(j,V)
local g=h(j,m,w)if not g then
ad.warn(string.format("Cluster 0x%04X endpoint not found",m))return nil
end
local S=p.ZclHeader({
cmd=E.ZCLCommandId(k.ReadAttribute.ID)})local G=D.AddressHeader(
s.HUB.ADDR,s.HUB.ENDPOINT,j:get_short_address(),g,s.HA_PROFILE_ID,m)local L=p.ZclMessageBody({
zcl_header=S,zcl_body=k.ReadAttribute(V)})return D.ZigbeeMessageTx({
address_header=G,body=L})
end
local function C(Z)
local X={}for aa,W in ipairs(Z or{})do
if d(W)~="number"then
return nil
end
local b=x(W)if b~=W or b<0 or b>255 then
return nil
end
X[aa]=A(b)
end
return M(X)
end
local function U(f)
if d(f)=="string"then
return f
end
if d(f)=="table"then
return C(f)
end
return nil
end
local function N(f)
if d(f)~="number"then
return nil
end
local b=x(f)if b~=f or b<0 then
return nil
end
f=b
if f<=255 then
return A(f)elseif f<=65535 then
return B(">I2",f)elseif f<=0xFFFFFFFF then
return B(">I4",f)
end
return nil
end
local function O(Y)
if Y then
return{persist=true}
end
return n
end
local function v(l)
if l==nil then
return nil
end
if d(l)~="number"then
return nil
end
local b=x(l)if b~=l then
return nil
end
b=b%65536
if b<0 then
b=b+65536
end
return b
end
local function y(c)
local I=t(c)if I and R(I)>=2 then
return P(I,2)
end
return nil
end
a.next_packet_id=H
a.resolve_cluster_endpoint=h
a.extract_payload=t
a.extract_command_id=z
a.extract_source_endpoint=q
a.build_basic_read_attributes_message=i
a.raw_bytes=U
a.pack_bitmap=N
a.persist_opt=O
a.normalize_transaction=v
a.extract_transaction=y
return a
