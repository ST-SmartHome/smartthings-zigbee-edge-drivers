local function Y(av,t)
local az=t.utils
local r=t.log
local A=t.math_floor
local g=t.type_check
local c=t.tonumber_check
local aq=t.raw_bytes
local P=t.string_byte
local ax=t.string_char
local B=t.string_len
local ae=t.table_concat
local x={}
local function aw(e)
return e
end
local function p(ak,f,d)
if g(ak)=="function"then
return ak(f,d)
end
return ak
end
local function s(k,f,d)
if g(k)=="function"then
return k(f,d)
end
return k
end
local function i(ak,f,d)
local u=p(ak,f,d)if u==nil then
return nil
end
return c(u)
end
local function v(F)
local M={}for au,an in pairs(F)do
M[an]=au
end
return M
end
local function z(F,f,d)
local u=p(F,f,d)if u==nil then
return x
end
if g(u)~="table"then
r.warn(string.format("Tuya lookup expects table map, got %s",g(u)))return x
end
return u
end
local function ad(n,h,j)
if g(n)~="string"then
return nil
end
local U=h or 1
local af=j or(B(n)-U+1)if U<1 or af<1 or(U+af-1)>B(n)then
return nil
end
local e=0
for ag=U,U+af-1 do
e=(e*256)+P(n,ag)
end
return e
end
local function N(n,G,f,d)
local S=B(n)local m=g(G)=="table"and G or x
local j=i(m.bytes or m.length,f,d)if j==nil then
j=S
end
j=A(j)if j<1 or j>S then
r.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(m.start,f,d)if h==nil then
local ao=i(m.offset,f,d)if ao~=nil then
h=A(ao)+1
end
end
if h==nil then
local am=p(m.from_tail,f,d)if am==true then
h=S-j+1
else
h=1
end
end
h=A(h)if h<1 or(h+j-1)>S then
r.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function ar(n)
local ai={}for ag=1,B(n)do
ai[#ai+1]=string.format("%02X",P(n,ag))
end
return ae(ai)
end
local function aj(F)
local ah={}for au,_ in pairs(F or x)do
local O=c(au)if O~=nil then
ah[#ah+1]=A(O)
end
end
table.sort(ah)return ah
end
local b=av.converter
function b.pipe(...)
local V={...}if #V==1 and g(V[1])=="table"then
V=V[1]
end
return function(e,f,d)
local W=e
for _,ay in ipairs(V)do
W=ay(W,f,d)
end
return W
end
end
function b.from_to(y,ac)
local as={}
if g(y)=="function"then
as.from=y
end
if g(ac)=="function"then
as.to=ac
end
return as
end
function b.from_only(y)
return b.from_to(y,nil)
end
function b.lookup_from_to(F,k)
local w=g(F)=="table"and F or nil
local aa=w and v(w)or nil
return b.from_to(
function(e,f,d)
local D=w or z(F,f,d)local M=aa or v(D)local J=M[e]if J~=nil then
return J
end
local C=s(k,f,d)if C~=nil then
return C
end
r.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(e)))return nil
end,
b.lookup_value(F,k))
end
function b.lookup_value(F,k)
local w=g(F)=="table"and F or nil
return function(e,f,d)
local D=w or z(F,f,d)local J=D[e]if J~=nil then
return J
end
local C=s(k,f,d)if C~=nil then
return C
end
r.warn(string.format("Tuya lookup missing key: %s",tostring(e)))return nil
end
end
function b.raw_uint_be(o,G)
local Z=g(G)=="table"and G or nil
return b.from_only(function(e,f,d)
local n=aq(e)if n==nil then
r.warn(string.format("Tuya raw_uint_be expects bytes, got %s",g(e)))return nil
end
local h,j=N(n,Z,f,d)if h==nil then
return nil
end
local ap=ad(n,h,j)if ap==nil then
r.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ab=i(o,f,d)if ab==nil then
ab=1
end
if ab==0 then
r.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return ap/ab
end)
end
function b.power()
return b.from_only(function(e)
local a=c(e)if a==nil then
r.warn(string.format("Tuya power expects number, got %s",g(e)))return nil
end
if a>268435455 then
return(429496732-a)*-1
end
return a
end)
end
function b.scale(R,Q,L,K)
return function(e)
local a=c(e)local E=c(R)local I=c(Q)local H=c(L)local T=c(K)if a==nil then
r.warn(string.format("Tuya scale expects number, got %s",g(e)))return nil
end
if E==nil or I==nil or H==nil or T==nil then
r.warn("Tuya scale expects numeric ranges")return nil
end
if I==E then
r.warn("Tuya scale input range cannot be zero")return nil
end
return((a-E)*(T-H)/(I-E))+H
end
end
function b.scale_pair(R,Q,L,K)
return b.from_to(
b.scale(R,Q,L,K),b.scale(L,K,R,Q))
end
function b.divide_by(o)
return function(e,f,d)
local a=c(e)local ab=i(o,f,d)if a==nil or ab==nil then
r.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ab==0 then
r.warn("Tuya divide_by divisor cannot be zero")return nil
end
return a/ab
end
end
function b.divide_by_pair(o)
return b.from_to(
b.divide_by(o),b.multiply_by(o))
end
function b.signed_number_pair(at)
return b.from_to(
function(e,f,X,d)
local l=nil
if g(X)=="table"and c(X.signed_value)~=nil then
l=c(X.signed_value)else
l=c(e)if l~=nil and l>0x7FFFFFFF then
l=l-4294967296
end
end
if l==nil then
r.warn(string.format("Tuya signed_number_pair expects number, got %s",g(e)))return nil
end
local o=i(at,f,d)if o==nil then
o=1
end
if o==0 then
r.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return l/o
end,
function(e,f,d)
local a=c(e)if a==nil then
r.warn(string.format("Tuya signed_number_pair expects number, got %s",g(e)))return nil
end
local q=i(at,f,d)if q==nil then
q=1
end
if q==0 then
r.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return a*q
end
)
end
function b.multiply_by(q)
return function(e,f,d)
local a=c(e)local al=i(q,f,d)if a==nil or al==nil then
r.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return a*al
end
end
function b.threshold_parser()
return function(e)
return av.parse_threshold(e)
end
end
function b.cover_position_inverted()
return b.from_to(
function(e)
local a=c(e)if a==nil then
r.warn("Tuya cover_position_inverted expects number")return nil
end
return 100-a
end,
function(e)
local a=c(e)if a==nil then
r.warn("Tuya cover_position_inverted expects number")return nil
end
return 100-a
end
)
end
end
return Y
