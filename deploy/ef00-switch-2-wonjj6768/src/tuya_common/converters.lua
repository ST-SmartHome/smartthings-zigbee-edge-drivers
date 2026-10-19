local function aa(ay,u)
local aC=u.utils
local r=u.log
local C=u.math_floor
local c=u.type_check
local e=u.tonumber_check
local at=u.raw_bytes
local R=u.string_byte
local aA=u.string_char
local D=u.string_len
local ah=u.table_concat
local z={}
local function az(b)
return b
end
local function p(an,g,d)
if c(an)=="function"then
return an(g,d)
end
return an
end
local function t(k,g,d)
if c(k)=="function"then
return k(g,d)
end
return k
end
local function i(an,g,d)
local v=p(an,g,d)if v==nil then
return nil
end
return e(v)
end
local function w(H)
local O={}for ax,aq in pairs(H)do
O[aq]=ax
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
local ai=j or(D(o)-W+1)if W<1 or ai<1 or(W+ai-1)>D(o)then
return nil
end
local b=0
for aj=W,W+ai-1 do
b=(b*256)+R(o,aj)
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
local ar=i(n.offset,g,d)if ar~=nil then
h=C(ar)+1
end
end
if h==nil then
local ap=p(n.from_tail,g,d)if ap==true then
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
local function au(o)
local al={}for aj=1,D(o)do
al[#al+1]=string.format("%02X",R(o,aj))
end
return ah(al)
end
local function am(H)
local ak={}for ax,_ in pairs(H or z)do
local Q=e(ax)if Q~=nil then
ak[#ak+1]=C(Q)
end
end
table.sort(ak)return ak
end
local a=ay.converter
function a.pipe(...)
local X={...}if #X==1 and c(X[1])=="table"then
X=X[1]
end
return function(b,g,d)
local Y=b
for _,aB in ipairs(X)do
Y=aB(Y,g,d)
end
return Y
end
end
function a.from_to(A,ae)
local av={}
if c(A)=="function"then
av.from=A
end
if c(ae)=="function"then
av.to=ae
end
return av
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
function a.constant(ag)
return function()
return ag
end
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
local o=at(b)if o==nil then
r.warn(string.format("Tuya raw_uint_be expects bytes, got %s",c(b)))return nil
end
local h,j=P(o,ab,g,d)if h==nil then
return nil
end
local as=af(o,h,j)if as==nil then
r.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ad=i(m,g,d)if ad==nil then
ad=1
end
if ad==0 then
r.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return as/ad
end)
end
function a.true_false0()
return a.bool_pair(0,1)
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
function a.signed_number_pair(aw)
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
local m=i(aw,g,d)if m==nil then
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
local q=i(aw,g,d)if q==nil then
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
local f=e(b)local ao=i(q,g,d)if f==nil or ao==nil then
r.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return f*ao
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
return ay.parse_threshold(b)
end
end
end
return aa
