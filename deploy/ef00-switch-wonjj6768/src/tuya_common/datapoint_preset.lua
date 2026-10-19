local function au(s,aD,bs)
bs=bs or{switch=function()return nil end}
local d=aD.type_check
local N=aD.table_insert
local aT=aD.tonumber_check
local j=aD.merge_options
local bm=aD.copy_keys
local o=s.converter
local function ar(Z,K)
if d(Z)~="table"or d(K)~="table"then
return Z
end
for at,R in pairs(K)do
if Z[at]==nil then
Z[at]=R
end
end
return Z
end
local function e(c,b,g)
local a={}if d(c)=="string"then
a.name=c
else
j(a,c)
end
j(a,b)if a.name==nil and g~=nil then
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
local function w(bh,b)
if an(b)then
return bh
end
return s.apply_fixed_send_policy(bh)
end
local function F(y,g,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and v~=1 then
a.converter=o.divide_by_pair(v)
end
a.scale=nil
return s.dp_numeric(y,a)
end
local function r(y,g,B,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and v~=1 then
a.converter=o.divide_by_pair(v)
end
a.scale=nil
return s.dp_numeric(y,a)
end
local function ad(y,g,B,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local aq=o.power()local bf=aq.from
if v~=1 then
a.from_device=o.pipe(
bf,o.divide_by(v))else
a.converter=aq
end
end
a.scale=nil
return s.dp_numeric(y,a)
end
local function ac(y,g,B,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=o.signed_number_pair(v)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return s.dp_numeric(y,a)
end
local function aI(y,g,B,bc,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=B
end
local br=
a.datatype==s.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aG={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ar(aG,bc)a.converter=o.raw_uint_be(v,aG)if a.datatype==nil then
a.datatype=s.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and v~=1 then
a.converter=o.divide_by_pair(v)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return s.dp_numeric(y,a)
end
local function W(R,bp,bo)
local aC=aT(R)if aC==nil then
return nil
end
return bp+bo-aC
end
local function aV(y,g,K,c,b)
local a=e(c,b,g)local ah=a.raw_min
if ah==nil then
ah=K.raw_min
end
local ag=a.raw_max
if ag==nil then
ag=K.raw_max
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
local bj=o.scale(ah,ag,I,H)local bt=o.scale(I,H,ah,ag)a.converter=o.from_to(
function(R,aY,aQ)
local bq=bj(R,aY,aQ)if bq==nil then
return nil
end
return W(bq,I,H)
end,
function(R,aY,aQ)
local ba=W(R,I,H)if ba==nil then
return nil
end
return bt(ba,aY,aQ)
end
)elseif ah~=I or ag~=H then
a.converter=o.scale_pair(ah,ag,I,H)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return s.dp_numeric(y,a)
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
local function bd(y,g,aS,bi,c,b)
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
return s.dp_raw(y,a)
end
local function be(y,c,b)
local a=e(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=o.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return s.dp_raw(y,a)
end
local function ap(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aK={}for _,y in ipairs(m)do
if d(y)=="number"and y%1==0 and y>=0 then
N(aK,y)
end
end
return aK
end
local function aa(b)
if d(b)~="table"then
return b
end
local m=b.dps
if m==nil then
m=b.dp_list
end
if m==nil and b[1]~=nil then
m=b
end
return m
end
local function af(b)
local m=aa(b)if m~=nil then
return m
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
b=b or{}local L=b.first_is_main~=false
local J=b.component_prefix
if d(J)~="string"or J==""then
J="switch"
end
local Q=b.main_component
if d(Q)~="string"or Q==""then
Q="main"
end
local q=b.index_offset
if d(q)~="number"or q%1~=0 then
q=0
end
if A==1 and L then
return Q
end
local aE=L and(A-1+q)or(A+q)if aE<1 then
return b.default_component
end
return J..tostring(aE)
end
local function aA(A,b,aR)
b=b or{}local L=b.first_is_main~=false
local X=b.key_prefix
if d(X)~="string"or X==""then
X=aR or"switch"
end
local aw=b.main_key
if d(aw)~="string"or aw==""then
aw=X
end
local q=b.index_offset
if d(q)~="number"or q%1~=0 then
q=0
end
if A==1 and L then
return aw
end
local aE=L and(A-1+q)or(A+q)if aE<1 then
return b.default_key
end
return X..tostring(aE)
end
local function S(h,y,z,b)
if d(y)~="number"or y%1~=0 or y<0 then
return
end
N(h,z(y,b))
end
local function ab(Z,bu)
if d(bu)~="table"then
return Z
end
for _,bw in ipairs(bu)do
N(Z,bw)
end
return Z
end
local am={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function az(R)
return d(R)=="number"and R%1==0 and R>0
end
local function p(b,i)
local a={}if d(b)~="table"then
return a
end
for at,R in pairs(b)do
local aH=true
if not i then
if at=="dp"or at=="dps"or at=="dp_list"then
aH=false
elseif az(at)then
aH=false
end
end
if aH then
a[at]=R
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
local function G(b)
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
local function u(b,n,i)
if d(b)~="table"then
return{}
end
local t=b[n]if t==nil then
return p(b,i)
end
local a=p(b,i)if d(t)=="table"then
j(a,t)else
a.dp=t
end
return a
end
local function x(t)
if t==nil then
return nil
end
if d(t)=="table"then
return t
end
return{dp=t}
end
local function V(b,n)
if d(b)~="table"then
return nil
end
return x(b[n])
end
local function ax(av,f)
local M=d(av)=="table"and av.item_options or nil
local D=d(f)=="table"and f.item_options or nil
if d(M)~="table"then
return d(D)=="table"and D or nil
end
if d(D)~="table"then
return M
end
local a={}j(a,M)j(a,D)return a
end
local function ai(b,n,C,i)
local a={}local t=nil
if d(b)=="table"then
bm(a,b,am)t=b[n]if d(t)=="table"then
j(a,p(b,i))if i and ae(t)then
G(a)
end
j(a,t)elseif t~=nil then
j(a,p(b,i))if i then
G(a)
end
a.dp=t
else
j(a,p(b,i))
end
end
if a.key_prefix==nil and C~=nil then
a.key_prefix=C
end
a.item_options=ax(b,t)return a
end
local function O(b,l)
local k={}local as=V(b,"config")j(k,as)local ay=x(k[l])if ay~=nil then
k[l]=ay
else
local Y=x(k.switch_type)if Y==nil then
Y=V(b,"switch_type")
end
if d(Y)=="table"then
k[l]=Y
end
end
if l~="switch_type"then
k.switch_type=nil
end
if next(k)~=nil then
return k
end
return{}
end
local function P(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local k=O(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aW(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local U=P(
u(b,"switch_module"),l)if next(U)~=nil then
a.switch_module=U
end
return a
end
local function bl(h,b,n,z)
local f=u(b,n)S(h,f.dp,z,f)
end
local function aF(h,b,n,z,K)
local f=u(b,n)ar(f,K)S(h,f.dp,z,f)
end
local function aU(h,b,n,z,aB)
local f=u(b,n)local m=aa(f)if m~=nil and aB~=nil then
ab(h,aB(m,f))return
end
S(h,f.dp,z,f)
end
local function aN(h,b,n,C,z)
local f=ai(b,n,C)ab(h,z(af(f),f))
end
local function bg(m,z,g,b)
local h={}local al=ap(m)local ak=d(b)=="table"and b.item_options or nil
for A,y in ipairs(al)do
local a=e(ak,nil,g)if a.component==nil then
a.component=aj(A,b)
end
if a.key==nil and a.preference==nil then
a.key=aA(A,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
N(h,z(y,a))
end
return h
end
local function aP(m,z,b)
local h={}local al=ap(m)local ak=d(b)=="table"and b.item_options or nil
for A,y in ipairs(al)do
local a=e(ak,nil,nil)if a.phase==nil then
a.phase=aL(A,b)
end
N(h,z(y,a))
end
return h
end
local function aO(b,n,z)
local f=nil
if d(b)=="table"then
f=u(b,n,true)else
f={dp=b}
end
local h={}S(h,f.dp,z,f)return h
end
function s.dp_on_off(y,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return s.dp_binary(y,a)
end
function s.dp_temperature(y,c,b)
return F(y,"temperature",c,b)
end
function s.dp_humidity(y,c,b)
return F(y,"humidity",c,b)
end
function s.dp_child_lock(y,c,b)
return s.dp_binary(y,e(c,b,"child_lock"))
end
function s.dp_voltage(y,c,b)
return r(y,"voltage",10,c,b)
end
function s.dp_current(y,c,b)
return r(y,"current",1000,c,b)
end
function s.dp_power(y,c,b)
return ad(y,"power",10,c,b)
end
function s.dp_energy(y,c,b)
return r(y,"energy",100,c,b)
end
function s.dp_temperature_unit(y,c,b)
local a=e(c,b,"temperature_unit")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=o.temperature_unit()
end
return s.dp_enum(y,a)
end
function s.dp_power_on_behavior(y,c,b)
local a=e(c,b,"power_on_behavior")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=o.power_on_behavior()
end
return w(s.dp_enum(y,a),a)
end
function s.dp_backlight_mode_off_on(y,c,b)
local a=e(c,b,"backlight_mode")return w(s.dp_binary(y,a),a)
end
function s.dp_indicator_mode_none_relay_pos(y,c,b)
local a=e(c,b,"indicator_mode")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=o.indicator_mode_none_relay_pos()
end
return w(s.dp_enum(y,a),a)
end
function s.dp_countdown(y,c,b)
return r(y,"countdown",1,c,b)
end
function s.dp_temperature_calibration(y,c,b)
return ac(y,"temperature_calibration",10,c,b)
end
end
return au
