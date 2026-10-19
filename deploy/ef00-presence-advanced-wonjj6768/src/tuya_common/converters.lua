local function aa(ay,v)
local aC=v.utils
local t=v.log
local C=v.math_floor
local e=v.type_check
local d=v.tonumber_check
local as=v.raw_bytes
local R=v.string_byte
local aA=v.string_char
local D=v.string_len
local ag=v.table_concat
local z={}
local function az(c)
return c
end
local function m(am,f,b)
if e(am)=="function"then
return am(f,b)
end
return am
end
local function u(k,f,b)
if e(k)=="function"then
return k(f,b)
end
return k
end
local function i(am,f,b)
local w=m(am,f,b)if w==nil then
return nil
end
return d(w)
end
local function x(H)
local O={}for ax,ap in pairs(H)do
O[ap]=ax
end
return O
end
local function B(H,f,b)
local w=m(H,f,b)if w==nil then
return z
end
if e(w)~="table"then
t.warn(string.format("Tuya lookup expects table map, got %s",e(w)))return z
end
return w
end
local function af(p,h,j)
if e(p)~="string"then
return nil
end
local W=h or 1
local ah=j or(D(p)-W+1)if W<1 or ah<1 or(W+ah-1)>D(p)then
return nil
end
local c=0
for ai=W,W+ah-1 do
c=(c*256)+R(p,ai)
end
return c
end
local function P(p,I,f,b)
local U=D(p)local o=e(I)=="table"and I or z
local j=i(o.bytes or o.length,f,b)if j==nil then
j=U
end
j=C(j)if j<1 or j>U then
t.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(o.start,f,b)if h==nil then
local aq=i(o.offset,f,b)if aq~=nil then
h=C(aq)+1
end
end
if h==nil then
local ao=m(o.from_tail,f,b)if ao==true then
h=U-j+1
else
h=1
end
end
h=C(h)if h<1 or(h+j-1)>U then
t.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function at(p)
local ak={}for ai=1,D(p)do
ak[#ak+1]=string.format("%02X",R(p,ai))
end
return ag(ak)
end
local function al(H)
local aj={}for ax,_ in pairs(H or z)do
local Q=d(ax)if Q~=nil then
aj[#aj+1]=C(Q)
end
end
table.sort(aj)return aj
end
local a=ay.converter
function a.pipe(...)
local X={...}if #X==1 and e(X[1])=="table"then
X=X[1]
end
return function(c,f,b)
local Y=c
for _,aB in ipairs(X)do
Y=aB(Y,f,b)
end
return Y
end
end
function a.from_to(A,ae)
local av={}
if e(A)=="function"then
av.from=A
end
if e(ae)=="function"then
av.to=ae
end
return av
end
function a.from_only(A)
return a.from_to(A,nil)
end
function a.to_bool(q,s)
return function(c)
if e(c)=="boolean"then
return c
end
if c==q then
return true
end
if c==s then
return false
end
t.warn(string.format("Tuya to_bool expected %s or %s, got %s",tostring(q),tostring(s),tostring(c)))return nil
end
end
function a.bool_pair(q,s)
return a.from_to(
a.to_bool(q,s),
function(c)
if c==true then
return q
end
if c==false then
return s
end
t.warn(string.format("Tuya bool_pair expected boolean, got %s",e(c)))return nil
end
)
end
function a.lookup_from_to(H,k)
local y=e(H)=="table"and H or nil
local ac=y and x(y)or nil
return a.from_to(
function(c,f,b)
local F=y or B(H,f,b)local O=ac or x(F)local L=O[c]if L~=nil then
return L
end
local E=u(k,f,b)if E~=nil then
return E
end
t.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(c)))return nil
end,
a.lookup_value(H,k))
end
function a.lookup_value(H,k)
local y=e(H)=="table"and H or nil
return function(c,f,b)
local F=y or B(H,f,b)local L=F[c]if L~=nil then
return L
end
local E=u(k,f,b)if E~=nil then
return E
end
t.warn(string.format("Tuya lookup missing key: %s",tostring(c)))return nil
end
end
function a.raw_uint_be(n,I)
local ab=e(I)=="table"and I or nil
return a.from_only(function(c,f,b)
local p=as(c)if p==nil then
t.warn(string.format("Tuya raw_uint_be expects bytes, got %s",e(c)))return nil
end
local h,j=P(p,ab,f,b)if h==nil then
return nil
end
local ar=af(p,h,j)if ar==nil then
t.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ad=i(n,f,b)if ad==nil then
ad=1
end
if ad==0 then
t.warn("Tuya raw_uint_be divisor cannot be zero")return nil
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
function a.true_false(q)
return a.from_only(function(c,f,b)
local au=m(q,f,b)return c==au
end)
end
function a.divide_by_from_only(n)
return a.from_only(a.divide_by(n))
end
function a.power()
return a.from_only(function(c)
local g=d(c)if g==nil then
t.warn(string.format("Tuya power expects number, got %s",e(c)))return nil
end
if g>268435455 then
return(429496732-g)*-1
end
return g
end)
end
function a.scale(T,S,N,M)
return function(c)
local g=d(c)local G=d(T)local K=d(S)local J=d(N)local V=d(M)if g==nil then
t.warn(string.format("Tuya scale expects number, got %s",e(c)))return nil
end
if G==nil or K==nil or J==nil or V==nil then
t.warn("Tuya scale expects numeric ranges")return nil
end
if K==G then
t.warn("Tuya scale input range cannot be zero")return nil
end
return((g-G)*(V-J)/(K-G))+J
end
end
function a.scale_pair(T,S,N,M)
return a.from_to(
a.scale(T,S,N,M),a.scale(N,M,T,S))
end
function a.divide_by(n)
return function(c,f,b)
local g=d(c)local ad=i(n,f,b)if g==nil or ad==nil then
t.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ad==0 then
t.warn("Tuya divide_by divisor cannot be zero")return nil
end
return g/ad
end
end
function a.divide_by_pair(n)
return a.from_to(
a.divide_by(n),a.multiply_by(n))
end
function a.signed_number_pair(aw)
return a.from_to(
function(c,f,Z,b)
local l=nil
if e(Z)=="table"and d(Z.signed_value)~=nil then
l=d(Z.signed_value)else
l=d(c)if l~=nil and l>0x7FFFFFFF then
l=l-4294967296
end
end
if l==nil then
t.warn(string.format("Tuya signed_number_pair expects number, got %s",e(c)))return nil
end
local n=i(aw,f,b)if n==nil then
n=1
end
if n==0 then
t.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return l/n
end,
function(c,f,b)
local g=d(c)if g==nil then
t.warn(string.format("Tuya signed_number_pair expects number, got %s",e(c)))return nil
end
local r=i(aw,f,b)if r==nil then
r=1
end
if r==0 then
t.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return g*r
end
)
end
function a.multiply_by(r)
return function(c,f,b)
local g=d(c)local an=i(r,f,b)if g==nil or an==nil then
t.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return g*an
end
end
function a.threshold_parser()
return function(c)
return ay.parse_threshold(c)
end
end
end
return aa
