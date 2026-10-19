local function ab(ay,u)
local aC=u.utils
local s=u.log
local C=u.math_floor
local e=u.type_check
local d=u.tonumber_check
local at=u.raw_bytes
local S=u.string_byte
local aA=u.string_char
local D=u.string_len
local ah=u.table_concat
local z={}
local function az(b)
return b
end
local function p(an,g,c)
if e(an)=="function"then
return an(g,c)
end
return an
end
local function t(k,g,c)
if e(k)=="function"then
return k(g,c)
end
return k
end
local function i(an,g,c)
local v=p(an,g,c)if v==nil then
return nil
end
return d(v)
end
local function w(H)
local P={}for ax,aq in pairs(H)do
P[aq]=ax
end
return P
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
local X=h or 1
local ai=j or(D(n)-X+1)if X<1 or ai<1 or(X+ai-1)>D(n)then
return nil
end
local b=0
for aj=X,X+ai-1 do
b=(b*256)+S(n,aj)
end
return b
end
local function Q(n,J,g,c)
local V=D(n)local m=e(J)=="table"and J or z
local j=i(m.bytes or m.length,g,c)if j==nil then
j=V
end
j=C(j)if j<1 or j>V then
s.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(m.start,g,c)if h==nil then
local ar=i(m.offset,g,c)if ar~=nil then
h=C(ar)+1
end
end
if h==nil then
local ap=p(m.from_tail,g,c)if ap==true then
h=V-j+1
else
h=1
end
end
h=C(h)if h<1 or(h+j-1)>V then
s.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function au(n)
local al={}for aj=1,D(n)do
al[#al+1]=string.format("%02X",S(n,aj))
end
return ah(al)
end
local function am(H)
local ak={}for ax,_ in pairs(H or z)do
local R=d(ax)if R~=nil then
ak[#ak+1]=C(R)
end
end
table.sort(ak)return ak
end
local a=ay.converter
function a.pipe(...)
local Y={...}if #Y==1 and e(Y[1])=="table"then
Y=Y[1]
end
return function(b,g,c)
local Z=b
for _,aB in ipairs(Y)do
Z=aB(Z,g,c)
end
return Z
end
end
function a.from_to(A,I)
local av={}
if e(A)=="function"then
av.from=A
end
if e(I)=="function"then
av.to=I
end
return av
end
function a.from_only(A)
return a.from_to(A,nil)
end
function a.to_only(I)
return a.from_to(nil,I)
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
function a.constant(ag)
return function()
return ag
end
end
function a.lookup_from_to(H,k)
local x=e(H)=="table"and H or nil
local ad=x and w(x)or nil
return a.from_to(
function(b,g,c)
local F=x or B(H,g,c)local P=ad or w(F)local M=P[b]if M~=nil then
return M
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
local F=x or B(H,g,c)local M=F[b]if M~=nil then
return M
end
local E=t(k,g,c)if E~=nil then
return E
end
s.warn(string.format("Tuya lookup missing key: %s",tostring(b)))return nil
end
end
function a.raw_uint_be(o,J)
local ac=e(J)=="table"and J or nil
return a.from_only(function(b,g,c)
local n=at(b)if n==nil then
s.warn(string.format("Tuya raw_uint_be expects bytes, got %s",e(b)))return nil
end
local h,j=Q(n,ac,g,c)if h==nil then
return nil
end
local as=af(n,h,j)if as==nil then
s.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ae=i(o,g,c)if ae==nil then
ae=1
end
if ae==0 then
s.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return as/ae
end)
end
function a.true_false1()
return a.bool_pair(1,0)
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
function a.scale(U,T,O,N)
return function(b)
local f=d(b)local G=d(U)local L=d(T)local K=d(O)local W=d(N)if f==nil then
s.warn(string.format("Tuya scale expects number, got %s",e(b)))return nil
end
if G==nil or L==nil or K==nil or W==nil then
s.warn("Tuya scale expects numeric ranges")return nil
end
if L==G then
s.warn("Tuya scale input range cannot be zero")return nil
end
return((f-G)*(W-K)/(L-G))+K
end
end
function a.scale_pair(U,T,O,N)
return a.from_to(
a.scale(U,T,O,N),a.scale(O,N,U,T))
end
function a.divide_by(o)
return function(b,g,c)
local f=d(b)local ae=i(o,g,c)if f==nil or ae==nil then
s.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ae==0 then
s.warn("Tuya divide_by divisor cannot be zero")return nil
end
return f/ae
end
end
function a.divide_by_pair(o)
return a.from_to(
a.divide_by(o),a.multiply_by(o))
end
function a.signed_number_pair(aw)
return a.from_to(
function(b,g,aa,c)
local l=nil
if e(aa)=="table"and d(aa.signed_value)~=nil then
l=d(aa.signed_value)else
l=d(b)if l~=nil and l>0x7FFFFFFF then
l=l-4294967296
end
end
if l==nil then
s.warn(string.format("Tuya signed_number_pair expects number, got %s",e(b)))return nil
end
local o=i(aw,g,c)if o==nil then
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
local q=i(aw,g,c)if q==nil then
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
local f=d(b)local ao=i(q,g,c)if f==nil or ao==nil then
s.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return f*ao
end
end
function a.threshold_parser()
return function(b)
return ay.parse_threshold(b)
end
end
end
return ab
