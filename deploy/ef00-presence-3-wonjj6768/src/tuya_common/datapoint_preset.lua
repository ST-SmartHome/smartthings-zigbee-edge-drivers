local function as(y,aB,bs)
bs=bs or{switch=function()return nil end}
local d=aB.type_check
local N=aB.table_insert
local aS=aB.tonumber_check
local j=aB.merge_options
local bm=aB.copy_keys
local q=y.converter
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
return y.apply_fixed_send_policy(bh)
end
local function E(z,g,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return y.dp_numeric(z,a)
end
local function C(z,g,x,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return y.dp_numeric(z,a)
end
local function aW(z,g,x,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
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
return y.dp_numeric(z,a)
end
local function F(z,g,x,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.signed_number_pair(t)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return y.dp_numeric(z,a)
end
local function aH(z,g,x,bc,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
end
local br=
a.datatype==y.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aE={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ap(aE,bc)a.converter=q.raw_uint_be(t,aE)if a.datatype==nil then
a.datatype=y.DP_TYPE_RAW
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
return y.dp_numeric(z,a)
end
local function W(R,bp,bo)
local aA=aS(R)if aA==nil then
return nil
end
return bp+bo-aA
end
local function aU(z,g,K,c,b)
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
local bj=q.scale(af,ae,I,H)local bt=q.scale(I,H,af,ae)a.converter=q.from_to(
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
a.converter=q.scale_pair(af,ae,I,H)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return y.dp_numeric(z,a)
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
return y.dp_raw(z,a)
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
return y.dp_raw(z,a)
end
local function an(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aJ={}for _,z in ipairs(m)do
if d(z)=="number"and z%1==0 and z>=0 then
N(aJ,z)
end
end
return aJ
end
local function aa(b)
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
local m=aa(b)if m~=nil then
return m
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aK(w,b)
b=b or{}local aL=b.phases
if d(aL)~="table"then
aL=b.phase_names
end
local phase=d(aL)=="table"and aL[w]or nil
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
return D..tostring(w)
end
return tostring(w)
end
local function ah(w,b)
b=b or{}local L=b.first_is_main~=false
local J=b.component_prefix
if d(J)~="string"or J==""then
J="switch"
end
local Q=b.main_component
if d(Q)~="string"or Q==""then
Q="main"
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and L then
return Q
end
local aC=L and(w-1+p)or(w+p)if aC<1 then
return b.default_component
end
return J..tostring(aC)
end
local function ay(w,b,aQ)
b=b or{}local L=b.first_is_main~=false
local X=b.key_prefix
if d(X)~="string"or X==""then
X=aQ or"switch"
end
local au=b.main_key
if d(au)~="string"or au==""then
au=X
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and L then
return au
end
local aC=L and(w-1+p)or(w+p)if aC<1 then
return b.default_key
end
return X..tostring(aC)
end
local function S(h,z,v,b)
if d(z)~="number"or z%1~=0 or z<0 then
return
end
N(h,v(z,b))
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
local function o(b,i)
local a={}if d(b)~="table"then
return a
end
for ar,R in pairs(b)do
local aF=true
if not i then
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
local w=1
while b[w]~=nil do
b[w]=nil
w=w+1
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
local function V(b,n)
if d(b)~="table"then
return nil
end
return u(b[n])
end
local function av(at,f)
local M=d(at)=="table"and at.item_options or nil
local B=d(f)=="table"and f.item_options or nil
if d(M)~="table"then
return d(B)=="table"and B or nil
end
if d(B)~="table"then
return M
end
local a={}j(a,M)j(a,B)return a
end
local function ag(b,n,A,i)
local a={}local r=nil
if d(b)=="table"then
bm(a,b,ak)r=b[n]if d(r)=="table"then
j(a,o(b,i))if i and ac(r)then
G(a)
end
j(a,r)elseif r~=nil then
j(a,o(b,i))if i then
G(a)
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
local function O(b,l)
local k={}local aq=V(b,"config")j(k,aq)local aw=u(k[l])if aw~=nil then
k[l]=aw
else
local Y=u(k.switch_type)if Y==nil then
Y=V(b,"switch_type")
end
if d(Y)=="table"then
k[l]=Y
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
local function P(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local k=O(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aV(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local U=P(
s(b,"switch_module"),l)if next(U)~=nil then
a.switch_module=U
end
return a
end
local function bl(h,b,n,v)
local f=s(b,n)S(h,f.dp,v,f)
end
local function aD(h,b,n,v,K)
local f=s(b,n)ap(f,K)S(h,f.dp,v,f)
end
local function aT(h,b,n,v,az)
local f=s(b,n)local m=aa(f)if m~=nil and az~=nil then
ab(h,az(m,f))return
end
S(h,f.dp,v,f)
end
local function aM(h,b,n,A,v)
local f=ag(b,n,A)ab(h,v(ad(f),f))
end
local function bg(m,v,g,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
for w,z in ipairs(aj)do
local a=e(ai,nil,g)if a.component==nil then
a.component=ah(w,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(w,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
N(h,v(z,a))
end
return h
end
local function aO(m,v,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
for w,z in ipairs(aj)do
local a=e(ai,nil,nil)if a.phase==nil then
a.phase=aK(w,b)
end
N(h,v(z,a))
end
return h
end
local function aN(b,n,v)
local f=nil
if d(b)=="table"then
f=s(b,n,true)else
f={dp=b}
end
local h={}S(h,f.dp,v,f)return h
end
function y.dp_on_off(z,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return y.dp_binary(z,a)
end
function y.dp_temperature(z,c,b)
return E(z,"temperature",c,b)
end
function y.dp_humidity(z,c,b)
return E(z,"humidity",c,b)
end
function y.dp_illuminance(z,c,b)
local a=e(c,b,"illuminance")return y.dp_numeric(z,a)
end
function y.dp_temperature_calibration(z,c,b)
return F(z,"temperature_calibration",10,c,b)
end
function y.dp_humidity_calibration(z,c,b)
return F(z,"humidity_calibration",1,c,b)
end
function y.dp_presence(z,c,b)
return y.dp_binary(z,e(c,b,"presence"))
end
function y.dp_static_detection_distance(z,c,b)
return C(z,"static_detection_distance",100,c,b)
end
function y.dp_target_distance(z,c,b)
return C(z,"target_distance",100,c,b)
end
end
return as
