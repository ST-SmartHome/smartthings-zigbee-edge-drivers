local function av(s,aE,bs)
bs=bs or{switch=function()return nil end}
local d=aE.type_check
local N=aE.table_insert
local aU=aE.tonumber_check
local k=aE.merge_options
local bm=aE.copy_keys
local j=s.converter
local function as(Z,K)
if d(Z)~="table"or d(K)~="table"then
return Z
end
for au,R in pairs(K)do
if Z[au]==nil then
Z[au]=R
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
for _,au in ipairs(ao)do
if b[au]~=nil then
return true
end
end
return false
end
local function B(bh,b)
if an(b)then
return bh
end
return s.apply_fixed_send_policy(bh)
end
local function ac(w,g,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and v~=1 then
a.converter=j.divide_by_pair(v)
end
a.scale=nil
return s.dp_numeric(w,a)
end
local function l(w,g,A,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and v~=1 then
a.converter=j.divide_by_pair(v)
end
a.scale=nil
return s.dp_numeric(w,a)
end
local function ad(w,g,A,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local aq=j.power()local bf=aq.from
if v~=1 then
a.from_device=j.pipe(
bf,j.divide_by(v))else
a.converter=aq
end
end
a.scale=nil
return s.dp_numeric(w,a)
end
local function aX(w,g,A,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=j.signed_number_pair(v)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return s.dp_numeric(w,a)
end
local function aJ(w,g,A,be,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=A
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
local aH={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}as(aH,be)a.converter=j.raw_uint_be(v,aH)if a.datatype==nil then
a.datatype=s.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and v~=1 then
a.converter=j.divide_by_pair(v)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return s.dp_numeric(w,a)
end
local function W(R,bp,bo)
local aD=aU(R)if aD==nil then
return nil
end
return bp+bo-aD
end
local function aW(w,g,K,c,b)
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
local bj=j.scale(ah,ag,I,H)local bt=j.scale(I,H,ah,ag)a.converter=j.from_to(
function(R,ba,aR)
local bq=bj(R,ba,aR)if bq==nil then
return nil
end
return W(bq,I,H)
end,
function(R,ba,aR)
local bc=W(R,I,H)if bc==nil then
return nil
end
return bt(bc,ba,aR)
end
)elseif ah~=I or ag~=H then
a.converter=j.scale_pair(ah,ag,I,H)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return s.dp_numeric(w,a)
end
local function bk(phase,bb)
if d(phase)=="string"and phase~=""then
return(bb or"phase").."_"..phase
end
return bb or"phase"
end
local function bd(bx,phase)
local bn={}for _,au in ipairs(bx or{})do
local aK=au
if d(phase)=="string"and phase~=""then
aK=au.."_"..phase
end
bn[aK]=true
end
return bn
end
local function E(w,g,aT,bi,c,b)
local aZ=
d(c)=="string"or
(d(c)=="table"and c.name~=nil)or
(d(b)=="table"and b.name~=nil)local a=e(c,b,g)local phase=a.phase
if not aZ and a.name==g then
a.name=bk(phase,g)
end
if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=aT(a)
end
if a.field==nil and a.fields==nil then
a.fields=bd(bi,phase)
end
return s.dp_raw(w,a)
end
local function ar(w,c,b)
local a=e(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=j.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return s.dp_raw(w,a)
end
local function ap(o)
if d(o)=="number"and o%1==0 and o>=0 then
return{o}
end
if d(o)~="table"then
return{}
end
local aL={}for _,w in ipairs(o)do
if d(w)=="number"and w%1==0 and w>=0 then
N(aL,w)
end
end
return aL
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
local function aM(z,b)
b=b or{}local aN=b.phases
if d(aN)~="table"then
aN=b.phase_names
end
local phase=d(aN)=="table"and aN[z]or nil
if d(phase)=="string"and phase~=""then
return phase
end
local F=b.phase_prefix
if F==false then
return nil
end
if d(F)~="string"or F==""then
F=nil
end
if F~=nil then
return F..tostring(z)
end
return tostring(z)
end
local function aj(z,b)
b=b or{}local L=b.first_is_main~=false
local J=b.component_prefix
if d(J)~="string"or J==""then
J="switch"
end
local Q=b.main_component
if d(Q)~="string"or Q==""then
Q="main"
end
local r=b.index_offset
if d(r)~="number"or r%1~=0 then
r=0
end
if z==1 and L then
return Q
end
local aF=L and(z-1+r)or(z+r)if aF<1 then
return b.default_component
end
return J..tostring(aF)
end
local function aB(z,b,aS)
b=b or{}local L=b.first_is_main~=false
local X=b.key_prefix
if d(X)~="string"or X==""then
X=aS or"switch"
end
local ax=b.main_key
if d(ax)~="string"or ax==""then
ax=X
end
local r=b.index_offset
if d(r)~="number"or r%1~=0 then
r=0
end
if z==1 and L then
return ax
end
local aF=L and(z-1+r)or(z+r)if aF<1 then
return b.default_key
end
return X..tostring(aF)
end
local function S(h,w,y,b)
if d(w)~="number"or w%1~=0 or w<0 then
return
end
N(h,y(w,b))
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
local function aA(R)
return d(R)=="number"and R%1==0 and R>0
end
local function q(b,i)
local a={}if d(b)~="table"then
return a
end
for au,R in pairs(b)do
local aI=true
if not i then
if au=="dp"or au=="dps"or au=="dp_list"then
aI=false
elseif aA(au)then
aI=false
end
end
if aI then
a[au]=R
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
local z=1
while b[z]~=nil do
b[z]=nil
z=z+1
end
return b
end
local function u(b,p,i)
if d(b)~="table"then
return{}
end
local t=b[p]if t==nil then
return q(b,i)
end
local a=q(b,i)if d(t)=="table"then
k(a,t)else
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
local function V(b,p)
if d(b)~="table"then
return nil
end
return x(b[p])
end
local function ay(aw,f)
local M=d(aw)=="table"and aw.item_options or nil
local D=d(f)=="table"and f.item_options or nil
if d(M)~="table"then
return d(D)=="table"and D or nil
end
if d(D)~="table"then
return M
end
local a={}k(a,M)k(a,D)return a
end
local function ai(b,p,C,i)
local a={}local t=nil
if d(b)=="table"then
bm(a,b,am)t=b[p]if d(t)=="table"then
k(a,q(b,i))if i and ae(t)then
G(a)
end
k(a,t)elseif t~=nil then
k(a,q(b,i))if i then
G(a)
end
a.dp=t
else
k(a,q(b,i))
end
end
if a.key_prefix==nil and C~=nil then
a.key_prefix=C
end
a.item_options=ay(b,t)return a
end
local function O(b,n)
local m={}local at=V(b,"config")k(m,at)local az=x(m[n])if az~=nil then
m[n]=az
else
local Y=x(m.switch_type)if Y==nil then
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
local function P(b,n)
local a={}if d(b)=="table"then
k(a,b)
end
local m=O(b,n)if next(m)~=nil then
a.config=m
end
a.switch_type=nil
return a
end
local function aY(b,n)
local a={}if d(b)=="table"then
k(a,b)
end
local U=P(
u(b,"switch_module"),n)if next(U)~=nil then
a.switch_module=U
end
return a
end
local function bl(h,b,p,y)
local f=u(b,p)S(h,f.dp,y,f)
end
local function aG(h,b,p,y,K)
local f=u(b,p)as(f,K)S(h,f.dp,y,f)
end
local function aV(h,b,p,y,aC)
local f=u(b,p)local o=aa(f)if o~=nil and aC~=nil then
ab(h,aC(o,f))return
end
S(h,f.dp,y,f)
end
local function aO(h,b,p,C,y)
local f=ai(b,p,C)ab(h,y(af(f),f))
end
local function bg(o,y,g,b)
local h={}local al=ap(o)local ak=d(b)=="table"and b.item_options or nil
for z,w in ipairs(al)do
local a=e(ak,nil,g)if a.component==nil then
a.component=aj(z,b)
end
if a.key==nil and a.preference==nil then
a.key=aB(z,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
N(h,y(w,a))
end
return h
end
local function aQ(o,y,b)
local h={}local al=ap(o)local ak=d(b)=="table"and b.item_options or nil
for z,w in ipairs(al)do
local a=e(ak,nil,nil)if a.phase==nil then
a.phase=aM(z,b)
end
N(h,y(w,a))
end
return h
end
local function aP(b,p,y)
local f=nil
if d(b)=="table"then
f=u(b,p,true)else
f={dp=b}
end
local h={}S(h,f.dp,y,f)return h
end
function s.dp_on_off(w,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return s.dp_binary(w,a)
end
function s.dp_temperature(w,c,b)
return ac(w,"temperature",c,b)
end
function s.dp_child_lock(w,c,b)
return s.dp_binary(w,e(c,b,"child_lock"))
end
function s.dp_voltage(w,c,b)
return l(w,"voltage",10,c,b)
end
function s.dp_current(w,c,b)
return l(w,"current",1000,c,b)
end
function s.dp_power(w,c,b)
return ad(w,"power",10,c,b)
end
function s.dp_energy(w,c,b)
return l(w,"energy",100,c,b)
end
function s.dp_ac_frequency(w,c,b)
return l(w,"ac_frequency",100,c,b)
end
function s.dp_phase_variant1(w,c,b)
return E(
w,"phase",
function(a)
return j.phase_variant1_parser(a.phase)
end,
{"voltage","current"},c,b)
end
function s.dp_phase_variant2(w,c,b)
return E(
w,"phase",
function(a)
return j.phase_variant2_parser(a.phase,a.signed_power)
end,
{"voltage","current","power"},c,b)
end
function s.dp_phase_variant3(w,c,b)
return E(
w,"phase",
function(a)
return j.phase_variant3_parser(a.phase)
end,
{"voltage","current","power"},c,b)
end
function s.dp_threshold(w,c,b)
return ar(w,c,b)
end
function s.dp_power_on_behavior(w,c,b)
local a=e(c,b,"power_on_behavior")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=j.power_on_behavior()
end
return B(s.dp_enum(w,a),a)
end
function s.dp_power_outage_memory(w,c,b)
local a=e(c,b,"power_outage_memory")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=j.power_outage_memory()
end
return B(s.dp_enum(w,a),a)
end
function s.dp_power_factor(w,c,b)
local a=e(c,b,"power_factor")if a.read_only==nil then
a.read_only=true
end
return l(w,"power_factor",1,a)
end
end
return av
