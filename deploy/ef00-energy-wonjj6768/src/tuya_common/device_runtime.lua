local function bg(l,o)
local bl=o.log
local bc=o.BASIC_CLUSTER
local br=o.EPOCH_2000_OFFSET
local v=o.PERSIST_FALSE
local B=o.CONFIG_QUEUE_FIELD
local r=o.CONFIG_QUEUE_CALLBACK_FIELD
local w=o.QUERY_INTERVAL_TIMER_FIELD
local bv=o.QUERY_DATA
local bs=o.SET_TIME
local aN=o.CONNECTION_STATUS
local aU=o.REPORT_COMMANDS
local aO=require"st.zigbee.device_management"
local bu=o.string_byte
local bx=o.string_len
local d=o.type_check
local A=o.table_insert
local bi=o.table_remove
local aV=o.extract_payload
local aK=o.extract_command_id
local aG=o.extract_transaction
local at=o.prepare_mappings
local R=o.time_offset_for_start
local Y="magic_packet"
local af="query_state"
local ae="mcu_version"
local aD=o.MCU_VERSION_RESPONSE
local ar="bind_basic"
local X="config_queue"
local ag="query_timer"
local K="tuya_next_forced_time_update"
local ao=60*60
local s
local u
local Q
local F
local function n(aZ,ap,bn)
local q=aZ
if q==nil then
q=ap
end
if d(q)~="number"or q<0 then
bl.warn(string.format("Tuya %s expects non-negative number, got %s",bn,tostring(q)))return nil
end
return q
end
local function am(aZ,ap,bn)
local q=aZ
if q==nil then
q=ap
end
if d(q)~="number"or q<=0 then
bl.warn(string.format("Tuya %s expects positive number, got %s",bn,tostring(q)))return nil
end
return q
end
local function aw(b,aJ)
local h=b.bind_target_eui
if d(h)=="string"and h~=""then
return h
end
if d(aJ)=="table"and d(aJ.environment_info)=="table"then
local ac=aJ.environment_info.hub_zigbee_eui
if d(ac)=="string"and ac~=""then
return ac
end
end
return nil
end
local function al(b)
local bh={}local bq=d(b.named_mapping)=="table"and b.named_mapping or nil
if bq~=nil then
for bp,aZ in pairs(bq)do
bh[bp]=aZ
end
end
local bo={
"named_mappings","named_datapoints","named_key_field","named_mapping_values","named_mapping_names",}for _,bp in ipairs(bo)do
if b[bp]~=nil then
bh[bp]=b[bp]
end
end
return bh
end
local function ax(a,h)
if d(h)~="string"or h==""then
return false
end
local bm=aO.build_bind_request(a,bc,h)if bm==nil then
bl.warn("Tuya bind_basic_on_configure failed to build bind request")return false
end
a:send(bm)return true
end
local function ah(aY,aW)
if d(aY)~="table"or d(aW)~="table"then
return aY
end
for _,L in ipairs(aW)do
A(aY,L)
end
return aY
end
local function D(a,p,x,aA)
if p[aA+1]then
a.thread:call_with_delay(x,function()
u(a,p,x,aA+1)
end)
end
end
s=function(a,m,V,bj,aX)
if V=="off"then
return false
end
local aL=R(V)if aL~=0 then
return l.apply_time_request_with_offset(a,m,aL,bj,aX)
end
return l.apply_time_request(a,m,bj,aX)
end
u=function(a,p,x,bw)
local aA=bw or 1
local H=p[aA]if not H then
return false
end
if H.kind==Y then
l.send_magic_packet(a)elseif H.kind==af then
l.send_state_request(a,H.command_id)elseif H.kind==ae then
l.send_mcu_version_request(a)elseif H.kind==ar then
ax(a,H.bind_target_eui)elseif H.kind==X then
return l.start_config_queue(a,H.queue,{
on_complete=function(success)
if success then
D(a,p,x,aA)
end
end,
})elseif H.kind==ag then
l.start_query_timer(a,H.interval_seconds,H.command_id)
end
D(a,p,x,aA)return true
end
function l.apply_announce(a,b)
b=b or{}local bk=false
if d(b.announce_handler)=="function"then
bk=b.announce_handler(a,b)~=false
end
if not b.query_on_announce then
return bk
end
local be=n(b.announce_delay,0.5,"announce_delay")if be==nil then
return false
end
a.thread:call_with_delay(be,function()
l.send_state_request(a,b.query_command_id)
end)
return true
end
function l.stop_query_timer(a)
local aM=a:get_field(w)if aM and aM.cancel then
pcall(function()
aM:cancel()
end)
end
a:set_field(w,nil,v)return true
end
function l.start_query_timer(a,aS,k)
local ba=am(aS,nil,"query_interval_seconds")if ba==nil then
return false
end
l.stop_query_timer(a)local aM=nil
aM=a.thread:call_with_delay(ba,function()
l.send_state_request(a,k)l.start_query_timer(a,ba,k)
end)
a:set_field(w,aM,v)return true
end
function l.start_configuration(a,b,aJ)
b=b or{}local p={}local x=n(b.step_delay,1,"step_delay")local aq=n(b.initial_delay,0,"initial_delay")if x==nil or aq==nil then
return false
end
local e=al(b)local y=b.preference_map
local aT=d(b.preference_names)=="table"and b.preference_names or nil
local j=e.named_mappings
local G=d(e.named_mapping_values)=="table"and e.named_mapping_values or nil
local Z=d(e.named_mapping_names)=="table"and e.named_mapping_names or nil
local h=aw(b,aJ)local S={}if y==nil and b.preference_datapoints then
local t=b.preference_datapoints
if t==true then
t=b.datapoints
end
if t~=nil then
y=l.build_preference_map(
t,b.preference_key_field)
end
end
if y~=nil then
at(y)
end
if j==nil and e.named_datapoints then
local z=e.named_datapoints
if z==true then
z=b.datapoints
end
if z~=nil then
if e.named_key_field~=nil then
j=l.build_named_map(z,e.named_key_field)else
j=z
end
end
end
if j==nil and(G~=nil or Z~=nil)and b.datapoints~=nil then
if e.named_key_field~=nil then
j=l.build_named_map(b.datapoints,e.named_key_field)else
j=b.datapoints
end
end
if j~=nil then
at(j)
end
if b.magic_packet~=false then
A(p,{kind=Y})
end
if b.query_on_configure then
A(p,{
kind=af,command_id=b.query_command_id,})
end
if b.mcu_version_request_on_configure then
A(p,{kind=ae})
end
if b.bind_basic_on_configure then
if h~=nil then
A(p,{
kind=ar,bind_target_eui=h,})else
bl.warn("Tuya bind_basic_on_configure requires bind_target_eui or driver.environment_info.hub_zigbee_eui")
end
end
if y~=nil then
ah(
S,l.build_preference_config_queue(a,y,aT))
end
if j~=nil and G~=nil then
ah(
S,l.build_named_mapping_config_queue(a,j,G,Z))
end
if #S>0 then
A(p,{
kind=X,queue=S,})
end
if b.query_interval_seconds then
A(p,{
kind=ag,interval_seconds=b.query_interval_seconds,command_id=b.query_command_id,})
end
if #p==0 then
return false
end
if aq>0 then
a.thread:call_with_delay(aq,function()
u(a,p,x,1)
end)
return true
end
return u(a,p,x,1)
end
local function aH(a,m,c)
if type(c.time_handler)=="function"then
return c.time_handler(a,m,c)
end
if c.auto_time==false then
return false
end
local N=c.time_offset
if N then
return l.apply_time_request_with_offset(a,m,N,c.utc_time,c.local_time)
end
if c.time_start then
return s(a,m,c.time_start,c.utc_time,c.local_time)
end
return l.apply_time_request(a,m,c.utc_time,c.local_time)
end
local function O(a,m,c)
if c.auto_connection_status==false then
return false
end
return l.apply_connection_status_request(a,m,c.connection_status_bytes)
end
local function J(a,bt)
a:set_field(
K,(bt or os.time())+ao,v)
end
local function av(a,m,c)
if c.force_time_updates~=true or c.time_start=="off"then
return false
end
local bt=os.time()local aQ=a:get_field(K)if aQ~=nil and aQ>=bt then
return false
end
J(a,bt)
if type(c.time_handler)=="function"then
return c.time_handler(a,m,c)==true
end
local N=c.time_offset
if N~=nil then
return l.send_time_with_offset(
a,N,c.utc_time,c.local_time
)==true
end
local V=c.time_start
if V~=nil then
local aL=R(V)if aL~=0 then
return l.send_time_with_offset(
a,aL,c.utc_time,c.local_time
)==true
end
end
return l.send_time(a,c.utc_time,c.local_time)==true
end
local function aB(a,m,c,as,k)
local C=l.parse_datapoint_report(m)if not C then
bl.warn(string.format("Failed to parse Tuya report for command 0x%02X",k))return false
end
if c.config_queue~=false then
F(a,m,c.queue_delay,C)
end
for _,ab in ipairs(C.datapoints)do
if as then
l.apply_datapoint_mapping(a,ab,as,{
frame=C,endpoint=ab.endpoint or C.endpoint,})
end
end
return true
end
function l.apply_message(a,m,c)
c=c or{}local as=c.datapoints
local k=aK(m)if not k then
return false
end
local ak=av(a,m,c)if k==bs then
if ak then
return true
end
if aH(a,m,c)then
J(a)return true
end
end
if k==aN then
if ak then
return true
end
if O(a,m,c)then
return true
end
end
if k==aD and c.respond_to_mcu_version_response==true then
return l.send_mcu_version_request(a,l.DEFAULT_MCU_VERSION_TRANSACTION)~=nil
end
if aU[k]==true then
return aB(a,m,c,as,k)
end
return false
end
local function aI(aR,bf)
if aR==nil or bf==nil then
return false
end
if aR==bf then
return true
end
return(aR%256)==bf
end
local function aE(P,C)
local i={}if C and C.datapoints and #C.datapoints>0 then
for _,ab in ipairs(C.datapoints)do
i[ab.dp]=true
end
return i
end
if P then
local ab=l.parse_datapoint(P,3)if ab~=nil then
i[ab.dp]=true
end
end
return i
end
local function U(i,dp)
return dp~=nil and i[dp]==true
end
local function ai(f)
local g={}
local function ay(dp)
if d(dp)=="number"then
g[dp]=true
end
end
if f.response_dp~=nil then
ay(f.response_dp)return g
end
if d(f.response_dps)=="table"then
for _,dp in ipairs(f.response_dps)do
ay(dp)
end
if next(g)~=nil then
return g
end
end
if f.dp~=nil then
ay(f.dp)return g
end
if d(f.items)=="table"then
for _,L in ipairs(f.items)do
if d(L)=="table"then
ay(L.dp)
end
end
end
return g
end
local function W(f,i)
local g=f.expected_response_dps
if d(g)~="table"then
g=ai(f)f.expected_response_dps=g
end
if next(g)==nil then
return false
end
local M=f.matched_response_dps
if d(M)~="table"then
M={}f.matched_response_dps=M
end
local aP=false
for dp,_ in pairs(i)do
if U(g,dp)then
M[dp]=true
aP=true
end
end
if not aP then
return false
end
for dp,_ in pairs(g)do
if not U(M,dp)then
return false
end
end
return true
end
local function au(f,ad,P,C)
if f.match_response then
return f.match_response(ad,P,f,C)==true
end
if f.match_transaction and f.packet_id~=nil then
local aF=aG(ad)if not aI(f.packet_id,aF)then
return false
end
end
local i=aE(P,C)if next(i)==nil then
return f.match_transaction and f.packet_id~=nil
end
return W(f,i)
end
local function aj(a)
a:set_field(B,nil,v)a:set_field(r,nil,v)
end
local function az(b)
if d(b)=="function"then
return b
end
if d(b)=="table"and d(b.on_complete)=="function"then
return b.on_complete
end
return nil
end
local function I(a,success)
local aa=a:get_field(r)aj(a)
if d(aa)=="function"then
local ok,bz=pcall(aa,success==true)if not ok then
bl.warn(string.format("Tuya config queue callback failed: %s",tostring(bz)))
end
end
return success==true
end
local function E(a)
if Q(a)then
return true
end
return I(a,false)
end
function l.start_config_queue(a,T,b)
local aW=T or{}local aa=az(b)if #aW==0 then
aj(a)
if d(aa)=="function"then
pcall(aa,false)
end
return false
end
a:set_field(B,aW,v)a:set_field(r,aa,v)return E(a)
end
Q=function(a)
local T=a:get_field(B)if not T or #T==0 then
return false
end
local L=T[1]local k=L.command_id
if L.items then
local an=l.send_datapoints(a,L.items,k,L.transaction)if an~=nil then
L.packet_id=an
return true
end
return false
end
local an=l.send_datapoint(a,L.dp,L.datatype,L.value,k,L.signed,L.transaction)if an~=nil then
L.packet_id=an
return true
end
return false
end
F=function(a,ad,be,C)
local P=aV(ad)local T=a:get_field(B)if not P or not T or #T==0 then
return false
end
C=C or l.parse_datapoint_report(ad)local f=T[1]if not au(f,ad,P,C)then
return false
end
bi(T,1)if #T==0 then
return I(a,true)
end
local aC=n(be,0.5,"config_queue_delay")if aC==nil then
return I(a,false)
end
a.thread:call_with_delay(aC,function()
E(a)
end)
return true
end
end
return bg
