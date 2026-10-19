local function at(D,aC,bs)
bs=bs or{switch=function()return nil end}
local d=aC.type_check
local L=aC.table_insert
local aT=aC.tonumber_check
local j=aC.merge_options
local bm=aC.copy_keys
local q=D.converter
local function aq(X,I)
if d(X)~="table"or d(I)~="table"then
return X
end
for as,P in pairs(I)do
if X[as]==nil then
X[as]=P
end
end
return X
end
local function f(c,b,g)
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
for _,as in ipairs(am)do
if b[as]~=nil then
return true
end
end
return false
end
local function aH(bh,b)
if al(b)then
return bh
end
return D.apply_fixed_send_policy(bh)
end
local function aa(B,g,c,b)
local a=f(c,b,g)local t=a.scale
if t==nil then
t=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return D.dp_numeric(B,a)
end
local function v(B,g,y,c,b)
local a=f(c,b,g)local t=a.scale
if t==nil then
t=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return D.dp_numeric(B,a)
end
local function ab(B,g,y,c,b)
local a=f(c,b,g)local t=a.scale
if t==nil then
t=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ao=q.power()local bf=ao.from
if t~=1 then
a.from_device=q.pipe(
bf,q.divide_by(t))else
a.converter=ao
end
end
a.scale=nil
return D.dp_numeric(B,a)
end
local function aW(B,g,y,c,b)
local a=f(c,b,g)local t=a.scale
if t==nil then
t=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.signed_number_pair(t)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return D.dp_numeric(B,a)
end
local function aI(B,g,y,bd,c,b)
local a=f(c,b,g)local t=a.scale
if t==nil then
t=y
end
local br=
a.datatype==D.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aF={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}aq(aF,bd)a.converter=q.raw_uint_be(t,aF)if a.datatype==nil then
a.datatype=D.DP_TYPE_RAW
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
return D.dp_numeric(B,a)
end
local function U(P,bp,bo)
local aB=aT(P)if aB==nil then
return nil
end
return bp+bo-aB
end
local function aV(B,g,I,c,b)
local a=f(c,b,g)local af=a.raw_min
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
local bj=q.scale(af,ae,G,F)local bt=q.scale(G,F,af,ae)a.converter=q.from_to(
function(P,aZ,aQ)
local bq=bj(P,aZ,aQ)if bq==nil then
return nil
end
return U(bq,G,F)
end,
function(P,aZ,aQ)
local bb=U(P,G,F)if bb==nil then
return nil
end
return bt(bb,aZ,aQ)
end
)elseif af~=G or ae~=F then
a.converter=q.scale_pair(af,ae,G,F)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return D.dp_numeric(B,a)
end
local function bk(phase,ba)
if d(phase)=="string"and phase~=""then
return(ba or"phase").."_"..phase
end
return ba or"phase"
end
local function bc(bx,phase)
local bn={}for _,as in ipairs(bx or{})do
local aJ=as
if d(phase)=="string"and phase~=""then
aJ=as.."_"..phase
end
bn[aJ]=true
end
return bn
end
local function ap(B,g,aS,bi,c,b)
local aY=
d(c)=="string"or
(d(c)=="table"and c.name~=nil)or
(d(b)=="table"and b.name~=nil)local a=f(c,b,g)local phase=a.phase
if not aY and a.name==g then
a.name=bk(phase,g)
end
if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=aS(a)
end
if a.field==nil and a.fields==nil then
a.fields=bc(bi,phase)
end
return D.dp_raw(B,a)
end
local function be(B,c,b)
local a=f(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return D.dp_raw(B,a)
end
local function an(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aK={}for _,B in ipairs(m)do
if d(B)=="number"and B%1==0 and B>=0 then
L(aK,B)
end
end
return aK
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
local function ad(b)
local m=Y(b)if m~=nil then
return m
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aL(x,b)
b=b or{}local aM=b.phases
if d(aM)~="table"then
aM=b.phase_names
end
local phase=d(aM)=="table"and aM[x]or nil
if d(phase)=="string"and phase~=""then
return phase
end
local C=b.phase_prefix
if C==false then
return nil
end
if d(C)~="string"or C==""then
C=nil
end
if C~=nil then
return C..tostring(x)
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
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if x==1 and J then
return O
end
local aD=J and(x-1+p)or(x+p)if aD<1 then
return b.default_component
end
return H..tostring(aD)
end
local function az(x,b,aR)
b=b or{}local J=b.first_is_main~=false
local V=b.key_prefix
if d(V)~="string"or V==""then
V=aR or"switch"
end
local av=b.main_key
if d(av)~="string"or av==""then
av=V
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if x==1 and J then
return av
end
local aD=J and(x-1+p)or(x+p)if aD<1 then
return b.default_key
end
return V..tostring(aD)
end
local function Q(h,B,w,b)
if d(B)~="number"or B%1~=0 or B<0 then
return
end
L(h,w(B,b))
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
local ak={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ay(P)
return d(P)=="number"and P%1==0 and P>0
end
local function o(b,i)
local a={}if d(b)~="table"then
return a
end
for as,P in pairs(b)do
local aG=true
if not i then
if as=="dp"or as=="dps"or as=="dp_list"then
aG=false
elseif ay(as)then
aG=false
end
end
if aG then
a[as]=P
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
local function T(b,n)
if d(b)~="table"then
return nil
end
return u(b[n])
end
local function aw(au,e)
local K=d(au)=="table"and au.item_options or nil
local A=d(e)=="table"and e.item_options or nil
if d(K)~="table"then
return d(A)=="table"and A or nil
end
if d(A)~="table"then
return K
end
local a={}j(a,K)j(a,A)return a
end
local function ag(b,n,z,i)
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
if a.key_prefix==nil and z~=nil then
a.key_prefix=z
end
a.item_options=aw(b,r)return a
end
local function M(b,l)
local k={}local ar=T(b,"config")j(k,ar)local ax=u(k[l])if ax~=nil then
k[l]=ax
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
local function aX(b,l)
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
local e=s(b,n)Q(h,e.dp,w,e)
end
local function aE(h,b,n,w,I)
local e=s(b,n)aq(e,I)Q(h,e.dp,w,e)
end
local function aU(h,b,n,w,aA)
local e=s(b,n)local m=Y(e)if m~=nil and aA~=nil then
Z(h,aA(m,e))return
end
Q(h,e.dp,w,e)
end
local function aN(h,b,n,z,w)
local e=ag(b,n,z)Z(h,w(ad(e),e))
end
local function bg(m,w,g,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
for x,B in ipairs(aj)do
local a=f(ai,nil,g)if a.component==nil then
a.component=ah(x,b)
end
if a.key==nil and a.preference==nil then
a.key=az(x,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
L(h,w(B,a))
end
return h
end
local function aP(m,w,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
for x,B in ipairs(aj)do
local a=f(ai,nil,nil)if a.phase==nil then
a.phase=aL(x,b)
end
L(h,w(B,a))
end
return h
end
local function aO(b,n,w)
local e=nil
if d(b)=="table"then
e=s(b,n,true)else
e={dp=b}
end
local h={}Q(h,e.dp,w,e)return h
end
function D.dp_on_off(B,c,b)
local a=f(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return D.dp_binary(B,a)
end
function D.dp_temperature(B,c,b)
return aa(B,"temperature",c,b)
end
function D.dp_voltage(B,c,b)
return v(B,"voltage",10,c,b)
end
function D.dp_current(B,c,b)
return v(B,"current",1000,c,b)
end
function D.dp_power(B,c,b)
return ab(B,"power",10,c,b)
end
function D.dp_energy(B,c,b)
return v(B,"energy",100,c,b)
end
function D.dp_phase_variant2(B,c,b)
return ap(
B,"phase",
function(a)
return q.phase_variant2_parser(a.phase,a.signed_power)
end,
{"voltage","current","power"},c,b)
end
end
return at
