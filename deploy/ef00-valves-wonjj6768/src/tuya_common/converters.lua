local function ah(aJ,x)
local aM=x.utils
local z=x.log
local v=x.math_floor
local d=x.type_check
local c=x.tonumber_check
local am=x.raw_bytes
local L=x.string_byte
local at=x.string_char
local B=x.string_len
local J=x.table_concat
local E={}
local function aK(f)
return f
end
local function n(ax,e,b)
if d(ax)=="function"then
return ax(e,b)
end
return ax
end
local function s(l,e,b)
if d(l)=="function"then
return l(e,b)
end
return l
end
local function i(ax,e,b)
local y=n(ax,e,b)if y==nil then
return nil
end
return c(y)
end
local function A(C)
local U={}for aI,aA in pairs(C)do
U[aA]=aI
end
return U
end
local function t(C,e,b)
local y=n(C,e,b)if y==nil then
return E
end
if d(y)~="table"then
z.warn(string.format("Tuya lookup expects table map, got %s",d(y)))return E
end
return y
end
local function P(k,h,j)
if d(k)~="string"then
return nil
end
local ad=h or 1
local au=j or(B(k)-ad+1)if ad<1 or au<1 or(ad+au-1)>B(k)then
return nil
end
local f=0
for aa=ad,ad+au-1 do
f=(f*256)+L(k,aa)
end
return f
end
local function W(k,M,e,b)
local G=B(k)local r=d(M)=="table"and M or E
local j=i(r.bytes or r.length,e,b)if j==nil then
j=G
end
j=v(j)if j<1 or j>G then
z.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(r.start,e,b)if h==nil then
local aB=i(r.offset,e,b)if aB~=nil then
h=v(aB)+1
end
end
if h==nil then
local az=n(r.from_tail,e,b)if az==true then
h=G-j+1
else
h=1
end
end
h=v(h)if h<1 or(h+j-1)>G then
z.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function V(k)
local aw={}for aa=1,B(k)do
aw[#aw+1]=string.format("%02X",L(k,aa))
end
return J(aw)
end
local function D(C)
local av={}for aI,_ in pairs(C or E)do
local X=c(aI)if X~=nil then
av[#av+1]=v(X)
end
end
table.sort(av)return av
end
local a=aJ.converter
function a.pipe(...)
local ae={...}if #ae==1 and d(ae[1])=="table"then
ae=ae[1]
end
return function(f,e,b)
local af=f
for _,aL in ipairs(ae)do
af=aL(af,e,b)
end
return af
end
end
function a.from_to(F,an)
local aE={}
if d(F)=="function"then
aE.from=F
end
if d(an)=="function"then
aE.to=an
end
return aE
end
function a.from_only(F)
return a.from_to(F,nil)
end
function a.lookup_from_to(C,l)
local o=d(C)=="table"and C or nil
local aj=o and A(o)or nil
return a.from_to(
function(f,e,b)
local q=o or t(C,e,b)local U=aj or A(q)local R=U[f]if R~=nil then
return R
end
local I=s(l,e,b)if I~=nil then
return I
end
z.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(f)))return nil
end,
a.lookup_value(C,l))
end
function a.lookup_value(C,l)
local o=d(C)=="table"and C or nil
return function(f,e,b)
local q=o or t(C,e,b)local R=q[f]if R~=nil then
return R
end
local I=s(l,e,b)if I~=nil then
return I
end
z.warn(string.format("Tuya lookup missing key: %s",tostring(f)))return nil
end
end
function a.raw_uint_be(p,M)
local ai=d(M)=="table"and M or nil
return a.from_only(function(f,e,b)
local k=am(f)if k==nil then
z.warn(string.format("Tuya raw_uint_be expects bytes, got %s",d(f)))return nil
end
local h,j=W(k,ai,e,b)if h==nil then
return nil
end
local aC=P(k,h,j)if aC==nil then
z.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ak=i(p,e,b)if ak==nil then
ak=1
end
if ak==0 then
z.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return aC/ak
end)
end
function a.raw_identifier()
return a.from_only(function(f)
local k=am(f)if k==nil then
return f
end
local G=B(k)local aq={}local al=true
for aa=1,G do
local H=L(k,aa)if H~=0 then
if H<32 or H>126 then
al=false
end
aq[#aq+1]=at(H)
end
end
if al and #aq>0 then
return J(aq)
end
if G<=4 then
return P(k,1,G)
end
return V(k)
end)
end
function a.bitmap_flags(C,ar,aD)
local o=d(C)=="table"and C or nil
local as=o and D(o)or nil
return a.from_only(function(f,e,b)
local O=c(f)if O==nil then
z.warn(string.format("Tuya bitmap_flags expects number, got %s",d(f)))return nil
end
local q=o or t(C,e,b)local ap=as or D(q)local ab={}local ao=v(O)for _,aH in ipairs(ap)do
if v(ao/aH)%2==1 then
local aF=q[aH]or q[tostring(aH)]if aF~=nil then
ab[#ab+1]=aF
end
end
end
if #ab==0 then
return s(ar,e,b)
end
local u=n(aD,e,b)if d(u)~="string"then
u=","
end
return J(ab,u)
end)
end
function a.report_period_hours()
return a.lookup_from_to({
["1h"]=0,["2h"]=1,["3h"]=2,["4h"]=3,["6h"]=4,["8h"]=5,["12h"]=6,["24h"]=7,["48h"]=8,["72h"]=9,})
end
function a.water_meter_faults()
return a.bitmap_flags({
[1]="battery_alarm",[2]="magnetism_alarm",[4]="cover_alarm",[8]="credit_alarm",[16]="switch_gaps_alarm",[32]="meter_body_alarm",[64]="abnormal_water_alarm",[128]="arrearage_alarm",[256]="overflow_alarm",[512]="revflow_alarm",[1024]="over_pre_alarm",[2048]="empty_pipe_alarm",[4096]="transducer_alarm",},"no_alarm",",")
end
function a.divide_by_from_only(p)
return a.from_only(a.divide_by(p))
end
function a.power()
return a.from_only(function(f)
local g=c(f)if g==nil then
z.warn(string.format("Tuya power expects number, got %s",d(f)))return nil
end
if g>268435455 then
return(429496732-g)*-1
end
return g
end)
end
function a.scale(Z,Y,T,S)
return function(f)
local g=c(f)local K=c(Z)local Q=c(Y)local N=c(T)local ac=c(S)if g==nil then
z.warn(string.format("Tuya scale expects number, got %s",d(f)))return nil
end
if K==nil or Q==nil or N==nil or ac==nil then
z.warn("Tuya scale expects numeric ranges")return nil
end
if Q==K then
z.warn("Tuya scale input range cannot be zero")return nil
end
return((g-K)*(ac-N)/(Q-K))+N
end
end
function a.scale_pair(Z,Y,T,S)
return a.from_to(
a.scale(Z,Y,T,S),a.scale(T,S,Z,Y))
end
function a.divide_by(p)
return function(f,e,b)
local g=c(f)local ak=i(p,e,b)if g==nil or ak==nil then
z.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ak==0 then
z.warn("Tuya divide_by divisor cannot be zero")return nil
end
return g/ak
end
end
function a.divide_by_pair(p)
return a.from_to(
a.divide_by(p),a.multiply_by(p))
end
function a.signed_number_pair(aG)
return a.from_to(
function(f,e,ag,b)
local m=nil
if d(ag)=="table"and c(ag.signed_value)~=nil then
m=c(ag.signed_value)else
m=c(f)if m~=nil and m>0x7FFFFFFF then
m=m-4294967296
end
end
if m==nil then
z.warn(string.format("Tuya signed_number_pair expects number, got %s",d(f)))return nil
end
local p=i(aG,e,b)if p==nil then
p=1
end
if p==0 then
z.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return m/p
end,
function(f,e,b)
local g=c(f)if g==nil then
z.warn(string.format("Tuya signed_number_pair expects number, got %s",d(f)))return nil
end
local w=i(aG,e,b)if w==nil then
w=1
end
if w==0 then
z.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return g*w
end
)
end
function a.multiply_by(w)
return function(f,e,b)
local g=c(f)local ay=i(w,e,b)if g==nil or ay==nil then
z.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return g*ay
end
end
function a.threshold_parser()
return function(f)
return aJ.parse_threshold(f)
end
end
end
return ah
