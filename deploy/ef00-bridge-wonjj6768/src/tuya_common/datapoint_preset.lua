local function ap(W,ay,bs)
bs=bs or{switch=function()return nil end}
local c=ay.type_check
local I=ay.table_insert
local aQ=ay.tonumber_check
local j=ay.merge_options
local bm=ay.copy_keys
local q=W.converter
local function am(V,F)
if c(V)~="table"or c(F)~="table"then
return V
end
for ao,M in pairs(F)do
if V[ao]==nil then
V[ao]=M
end
end
return V
end
local function f(d,b,g)
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
local aj={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function ai(b)
if c(b)~="table"then
return false
end
for _,ao in ipairs(aj)do
if b[ao]~=nil then
return true
end
end
return false
end
local function aD(bh,b)
if ai(b)then
return bh
end
return W.apply_fixed_send_policy(bh)
end
local function aT(P,g,d,b)
local a=f(d,b,g)local t=a.scale
if t==nil then
t=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return W.dp_numeric(P,a)
end
local function aL(P,g,x,d,b)
local a=f(d,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return W.dp_numeric(P,a)
end
local function aW(P,g,x,d,b)
local a=f(d,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local al=q.power()local bf=al.from
if t~=1 then
a.from_device=q.pipe(
bf,q.divide_by(t))else
a.converter=al
end
end
a.scale=nil
return W.dp_numeric(P,a)
end
local function aU(P,g,x,d,b)
local a=f(d,b,g)local t=a.scale
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
return W.dp_numeric(P,a)
end
local function aE(P,g,x,bc,d,b)
local a=f(d,b,g)local t=a.scale
if t==nil then
t=x
end
local br=
a.datatype==W.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aB={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}am(aB,bc)a.converter=q.raw_uint_be(t,aB)if a.datatype==nil then
a.datatype=W.DP_TYPE_RAW
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
return W.dp_numeric(P,a)
end
local function S(M,bp,bo)
local ax=aQ(M)if ax==nil then
return nil
end
return bp+bo-ax
end
local function aS(P,g,F,d,b)
local a=f(d,b,g)local ac=a.raw_min
if ac==nil then
ac=F.raw_min
end
local ab=a.raw_max
if ab==nil then
ab=F.raw_max
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
local bj=q.scale(ac,ab,D,C)local bt=q.scale(D,C,ac,ab)a.converter=q.from_to(
function(M,aY,aN)
local bq=bj(M,aY,aN)if bq==nil then
return nil
end
return S(bq,D,C)
end,
function(M,aY,aN)
local ba=S(M,D,C)if ba==nil then
return nil
end
return bt(ba,aY,aN)
end
)elseif ac~=D or ab~=C then
a.converter=q.scale_pair(ac,ab,D,C)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return W.dp_numeric(P,a)
end
local function bk(phase,aZ)
if c(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,ao in ipairs(bx or{})do
local aF=ao
if c(phase)=="string"and phase~=""then
aF=ao.."_"..phase
end
bn[aF]=true
end
return bn
end
local function bd(P,g,aP,bi,d,b)
local aX=
c(d)=="string"or
(c(d)=="table"and d.name~=nil)or
(c(b)=="table"and b.name~=nil)local a=f(d,b,g)local phase=a.phase
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
return W.dp_raw(P,a)
end
local function be(P,d,b)
local a=f(d,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return W.dp_raw(P,a)
end
local function ak(m)
if c(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if c(m)~="table"then
return{}
end
local aG={}for _,P in ipairs(m)do
if c(P)=="number"and P%1==0 and P>=0 then
I(aG,P)
end
end
return aG
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
local function aa(b)
local m=X(b)if m~=nil then
return m
end
if c(b)~="table"then
return b
end
return b.dp
end
local function aH(w,b)
b=b or{}local aI=b.phases
if c(aI)~="table"then
aI=b.phase_names
end
local phase=c(aI)=="table"and aI[w]or nil
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
local function ae(w,b)
b=b or{}local G=b.first_is_main~=false
local E=b.component_prefix
if c(E)~="string"or E==""then
E="switch"
end
local L=b.main_component
if c(L)~="string"or L==""then
L="main"
end
local p=b.index_offset
if c(p)~="number"or p%1~=0 then
p=0
end
if w==1 and G then
return L
end
local az=G and(w-1+p)or(w+p)if az<1 then
return b.default_component
end
return E..tostring(az)
end
local function av(w,b,aO)
b=b or{}local G=b.first_is_main~=false
local T=b.key_prefix
if c(T)~="string"or T==""then
T=aO or"switch"
end
local ar=b.main_key
if c(ar)~="string"or ar==""then
ar=T
end
local p=b.index_offset
if c(p)~="number"or p%1~=0 then
p=0
end
if w==1 and G then
return ar
end
local az=G and(w-1+p)or(w+p)if az<1 then
return b.default_key
end
return T..tostring(az)
end
local function N(h,P,v,b)
if c(P)~="number"or P%1~=0 or P<0 then
return
end
I(h,v(P,b))
end
local function Y(V,bu)
if c(bu)~="table"then
return V
end
for _,bw in ipairs(bu)do
I(V,bw)
end
return V
end
local ah={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function au(M)
return c(M)=="number"and M%1==0 and M>0
end
local function o(b,i)
local a={}if c(b)~="table"then
return a
end
for ao,M in pairs(b)do
local aC=true
if not i then
if ao=="dp"or ao=="dps"or ao=="dp_list"then
aC=false
elseif au(ao)then
aC=false
end
end
if aC then
a[ao]=M
end
end
return a
end
local function Z(b)
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
local function R(b,n)
if c(b)~="table"then
return nil
end
return u(b[n])
end
local function as(aq,e)
local H=c(aq)=="table"and aq.item_options or nil
local z=c(e)=="table"and e.item_options or nil
if c(H)~="table"then
return c(z)=="table"and z or nil
end
if c(z)~="table"then
return H
end
local a={}j(a,H)j(a,z)return a
end
local function ad(b,n,y,i)
local a={}local r=nil
if c(b)=="table"then
bm(a,b,ah)r=b[n]if c(r)=="table"then
j(a,o(b,i))if i and Z(r)then
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
a.item_options=as(b,r)return a
end
local function J(b,l)
local k={}local an=R(b,"config")j(k,an)local at=u(k[l])if at~=nil then
k[l]=at
else
local U=u(k.switch_type)if U==nil then
U=R(b,"switch_type")
end
if c(U)=="table"then
k[l]=U
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
local function K(b,l)
local a={}if c(b)=="table"then
j(a,b)
end
local k=J(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aV(b,l)
local a={}if c(b)=="table"then
j(a,b)
end
local Q=K(
s(b,"switch_module"),l)if next(Q)~=nil then
a.switch_module=Q
end
return a
end
local function bl(h,b,n,v)
local e=s(b,n)N(h,e.dp,v,e)
end
local function aA(h,b,n,v,F)
local e=s(b,n)am(e,F)N(h,e.dp,v,e)
end
local function aR(h,b,n,v,aw)
local e=s(b,n)local m=X(e)if m~=nil and aw~=nil then
Y(h,aw(m,e))return
end
N(h,e.dp,v,e)
end
local function aJ(h,b,n,y,v)
local e=ad(b,n,y)Y(h,v(aa(e),e))
end
local function bg(m,v,g,b)
local h={}local ag=ak(m)local af=c(b)=="table"and b.item_options or nil
for w,P in ipairs(ag)do
local a=f(af,nil,g)if a.component==nil then
a.component=ae(w,b)
end
if a.key==nil and a.preference==nil then
a.key=av(w,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
I(h,v(P,a))
end
return h
end
local function aM(m,v,b)
local h={}local ag=ak(m)local af=c(b)=="table"and b.item_options or nil
for w,P in ipairs(ag)do
local a=f(af,nil,nil)if a.phase==nil then
a.phase=aH(w,b)
end
I(h,v(P,a))
end
return h
end
local function aK(b,n,v)
local e=nil
if c(b)=="table"then
e=s(b,n,true)else
e={dp=b}
end
local h={}N(h,e.dp,v,e)return h
end
function W.dp_on_off(P,d,b)
local a=f(d,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return W.dp_binary(P,a)
end
end
return ap
