local function ad(aF,x)
local aJ=x.utils
local z=x.log
local v=x.math_floor
local d=x.type_check
local c=x.tonumber_check
local ax=x.raw_bytes
local T=x.string_byte
local aH=x.string_char
local F=x.string_len
local N=x.table_concat
local D={}
local function aG(g)
return g
end
local function m(ar,e,b)
if d(ar)=="function"then
return ar(e,b)
end
return ar
end
local function q(k,e,b)
if d(k)=="function"then
return k(e,b)
end
return k
end
local function i(ar,e,b)
local y=m(ar,e,b)if y==nil then
return nil
end
return c(y)
end
local function A(B)
local Q={}for aE,au in pairs(B)do
Q[au]=aE
end
return Q
end
local function t(B,e,b)
local y=m(B,e,b)if y==nil then
return D
end
if d(y)~="table"then
z.warn(string.format("Tuya lookup expects table map, got %s",d(y)))return D
end
return y
end
local function aj(r,h,j)
if d(r)~="string"then
return nil
end
local Z=h or 1
local an=j or(F(r)-Z+1)if Z<1 or an<1 or(Z+an-1)>F(r)then
return nil
end
local g=0
for ao=Z,Z+an-1 do
g=(g*256)+T(r,ao)
end
return g
end
local function R(r,I,e,b)
local X=F(r)local p=d(I)=="table"and I or D
local j=i(p.bytes or p.length,e,b)if j==nil then
j=X
end
j=v(j)if j<1 or j>X then
z.warn("Tuya raw_uint_be requires valid byte count")return nil,nil
end
local h=i(p.start,e,b)if h==nil then
local av=i(p.offset,e,b)if av~=nil then
h=v(av)+1
end
end
if h==nil then
local at=m(p.from_tail,e,b)if at==true then
h=X-j+1
else
h=1
end
end
h=v(h)if h<1 or(h+j-1)>X then
z.warn("Tuya raw_uint_be slice is out of range")return nil,nil
end
return h,j
end
local function az(r)
local aq={}for ao=1,F(r)do
aq[#aq+1]=string.format("%02X",T(r,ao))
end
return N(aq)
end
local function C(B)
local ap={}for aE,_ in pairs(B or D)do
local S=c(aE)if S~=nil then
ap[#ap+1]=v(S)
end
end
table.sort(ap)return ap
end
local a=aF.converter
function a.pipe(...)
local aa={...}if #aa==1 and d(aa[1])=="table"then
aa=aa[1]
end
return function(g,e,b)
local ab=g
for _,aI in ipairs(aa)do
ab=aI(ab,e,b)
end
return ab
end
end
function a.from_to(E,ah)
local aA={}
if d(E)=="function"then
aA.from=E
end
if d(ah)=="function"then
aA.to=ah
end
return aA
end
function a.from_only(E)
return a.from_to(E,nil)
end
function a.lookup_from_to(B,k)
local n=d(B)=="table"and B or nil
local af=n and A(n)or nil
return a.from_to(
function(g,e,b)
local o=n or t(B,e,b)local Q=af or A(o)local M=Q[g]if M~=nil then
return M
end
local G=q(k,e,b)if G~=nil then
return G
end
z.warn(string.format("Tuya lookup_from_to missing value: %s",tostring(g)))return nil
end,
a.lookup_value(B,k))
end
function a.lookup_value(B,k)
local n=d(B)=="table"and B or nil
return function(g,e,b)
local o=n or t(B,e,b)local M=o[g]if M~=nil then
return M
end
local G=q(k,e,b)if G~=nil then
return G
end
z.warn(string.format("Tuya lookup missing key: %s",tostring(g)))return nil
end
end
function a.raw_uint_be(s,I)
local ae=d(I)=="table"and I or nil
return a.from_only(function(g,e,b)
local r=ax(g)if r==nil then
z.warn(string.format("Tuya raw_uint_be expects bytes, got %s",d(g)))return nil
end
local h,j=R(r,ae,e,b)if h==nil then
return nil
end
local aw=aj(r,h,j)if aw==nil then
z.warn("Tuya raw_uint_be failed to parse payload")return nil
end
local ag=i(s,e,b)if ag==nil then
ag=1
end
if ag==0 then
z.warn("Tuya raw_uint_be divisor cannot be zero")return nil
end
return aw/ag
end)
end
function a.bitmap_flags(B,al,ay)
local n=d(B)=="table"and B or nil
local am=n and C(n)or nil
return a.from_only(function(g,e,b)
local K=c(g)if K==nil then
z.warn(string.format("Tuya bitmap_flags expects number, got %s",d(g)))return nil
end
local o=n or t(B,e,b)local ak=am or C(o)local W={}local ai=v(K)for _,aD in ipairs(ak)do
if v(ai/aD)%2==1 then
local aB=o[aD]or o[tostring(aD)]if aB~=nil then
W[#W+1]=aB
end
end
end
if #W==0 then
return q(al,e,b)
end
local u=m(ay,e,b)if d(u)~="string"then
u=","
end
return N(W,u)
end)
end
function a.power()
return a.from_only(function(g)
local f=c(g)if f==nil then
z.warn(string.format("Tuya power expects number, got %s",d(g)))return nil
end
if f>268435455 then
return(429496732-f)*-1
end
return f
end)
end
function a.scale(V,U,P,O)
return function(g)
local f=c(g)local H=c(V)local L=c(U)local J=c(P)local Y=c(O)if f==nil then
z.warn(string.format("Tuya scale expects number, got %s",d(g)))return nil
end
if H==nil or L==nil or J==nil or Y==nil then
z.warn("Tuya scale expects numeric ranges")return nil
end
if L==H then
z.warn("Tuya scale input range cannot be zero")return nil
end
return((f-H)*(Y-J)/(L-H))+J
end
end
function a.scale_pair(V,U,P,O)
return a.from_to(
a.scale(V,U,P,O),a.scale(P,O,V,U))
end
function a.divide_by(s)
return function(g,e,b)
local f=c(g)local ag=i(s,e,b)if f==nil or ag==nil then
z.warn("Tuya divide_by expects numeric input and divisor")return nil
end
if ag==0 then
z.warn("Tuya divide_by divisor cannot be zero")return nil
end
return f/ag
end
end
function a.divide_by_pair(s)
return a.from_to(
a.divide_by(s),a.multiply_by(s))
end
function a.signed_number_pair(aC)
return a.from_to(
function(g,e,ac,b)
local l=nil
if d(ac)=="table"and c(ac.signed_value)~=nil then
l=c(ac.signed_value)else
l=c(g)if l~=nil and l>0x7FFFFFFF then
l=l-4294967296
end
end
if l==nil then
z.warn(string.format("Tuya signed_number_pair expects number, got %s",d(g)))return nil
end
local s=i(aC,e,b)if s==nil then
s=1
end
if s==0 then
z.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return l/s
end,
function(g,e,b)
local f=c(g)if f==nil then
z.warn(string.format("Tuya signed_number_pair expects number, got %s",d(g)))return nil
end
local w=i(aC,e,b)if w==nil then
w=1
end
if w==0 then
z.warn("Tuya signed_number_pair scale cannot be zero")return nil
end
return f*w
end
)
end
function a.multiply_by(w)
return function(g,e,b)
local f=c(g)local as=i(w,e,b)if f==nil or as==nil then
z.warn("Tuya multiply_by expects numeric input and multiplier")return nil
end
return f*as
end
end
function a.threshold_parser()
return function(g)
return aF.parse_threshold(g)
end
end
end
return ad
