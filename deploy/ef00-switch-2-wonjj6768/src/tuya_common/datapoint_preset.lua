local function as(y,aB,bs)
bs=bs or{switch=function()return nil end}
local d=aB.type_check
local M=aB.table_insert
local aS=aB.tonumber_check
local j=aB.merge_options
local bm=aB.copy_keys
local r=y.converter
local function ap(Y,J)
if d(Y)~="table"or d(J)~="table"then
return Y
end
for ar,Q in pairs(J)do
if Y[ar]==nil then
Y[ar]=Q
end
end
return Y
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
return y.apply_fixed_send_policy(bh)
end
local function E(A,g,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=r.divide_by_pair(u)
end
a.scale=nil
return y.dp_numeric(A,a)
end
local function k(A,g,z,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=z
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=r.divide_by_pair(u)
end
a.scale=nil
return y.dp_numeric(A,a)
end
local function ab(A,g,z,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=z
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ao=r.power()local bf=ao.from
if u~=1 then
a.from_device=r.pipe(
bf,r.divide_by(u))else
a.converter=ao
end
end
a.scale=nil
return y.dp_numeric(A,a)
end
local function aV(A,g,z,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=z
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=r.signed_number_pair(u)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return y.dp_numeric(A,a)
end
local function aH(A,g,z,bc,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=z
end
local br=
a.datatype==y.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aE={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ap(aE,bc)a.converter=r.raw_uint_be(u,aE)if a.datatype==nil then
a.datatype=y.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=r.divide_by_pair(u)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return y.dp_numeric(A,a)
end
local function V(Q,bp,bo)
local aA=aS(Q)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aU(A,g,J,c,b)
local a=e(c,b,g)local af=a.raw_min
if af==nil then
af=J.raw_min
end
local ae=a.raw_max
if ae==nil then
ae=J.raw_max
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
local bj=r.scale(af,ae,H,G)local bt=r.scale(H,G,af,ae)a.converter=r.from_to(
function(Q,aY,aP)
local bq=bj(Q,aY,aP)if bq==nil then
return nil
end
return V(bq,H,G)
end,
function(Q,aY,aP)
local ba=V(Q,H,G)if ba==nil then
return nil
end
return bt(ba,aY,aP)
end
)elseif af~=H or ae~=G then
a.converter=r.scale_pair(af,ae,H,G)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return y.dp_numeric(A,a)
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
local function bd(A,g,aR,bi,c,b)
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
return y.dp_raw(A,a)
end
local function be(A,c,b)
local a=e(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=r.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return y.dp_raw(A,a)
end
local function an(n)
if d(n)=="number"and n%1==0 and n>=0 then
return{n}
end
if d(n)~="table"then
return{}
end
local aJ={}for _,A in ipairs(n)do
if d(A)=="number"and A%1==0 and A>=0 then
M(aJ,A)
end
end
return aJ
end
local function Z(b)
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
local n=Z(b)if n~=nil then
return n
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aK(x,b)
b=b or{}local aL=b.phases
if d(aL)~="table"then
aL=b.phase_names
end
local phase=d(aL)=="table"and aL[x]or nil
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
return D..tostring(x)
end
return tostring(x)
end
local function ah(x,b)
b=b or{}local K=b.first_is_main~=false
local I=b.component_prefix
if d(I)~="string"or I==""then
I="switch"
end
local P=b.main_component
if d(P)~="string"or P==""then
P="main"
end
local q=b.index_offset
if d(q)~="number"or q%1~=0 then
q=0
end
if x==1 and K then
return P
end
local aC=K and(x-1+q)or(x+q)if aC<1 then
return b.default_component
end
return I..tostring(aC)
end
local function ay(x,b,aQ)
b=b or{}local K=b.first_is_main~=false
local W=b.key_prefix
if d(W)~="string"or W==""then
W=aQ or"switch"
end
local au=b.main_key
if d(au)~="string"or au==""then
au=W
end
local q=b.index_offset
if d(q)~="number"or q%1~=0 then
q=0
end
if x==1 and K then
return au
end
local aC=K and(x-1+q)or(x+q)if aC<1 then
return b.default_key
end
return W..tostring(aC)
end
local function R(h,A,w,b)
if d(A)~="number"or A%1~=0 or A<0 then
return
end
M(h,w(A,b))
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
local ak={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ax(Q)
return d(Q)=="number"and Q%1==0 and Q>0
end
local function p(b,i)
local a={}if d(b)~="table"then
return a
end
for ar,Q in pairs(b)do
local aF=true
if not i then
if ar=="dp"or ar=="dps"or ar=="dp_list"then
aF=false
elseif ax(ar)then
aF=false
end
end
if aF then
a[ar]=Q
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
local function F(b)
if d(b)~="table"then
return b
end
b.dp=nil
b.dps=nil
b.dp_list=nil
local x=1
while b[x]~=nil do
b[x]=nil
x=x+1
end
return b
end
local function t(b,o,i)
if d(b)~="table"then
return{}
end
local s=b[o]if s==nil then
return p(b,i)
end
local a=p(b,i)if d(s)=="table"then
j(a,s)else
a.dp=s
end
return a
end
local function v(s)
if s==nil then
return nil
end
if d(s)=="table"then
return s
end
return{dp=s}
end
local function U(b,o)
if d(b)~="table"then
return nil
end
return v(b[o])
end
local function av(at,f)
local L=d(at)=="table"and at.item_options or nil
local C=d(f)=="table"and f.item_options or nil
if d(L)~="table"then
return d(C)=="table"and C or nil
end
if d(C)~="table"then
return L
end
local a={}j(a,L)j(a,C)return a
end
local function ag(b,o,B,i)
local a={}local s=nil
if d(b)=="table"then
bm(a,b,ak)s=b[o]if d(s)=="table"then
j(a,p(b,i))if i and ac(s)then
F(a)
end
j(a,s)elseif s~=nil then
j(a,p(b,i))if i then
F(a)
end
a.dp=s
else
j(a,p(b,i))
end
end
if a.key_prefix==nil and B~=nil then
a.key_prefix=B
end
a.item_options=av(b,s)return a
end
local function N(b,m)
local l={}local aq=U(b,"config")j(l,aq)local aw=v(l[m])if aw~=nil then
l[m]=aw
else
local X=v(l.switch_type)if X==nil then
X=U(b,"switch_type")
end
if d(X)=="table"then
l[m]=X
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
local function O(b,m)
local a={}if d(b)=="table"then
j(a,b)
end
local l=N(b,m)if next(l)~=nil then
a.config=l
end
a.switch_type=nil
return a
end
local function aW(b,m)
local a={}if d(b)=="table"then
j(a,b)
end
local T=O(
t(b,"switch_module"),m)if next(T)~=nil then
a.switch_module=T
end
return a
end
local function bl(h,b,o,w)
local f=t(b,o)R(h,f.dp,w,f)
end
local function aD(h,b,o,w,J)
local f=t(b,o)ap(f,J)R(h,f.dp,w,f)
end
local function aT(h,b,o,w,az)
local f=t(b,o)local n=Z(f)if n~=nil and az~=nil then
aa(h,az(n,f))return
end
R(h,f.dp,w,f)
end
local function aM(h,b,o,B,w)
local f=ag(b,o,B)aa(h,w(ad(f),f))
end
local function bg(n,w,g,b)
local h={}local aj=an(n)local ai=d(b)=="table"and b.item_options or nil
for x,A in ipairs(aj)do
local a=e(ai,nil,g)if a.component==nil then
a.component=ah(x,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(x,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
M(h,w(A,a))
end
return h
end
local function aO(n,w,b)
local h={}local aj=an(n)local ai=d(b)=="table"and b.item_options or nil
for x,A in ipairs(aj)do
local a=e(ai,nil,nil)if a.phase==nil then
a.phase=aK(x,b)
end
M(h,w(A,a))
end
return h
end
local function aN(b,o,w)
local f=nil
if d(b)=="table"then
f=t(b,o,true)else
f={dp=b}
end
local h={}R(h,f.dp,w,f)return h
end
function y.dp_on_off(A,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return y.dp_binary(A,a)
end
function y.dp_temperature(A,c,b)
return E(A,"temperature",c,b)
end
function y.dp_humidity(A,c,b)
return E(A,"humidity",c,b)
end
function y.dp_battery(A,c,b)
return k(A,"battery",1,c,b)
end
function y.dp_occupancy(A,c,b)
local a=e(c,b,"occupancy")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=r.true_false0()
end
return y.dp_binary(A,a)
end
function y.dp_illuminance(A,c,b)
local a=e(c,b,"illuminance")return y.dp_numeric(A,a)
end
function y.dp_voltage(A,c,b)
return k(A,"voltage",10,c,b)
end
function y.dp_current(A,c,b)
return k(A,"current",1000,c,b)
end
function y.dp_power(A,c,b)
return ab(A,"power",10,c,b)
end
function y.dp_energy(A,c,b)
return k(A,"energy",100,c,b)
end
function y.dp_countdown(A,c,b)
return k(A,"countdown",1,c,b)
end
end
return as
