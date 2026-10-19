local function ar(w,aA,bu)
bu=bu or{switch=function()return nil end}
local d=aA.type_check
local M=aA.table_insert
local aQ=aA.tonumber_check
local k=aA.merge_options
local bm=aA.copy_keys
local m=w.converter
local function ao(Y,J)
if d(Y)~="table"or d(J)~="table"then
return Y
end
for aq,Q in pairs(J)do
if Y[aq]==nil then
Y[aq]=Q
end
end
return Y
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
local function B(bh,b)
if ak(b)then
return bh
end
return w.apply_fixed_send_policy(bh)
end
local function aT(A,g,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=m.divide_by_pair(u)
end
a.scale=nil
return w.dp_numeric(A,a)
end
local function j(A,g,z,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=z
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=m.divide_by_pair(u)
end
a.scale=nil
return w.dp_numeric(A,a)
end
local function aW(A,g,z,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=z
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local an=m.power()local bf=an.from
if u~=1 then
a.from_device=m.pipe(
bf,m.divide_by(u))else
a.converter=an
end
end
a.scale=nil
return w.dp_numeric(A,a)
end
local function aU(A,g,z,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=z
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=m.signed_number_pair(u)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return w.dp_numeric(A,a)
end
local function aF(A,g,z,bc,c,b)
local a=e(c,b,g)local u=a.scale
if u==nil then
u=z
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
local aD={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ao(aD,bc)a.converter=m.raw_uint_be(u,aD)if a.datatype==nil then
a.datatype=w.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and u~=1 then
a.converter=m.divide_by_pair(u)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return w.dp_numeric(A,a)
end
local function V(Q,bp,bo)
local az=aQ(Q)if az==nil then
return nil
end
return bp+bo-az
end
local function aS(A,g,J,c,b)
local a=e(c,b,g)local ae=a.raw_min
if ae==nil then
ae=J.raw_min
end
local ad=a.raw_max
if ad==nil then
ad=J.raw_max
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
local bj=m.scale(ae,ad,H,G)local bs=m.scale(H,G,ae,ad)a.converter=m.from_to(
function(Q,aY,aN)
local bq=bj(Q,aY,aN)if bq==nil then
return nil
end
return V(bq,H,G)
end,
function(Q,aY,aN)
local ba=V(Q,H,G)if ba==nil then
return nil
end
return bs(ba,aY,aN)
end
)elseif ae~=H or ad~=G then
a.converter=m.scale_pair(ae,ad,H,G)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return w.dp_numeric(A,a)
end
local function bk(phase,aZ)
if d(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,aq in ipairs(bx or{})do
local aG=aq
if d(phase)=="string"and phase~=""then
aG=aq.."_"..phase
end
bn[aG]=true
end
return bn
end
local function bd(A,g,aP,bi,c,b)
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
a.converter=aP(a)
end
if a.field==nil and a.fields==nil then
a.fields=bb(bi,phase)
end
return w.dp_raw(A,a)
end
local function be(A,c,b)
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
return w.dp_raw(A,a)
end
local function am(o)
if d(o)=="number"and o%1==0 and o>=0 then
return{o}
end
if d(o)~="table"then
return{}
end
local aH={}for _,A in ipairs(o)do
if d(A)=="number"and A%1==0 and A>=0 then
M(aH,A)
end
end
return aH
end
local function Z(b)
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
local function ac(b)
local o=Z(b)if o~=nil then
return o
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aI(y,b)
b=b or{}local aJ=b.phases
if d(aJ)~="table"then
aJ=b.phase_names
end
local phase=d(aJ)=="table"and aJ[y]or nil
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
return E..tostring(y)
end
return tostring(y)
end
local function ag(y,b)
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
if y==1 and K then
return P
end
local aB=K and(y-1+r)or(y+r)if aB<1 then
return b.default_component
end
return I..tostring(aB)
end
local function ax(y,b,aO)
b=b or{}local K=b.first_is_main~=false
local W=b.key_prefix
if d(W)~="string"or W==""then
W=aO or"switch"
end
local at=b.main_key
if d(at)~="string"or at==""then
at=W
end
local r=b.index_offset
if d(r)~="number"or r%1~=0 then
r=0
end
if y==1 and K then
return at
end
local aB=K and(y-1+r)or(y+r)if aB<1 then
return b.default_key
end
return W..tostring(aB)
end
local function R(h,A,x,b)
if d(A)~="number"or A%1~=0 or A<0 then
return
end
M(h,x(A,b))
end
local function aa(Y,bt)
if d(bt)~="table"then
return Y
end
for _,bw in ipairs(bt)do
M(Y,bw)
end
return Y
end
local aj={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function aw(Q)
return d(Q)=="number"and Q%1==0 and Q>0
end
local function q(b,i)
local a={}if d(b)~="table"then
return a
end
for aq,Q in pairs(b)do
local aE=true
if not i then
if aq=="dp"or aq=="dps"or aq=="dp_list"then
aE=false
elseif aw(aq)then
aE=false
end
end
if aE then
a[aq]=Q
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
local function F(b)
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
local function t(b,p,i)
if d(b)~="table"then
return{}
end
local s=b[p]if s==nil then
return q(b,i)
end
local a=q(b,i)if d(s)=="table"then
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
local function U(b,p)
if d(b)~="table"then
return nil
end
return v(b[p])
end
local function au(as,f)
local L=d(as)=="table"and as.item_options or nil
local D=d(f)=="table"and f.item_options or nil
if d(L)~="table"then
return d(D)=="table"and D or nil
end
if d(D)~="table"then
return L
end
local a={}k(a,L)k(a,D)return a
end
local function af(b,p,C,i)
local a={}local s=nil
if d(b)=="table"then
bm(a,b,aj)s=b[p]if d(s)=="table"then
k(a,q(b,i))if i and ab(s)then
F(a)
end
k(a,s)elseif s~=nil then
k(a,q(b,i))if i then
F(a)
end
a.dp=s
else
k(a,q(b,i))
end
end
if a.key_prefix==nil and C~=nil then
a.key_prefix=C
end
a.item_options=au(b,s)return a
end
local function N(b,n)
local l={}local ap=U(b,"config")k(l,ap)local av=v(l[n])if av~=nil then
l[n]=av
else
local X=v(l.switch_type)if X==nil then
X=U(b,"switch_type")
end
if d(X)=="table"then
l[n]=X
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
local function O(b,n)
local a={}if d(b)=="table"then
k(a,b)
end
local l=N(b,n)if next(l)~=nil then
a.config=l
end
a.switch_type=nil
return a
end
local function aV(b,n)
local a={}if d(b)=="table"then
k(a,b)
end
local T=O(
t(b,"switch_module"),n)if next(T)~=nil then
a.switch_module=T
end
return a
end
local function bl(h,b,p,x)
local f=t(b,p)R(h,f.dp,x,f)
end
local function aC(h,b,p,x,J)
local f=t(b,p)ao(f,J)R(h,f.dp,x,f)
end
local function aR(h,b,p,x,ay)
local f=t(b,p)local o=Z(f)if o~=nil and ay~=nil then
aa(h,ay(o,f))return
end
R(h,f.dp,x,f)
end
local function aK(h,b,p,C,x)
local f=af(b,p,C)aa(h,x(ac(f),f))
end
local function bg(o,x,g,b)
local h={}local ai=am(o)local ah=d(b)=="table"and b.item_options or nil
for y,A in ipairs(ai)do
local a=e(ah,nil,g)if a.component==nil then
a.component=ag(y,b)
end
if a.key==nil and a.preference==nil then
a.key=ax(y,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
M(h,x(A,a))
end
return h
end
local function aM(o,x,b)
local h={}local ai=am(o)local ah=d(b)=="table"and b.item_options or nil
for y,A in ipairs(ai)do
local a=e(ah,nil,nil)if a.phase==nil then
a.phase=aI(y,b)
end
M(h,x(A,a))
end
return h
end
local function aL(b,p,x)
local f=nil
if d(b)=="table"then
f=t(b,p,true)else
f={dp=b}
end
local h={}R(h,f.dp,x,f)return h
end
function w.dp_battery(A,c,b)
return j(A,"battery",1,c,b)
end
function w.dp_occupancy(A,c,b)
local a=e(c,b,"occupancy")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=m.true_false0()
end
return w.dp_binary(A,a)
end
function w.dp_illuminance(A,c,b)
local a=e(c,b,"illuminance")return w.dp_numeric(A,a)
end
function w.dp_pir_sensitivity(A,c,b)
local a=e(c,b,"sensitivity")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=m.pir_sensitivity_low_medium_high()
end
return B(w.dp_enum(A,a),a)
end
function w.dp_keep_time(A,c,b)
local a=e(c,b,"keep_time")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=m.pir_keep_time_ten_thirty_sixty_one_twenty()
end
return B(w.dp_enum(A,a),a)
end
function w.dp_fading_time(A,c,b)
return j(A,"fading_time",1,c,b)
end
function w.dp_static_detection_distance(A,c,b)
return j(A,"static_detection_distance",100,c,b)
end
function w.dp_static_detection_sensitivity(A,c,b)
return j(A,"static_detection_sensitivity",1,c,b)
end
function w.dp_motion_detection_mode(A,c,b)
local a=e(c,b,"motion_detection_mode")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=m.motion_detection_mode()
end
return w.dp_enum(A,a)
end
function w.dp_motion_detection_sensitivity(A,c,b)
return j(A,"motion_detection_sensitivity",1,c,b)
end
function w.dp_target_distance(A,c,b)
return j(A,"target_distance",100,c,b)
end
end
return ar
