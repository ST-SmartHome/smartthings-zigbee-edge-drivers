local function as(q,aB,bs)
bs=bs or{switch=function()return nil end}
local d=aB.type_check
local N=aB.table_insert
local aS=aB.tonumber_check
local k=aB.merge_options
local bm=aB.copy_keys
local m=q.converter
local function ap(Z,K)
if d(Z)~="table"or d(K)~="table"then
return Z
end
for ar,R in pairs(K)do
if Z[ar]==nil then
Z[ar]=R
end
end
return Z
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
return q.apply_fixed_send_policy(bh)
end
local function E(t,g,c,b)
local a=e(c,b,g)local w=a.scale
if w==nil then
w=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=m.divide_by_pair(w)
end
a.scale=nil
return q.dp_numeric(t,a)
end
local function h(t,g,A,c,b)
local a=e(c,b,g)local w=a.scale
if w==nil then
w=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=m.divide_by_pair(w)
end
a.scale=nil
return q.dp_numeric(t,a)
end
local function aW(t,g,A,c,b)
local a=e(c,b,g)local w=a.scale
if w==nil then
w=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ao=m.power()local bf=ao.from
if w~=1 then
a.from_device=m.pipe(
bf,m.divide_by(w))else
a.converter=ao
end
end
a.scale=nil
return q.dp_numeric(t,a)
end
local function F(t,g,A,c,b)
local a=e(c,b,g)local w=a.scale
if w==nil then
w=A
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=m.signed_number_pair(w)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return q.dp_numeric(t,a)
end
local function aH(t,g,A,bc,c,b)
local a=e(c,b,g)local w=a.scale
if w==nil then
w=A
end
local br=
a.datatype==q.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aE={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ap(aE,bc)a.converter=m.raw_uint_be(w,aE)if a.datatype==nil then
a.datatype=q.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=m.divide_by_pair(w)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return q.dp_numeric(t,a)
end
local function W(R,bp,bo)
local aA=aS(R)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aU(t,g,K,c,b)
local a=e(c,b,g)local af=a.raw_min
if af==nil then
af=K.raw_min
end
local ae=a.raw_max
if ae==nil then
ae=K.raw_max
end
local I=a.value_min
if I==nil then
I=K.value_min
end
local H=a.value_max
if H==nil then
H=K.value_max
end
local bv=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bv then
local bj=m.scale(af,ae,I,H)local bt=m.scale(I,H,af,ae)a.converter=m.from_to(
function(R,aY,aP)
local bq=bj(R,aY,aP)if bq==nil then
return nil
end
return W(bq,I,H)
end,
function(R,aY,aP)
local ba=W(R,I,H)if ba==nil then
return nil
end
return bt(ba,aY,aP)
end
)elseif af~=I or ae~=H then
a.converter=m.scale_pair(af,ae,I,H)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return q.dp_numeric(t,a)
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
local function bd(t,g,aR,bi,c,b)
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
return q.dp_raw(t,a)
end
local function be(t,c,b)
local a=e(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=m.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return q.dp_raw(t,a)
end
local function an(o)
if d(o)=="number"and o%1==0 and o>=0 then
return{o}
end
if d(o)~="table"then
return{}
end
local aJ={}for _,t in ipairs(o)do
if d(t)=="number"and t%1==0 and t>=0 then
N(aJ,t)
end
end
return aJ
end
local function aa(b)
if d(b)~="table"then
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
local o=aa(b)if o~=nil then
return o
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
b=b or{}local L=b.first_is_main~=false
local J=b.component_prefix
if d(J)~="string"or J==""then
J="switch"
end
local Q=b.main_component
if d(Q)~="string"or Q==""then
Q="main"
end
local s=b.index_offset
if d(s)~="number"or s%1~=0 then
s=0
end
if z==1 and L then
return Q
end
local aC=L and(z-1+s)or(z+s)if aC<1 then
return b.default_component
end
return J..tostring(aC)
end
local function ay(z,b,aQ)
b=b or{}local L=b.first_is_main~=false
local X=b.key_prefix
if d(X)~="string"or X==""then
X=aQ or"switch"
end
local au=b.main_key
if d(au)~="string"or au==""then
au=X
end
local s=b.index_offset
if d(s)~="number"or s%1~=0 then
s=0
end
if z==1 and L then
return au
end
local aC=L and(z-1+s)or(z+s)if aC<1 then
return b.default_key
end
return X..tostring(aC)
end
local function S(i,t,y,b)
if d(t)~="number"or t%1~=0 or t<0 then
return
end
N(i,y(t,b))
end
local function ab(Z,bu)
if d(bu)~="table"then
return Z
end
for _,bw in ipairs(bu)do
N(Z,bw)
end
return Z
end
local ak={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ax(R)
return d(R)=="number"and R%1==0 and R>0
end
local function r(b,j)
local a={}if d(b)~="table"then
return a
end
for ar,R in pairs(b)do
local aF=true
if not j then
if ar=="dp"or ar=="dps"or ar=="dp_list"then
aF=false
elseif ax(ar)then
aF=false
end
end
if aF then
a[ar]=R
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
local function G(b)
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
local function v(b,p,j)
if d(b)~="table"then
return{}
end
local u=b[p]if u==nil then
return r(b,j)
end
local a=r(b,j)if d(u)=="table"then
k(a,u)else
a.dp=u
end
return a
end
local function x(u)
if u==nil then
return nil
end
if d(u)=="table"then
return u
end
return{dp=u}
end
local function V(b,p)
if d(b)~="table"then
return nil
end
return x(b[p])
end
local function av(at,f)
local M=d(at)=="table"and at.item_options or nil
local C=d(f)=="table"and f.item_options or nil
if d(M)~="table"then
return d(C)=="table"and C or nil
end
if d(C)~="table"then
return M
end
local a={}k(a,M)k(a,C)return a
end
local function ag(b,p,B,j)
local a={}local u=nil
if d(b)=="table"then
bm(a,b,ak)u=b[p]if d(u)=="table"then
k(a,r(b,j))if j and ac(u)then
G(a)
end
k(a,u)elseif u~=nil then
k(a,r(b,j))if j then
G(a)
end
a.dp=u
else
k(a,r(b,j))
end
end
if a.key_prefix==nil and B~=nil then
a.key_prefix=B
end
a.item_options=av(b,u)return a
end
local function O(b,n)
local l={}local aq=V(b,"config")k(l,aq)local aw=x(l[n])if aw~=nil then
l[n]=aw
else
local Y=x(l.switch_type)if Y==nil then
Y=V(b,"switch_type")
end
if d(Y)=="table"then
l[n]=Y
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
local function P(b,n)
local a={}if d(b)=="table"then
k(a,b)
end
local l=O(b,n)if next(l)~=nil then
a.config=l
end
a.switch_type=nil
return a
end
local function aV(b,n)
local a={}if d(b)=="table"then
k(a,b)
end
local U=P(
v(b,"switch_module"),n)if next(U)~=nil then
a.switch_module=U
end
return a
end
local function bl(i,b,p,y)
local f=v(b,p)S(i,f.dp,y,f)
end
local function aD(i,b,p,y,K)
local f=v(b,p)ap(f,K)S(i,f.dp,y,f)
end
local function aT(i,b,p,y,az)
local f=v(b,p)local o=aa(f)if o~=nil and az~=nil then
ab(i,az(o,f))return
end
S(i,f.dp,y,f)
end
local function aM(i,b,p,B,y)
local f=ag(b,p,B)ab(i,y(ad(f),f))
end
local function bg(o,y,g,b)
local i={}local aj=an(o)local ai=d(b)=="table"and b.item_options or nil
for z,t in ipairs(aj)do
local a=e(ai,nil,g)if a.component==nil then
a.component=ah(z,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(z,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
N(i,y(t,a))
end
return i
end
local function aO(o,y,b)
local i={}local aj=an(o)local ai=d(b)=="table"and b.item_options or nil
for z,t in ipairs(aj)do
local a=e(ai,nil,nil)if a.phase==nil then
a.phase=aK(z,b)
end
N(i,y(t,a))
end
return i
end
local function aN(b,p,y)
local f=nil
if d(b)=="table"then
f=v(b,p,true)else
f={dp=b}
end
local i={}S(i,f.dp,y,f)return i
end
function q.dp_on_off(t,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return q.dp_binary(t,a)
end
function q.dp_temperature(t,c,b)
return E(t,"temperature",c,b)
end
function q.dp_humidity(t,c,b)
return E(t,"humidity",c,b)
end
function q.dp_battery(t,c,b)
return h(t,"battery",1,c,b)
end
function q.dp_occupancy(t,c,b)
local a=e(c,b,"occupancy")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=m.true_false0()
end
return q.dp_binary(t,a)
end
function q.dp_illuminance(t,c,b)
local a=e(c,b,"illuminance")return q.dp_numeric(t,a)
end
function q.dp_temperature_unit(t,c,b)
local a=e(c,b,"temperature_unit")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=m.temperature_unit()
end
return q.dp_enum(t,a)
end
function q.dp_temperature_calibration(t,c,b)
return F(t,"temperature_calibration",10,c,b)
end
function q.dp_humidity_calibration(t,c,b)
return F(t,"humidity_calibration",1,c,b)
end
function q.dp_presence(t,c,b)
return q.dp_binary(t,e(c,b,"presence"))
end
function q.dp_motion_state(t,c,b)
local a=e(c,b,"motion_state")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=m.motion_state()
end
return q.dp_enum(t,a)
end
function q.dp_indicator(t,c,b)
return q.dp_binary(t,e(c,b,"indicator"))
end
function q.dp_fading_time(t,c,b)
return h(t,"fading_time",1,c,b)
end
function q.dp_illuminance_interval(t,c,b)
return h(t,"illuminance_interval",1,c,b)
end
function q.dp_static_detection_distance(t,c,b)
return h(t,"static_detection_distance",100,c,b)
end
function q.dp_static_detection_sensitivity(t,c,b)
return h(t,"static_detection_sensitivity",1,c,b)
end
function q.dp_motion_detection_mode(t,c,b)
local a=e(c,b,"motion_detection_mode")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=m.motion_detection_mode()
end
return q.dp_enum(t,a)
end
function q.dp_motion_detection_sensitivity(t,c,b)
return h(t,"motion_detection_sensitivity",1,c,b)
end
function q.dp_target_distance(t,c,b)
return h(t,"target_distance",100,c,b)
end
end
return as
