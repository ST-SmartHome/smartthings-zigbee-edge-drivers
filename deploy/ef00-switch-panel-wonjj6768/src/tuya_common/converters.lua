local function Z(az,t)
local aC=t.utils
local r=t.log
local x=t.math_floor
local f=t.type_check
local c=t.tonumber_check
local ad=t.raw_bytes
local u=t.string_byte
local ah=t.string_char
local z=t.string_len
local ag=t.table_concat
local A={}
local function aA(d)
return d
end
local function p(ao,g,b)
if f(ao)=="function"then
return ao(g,b)
end
return ao
end
local function s(k,g,b)
if f(k)=="function"then
return k(g,b)
end
return k
end
local function i(ao,g,b)
local v=p(ao,g,b)if v==nil then
return nil
end
return c(v)
end
local function w(G)
local O={}for ay,ar in pairs(G)do
O[ar]=ay
end
return O
end
local function C(G,g,b)
local v=p(G,g,b)if v==nil then
return A
end
if f(v)~="table"then
r.warn(string.format("Tuya lookup expects table map, got %s",f(v)))return A
end
return v
end
local function af(n,h,j)
if f(n)~="string"then
return nil
end
local V=h or 1
local ai=j or(z(n)-V+1)if V<1 or ai<1 or(V+ai-1)>z(n)then
return nil
end
local d=0
for aj=V,V+ai-1 do
d=(d*256)+u(n,aj)
end
return d
end
local function P(n,H,g,b)
local T=z(n)local m=f(H)=="table"and H or A
local j=i(m.bytes or m.length,g,b)if j==nil then
j=T
end
j=x(j)if j<1 or j>T then
r.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(m.start,g,b)if h==nil then
local as=i(m.offset,g,b)if as~=nil then
h=x(as)+1
end
end
if h==nil then
local aq=p(m.from_tail,g,b)if aq==true then
h=T-j+1
else
h=1
end
end
h=x(h)if h<1 or(h+j-1)>T then
r.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function av(n)
local al={}for aj=1,z(n)do
al[#al+1]=string.format("%02X",u(n,aj))
end
return ag(al)
end
local function an(G)
local ak={}for ay,_ in pairs(G or A)do
local Q=c(ay)if Q~=nil then
ak[#ak+1]=x(Q)
end
end
table.sort(ak)return ak
end
local a=az.converter
function a.pipe(...)
local W={...}if #W==1 and f(W[1])=="table"then
W=W[1]
end
return function(d,g,b)
local X=d
for _,aB in ipairs(W)do
X=aB(X,g,b)
end
return X
end
end
function a.from_to(B,ae)
local aw={}
if f(B)=="function"then
aw.from=B
end
if f(ae)=="function"then
aw.to=ae
end
return aw
end
function a.from_only(B)
return a.from_to(B,nil)
end
function a.lookup_from_to(G,k)
local y=f(G)=="table"and G or nil
local ab=y and w(y)or nil
return a.from_to(
function(d,g,b)
local E=y or C(G,g,b)local O=ab or w(E)local L=O[d]if L~=nil then
return L
end
local D=s(k,g,b)if D~=nil then
return D
end
r.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(d)))return nil
end,
a.lookup_value(G,k))
end
function a.lookup_value(G,k)
local y=f(G)=="table"and G or nil
return function(d,g,b)
local E=y or C(G,g,b)local L=E[d]if L~=nil then
return L
end
local D=s(k,g,b)if D~=nil then
return D
end
r.warn(string.format("Tuya lookup missing key: %s",tostring(d)))return nil
end
end
function a.raw_uint_be(o,H)
local aa=f(H)=="table"and H or nil
return a.from_only(function(d,g,b)
local n=ad(d)if n==nil then
r.warn(string.format("Tuya raw_uint_be expects bytes, got %s",f(d)))return nil
end
local h,j=P(n,aa,g,b)if h==nil then
return nil
end
local at=af(n,h,j)if at==nil then
r.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ac=i(o,g,b)if ac==nil then
ac=1
end
if ac==0 then
r.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return at/ac
end)
end
function a.power_on_behavior()
return a.lookup_from_to({
off=0,on=1,previous=2,})
end
function a.indicator_mode_none_relay_pos()
return a.lookup_from_to({
none=0,relay=1,pos=2,})
end
function a.power()
return a.from_only(function(d)
local e=c(d)if e==nil then
r.warn(string.format("Tuya power expects number, got %s",f(d)))return nil
end
if e>268435455 then
return(429496732-e)*-1
end
return e
end)
end
function a.scale(S,R,N,M)
return function(d)
local e=c(d)local F=c(S)local K=c(R)local J=c(N)local U=c(M)if e==nil then
r.warn(string.format("Tuya scale expects number, got %s",f(d)))return nil
end
if F==nil or K==nil or J==nil or U==nil then
r.warn("Tuya scale expects numeric ranges")return nil
end
if K==F then
r.warn("Tuya scale input range cannot be zero")return nil
end
return((e-F)*(U-J)/(K-F))+J
end
end
function a.scale_pair(S,R,N,M)
return a.from_to(
a.scale(S,R,N,M),a.scale(N,M,S,R))
end
function a.divide_by(o)
return function(d,g,b)
local e=c(d)local ac=i(o,g,b)if e==nil or ac==nil then
r.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ac==0 then
r.warn("Tuya divide_by divisor cannot be zero")return nil
end
return e/ac
end
end
function a.divide_by_pair(o)
return a.from_to(
a.divide_by(o),a.multiply_by(o))
end
function a.signed_number_pair(ax)
return a.from_to(
function(d,g,Y,b)
local l=nil
if f(Y)=="table"and c(Y.signed_value)~=nil then
l=c(Y.signed_value)else
l=c(d)if l~=nil and l>0x7FFFFFFF then
l=l-4294967296
end
end
if l==nil then
r.warn(string.format("Tuya signed_number_pair expects number, got %s",f(d)))return nil
end
local o=i(ax,g,b)if o==nil then
o=1
end
if o==0 then
r.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return l/o
end,
function(d,g,b)
local e=c(d)if e==nil then
r.warn(string.format("Tuya signed_number_pair expects number, got %s",f(d)))return nil
end
local q=i(ax,g,b)if q==nil then
q=1
end
if q==0 then
r.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return e*q
end
)
end
function a.multiply_by(q)
return function(d,g,b)
local e=c(d)local ap=i(q,g,b)if e==nil or ap==nil then
r.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return e*ap
end
end
function a.threshold_parser()
return function(d)
return az.parse_threshold(d)
end
end
function a.inching_switch()
return a.from_to(
function(d)
local au=ad(d)if au==nil or z(au)<3 then
r.warn("Tuya inching_switch expects at least 3 bytes")return nil
end
local am=u(au,1)local I=u(au,2)*256+u(au,3)return{state=(am~=0),duration=I}
end,
function(d)
if f(d)~="table"then
r.warn("Tuya inching_switch expects table {state, duration}")return nil
end
local am=d.state and 1 or 0
local I=c(d.duration)or 0
return ah(am,x(I/256)%256,I%256)
end
)
end
end
return Z
