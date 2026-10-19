local function as(z,aB,bs)
bs=bs or{switch=function()return nil end}
local d=aB.type_check
local L=aB.table_insert
local aR=aB.tonumber_check
local j=aB.merge_options
local bm=aB.copy_keys
local p=z.converter
local function ap(Y,I)
if d(Y)~="table"or d(I)~="table"then
return Y
end
for ar,P in pairs(I)do
if Y[ar]==nil then
Y[ar]=P
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
local function T(bh,b)
if al(b)then
return bh
end
return z.apply_fixed_send_policy(bh)
end
local function aU(C,g,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=p.divide_by_pair(t)
end
a.scale=nil
return z.dp_numeric(C,a)
end
local function v(C,g,y,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=p.divide_by_pair(t)
end
a.scale=nil
return z.dp_numeric(C,a)
end
local function ab(C,g,y,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ao=p.power()local bf=ao.from
if t~=1 then
a.from_device=p.pipe(
bf,p.divide_by(t))else
a.converter=ao
end
end
a.scale=nil
return z.dp_numeric(C,a)
end
local function aV(C,g,y,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=p.signed_number_pair(t)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return z.dp_numeric(C,a)
end
local function aG(C,g,y,bc,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=y
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
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ap(aE,bc)a.converter=p.raw_uint_be(t,aE)if a.datatype==nil then
a.datatype=z.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=p.divide_by_pair(t)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return z.dp_numeric(C,a)
end
local function V(P,bp,bo)
local aA=aR(P)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aT(C,g,I,c,b)
local a=e(c,b,g)local af=a.raw_min
if af==nil then
af=I.raw_min
end
local ae=a.raw_max
if ae==nil then
ae=I.raw_max
end
local G=a.value_min
if G==nil then
G=I.value_min
end
local F=a.value_max
if F==nil then
F=I.value_max
end
local bv=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bv then
local bj=p.scale(af,ae,G,F)local bt=p.scale(G,F,af,ae)a.converter=p.from_to(
function(P,aY,aO)
local bq=bj(P,aY,aO)if bq==nil then
return nil
end
return V(bq,G,F)
end,
function(P,aY,aO)
local ba=V(P,G,F)if ba==nil then
return nil
end
return bt(ba,aY,aO)
end
)elseif af~=G or ae~=F then
a.converter=p.scale_pair(af,ae,G,F)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return z.dp_numeric(C,a)
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
local function bd(C,g,aQ,bi,c,b)
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
return z.dp_raw(C,a)
end
local function be(C,c,b)
local a=e(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=p.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return z.dp_raw(C,a)
end
local function an(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aI={}for _,C in ipairs(m)do
if d(C)=="number"and C%1==0 and C>=0 then
L(aI,C)
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
b=b or{}local J=b.first_is_main~=false
local H=b.component_prefix
if d(H)~="string"or H==""then
H="switch"
end
local O=b.main_component
if d(O)~="string"or O==""then
O="main"
end
local q=b.index_offset
if d(q)~="number"or q%1~=0 then
q=0
end
if x==1 and J then
return O
end
local aC=J and(x-1+q)or(x+q)if aC<1 then
return b.default_component
end
return H..tostring(aC)
end
local function ay(x,b,aP)
b=b or{}local J=b.first_is_main~=false
local W=b.key_prefix
if d(W)~="string"or W==""then
W=aP or"switch"
end
local au=b.main_key
if d(au)~="string"or au==""then
au=W
end
local q=b.index_offset
if d(q)~="number"or q%1~=0 then
q=0
end
if x==1 and J then
return au
end
local aC=J and(x-1+q)or(x+q)if aC<1 then
return b.default_key
end
return W..tostring(aC)
end
local function Q(h,C,w,b)
if d(C)~="number"or C%1~=0 or C<0 then
return
end
L(h,w(C,b))
end
local function aa(Y,bu)
if d(bu)~="table"then
return Y
end
for _,bw in ipairs(bu)do
L(Y,bw)
end
return Y
end
local ak={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ax(P)
return d(P)=="number"and P%1==0 and P>0
end
local function o(b,i)
local a={}if d(b)~="table"then
return a
end
for ar,P in pairs(b)do
local aF=true
if not i then
if ar=="dp"or ar=="dps"or ar=="dp_list"then
aF=false
elseif ax(ar)then
aF=false
end
end
if aF then
a[ar]=P
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
local function E(b)
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
local function U(b,n)
if d(b)~="table"then
return nil
end
return u(b[n])
end
local function av(at,f)
local K=d(at)=="table"and at.item_options or nil
local B=d(f)=="table"and f.item_options or nil
if d(K)~="table"then
return d(B)=="table"and B or nil
end
if d(B)~="table"then
return K
end
local a={}j(a,K)j(a,B)return a
end
local function ag(b,n,A,i)
local a={}local r=nil
if d(b)=="table"then
bm(a,b,ak)r=b[n]if d(r)=="table"then
j(a,o(b,i))if i and ac(r)then
E(a)
end
j(a,r)elseif r~=nil then
j(a,o(b,i))if i then
E(a)
end
a.dp=r
else
j(a,o(b,i))
end
end
if a.key_prefix==nil and A~=nil then
a.key_prefix=A
end
a.item_options=av(b,r)return a
end
local function M(b,l)
local k={}local aq=U(b,"config")j(k,aq)local aw=u(k[l])if aw~=nil then
k[l]=aw
else
local X=u(k.switch_type)if X==nil then
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
local function aW(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local S=N(
s(b,"switch_module"),l)if next(S)~=nil then
a.switch_module=S
end
return a
end
local function bl(h,b,n,w)
local f=s(b,n)Q(h,f.dp,w,f)
end
local function aD(h,b,n,w,I)
local f=s(b,n)ap(f,I)Q(h,f.dp,w,f)
end
local function aS(h,b,n,w,az)
local f=s(b,n)local m=Z(f)if m~=nil and az~=nil then
aa(h,az(m,f))return
end
Q(h,f.dp,w,f)
end
local function aL(h,b,n,A,w)
local f=ag(b,n,A)aa(h,w(ad(f),f))
end
local function bg(m,w,g,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
for x,C in ipairs(aj)do
local a=e(ai,nil,g)if a.component==nil then
a.component=ah(x,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(x,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
L(h,w(C,a))
end
return h
end
local function aN(m,w,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
for x,C in ipairs(aj)do
local a=e(ai,nil,nil)if a.phase==nil then
a.phase=aJ(x,b)
end
L(h,w(C,a))
end
return h
end
local function aM(b,n,w)
local f=nil
if d(b)=="table"then
f=s(b,n,true)else
f={dp=b}
end
local h={}Q(h,f.dp,w,f)return h
end
function z.dp_on_off(C,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return z.dp_binary(C,a)
end
function z.dp_occupancy(C,c,b)
local a=e(c,b,"occupancy")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=p.true_false0()
end
return z.dp_binary(C,a)
end
function z.dp_voltage(C,c,b)
return v(C,"voltage",10,c,b)
end
function z.dp_current(C,c,b)
return v(C,"current",1000,c,b)
end
function z.dp_power(C,c,b)
return ab(C,"power",10,c,b)
end
function z.dp_power_on_behavior(C,c,b)
local a=e(c,b,"power_on_behavior")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=p.power_on_behavior()
end
return T(z.dp_enum(C,a),a)
end
function z.dp_countdown(C,c,b)
return v(C,"countdown",1,c,b)
end
end
return as
