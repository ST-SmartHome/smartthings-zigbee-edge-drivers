local function aa(ax,u)
local aB=u.utils
local s=u.log
local C=u.math_floor
local e=u.type_check
local d=u.tonumber_check
local as=u.raw_bytes
local R=u.string_byte
local az=u.string_char
local D=u.string_len
local ag=u.table_concat
local z={}
local function ay(b)
return b
end
local function p(am,g,c)
if e(am)=="function"then
return am(g,c)
end
return am
end
local function t(k,g,c)
if e(k)=="function"then
return k(g,c)
end
return k
end
local function i(am,g,c)
local v=p(am,g,c)if v==nil then
return nil
end
return d(v)
end
local function w(H)
local O={}for aw,ap in pairs(H)do
O[ap]=aw
end
return O
end
local function B(H,g,c)
local v=p(H,g,c)if v==nil then
return z
end
if e(v)~="table"then
s.warn(string.format("Tuya lookup expects table map, got %s",e(v)))return z
end
return v
end
local function af(n,h,j)
if e(n)~="string"then
return nil
end
local W=h or 1
local ah=j or(D(n)-W+1)if W<1 or ah<1 or(W+ah-1)>D(n)then
return nil
end
local b=0
for ai=W,W+ah-1 do
b=(b*256)+R(n,ai)
end
return b
end
local function P(n,I,g,c)
local U=D(n)local m=e(I)=="table"and I or z
local j=i(m.bytes or m.length,g,c)if j==nil then
j=U
end
j=C(j)if j<1 or j>U then
s.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(m.start,g,c)if h==nil then
local aq=i(m.offset,g,c)if aq~=nil then
h=C(aq)+1
end
end
if h==nil then
local ao=p(m.from_tail,g,c)if ao==true then
h=U-j+1
else
h=1
end
end
h=C(h)if h<1 or(h+j-1)>U then
s.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function at(n)
local ak={}for ai=1,D(n)do
ak[#ak+1]=string.format("%02X",R(n,ai))
end
return ag(ak)
end
local function al(H)
local aj={}for aw,_ in pairs(H or z)do
local Q=d(aw)if Q~=nil then
aj[#aj+1]=C(Q)
end
end
table.sort(aj)return aj
end
local a=ax.converter
function a.pipe(...)
local X={...}if #X==1 and e(X[1])=="table"then
X=X[1]
end
return function(b,g,c)
local Y=b
for _,aA in ipairs(X)do
Y=aA(Y,g,c)
end
return Y
end
end
function a.from_to(A,ae)
local au={}
if e(A)=="function"then
au.from=A
end
if e(ae)=="function"then
au.to=ae
end
return au
end
function a.from_only(A)
return a.from_to(A,nil)
end
function a.to_bool(y,r)
return function(b)
if e(b)=="boolean"then
return b
end
if b==y then
return true
end
if b==r then
return false
end
s.warn(string.format("Tuya to_bool expected %s or %s, got %s",tostring(y),tostring(r),tostring(b)))return nil
end
end
function a.bool_pair(y,r)
return a.from_to(
a.to_bool(y,r),
function(b)
if b==true then
return y
end
if b==false then
return r
end
s.warn(string.format("Tuya bool_pair expected boolean, got %s",e(b)))return nil
end
)
end
function a.lookup_from_to(H,k)
local x=e(H)=="table"and H or nil
local ac=x and w(x)or nil
return a.from_to(
function(b,g,c)
local F=x or B(H,g,c)local O=ac or w(F)local L=O[b]if L~=nil then
return L
end
local E=t(k,g,c)if E~=nil then
return E
end
s.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(b)))return nil
end,
a.lookup_value(H,k))
end
function a.lookup_value(H,k)
local x=e(H)=="table"and H or nil
return function(b,g,c)
local F=x or B(H,g,c)local L=F[b]if L~=nil then
return L
end
local E=t(k,g,c)if E~=nil then
return E
end
s.warn(string.format("Tuya lookup missing key: %s",tostring(b)))return nil
end
end
function a.raw_uint_be(o,I)
local ab=e(I)=="table"and I or nil
return a.from_only(function(b,g,c)
local n=as(b)if n==nil then
s.warn(string.format("Tuya raw_uint_be expects bytes, got %s",e(b)))return nil
end
local h,j=P(n,ab,g,c)if h==nil then
return nil
end
local ar=af(n,h,j)if ar==nil then
s.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ad=i(o,g,c)if ad==nil then
ad=1
end
if ad==0 then
s.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return ar/ad
end)
end
function a.true_false0()
return a.bool_pair(0,1)
end
function a.true_false1()
return a.bool_pair(1,0)
end
function a.temperature_unit()
return a.lookup_from_to({
celsius=0,fahrenheit=1,})
end
function a.motion_state()
return a.lookup_from_to({
none=0,large=1,small=2,static=3,})
end
function a.motion_detection_mode()
return a.lookup_from_to({
pir_and_radar=0,pir_or_radar=1,only_radar=2,})
end
function a.power()
return a.from_only(function(b)
local f=d(b)if f==nil then
s.warn(string.format("Tuya power expects number, got %s",e(b)))return nil
end
if f>268435455 then
return(429496732-f)*-1
end
return f
end)
end
function a.scale(T,S,N,M)
return function(b)
local f=d(b)local G=d(T)local K=d(S)local J=d(N)local V=d(M)if f==nil then
s.warn(string.format("Tuya scale expects number, got %s",e(b)))return nil
end
if G==nil or K==nil or J==nil or V==nil then
s.warn("Tuya scale expects numeric ranges")return nil
end
if K==G then
s.warn("Tuya scale input range cannot be zero")return nil
end
return((f-G)*(V-J)/(K-G))+J
end
end
function a.scale_pair(T,S,N,M)
return a.from_to(
a.scale(T,S,N,M),a.scale(N,M,T,S))
end
function a.divide_by(o)
return function(b,g,c)
local f=d(b)local ad=i(o,g,c)if f==nil or ad==nil then
s.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ad==0 then
s.warn("Tuya divide_by divisor cannot be zero")return nil
end
return f/ad
end
end
function a.divide_by_pair(o)
return a.from_to(
a.divide_by(o),a.multiply_by(o))
end
function a.signed_number_pair(av)
return a.from_to(
function(b,g,Z,c)
local l=nil
if e(Z)=="table"and d(Z.signed_value)~=nil then
l=d(Z.signed_value)else
l=d(b)if l~=nil and l>0x7FFFFFFF then
l=l-4294967296
end
end
if l==nil then
s.warn(string.format("Tuya signed_number_pair expects number, got %s",e(b)))return nil
end
local o=i(av,g,c)if o==nil then
o=1
end
if o==0 then
s.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return l/o
end,
function(b,g,c)
local f=d(b)if f==nil then
s.warn(string.format("Tuya signed_number_pair expects number, got %s",e(b)))return nil
end
local q=i(av,g,c)if q==nil then
q=1
end
if q==0 then
s.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return f*q
end
)
end
function a.multiply_by(q)
return function(b,g,c)
local f=d(b)local an=i(q,g,c)if f==nil or an==nil then
s.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return f*an
end
end
function a.threshold_parser()
return function(b)
return ax.parse_threshold(b)
end
end
end
return aa
