local function as(w,aB,bs)
bs=bs or{switch=function()return nil end}
local d=aB.type_check
local L=aB.table_insert
local aS=aB.tonumber_check
local j=aB.merge_options
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
return w.apply_fixed_send_policy(bh)
end
local function l(z,g,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=r.divide_by_pair(u)
end
a.scale=nil
return w.dp_numeric(z,a)
end
local function Z(z,g,A,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=r.divide_by_pair(u)
end
a.scale=nil
return w.dp_numeric(z,a)
end
local function aW(z,g,A,c,b)
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
return w.dp_numeric(z,a)
end
local function ab(z,g,A,c,b)
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
return w.dp_numeric(z,a)
end
local function aH(z,g,A,bc,c,b)
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
return w.dp_numeric(z,a)
end
local function U(P,bp,bo)
local aA=aS(P)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aU(z,g,I,c,b)
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
local bj=r.scale(af,ae,G,F)local bt=r.scale(G,F,af,ae)a.converter=r.from_to(
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
return bt(ba,aY,aP)
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
return w.dp_numeric(z,a)
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
local function bd(z,g,aR,bi,c,b)
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
return w.dp_raw(z,a)
end
local function be(z,c,b)
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
return w.dp_raw(z,a)
end
local function an(n)
if d(n)=="number"and n%1==0 and n>=0 then
return{n}
end
if d(n)~="table"then
return{}
end
local aJ={}for _,z in ipairs(n)do
if d(z)=="number"and z%1==0 and z>=0 then
L(aJ,z)
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
local function aK(y,b)
b=b or{}local aL=b.phases
if d(aL)~="table"then
aL=b.phase_names
end
local phase=d(aL)=="table"and aL[y]or nil
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
return D..tostring(y)
end
return tostring(y)
end
local function ah(y,b)
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
if y==1 and J then
return O
end
local aC=J and(y-1+q)or(y+q)if aC<1 then
return b.default_component
end
return H..tostring(aC)
end
local function ay(y,b,aQ)
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
if y==1 and J then
return au
end
local aC=J and(y-1+q)or(y+q)if aC<1 then
return b.default_key
end
return V..tostring(aC)
end
local function Q(h,z,x,b)
if d(z)~="number"or z%1~=0 or z<0 then
return
end
L(h,x(z,b))
end
local function aa(X,bu)
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
local function ax(P)
return d(P)=="number"and P%1==0 and P>0
end
local function p(b,i)
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
local y=1
while b[y]~=nil do
b[y]=nil
y=y+1
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
local a={}j(a,K)j(a,C)return a
end
local function ag(b,o,B,i)
local a={}local s=nil
if d(b)=="table"then
bm(a,b,ak)s=b[o]if d(s)=="table"then
j(a,p(b,i))if i and ac(s)then
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
a.item_options=av(b,s)return a
end
local function M(b,m)
local k={}local aq=T(b,"config")j(k,aq)local aw=v(k[m])if aw~=nil then
k[m]=aw
else
local W=v(k.switch_type)if W==nil then
W=T(b,"switch_type")
end
if d(W)=="table"then
k[m]=W
end
end
if m~="switch_type"then
k.switch_type=nil
end
if next(k)~=nil then
return k
end
return{}
end
local function N(b,m)
local a={}if d(b)=="table"then
j(a,b)
end
local k=M(b,m)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aV(b,m)
local a={}if d(b)=="table"then
j(a,b)
end
local S=N(
t(b,"switch_module"),m)if next(S)~=nil then
a.switch_module=S
end
return a
end
local function bl(h,b,o,x)
local f=t(b,o)Q(h,f.dp,x,f)
end
local function aD(h,b,o,x,I)
local f=t(b,o)ap(f,I)Q(h,f.dp,x,f)
end
local function aT(h,b,o,x,az)
local f=t(b,o)local n=Y(f)if n~=nil and az~=nil then
aa(h,az(n,f))return
end
Q(h,f.dp,x,f)
end
local function aM(h,b,o,B,x)
local f=ag(b,o,B)aa(h,x(ad(f),f))
end
local function bg(n,x,g,b)
local h={}local aj=an(n)local ai=d(b)=="table"and b.item_options or nil
for y,z in ipairs(aj)do
local a=e(ai,nil,g)if a.component==nil then
a.component=ah(y,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(y,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
L(h,x(z,a))
end
return h
end
local function aO(n,x,b)
local h={}local aj=an(n)local ai=d(b)=="table"and b.item_options or nil
for y,z in ipairs(aj)do
local a=e(ai,nil,nil)if a.phase==nil then
a.phase=aK(y,b)
end
L(h,x(z,a))
end
return h
end
local function aN(b,o,x)
local f=nil
if d(b)=="table"then
f=t(b,o,true)else
f={dp=b}
end
local h={}Q(h,f.dp,x,f)return h
end
function w.dp_on_off(z,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return w.dp_binary(z,a)
end
function w.dp_humidity(z,c,b)
return l(z,"humidity",c,b)
end
function w.dp_battery(z,c,b)
return Z(z,"battery",1,c,b)
end
function w.dp_child_lock(z,c,b)
return w.dp_binary(z,e(c,b,"child_lock"))
end
function w.dp_local_temperature(z,c,b)
return l(z,"local_temperature",c,b)
end
function w.dp_current_heating_setpoint(z,c,b)
return l(z,"current_heating_setpoint",c,b)
end
function w.dp_local_temperature_calibration(z,c,b)
return ab(z,"local_temperature_calibration",10,c,b)
end
function w.dp_comfort_temperature(z,c,b)
return l(z,"comfort_temperature",c,b)
end
function w.dp_eco_temperature(z,c,b)
return l(z,"eco_temperature",c,b)
end
function w.dp_system_mode(z,c,b)
return w.dp_enum(z,e(c,b,"system_mode"))
end
function w.dp_running_state(z,c,b)
return w.dp_enum(z,e(c,b,"running_state"))
end
function w.dp_fan_mode(z,c,b)
return w.dp_enum(z,e(c,b,"fan_mode"))
end
end
return as
