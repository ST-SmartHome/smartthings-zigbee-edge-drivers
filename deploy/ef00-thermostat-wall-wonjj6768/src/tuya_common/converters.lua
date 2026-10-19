local function Y(av,s)
local az=s.utils
local v=s.log
local A=s.math_floor
local f=s.type_check
local c=s.tonumber_check
local aq=s.raw_bytes
local P=s.string_byte
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
local M={}for au,an in pairs(F)do
M[an]=au
end
return M
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
local U=g or 1
local af=j or(B(n)-U+1)if U<1 or af<1 or(U+af-1)>B(n)then
return nil
end
local h=0
for ag=U,U+af-1 do
h=(h*256)+P(n,ag)
end
return h
end
local function N(n,G,e,b)
local S=B(n)local m=f(G)=="table"and G or x
local j=i(m.bytes or m.length,e,b)if j==nil then
j=S
end
j=A(j)if j<1 or j>S then
v.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local g=i(m.start,e,b)if g==nil then
local ao=i(m.offset,e,b)if ao~=nil then
g=A(ao)+1
end
end
if g==nil then
local am=p(m.from_tail,e,b)if am==true then
g=S-j+1
else
g=1
end
end
g=A(g)if g<1 or(g+j-1)>S then
v.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return g,j
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
local a=av.converter
function a.pipe(...)
local V={...}if #V==1 and f(V[1])=="table"then
V=V[1]
end
return function(h,e,b)
local W=h
for _,ay in ipairs(V)do
W=ay(W,e,b)
end
return W
end
end
function a.from_to(y,ac)
local as={}
if f(y)=="function"then
as.from=y
end
if f(ac)=="function"then
as.to=ac
end
return as
end
function a.from_only(y)
return a.from_to(y,nil)
end
function a.lookup_from_to(F,k)
local w=f(F)=="table"and F or nil
local aa=w and u(w)or nil
return a.from_to(
function(h,e,b)
local D=w or z(F,e,b)local M=aa or u(D)local J=M[h]if J~=nil then
return J
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
local D=w or z(F,e,b)local J=D[h]if J~=nil then
return J
end
local C=r(k,e,b)if C~=nil then
return C
end
v.warn(string.format("Tuya lookup missing key: %s",tostring(h)))return nil
end
end
function a.raw_uint_be(o,G)
local Z=f(G)=="table"and G or nil
return a.from_only(function(h,e,b)
local n=aq(h)if n==nil then
v.warn(string.format("Tuya raw_uint_be expects bytes, got %s",f(h)))return nil
end
local g,j=N(n,Z,e,b)if g==nil then
return nil
end
local ap=ad(n,g,j)if ap==nil then
v.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ab=i(o,e,b)if ab==nil then
ab=1
end
if ab==0 then
v.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return ap/ab
end)
end
function a.temperature_sensor_select_internal_external_both()
return a.lookup_from_to({
internal=0,external=1,both=2,})
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
function a.scale(R,Q,L,K)
return function(h)
local d=c(h)local E=c(R)local I=c(Q)local H=c(L)local T=c(K)if d==nil then
v.warn(string.format("Tuya scale expects number, got %s",f(h)))return nil
end
if E==nil or I==nil or H==nil or T==nil then
v.warn("Tuya scale expects numeric ranges")return nil
end
if I==E then
v.warn("Tuya scale input range cannot be zero")return nil
end
return((d-E)*(T-H)/(I-E))+H
end
end
function a.scale_pair(R,Q,L,K)
return a.from_to(
a.scale(R,Q,L,K),a.scale(L,K,R,Q))
end
function a.divide_by(o)
return function(h,e,b)
local d=c(h)local ab=i(o,e,b)if d==nil or ab==nil then
v.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ab==0 then
v.warn("Tuya divide_by divisor cannot be zero")return nil
end
return d/ab
end
end
function a.divide_by_pair(o)
return a.from_to(
a.divide_by(o),a.multiply_by(o))
end
function a.signed_number_pair(at)
return a.from_to(
function(h,e,X,b)
local l=nil
if f(X)=="table"and c(X.signed_value)~=nil then
l=c(X.signed_value)else
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
return Y
