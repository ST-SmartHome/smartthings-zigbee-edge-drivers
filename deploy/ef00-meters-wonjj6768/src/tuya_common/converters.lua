local function Y(al,s)
local aB=s.utils
local v=s.log
local A=s.math_floor
local g=s.type_check
local c=s.tonumber_check
local at=s.raw_bytes
local P=s.string_byte
local az=s.string_char
local B=s.string_len
local af=s.table_concat
local x={}
local function ay(e)
return e
end
local function p(an,f,b)
if g(an)=="function"then
return an(f,b)
end
return an
end
local function r(k,f,b)
if g(k)=="function"then
return k(f,b)
end
return k
end
local function i(an,f,b)
local t=p(an,f,b)if t==nil then
return nil
end
return c(t)
end
local function u(F)
local M={}for ax,aq in pairs(F)do
M[aq]=ax
end
return M
end
local function z(F,f,b)
local t=p(F,f,b)if t==nil then
return x
end
if g(t)~="table"then
v.warn(string.format("Tuya lookup expects table map, got %s",g(t)))return x
end
return t
end
local function ad(n,h,j)
if g(n)~="string"then
return nil
end
local U=h or 1
local ag=j or(B(n)-U+1)if U<1 or ag<1 or(U+ag-1)>B(n)then
return nil
end
local e=0
for ah=U,U+ag-1 do
e=(e*256)+P(n,ah)
end
return e
end
local function N(n,G,f,b)
local S=B(n)local m=g(G)=="table"and G or x
local j=i(m.bytes or m.length,f,b)if j==nil then
j=S
end
j=A(j)if j<1 or j>S then
v.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(m.start,f,b)if h==nil then
local ar=i(m.offset,f,b)if ar~=nil then
h=A(ar)+1
end
end
if h==nil then
local ap=p(m.from_tail,f,b)if ap==true then
h=S-j+1
else
h=1
end
end
h=A(h)if h<1 or(h+j-1)>S then
v.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function au(n)
local aj={}for ah=1,B(n)do
aj[#aj+1]=string.format("%02X",P(n,ah))
end
return af(aj)
end
local function am(F)
local ai={}for ax,_ in pairs(F or x)do
local O=c(ax)if O~=nil then
ai[#ai+1]=A(O)
end
end
table.sort(ai)return ai
end
local a=al.converter
function a.pipe(...)
local V={...}if #V==1 and g(V[1])=="table"then
V=V[1]
end
return function(e,f,b)
local W=e
for _,aA in ipairs(V)do
W=aA(W,f,b)
end
return W
end
end
function a.from_to(y,ac)
local av={}
if g(y)=="function"then
av.from=y
end
if g(ac)=="function"then
av.to=ac
end
return av
end
function a.from_only(y)
return a.from_to(y,nil)
end
function a.lookup_from_to(F,k)
local w=g(F)=="table"and F or nil
local aa=w and u(w)or nil
return a.from_to(
function(e,f,b)
local D=w or z(F,f,b)local M=aa or u(D)local J=M[e]if J~=nil then
return J
end
local C=r(k,f,b)if C~=nil then
return C
end
v.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(e)))return nil
end,
a.lookup_value(F,k))
end
function a.lookup_value(F,k)
local w=g(F)=="table"and F or nil
return function(e,f,b)
local D=w or z(F,f,b)local J=D[e]if J~=nil then
return J
end
local C=r(k,f,b)if C~=nil then
return C
end
v.warn(string.format("Tuya lookup missing key: %s",tostring(e)))return nil
end
end
function a.raw_uint_be(o,G)
local Z=g(G)=="table"and G or nil
return a.from_only(function(e,f,b)
local n=at(e)if n==nil then
v.warn(string.format("Tuya raw_uint_be expects bytes, got %s",g(e)))return nil
end
local h,j=N(n,Z,f,b)if h==nil then
return nil
end
local as=ad(n,h,j)if as==nil then
v.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ab=i(o,f,b)if ab==nil then
ab=1
end
if ab==0 then
v.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return as/ab
end)
end
function a.power()
return a.from_only(function(e)
local d=c(e)if d==nil then
v.warn(string.format("Tuya power expects number, got %s",g(e)))return nil
end
if d>268435455 then
return(429496732-d)*-1
end
return d
end)
end
function a.scale(R,Q,L,K)
return function(e)
local d=c(e)local E=c(R)local I=c(Q)local H=c(L)local T=c(K)if d==nil then
v.warn(string.format("Tuya scale expects number, got %s",g(e)))return nil
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
return function(e,f,b)
local d=c(e)local ab=i(o,f,b)if d==nil or ab==nil then
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
function a.signed_number_pair(aw)
return a.from_to(
function(e,f,X,b)
local l=nil
if g(X)=="table"and c(X.signed_value)~=nil then
l=c(X.signed_value)else
l=c(e)if l~=nil and l>0x7FFFFFFF then
l=l-4294967296
end
end
if l==nil then
v.warn(string.format("Tuya signed_number_pair expects number, got %s",g(e)))return nil
end
local o=i(aw,f,b)if o==nil then
o=1
end
if o==0 then
v.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return l/o
end,
function(e,f,b)
local d=c(e)if d==nil then
v.warn(string.format("Tuya signed_number_pair expects number, got %s",g(e)))return nil
end
local q=i(aw,f,b)if q==nil then
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
return function(e,f,b)
local d=c(e)local ao=i(q,f,b)if d==nil or ao==nil then
v.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return d*ao
end
end
function a.phase_variant2_parser(ak,ae)
return function(e)
return al.parse_phase_variant2(e,ak,ae)
end
end
function a.phase_variant3_parser(ak)
return function(e)
return al.parse_phase_variant3(e,ak)
end
end
function a.threshold_parser()
return function(e)
return al.parse_threshold(e)
end
end
end
return Y
