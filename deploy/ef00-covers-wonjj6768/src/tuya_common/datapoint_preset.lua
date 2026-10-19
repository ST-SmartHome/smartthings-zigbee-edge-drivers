local function as(y,aB,bs)
bs=bs or{switch=function()return nil end}
local d=aB.type_check
local K=aB.table_insert
local aR=aB.tonumber_check
local j=aB.merge_options
local bm=aB.copy_keys
local q=y.converter
local function ap(X,H)
if d(X)~="table"or d(H)~="table"then
return X
end
for ar,O in pairs(H)do
if X[ar]==nil then
X[ar]=O
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
local function S(bh,b)
if al(b)then
return bh
end
return y.apply_fixed_send_policy(bh)
end
local function aT(B,g,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return y.dp_numeric(B,a)
end
local function Z(B,g,x,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=x
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=q.divide_by_pair(t)
end
a.scale=nil
return y.dp_numeric(B,a)
end
local function aW(B,g,x,c,b)
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
return y.dp_numeric(B,a)
end
local function aU(B,g,x,c,b)
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
return y.dp_numeric(B,a)
end
local function aG(B,g,x,bc,c,b)
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
return y.dp_numeric(B,a)
end
local function U(O,bp,bo)
local aA=aR(O)if aA==nil then
return nil
end
return bp+bo-aA
end
local function ab(B,g,H,c,b)
local a=e(c,b,g)local af=a.raw_min
if af==nil then
af=H.raw_min
end
local ae=a.raw_max
if ae==nil then
ae=H.raw_max
end
local F=a.value_min
if F==nil then
F=H.value_min
end
local E=a.value_max
if E==nil then
E=H.value_max
end
local bv=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bv then
local bj=q.scale(af,ae,F,E)local bt=q.scale(F,E,af,ae)a.converter=q.from_to(
function(O,aY,aO)
local bq=bj(O,aY,aO)if bq==nil then
return nil
end
return U(bq,F,E)
end,
function(O,aY,aO)
local ba=U(O,F,E)if ba==nil then
return nil
end
return bt(ba,aY,aO)
end
)elseif af~=F or ae~=E then
a.converter=q.scale_pair(af,ae,F,E)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return y.dp_numeric(B,a)
end
local function bk(phase,aZ)
if d(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,ar in ipairs(bx or{})do
local aH=ar
if d(phase)=="string"and phase~=""then
aH=ar.."_"..phase
end
bn[aH]=true
end
return bn
end
local function bd(B,g,aQ,bi,c,b)
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
a.converter=aQ(a)
end
if a.field==nil and a.fields==nil then
a.fields=bb(bi,phase)
end
return y.dp_raw(B,a)
end
local function be(B,c,b)
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
return y.dp_raw(B,a)
end
local function an(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aI={}for _,B in ipairs(m)do
if d(B)=="number"and B%1==0 and B>=0 then
K(aI,B)
end
end
return aI
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
local function aJ(w,b)
b=b or{}local aK=b.phases
if d(aK)~="table"then
aK=b.phase_names
end
local phase=d(aK)=="table"and aK[w]or nil
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
return C..tostring(w)
end
return tostring(w)
end
local function ah(w,b)
b=b or{}local I=b.first_is_main~=false
local G=b.component_prefix
if d(G)~="string"or G==""then
G="switch"
end
local N=b.main_component
if d(N)~="string"or N==""then
N="main"
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and I then
return N
end
local aC=I and(w-1+p)or(w+p)if aC<1 then
return b.default_component
end
return G..tostring(aC)
end
local function ay(w,b,aP)
b=b or{}local I=b.first_is_main~=false
local V=b.key_prefix
if d(V)~="string"or V==""then
V=aP or"switch"
end
local au=b.main_key
if d(au)~="string"or au==""then
au=V
end
local p=b.index_offset
if d(p)~="number"or p%1~=0 then
p=0
end
if w==1 and I then
return au
end
local aC=I and(w-1+p)or(w+p)if aC<1 then
return b.default_key
end
return V..tostring(aC)
end
local function P(h,B,v,b)
if d(B)~="number"or B%1~=0 or B<0 then
return
end
K(h,v(B,b))
end
local function aa(X,bu)
if d(bu)~="table"then
return X
end
for _,bw in ipairs(bu)do
K(X,bw)
end
return X
end
local ak={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ax(O)
return d(O)=="number"and O%1==0 and O>0
end
local function o(b,i)
local a={}if d(b)~="table"then
return a
end
for ar,O in pairs(b)do
local aF=true
if not i then
if ar=="dp"or ar=="dps"or ar=="dp_list"then
aF=false
elseif ax(ar)then
aF=false
end
end
if aF then
a[ar]=O
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
local function D(b)
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
local function T(b,n)
if d(b)~="table"then
return nil
end
return u(b[n])
end
local function av(at,f)
local J=d(at)=="table"and at.item_options or nil
local A=d(f)=="table"and f.item_options or nil
if d(J)~="table"then
return d(A)=="table"and A or nil
end
if d(A)~="table"then
return J
end
local a={}j(a,J)j(a,A)return a
end
local function ag(b,n,z,i)
local a={}local r=nil
if d(b)=="table"then
bm(a,b,ak)r=b[n]if d(r)=="table"then
j(a,o(b,i))if i and ac(r)then
D(a)
end
j(a,r)elseif r~=nil then
j(a,o(b,i))if i then
D(a)
end
a.dp=r
else
j(a,o(b,i))
end
end
if a.key_prefix==nil and z~=nil then
a.key_prefix=z
end
a.item_options=av(b,r)return a
end
local function L(b,l)
local k={}local aq=T(b,"config")j(k,aq)local aw=u(k[l])if aw~=nil then
k[l]=aw
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
local function M(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local k=L(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aV(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local R=M(
s(b,"switch_module"),l)if next(R)~=nil then
a.switch_module=R
end
return a
end
local function bl(h,b,n,v)
local f=s(b,n)P(h,f.dp,v,f)
end
local function aD(h,b,n,v,H)
local f=s(b,n)ap(f,H)P(h,f.dp,v,f)
end
local function aS(h,b,n,v,az)
local f=s(b,n)local m=Y(f)if m~=nil and az~=nil then
aa(h,az(m,f))return
end
P(h,f.dp,v,f)
end
local function aL(h,b,n,z,v)
local f=ag(b,n,z)aa(h,v(ad(f),f))
end
local function bg(m,v,g,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
for w,B in ipairs(aj)do
local a=e(ai,nil,g)if a.component==nil then
a.component=ah(w,b)
end
if a.key==nil and a.preference==nil then
a.key=ay(w,b,g)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
K(h,v(B,a))
end
return h
end
local function aN(m,v,b)
local h={}local aj=an(m)local ai=d(b)=="table"and b.item_options or nil
for w,B in ipairs(aj)do
local a=e(ai,nil,nil)if a.phase==nil then
a.phase=aJ(w,b)
end
K(h,v(B,a))
end
return h
end
local function aM(b,n,v)
local f=nil
if d(b)=="table"then
f=s(b,n,true)else
f={dp=b}
end
local h={}P(h,f.dp,v,f)return h
end
function y.dp_on_off(B,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return y.dp_binary(B,a)
end
function y.dp_battery(B,c,b)
return Z(B,"battery",1,c,b)
end
function y.dp_child_lock(B,c,b)
return y.dp_binary(B,e(c,b,"child_lock"))
end
function y.dp_backlight_mode_off_on(B,c,b)
local a=e(c,b,"backlight_mode")return S(y.dp_binary(B,a),a)
end
function y.dp_cover_position(B,c,b)
return ab(
B,"cover_position",{raw_min=0,raw_max=100,value_min=0,value_max=100},c,b)
end
function y.dp_cover_position_inverted(B,c,b)
local a=e(c,b,"cover_position")if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=q.cover_position_inverted()
end
return y.dp_numeric(B,a)
end
end
return as
