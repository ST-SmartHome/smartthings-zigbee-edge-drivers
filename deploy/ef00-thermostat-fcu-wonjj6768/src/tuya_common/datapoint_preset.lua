local function at(m,aC,bs)
bs=bs or{switch=function()return nil end}
local d=aC.type_check
local M=aC.table_insert
local aT=aC.tonumber_check
local k=aC.merge_options
local bm=aC.copy_keys
local u=m.converter
local function aq(Y,J)
if d(Y)~="table"or d(J)~="table"then
return Y
end
for as,Q in pairs(J)do
if Y[as]==nil then
Y[as]=Q
end
end
return Y
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
local an={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function am(b)
if d(b)~="table"then
return false
end
for _,as in ipairs(an)do
if b[as]~=nil then
return true
end
end
return false
end
local function aH(bh,b)
if am(b)then
return bh
end
return m.apply_fixed_send_policy(bh)
end
local function h(r,g,c,b)
local a=e(c,b,g)local x=a.scale
if x==nil then
x=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and x~=1 then
a.converter=u.divide_by_pair(x)
end
a.scale=nil
return m.dp_numeric(r,a)
end
local function t(r,g,B,c,b)
local a=e(c,b,g)local x=a.scale
if x==nil then
x=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and x~=1 then
a.converter=u.divide_by_pair(x)
end
a.scale=nil
return m.dp_numeric(r,a)
end
local function ac(r,g,B,c,b)
local a=e(c,b,g)local x=a.scale
if x==nil then
x=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ap=u.power()local bf=ap.from
if x~=1 then
a.from_device=u.pipe(
bf,u.divide_by(x))else
a.converter=ap
end
end
a.scale=nil
return m.dp_numeric(r,a)
end
local function ab(r,g,B,c,b)
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
return m.dp_numeric(r,a)
end
local function aI(r,g,B,bc,c,b)
local a=e(c,b,g)local x=a.scale
if x==nil then
x=B
end
local br=
a.datatype==m.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aF={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}aq(aF,bc)a.converter=u.raw_uint_be(x,aF)if a.datatype==nil then
a.datatype=m.DP_TYPE_RAW
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
return m.dp_numeric(r,a)
end
local function V(Q,bp,bo)
local aB=aT(Q)if aB==nil then
return nil
end
return bp+bo-aB
end
local function aV(r,g,J,c,b)
local a=e(c,b,g)local ag=a.raw_min
if ag==nil then
ag=J.raw_min
end
local af=a.raw_max
if af==nil then
af=J.raw_max
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
local bj=u.scale(ag,af,H,G)local bt=u.scale(H,G,ag,af)a.converter=u.from_to(
function(Q,aY,aQ)
local bq=bj(Q,aY,aQ)if bq==nil then
return nil
end
return V(bq,H,G)
end,
function(Q,aY,aQ)
local ba=V(Q,H,G)if ba==nil then
return nil
end
return bt(ba,aY,aQ)
end
)elseif ag~=H or af~=G then
a.converter=u.scale_pair(ag,af,H,G)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return m.dp_numeric(r,a)
end
local function bk(phase,aZ)
if d(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,as in ipairs(bx or{})do
local aJ=as
if d(phase)=="string"and phase~=""then
aJ=as.."_"..phase
end
bn[aJ]=true
end
return bn
end
local function bd(r,g,aS,bi,c,b)
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
return m.dp_raw(r,a)
end
local function be(r,c,b)
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
return m.dp_raw(r,a)
end
local function ao(o)
if d(o)=="number"and o%1==0 and o>=0 then
return{o}
end
if d(o)~="table"then
return{}
end
local aK={}for _,r in ipairs(o)do
if d(r)=="number"and r%1==0 and r>=0 then
M(aK,r)
end
end
return aK
end
local function Z(b)
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
local function ae(b)
local o=Z(b)if o~=nil then
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
local function ai(A,b)
b=b or{}local K=b.first_is_main~=false
local I=b.component_prefix
if d(I)~="string"or I==""then
I="switch"
end
local P=b.main_component
if d(P)~="string"or P==""then
P="main"
end
local s=b.index_offset
if d(s)~="number"or s%1~=0 then
s=0
end
if A==1 and K then
return P
end
local aD=K and(A-1+s)or(A+s)if aD<1 then
return b.default_component
end
return I..tostring(aD)
end
local function az(A,b,aR)
b=b or{}local K=b.first_is_main~=false
local W=b.key_prefix
if d(W)~="string"or W==""then
W=aR or"switch"
end
local av=b.main_key
if d(av)~="string"or av==""then
av=W
end
local s=b.index_offset
if d(s)~="number"or s%1~=0 then
s=0
end
if A==1 and K then
return av
end
local aD=K and(A-1+s)or(A+s)if aD<1 then
return b.default_key
end
return W..tostring(aD)
end
local function R(i,r,z,b)
if d(r)~="number"or r%1~=0 or r<0 then
return
end
M(i,z(r,b))
end
local function aa(Y,bu)
if d(bu)~="table"then
return Y
end
for _,bw in ipairs(bu)do
M(Y,bw)
end
return Y
end
local al={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ay(Q)
return d(Q)=="number"and Q%1==0 and Q>0
end
local function q(b,j)
local a={}if d(b)~="table"then
return a
end
for as,Q in pairs(b)do
local aG=true
if not j then
if as=="dp"or as=="dps"or as=="dp_list"then
aG=false
elseif ay(as)then
aG=false
end
end
if aG then
a[as]=Q
end
end
return a
end
local function ad(b)
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
return q(b,j)
end
local a=q(b,j)if d(v)=="table"then
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
local function U(b,p)
if d(b)~="table"then
return nil
end
return y(b[p])
end
local function aw(au,f)
local L=d(au)=="table"and au.item_options or nil
local D=d(f)=="table"and f.item_options or nil
if d(L)~="table"then
return d(D)=="table"and D or nil
end
if d(D)~="table"then
return L
end
local a={}k(a,L)k(a,D)return a
end
local function ah(b,p,C,j)
local a={}local v=nil
if d(b)=="table"then
bm(a,b,al)v=b[p]if d(v)=="table"then
k(a,q(b,j))if j and ad(v)then
F(a)
end
k(a,v)elseif v~=nil then
k(a,q(b,j))if j then
F(a)
end
a.dp=v
else
k(a,q(b,j))
end
end
if a.key_prefix==nil and C~=nil then
a.key_prefix=C
end
a.item_options=aw(b,v)return a
end
local function N(b,n)
local l={}local ar=U(b,"config")k(l,ar)local ax=y(l[n])if ax~=nil then
l[n]=ax
else
local X=y(l.switch_type)if X==nil then
X=U(b,"switch_type")
end
if d(X)=="table"then
l[n]=X
end
end
if n~="switch_type"then
l.switch_type=nil
end
if next(l)~=nil then
return l
end
return{}
end
local function O(b,n)
local a={}if d(b)=="table"then
k(a,b)
end
local l=N(b,n)if next(l)~=nil then
a.config=l
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
local function aE(i,b,p,z,J)
local f=w(b,p)aq(f,J)R(i,f.dp,z,f)
end
local function aU(i,b,p,z,aA)
local f=w(b,p)local o=Z(f)if o~=nil and aA~=nil then
aa(i,aA(o,f))return
end
R(i,f.dp,z,f)
end
local function aN(i,b,p,C,z)
local f=ah(b,p,C)aa(i,z(ae(f),f))
end
local function bg(o,z,g,b)
local i={}local ak=ao(o)local aj=d(b)=="table"and b.item_options or nil
for A,r in ipairs(ak)do
local a=e(aj,nil,g)if a.component==nil then
a.component=ai(A,b)
end
if a.key==nil and a.preference==nil then
a.key=az(A,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
M(i,z(r,a))
end
return i
end
local function aP(o,z,b)
local i={}local ak=ao(o)local aj=d(b)=="table"and b.item_options or nil
for A,r in ipairs(ak)do
local a=e(aj,nil,nil)if a.phase==nil then
a.phase=aL(A,b)
end
M(i,z(r,a))
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
function m.dp_on_off(r,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return m.dp_binary(r,a)
end
function m.dp_temperature(r,c,b)
return h(r,"temperature",c,b)
end
function m.dp_humidity(r,c,b)
return h(r,"humidity",c,b)
end
function m.dp_child_lock(r,c,b)
return m.dp_binary(r,e(c,b,"child_lock"))
end
function m.dp_voltage(r,c,b)
return t(r,"voltage",10,c,b)
end
function m.dp_current(r,c,b)
return t(r,"current",1000,c,b)
end
function m.dp_power(r,c,b)
return ac(r,"power",10,c,b)
end
function m.dp_energy(r,c,b)
return t(r,"energy",100,c,b)
end
function m.dp_temperature_unit(r,c,b)
local a=e(c,b,"temperature_unit")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=u.temperature_unit()
end
return m.dp_enum(r,a)
end
function m.dp_local_temperature(r,c,b)
return h(r,"local_temperature",c,b)
end
function m.dp_current_heating_setpoint(r,c,b)
return h(r,"current_heating_setpoint",c,b)
end
function m.dp_local_temperature_calibration(r,c,b)
return ab(r,"local_temperature_calibration",10,c,b)
end
function m.dp_eco_temperature(r,c,b)
return h(r,"eco_temperature",c,b)
end
function m.dp_max_temperature_limit(r,c,b)
return h(r,"max_temperature_limit",c,b)
end
function m.dp_min_temperature_limit(r,c,b)
return h(r,"min_temperature_limit",c,b)
end
function m.dp_deadzone_temperature(r,c,b)
return t(r,"deadzone_temperature",1,c,b)
end
function m.dp_system_mode(r,c,b)
return m.dp_enum(r,e(c,b,"system_mode"))
end
function m.dp_running_state(r,c,b)
return m.dp_enum(r,e(c,b,"running_state"))
end
function m.dp_fan_mode(r,c,b)
return m.dp_enum(r,e(c,b,"fan_mode"))
end
function m.dp_open_window(r,c,b)
return m.dp_binary(r,e(c,b,"open_window"))
end
function m.dp_eco_mode(r,c,b)
return m.dp_binary(r,e(c,b,"eco_mode"))
end
end
return at
