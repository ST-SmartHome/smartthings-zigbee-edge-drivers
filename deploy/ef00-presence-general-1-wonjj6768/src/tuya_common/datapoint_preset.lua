local function as(s,aB,bu)
bu=bu or{switch=function()return nil end}
local d=aB.type_check
local N=aB.table_insert
local aS=aB.tonumber_check
local j=aB.merge_options
local bm=aB.copy_keys
local q=s.converter
local function ap(Z,K)
if d(Z)~="table"or d(K)~="table"then
return Z
end
for ar,R in pairs(K)do
if Z[ar]==nil then
Z[ar]=R
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
local am={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function al(b)
if d(b)~="table"then
return false
end
for _,ar in ipairs(am)do
if b[ar]~=nil then
return true
end
end
return false
end
local function aG(bh,b)
if al(b)then
return bh
end
return s.apply_fixed_send_policy(bh)
end
local function E(x,g,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and v~=1 then
a.converter=q.divide_by_pair(v)
end
a.scale=nil
return s.dp_numeric(x,a)
end
local function k(x,g,A,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and v~=1 then
a.converter=q.divide_by_pair(v)
end
a.scale=nil
return s.dp_numeric(x,a)
end
local function aW(x,g,A,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ao=q.power()local bf=ao.from
if v~=1 then
a.from_device=q.pipe(
bf,q.divide_by(v))else
a.converter=ao
end
end
a.scale=nil
return s.dp_numeric(x,a)
end
local function F(x,g,A,c,b)
local a=e(c,b,g)local v=a.scale
if v==nil then
v=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.signed_number_pair(v)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return s.dp_numeric(x,a)
end
local function aH(x,g,A,bc,c,b)
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
local aE={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ap(aE,bc)a.converter=q.raw_uint_be(v,aE)if a.datatype==nil then
a.datatype=s.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and v~=1 then
a.converter=q.divide_by_pair(v)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return s.dp_numeric(x,a)
end
local function W(R,bp,bo)
local aA=aS(R)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aU(x,g,K,c,b)
local a=e(c,b,g)local af=a.raw_min
if af==nil then
af=K.raw_min
end
local ae=a.raw_max
if ae==nil then
ae=K.raw_max
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
local bj=q.scale(af,ae,I,H)local bs=q.scale(I,H,af,ae)a.converter=q.from_to(
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
return bs(ba,aY,aP)
end
)elseif af~=I or ae~=H then
a.converter=q.scale_pair(af,ae,I,H)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return s.dp_numeric(x,a)
end
local function bk(phase,aZ)
if d(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,ar in ipairs(bx or{})do
local aI=ar
if d(phase)=="string"and phase~=""then
aI=ar.."_"..phase
end
bn[aI]=true
end
return bn
end
local function bd(x,g,aR,bi,c,b)
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
a.converter=aR(a)
end
if a.field==nil and a.fields==nil then
a.fields=bb(bi,phase)
end
return s.dp_raw(x,a)
end
local function be(x,c,b)
local a=e(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return s.dp_raw(x,a)
end
local function an(n)
if d(n)=="number"and n%1==0 and n>=0 then
return{n}
end
if d(n)~="table"then
return{}
end
local aJ={}for _,x in ipairs(n)do
if d(x)=="number"and x%1==0 and x>=0 then
N(aJ,x)
end
end
return aJ
end
local function aa(b)
if d(b)~="table"then
return b
end
local n=b.dps
if n==nil then
n=b.dp_list
end
if n==nil and b[1]~=nil then
n=b
end
return n
end
local function ad(b)
local n=aa(b)if n~=nil then
return n
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aK(z,b)
b=b or{}local aL=b.phases
if d(aL)~="table"then
aL=b.phase_names
end
local phase=d(aL)=="table"and aL[z]or nil
if d(phase)=="string"and phase~=""then
return phase
end
local D=b.phase_prefix
if D==false then
return nil
end
if d(D)~="string"or D==""then
D=nil
end
if D~=nil then
return D..tostring(z)
end
return tostring(z)
end
local function ah(z,b)
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
local aC=L and(z-1+r)or(z+r)if aC<1 then
return b.default_component
end
return J..tostring(aC)
end
local function ay(z,b,aQ)
b=b or{}local L=b.first_is_main~=false
local X=b.key_prefix
if d(X)~="string"or X==""then
X=aQ or"switch"
end
local au=b.main_key
if d(au)~="string"or au==""then
au=X
end
local r=b.index_offset
if d(r)~="number"or r%1~=0 then
r=0
end
if z==1 and L then
return au
end
local aC=L and(z-1+r)or(z+r)if aC<1 then
return b.default_key
end
return X..tostring(aC)
end
local function S(h,x,y,b)
if d(x)~="number"or x%1~=0 or x<0 then
return
end
N(h,y(x,b))
end
local function ab(Z,bt)
if d(bt)~="table"then
return Z
end
for _,bw in ipairs(bt)do
N(Z,bw)
end
return Z
end
local ak={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ax(R)
return d(R)=="number"and R%1==0 and R>0
end
local function p(b,i)
local a={}if d(b)~="table"then
return a
end
for ar,R in pairs(b)do
local aF=true
if not i then
if ar=="dp"or ar=="dps"or ar=="dp_list"then
aF=false
elseif ax(ar)then
aF=false
end
end
if aF then
a[ar]=R
end
end
return a
end
local function ac(b)
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
local function u(b,o,i)
if d(b)~="table"then
return{}
end
local t=b[o]if t==nil then
return p(b,i)
end
local a=p(b,i)if d(t)=="table"then
j(a,t)else
a.dp=t
end
return a
end
local function w(t)
if t==nil then
return nil
end
if d(t)=="table"then
return t
end
return{dp=t}
end
local function V(b,o)
if d(b)~="table"then
return nil
end
return w(b[o])
end
local function av(at,f)
local M=d(at)=="table"and at.item_options or nil
local C=d(f)=="table"and f.item_options or nil
if d(M)~="table"then
return d(C)=="table"and C or nil
end
if d(C)~="table"then
return M
end
local a={}j(a,M)j(a,C)return a
end
local function ag(b,o,B,i)
local a={}local t=nil
if d(b)=="table"then
bm(a,b,ak)t=b[o]if d(t)=="table"then
j(a,p(b,i))if i and ac(t)then
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
if a.key_prefix==nil and B~=nil then
a.key_prefix=B
end
a.item_options=av(b,t)return a
end
local function O(b,m)
local l={}local aq=V(b,"config")j(l,aq)local aw=w(l[m])if aw~=nil then
l[m]=aw
else
local Y=w(l.switch_type)if Y==nil then
Y=V(b,"switch_type")
end
if d(Y)=="table"then
l[m]=Y
end
end
if m~="switch_type"then
l.switch_type=nil
end
if next(l)~=nil then
return l
end
return{}
end
local function P(b,m)
local a={}if d(b)=="table"then
j(a,b)
end
local l=O(b,m)if next(l)~=nil then
a.config=l
end
a.switch_type=nil
return a
end
local function aV(b,m)
local a={}if d(b)=="table"then
j(a,b)
end
local U=P(
u(b,"switch_module"),m)if next(U)~=nil then
a.switch_module=U
end
return a
end
local function bl(h,b,o,y)
local f=u(b,o)S(h,f.dp,y,f)
end
local function aD(h,b,o,y,K)
local f=u(b,o)ap(f,K)S(h,f.dp,y,f)
end
local function aT(h,b,o,y,az)
local f=u(b,o)local n=aa(f)if n~=nil and az~=nil then
ab(h,az(n,f))return
end
S(h,f.dp,y,f)
end
local function aM(h,b,o,B,y)
local f=ag(b,o,B)ab(h,y(ad(f),f))
end
local function bg(n,y,g,b)
local h={}local aj=an(n)local ai=d(b)=="table"and b.item_options or nil
for z,x in ipairs(aj)do
local a=e(ai,nil,g)if a.component==nil then
a.component=ah(z,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(z,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
N(h,y(x,a))
end
return h
end
local function aO(n,y,b)
local h={}local aj=an(n)local ai=d(b)=="table"and b.item_options or nil
for z,x in ipairs(aj)do
local a=e(ai,nil,nil)if a.phase==nil then
a.phase=aK(z,b)
end
N(h,y(x,a))
end
return h
end
local function aN(b,o,y)
local f=nil
if d(b)=="table"then
f=u(b,o,true)else
f={dp=b}
end
local h={}S(h,f.dp,y,f)return h
end
function s.dp_temperature(x,c,b)
return E(x,"temperature",c,b)
end
function s.dp_humidity(x,c,b)
return E(x,"humidity",c,b)
end
function s.dp_battery(x,c,b)
return k(x,"battery",1,c,b)
end
function s.dp_occupancy(x,c,b)
local a=e(c,b,"occupancy")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=q.true_false0()
end
return s.dp_binary(x,a)
end
function s.dp_illuminance(x,c,b)
local a=e(c,b,"illuminance")return s.dp_numeric(x,a)
end
function s.dp_temperature_unit(x,c,b)
local a=e(c,b,"temperature_unit")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=q.temperature_unit()
end
return s.dp_enum(x,a)
end
function s.dp_temperature_calibration(x,c,b)
return F(x,"temperature_calibration",10,c,b)
end
function s.dp_humidity_calibration(x,c,b)
return F(x,"humidity_calibration",1,c,b)
end
function s.dp_presence(x,c,b)
return s.dp_binary(x,e(c,b,"presence"))
end
function s.dp_indicator(x,c,b)
return s.dp_binary(x,e(c,b,"indicator"))
end
function s.dp_fading_time(x,c,b)
return k(x,"fading_time",1,c,b)
end
function s.dp_illuminance_interval(x,c,b)
return k(x,"illuminance_interval",1,c,b)
end
function s.dp_static_detection_distance(x,c,b)
return k(x,"static_detection_distance",100,c,b)
end
function s.dp_static_detection_sensitivity(x,c,b)
return k(x,"static_detection_sensitivity",1,c,b)
end
end
return as
