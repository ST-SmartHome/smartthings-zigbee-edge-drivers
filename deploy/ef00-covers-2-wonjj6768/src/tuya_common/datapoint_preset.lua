local function ar(B,aA,bs)
bs=bs or{switch=function()return nil end}
local d=aA.type_check
local K=aA.table_insert
local aR=aA.tonumber_check
local j=aA.merge_options
local bm=aA.copy_keys
local q=B.converter
local function ao(W,G)
if d(W)~="table"or d(G)~="table"then
return W
end
for aq,O in pairs(G)do
if W[aq]==nil then
W[aq]=O
end
end
return W
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
local al={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function ak(b)
if d(b)~="table"then
return false
end
for _,aq in ipairs(al)do
if b[aq]~=nil then
return true
end
end
return false
end
local function aF(bh,b)
if ak(b)then
return bh
end
return B.apply_fixed_send_policy(bh)
end
local function aT(H,g,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return B.dp_numeric(H,a)
end
local function Y(H,g,x,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return B.dp_numeric(H,a)
end
local function aW(H,g,x,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local an=q.power()local bf=an.from
if t~=1 then
a.from_device=q.pipe(
bf,q.divide_by(t))else
a.converter=an
end
end
a.scale=nil
return B.dp_numeric(H,a)
end
local function aU(H,g,x,c,b)
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
return B.dp_numeric(H,a)
end
local function aG(H,g,x,bc,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
end
local br=
a.datatype==B.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aD={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ao(aD,bc)a.converter=q.raw_uint_be(t,aD)if a.datatype==nil then
a.datatype=B.DP_TYPE_RAW
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
return B.dp_numeric(H,a)
end
local function T(O,bp,bo)
local az=aR(O)if az==nil then
return nil
end
return bp+bo-az
end
local function aa(H,g,G,c,b)
local a=e(c,b,g)local ae=a.raw_min
if ae==nil then
ae=G.raw_min
end
local ad=a.raw_max
if ad==nil then
ad=G.raw_max
end
local E=a.value_min
if E==nil then
E=G.value_min
end
local D=a.value_max
if D==nil then
D=G.value_max
end
local bv=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bv then
local bj=q.scale(ae,ad,E,D)local bt=q.scale(E,D,ae,ad)a.converter=q.from_to(
function(O,aY,aO)
local bq=bj(O,aY,aO)if bq==nil then
return nil
end
return T(bq,E,D)
end,
function(O,aY,aO)
local ba=T(O,E,D)if ba==nil then
return nil
end
return bt(ba,aY,aO)
end
)elseif ae~=E or ad~=D then
a.converter=q.scale_pair(ae,ad,E,D)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return B.dp_numeric(H,a)
end
local function bk(phase,aZ)
if d(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,aq in ipairs(bx or{})do
local aH=aq
if d(phase)=="string"and phase~=""then
aH=aq.."_"..phase
end
bn[aH]=true
end
return bn
end
local function bd(H,g,aQ,bi,c,b)
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
a.converter=aQ(a)
end
if a.field==nil and a.fields==nil then
a.fields=bb(bi,phase)
end
return B.dp_raw(H,a)
end
local function be(H,c,b)
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
return B.dp_raw(H,a)
end
local function am(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aI={}for _,H in ipairs(m)do
if d(H)=="number"and H%1==0 and H>=0 then
K(aI,H)
end
end
return aI
end
local function X(b)
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
local function ac(b)
local m=X(b)if m~=nil then
return m
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aJ(w,b)
b=b or{}local aK=b.phases
if d(aK)~="table"then
aK=b.phase_names
end
local phase=d(aK)=="table"and aK[w]or nil
if d(phase)=="string"and phase~=""then
return phase
end
local A=b.phase_prefix
if A==false then
return nil
end
if d(A)~="string"or A==""then
A=nil
end
if A~=nil then
return A..tostring(w)
end
return tostring(w)
end
local function ag(w,b)
b=b or{}local I=b.first_is_main~=false
local F=b.component_prefix
if d(F)~="string"or F==""then
F="switch"
end
local N=b.main_component
if d(N)~="string"or N==""then
N="main"
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and I then
return N
end
local aB=I and(w-1+p)or(w+p)if aB<1 then
return b.default_component
end
return F..tostring(aB)
end
local function ax(w,b,aP)
b=b or{}local I=b.first_is_main~=false
local U=b.key_prefix
if d(U)~="string"or U==""then
U=aP or"switch"
end
local at=b.main_key
if d(at)~="string"or at==""then
at=U
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and I then
return at
end
local aB=I and(w-1+p)or(w+p)if aB<1 then
return b.default_key
end
return U..tostring(aB)
end
local function P(h,H,v,b)
if d(H)~="number"or H%1~=0 or H<0 then
return
end
K(h,v(H,b))
end
local function Z(W,bu)
if d(bu)~="table"then
return W
end
for _,bw in ipairs(bu)do
K(W,bw)
end
return W
end
local aj={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function aw(O)
return d(O)=="number"and O%1==0 and O>0
end
local function o(b,i)
local a={}if d(b)~="table"then
return a
end
for aq,O in pairs(b)do
local aE=true
if not i then
if aq=="dp"or aq=="dps"or aq=="dp_list"then
aE=false
elseif aw(aq)then
aE=false
end
end
if aE then
a[aq]=O
end
end
return a
end
local function ab(b)
if d(b)~="table"then
return false
end
if b.dp~=nil or b.dps~=nil or b.dp_list~=nil or b[1]~=nil then
return true
end
return false
end
local function C(b)
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
local function S(b,n)
if d(b)~="table"then
return nil
end
return u(b[n])
end
local function au(as,f)
local J=d(as)=="table"and as.item_options or nil
local z=d(f)=="table"and f.item_options or nil
if d(J)~="table"then
return d(z)=="table"and z or nil
end
if d(z)~="table"then
return J
end
local a={}j(a,J)j(a,z)return a
end
local function af(b,n,y,i)
local a={}local r=nil
if d(b)=="table"then
bm(a,b,aj)r=b[n]if d(r)=="table"then
j(a,o(b,i))if i and ab(r)then
C(a)
end
j(a,r)elseif r~=nil then
j(a,o(b,i))if i then
C(a)
end
a.dp=r
else
j(a,o(b,i))
end
end
if a.key_prefix==nil and y~=nil then
a.key_prefix=y
end
a.item_options=au(b,r)return a
end
local function L(b,l)
local k={}local ap=S(b,"config")j(k,ap)local av=u(k[l])if av~=nil then
k[l]=av
else
local V=u(k.switch_type)if V==nil then
V=S(b,"switch_type")
end
if d(V)=="table"then
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
local a={}if d(b)=="table"then
j(a,b)
end
local k=L(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aV(b,l)
local a={}if d(b)=="table"then
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
local function aC(h,b,n,v,G)
local f=s(b,n)ao(f,G)P(h,f.dp,v,f)
end
local function aS(h,b,n,v,ay)
local f=s(b,n)local m=X(f)if m~=nil and ay~=nil then
Z(h,ay(m,f))return
end
P(h,f.dp,v,f)
end
local function aL(h,b,n,y,v)
local f=af(b,n,y)Z(h,v(ac(f),f))
end
local function bg(m,v,g,b)
local h={}local ai=am(m)local ah=d(b)=="table"and b.item_options or nil
for w,H in ipairs(ai)do
local a=e(ah,nil,g)if a.component==nil then
a.component=ag(w,b)
end
if a.key==nil and a.preference==nil then
a.key=ax(w,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
K(h,v(H,a))
end
return h
end
local function aN(m,v,b)
local h={}local ai=am(m)local ah=d(b)=="table"and b.item_options or nil
for w,H in ipairs(ai)do
local a=e(ah,nil,nil)if a.phase==nil then
a.phase=aJ(w,b)
end
K(h,v(H,a))
end
return h
end
local function aM(b,n,v)
local f=nil
if d(b)=="table"then
f=s(b,n,true)else
f={dp=b}
end
local h={}P(h,f.dp,v,f)return h
end
function B.dp_on_off(H,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return B.dp_binary(H,a)
end
function B.dp_battery(H,c,b)
return Y(H,"battery",1,c,b)
end
function B.dp_illuminance(H,c,b)
local a=e(c,b,"illuminance")return B.dp_numeric(H,a)
end
function B.dp_cover_position(H,c,b)
return aa(
H,"cover_position",{raw_min=0,raw_max=100,value_min=0,value_max=100},c,b)
end
function B.dp_cover_position_inverted(H,c,b)
local a=e(c,b,"cover_position")if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.cover_position_inverted()
end
return B.dp_numeric(H,a)
end
end
return ar
