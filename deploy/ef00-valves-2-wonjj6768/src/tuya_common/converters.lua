local function Z(av,s)
local az=s.utils
local v=s.log
local A=s.math_floor
local f=s.type_check
local c=s.tonumber_check
local aq=s.raw_bytes
local Q=s.string_byte
local ax=s.string_char
local B=s.string_len
local ae=s.table_concat
local x={}
local function aw(h)
return h
end
local function p(ak,e,b)
if f(ak)=="function"then
return ak(e,b)
end
return ak
end
local function r(k,e,b)
if f(k)=="function"then
return k(e,b)
end
return k
end
local function i(ak,e,b)
local t=p(ak,e,b)if t==nil then
return nil
end
return c(t)
end
local function u(F)
local N={}for au,an in pairs(F)do
N[an]=au
end
return N
end
local function z(F,e,b)
local t=p(F,e,b)if t==nil then
return x
end
if f(t)~="table"then
v.warn(string.format("Tuya lookup expects table map, got %s",f(t)))return x
end
return t
end
local function ad(n,g,j)
if f(n)~="string"then
return nil
end
local V=g or 1
local af=j or(B(n)-V+1)if V<1 or af<1 or(V+af-1)>B(n)then
return nil
end
local h=0
for ag=V,V+af-1 do
h=(h*256)+Q(n,ag)
end
return h
end
local function O(n,H,e,b)
local T=B(n)local m=f(H)=="table"and H or x
local j=i(m.bytes or m.length,e,b)if j==nil then
j=T
end
j=A(j)if j<1 or j>T then
v.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local g=i(m.start,e,b)if g==nil then
local ao=i(m.offset,e,b)if ao~=nil then
g=A(ao)+1
end
end
if g==nil then
local am=p(m.from_tail,e,b)if am==true then
g=T-j+1
else
g=1
end
end
g=A(g)if g<1 or(g+j-1)>T then
v.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return g,j
end
local function ar(n)
local ai={}for ag=1,B(n)do
ai[#ai+1]=string.format("%02X",Q(n,ag))
end
return ae(ai)
end
local function aj(F)
local ah={}for au,_ in pairs(F or x)do
local P=c(au)if P~=nil then
ah[#ah+1]=A(P)
end
end
table.sort(ah)return ah
end
local a=av.converter
function a.pipe(...)
local W={...}if #W==1 and f(W[1])=="table"then
W=W[1]
end
return function(h,e,b)
local X=h
for _,ay in ipairs(W)do
X=ay(X,e,b)
end
return X
end
end
function a.from_to(y,G)
local as={}
if f(y)=="function"then
as.from=y
end
if f(G)=="function"then
as.to=G
end
return as
end
function a.from_only(y)
return a.from_to(y,nil)
end
function a.to_only(G)
return a.from_to(nil,G)
end
function a.lookup_from_to(F,k)
local w=f(F)=="table"and F or nil
local ab=w and u(w)or nil
return a.from_to(
function(h,e,b)
local D=w or z(F,e,b)local N=ab or u(D)local K=N[h]if K~=nil then
return K
end
local C=r(k,e,b)if C~=nil then
return C
end
v.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(h)))return nil
end,
a.lookup_value(F,k))
end
function a.lookup_value(F,k)
local w=f(F)=="table"and F or nil
return function(h,e,b)
local D=w or z(F,e,b)local K=D[h]if K~=nil then
return K
end
local C=r(k,e,b)if C~=nil then
return C
end
v.warn(string.format("Tuya lookup missing key: %s",tostring(h)))return nil
end
end
function a.raw_uint_be(o,H)
local aa=f(H)=="table"and H or nil
return a.from_only(function(h,e,b)
local n=aq(h)if n==nil then
v.warn(string.format("Tuya raw_uint_be expects bytes, got %s",f(h)))return nil
end
local g,j=O(n,aa,e,b)if g==nil then
return nil
end
local ap=ad(n,g,j)if ap==nil then
v.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ac=i(o,e,b)if ac==nil then
ac=1
end
if ac==0 then
v.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return ap/ac
end)
end
function a.power()
return a.from_only(function(h)
local d=c(h)if d==nil then
v.warn(string.format("Tuya power expects number, got %s",f(h)))return nil
end
if d>268435455 then
return(429496732-d)*-1
end
return d
end)
end
function a.scale(S,R,M,L)
return function(h)
local d=c(h)local E=c(S)local J=c(R)local I=c(M)local U=c(L)if d==nil then
v.warn(string.format("Tuya scale expects number, got %s",f(h)))return nil
end
if E==nil or J==nil or I==nil or U==nil then
v.warn("Tuya scale expects numeric ranges")return nil
end
if J==E then
v.warn("Tuya scale input range cannot be zero")return nil
end
return((d-E)*(U-I)/(J-E))+I
end
end
function a.scale_pair(S,R,M,L)
return a.from_to(
a.scale(S,R,M,L),a.scale(M,L,S,R))
end
function a.divide_by(o)
return function(h,e,b)
local d=c(h)local ac=i(o,e,b)if d==nil or ac==nil then
v.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ac==0 then
v.warn("Tuya divide_by divisor cannot be zero")return nil
end
return d/ac
end
end
function a.divide_by_pair(o)
return a.from_to(
a.divide_by(o),a.multiply_by(o))
end
function a.signed_number_pair(at)
return a.from_to(
function(h,e,Y,b)
local l=nil
if f(Y)=="table"and c(Y.signed_value)~=nil then
l=c(Y.signed_value)else
l=c(h)if l~=nil and l>0x7FFFFFFF then
l=l-4294967296
end
end
if l==nil then
v.warn(string.format("Tuya signed_number_pair expects number, got %s",f(h)))return nil
end
local o=i(at,e,b)if o==nil then
o=1
end
if o==0 then
v.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return l/o
end,
function(h,e,b)
local d=c(h)if d==nil then
v.warn(string.format("Tuya signed_number_pair expects number, got %s",f(h)))return nil
end
local q=i(at,e,b)if q==nil then
q=1
end
if q==0 then
v.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return d*q
end
)
end
function a.multiply_by(q)
return function(h,e,b)
local d=c(h)local al=i(q,e,b)if d==nil or al==nil then
v.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return d*al
end
end
function a.threshold_parser()
return function(h)
return av.parse_threshold(h)
end
end
end
return Z
