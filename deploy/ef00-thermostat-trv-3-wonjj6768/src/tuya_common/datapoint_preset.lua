local function as(w,aB,bu)
bu=bu or{switch=function()return nil end}
local d=aB.type_check
local L=aB.table_insert
local aS=aB.tonumber_check
local k=aB.merge_options
local bm=aB.copy_keys
local r=w.converter
local function ap(X,I)
if d(X)~="table"or d(I)~="table"then
return X
end
for ar,P in pairs(I)do
if X[ar]==nil then
X[ar]=P
end
end
return X
end
local function e(c,b,g)
local a={}if d(c)=="string"then
a.name=c
else
k(a,c)
end
k(a,b)if a.name==nil and g~=nil then
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
return w.apply_fixed_send_policy(bh)
end
local function h(y,g,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=r.divide_by_pair(u)
end
a.scale=nil
return w.dp_numeric(y,a)
end
local function Z(y,g,A,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=r.divide_by_pair(u)
end
a.scale=nil
return w.dp_numeric(y,a)
end
local function aW(y,g,A,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=A
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
return w.dp_numeric(y,a)
end
local function ab(y,g,A,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=r.signed_number_pair(u)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return w.dp_numeric(y,a)
end
local function aH(y,g,A,bc,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=A
end
local br=
a.datatype==w.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aE={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ap(aE,bc)a.converter=r.raw_uint_be(u,aE)if a.datatype==nil then
a.datatype=w.DP_TYPE_RAW
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
return w.dp_numeric(y,a)
end
local function U(P,bp,bo)
local aA=aS(P)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aU(y,g,I,c,b)
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
local bj=r.scale(af,ae,G,F)local bs=r.scale(G,F,af,ae)a.converter=r.from_to(
function(P,aY,aP)
local bq=bj(P,aY,aP)if bq==nil then
return nil
end
return U(bq,G,F)
end,
function(P,aY,aP)
local ba=U(P,G,F)if ba==nil then
return nil
end
return bs(ba,aY,aP)
end
)elseif af~=G or ae~=F then
a.converter=r.scale_pair(af,ae,G,F)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return w.dp_numeric(y,a)
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
local function bd(y,g,aR,bi,c,b)
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
return w.dp_raw(y,a)
end
local function be(y,c,b)
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
return w.dp_raw(y,a)
end
local function an(n)
if d(n)=="number"and n%1==0 and n>=0 then
return{n}
end
if d(n)~="table"then
return{}
end
local aJ={}for _,y in ipairs(n)do
if d(y)=="number"and y%1==0 and y>=0 then
L(aJ,y)
end
end
return aJ
end
local function Y(b)
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
local n=Y(b)if n~=nil then
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
if z==1 and J then
return O
end
local aC=J and(z-1+q)or(z+q)if aC<1 then
return b.default_component
end
return H..tostring(aC)
end
local function ay(z,b,aQ)
b=b or{}local J=b.first_is_main~=false
local V=b.key_prefix
if d(V)~="string"or V==""then
V=aQ or"switch"
end
local au=b.main_key
if d(au)~="string"or au==""then
au=V
end
local q=b.index_offset
if d(q)~="number"or q%1~=0 then
q=0
end
if z==1 and J then
return au
end
local aC=J and(z-1+q)or(z+q)if aC<1 then
return b.default_key
end
return V..tostring(aC)
end
local function Q(i,y,x,b)
if d(y)~="number"or y%1~=0 or y<0 then
return
end
L(i,x(y,b))
end
local function aa(X,bt)
if d(bt)~="table"then
return X
end
for _,bw in ipairs(bt)do
L(X,bw)
end
return X
end
local ak={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ax(P)
return d(P)=="number"and P%1==0 and P>0
end
local function p(b,j)
local a={}if d(b)~="table"then
return a
end
for ar,P in pairs(b)do
local aF=true
if not j then
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
local z=1
while b[z]~=nil do
b[z]=nil
z=z+1
end
return b
end
local function t(b,o,j)
if d(b)~="table"then
return{}
end
local s=b[o]if s==nil then
return p(b,j)
end
local a=p(b,j)if d(s)=="table"then
k(a,s)else
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
local function T(b,o)
if d(b)~="table"then
return nil
end
return v(b[o])
end
local function av(at,f)
local K=d(at)=="table"and at.item_options or nil
local C=d(f)=="table"and f.item_options or nil
if d(K)~="table"then
return d(C)=="table"and C or nil
end
if d(C)~="table"then
return K
end
local a={}k(a,K)k(a,C)return a
end
local function ag(b,o,B,j)
local a={}local s=nil
if d(b)=="table"then
bm(a,b,ak)s=b[o]if d(s)=="table"then
k(a,p(b,j))if j and ac(s)then
E(a)
end
k(a,s)elseif s~=nil then
k(a,p(b,j))if j then
E(a)
end
a.dp=s
else
k(a,p(b,j))
end
end
if a.key_prefix==nil and B~=nil then
a.key_prefix=B
end
a.item_options=av(b,s)return a
end
local function M(b,m)
local l={}local aq=T(b,"config")k(l,aq)local aw=v(l[m])if aw~=nil then
l[m]=aw
else
local W=v(l.switch_type)if W==nil then
W=T(b,"switch_type")
end
if d(W)=="table"then
l[m]=W
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
k(a,b)
end
local l=M(b,m)if next(l)~=nil then
a.config=l
end
a.switch_type=nil
return a
end
local function aV(b,m)
local a={}if d(b)=="table"then
k(a,b)
end
local S=N(
t(b,"switch_module"),m)if next(S)~=nil then
a.switch_module=S
end
return a
end
local function bl(i,b,o,x)
local f=t(b,o)Q(i,f.dp,x,f)
end
local function aD(i,b,o,x,I)
local f=t(b,o)ap(f,I)Q(i,f.dp,x,f)
end
local function aT(i,b,o,x,az)
local f=t(b,o)local n=Y(f)if n~=nil and az~=nil then
aa(i,az(n,f))return
end
Q(i,f.dp,x,f)
end
local function aM(i,b,o,B,x)
local f=ag(b,o,B)aa(i,x(ad(f),f))
end
local function bg(n,x,g,b)
local i={}local aj=an(n)local ai=d(b)=="table"and b.item_options or nil
for z,y in ipairs(aj)do
local a=e(ai,nil,g)if a.component==nil then
a.component=ah(z,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(z,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
L(i,x(y,a))
end
return i
end
local function aO(n,x,b)
local i={}local aj=an(n)local ai=d(b)=="table"and b.item_options or nil
for z,y in ipairs(aj)do
local a=e(ai,nil,nil)if a.phase==nil then
a.phase=aK(z,b)
end
L(i,x(y,a))
end
return i
end
local function aN(b,o,x)
local f=nil
if d(b)=="table"then
f=t(b,o,true)else
f={dp=b}
end
local i={}Q(i,f.dp,x,f)return i
end
function w.dp_battery(y,c,b)
return Z(y,"battery",1,c,b)
end
function w.dp_child_lock(y,c,b)
return w.dp_binary(y,e(c,b,"child_lock"))
end
function w.dp_local_temperature(y,c,b)
return h(y,"local_temperature",c,b)
end
function w.dp_current_heating_setpoint(y,c,b)
return h(y,"current_heating_setpoint",c,b)
end
function w.dp_local_temperature_calibration(y,c,b)
return ab(y,"local_temperature_calibration",10,c,b)
end
function w.dp_open_window_temperature(y,c,b)
return h(y,"open_window_temperature",c,b)
end
function w.dp_comfort_temperature(y,c,b)
return h(y,"comfort_temperature",c,b)
end
function w.dp_eco_temperature(y,c,b)
return h(y,"eco_temperature",c,b)
end
function w.dp_holiday_temperature(y,c,b)
return h(y,"holiday_temperature",c,b)
end
function w.dp_max_temperature_limit(y,c,b)
return h(y,"max_temperature_limit",c,b)
end
function w.dp_min_temperature_limit(y,c,b)
return h(y,"min_temperature_limit",c,b)
end
function w.dp_system_mode(y,c,b)
return w.dp_enum(y,e(c,b,"system_mode"))
end
function w.dp_running_state(y,c,b)
return w.dp_enum(y,e(c,b,"running_state"))
end
end
return as
