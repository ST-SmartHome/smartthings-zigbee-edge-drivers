local function ae(B)
local t=require"runtime.capability_metadata"
local l=require"runtime.capability_binding"
local aw=require"log"
local R=t.by_emit_name.learn_ir_code
local N=t.by_emit_name.learned_ir_code
local M=t.by_emit_name.ir_code_to_send
local p=57348
local g=60672
local ak=1
local Z=56
local y="__ir_learning"
local G="__ir_next_seq"
local H="__ir_outgoing_messages"
local i="__ir_incoming_bytes"
local m="__ir_incoming_length"
local z="__ir_last_learned_code"
local F="__ir_last_sent_code"
local function encode_le16(ao)
local C=math.max(0,math.min(65535,math.floor(ao or 0)))return string.char(bit32.band(C,255))..string.char(bit32.band(bit32.rshift(C,8),255))
end
local function encode_le32(ao)
local C=math.max(0,math.min(0xFFFFFFFF,math.floor(ao or 0)))return string.char(bit32.band(C,255))..string.char(bit32.band(bit32.rshift(C,8),255))..string.char(bit32.band(bit32.rshift(C,16),255))..string.char(bit32.band(bit32.rshift(C,24),255))
end
local function s(A,r)
r=r or 1
if type(A)~="string"or #A<r+1 then
return nil
end
local b1=string.byte(A,r)or 0
local b2=string.byte(A,r+1)or 0
return b1+bit32.lshift(b2,8)
end
local function D(A,r)
r=r or 1
if type(A)~="string"or #A<r+3 then
return nil
end
local b1=string.byte(A,r)or 0
local b2=string.byte(A,r+1)or 0
local b3=string.byte(A,r+2)or 0
local b4=string.byte(A,r+3)or 0
return b1+
bit32.lshift(b2,8)+
bit32.lshift(b3,16)+
bit32.lshift(b4,24)
end
local function ac(L)
if type(L)~="string"then
return 0
end
local ai=0
for E=1,#L do
ai=(ai+(string.byte(L,E)or 0))%256
end
return ai
end
local function ah(af)
if type(af)~="string"or af==""then
return""
end
local U="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local j={}local O=#af
local E=1
while E<=O do
local a=string.byte(af,E)or 0
local b=string.byte(af,E+1)or 0
local c=string.byte(af,E+2)or 0
local n=bit32.lshift(a,16)+bit32.lshift(b,8)+c
j[#j+1]=U:sub(bit32.rshift(n,18)+1,bit32.rshift(n,18)+1)j[#j+1]=U:sub(bit32.band(bit32.rshift(n,12),63)+1,bit32.band(bit32.rshift(n,12),63)+1)if E+1<=O then
j[#j+1]=U:sub(bit32.band(bit32.rshift(n,6),63)+1,bit32.band(bit32.rshift(n,6),63)+1)else
j[#j+1]="="
end
if E+2<=O then
j[#j+1]=U:sub(bit32.band(n,63)+1,bit32.band(n,63)+1)else
j[#j+1]="="
end
E=E+3
end
return table.concat(j)
end
local function k(f)
return type(f)=="table"and type(f.ir_endpoint)=="number"and f.ir_endpoint or ak
end
local function q(d)
local X=type(d)=="table"and d:get_field(H)or nil
if type(X)~="table"then
X={}d:set_field(H,X,{persist=false})
end
return X
end
local function aq(d)
local o=type(d)=="table"and d:get_field(G)or 0
if type(o)~="number"then
o=0
end
o=(o+1)%65536
d:set_field(G,o,{persist=false})return o
end
local function u(d,av)
l.emit_state(d,"main",R,av)
end
local function J(d,W)
l.emit_state(d,"main",N,W or"")
end
local function I(d,W)
l.emit_state(d,"main",M,W or"")
end
function B.emit_ir_state(d,f)
if type(f)~="table"or f.ir_controller~=true then
return
end
local ap=d:get_field(y)==true
u(d,ap and"start"or"stop")J(d,d:get_field(z)or"")I(d,d:get_field(F)or"")
end
function B.start_ir_learning(d,f)
if B.send_raw_cluster_command==nil then
return false
end
d:set_field(y,true,{persist=false})u(d,"start")return B.send_raw_cluster_command(d,p,0,'{"study":0}',k(f))
end
function B.stop_ir_learning(d,f)
if B.send_raw_cluster_command==nil then
return false
end
d:set_field(y,false,{persist=false})u(d,"stop")return B.send_raw_cluster_command(d,p,0,'{"study":1}',k(f))
end
function B.send_ir_code(d,f,W)
if B.send_raw_cluster_command==nil or type(W)~="string"or W==""then
return false
end
local o=aq(d)local L=string.format(
'{"key_num":1,"delay":300,"key1":{"num":1,"freq":38000,"type":1,"key_code":"%s"}}',W)local ad=q(d)ad[o]=L
d:set_field(F,W,{persist=false})I(d,W)return B.send_raw_cluster_command(
d,g,0,encode_le16(o)..
encode_le32(#L)..
encode_le32(0)..
encode_le16(p)..
string.char(1)..
string.char(2)..
encode_le16(0),k(f))
end
local function P(d,f,o,e)
return B.send_raw_cluster_command(
d,g,2,encode_le16(o)..encode_le32(e)..string.char(Z),k(f))
end
local function Y(d,f,o,e,aj)
local ad=q(d)local ag=ad[o]if type(ag)~="string"then
aw.warn(string.format("missing pending IR message for seq=%s",tostring(o)))return false
end
local al=e+1
local an=math.min(#ag,e+aj)local part=ag:sub(al,an)local ai=ac(part)return B.send_raw_cluster_command(
d,g,3,string.char(0)..
encode_le16(o)..
encode_le32(e)..
string.char(#part)..
part..
string.char(ai),k(f))
end
local function V(d,e,part,h)
local x=d:get_field(i)if type(x)~="string"then
x=string.rep("\0",h)elseif #x<h then
x=x..string.rep("\0",h-#x)
end
local as=e>0 and x:sub(1,e)or""
local aa=e+#part+1
local suffix=aa<=#x and x:sub(aa)or""
local ab=as..part..suffix
d:set_field(i,ab,{persist=false})return ab
end
function B.handle_ir_transmit_command(d,f,K)
if B.send_raw_cluster_command==nil then
return false
end
local w=K and K.body and K.body.zcl_header and K.body.zcl_header.cmd and K.body.zcl_header.cmd.value or nil
local v=K and K.body and K.body.zcl_body and K.body.zcl_body.body_bytes or nil
if type(w)~="number"or type(v)~="string"then
return false
end
if w==0 then
local o=s(v,1)local O=D(v,3)local aA=D(v,7)or 0
local am=s(v,11)or p
local aB=string.byte(v,13)or 0
local aD=string.byte(v,14)or 0
local aC=s(v,15)or 0
if o==nil or O==nil then
return false
end
d:set_field(i,"",{persist=false})d:set_field(m,O,{persist=false})B.send_raw_cluster_command(
d,g,1,string.char(0)..
encode_le16(o)..
encode_le32(O)..
encode_le32(aA)..
encode_le16(am)..
string.char(aB)..
string.char(aD)..
encode_le16(aC),k(f))P(d,f,o,0)return true
end
if w==2 then
local o=s(v,1)local e=D(v,3)local aj=string.byte(v,7)or Z
if o==nil or e==nil then
return false
end
return Y(d,f,o,e,aj)
end
if w==3 then
local o=s(v,2)local e=D(v,4)local T=string.byte(v,8)if o==nil or e==nil or T==nil then
return false
end
local part=v:sub(9,8+T)local ai=string.byte(v,9+T)or 0
if ac(part)~=ai then
aw.warn(string.format("IR chunk CRC mismatch seq=%s position=%s",tostring(o),tostring(e)))
end
local h=d:get_field(m)if type(h)~="number"then
h=e+#part
end
local ab=V(d,e,part,h)if e+#part<h then
P(d,f,o,e+#part)else
B.send_raw_cluster_command(
d,g,4,string.char(0)..encode_le16(o)..encode_le16(0),k(f))d:set_field(i,ab:sub(1,h),{persist=false})
end
return true
end
if w==4 then
local o=s(v,2)if o==nil then
return false
end
local at=B.send_raw_cluster_command(
d,g,5,encode_le16(o)..encode_le16(0),k(f))if at then
q(d)[o]=nil
end
return at
end
if w==5 then
local ar=d:get_field(i)or""
local j=ah(ar)d:set_field(z,j,{persist=false})d:set_field(i,nil,{persist=false})d:set_field(m,nil,{persist=false})J(d,j)B.stop_ir_learning(d,f)return true
end
return false
end
end
return ae
