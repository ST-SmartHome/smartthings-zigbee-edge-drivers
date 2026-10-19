local function aU(n,f)
local bi=f.data_types
local aD=f.constants
local aG=f.zcl_messages
local ba=f.messages
local aX=f.generic_body
local v=f.log
local aB=f.TUYA_CLUSTER
local ax=f.TUYA_ENDPOINT_FIELD
local aA=f.MAGIC_PACKET_ATTRS
local aV=f.SET_DATA
local bh=f.QUERY_DATA
local aw=f.MCU_VERSION_REQUEST
local aq=f.SET_TIME
local aa=f.CONNECTION_STATUS
local S=f.DEFAULT_MCU_VERSION_TRANSACTION
local aH=f.DP_TYPE_RAW
local ay=f.DP_TYPE_BOOL
local av=f.DP_TYPE_VALUE
local an=f.DP_TYPE_STRING
local az=f.DP_TYPE_ENUM
local am=f.DP_TYPE_BITMAP
local d=f.string_byte
local W=f.string_char
local string_pack=f.string_pack
local aK=f.string_sub
local h=f.string_len
local T=f.math_floor
local b=f.type_check
local aF=f.table_insert
local bg=f.os_time
local aN=f.next_packet_id
local ag=f.resolve_cluster_endpoint
local D=f.extract_payload
local C=f.extract_command_id
local ai=f.extract_source_endpoint
local M=f.build_basic_read_attributes_message
local Y=f.raw_bytes
local be=f.pack_bitmap
local ap=f.normalize_transaction
local P={
[0]="not_set",[1]="over_current_threshold",[3]="over_voltage_threshold",}local J={
[0]="OFF",[1]="ON",}local al
local m
local aR
local ab
local aI
local A
local K
local B
local function aM(e)
return b(e)=="number"and e>=0 and e<=255 and e%1==0
end
local function y(e,bv)
if b(e)~="number"then
v.warn(string.format("Tuya %s expects number, got %s",bv,b(e)))return nil
end
local E=T(e)if E~=e or E<0 or E>0xFFFFFFFF then
v.warn(string.format("Tuya %s expects integer in range 0..0xFFFFFFFF, got %s",bv,tostring(e)))return nil
end
return E
end
local function p(e,bt)
if e==nil then
return bt
end
return e
end
al=function(e)
local bf=Y(e)if bf~=nil then
return bf
end
v.warn(string.format("Tuya bytes expects string or byte array, got %s",b(e)))return nil
end
function n.parse_phase_variant1(e,phase)
local c=Y(e)if c==nil or h(c)<15 then
v.warn("Tuya phase_variant1 expects at least 15 bytes")return nil
end
local R=m(c,14,2)/10
local Q=m(c,12,2)/1000
if b(phase)=="string"and phase~=""then
return{
["voltage_"..phase]=R,["current_"..phase]=Q,}
end
return{
voltage=R,current=Q,}
end
function n.parse_phase_variant2(e,phase,bb)
local c=Y(e)if c==nil or h(c)<8 then
v.warn("Tuya phase_variant2 expects at least 8 bytes")return nil
end
local R=m(c,1,2)/10
local Q=m(c,4,2)/1000
local ak=m(c,7,2)if bb and ak>32767 then
ak=(39322-ak)*-1
end
if b(phase)=="string"and phase~=""then
return{
["voltage_"..phase]=R,["current_"..phase]=Q,["power_"..phase]=ak,}
end
return{
voltage=R,current=Q,power=ak,}
end
function n.parse_phase_variant3(e,phase)
local c=Y(e)if c==nil or h(c)<8 then
v.warn("Tuya phase_variant3 expects at least 8 bytes")return nil
end
local R=m(c,1,2)/10
local Q=m(c,3,3)/1000
local ak=m(c,6,3)if b(phase)=="string"and phase~=""then
return{
["voltage_"..phase]=R,["current_"..phase]=Q,["power_"..phase]=ak,}
end
return{
voltage=R,current=Q,power=ak,}
end
function n.parse_threshold(e)
local c=Y(e)if c==nil or h(c)<8 then
v.warn("Tuya threshold expects at least 8 bytes")return nil
end
return{
threshold_1_protection=J[d(c,2)],threshold_1=P[d(c,1)],threshold_1_value=m(c,3,2),threshold_2_protection=J[d(c,6)],threshold_2=P[d(c,5)],threshold_2_value=m(c,7,2),}
end
function n.send_magic_packet(j)
local q=M(j,aA)if not q then
return false
end
j:send(q)return true
end
m=function(c,bo,aY)
if b(c)~="string"then
v.warn(string.format("Tuya parse_uint expects string, got %s",b(c)))return nil
end
local k=p(bo,1)local L=aY
if b(k)~="number"or k%1~=0 or k<1 then
v.warn(string.format("Tuya parse_uint expects positive integer offset, got %s",tostring(k)))return nil
end
if L==nil then
L=h(c)-k+1
end
if b(L)~="number"or L%1~=0 or L<1 then
v.warn(string.format("Tuya parse_uint expects positive integer length, got %s",tostring(L)))return nil
end
if k+L-1>h(c)then
v.warn(string.format("Tuya parse_uint out of range: offset=%d len=%d buffer_len=%d",k,L,h(c)))return nil
end
if L==1 then
return d(c,k)elseif L==2 then
return(d(c,k)*256)+d(c,k+1)elseif L==4 then
return(d(c,k)*16777216)+
(d(c,k+1)*65536)+
(d(c,k+2)*256)+
d(c,k+3)
end
local e=0
for i=0,L-1 do
e=e*256+d(c,k+i)
end
return e
end
aR=function(c,bo,aY)
if b(c)~="string"then
v.warn(string.format("Tuya parse_int expects string, got %s",b(c)))return nil
end
local k=p(bo,1)local L=aY
if L==nil then
if b(k)~="number"or k%1~=0 then
v.warn(string.format("Tuya parse_int expects integer offset, got %s",tostring(k)))return nil
end
L=h(c)-k+1
end
local at=m(c,k,L)if at==nil then
return nil
end
local aQ=2 ^(L*8)local bu=aQ/2
if at>=bu then
return at-aQ
end
return at
end
ab=function(g,e,aE)
if g==ay then
if e==true or e==1 then
return W(1)
end
if e==false or e==0 then
return W(0)
end
v.warn(string.format("Tuya BOOL expects boolean or 0/1, got %s",tostring(e)))return nil
end
if g==av then
if b(e)~="number"then
v.warn(string.format("Tuya VALUE expects number, got %s",b(e)))return nil
end
local u=T(e+0.5)if aE then
if u<-0x80000000 then u=-0x80000000 end
if u>0x7FFFFFFF then u=0x7FFFFFFF end
if u<0 then
u=u+4294967296
end
else
if u<0 then u=0 end
if u>0xFFFFFFFF then u=0xFFFFFFFF end
end
return string_pack(">I4",u)
end
if g==az then
if b(e)~="number"then
v.warn(string.format("Tuya ENUM expects number, got %s",b(e)))return nil
end
local ad=T(e)if ad~=e or ad<0 or ad>255 then
v.warn(string.format("Tuya ENUM expects byte integer, got %s",tostring(e)))return nil
end
return W(ad)
end
if g==am then
if b(e)=="number"then
local br=be(e)if br~=nil then
return br
end
v.warn(string.format("Tuya BITMAP expects non-negative integer up to 0xFFFFFFFF, got %s",tostring(e)))return nil
end
if b(e)=="string"then
return e
end
v.warn(string.format("Tuya BITMAP expects number or string, got %s",b(e)))return nil
end
if g==aH then
local aS=al(e)if aS==nil then
return nil
end
return aS
end
if g==an then
if b(e)~="string"then
v.warn(string.format("Tuya type %d expects string, got %s",g,b(e)))return nil
end
return e
end
v.warn(string.format("Unsupported Tuya datatype: %d",g))return nil
end
aI=function(g,value_bytes)
if b(value_bytes)~="string"then
return nil
end
if g==ay then
local ar=d(value_bytes,1)if ar==0 then
return false
end
if ar==1 then
return true
end
v.warn(string.format("Tuya BOOL payload expects 0x00 or 0x01, got %s",tostring(ar)))return nil
elseif g==av then
return m(value_bytes)elseif g==az then
return d(value_bytes,1)elseif g==am then
return m(value_bytes)elseif g==aH or g==an then
return value_bytes
end
return nil
end
function n.build_datapoint(dp,g,e,aE)
if not aM(dp)or not aM(g)then
v.warn(string.format("Tuya datapoint expects byte dp/datatype, got dp=%s datatype=%s",tostring(dp),tostring(g)))return nil
end
local value_bytes=ab(g,e,aE)if not value_bytes then
return nil
end
local ah=h(value_bytes)if ah>65535 then
v.warn(string.format("Tuya datapoint value too long: %d",ah))return nil
end
return W(dp,g)..string_pack(">I2",ah)..value_bytes
end
function n.build_datapoints(bn)
local bw={}for _,bm in ipairs(bn or{})do
local a=n.build_datapoint(bm.dp,bm.datatype,bm.value,bm.signed)if not a then
return nil
end
aF(bw,a)
end
return table.concat(bw)
end
local function O(j,r)
local E=ap(r)if r~=nil and E==nil then
v.warn(string.format("Tuya transaction expects number, got %s",b(r)))return nil
end
if E~=nil then
return E
end
return aN(j)
end
function n.send_raw(j,x,a)
if not aM(x)then
v.warn(string.format("Tuya command id expects byte value, got %s",tostring(x)))return false
end
if a==nil then
a=""
end
if b(a)~="string"then
v.warn(string.format("Tuya raw payload expects string, got %s",b(a)))return false
end
local aW=ag(j,aB,ax)if not aW then
v.warn("Tuya cluster endpoint not found")return false
end
local au=aG.ZclHeader({cmd=bi.ZCLCommandId(x)})au.frame_ctrl:set_cluster_specific()au.frame_ctrl:set_disable_default_response()local aL=ba.AddressHeader(
aD.HUB.ADDR,aD.HUB.ENDPOINT,j:get_short_address(),aW,aD.HA_PROFILE_ID,aB)local aZ=aG.ZclMessageBody({
zcl_header=au,zcl_body=aX.GenericBody(a)})j:send(ba.ZigbeeMessageTx({
address_header=aL,body=aZ}))return true
end
function n.send_datapoint(j,dp,g,e,x,aE,r)
local dp_payload=n.build_datapoint(dp,g,e,aE)if not dp_payload then
return nil
end
local w=O(j,r)if w==nil then
return nil
end
local aC=x
if aC==nil then
aC=aV
end
if not n.send_raw(j,aC,string_pack(">I2",w)..dp_payload)then
return nil
end
return w
end
function n.send_datapoints(j,bn,x,r)
local dps_payload=n.build_datapoints(bn)if not dps_payload then
return nil
end
local w=O(j,r)if w==nil then
return nil
end
local aC=x
if aC==nil then
aC=aV
end
if not n.send_raw(j,aC,string_pack(">I2",w)..dps_payload)then
return nil
end
return w
end
function n.send_state_request(j,x)
local aC=x
if aC==nil then
aC=bh
end
return n.send_raw(j,aC,"")
end
function n.send_mcu_version_request(j,r)
local H=r
if H==nil then
H=S
end
local w=O(j,H)if w==nil then
return nil
end
if not n.send_raw(j,aw,string_pack(">I2",w))then
return nil
end
return w
end
A=function(t)
local status=t==nil and"\x01"or al(t)if status==nil then
return nil
end
if h(status)~=1 then
v.warn(string.format("Tuya connection status expects exactly one status byte, got %d",h(status)))return nil
end
return string_pack("<I2",1)..status
end
function n.send_connection_status(j,r,t)
local a=A(t)if a==nil then
return false
end
return n.send_raw(j,aa,a)
end
K=function(z,s)
local Z=y(p(z,bg()),"utc_time")if Z==nil then
return nil
end
local V=y(p(s,Z),"local_time")if V==nil then
return nil
end
local time_bytes=string_pack(">I4I4",Z,V)return string_pack("<I2",h(time_bytes))..time_bytes
end
B=function(I,z,s)
local k=y(p(I,0),"time_offset")if k==nil then
return nil
end
local ae=y(p(z,bg()),"utc_time")if ae==nil or ae<k then
v.warn(string.format("Tuya time offset underflow: utc=%s offset=%s",tostring(ae),tostring(k)))return nil
end
local ac=y(p(s,ae),"local_time")if ac==nil or ac<k then
v.warn(string.format("Tuya time offset underflow: local=%s offset=%s",tostring(ac),tostring(k)))return nil
end
local Z=ae-k
local V=ac-k
return K(Z,V)
end
function n.send_time(j,z,s)
local a=K(z,s)if a==nil then
return false
end
return n.send_raw(j,aq,a)
end
function n.send_time_with_offset(j,I,z,s)
local a=B(I,z,s)if a==nil then
return false
end
return n.send_raw(j,aq,a)
end
function n.apply_time_request(j,q,z,s)
if C(q)~=aq then
return false
end
return n.send_time(j,z,s)==true
end
function n.apply_time_request_with_offset(j,q,I,z,s)
if C(q)~=aq then
return false
end
return n.send_time_with_offset(j,I,z,s)==true
end
function n.apply_connection_status_request(j,q,t)
if C(q)~=aa then
return false
end
local bA=n.parse_connection_status(q)if bA==nil then
return false
end
return n.send_connection_status(j,nil,t)==true
end
function n.parse_connection_status(q)
local a=D(q)if not a or h(a)<2 then
return nil
end
local U=d(a,1)+d(a,2)*256
local bq=h(a)-2
local t=""
if bq>0 and U>0 then
t=aK(a,3,math.min(h(a),U+2))
end
return{
payload_size=U,status_length=U,status_bytes=t,payload=a,}
end
function n.parse_mcu_version_response(q)
local a=D(q)if not a or h(a)<3 then
return nil
end
local aO=d(a,1)local aP=d(a,2)local X=d(a,3)local by=T(X/64)local bz=T((X%64)/16)local bx=X%16
return{
transaction_hi=aO,transaction_lo=aP,version_raw=X,version=string.format("%d.%d.%d",by,bz,bx),payload=a,}
end
function n.parse_datapoint(c,bl)
local a=D(c)local o=p(bl,3)if not a then
return nil
end
if b(o)~="number"or o%1~=0 or o<1 then
v.warn(string.format("Tuya parse_datapoint expects positive integer index, got %s",tostring(o)))return nil
end
local F=h(a)if F<o+3 then
if F>=o then
v.warn(string.format(
"Tuya DP header truncated at index %d (payload_len=%d)",o,F))
end
return nil
end
local dp=d(a,o)local g=d(a,o+1)local aY=(d(a,o+2)*256)+d(a,o+3)local aJ=o+4
local as=aJ+aY
if as-1>F then
v.warn(string.format(
"Tuya DP payload truncated: dp=%d datatype=%d len=%d index=%d payload_len=%d",dp,g,aY,o,F))return nil
end
local value_bytes=aK(a,aJ,as-1)local aT=aI(g,value_bytes)return{
dp=dp,datatype=g,length=aY,value_bytes=value_bytes,value=aT,int_value=m(value_bytes),signed_value=aR(value_bytes),next_index=as,}
end
function n.parse_datapoints(c,bl)
local a=D(c)if a==nil then
return nil
end
local af=p(bl,3)if b(af)~="number"or af%1~=0 or af<1 then
v.warn(string.format("Tuya parse_datapoints expects positive integer index, got %s",tostring(af)))return nil
end
local F=h(a)local N={}while af<=F do
local ao=n.parse_datapoint(a,af)if not ao then
return nil
end
aF(N,ao)af=ao.next_index
end
return N
end
function n.parse_datapoint_report(q)
local a=D(q)if not a then
return nil
end
if h(a)<2 then
v.warn(string.format("Tuya report too short (payload_len=%d)",h(a)))return nil
end
local bk={
command_id=C(q),endpoint=ai(q),status=d(a,1),transaction=d(a,2),payload=a,datapoints={},}local N=n.parse_datapoints(a,3)if N==nil then
return nil
end
for _,ao in ipairs(N)do
ao.endpoint=bk.endpoint
end
bk.datapoints=N
return bk
end
end
return aU
