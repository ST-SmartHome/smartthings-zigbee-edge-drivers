local function aq(K,az,bu)
bu=bu or{switch=function()return nil end}
local c=az.type_check
local J=az.table_insert
local aQ=az.tonumber_check
local j=az.merge_options
local bm=az.copy_keys
local q=K.converter
local function an(W,F)
if c(W)~="table"or c(F)~="table"then
return W
end
for ap,O in pairs(F)do
if W[ap]==nil then
W[ap]=O
end
end
return W
end
local function e(d,b,g)
local a={}if c(d)=="string"then
a.name=d
else
j(a,d)
end
j(a,b)if a.name==nil and g~=nil then
a.name=g
end
return a
end
local ak={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function aj(b)
if c(b)~="table"then
return false
end
for _,ap in ipairs(ak)do
if b[ap]~=nil then
return true
end
end
return false
end
local function aE(bh,b)
if aj(b)then
return bh
end
return K.apply_fixed_send_policy(bh)
end
local function aT(I,g,d,b)
local a=e(d,b,g)local t=a.scale
if t==nil then
t=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return K.dp_numeric(I,a)
end
local function Y(I,g,x,d,b)
local a=e(d,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return K.dp_numeric(I,a)
end
local function aW(I,g,x,d,b)
local a=e(d,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local am=q.power()local bf=am.from
if t~=1 then
a.from_device=q.pipe(
bf,q.divide_by(t))else
a.converter=am
end
end
a.scale=nil
return K.dp_numeric(I,a)
end
local function aU(I,g,x,d,b)
local a=e(d,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.signed_number_pair(t)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return K.dp_numeric(I,a)
end
local function aF(I,g,x,bc,d,b)
local a=e(d,b,g)local t=a.scale
if t==nil then
t=x
end
local br=
a.datatype==K.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aC={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}an(aC,bc)a.converter=q.raw_uint_be(t,aC)if a.datatype==nil then
a.datatype=K.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return K.dp_numeric(I,a)
end
local function T(O,bp,bo)
local ay=aQ(O)if ay==nil then
return nil
end
return bp+bo-ay
end
local function aS(I,g,F,d,b)
local a=e(d,b,g)local ad=a.raw_min
if ad==nil then
ad=F.raw_min
end
local ac=a.raw_max
if ac==nil then
ac=F.raw_max
end
local D=a.value_min
if D==nil then
D=F.value_min
end
local C=a.value_max
if C==nil then
C=F.value_max
end
local bv=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bv then
local bj=q.scale(ad,ac,D,C)local bs=q.scale(D,C,ad,ac)a.converter=q.from_to(
function(O,aY,aN)
local bq=bj(O,aY,aN)if bq==nil then
return nil
end
return T(bq,D,C)
end,
function(O,aY,aN)
local ba=T(O,D,C)if ba==nil then
return nil
end
return bs(ba,aY,aN)
end
)elseif ad~=D or ac~=C then
a.converter=q.scale_pair(ad,ac,D,C)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return K.dp_numeric(I,a)
end
local function bk(phase,aZ)
if c(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,ap in ipairs(bx or{})do
local aG=ap
if c(phase)=="string"and phase~=""then
aG=ap.."_"..phase
end
bn[aG]=true
end
return bn
end
local function bd(I,g,aP,bi,d,b)
local aX=
c(d)=="string"or
(c(d)=="table"and d.name~=nil)or
(c(b)=="table"and b.name~=nil)local a=e(d,b,g)local phase=a.phase
if not aX and a.name==g then
a.name=bk(phase,g)
end
if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=aP(a)
end
if a.field==nil and a.fields==nil then
a.fields=bb(bi,phase)
end
return K.dp_raw(I,a)
end
local function be(I,d,b)
local a=e(d,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return K.dp_raw(I,a)
end
local function al(m)
if c(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if c(m)~="table"then
return{}
end
local aH={}for _,I in ipairs(m)do
if c(I)=="number"and I%1==0 and I>=0 then
J(aH,I)
end
end
return aH
end
local function X(b)
if c(b)~="table"then
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
local function ab(b)
local m=X(b)if m~=nil then
return m
end
if c(b)~="table"then
return b
end
return b.dp
end
local function aI(w,b)
b=b or{}local aJ=b.phases
if c(aJ)~="table"then
aJ=b.phase_names
end
local phase=c(aJ)=="table"and aJ[w]or nil
if c(phase)=="string"and phase~=""then
return phase
end
local A=b.phase_prefix
if A==false then
return nil
end
if c(A)~="string"or A==""then
A=nil
end
if A~=nil then
return A..tostring(w)
end
return tostring(w)
end
local function af(w,b)
b=b or{}local G=b.first_is_main~=false
local E=b.component_prefix
if c(E)~="string"or E==""then
E="switch"
end
local N=b.main_component
if c(N)~="string"or N==""then
N="main"
end
local p=b.index_offset
if c(p)~="number"or p%1~=0 then
p=0
end
if w==1 and G then
return N
end
local aA=G and(w-1+p)or(w+p)if aA<1 then
return b.default_component
end
return E..tostring(aA)
end
local function aw(w,b,aO)
b=b or{}local G=b.first_is_main~=false
local U=b.key_prefix
if c(U)~="string"or U==""then
U=aO or"switch"
end
local as=b.main_key
if c(as)~="string"or as==""then
as=U
end
local p=b.index_offset
if c(p)~="number"or p%1~=0 then
p=0
end
if w==1 and G then
return as
end
local aA=G and(w-1+p)or(w+p)if aA<1 then
return b.default_key
end
return U..tostring(aA)
end
local function P(h,I,v,b)
if c(I)~="number"or I%1~=0 or I<0 then
return
end
J(h,v(I,b))
end
local function Z(W,bt)
if c(bt)~="table"then
return W
end
for _,bw in ipairs(bt)do
J(W,bw)
end
return W
end
local ai={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function av(O)
return c(O)=="number"and O%1==0 and O>0
end
local function o(b,i)
local a={}if c(b)~="table"then
return a
end
for ap,O in pairs(b)do
local aD=true
if not i then
if ap=="dp"or ap=="dps"or ap=="dp_list"then
aD=false
elseif av(ap)then
aD=false
end
end
if aD then
a[ap]=O
end
end
return a
end
local function aa(b)
if c(b)~="table"then
return false
end
if b.dp~=nil or b.dps~=nil or b.dp_list~=nil or b[1]~=nil then
return true
end
return false
end
local function B(b)
if c(b)~="table"then
return b
end
b.dp=nil
b.dps=nil
b.dp_list=nil
local w=1
while b[w]~=nil do
b[w]=nil
w=w+1
end
return b
end
local function s(b,n,i)
if c(b)~="table"then
return{}
end
local r=b[n]if r==nil then
return o(b,i)
end
local a=o(b,i)if c(r)=="table"then
j(a,r)else
a.dp=r
end
return a
end
local function u(r)
if r==nil then
return nil
end
if c(r)=="table"then
return r
end
return{dp=r}
end
local function S(b,n)
if c(b)~="table"then
return nil
end
return u(b[n])
end
local function at(ar,f)
local H=c(ar)=="table"and ar.item_options or nil
local z=c(f)=="table"and f.item_options or nil
if c(H)~="table"then
return c(z)=="table"and z or nil
end
if c(z)~="table"then
return H
end
local a={}j(a,H)j(a,z)return a
end
local function ae(b,n,y,i)
local a={}local r=nil
if c(b)=="table"then
bm(a,b,ai)r=b[n]if c(r)=="table"then
j(a,o(b,i))if i and aa(r)then
B(a)
end
j(a,r)elseif r~=nil then
j(a,o(b,i))if i then
B(a)
end
a.dp=r
else
j(a,o(b,i))
end
end
if a.key_prefix==nil and y~=nil then
a.key_prefix=y
end
a.item_options=at(b,r)return a
end
local function L(b,l)
local k={}local ao=S(b,"config")j(k,ao)local au=u(k[l])if au~=nil then
k[l]=au
else
local V=u(k.switch_type)if V==nil then
V=S(b,"switch_type")
end
if c(V)=="table"then
k[l]=V
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
local function M(b,l)
local a={}if c(b)=="table"then
j(a,b)
end
local k=L(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aV(b,l)
local a={}if c(b)=="table"then
j(a,b)
end
local R=M(
s(b,"switch_module"),l)if next(R)~=nil then
a.switch_module=R
end
return a
end
local function bl(h,b,n,v)
local f=s(b,n)P(h,f.dp,v,f)
end
local function aB(h,b,n,v,F)
local f=s(b,n)an(f,F)P(h,f.dp,v,f)
end
local function aR(h,b,n,v,ax)
local f=s(b,n)local m=X(f)if m~=nil and ax~=nil then
Z(h,ax(m,f))return
end
P(h,f.dp,v,f)
end
local function aK(h,b,n,y,v)
local f=ae(b,n,y)Z(h,v(ab(f),f))
end
local function bg(m,v,g,b)
local h={}local ah=al(m)local ag=c(b)=="table"and b.item_options or nil
for w,I in ipairs(ah)do
local a=e(ag,nil,g)if a.component==nil then
a.component=af(w,b)
end
if a.key==nil and a.preference==nil then
a.key=aw(w,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
J(h,v(I,a))
end
return h
end
local function aM(m,v,b)
local h={}local ah=al(m)local ag=c(b)=="table"and b.item_options or nil
for w,I in ipairs(ah)do
local a=e(ag,nil,nil)if a.phase==nil then
a.phase=aI(w,b)
end
J(h,v(I,a))
end
return h
end
local function aL(b,n,v)
local f=nil
if c(b)=="table"then
f=s(b,n,true)else
f={dp=b}
end
local h={}P(h,f.dp,v,f)return h
end
function K.dp_battery(I,d,b)
return Y(I,"battery",1,d,b)
end
function K.dp_illuminance(I,d,b)
local a=e(d,b,"illuminance")return K.dp_numeric(I,a)
end
function K.dp_presence(I,d,b)
return K.dp_binary(I,e(d,b,"presence"))
end
end
return aq
