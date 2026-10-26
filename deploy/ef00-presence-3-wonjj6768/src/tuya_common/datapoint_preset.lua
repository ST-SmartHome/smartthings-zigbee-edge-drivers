local function ar(z,aA,br)
br=br or{switch=function()return nil end}
local d=aA.type_check
local M=aA.table_insert
local aR=aA.tonumber_check
local j=aA.merge_options
local bl=aA.copy_keys
local u=z.converter
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
j(a,c)
end
j(a,b)if a.name==nil and g~=nil then
a.name=g
end
return a
end
local al={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response"}
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
local function aF(bg,b)
if ak(b)then
return bg
end
return z.apply_fixed_send_policy(bg)
end
local function q(A,g,x,c,b)
local a=e(c,b,g)local y=a.scale
if y==nil then
y=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and y~=1 then
a.converter=u.divide_by_pair(y)
end
a.scale=nil
return z.dp_numeric(A,a)
end
local function aV(A,g,x,c,b)
local a=e(c,b,g)local y=a.scale
if y==nil then
y=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local an=u.power()local be=an.from
if y~=1 then
a.from_device=u.pipe(
be,u.divide_by(y))else
a.converter=an
end
end
a.scale=nil
return z.dp_numeric(A,a)
end
local function E(A,g,x,c,b)
local a=e(c,b,g)local y=a.scale
if y==nil then
y=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=u.signed_number_pair(y)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return z.dp_numeric(A,a)
end
local function aG(A,g,x,bb,c,b)
local a=e(c,b,g)local y=a.scale
if y==nil then
y=x
end
local bq=
a.datatype==z.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if bq and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aD={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset}ao(aD,bb)a.converter=u.raw_uint_be(y,aD)if a.datatype==nil then
a.datatype=z.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and y~=1 then
a.converter=u.divide_by_pair(y)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return z.dp_numeric(A,a)
end
local function V(Q,bo,bn)
local az=aR(Q)if az==nil then
return nil
end
return bo+bn-az
end
local function aT(A,g,J,c,b)
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
local bu=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bu then
local bi=u.scale(ae,ad,H,G)local bs=u.scale(H,G,ae,ad)a.converter=u.from_to(
function(Q,aX,aO)
local bp=bi(Q,aX,aO)if bp==nil then
return nil
end
return V(bp,H,G)
end,
function(Q,aX,aO)
local aZ=V(Q,H,G)if aZ==nil then
return nil
end
return bs(aZ,aX,aO)
end
)elseif ae~=H or ad~=G then
a.converter=u.scale_pair(ae,ad,H,G)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return z.dp_numeric(A,a)
end
local function bj(phase,aY)
if d(phase)=="string"and phase~=""then
return(aY or"phase").."_"..phase
end
return aY or"phase"
end
local function ba(bw,phase)
local bm={}for _,aq in ipairs(bw or{})do
local aH=aq
if d(phase)=="string"and phase~=""then
aH=aq.."_"..phase
end
bm[aH]=true
end
return bm
end
local function bc(A,g,aQ,bh,c,b)
local aW=
d(c)=="string"or
(d(c)=="table"and c.name~=nil)or
(d(b)=="table"and b.name~=nil)local a=e(c,b,g)local phase=a.phase
if not aW and a.name==g then
a.name=bj(phase,g)
end
if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=aQ(a)
end
if a.field==nil and a.fields==nil then
a.fields=ba(bh,phase)
end
return z.dp_raw(A,a)
end
local function bd(A,c,b)
local a=e(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=u.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true}
end
return z.dp_raw(A,a)
end
local function am(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aI={}for _,A in ipairs(m)do
if d(A)=="number"and A%1==0 and A>=0 then
M(aI,A)
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
local function ac(b)
local m=Z(b)if m~=nil then
return m
end
if d(b)~="table"then
return b
end
return b.dp
end
local function aJ(w,b)
b=b or{}local aK=b.phases
if d(aK)~="table"then
aK=b.phase_names
end
local phase=d(aK)=="table"and aK[w]or nil
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
local function ag(w,b)
b=b or{}local K=b.first_is_main~=false
local I=b.component_prefix
if d(I)~="string"or I==""then
I="switch"
end
local P=b.main_component
if d(P)~="string"or P==""then
P="main"
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and K then
return P
end
local aB=K and(w-1+p)or(w+p)if aB<1 then
return b.default_component
end
return I..tostring(aB)
end
local function ax(w,b,aP)
b=b or{}local K=b.first_is_main~=false
local W=b.key_prefix
if d(W)~="string"or W==""then
W=aP or"switch"
end
local at=b.main_key
if d(at)~="string"or at==""then
at=W
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and K then
return at
end
local aB=K and(w-1+p)or(w+p)if aB<1 then
return b.default_key
end
return W..tostring(aB)
end
local function R(h,A,v,b)
if d(A)~="number"or A%1~=0 or A<0 then
return
end
M(h,v(A,b))
end
local function aa(Y,bt)
if d(bt)~="table"then
return Y
end
for _,bv in ipairs(bt)do
M(Y,bv)
end
return Y
end
local aj={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key"}
local function aw(Q)
return d(Q)=="number"and Q%1==0 and Q>0
end
local function o(b,i)
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
local function t(r)
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
return t(b[n])
end
local function au(as,f)
local L=d(as)=="table"and as.item_options or nil
local C=d(f)=="table"and f.item_options or nil
if d(L)~="table"then
return d(C)=="table"and C or nil
end
if d(C)~="table"then
return L
end
local a={}j(a,L)j(a,C)return a
end
local function af(b,n,B,i)
local a={}local r
if d(b)=="table"then
bl(a,b,aj)r=b[n]if d(r)=="table"then
j(a,o(b,i))if i and ab(r)then
F(a)
end
j(a,r)elseif r~=nil then
j(a,o(b,i))if i then
F(a)
end
a.dp=r
else
j(a,o(b,i))
end
end
if a.key_prefix==nil and B~=nil then
a.key_prefix=B
end
a.item_options=au(b,r)return a
end
local function N(b,l)
local k={}local ap=U(b,"config")j(k,ap)local av=t(k[l])if av~=nil then
k[l]=av
else
local X=t(k.switch_type)if X==nil then
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
local function O(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local k=N(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aU(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local T=O(
s(b,"switch_module"),l)if next(T)~=nil then
a.switch_module=T
end
return a
end
local function bk(h,b,n,v)
local f=s(b,n)R(h,f.dp,v,f)
end
local function aC(h,b,n,v,J)
local f=s(b,n)ao(f,J)R(h,f.dp,v,f)
end
local function aS(h,b,n,v,ay)
local f=s(b,n)local m=Z(f)if m~=nil and ay~=nil then
aa(h,ay(m,f))return
end
R(h,f.dp,v,f)
end
local function aL(h,b,n,B,v)
local f=af(b,n,B)aa(h,v(ac(f),f))
end
local function bf(m,v,g,b)
local h={}local ai=am(m)local ah=d(b)=="table"and b.item_options or nil
for w,A in ipairs(ai)do
local a=e(ah,nil,g)if a.component==nil then
a.component=ag(w,b)
end
if a.key==nil and a.preference==nil then
a.key=ax(w,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
M(h,v(A,a))
end
return h
end
local function aN(m,v,b)
local h={}local ai=am(m)local ah=d(b)=="table"and b.item_options or nil
for w,A in ipairs(ai)do
local a=e(ah,nil,nil)if a.phase==nil then
a.phase=aJ(w,b)
end
M(h,v(A,a))
end
return h
end
local function aM(b,n,v)
local f
if d(b)=="table"then
f=s(b,n,true)else
f={dp=b}
end
local h={}R(h,f.dp,v,f)return h
end
function z.dp_on_off(A,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=br.switch()
end
return z.dp_binary(A,a)
end
function z.dp_temperature(A,c,b)
return q(A,"temperature",10,c,b)
end
function z.dp_humidity(A,c,b)
return q(A,"humidity",10,c,b)
end
function z.dp_illuminance(A,c,b)
local a=e(c,b,"illuminance")return z.dp_numeric(A,a)
end
function z.dp_temperature_calibration(A,c,b)
return E(A,"temperature_calibration",10,c,b)
end
function z.dp_humidity_calibration(A,c,b)
return E(A,"humidity_calibration",1,c,b)
end
function z.dp_presence(A,c,b)
return z.dp_binary(A,e(c,b,"presence"))
end
function z.dp_static_detection_distance(A,c,b)
return q(A,"static_detection_distance",100,c,b)
end
function z.dp_target_distance(A,c,b)
return q(A,"target_distance",100,c,b)
end
end
return ar
