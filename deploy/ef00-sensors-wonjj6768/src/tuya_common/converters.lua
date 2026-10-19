local function ai(aL,y)
local aO=y.utils
local A=y.log
local t=y.math_floor
local e=y.type_check
local d=y.tonumber_check
local an=y.raw_bytes
local M=y.string_byte
local av=y.string_char
local C=y.string_len
local K=y.table_concat
local F={}
local function aM(c)
return c
end
local function o(az,f,b)
if e(az)=="function"then
return az(f,b)
end
return az
end
local function s(l,f,b)
if e(l)=="function"then
return l(f,b)
end
return l
end
local function i(az,f,b)
local z=o(az,f,b)if z==nil then
return nil
end
return d(z)
end
local function B(D)
local V={}for aK,aC in pairs(D)do
V[aC]=aK
end
return V
end
local function u(D,f,b)
local z=o(D,f,b)if z==nil then
return F
end
if e(z)~="table"then
A.warn(string.format("Tuya lookup expects table map, got %s",e(z)))return F
end
return z
end
local function Q(k,h,j)
if e(k)~="string"then
return nil
end
local ae=h or 1
local aw=j or(C(k)-ae+1)if ae<1 or aw<1 or(ae+aw-1)>C(k)then
return nil
end
local c=0
for ab=ae,ae+aw-1 do
c=(c*256)+M(k,ab)
end
return c
end
local function X(k,N,f,b)
local H=C(k)local r=e(N)=="table"and N or F
local j=i(r.bytes or r.length,f,b)if j==nil then
j=H
end
j=t(j)if j<1 or j>H then
A.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(r.start,f,b)if h==nil then
local aD=i(r.offset,f,b)if aD~=nil then
h=t(aD)+1
end
end
if h==nil then
local aB=o(r.from_tail,f,b)if aB==true then
h=H-j+1
else
h=1
end
end
h=t(h)if h<1 or(h+j-1)>H then
A.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function W(k)
local ay={}for ab=1,C(k)do
ay[#ay+1]=string.format("%02X",M(k,ab))
end
return K(ay)
end
local function E(D)
local ax={}for aK,_ in pairs(D or F)do
local Y=d(aK)if Y~=nil then
ax[#ax+1]=t(Y)
end
end
table.sort(ax)return ax
end
local a=aL.converter
function a.pipe(...)
local af={...}if #af==1 and e(af[1])=="table"then
af=af[1]
end
return function(c,f,b)
local ag=c
for _,aN in ipairs(af)do
ag=aN(ag,f,b)
end
return ag
end
end
function a.from_to(G,ao)
local aG={}
if e(G)=="function"then
aG.from=G
end
if e(ao)=="function"then
aG.to=ao
end
return aG
end
function a.from_only(G)
return a.from_to(G,nil)
end
function a.lookup_from_to(D,l)
local p=e(D)=="table"and D or nil
local ak=p and B(p)or nil
return a.from_to(
function(c,f,b)
local q=p or u(D,f,b)local V=ak or B(q)local S=V[c]if S~=nil then
return S
end
local J=s(l,f,b)if J~=nil then
return J
end
A.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(c)))return nil
end,
a.lookup_value(D,l))
end
function a.lookup_value(D,l)
local p=e(D)=="table"and D or nil
return function(c,f,b)
local q=p or u(D,f,b)local S=q[c]if S~=nil then
return S
end
local J=s(l,f,b)if J~=nil then
return J
end
A.warn(string.format("Tuya lookup missing key: %s",tostring(c)))return nil
end
end
function a.raw_uint_be(n,N)
local aj=e(N)=="table"and N or nil
return a.from_only(function(c,f,b)
local k=an(c)if k==nil then
A.warn(string.format("Tuya raw_uint_be expects bytes, got %s",e(c)))return nil
end
local h,j=X(k,aj,f,b)if h==nil then
return nil
end
local aE=Q(k,h,j)if aE==nil then
A.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local al=i(n,f,b)if al==nil then
al=1
end
if al==0 then
A.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return aE/al
end)
end
function a.raw_identifier()
return a.from_only(function(c)
local k=an(c)if k==nil then
return c
end
local H=C(k)local ar={}local am=true
for ab=1,H do
local I=M(k,ab)if I~=0 then
if I<32 or I>126 then
am=false
end
ar[#ar+1]=av(I)
end
end
if am and #ar>0 then
return K(ar)
end
if H<=4 then
return Q(k,1,H)
end
return W(k)
end)
end
function a.bitmap_flags(D,at,aF)
local p=e(D)=="table"and D or nil
local au=p and E(p)or nil
return a.from_only(function(c,f,b)
local P=d(c)if P==nil then
A.warn(string.format("Tuya bitmap_flags expects number, got %s",e(c)))return nil
end
local q=p or u(D,f,b)local aq=au or E(q)local ac={}local ap=t(P)for _,aJ in ipairs(aq)do
if t(ap/aJ)%2==1 then
local aH=q[aJ]or q[tostring(aJ)]if aH~=nil then
ac[#ac+1]=aH
end
end
end
if #ac==0 then
return s(at,f,b)
end
local w=o(aF,f,b)if e(w)~="string"then
w=","
end
return K(ac,w)
end)
end
function a.alarm_state_lower_upper_cancel()
return a.lookup_from_to({
lower_alarm=0,upper_alarm=1,cancel=2,})
end
function a.temperature_unit()
return a.lookup_from_to({
celsius=0,fahrenheit=1,})
end
function a.report_period_hours()
return a.lookup_from_to({
["1h"]=0,["2h"]=1,["3h"]=2,["4h"]=3,["6h"]=4,["8h"]=5,["12h"]=6,["24h"]=7,["48h"]=8,["72h"]=9,})
end
function a.water_meter_faults()
return a.bitmap_flags({
[1]="battery_alarm",[2]="magnetism_alarm",[4]="cover_alarm",[8]="credit_alarm",[16]="switch_gaps_alarm",[32]="meter_body_alarm",[64]="abnormal_water_alarm",[128]="arrearage_alarm",[256]="overflow_alarm",[512]="revflow_alarm",[1024]="over_pre_alarm",[2048]="empty_pipe_alarm",[4096]="transducer_alarm",},"no_alarm",",")
end
function a.water_warning()
return a.lookup_from_to({
none=0,alarm=1,})
end
function a.soil_fertility_warning()
return a.lookup_from_to({
none=0,alarm=1,})
end
function a.power()
return a.from_only(function(c)
local g=d(c)if g==nil then
A.warn(string.format("Tuya power expects number, got %s",e(c)))return nil
end
if g>268435455 then
return(429496732-g)*-1
end
return g
end)
end
function a.scale(aa,Z,U,T)
return function(c)
local g=d(c)local L=d(aa)local R=d(Z)local O=d(U)local ad=d(T)if g==nil then
A.warn(string.format("Tuya scale expects number, got %s",e(c)))return nil
end
if L==nil or R==nil or O==nil or ad==nil then
A.warn("Tuya scale expects numeric ranges")return nil
end
if R==L then
A.warn("Tuya scale input range cannot be zero")return nil
end
return((g-L)*(ad-O)/(R-L))+O
end
end
function a.scale_pair(aa,Z,U,T)
return a.from_to(
a.scale(aa,Z,U,T),a.scale(U,T,aa,Z))
end
function a.divide_by(n)
return function(c,f,b)
local g=d(c)local al=i(n,f,b)if g==nil or al==nil then
A.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if al==0 then
A.warn("Tuya divide_by divisor cannot be zero")return nil
end
return g/al
end
end
function a.divide_by_pair(n)
return a.from_to(
a.divide_by(n),a.multiply_by(n))
end
function a.signed_number_pair(as)
return a.from_to(
function(c,f,ah,b)
local m=nil
if e(ah)=="table"and d(ah.signed_value)~=nil then
m=d(ah.signed_value)else
m=d(c)if m~=nil and m>0x7FFFFFFF then
m=m-4294967296
end
end
if m==nil then
A.warn(string.format("Tuya signed_number_pair expects number, got %s",e(c)))return nil
end
local n=i(as,f,b)if n==nil then
n=1
end
if n==0 then
A.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return m/n
end,
function(c,f,b)
local g=d(c)if g==nil then
A.warn(string.format("Tuya signed_number_pair expects number, got %s",e(c)))return nil
end
local x=i(as,f,b)if x==nil then
x=1
end
if x==0 then
A.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return g*x
end
)
end
function a.multiply_by(x)
return function(c,f,b)
local g=d(c)local aA=i(x,f,b)if g==nil or aA==nil then
A.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return g*aA
end
end
function a.threshold_parser()
return function(c)
return aL.parse_threshold(c)
end
end
function a.tuya_unsigned_temp(as)
local n=as or 10
return a.from_to(
function(c)
if c==nil then return nil end
local v=c
if v>8192 then
v=v-65535
end
return v/n
end,
function(c)
if c==nil then return nil end
local aI=t(c*n+0.5)if aI<0 then
aI=aI+65535
end
return aI
end
)
end
end
return ai
