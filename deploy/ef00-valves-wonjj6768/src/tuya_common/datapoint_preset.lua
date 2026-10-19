local function as(z,aB,bs)
bs=bs or{switch=function()return nil end}
local d=aB.type_check
local M=aB.table_insert
local aR=aB.tonumber_check
local j=aB.merge_options
local bm=aB.copy_keys
local q=z.converter
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
return z.apply_fixed_send_policy(bh)
end
local function ab(A,g,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=q.divide_by_pair(u)
end
a.scale=nil
return z.dp_numeric(A,a)
end
local function D(A,g,y,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=q.divide_by_pair(u)
end
a.scale=nil
return z.dp_numeric(A,a)
end
local function aW(A,g,y,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ao=q.power()local bf=ao.from
if u~=1 then
a.from_device=q.pipe(
bf,q.divide_by(u))else
a.converter=ao
end
end
a.scale=nil
return z.dp_numeric(A,a)
end
local function aU(A,g,y,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.signed_number_pair(u)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return z.dp_numeric(A,a)
end
local function o(A,g,y,bc,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=y
end
local br=
a.datatype==z.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aE={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ap(aE,bc)a.converter=q.raw_uint_be(u,aE)if a.datatype==nil then
a.datatype=z.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=q.divide_by_pair(u)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return z.dp_numeric(A,a)
end
local function V(Q,bp,bo)
local aA=aR(Q)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aT(A,g,J,c,b)
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
local bj=q.scale(af,ae,H,G)local bt=q.scale(H,G,af,ae)a.converter=q.from_to(
function(Q,aY,aO)
local bq=bj(Q,aY,aO)if bq==nil then
return nil
end
return V(bq,H,G)
end,
function(Q,aY,aO)
local ba=V(Q,H,G)if ba==nil then
return nil
end
return bt(ba,aY,aO)
end
)elseif af~=H or ae~=G then
a.converter=q.scale_pair(af,ae,H,G)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return z.dp_numeric(A,a)
end
local function bk(phase,aZ)
if d(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,ar in ipairs(bx or{})do
local aH=ar
if d(phase)=="string"and phase~=""then
aH=ar.."_"..phase
end
bn[aH]=true
end
return bn
end
local function bd(A,g,aQ,bi,c,b)
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
return z.dp_raw(A,a)
end
local function be(A,c,b)
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
return z.dp_raw(A,a)
end
local function an(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aI={}for _,A in ipairs(m)do
if d(A)=="number"and A%1==0 and A>=0 then
M(aI,A)
end
end
return aI
end
local function Z(b)
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
local function ad(b)
local m=Z(b)if m~=nil then
return m
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aJ(x,b)
b=b or{}local aK=b.phases
if d(aK)~="table"then
aK=b.phase_names
end
local phase=d(aK)=="table"and aK[x]or nil
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
return E..tostring(x)
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
local r=b.index_offset
if d(r)~="number"or r%1~=0 then
r=0
end
if x==1 and K then
return P
end
local aC=K and(x-1+r)or(x+r)if aC<1 then
return b.default_component
end
return I..tostring(aC)
end
local function ay(x,b,aP)
b=b or{}local K=b.first_is_main~=false
local W=b.key_prefix
if d(W)~="string"or W==""then
W=aP or"switch"
end
local au=b.main_key
if d(au)~="string"or au==""then
au=W
end
local r=b.index_offset
if d(r)~="number"or r%1~=0 then
r=0
end
if x==1 and K then
return au
end
local aC=K and(x-1+r)or(x+r)if aC<1 then
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
local function t(b,n,i)
if d(b)~="table"then
return{}
end
local s=b[n]if s==nil then
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
local function U(b,n)
if d(b)~="table"then
return nil
end
return v(b[n])
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
local function ag(b,n,B,i)
local a={}local s=nil
if d(b)=="table"then
bm(a,b,ak)s=b[n]if d(s)=="table"then
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
local function N(b,l)
local k={}local aq=U(b,"config")j(k,aq)local aw=v(k[l])if aw~=nil then
k[l]=aw
else
local X=v(k.switch_type)if X==nil then
X=U(b,"switch_type")
end
if d(X)=="table"then
k[l]=X
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
local function O(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local k=N(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aV(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local T=O(
t(b,"switch_module"),l)if next(T)~=nil then
a.switch_module=T
end
return a
end
local function bl(h,b,n,w)
local f=t(b,n)R(h,f.dp,w,f)
end
local function aD(h,b,n,w,J)
local f=t(b,n)ap(f,J)R(h,f.dp,w,f)
end
local function aS(h,b,n,w,az)
local f=t(b,n)local m=Z(f)if m~=nil and az~=nil then
aa(h,az(m,f))return
end
R(h,f.dp,w,f)
end
local function aL(h,b,n,B,w)
local f=ag(b,n,B)aa(h,w(ad(f),f))
end
local function bg(m,w,g,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
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
local function aN(m,w,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
for x,A in ipairs(aj)do
local a=e(ai,nil,nil)if a.phase==nil then
a.phase=aJ(x,b)
end
M(h,w(A,a))
end
return h
end
local function aM(b,n,w)
local f=nil
if d(b)=="table"then
f=t(b,n,true)else
f={dp=b}
end
local h={}R(h,f.dp,w,f)return h
end
function z.dp_on_off(A,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return z.dp_binary(A,a)
end
function z.dp_temperature(A,c,b)
return ab(A,"temperature",c,b)
end
function z.dp_battery(A,c,b)
return D(A,"battery",1,c,b)
end
function z.dp_reverse_water_consumed(A,c,b)
return o(
A,"reverse_water_consumed",1000,{bytes=4},c,b)
end
function z.dp_month_consumption(A,c,b)
return o(
A,"month_consumption",1000,{bytes=4,from_tail=true},c,b)
end
function z.dp_daily_consumption(A,c,b)
return o(
A,"daily_consumption",1000,{bytes=4,from_tail=true},c,b)
end
function z.dp_flow_rate(A,c,b)
return o(
A,"flow_rate",1000,{bytes=4},c,b)
end
function z.dp_battery_voltage(A,c,b)
return D(A,"battery_voltage",100,c,b)
end
function z.dp_meter_id(A,c,b)
local a=e(c,b,"meter_id")if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.raw_identifier()
end
return z.dp_raw(A,a)
end
function z.dp_water_meter_faults(A,c,b)
local a=e(c,b,"faults")if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.water_meter_faults()
end
return z.dp_numeric(A,a)
end
end
return as
