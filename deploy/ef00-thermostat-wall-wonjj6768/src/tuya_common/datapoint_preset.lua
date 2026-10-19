local function au(q,aD,bs)
bs=bs or{switch=function()return nil end}
local d=aD.type_check
local M=aD.table_insert
local aT=aD.tonumber_check
local k=aD.merge_options
local bm=aD.copy_keys
local u=q.converter
local function ar(Z,J)
if d(Z)~="table"or d(J)~="table"then
return Z
end
for at,Q in pairs(J)do
if Z[at]==nil then
Z[at]=Q
end
end
return Z
end
local function e(c,b,g)
local a={}if d(c)=="string"then
a.name=c
else
k(a,c)
end
k(a,b)if a.name==nil and g~=nil then
a.name=g
end
return a
end
local ao={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function an(b)
if d(b)~="table"then
return false
end
for _,at in ipairs(ao)do
if b[at]~=nil then
return true
end
end
return false
end
local function U(bh,b)
if an(b)then
return bh
end
return q.apply_fixed_send_policy(bh)
end
local function h(s,g,c,b)
local a=e(c,b,g)local x=a.scale
if x==nil then
x=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and x~=1 then
a.converter=u.divide_by_pair(x)
end
a.scale=nil
return q.dp_numeric(s,a)
end
local function l(s,g,B,c,b)
local a=e(c,b,g)local x=a.scale
if x==nil then
x=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and x~=1 then
a.converter=u.divide_by_pair(x)
end
a.scale=nil
return q.dp_numeric(s,a)
end
local function ad(s,g,B,c,b)
local a=e(c,b,g)local x=a.scale
if x==nil then
x=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local aq=u.power()local bf=aq.from
if x~=1 then
a.from_device=u.pipe(
bf,u.divide_by(x))else
a.converter=aq
end
end
a.scale=nil
return q.dp_numeric(s,a)
end
local function ac(s,g,B,c,b)
local a=e(c,b,g)local x=a.scale
if x==nil then
x=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=u.signed_number_pair(x)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return q.dp_numeric(s,a)
end
local function aI(s,g,B,bc,c,b)
local a=e(c,b,g)local x=a.scale
if x==nil then
x=B
end
local br=
a.datatype==q.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aG={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ar(aG,bc)a.converter=u.raw_uint_be(x,aG)if a.datatype==nil then
a.datatype=q.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and x~=1 then
a.converter=u.divide_by_pair(x)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return q.dp_numeric(s,a)
end
local function W(Q,bp,bo)
local aC=aT(Q)if aC==nil then
return nil
end
return bp+bo-aC
end
local function aV(s,g,J,c,b)
local a=e(c,b,g)local ah=a.raw_min
if ah==nil then
ah=J.raw_min
end
local ag=a.raw_max
if ag==nil then
ag=J.raw_max
end
local H=a.value_min
if H==nil then
H=J.value_min
end
local G=a.value_max
if G==nil then
G=J.value_max
end
local bv=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bv then
local bj=u.scale(ah,ag,H,G)local bt=u.scale(H,G,ah,ag)a.converter=u.from_to(
function(Q,aY,aQ)
local bq=bj(Q,aY,aQ)if bq==nil then
return nil
end
return W(bq,H,G)
end,
function(Q,aY,aQ)
local ba=W(Q,H,G)if ba==nil then
return nil
end
return bt(ba,aY,aQ)
end
)elseif ah~=H or ag~=G then
a.converter=u.scale_pair(ah,ag,H,G)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return q.dp_numeric(s,a)
end
local function bk(phase,aZ)
if d(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,at in ipairs(bx or{})do
local aJ=at
if d(phase)=="string"and phase~=""then
aJ=at.."_"..phase
end
bn[aJ]=true
end
return bn
end
local function bd(s,g,aS,bi,c,b)
local aX=
d(c)=="string"or
(d(c)=="table"and c.name~=nil)or
(d(b)=="table"and b.name~=nil)local a=e(c,b,g)local phase=a.phase
if not aX and a.name==g then
a.name=bk(phase,g)
end
if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=aS(a)
end
if a.field==nil and a.fields==nil then
a.fields=bb(bi,phase)
end
return q.dp_raw(s,a)
end
local function be(s,c,b)
local a=e(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=u.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return q.dp_raw(s,a)
end
local function ap(o)
if d(o)=="number"and o%1==0 and o>=0 then
return{o}
end
if d(o)~="table"then
return{}
end
local aK={}for _,s in ipairs(o)do
if d(s)=="number"and s%1==0 and s>=0 then
M(aK,s)
end
end
return aK
end
local function aa(b)
if d(b)~="table"then
return b
end
local o=b.dps
if o==nil then
o=b.dp_list
end
if o==nil and b[1]~=nil then
o=b
end
return o
end
local function af(b)
local o=aa(b)if o~=nil then
return o
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aL(A,b)
b=b or{}local aM=b.phases
if d(aM)~="table"then
aM=b.phase_names
end
local phase=d(aM)=="table"and aM[A]or nil
if d(phase)=="string"and phase~=""then
return phase
end
local E=b.phase_prefix
if E==false then
return nil
end
if d(E)~="string"or E==""then
E=nil
end
if E~=nil then
return E..tostring(A)
end
return tostring(A)
end
local function aj(A,b)
b=b or{}local K=b.first_is_main~=false
local I=b.component_prefix
if d(I)~="string"or I==""then
I="switch"
end
local P=b.main_component
if d(P)~="string"or P==""then
P="main"
end
local t=b.index_offset
if d(t)~="number"or t%1~=0 then
t=0
end
if A==1 and K then
return P
end
local aE=K and(A-1+t)or(A+t)if aE<1 then
return b.default_component
end
return I..tostring(aE)
end
local function aA(A,b,aR)
b=b or{}local K=b.first_is_main~=false
local X=b.key_prefix
if d(X)~="string"or X==""then
X=aR or"switch"
end
local aw=b.main_key
if d(aw)~="string"or aw==""then
aw=X
end
local t=b.index_offset
if d(t)~="number"or t%1~=0 then
t=0
end
if A==1 and K then
return aw
end
local aE=K and(A-1+t)or(A+t)if aE<1 then
return b.default_key
end
return X..tostring(aE)
end
local function R(i,s,z,b)
if d(s)~="number"or s%1~=0 or s<0 then
return
end
M(i,z(s,b))
end
local function ab(Z,bu)
if d(bu)~="table"then
return Z
end
for _,bw in ipairs(bu)do
M(Z,bw)
end
return Z
end
local am={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function az(Q)
return d(Q)=="number"and Q%1==0 and Q>0
end
local function r(b,j)
local a={}if d(b)~="table"then
return a
end
for at,Q in pairs(b)do
local aH=true
if not j then
if at=="dp"or at=="dps"or at=="dp_list"then
aH=false
elseif az(at)then
aH=false
end
end
if aH then
a[at]=Q
end
end
return a
end
local function ae(b)
if d(b)~="table"then
return false
end
if b.dp~=nil or b.dps~=nil or b.dp_list~=nil or b[1]~=nil then
return true
end
return false
end
local function F(b)
if d(b)~="table"then
return b
end
b.dp=nil
b.dps=nil
b.dp_list=nil
local A=1
while b[A]~=nil do
b[A]=nil
A=A+1
end
return b
end
local function w(b,p,j)
if d(b)~="table"then
return{}
end
local v=b[p]if v==nil then
return r(b,j)
end
local a=r(b,j)if d(v)=="table"then
k(a,v)else
a.dp=v
end
return a
end
local function y(v)
if v==nil then
return nil
end
if d(v)=="table"then
return v
end
return{dp=v}
end
local function V(b,p)
if d(b)~="table"then
return nil
end
return y(b[p])
end
local function ax(av,f)
local L=d(av)=="table"and av.item_options or nil
local D=d(f)=="table"and f.item_options or nil
if d(L)~="table"then
return d(D)=="table"and D or nil
end
if d(D)~="table"then
return L
end
local a={}k(a,L)k(a,D)return a
end
local function ai(b,p,C,j)
local a={}local v=nil
if d(b)=="table"then
bm(a,b,am)v=b[p]if d(v)=="table"then
k(a,r(b,j))if j and ae(v)then
F(a)
end
k(a,v)elseif v~=nil then
k(a,r(b,j))if j then
F(a)
end
a.dp=v
else
k(a,r(b,j))
end
end
if a.key_prefix==nil and C~=nil then
a.key_prefix=C
end
a.item_options=ax(b,v)return a
end
local function N(b,n)
local m={}local as=V(b,"config")k(m,as)local ay=y(m[n])if ay~=nil then
m[n]=ay
else
local Y=y(m.switch_type)if Y==nil then
Y=V(b,"switch_type")
end
if d(Y)=="table"then
m[n]=Y
end
end
if n~="switch_type"then
m.switch_type=nil
end
if next(m)~=nil then
return m
end
return{}
end
local function O(b,n)
local a={}if d(b)=="table"then
k(a,b)
end
local m=N(b,n)if next(m)~=nil then
a.config=m
end
a.switch_type=nil
return a
end
local function aW(b,n)
local a={}if d(b)=="table"then
k(a,b)
end
local T=O(
w(b,"switch_module"),n)if next(T)~=nil then
a.switch_module=T
end
return a
end
local function bl(i,b,p,z)
local f=w(b,p)R(i,f.dp,z,f)
end
local function aF(i,b,p,z,J)
local f=w(b,p)ar(f,J)R(i,f.dp,z,f)
end
local function aU(i,b,p,z,aB)
local f=w(b,p)local o=aa(f)if o~=nil and aB~=nil then
ab(i,aB(o,f))return
end
R(i,f.dp,z,f)
end
local function aN(i,b,p,C,z)
local f=ai(b,p,C)ab(i,z(af(f),f))
end
local function bg(o,z,g,b)
local i={}local al=ap(o)local ak=d(b)=="table"and b.item_options or nil
for A,s in ipairs(al)do
local a=e(ak,nil,g)if a.component==nil then
a.component=aj(A,b)
end
if a.key==nil and a.preference==nil then
a.key=aA(A,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
M(i,z(s,a))
end
return i
end
local function aP(o,z,b)
local i={}local al=ap(o)local ak=d(b)=="table"and b.item_options or nil
for A,s in ipairs(al)do
local a=e(ak,nil,nil)if a.phase==nil then
a.phase=aL(A,b)
end
M(i,z(s,a))
end
return i
end
local function aO(b,p,z)
local f=nil
if d(b)=="table"then
f=w(b,p,true)else
f={dp=b}
end
local i={}R(i,f.dp,z,f)return i
end
function q.dp_on_off(s,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return q.dp_binary(s,a)
end
function q.dp_temperature(s,c,b)
return h(s,"temperature",c,b)
end
function q.dp_humidity(s,c,b)
return h(s,"humidity",c,b)
end
function q.dp_battery(s,c,b)
return l(s,"battery",1,c,b)
end
function q.dp_child_lock(s,c,b)
return q.dp_binary(s,e(c,b,"child_lock"))
end
function q.dp_voltage(s,c,b)
return l(s,"voltage",10,c,b)
end
function q.dp_current(s,c,b)
return l(s,"current",1000,c,b)
end
function q.dp_power(s,c,b)
return ad(s,"power",10,c,b)
end
function q.dp_energy(s,c,b)
return l(s,"energy",100,c,b)
end
function q.dp_local_temperature(s,c,b)
return h(s,"local_temperature",c,b)
end
function q.dp_current_heating_setpoint(s,c,b)
return h(s,"current_heating_setpoint",c,b)
end
function q.dp_local_temperature_calibration(s,c,b)
return ac(s,"local_temperature_calibration",10,c,b)
end
function q.dp_eco_temperature(s,c,b)
return h(s,"eco_temperature",c,b)
end
function q.dp_holiday_temperature(s,c,b)
return h(s,"holiday_temperature",c,b)
end
function q.dp_max_temperature_limit(s,c,b)
return h(s,"max_temperature_limit",c,b)
end
function q.dp_min_temperature_limit(s,c,b)
return h(s,"min_temperature_limit",c,b)
end
function q.dp_deadzone_temperature(s,c,b)
return l(s,"deadzone_temperature",1,c,b)
end
function q.dp_system_mode(s,c,b)
return q.dp_enum(s,e(c,b,"system_mode"))
end
function q.dp_running_state(s,c,b)
return q.dp_enum(s,e(c,b,"running_state"))
end
function q.dp_frost_protection(s,c,b)
return q.dp_binary(s,e(c,b,"frost_protection"))
end
function q.dp_temperature_sensor_select_internal_external_both(s,c,b)
local a=e(c,b,"temperature_sensor_select")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=u.temperature_sensor_select_internal_external_both()
end
return U(q.dp_enum(s,a),a)
end
end
return au
