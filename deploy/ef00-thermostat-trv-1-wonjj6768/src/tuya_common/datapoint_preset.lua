local function at(i,aC,bs)
bs=bs or{switch=function()return nil end}
local e=aC.type_check
local N=aC.table_insert
local aS=aC.tonumber_check
local m=aC.merge_options
local bm=aC.copy_keys
local r=i.converter
local function aq(Z,K)
if e(Z)~="table"or e(K)~="table"then
return Z
end
for as,R in pairs(K)do
if Z[as]==nil then
Z[as]=R
end
end
return Z
end
local function d(c,b,h)
local a={}if e(c)=="string"then
a.name=c
else
m(a,c)
end
m(a,b)if a.name==nil and h~=nil then
a.name=h
end
return a
end
local an={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function am(b)
if e(b)~="table"then
return false
end
for _,as in ipairs(an)do
if b[as]~=nil then
return true
end
end
return false
end
local function C(bh,b)
if am(b)then
return bh
end
return i.apply_fixed_send_policy(bh)
end
local function g(l,h,c,b)
local a=d(c,b,h)local x=a.scale
if x==nil then
x=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and x~=1 then
a.converter=r.divide_by_pair(x)
end
a.scale=nil
return i.dp_numeric(l,a)
end
local function u(l,h,B,c,b)
local a=d(c,b,h)local x=a.scale
if x==nil then
x=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and x~=1 then
a.converter=r.divide_by_pair(x)
end
a.scale=nil
return i.dp_numeric(l,a)
end
local function aW(l,h,B,c,b)
local a=d(c,b,h)local x=a.scale
if x==nil then
x=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ap=r.power()local bf=ap.from
if x~=1 then
a.from_device=r.pipe(
bf,r.divide_by(x))else
a.converter=ap
end
end
a.scale=nil
return i.dp_numeric(l,a)
end
local function ac(l,h,B,c,b)
local a=d(c,b,h)local x=a.scale
if x==nil then
x=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=r.signed_number_pair(x)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return i.dp_numeric(l,a)
end
local function aH(l,h,B,bc,c,b)
local a=d(c,b,h)local x=a.scale
if x==nil then
x=B
end
local br=
a.datatype==i.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aF={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}aq(aF,bc)a.converter=r.raw_uint_be(x,aF)if a.datatype==nil then
a.datatype=i.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and x~=1 then
a.converter=r.divide_by_pair(x)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return i.dp_numeric(l,a)
end
local function W(R,bp,bo)
local aB=aS(R)if aB==nil then
return nil
end
return bp+bo-aB
end
local function aU(l,h,K,c,b)
local a=d(c,b,h)local ag=a.raw_min
if ag==nil then
ag=K.raw_min
end
local af=a.raw_max
if af==nil then
af=K.raw_max
end
local I=a.value_min
if I==nil then
I=K.value_min
end
local H=a.value_max
if H==nil then
H=K.value_max
end
local bv=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bv then
local bj=r.scale(ag,af,I,H)local bt=r.scale(I,H,ag,af)a.converter=r.from_to(
function(R,aY,aP)
local bq=bj(R,aY,aP)if bq==nil then
return nil
end
return W(bq,I,H)
end,
function(R,aY,aP)
local ba=W(R,I,H)if ba==nil then
return nil
end
return bt(ba,aY,aP)
end
)elseif ag~=I or af~=H then
a.converter=r.scale_pair(ag,af,I,H)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return i.dp_numeric(l,a)
end
local function bk(phase,aZ)
if e(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,as in ipairs(bx or{})do
local aI=as
if e(phase)=="string"and phase~=""then
aI=as.."_"..phase
end
bn[aI]=true
end
return bn
end
local function bd(l,h,aR,bi,c,b)
local aX=
e(c)=="string"or
(e(c)=="table"and c.name~=nil)or
(e(b)=="table"and b.name~=nil)local a=d(c,b,h)local phase=a.phase
if not aX and a.name==h then
a.name=bk(phase,h)
end
if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=aR(a)
end
if a.field==nil and a.fields==nil then
a.fields=bb(bi,phase)
end
return i.dp_raw(l,a)
end
local function be(l,c,b)
local a=d(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=r.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return i.dp_raw(l,a)
end
local function ao(p)
if e(p)=="number"and p%1==0 and p>=0 then
return{p}
end
if e(p)~="table"then
return{}
end
local aJ={}for _,l in ipairs(p)do
if e(l)=="number"and l%1==0 and l>=0 then
N(aJ,l)
end
end
return aJ
end
local function aa(b)
if e(b)~="table"then
return b
end
local p=b.dps
if p==nil then
p=b.dp_list
end
if p==nil and b[1]~=nil then
p=b
end
return p
end
local function ae(b)
local p=aa(b)if p~=nil then
return p
end
if e(b)~="table"then
return b
end
return b.dp
end
local function aK(A,b)
b=b or{}local aL=b.phases
if e(aL)~="table"then
aL=b.phase_names
end
local phase=e(aL)=="table"and aL[A]or nil
if e(phase)=="string"and phase~=""then
return phase
end
local F=b.phase_prefix
if F==false then
return nil
end
if e(F)~="string"or F==""then
F=nil
end
if F~=nil then
return F..tostring(A)
end
return tostring(A)
end
local function ai(A,b)
b=b or{}local L=b.first_is_main~=false
local J=b.component_prefix
if e(J)~="string"or J==""then
J="switch"
end
local Q=b.main_component
if e(Q)~="string"or Q==""then
Q="main"
end
local t=b.index_offset
if e(t)~="number"or t%1~=0 then
t=0
end
if A==1 and L then
return Q
end
local aD=L and(A-1+t)or(A+t)if aD<1 then
return b.default_component
end
return J..tostring(aD)
end
local function az(A,b,aQ)
b=b or{}local L=b.first_is_main~=false
local X=b.key_prefix
if e(X)~="string"or X==""then
X=aQ or"switch"
end
local av=b.main_key
if e(av)~="string"or av==""then
av=X
end
local t=b.index_offset
if e(t)~="number"or t%1~=0 then
t=0
end
if A==1 and L then
return av
end
local aD=L and(A-1+t)or(A+t)if aD<1 then
return b.default_key
end
return X..tostring(aD)
end
local function S(j,l,z,b)
if e(l)~="number"or l%1~=0 or l<0 then
return
end
N(j,z(l,b))
end
local function ab(Z,bu)
if e(bu)~="table"then
return Z
end
for _,bw in ipairs(bu)do
N(Z,bw)
end
return Z
end
local al={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ay(R)
return e(R)=="number"and R%1==0 and R>0
end
local function s(b,k)
local a={}if e(b)~="table"then
return a
end
for as,R in pairs(b)do
local aG=true
if not k then
if as=="dp"or as=="dps"or as=="dp_list"then
aG=false
elseif ay(as)then
aG=false
end
end
if aG then
a[as]=R
end
end
return a
end
local function ad(b)
if e(b)~="table"then
return false
end
if b.dp~=nil or b.dps~=nil or b.dp_list~=nil or b[1]~=nil then
return true
end
return false
end
local function G(b)
if e(b)~="table"then
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
local function w(b,q,k)
if e(b)~="table"then
return{}
end
local v=b[q]if v==nil then
return s(b,k)
end
local a=s(b,k)if e(v)=="table"then
m(a,v)else
a.dp=v
end
return a
end
local function y(v)
if v==nil then
return nil
end
if e(v)=="table"then
return v
end
return{dp=v}
end
local function V(b,q)
if e(b)~="table"then
return nil
end
return y(b[q])
end
local function aw(au,f)
local M=e(au)=="table"and au.item_options or nil
local E=e(f)=="table"and f.item_options or nil
if e(M)~="table"then
return e(E)=="table"and E or nil
end
if e(E)~="table"then
return M
end
local a={}m(a,M)m(a,E)return a
end
local function ah(b,q,D,k)
local a={}local v=nil
if e(b)=="table"then
bm(a,b,al)v=b[q]if e(v)=="table"then
m(a,s(b,k))if k and ad(v)then
G(a)
end
m(a,v)elseif v~=nil then
m(a,s(b,k))if k then
G(a)
end
a.dp=v
else
m(a,s(b,k))
end
end
if a.key_prefix==nil and D~=nil then
a.key_prefix=D
end
a.item_options=aw(b,v)return a
end
local function O(b,o)
local n={}local ar=V(b,"config")m(n,ar)local ax=y(n[o])if ax~=nil then
n[o]=ax
else
local Y=y(n.switch_type)if Y==nil then
Y=V(b,"switch_type")
end
if e(Y)=="table"then
n[o]=Y
end
end
if o~="switch_type"then
n.switch_type=nil
end
if next(n)~=nil then
return n
end
return{}
end
local function P(b,o)
local a={}if e(b)=="table"then
m(a,b)
end
local n=O(b,o)if next(n)~=nil then
a.config=n
end
a.switch_type=nil
return a
end
local function aV(b,o)
local a={}if e(b)=="table"then
m(a,b)
end
local U=P(
w(b,"switch_module"),o)if next(U)~=nil then
a.switch_module=U
end
return a
end
local function bl(j,b,q,z)
local f=w(b,q)S(j,f.dp,z,f)
end
local function aE(j,b,q,z,K)
local f=w(b,q)aq(f,K)S(j,f.dp,z,f)
end
local function aT(j,b,q,z,aA)
local f=w(b,q)local p=aa(f)if p~=nil and aA~=nil then
ab(j,aA(p,f))return
end
S(j,f.dp,z,f)
end
local function aM(j,b,q,D,z)
local f=ah(b,q,D)ab(j,z(ae(f),f))
end
local function bg(p,z,h,b)
local j={}local ak=ao(p)local aj=e(b)=="table"and b.item_options or nil
for A,l in ipairs(ak)do
local a=d(aj,nil,h)if a.component==nil then
a.component=ai(A,b)
end
if a.key==nil and a.preference==nil then
a.key=az(A,b,h)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
N(j,z(l,a))
end
return j
end
local function aO(p,z,b)
local j={}local ak=ao(p)local aj=e(b)=="table"and b.item_options or nil
for A,l in ipairs(ak)do
local a=d(aj,nil,nil)if a.phase==nil then
a.phase=aK(A,b)
end
N(j,z(l,a))
end
return j
end
local function aN(b,q,z)
local f=nil
if e(b)=="table"then
f=w(b,q,true)else
f={dp=b}
end
local j={}S(j,f.dp,z,f)return j
end
function i.dp_on_off(l,c,b)
local a=d(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return i.dp_binary(l,a)
end
function i.dp_temperature(l,c,b)
return g(l,"temperature",c,b)
end
function i.dp_battery(l,c,b)
return u(l,"battery",1,c,b)
end
function i.dp_child_lock(l,c,b)
return i.dp_binary(l,d(c,b,"child_lock"))
end
function i.dp_local_temperature(l,c,b)
return g(l,"local_temperature",c,b)
end
function i.dp_current_heating_setpoint(l,c,b)
return g(l,"current_heating_setpoint",c,b)
end
function i.dp_local_temperature_calibration(l,c,b)
return ac(l,"local_temperature_calibration",10,c,b)
end
function i.dp_open_window_temperature(l,c,b)
return g(l,"open_window_temperature",c,b)
end
function i.dp_comfort_temperature(l,c,b)
return g(l,"comfort_temperature",c,b)
end
function i.dp_eco_temperature(l,c,b)
return g(l,"eco_temperature",c,b)
end
function i.dp_holiday_temperature(l,c,b)
return g(l,"holiday_temperature",c,b)
end
function i.dp_max_temperature_limit(l,c,b)
return g(l,"max_temperature_limit",c,b)
end
function i.dp_min_temperature_limit(l,c,b)
return g(l,"min_temperature_limit",c,b)
end
function i.dp_deadzone_temperature(l,c,b)
return u(l,"deadzone_temperature",1,c,b)
end
function i.dp_open_window_time(l,c,b)
return u(l,"open_window_time",1,c,b)
end
function i.dp_system_mode(l,c,b)
return i.dp_enum(l,d(c,b,"system_mode"))
end
function i.dp_running_state(l,c,b)
return i.dp_enum(l,d(c,b,"running_state"))
end
function i.dp_frost_protection(l,c,b)
return i.dp_binary(l,d(c,b,"frost_protection"))
end
function i.dp_window_detection(l,c,b)
return i.dp_binary(l,d(c,b,"window_detection"))
end
function i.dp_open_window(l,c,b)
return i.dp_binary(l,d(c,b,"open_window"))
end
function i.dp_window_open(l,c,b)
return i.dp_binary(l,d(c,b,"window_open"))
end
function i.dp_boost_heating(l,c,b)
return i.dp_binary(l,d(c,b,"boost_heating"))
end
function i.dp_scale_protection(l,c,b)
return i.dp_binary(l,d(c,b,"scale_protection"))
end
function i.dp_eco_mode(l,c,b)
return i.dp_binary(l,d(c,b,"eco_mode"))
end
function i.dp_valve_state(l,c,b)
local a=d(c,b,"valve_state")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=r.valve_state_closed_open()
end
return i.dp_enum(l,a)
end
function i.dp_temperature_sensor_select(l,c,b)
local a=d(c,b,"temperature_sensor_select")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=r.temperature_sensor_select_in_al_ou()
end
return C(i.dp_enum(l,a),a)
end
function i.dp_temperature_sensor_select_internal_external_both(l,c,b)
local a=d(c,b,"temperature_sensor_select")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=r.temperature_sensor_select_internal_external_both()
end
return C(i.dp_enum(l,a),a)
end
function i.dp_boost_time(l,c,b)
return u(l,"boost_time",1,c,b)
end
end
return at
