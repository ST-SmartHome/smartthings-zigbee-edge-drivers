local function aj(j)
local o,x=require"zcl_common.attribute_reader"(j)local am=require"st.zigbee.cluster_base"
local q=require"st.zigbee.data_types"
local aA=require"st.zigbee.messages"
local B=require"st.zigbee.constants"
local O=require"st.zigbee.zcl.clusters"
local aq=require"st.zigbee.zcl"
local aJ=require"st.zigbee.zcl.frame_ctrl"
local az=require"st.zigbee.generic_body"
local ai=require"log"
local T="__default"
local D={}
local function s(
b,h,p,H,f,G,A,w)local L=aJ(0)L:set_cluster_specific()if G=="client"then
L:set_direction_client()
end
if A~=nil then
L:set_mfg_specific()
end
if w then
L:set_disable_default_response()
end
local at={
cmd=q.ZCLCommandId(p),frame_ctrl=L,}if A~=nil then
at.mfg_code=q.Uint16(A)
end
return o(
b,aA.ZigbeeMessageTx({
address_header=aA.AddressHeader(
B.HUB.ADDR,B.HUB.ENDPOINT,b:get_short_address(),b:get_endpoint(h),B.HA_PROFILE_ID,h),body=aq.ZclMessageBody({
zcl_header=aq.ZclHeader(at),zcl_body=az.GenericBody(H or""),}),}),f)
end
local function m(b,h,p,H,f,G)
return s(b,h,p,H,f,G,nil)
end
local function J(b,h,p,A,H,f,G)
return s(b,h,p,H,f,G,A)
end
local function N(b,h,t,value,i,f)
return o(
b,am.write_attribute(
b,q.ClusterId(h),q.AttributeId(t),i(value)),f)
end
local function E(b,h,t,A,value,i,f)
return o(
b,am.write_manufacturer_specific_attribute(
b,h,t,A,i,value),f)
end
local function v(b,k,value,f)
return o(b,k:write(b,k(value)),f)
end
local function r(value,aL,aK)
return math.max(aL,math.min(aK,math.floor(value)))
end
local function encode_uint16_le(value)
return string.char(bit32.band(value,255))..string.char(bit32.rshift(bit32.band(value,65280),8))
end
local function Q(c,i,d)
if type(c)~="number"or type(i)~="table"then
return c
end
local aQ={
Uint8={0,255},Uint16={0,65535},Uint24={0,0xFFFFFF},Uint32={0,0xFFFFFFFF},Int8={-128,127},Int16={-32768,32767},Int24={-8388608,8388607},Int32={-0x80000000,0x7FFFFFFF},Enum8={0,255},}local aH=aQ[i.NAME]if aH==nil then
return c
end
local au=math.max(aH[1],math.min(aH[2],math.floor(c+0.5)))if au~=c then
ai.warn(string.format(
"ZCL write value clamped for cluster 0x%04X attribute 0x%04X name '%s': %s -> %s",d and d.cluster_id or 0,d and d.attribute_id or 0,tostring(d and d.name or"unknown"),tostring(c),tostring(au)))
end
return au
end
local function ad(i)
return type(i)=="table"and i.NAME or nil
end
local function C(i)
local an=ad(i)if type(an)~="string"then
return false
end
return an:match("^Uint")~=nil or an:match("^Int")~=nil or an:match("^Enum")~=nil
end
local function I(d)
if type(d)~="table"then
return false
end
if d.prefer_plain_attribute_write==true then
return true
end
if d.mfg_code~=nil then
return true
end
if type(d.attribute_id)=="number"and d.attribute_id>=32768 then
return true
end
return false
end
local function ao(d,ay)
if d.write_type~=nil then
return d.write_type
end
if d.attribute_def~=nil and d.attribute_def.base_type~=nil then
return d.attribute_def.base_type
end
if type(ay)=="boolean"then
return q.Boolean
end
return nil
end
local function af(b,e,value,a,d)
local c=value
if d.to_device~=nil then
c=d.to_device(value,b,a,e)
end
if type(c)=="string"and type(e)=="table"then
local u=type(e.converter)=="table"and e.converter or nil
local U=u and type(u.to)=="function"and u.to or nil
if U~=nil then
local Y=U(c,b,a,e)if Y~=nil then
c=Y
end
end
end
if c==nil then
return nil
end
if type(c)=="number"and type(d.scale)=="number"and d.scale~=0 and d.scale~=1 then
c=math.floor(c*d.scale)
end
return c
end
local function R(b,c,e,a,d)
local i=d and d.write_type or nil
local ax=ad(i)if ax==nil or not tostring(ax):match("^Enum")then
return c
end
if type(c)=="number"then
return c
end
local ab=type(a)=="table"and a.raw_value or c
local u=type(e)=="table"and type(e.converter)=="table"and e.converter or nil
local F=u and type(u.to)=="function"and u.to or nil
if F~=nil then
local aw=F(ab,b,a,e)if type(aw)=="number"then
return aw
end
end
local aE=tonumber(c)if type(aE)=="number"then
return aE
end
ai.warn(string.format(
"ZCL enum write conversion failed for cluster 0x%04X attribute 0x%04X name '%s': raw=%s encoded=%s",d and d.cluster_id or 0,d and d.attribute_id or 0,tostring(d and d.name or"unknown"),tostring(ab),tostring(c)))return nil
end
local function S(b,e,a,d,c)
if type(e)~="table"then
return c
end
local u=type(e.converter)=="table"and e.converter or nil
local F=u and type(u.to)=="function"and u.to or nil
if F==nil then
return c
end
local ab=type(a)=="table"and a.raw_value or c
local aG=F(ab,b,a,e)if aG~=nil then
return aG
end
return c
end
local function l(b,e,value,a)
local d=j.mapping_meta(e)if d==nil then
return nil
end
local c=value
if d.to_device~=nil then
c=d.to_device(value,b,a,e)
end
return c
end
local function ae(c)
if c==nil then
return{}
end
if type(c)=="table"and c[1]~=nil then
return c
end
return{c}
end
local function ag(b,e,value,W)
local d=j.mapping_meta(e)if d==nil or d.tx_command_id==nil or d.cluster_id==nil then
return false
end
local a=x(b,e,W,value)local c=l(b,e,value,a)local y=nil
if d.tx_command_direction=="client"then
y=j.get_generated_client_command and
j.get_generated_client_command(d.cluster_id,d.tx_command_id)or nil
else
y=j.get_generated_server_command and
j.get_generated_server_command(d.cluster_id,d.tx_command_id)or nil
end
if y~=nil and type(c)~="string"then
return o(b,y(b,table.unpack(ae(c))),a.endpoint)
end
if type(c)~="string"and c~=nil then
ai.warn(string.format(
"ZCL generic command fallback requires string payload for cluster 0x%04X command 0x%02X name '%s'",d.cluster_id,d.tx_command_id,tostring(d.name)))return false
end
if d.mfg_code~=nil then
return J(
b,d.cluster_id,d.tx_command_id,d.mfg_code,c or"",a.endpoint,d.tx_command_direction)
end
return m(
b,d.cluster_id,d.tx_command_id,c or"",a.endpoint,d.tx_command_direction)
end
local function al(b,e,value,W)
local d=j.mapping_meta(e)if d==nil then
return false
end
local a=x(b,e,W,value)a.raw_value=value
local c=af(b,e,value,a,d)if c==nil then
return false
end
local i=ao(d,c)if i==nil then
ai.warn(string.format(
"ZCL write requires explicit write_type/data_type for cluster 0x%04X attribute 0x%04X name '%s'",d.cluster_id or 0,d.attribute_id or 0,tostring(d.name)))return false
end
if type(c)~="number"then
c=S(b,e,a,d,c)
end
c=R(b,c,e,a,d)if c==nil then
return false
end
if type(c)=="number"and C(i)then
c=math.floor(c+0.5)
end
if type(c)=="string"and C(i)then
ai.warn(string.format(
"ZCL write aborted because encoded value is still non-numeric for cluster 0x%04X attribute 0x%04X name '%s': %s",d.cluster_id or 0,d.attribute_id or 0,tostring(d.name),tostring(c)))return false
end
c=Q(c,i,d)a.encoded_value=c
if d.mfg_code~=nil then
local ok,V=pcall(
E,b,d.cluster_id,d.attribute_id,d.mfg_code,c,i,a.endpoint)if ok then
return V
end
ai.error(string.format(
"ZCL manufacturer write failed for cluster 0x%04X attribute 0x%04X name '%s': %s",d.cluster_id or 0,d.attribute_id or 0,tostring(d.name),tostring(V)))return false
end
if not I(d)and d.attribute_def~=nil and type(d.attribute_def.write)=="function"then
local ok,V=pcall(v,b,d.attribute_def,c,a.endpoint)if ok then
return V
end
ai.error(string.format(
"ZCL generated write failed for cluster 0x%04X attribute 0x%04X name '%s': %s",d.cluster_id or 0,d.attribute_id or 0,tostring(d.name),tostring(V)))return false
end
local ok,V=pcall(
N,b,d.cluster_id,d.attribute_id,c,i,a.endpoint)if ok then
return V
end
ai.error(string.format(
"ZCL write failed for cluster 0x%04X attribute 0x%04X name '%s': %s",d.cluster_id or 0,d.attribute_id or 0,tostring(d.name),tostring(V)))return false
end
local function z(b,aR)
if type(b)~="table"or
type(b.get_profile_id)~="function"or
b:get_profile_id()~=B.ZLL_PROFILE_ID or
type(b.thread)~="table"or
type(b.thread.call_with_delay)~="function"or
type(b.refresh)~="function"then
return
end
b.thread:call_with_delay(2,function()
b:refresh()
end,aR)
end
local function aC(b,ar,a)
local X=type(a)=="table"and a.component_id or nil
local f=type(a)=="table"and a.endpoint or nil
local aF=ar and
O.OnOff.server.commands.On(b)or
O.OnOff.server.commands.Off(b)
if type(X)=="string"and X~=""and type(b.send_to_component)=="function"then
b:send_to_component(X,aF)z(b,ar and"on delayed read"or"off delayed read")return true
end
if o(b,aF,f)then
z(b,ar and"on delayed read"or"off delayed read")return true
end
return m(b,j.CLUSTER_ON_OFF,ar and 1 or 0,"",f)
end
local function aI(b,aN,ac,f)
local n=j.get_generated_server_command and
j.get_generated_server_command(j.CLUSTER_LEVEL_CONTROL,4)or nil
if n~=nil then
return o(
b,n(
b,q.Uint8(r(aN,0,254)),q.Uint16(r(ac or 0,0,65535)),0,0),f)
end
local H=string.char(r(aN,0,254))..encode_uint16_le(r(ac or 0,0,65535))return m(b,j.CLUSTER_LEVEL_CONTROL,4,H,f)
end
local function ak(b,M,f)
local n=j.get_generated_server_command and
j.get_generated_server_command(j.CLUSTER_WINDOW_COVERING,5)or nil
if n~=nil then
return o(
b,n(b,q.Uint8(r(M,0,100))),f)
end
return m(
b,j.CLUSTER_WINDOW_COVERING,5,string.char(r(M,0,100)),f)
end
local function as(b,M,f)
local n=j.get_generated_server_command and
j.get_generated_server_command(j.CLUSTER_WINDOW_COVERING,8)or nil
if n~=nil then
return o(
b,n(b,q.Uint8(r(M,0,100))),f)
end
return m(
b,j.CLUSTER_WINDOW_COVERING,8,string.char(r(M,0,100)),f)
end
local function ap(b,aD,f)
local aB={
open=0,close=1,stop=2,}local p=aB[aD]if p==nil then
ai.warn(string.format("ZCL unknown cover command: %s",tostring(aD)))return false
end
local n=j.get_generated_server_command and
j.get_generated_server_command(j.CLUSTER_WINDOW_COVERING,p)or nil
if n~=nil then
return o(b,n(b),f)
end
return m(b,j.CLUSTER_WINDOW_COVERING,p,"",f)
end
function j.send_raw_cluster_command(
b,h,p,H,f,G,A,w)return s(
b,h,p,H,f,G,A,w)
end
local function Z(b,P,f)
local k=j.get_generated_attribute and
j.get_generated_attribute(j.CLUSTER_THERMOSTAT,j.ATTR_OCCUPIED_HEATING_SETPOINT)or nil
if k~=nil and type(k.write)=="function"then
return v(b,k,math.floor(P*100),f)
end
return N(
b,j.CLUSTER_THERMOSTAT,j.ATTR_OCCUPIED_HEATING_SETPOINT,math.floor(P*100),q.Int16,f)
end
local function ah(b,aO,f)
local k=j.get_generated_attribute and
j.get_generated_attribute(j.CLUSTER_THERMOSTAT,j.ATTR_SYSTEM_MODE)or nil
if k~=nil and type(k.write)=="function"then
return v(b,k,aO,f)
end
return N(
b,j.CLUSTER_THERMOSTAT,j.ATTR_SYSTEM_MODE,aO,q.Enum8,f)
end
function j.register_sender(h,t,aa)
if h==nil or type(aa)~="function"then
ai.warn(string.format(
"skip invalid zcl sender registration cluster=%s attribute=%s sender=%s",tostring(h),tostring(t),type(aa)))return nil
end
D[h]=D[h]or{}D[h][t or T]=aa
return aa
end
function j.get_sender(h,t)
local K=D[h]if K==nil then
return nil
end
return K[t]or K[T]
end
local function av(e)
return j.get_sender(e.cluster_id,e.attribute_id)
end
j.register_sender(j.CLUSTER_ON_OFF,j.ATTR_ON_OFF,function(b,e,value,a)
return aC(b,value==true or value=="on"or value=="open",a)
end)
j.register_sender(j.CLUSTER_LEVEL_CONTROL,j.ATTR_LEVEL_CURRENT_LEVEL,function(b,e,value,a)
local c=l(b,e,value,a)if type(c)~="number"then
return false
end
return aI(b,c,nil,a.endpoint)
end)
j.register_sender(j.CLUSTER_WINDOW_COVERING,nil,function(b,e,value,a)
if type(value)=="string"then
return ap(b,value,a.endpoint)
end
local c=l(b,e,value,a)if type(c)=="number"then
return ak(b,c,a.endpoint)
end
return false
end)
j.register_sender(j.CLUSTER_WINDOW_COVERING,j.ATTR_CURRENT_POSITION_TILT_PERCENTAGE,function(b,e,value,a)
local c=l(b,e,value,a)if type(c)=="number"then
return as(b,c,a.endpoint)
end
return false
end)
j.register_sender(j.CLUSTER_THERMOSTAT,j.ATTR_OCCUPIED_HEATING_SETPOINT,function(b,e,value,a)
local c=l(b,e,value,a)if type(c)~="number"then
return false
end
return Z(b,c,a.endpoint)
end)
j.register_sender(j.CLUSTER_THERMOSTAT,j.ATTR_SYSTEM_MODE,function(b,e,value,a)
local c=l(b,e,value,a)if c==nil then
return false
end
return ah(b,c,a.endpoint)
end)
function j.send_named_command(b,O,an,value,W)
local e=j.find_mapping_by_name(O,an,b,W)if e==nil then
return false
end
local d=j.mapping_meta(e)if d==nil then
return false
end
if d.read_only then
ai.warn(string.format("ZCL send_named_command: mapping '%s' is read-only",tostring(an)))return false
end
local a=j.build_mapping_context(b,e,W,value)a.raw_value=value
if d.sender~=nil then
return d.sender(b,e,value,a)~=false
end
local aa=av(e)if aa~=nil then
return aa(b,e,value,a)
end
if d.tx_command_id~=nil then
return ag(b,e,value,a)
end
if d.cluster_id==nil or d.attribute_id==nil then
return false
end
if al(b,e,value,a)then
return true
end
ai.warn(string.format(
"ZCL send_named_command: no sender for cluster 0x%04X attribute 0x%04X name '%s'",d.cluster_id,d.attribute_id,tostring(an)))return false
end
end
return aj
