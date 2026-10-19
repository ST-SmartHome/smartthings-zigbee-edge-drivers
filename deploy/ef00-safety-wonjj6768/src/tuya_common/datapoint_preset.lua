local function as(m,aB,bs)
bs=bs or{switch=function()return nil end}
local e=aB.type_check
local N=aB.table_insert
local aR=aB.tonumber_check
local k=aB.merge_options
local bm=aB.copy_keys
local i=m.converter
local function ap(Z,K)
if e(Z)~="table"or e(K)~="table"then
return Z
end
for ar,R in pairs(K)do
if Z[ar]==nil then
Z[ar]=R
end
end
return Z
end
local function d(c,b,g)
local a={}if e(c)=="string"then
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
local function x(bh,b)
if al(b)then
return bh
end
return m.apply_fixed_send_policy(bh)
end
local function F(t,g,c,b)
local a=d(c,b,g)local w=a.scale
if w==nil then
w=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=i.divide_by_pair(w)
end
a.scale=nil
return m.dp_numeric(t,a)
end
local function s(t,g,B,c,b)
local a=d(c,b,g)local w=a.scale
if w==nil then
w=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=i.divide_by_pair(w)
end
a.scale=nil
return m.dp_numeric(t,a)
end
local function aW(t,g,B,c,b)
local a=d(c,b,g)local w=a.scale
if w==nil then
w=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ao=i.power()local bf=ao.from
if w~=1 then
a.from_device=i.pipe(
bf,i.divide_by(w))else
a.converter=ao
end
end
a.scale=nil
return m.dp_numeric(t,a)
end
local function aU(t,g,B,c,b)
local a=d(c,b,g)local w=a.scale
if w==nil then
w=B
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=i.signed_number_pair(w)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return m.dp_numeric(t,a)
end
local function aG(t,g,B,bc,c,b)
local a=d(c,b,g)local w=a.scale
if w==nil then
w=B
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
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ap(aE,bc)a.converter=i.raw_uint_be(w,aE)if a.datatype==nil then
a.datatype=m.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=i.divide_by_pair(w)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return m.dp_numeric(t,a)
end
local function W(R,bp,bo)
local aA=aR(R)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aT(t,g,K,c,b)
local a=d(c,b,g)local af=a.raw_min
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
local bj=i.scale(af,ae,I,H)local bt=i.scale(I,H,af,ae)a.converter=i.from_to(
function(R,aY,aO)
local bq=bj(R,aY,aO)if bq==nil then
return nil
end
return W(bq,I,H)
end,
function(R,aY,aO)
local ba=W(R,I,H)if ba==nil then
return nil
end
return bt(ba,aY,aO)
end
)elseif af~=I or ae~=H then
a.converter=i.scale_pair(af,ae,I,H)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return m.dp_numeric(t,a)
end
local function bk(phase,aZ)
if e(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,ar in ipairs(bx or{})do
local aH=ar
if e(phase)=="string"and phase~=""then
aH=ar.."_"..phase
end
bn[aH]=true
end
return bn
end
local function bd(t,g,aQ,bi,c,b)
local aX=
e(c)=="string"or
(e(c)=="table"and c.name~=nil)or
(e(b)=="table"and b.name~=nil)local a=d(c,b,g)local phase=a.phase
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
return m.dp_raw(t,a)
end
local function be(t,c,b)
local a=d(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=i.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return m.dp_raw(t,a)
end
local function an(o)
if e(o)=="number"and o%1==0 and o>=0 then
return{o}
end
if e(o)~="table"then
return{}
end
local aI={}for _,t in ipairs(o)do
if e(t)=="number"and t%1==0 and t>=0 then
N(aI,t)
end
end
return aI
end
local function aa(b)
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
local o=aa(b)if o~=nil then
return o
end
if e(b)~="table"then
return b
end
return b.dp
end
local function aJ(A,b)
b=b or{}local aK=b.phases
if e(aK)~="table"then
aK=b.phase_names
end
local phase=e(aK)=="table"and aK[A]or nil
if e(phase)=="string"and phase~=""then
return phase
end
local E=b.phase_prefix
if E==false then
return nil
end
if e(E)~="string"or E==""then
E=nil
end
if E~=nil then
return E..tostring(A)
end
return tostring(A)
end
local function ah(A,b)
b=b or{}local L=b.first_is_main~=false
local J=b.component_prefix
if e(J)~="string"or J==""then
J="switch"
end
local Q=b.main_component
if e(Q)~="string"or Q==""then
Q="main"
end
local r=b.index_offset
if e(r)~="number"or r%1~=0 then
r=0
end
if A==1 and L then
return Q
end
local aC=L and(A-1+r)or(A+r)if aC<1 then
return b.default_component
end
return J..tostring(aC)
end
local function ay(A,b,aP)
b=b or{}local L=b.first_is_main~=false
local X=b.key_prefix
if e(X)~="string"or X==""then
X=aP or"switch"
end
local au=b.main_key
if e(au)~="string"or au==""then
au=X
end
local r=b.index_offset
if e(r)~="number"or r%1~=0 then
r=0
end
if A==1 and L then
return au
end
local aC=L and(A-1+r)or(A+r)if aC<1 then
return b.default_key
end
return X..tostring(aC)
end
local function S(h,t,z,b)
if e(t)~="number"or t%1~=0 or t<0 then
return
end
N(h,z(t,b))
end
local function ab(Z,bu)
if e(bu)~="table"then
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
return e(R)=="number"and R%1==0 and R>0
end
local function q(b,j)
local a={}if e(b)~="table"then
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
if e(b)~="table"then
return false
end
if b.dp~=nil or b.dps~=nil or b.dp_list~=nil or b[1]~=nil then
return true
end
return false
end
local function G(b)
if e(b)~="table"then
return b
end
b.dp=nil
b.dps=nil
b.dp_list=nil
local A=1
while b[A]~=nil do
b[A]=nil
A=A+1
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
local function y(u)
if u==nil then
return nil
end
if e(u)=="table"then
return u
end
return{dp=u}
end
local function V(b,p)
if e(b)~="table"then
return nil
end
return y(b[p])
end
local function av(at,f)
local M=e(at)=="table"and at.item_options or nil
local D=e(f)=="table"and f.item_options or nil
if e(M)~="table"then
return e(D)=="table"and D or nil
end
if e(D)~="table"then
return M
end
local a={}k(a,M)k(a,D)return a
end
local function ag(b,p,C,j)
local a={}local u=nil
if e(b)=="table"then
bm(a,b,ak)u=b[p]if e(u)=="table"then
k(a,q(b,j))if j and ac(u)then
G(a)
end
k(a,u)elseif u~=nil then
k(a,q(b,j))if j then
G(a)
end
a.dp=u
else
k(a,q(b,j))
end
end
if a.key_prefix==nil and C~=nil then
a.key_prefix=C
end
a.item_options=av(b,u)return a
end
local function O(b,n)
local l={}local aq=V(b,"config")k(l,aq)local aw=y(l[n])if aw~=nil then
l[n]=aw
else
local Y=y(l.switch_type)if Y==nil then
Y=V(b,"switch_type")
end
if e(Y)=="table"then
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
local a={}if e(b)=="table"then
k(a,b)
end
local l=O(b,n)if next(l)~=nil then
a.config=l
end
a.switch_type=nil
return a
end
local function aV(b,n)
local a={}if e(b)=="table"then
k(a,b)
end
local U=P(
v(b,"switch_module"),n)if next(U)~=nil then
a.switch_module=U
end
return a
end
local function bl(h,b,p,z)
local f=v(b,p)S(h,f.dp,z,f)
end
local function aD(h,b,p,z,K)
local f=v(b,p)ap(f,K)S(h,f.dp,z,f)
end
local function aS(h,b,p,z,az)
local f=v(b,p)local o=aa(f)if o~=nil and az~=nil then
ab(h,az(o,f))return
end
S(h,f.dp,z,f)
end
local function aL(h,b,p,C,z)
local f=ag(b,p,C)ab(h,z(ad(f),f))
end
local function bg(o,z,g,b)
local h={}local aj=an(o)local ai=e(b)=="table"and b.item_options or nil
for A,t in ipairs(aj)do
local a=d(ai,nil,g)if a.component==nil then
a.component=ah(A,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(A,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
N(h,z(t,a))
end
return h
end
local function aN(o,z,b)
local h={}local aj=an(o)local ai=e(b)=="table"and b.item_options or nil
for A,t in ipairs(aj)do
local a=d(ai,nil,nil)if a.phase==nil then
a.phase=aJ(A,b)
end
N(h,z(t,a))
end
return h
end
local function aM(b,p,z)
local f=nil
if e(b)=="table"then
f=v(b,p,true)else
f={dp=b}
end
local h={}S(h,f.dp,z,f)return h
end
function m.dp_on_off(t,c,b)
local a=d(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return m.dp_binary(t,a)
end
function m.dp_temperature(t,c,b)
return F(t,"temperature",c,b)
end
function m.dp_humidity(t,c,b)
return F(t,"humidity",c,b)
end
function m.dp_battery(t,c,b)
return s(t,"battery",1,c,b)
end
function m.dp_contact(t,c,b)
return m.dp_binary(t,d(c,b,"contact"))
end
function m.dp_illuminance(t,c,b)
local a=d(c,b,"illuminance")return m.dp_numeric(t,a)
end
function m.dp_gas(t,c,b)
local a=d(c,b,"gas")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=i.true_false0()
end
return m.dp_binary(t,a)
end
function m.dp_smoke(t,c,b)
local a=d(c,b,"smoke")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=i.true_false0()
end
return m.dp_binary(t,a)
end
function m.dp_smoke_concentration(t,c,b)
return s(t,"smoke_concentration",10,c,b)
end
function m.dp_silence(t,c,b)
local a=d(c,b,"silence")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=i.true_false1()
end
return x(m.dp_binary(t,a),a)
end
function m.dp_alarm_time(t,c,b)
return x(
s(t,"alarm_time",1,c,b),d(c,b,"alarm_time"))
end
function m.dp_alarm_ringtone(t,c,b)
local a=d(c,b,"alarm_ringtone")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=i.alarm_ringtone_melody_five()
end
return x(m.dp_enum(t,a),a)
end
function m.dp_tamper(t,c,b)
local a=d(c,b,"tamper")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=i.true_false1()
end
return m.dp_binary(t,a)
end
function m.dp_battery_low(t,c,b)
local a=d(c,b,"battery_low")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=i.true_false0()
end
return m.dp_binary(t,a)
end
function m.dp_carbon_monoxide(t,c,b)
local a=d(c,b,"carbon_monoxide")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=i.true_false0()
end
return m.dp_binary(t,a)
end
function m.dp_co(t,c,b)
return s(t,"co",1,c,b)
end
function m.dp_water_leak(t,c,b)
local a=d(c,b,"water_leak")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=i.true_false0()
end
return m.dp_binary(t,a)
end
end
return as
