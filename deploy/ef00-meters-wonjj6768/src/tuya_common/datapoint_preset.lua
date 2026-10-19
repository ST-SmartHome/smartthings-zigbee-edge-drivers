local function at(A,aC,bs)
bs=bs or{switch=function()return nil end}
local d=aC.type_check
local L=aC.table_insert
local aT=aC.tonumber_check
local j=aC.merge_options
local bm=aC.copy_keys
local q=A.converter
local function aq(Y,I)
if d(Y)~="table"or d(I)~="table"then
return Y
end
for as,P in pairs(I)do
if Y[as]==nil then
Y[as]=P
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
local an={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function am(b)
if d(b)~="table"then
return false
end
for _,as in ipairs(an)do
if b[as]~=nil then
return true
end
end
return false
end
local function aH(bh,b)
if am(b)then
return bh
end
return A.apply_fixed_send_policy(bh)
end
local function ab(z,g,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=q.divide_by_pair(u)
end
a.scale=nil
return A.dp_numeric(z,a)
end
local function k(z,g,y,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=q.divide_by_pair(u)
end
a.scale=nil
return A.dp_numeric(z,a)
end
local function ac(z,g,y,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=y
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ap=q.power()local bf=ap.from
if u~=1 then
a.from_device=q.pipe(
bf,q.divide_by(u))else
a.converter=ap
end
end
a.scale=nil
return A.dp_numeric(z,a)
end
local function aW(z,g,y,c,b)
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
return A.dp_numeric(z,a)
end
local function aI(z,g,y,bd,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=y
end
local br=
a.datatype==A.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aF={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}aq(aF,bd)a.converter=q.raw_uint_be(u,aF)if a.datatype==nil then
a.datatype=A.DP_TYPE_RAW
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
return A.dp_numeric(z,a)
end
local function V(P,bp,bo)
local aB=aT(P)if aB==nil then
return nil
end
return bp+bo-aB
end
local function aV(z,g,I,c,b)
local a=e(c,b,g)local ag=a.raw_min
if ag==nil then
ag=I.raw_min
end
local af=a.raw_max
if af==nil then
af=I.raw_max
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
local bj=q.scale(ag,af,G,F)local bt=q.scale(G,F,ag,af)a.converter=q.from_to(
function(P,aZ,aQ)
local bq=bj(P,aZ,aQ)if bq==nil then
return nil
end
return V(bq,G,F)
end,
function(P,aZ,aQ)
local bb=V(P,G,F)if bb==nil then
return nil
end
return bt(bb,aZ,aQ)
end
)elseif ag~=G or af~=F then
a.converter=q.scale_pair(ag,af,G,F)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return A.dp_numeric(z,a)
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
local function Q(z,g,aS,bi,c,b)
local aY=
d(c)=="string"or
(d(c)=="table"and c.name~=nil)or
(d(b)=="table"and b.name~=nil)local a=e(c,b,g)local phase=a.phase
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
return A.dp_raw(z,a)
end
local function be(z,c,b)
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
return A.dp_raw(z,a)
end
local function ao(n)
if d(n)=="number"and n%1==0 and n>=0 then
return{n}
end
if d(n)~="table"then
return{}
end
local aK={}for _,z in ipairs(n)do
if d(z)=="number"and z%1==0 and z>=0 then
L(aK,z)
end
end
return aK
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
local function ae(b)
local n=Z(b)if n~=nil then
return n
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
local function ai(x,b)
b=b or{}local J=b.first_is_main~=false
local H=b.component_prefix
if d(H)~="string"or H==""then
H="switch"
end
local O=b.main_component
if d(O)~="string"or O==""then
O="main"
end
local r=b.index_offset
if d(r)~="number"or r%1~=0 then
r=0
end
if x==1 and J then
return O
end
local aD=J and(x-1+r)or(x+r)if aD<1 then
return b.default_component
end
return H..tostring(aD)
end
local function az(x,b,aR)
b=b or{}local J=b.first_is_main~=false
local W=b.key_prefix
if d(W)~="string"or W==""then
W=aR or"switch"
end
local av=b.main_key
if d(av)~="string"or av==""then
av=W
end
local r=b.index_offset
if d(r)~="number"or r%1~=0 then
r=0
end
if x==1 and J then
return av
end
local aD=J and(x-1+r)or(x+r)if aD<1 then
return b.default_key
end
return W..tostring(aD)
end
local function R(h,z,w,b)
if d(z)~="number"or z%1~=0 or z<0 then
return
end
L(h,w(z,b))
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
local al={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ay(P)
return d(P)=="number"and P%1==0 and P>0
end
local function p(b,i)
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
local function ad(b)
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
local function aw(au,f)
local K=d(au)=="table"and au.item_options or nil
local C=d(f)=="table"and f.item_options or nil
if d(K)~="table"then
return d(C)=="table"and C or nil
end
if d(C)~="table"then
return K
end
local a={}j(a,K)j(a,C)return a
end
local function ah(b,o,B,i)
local a={}local s=nil
if d(b)=="table"then
bm(a,b,al)s=b[o]if d(s)=="table"then
j(a,p(b,i))if i and ad(s)then
E(a)
end
j(a,s)elseif s~=nil then
j(a,p(b,i))if i then
E(a)
end
a.dp=s
else
j(a,p(b,i))
end
end
if a.key_prefix==nil and B~=nil then
a.key_prefix=B
end
a.item_options=aw(b,s)return a
end
local function M(b,m)
local l={}local ar=U(b,"config")j(l,ar)local ax=v(l[m])if ax~=nil then
l[m]=ax
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
local function N(b,m)
local a={}if d(b)=="table"then
j(a,b)
end
local l=M(b,m)if next(l)~=nil then
a.config=l
end
a.switch_type=nil
return a
end
local function aX(b,m)
local a={}if d(b)=="table"then
j(a,b)
end
local T=N(
t(b,"switch_module"),m)if next(T)~=nil then
a.switch_module=T
end
return a
end
local function bl(h,b,o,w)
local f=t(b,o)R(h,f.dp,w,f)
end
local function aE(h,b,o,w,I)
local f=t(b,o)aq(f,I)R(h,f.dp,w,f)
end
local function aU(h,b,o,w,aA)
local f=t(b,o)local n=Z(f)if n~=nil and aA~=nil then
aa(h,aA(n,f))return
end
R(h,f.dp,w,f)
end
local function aN(h,b,o,B,w)
local f=ah(b,o,B)aa(h,w(ae(f),f))
end
local function bg(n,w,g,b)
local h={}local ak=ao(n)local aj=d(b)=="table"and b.item_options or nil
for x,z in ipairs(ak)do
local a=e(aj,nil,g)if a.component==nil then
a.component=ai(x,b)
end
if a.key==nil and a.preference==nil then
a.key=az(x,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
L(h,w(z,a))
end
return h
end
local function aP(n,w,b)
local h={}local ak=ao(n)local aj=d(b)=="table"and b.item_options or nil
for x,z in ipairs(ak)do
local a=e(aj,nil,nil)if a.phase==nil then
a.phase=aL(x,b)
end
L(h,w(z,a))
end
return h
end
local function aO(b,o,w)
local f=nil
if d(b)=="table"then
f=t(b,o,true)else
f={dp=b}
end
local h={}R(h,f.dp,w,f)return h
end
function A.dp_on_off(z,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return A.dp_binary(z,a)
end
function A.dp_temperature(z,c,b)
return ab(z,"temperature",c,b)
end
function A.dp_voltage(z,c,b)
return k(z,"voltage",10,c,b)
end
function A.dp_current(z,c,b)
return k(z,"current",1000,c,b)
end
function A.dp_power(z,c,b)
return ac(z,"power",10,c,b)
end
function A.dp_energy(z,c,b)
return k(z,"energy",100,c,b)
end
function A.dp_ac_frequency(z,c,b)
return k(z,"ac_frequency",100,c,b)
end
function A.dp_phase_variant2(z,c,b)
return Q(
z,"phase",
function(a)
return q.phase_variant2_parser(a.phase,a.signed_power)
end,
{"voltage","current","power"},c,b)
end
function A.dp_phase_variant3(z,c,b)
return Q(
z,"phase",
function(a)
return q.phase_variant3_parser(a.phase)
end,
{"voltage","current","power"},c,b)
end
function A.dp_power_factor(z,c,b)
local a=e(c,b,"power_factor")if a.read_only==nil then
a.read_only=true
end
return k(z,"power_factor",1,a)
end
end
return at
