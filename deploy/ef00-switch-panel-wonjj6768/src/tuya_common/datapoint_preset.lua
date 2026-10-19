local function ar(x,aA,bs)
bs=bs or{switch=function()return nil end}
local d=aA.type_check
local L=aA.table_insert
local aQ=aA.tonumber_check
local j=aA.merge_options
local bm=aA.copy_keys
local o=x.converter
local function ao(X,I)
if d(X)~="table"or d(I)~="table"then
return X
end
for aq,P in pairs(I)do
if X[aq]==nil then
X[aq]=P
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
local function u(bh,b)
if ak(b)then
return bh
end
return x.apply_fixed_send_policy(bh)
end
local function aT(A,g,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=o.divide_by_pair(t)
end
a.scale=nil
return x.dp_numeric(A,a)
end
local function Z(A,g,z,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=z
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=o.divide_by_pair(t)
end
a.scale=nil
return x.dp_numeric(A,a)
end
local function aW(A,g,z,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=z
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local an=o.power()local bf=an.from
if t~=1 then
a.from_device=o.pipe(
bf,o.divide_by(t))else
a.converter=an
end
end
a.scale=nil
return x.dp_numeric(A,a)
end
local function aU(A,g,z,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=z
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=o.signed_number_pair(t)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return x.dp_numeric(A,a)
end
local function aF(A,g,z,bc,c,b)
local a=e(c,b,g)local t=a.scale
if t==nil then
t=z
end
local br=
a.datatype==x.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aD={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}ao(aD,bc)a.converter=o.raw_uint_be(t,aD)if a.datatype==nil then
a.datatype=x.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and t~=1 then
a.converter=o.divide_by_pair(t)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return x.dp_numeric(A,a)
end
local function U(P,bp,bo)
local az=aQ(P)if az==nil then
return nil
end
return bp+bo-az
end
local function aS(A,g,I,c,b)
local a=e(c,b,g)local ae=a.raw_min
if ae==nil then
ae=I.raw_min
end
local ad=a.raw_max
if ad==nil then
ad=I.raw_max
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
local bj=o.scale(ae,ad,G,F)local bt=o.scale(G,F,ae,ad)a.converter=o.from_to(
function(P,aY,aN)
local bq=bj(P,aY,aN)if bq==nil then
return nil
end
return U(bq,G,F)
end,
function(P,aY,aN)
local ba=U(P,G,F)if ba==nil then
return nil
end
return bt(ba,aY,aN)
end
)elseif ae~=G or ad~=F then
a.converter=o.scale_pair(ae,ad,G,F)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return x.dp_numeric(A,a)
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
return x.dp_raw(A,a)
end
local function be(A,c,b)
local a=e(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=o.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return x.dp_raw(A,a)
end
local function am(m)
if d(m)=="number"and m%1==0 and m>=0 then
return{m}
end
if d(m)~="table"then
return{}
end
local aH={}for _,A in ipairs(m)do
if d(A)=="number"and A%1==0 and A>=0 then
L(aH,A)
end
end
return aH
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
local function ac(b)
local m=Y(b)if m~=nil then
return m
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
local function ag(y,b)
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
local aB=J and(y-1+q)or(y+q)if aB<1 then
return b.default_component
end
return H..tostring(aB)
end
local function ax(y,b,aO)
b=b or{}local J=b.first_is_main~=false
local V=b.key_prefix
if d(V)~="string"or V==""then
V=aO or"switch"
end
local at=b.main_key
if d(at)~="string"or at==""then
at=V
end
local q=b.index_offset
if d(q)~="number"or q%1~=0 then
q=0
end
if y==1 and J then
return at
end
local aB=J and(y-1+q)or(y+q)if aB<1 then
return b.default_key
end
return V..tostring(aB)
end
local function Q(h,A,w,b)
if d(A)~="number"or A%1~=0 or A<0 then
return
end
L(h,w(A,b))
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
local aj={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function aw(P)
return d(P)=="number"and P%1==0 and P>0
end
local function p(b,i)
local a={}if d(b)~="table"then
return a
end
for aq,P in pairs(b)do
local aE=true
if not i then
if aq=="dp"or aq=="dps"or aq=="dp_list"then
aE=false
elseif aw(aq)then
aE=false
end
end
if aE then
a[aq]=P
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
local function s(b,n,i)
if d(b)~="table"then
return{}
end
local r=b[n]if r==nil then
return p(b,i)
end
local a=p(b,i)if d(r)=="table"then
j(a,r)else
a.dp=r
end
return a
end
local function v(r)
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
return v(b[n])
end
local function au(as,f)
local K=d(as)=="table"and as.item_options or nil
local C=d(f)=="table"and f.item_options or nil
if d(K)~="table"then
return d(C)=="table"and C or nil
end
if d(C)~="table"then
return K
end
local a={}j(a,K)j(a,C)return a
end
local function af(b,n,B,i)
local a={}local r=nil
if d(b)=="table"then
bm(a,b,aj)r=b[n]if d(r)=="table"then
j(a,p(b,i))if i and ab(r)then
E(a)
end
j(a,r)elseif r~=nil then
j(a,p(b,i))if i then
E(a)
end
a.dp=r
else
j(a,p(b,i))
end
end
if a.key_prefix==nil and B~=nil then
a.key_prefix=B
end
a.item_options=au(b,r)return a
end
local function M(b,l)
local k={}local ap=T(b,"config")j(k,ap)local av=v(k[l])if av~=nil then
k[l]=av
else
local W=v(k.switch_type)if W==nil then
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
local function N(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local k=M(b,l)if next(k)~=nil then
a.config=k
end
a.switch_type=nil
return a
end
local function aV(b,l)
local a={}if d(b)=="table"then
j(a,b)
end
local S=N(
s(b,"switch_module"),l)if next(S)~=nil then
a.switch_module=S
end
return a
end
local function bl(h,b,n,w)
local f=s(b,n)Q(h,f.dp,w,f)
end
local function aC(h,b,n,w,I)
local f=s(b,n)ao(f,I)Q(h,f.dp,w,f)
end
local function aR(h,b,n,w,ay)
local f=s(b,n)local m=Y(f)if m~=nil and ay~=nil then
aa(h,ay(m,f))return
end
Q(h,f.dp,w,f)
end
local function aK(h,b,n,B,w)
local f=af(b,n,B)aa(h,w(ac(f),f))
end
local function bg(m,w,g,b)
local h={}local ai=am(m)local ah=d(b)=="table"and b.item_options or nil
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
L(h,w(A,a))
end
return h
end
local function aM(m,w,b)
local h={}local ai=am(m)local ah=d(b)=="table"and b.item_options or nil
for y,A in ipairs(ai)do
local a=e(ah,nil,nil)if a.phase==nil then
a.phase=aI(y,b)
end
L(h,w(A,a))
end
return h
end
local function aL(b,n,w)
local f=nil
if d(b)=="table"then
f=s(b,n,true)else
f={dp=b}
end
local h={}Q(h,f.dp,w,f)return h
end
function x.dp_on_off(A,c,b)
local a=e(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bs.switch()
end
return x.dp_binary(A,a)
end
function x.dp_child_lock(A,c,b)
return x.dp_binary(A,e(c,b,"child_lock"))
end
function x.dp_power_on_behavior(A,c,b)
local a=e(c,b,"power_on_behavior")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=o.power_on_behavior()
end
return u(x.dp_enum(A,a),a)
end
function x.dp_backlight_mode_off_on(A,c,b)
local a=e(c,b,"backlight_mode")return u(x.dp_binary(A,a),a)
end
function x.dp_indicator_mode_none_relay_pos(A,c,b)
local a=e(c,b,"indicator_mode")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=o.indicator_mode_none_relay_pos()
end
return u(x.dp_enum(A,a),a)
end
function x.dp_inching_switch(A,c,b)
local a=e(c,b,"inching_switch")if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=o.inching_switch()
end
return x.dp_raw(A,a)
end
function x.dp_countdown(A,c,b)
return Z(A,"countdown",1,c,b)
end
function x.dp_presence(A,c,b)
return x.dp_binary(A,e(c,b,"presence"))
end
end
return ar
