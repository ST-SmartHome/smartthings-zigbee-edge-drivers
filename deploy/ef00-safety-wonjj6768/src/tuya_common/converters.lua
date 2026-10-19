local function aa(ax,u)
local aB=u.utils
local r=u.log
local C=u.math_floor
local c=u.type_check
local e=u.tonumber_check
local as=u.raw_bytes
local R=u.string_byte
local az=u.string_char
local D=u.string_len
local ag=u.table_concat
local z={}
local function ay(b)
return b
end
local function p(am,g,d)
if c(am)=="function"then
return am(g,d)
end
return am
end
local function t(k,g,d)
if c(k)=="function"then
return k(g,d)
end
return k
end
local function i(am,g,d)
local v=p(am,g,d)if v==nil then
return nil
end
return e(v)
end
local function w(H)
local O={}for aw,ap in pairs(H)do
O[ap]=aw
end
return O
end
local function B(H,g,d)
local v=p(H,g,d)if v==nil then
return z
end
if c(v)~="table"then
r.warn(string.format("Tuya lookup expects table map, got %s",c(v)))return z
end
return v
end
local function af(o,h,j)
if c(o)~="string"then
return nil
end
local W=h or 1
local ah=j or(D(o)-W+1)if W<1 or ah<1 or(W+ah-1)>D(o)then
return nil
end
local b=0
for ai=W,W+ah-1 do
b=(b*256)+R(o,ai)
end
return b
end
local function P(o,I,g,d)
local U=D(o)local n=c(I)=="table"and I or z
local j=i(n.bytes or n.length,g,d)if j==nil then
j=U
end
j=C(j)if j<1 or j>U then
r.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(n.start,g,d)if h==nil then
local aq=i(n.offset,g,d)if aq~=nil then
h=C(aq)+1
end
end
if h==nil then
local ao=p(n.from_tail,g,d)if ao==true then
h=U-j+1
else
h=1
end
end
h=C(h)if h<1 or(h+j-1)>U then
r.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function at(o)
local ak={}for ai=1,D(o)do
ak[#ak+1]=string.format("%02X",R(o,ai))
end
return ag(ak)
end
local function al(H)
local aj={}for aw,_ in pairs(H or z)do
local Q=e(aw)if Q~=nil then
aj[#aj+1]=C(Q)
end
end
table.sort(aj)return aj
end
local a=ax.converter
function a.pipe(...)
local X={...}if #X==1 and c(X[1])=="table"then
X=X[1]
end
return function(b,g,d)
local Y=b
for _,aA in ipairs(X)do
Y=aA(Y,g,d)
end
return Y
end
end
function a.from_to(A,ae)
local au={}
if c(A)=="function"then
au.from=A
end
if c(ae)=="function"then
au.to=ae
end
return au
end
function a.from_only(A)
return a.from_to(A,nil)
end
function a.to_bool(y,s)
return function(b)
if c(b)=="boolean"then
return b
end
if b==y then
return true
end
if b==s then
return false
end
r.warn(string.format("Tuya to_bool expected %s or %s, got %s",tostring(y),tostring(s),tostring(b)))return nil
end
end
function a.bool_pair(y,s)
return a.from_to(
a.to_bool(y,s),
function(b)
if b==true then
return y
end
if b==false then
return s
end
r.warn(string.format("Tuya bool_pair expected boolean, got %s",c(b)))return nil
end
)
end
function a.invert_bool_pair()
return a.from_to(
a.invert_bool(),a.invert_bool())
end
function a.lookup_from_to(H,k)
local x=c(H)=="table"and H or nil
local ac=x and w(x)or nil
return a.from_to(
function(b,g,d)
local F=x or B(H,g,d)local O=ac or w(F)local L=O[b]if L~=nil then
return L
end
local E=t(k,g,d)if E~=nil then
return E
end
r.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(b)))return nil
end,
a.lookup_value(H,k))
end
function a.lookup_value(H,k)
local x=c(H)=="table"and H or nil
return function(b,g,d)
local F=x or B(H,g,d)local L=F[b]if L~=nil then
return L
end
local E=t(k,g,d)if E~=nil then
return E
end
r.warn(string.format("Tuya lookup missing key: %s",tostring(b)))return nil
end
end
function a.raw_uint_be(m,I)
local ab=c(I)=="table"and I or nil
return a.from_only(function(b,g,d)
local o=as(b)if o==nil then
r.warn(string.format("Tuya raw_uint_be expects bytes, got %s",c(b)))return nil
end
local h,j=P(o,ab,g,d)if h==nil then
return nil
end
local ar=af(o,h,j)if ar==nil then
r.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ad=i(m,g,d)if ad==nil then
ad=1
end
if ad==0 then
r.warn("Tuya raw_uint_be divisor cannot be zero")return nil
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
function a.alarm_ringtone_melody_five()
return a.lookup_from_to({
melody_1=0,melody_2=1,melody_3=2,melody_4=3,melody_5=4,})
end
function a.divide_by_from_only(m)
return a.from_only(a.divide_by(m))
end
function a.power()
return a.from_only(function(b)
local f=e(b)if f==nil then
r.warn(string.format("Tuya power expects number, got %s",c(b)))return nil
end
if f>268435455 then
return(429496732-f)*-1
end
return f
end)
end
function a.scale(T,S,N,M)
return function(b)
local f=e(b)local G=e(T)local K=e(S)local J=e(N)local V=e(M)if f==nil then
r.warn(string.format("Tuya scale expects number, got %s",c(b)))return nil
end
if G==nil or K==nil or J==nil or V==nil then
r.warn("Tuya scale expects numeric ranges")return nil
end
if K==G then
r.warn("Tuya scale input range cannot be zero")return nil
end
return((f-G)*(V-J)/(K-G))+J
end
end
function a.scale_pair(T,S,N,M)
return a.from_to(
a.scale(T,S,N,M),a.scale(N,M,T,S))
end
function a.divide_by(m)
return function(b,g,d)
local f=e(b)local ad=i(m,g,d)if f==nil or ad==nil then
r.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ad==0 then
r.warn("Tuya divide_by divisor cannot be zero")return nil
end
return f/ad
end
end
function a.divide_by_pair(m)
return a.from_to(
a.divide_by(m),a.multiply_by(m))
end
function a.signed_number_pair(av)
return a.from_to(
function(b,g,Z,d)
local l=nil
if c(Z)=="table"and e(Z.signed_value)~=nil then
l=e(Z.signed_value)else
l=e(b)if l~=nil and l>0x7FFFFFFF then
l=l-4294967296
end
end
if l==nil then
r.warn(string.format("Tuya signed_number_pair expects number, got %s",c(b)))return nil
end
local m=i(av,g,d)if m==nil then
m=1
end
if m==0 then
r.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return l/m
end,
function(b,g,d)
local f=e(b)if f==nil then
r.warn(string.format("Tuya signed_number_pair expects number, got %s",c(b)))return nil
end
local q=i(av,g,d)if q==nil then
q=1
end
if q==0 then
r.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return f*q
end
)
end
function a.multiply_by(q)
return function(b,g,d)
local f=e(b)local an=i(q,g,d)if f==nil or an==nil then
r.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return f*an
end
end
function a.invert_bool()
return function(b)
if c(b)=="boolean"then
return not b
end
r.warn(string.format("Tuya invert_bool expects boolean, got %s",c(b)))return nil
end
end
function a.threshold_parser()
return function(b)
return ax.parse_threshold(b)
end
end
end
return aa
