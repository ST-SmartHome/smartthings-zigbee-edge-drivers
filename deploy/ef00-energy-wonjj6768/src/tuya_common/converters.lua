local function ae(an,s)
local aE=s.utils
local v=s.log
local D=s.math_floor
local g=s.type_check
local d=s.tonumber_check
local aj=s.raw_bytes
local I=s.string_byte
local ao=s.string_char
local x=s.string_len
local O=s.table_concat
local y={}
local function aC(c)
return c
end
local function p(at,f,b)
if g(at)=="function"then
return at(f,b)
end
return at
end
local function r(l,f,b)
if g(l)=="function"then
return l(f,b)
end
return l
end
local function i(at,f,b)
local t=p(at,f,b)if t==nil then
return nil
end
return d(t)
end
local function u(H)
local R={}for aB,aw in pairs(H)do
R[aw]=aB
end
return R
end
local function B(H,f,b)
local t=p(H,f,b)if t==nil then
return y
end
if g(t)~="table"then
v.warn(string.format("Tuya lookup expects table map, got %s",g(t)))return y
end
return t
end
local function L(k,h,j)
if g(k)~="string"then
return nil
end
local aa=h or 1
local ap=j or(x(k)-aa+1)if aa<1 or ap<1 or(aa+ap-1)>x(k)then
return nil
end
local c=0
for X=aa,aa+ap-1 do
c=(c*256)+I(k,X)
end
return c
end
local function T(k,J,f,b)
local A=x(k)local n=g(J)=="table"and J or y
local j=i(n.bytes or n.length,f,b)if j==nil then
j=A
end
j=D(j)if j<1 or j>A then
v.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(n.start,f,b)if h==nil then
local ax=i(n.offset,f,b)if ax~=nil then
h=D(ax)+1
end
end
if h==nil then
local av=p(n.from_tail,f,b)if av==true then
h=A-j+1
else
h=1
end
end
h=D(h)if h<1 or(h+j-1)>A then
v.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function S(k)
local ar={}for X=1,x(k)do
ar[#ar+1]=string.format("%02X",I(k,X))
end
return O(ar)
end
local function as(H)
local aq={}for aB,_ in pairs(H or y)do
local U=d(aB)if U~=nil then
aq[#aq+1]=D(U)
end
end
table.sort(aq)return aq
end
local a=an.converter
function a.pipe(...)
local ab={...}if #ab==1 and g(ab[1])=="table"then
ab=ab[1]
end
return function(c,f,b)
local ac=c
for _,aD in ipairs(ab)do
ac=aD(ac,f,b)
end
return ac
end
end
function a.from_to(z,ak)
local az={}
if g(z)=="function"then
az.from=z
end
if g(ak)=="function"then
az.to=ak
end
return az
end
function a.from_only(z)
return a.from_to(z,nil)
end
function a.lookup_from_to(H,l)
local w=g(H)=="table"and H or nil
local ag=w and u(w)or nil
return a.from_to(
function(c,f,b)
local F=w or B(H,f,b)local R=ag or u(F)local N=R[c]if N~=nil then
return N
end
local E=r(l,f,b)if E~=nil then
return E
end
v.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(c)))return nil
end,
a.lookup_value(H,l))
end
function a.lookup_value(H,l)
local w=g(H)=="table"and H or nil
return function(c,f,b)
local F=w or B(H,f,b)local N=F[c]if N~=nil then
return N
end
local E=r(l,f,b)if E~=nil then
return E
end
v.warn(string.format("Tuya lookup missing key: %s",tostring(c)))return nil
end
end
function a.raw_uint_be(o,J)
local af=g(J)=="table"and J or nil
return a.from_only(function(c,f,b)
local k=aj(c)if k==nil then
v.warn(string.format("Tuya raw_uint_be expects bytes, got %s",g(c)))return nil
end
local h,j=T(k,af,f,b)if h==nil then
return nil
end
local ay=L(k,h,j)if ay==nil then
v.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ah=i(o,f,b)if ah==nil then
ah=1
end
if ah==0 then
v.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return ay/ah
end)
end
function a.raw_identifier()
return a.from_only(function(c)
local k=aj(c)if k==nil then
return c
end
local A=x(k)local al={}local ai=true
for X=1,A do
local C=I(k,X)if C~=0 then
if C<32 or C>126 then
ai=false
end
al[#al+1]=ao(C)
end
end
if ai and #al>0 then
return O(al)
end
if A<=4 then
return L(k,1,A)
end
return S(k)
end)
end
function a.power_on_behavior()
return a.lookup_from_to({
off=0,on=1,previous=2,})
end
function a.power_outage_memory()
return a.lookup_from_to({
off=0,on=1,restore=2,})
end
function a.power()
return a.from_only(function(c)
local e=d(c)if e==nil then
v.warn(string.format("Tuya power expects number, got %s",g(c)))return nil
end
if e>268435455 then
return(429496732-e)*-1
end
return e
end)
end
function a.scale(W,V,Q,P)
return function(c)
local e=d(c)local G=d(W)local M=d(V)local K=d(Q)local Y=d(P)if e==nil then
v.warn(string.format("Tuya scale expects number, got %s",g(c)))return nil
end
if G==nil or M==nil or K==nil or Y==nil then
v.warn("Tuya scale expects numeric ranges")return nil
end
if M==G then
v.warn("Tuya scale input range cannot be zero")return nil
end
return((e-G)*(Y-K)/(M-G))+K
end
end
function a.scale_pair(W,V,Q,P)
return a.from_to(
a.scale(W,V,Q,P),a.scale(Q,P,W,V))
end
function a.divide_by(o)
return function(c,f,b)
local e=d(c)local ah=i(o,f,b)if e==nil or ah==nil then
v.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ah==0 then
v.warn("Tuya divide_by divisor cannot be zero")return nil
end
return e/ah
end
end
function a.divide_by_pair(o)
return a.from_to(
a.divide_by(o),a.multiply_by(o))
end
function a.signed_number_pair(aA)
return a.from_to(
function(c,f,ad,b)
local m=nil
if g(ad)=="table"and d(ad.signed_value)~=nil then
m=d(ad.signed_value)else
m=d(c)if m~=nil and m>0x7FFFFFFF then
m=m-4294967296
end
end
if m==nil then
v.warn(string.format("Tuya signed_number_pair expects number, got %s",g(c)))return nil
end
local o=i(aA,f,b)if o==nil then
o=1
end
if o==0 then
v.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return m/o
end,
function(c,f,b)
local e=d(c)if e==nil then
v.warn(string.format("Tuya signed_number_pair expects number, got %s",g(c)))return nil
end
local q=i(aA,f,b)if q==nil then
q=1
end
if q==0 then
v.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return e*q
end
)
end
function a.multiply_by(q)
return function(c,f,b)
local e=d(c)local au=i(q,f,b)if e==nil or au==nil then
v.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return e*au
end
end
function a.phase_variant1_parser(Z)
return function(c)
return an.parse_phase_variant1(c,Z)
end
end
function a.phase_variant2_parser(Z,am)
return function(c)
return an.parse_phase_variant2(c,Z,am)
end
end
function a.phase_variant3_parser(Z)
return function(c)
return an.parse_phase_variant3(c,Z)
end
end
function a.threshold_parser()
return function(c)
return an.parse_threshold(c)
end
end
end
return ae
