local function as(m,aB,bu)
bu=bu or{switch=function()return nil end}
local e=aB.type_check
local L=aB.table_insert
local aS=aB.tonumber_check
local k=aB.merge_options
local bm=aB.copy_keys
local t=m.converter
local function ap(X,I)
if e(X)~="table"or e(I)~="table"then
return X
end
for ar,P in pairs(I)do
if X[ar]==nil then
X[ar]=P
end
end
return X
end
local function d(c,b,h)
local a={}if e(c)=="string"then
a.name=c
else
k(a,c)
end
k(a,b)if a.name==nil and h~=nil then
a.name=h
end
return a
end
local am={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function al(b)
if e(b)~="table"then
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
return m.apply_fixed_send_policy(bh)
end
local function g(s,h,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=t.divide_by_pair(w)
end
a.scale=nil
return m.dp_numeric(s,a)
end
local function Z(s,h,A,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=t.divide_by_pair(w)
end
a.scale=nil
return m.dp_numeric(s,a)
end
local function aW(s,h,A,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ao=t.power()local bf=ao.from
if w~=1 then
a.from_device=t.pipe(
bf,t.divide_by(w))else
a.converter=ao
end
end
a.scale=nil
return m.dp_numeric(s,a)
end
local function ab(s,h,A,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=t.signed_number_pair(w)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return m.dp_numeric(s,a)
end
local function aH(s,h,A,bc,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=A
end
local br=
a.datatype==m.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aE={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ap(aE,bc)a.converter=t.raw_uint_be(w,aE)if a.datatype==nil then
a.datatype=m.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=t.divide_by_pair(w)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return m.dp_numeric(s,a)
end
local function U(P,bp,bo)
local aA=aS(P)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aU(s,h,I,c,b)
local a=d(c,b,h)local af=a.raw_min
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
local bj=t.scale(af,ae,G,F)local bs=t.scale(G,F,af,ae)a.converter=t.from_to(
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
a.converter=t.scale_pair(af,ae,G,F)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return m.dp_numeric(s,a)
end
local function bk(phase,aZ)
if e(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,ar in ipairs(bx or{})do
local aI=ar
if e(phase)=="string"and phase~=""then
aI=ar.."_"..phase
end
bn[aI]=true
end
return bn
end
local function bd(s,h,aR,bi,c,b)
local aX=
e(c)=="string"or
(e(c)=="table"and c.name~=nil)or
(e(b)=="table"and b.name~=nil)local a=d(c,b,h)local phase=a.phase
if not aX and a.name==h then
a.name=bk(phase,h)
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
return m.dp_raw(s,a)
end
local function be(s,c,b)
local a=d(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=t.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return m.dp_raw(s,a)
end
local function an(o)
if e(o)=="number"and o%1==0 and o>=0 then
return{o}
end
if e(o)~="table"then
return{}
end
local aJ={}for _,s in ipairs(o)do
if e(s)=="number"and s%1==0 and s>=0 then
L(aJ,s)
end
end
return aJ
end
local function Y(b)
if e(b)~="table"then
return b
end
local o=b.dps
if o==nil then
o=b.dp_list
end
if o==nil and b[1]~=nil then
o=b
end
return o
end
local function ad(b)
local o=Y(b)if o~=nil then
return o
end
if e(b)~="table"then
return b
end
return b.dp
end
local function aK(z,b)
b=b or{}local aL=b.phases
if e(aL)~="table"then
aL=b.phase_names
end
local phase=e(aL)=="table"and aL[z]or nil
if e(phase)=="string"and phase~=""then
return phase
end
local D=b.phase_prefix
if D==false then
return nil
end
if e(D)~="string"or D==""then
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
if e(H)~="string"or H==""then
H="switch"
end
local O=b.main_component
if e(O)~="string"or O==""then
O="main"
end
local r=b.index_offset
if e(r)~="number"or r%1~=0 then
r=0
end
if z==1 and J then
return O
end
local aC=J and(z-1+r)or(z+r)if aC<1 then
return b.default_component
end
return H..tostring(aC)
end
local function ay(z,b,aQ)
b=b or{}local J=b.first_is_main~=false
local V=b.key_prefix
if e(V)~="string"or V==""then
V=aQ or"switch"
end
local au=b.main_key
if e(au)~="string"or au==""then
au=V
end
local r=b.index_offset
if e(r)~="number"or r%1~=0 then
r=0
end
if z==1 and J then
return au
end
local aC=J and(z-1+r)or(z+r)if aC<1 then
return b.default_key
end
return V..tostring(aC)
end
local function Q(i,s,y,b)
if e(s)~="number"or s%1~=0 or s<0 then
return
end
L(i,y(s,b))
end
local function aa(X,bt)
if e(bt)~="table"then
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
return e(P)=="number"and P%1==0 and P>0
end
local function q(b,j)
local a={}if e(b)~="table"then
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
if e(b)~="table"then
return false
end
if b.dp~=nil or b.dps~=nil or b.dp_list~=nil or b[1]~=nil then
return true
end
return false
end
local function E(b)
if e(b)~="table"then
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
local function v(b,p,j)
if e(b)~="table"then
return{}
end
local u=b[p]if u==nil then
return q(b,j)
end
local a=q(b,j)if e(u)=="table"then
k(a,u)else
a.dp=u
end
return a
end
local function x(u)
if u==nil then
return nil
end
if e(u)=="table"then
return u
end
return{dp=u}
end
local function T(b,p)
if e(b)~="table"then
return nil
end
return x(b[p])
end
local function av(at,f)
local K=e(at)=="table"and at.item_options or nil
local C=e(f)=="table"and f.item_options or nil
if e(K)~="table"then
return e(C)=="table"and C or nil
end
if e(C)~="table"then
return K
end
local a={}k(a,K)k(a,C)return a
end
local function ag(b,p,B,j)
local a={}local u=nil
if e(b)=="table"then
bm(a,b,ak)u=b[p]if e(u)=="table"then
k(a,q(b,j))if j and ac(u)then
E(a)
end
k(a,u)elseif u~=nil then
k(a,q(b,j))if j then
E(a)
end
a.dp=u
else
k(a,q(b,j))
end
end
if a.key_prefix==nil and B~=nil then
a.key_prefix=B
end
a.item_options=av(b,u)return a
end
local function M(b,n)
local l={}local aq=T(b,"config")k(l,aq)local aw=x(l[n])if aw~=nil then
l[n]=aw
else
local W=x(l.switch_type)if W==nil then
W=T(b,"switch_type")
end
if e(W)=="table"then
l[n]=W
end
end
if n~="switch_type"then
l.switch_type=nil
end
if next(l)~=nil then
return l
end
return{}
end
local function N(b,n)
local a={}if e(b)=="table"then
k(a,b)
end
local l=M(b,n)if next(l)~=nil then
a.config=l
end
a.switch_type=nil
return a
end
local function aV(b,n)
local a={}if e(b)=="table"then
k(a,b)
end
local S=N(
v(b,"switch_module"),n)if next(S)~=nil then
a.switch_module=S
end
return a
end
local function bl(i,b,p,y)
local f=v(b,p)Q(i,f.dp,y,f)
end
local function aD(i,b,p,y,I)
local f=v(b,p)ap(f,I)Q(i,f.dp,y,f)
end
local function aT(i,b,p,y,az)
local f=v(b,p)local o=Y(f)if o~=nil and az~=nil then
aa(i,az(o,f))return
end
Q(i,f.dp,y,f)
end
local function aM(i,b,p,B,y)
local f=ag(b,p,B)aa(i,y(ad(f),f))
end
local function bg(o,y,h,b)
local i={}local aj=an(o)local ai=e(b)=="table"and b.item_options or nil
for z,s in ipairs(aj)do
local a=d(ai,nil,h)if a.component==nil then
a.component=ah(z,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(z,b,h)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
L(i,y(s,a))
end
return i
end
local function aO(o,y,b)
local i={}local aj=an(o)local ai=e(b)=="table"and b.item_options or nil
for z,s in ipairs(aj)do
local a=d(ai,nil,nil)if a.phase==nil then
a.phase=aK(z,b)
end
L(i,y(s,a))
end
return i
end
local function aN(b,p,y)
local f=nil
if e(b)=="table"then
f=v(b,p,true)else
f={dp=b}
end
local i={}Q(i,f.dp,y,f)return i
end
function m.dp_temperature(s,c,b)
return g(s,"temperature",c,b)
end
function m.dp_battery(s,c,b)
return Z(s,"battery",1,c,b)
end
function m.dp_child_lock(s,c,b)
return m.dp_binary(s,d(c,b,"child_lock"))
end
function m.dp_local_temperature(s,c,b)
return g(s,"local_temperature",c,b)
end
function m.dp_current_heating_setpoint(s,c,b)
return g(s,"current_heating_setpoint",c,b)
end
function m.dp_local_temperature_calibration(s,c,b)
return ab(s,"local_temperature_calibration",10,c,b)
end
function m.dp_open_window_temperature(s,c,b)
return g(s,"open_window_temperature",c,b)
end
function m.dp_comfort_temperature(s,c,b)
return g(s,"comfort_temperature",c,b)
end
function m.dp_eco_temperature(s,c,b)
return g(s,"eco_temperature",c,b)
end
function m.dp_holiday_temperature(s,c,b)
return g(s,"holiday_temperature",c,b)
end
function m.dp_max_temperature_limit(s,c,b)
return g(s,"max_temperature_limit",c,b)
end
function m.dp_min_temperature_limit(s,c,b)
return g(s,"min_temperature_limit",c,b)
end
function m.dp_system_mode(s,c,b)
return m.dp_enum(s,d(c,b,"system_mode"))
end
function m.dp_running_state(s,c,b)
return m.dp_enum(s,d(c,b,"running_state"))
end
function m.dp_frost_protection(s,c,b)
return m.dp_binary(s,d(c,b,"frost_protection"))
end
function m.dp_window_detection(s,c,b)
return m.dp_binary(s,d(c,b,"window_detection"))
end
function m.dp_open_window(s,c,b)
return m.dp_binary(s,d(c,b,"open_window"))
end
function m.dp_window_open(s,c,b)
return m.dp_binary(s,d(c,b,"window_open"))
end
function m.dp_boost_heating(s,c,b)
return m.dp_binary(s,d(c,b,"boost_heating"))
end
function m.dp_scale_protection(s,c,b)
return m.dp_binary(s,d(c,b,"scale_protection"))
end
end
return as
