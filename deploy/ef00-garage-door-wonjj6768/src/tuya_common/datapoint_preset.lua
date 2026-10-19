local function aq(C,az,bs)
bs=bs or{switch=function()return nil end}
local d=az.type_check
local L=az.table_insert
local aQ=az.tonumber_check
local j=az.merge_options
local bm=az.copy_keys
local q=C.converter
local function an(X,H)
if d(X)~="table"or d(H)~="table"then
return X
end
for ap,P in pairs(H)do
if X[ap]==nil then
X[ap]=P
end
end
return X
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
local ak={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function aj(b)
if d(b)~="table"then
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
return C.apply_fixed_send_policy(bh)
end
local function aT(I,g,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return C.dp_numeric(I,a)
end
local function A(I,g,x,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return C.dp_numeric(I,a)
end
local function aW(I,g,x,c,b)
local a=e(c,b,g)local t=a.scale
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
return C.dp_numeric(I,a)
end
local function aU(I,g,x,c,b)
local a=e(c,b,g)local t=a.scale
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
return C.dp_numeric(I,a)
end
local function aF(I,g,x,bc,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
end
local br=
a.datatype==C.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aC={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}an(aC,bc)a.converter=q.raw_uint_be(t,aC)if a.datatype==nil then
a.datatype=C.DP_TYPE_RAW
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
return C.dp_numeric(I,a)
end
local function U(P,bp,bo)
local ay=aQ(P)if ay==nil then
return nil
end
return bp+bo-ay
end
local function aS(I,g,H,c,b)
local a=e(c,b,g)local ad=a.raw_min
if ad==nil then
ad=H.raw_min
end
local ac=a.raw_max
if ac==nil then
ac=H.raw_max
end
local F=a.value_min
if F==nil then
F=H.value_min
end
local E=a.value_max
if E==nil then
E=H.value_max
end
local bv=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bv then
local bj=q.scale(ad,ac,F,E)local bt=q.scale(F,E,ad,ac)a.converter=q.from_to(
function(P,aY,aN)
local bq=bj(P,aY,aN)if bq==nil then
return nil
end
return U(bq,F,E)
end,
function(P,aY,aN)
local ba=U(P,F,E)if ba==nil then
return nil
end
return bt(ba,aY,aN)
end
)elseif ad~=F or ac~=E then
a.converter=q.scale_pair(ad,ac,F,E)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return C.dp_numeric(I,a)
end
local function bk(phase,aZ)
if d(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,ap in ipairs(bx or{})do
local aG=ap
if d(phase)=="string"and phase~=""then
aG=ap.."_"..phase
end
bn[aG]=true
end
return bn
end
local function bd(I,g,aP,bi,c,b)
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
a.converter=aP(a)
end
if a.field==nil and a.fields==nil then
a.fields=bb(bi,phase)
end
return C.dp_raw(I,a)
end
local function be(I,c,b)
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
return C.dp_raw(I,a)
end
local function al(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aH={}for _,I in ipairs(m)do
if d(I)=="number"and I%1==0 and I>=0 then
L(aH,I)
end
end
return aH
end
local function Y(b)
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
local function ab(b)
local m=Y(b)if m~=nil then
return m
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aI(w,b)
b=b or{}local aJ=b.phases
if d(aJ)~="table"then
aJ=b.phase_names
end
local phase=d(aJ)=="table"and aJ[w]or nil
if d(phase)=="string"and phase~=""then
return phase
end
local B=b.phase_prefix
if B==false then
return nil
end
if d(B)~="string"or B==""then
B=nil
end
if B~=nil then
return B..tostring(w)
end
return tostring(w)
end
local function af(w,b)
b=b or{}local J=b.first_is_main~=false
local G=b.component_prefix
if d(G)~="string"or G==""then
G="switch"
end
local O=b.main_component
if d(O)~="string"or O==""then
O="main"
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and J then
return O
end
local aA=J and(w-1+p)or(w+p)if aA<1 then
return b.default_component
end
return G..tostring(aA)
end
local function aw(w,b,aO)
b=b or{}local J=b.first_is_main~=false
local V=b.key_prefix
if d(V)~="string"or V==""then
V=aO or"switch"
end
local as=b.main_key
if d(as)~="string"or as==""then
as=V
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and J then
return as
end
local aA=J and(w-1+p)or(w+p)if aA<1 then
return b.default_key
end
return V..tostring(aA)
end
local function Q(h,I,v,b)
if d(I)~="number"or I%1~=0 or I<0 then
return
end
L(h,v(I,b))
end
local function Z(X,bu)
if d(bu)~="table"then
return X
end
for _,bw in ipairs(bu)do
L(X,bw)
end
return X
end
local ai={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function av(P)
return d(P)=="number"and P%1==0 and P>0
end
local function o(b,i)
local a={}if d(b)~="table"then
return a
end
for ap,P in pairs(b)do
local aD=true
if not i then
if ap=="dp"or ap=="dps"or ap=="dp_list"then
aD=false
elseif av(ap)then
aD=false
end
end
if aD then
a[ap]=P
end
end
return a
end
local function aa(b)
if d(b)~="table"then
return false
end
if b.dp~=nil or b.dps~=nil or b.dp_list~=nil or b[1]~=nil then
return true
end
return false
end
local function D(b)
if d(b)~="table"then
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
if d(b)~="table"then
return{}
end
local r=b[n]if r==nil then
return o(b,i)
end
local a=o(b,i)if d(r)=="table"then
j(a,r)else
a.dp=r
end
return a
end
local function u(r)
if r==nil then
return nil
end
if d(r)=="table"then
return r
end
return{dp=r}
end
local function T(b,n)
if d(b)~="table"then
return nil
end
return u(b[n])
end
local function at(ar,f)
local K=d(ar)=="table"and ar.item_options or nil
local z=d(f)=="table"and f.item_options or nil
if d(K)~="table"then
return d(z)=="table"and z or nil
end
if d(z)~="table"then
return K
end
local a={}j(a,K)j(a,z)return a
end
local function ae(b,n,y,i)
local a={}local r=nil
if d(b)=="table"then
bm(a,b,ai)r=b[n]if d(r)=="table"then
j(a,o(b,i))if i and aa(r)then
D(a)
end
j(a,r)elseif r~=nil then
j(a,o(b,i))if i then
D(a)
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
local function M(b,l)
local k={}local ao=T(b,"config")j(k,ao)local au=u(k[l])if au~=nil then
k[l]=au
else
local W=u(k.switch_type)if W==nil then
W=T(b,"switch_type")
end
if d(W)=="table"then
k[l]=W
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
local function N(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local k=M(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aV(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local S=N(
s(b,"switch_module"),l)if next(S)~=nil then
a.switch_module=S
end
return a
end
local function bl(h,b,n,v)
local f=s(b,n)Q(h,f.dp,v,f)
end
local function aB(h,b,n,v,H)
local f=s(b,n)an(f,H)Q(h,f.dp,v,f)
end
local function aR(h,b,n,v,ax)
local f=s(b,n)local m=Y(f)if m~=nil and ax~=nil then
Z(h,ax(m,f))return
end
Q(h,f.dp,v,f)
end
local function aK(h,b,n,y,v)
local f=ae(b,n,y)Z(h,v(ab(f),f))
end
local function bg(m,v,g,b)
local h={}local ah=al(m)local ag=d(b)=="table"and b.item_options or nil
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
L(h,v(I,a))
end
return h
end
local function aM(m,v,b)
local h={}local ah=al(m)local ag=d(b)=="table"and b.item_options or nil
for w,I in ipairs(ah)do
local a=e(ag,nil,nil)if a.phase==nil then
a.phase=aI(w,b)
end
L(h,v(I,a))
end
return h
end
local function aL(b,n,v)
local f=nil
if d(b)=="table"then
f=s(b,n,true)else
f={dp=b}
end
local h={}Q(h,f.dp,v,f)return h
end
function C.dp_on_off(I,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return C.dp_binary(I,a)
end
function C.dp_battery(I,c,b)
return A(I,"battery",1,c,b)
end
function C.dp_occupancy(I,c,b)
local a=e(c,b,"occupancy")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=q.true_false0()
end
return C.dp_binary(I,a)
end
function C.dp_illuminance(I,c,b)
local a=e(c,b,"illuminance")return C.dp_numeric(I,a)
end
function C.dp_countdown(I,c,b)
return A(I,"countdown",1,c,b)
end
end
return aq
