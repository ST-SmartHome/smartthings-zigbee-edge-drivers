local function at(i,aC,bu)
bu=bu or{switch=function()return nil end}
local e=aC.type_check
local O=aC.table_insert
local aS=aC.tonumber_check
local o=aC.merge_options
local bm=aC.copy_keys
local n=i.converter
local function aq(aa,L)
if e(aa)~="table"or e(L)~="table"then
return aa
end
for as,S in pairs(L)do
if aa[as]==nil then
aa[as]=S
end
end
return aa
end
local function d(b,c,h)
local a={}if e(b)=="string"then
a.name=b
else
o(a,b)
end
o(a,c)if a.name==nil and h~=nil then
a.name=h
end
return a
end
local an={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function am(c)
if e(c)~="table"then
return false
end
for _,as in ipairs(an)do
if c[as]~=nil then
return true
end
end
return false
end
local function aH(bh,c)
if am(c)then
return bh
end
return i.apply_fixed_send_policy(bh)
end
local function w(k,h,b,c)
local a=d(b,c,h)local z=a.scale
if z==nil then
z=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and z~=1 then
a.converter=n.divide_by_pair(z)
end
a.scale=nil
return i.dp_numeric(k,a)
end
local function f(k,h,D,b,c)
local a=d(b,c,h)local z=a.scale
if z==nil then
z=D
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and z~=1 then
a.converter=n.divide_by_pair(z)
end
a.scale=nil
return i.dp_numeric(k,a)
end
local function aW(k,h,D,b,c)
local a=d(b,c,h)local z=a.scale
if z==nil then
z=D
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ap=n.power()local bf=ap.from
if z~=1 then
a.from_device=n.pipe(
bf,n.divide_by(z))else
a.converter=ap
end
end
a.scale=nil
return i.dp_numeric(k,a)
end
local function q(k,h,D,b,c)
local a=d(b,c,h)local z=a.scale
if z==nil then
z=D
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=n.signed_number_pair(z)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return i.dp_numeric(k,a)
end
local function j(k,h,D,bc,b,c)
local a=d(b,c,h)local z=a.scale
if z==nil then
z=D
end
local br=
a.datatype==i.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if br and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aF={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}aq(aF,bc)a.converter=n.raw_uint_be(z,aF)if a.datatype==nil then
a.datatype=i.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and z~=1 then
a.converter=n.divide_by_pair(z)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return i.dp_numeric(k,a)
end
local function X(S,bp,bo)
local aB=aS(S)if aB==nil then
return nil
end
return bp+bo-aB
end
local function aU(k,h,L,b,c)
local a=d(b,c,h)local ag=a.raw_min
if ag==nil then
ag=L.raw_min
end
local af=a.raw_max
if af==nil then
af=L.raw_max
end
local J=a.value_min
if J==nil then
J=L.value_min
end
local I=a.value_max
if I==nil then
I=L.value_max
end
local bv=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bv then
local bj=n.scale(ag,af,J,I)local bs=n.scale(J,I,ag,af)a.converter=n.from_to(
function(S,aY,aP)
local bq=bj(S,aY,aP)if bq==nil then
return nil
end
return X(bq,J,I)
end,
function(S,aY,aP)
local ba=X(S,J,I)if ba==nil then
return nil
end
return bs(ba,aY,aP)
end
)elseif ag~=J or af~=I then
a.converter=n.scale_pair(ag,af,J,I)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return i.dp_numeric(k,a)
end
local function bk(phase,aZ)
if e(phase)=="string"and phase~=""then
return(aZ or"phase").."_"..phase
end
return aZ or"phase"
end
local function bb(bx,phase)
local bn={}for _,as in ipairs(bx or{})do
local aI=as
if e(phase)=="string"and phase~=""then
aI=as.."_"..phase
end
bn[aI]=true
end
return bn
end
local function bd(k,h,aR,bi,b,c)
local aX=
e(b)=="string"or
(e(b)=="table"and b.name~=nil)or
(e(c)=="table"and c.name~=nil)local a=d(b,c,h)local phase=a.phase
if not aX and a.name==h then
a.name=bk(phase,h)
end
if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=aR(a)
end
if a.field==nil and a.fields==nil then
a.fields=bb(bi,phase)
end
return i.dp_raw(k,a)
end
local function be(k,b,c)
local a=d(b,c,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=n.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return i.dp_raw(k,a)
end
local function ao(s)
if e(s)=="number"and s%1==0 and s>=0 then
return{s}
end
if e(s)~="table"then
return{}
end
local aJ={}for _,k in ipairs(s)do
if e(k)=="number"and k%1==0 and k>=0 then
O(aJ,k)
end
end
return aJ
end
local function ab(c)
if e(c)~="table"then
return c
end
local s=c.dps
if s==nil then
s=c.dp_list
end
if s==nil and c[1]~=nil then
s=c
end
return s
end
local function ae(c)
local s=ab(c)if s~=nil then
return s
end
if e(c)~="table"then
return c
end
return c.dp
end
local function aK(C,c)
c=c or{}local aL=c.phases
if e(aL)~="table"then
aL=c.phase_names
end
local phase=e(aL)=="table"and aL[C]or nil
if e(phase)=="string"and phase~=""then
return phase
end
local G=c.phase_prefix
if G==false then
return nil
end
if e(G)~="string"or G==""then
G=nil
end
if G~=nil then
return G..tostring(C)
end
return tostring(C)
end
local function ai(C,c)
c=c or{}local M=c.first_is_main~=false
local K=c.component_prefix
if e(K)~="string"or K==""then
K="switch"
end
local R=c.main_component
if e(R)~="string"or R==""then
R="main"
end
local v=c.index_offset
if e(v)~="number"or v%1~=0 then
v=0
end
if C==1 and M then
return R
end
local aD=M and(C-1+v)or(C+v)if aD<1 then
return c.default_component
end
return K..tostring(aD)
end
local function az(C,c,aQ)
c=c or{}local M=c.first_is_main~=false
local Y=c.key_prefix
if e(Y)~="string"or Y==""then
Y=aQ or"switch"
end
local av=c.main_key
if e(av)~="string"or av==""then
av=Y
end
local v=c.index_offset
if e(v)~="number"or v%1~=0 then
v=0
end
if C==1 and M then
return av
end
local aD=M and(C-1+v)or(C+v)if aD<1 then
return c.default_key
end
return Y..tostring(aD)
end
local function T(l,k,B,c)
if e(k)~="number"or k%1~=0 or k<0 then
return
end
O(l,B(k,c))
end
local function ac(aa,bt)
if e(bt)~="table"then
return aa
end
for _,bw in ipairs(bt)do
O(aa,bw)
end
return aa
end
local al={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function ay(S)
return e(S)=="number"and S%1==0 and S>0
end
local function u(c,m)
local a={}if e(c)~="table"then
return a
end
for as,S in pairs(c)do
local aG=true
if not m then
if as=="dp"or as=="dps"or as=="dp_list"then
aG=false
elseif ay(as)then
aG=false
end
end
if aG then
a[as]=S
end
end
return a
end
local function ad(c)
if e(c)~="table"then
return false
end
if c.dp~=nil or c.dps~=nil or c.dp_list~=nil or c[1]~=nil then
return true
end
return false
end
local function H(c)
if e(c)~="table"then
return c
end
c.dp=nil
c.dps=nil
c.dp_list=nil
local C=1
while c[C]~=nil do
c[C]=nil
C=C+1
end
return c
end
local function y(c,t,m)
if e(c)~="table"then
return{}
end
local x=c[t]if x==nil then
return u(c,m)
end
local a=u(c,m)if e(x)=="table"then
o(a,x)else
a.dp=x
end
return a
end
local function A(x)
if x==nil then
return nil
end
if e(x)=="table"then
return x
end
return{dp=x}
end
local function W(c,t)
if e(c)~="table"then
return nil
end
return A(c[t])
end
local function aw(au,g)
local N=e(au)=="table"and au.item_options or nil
local F=e(g)=="table"and g.item_options or nil
if e(N)~="table"then
return e(F)=="table"and F or nil
end
if e(F)~="table"then
return N
end
local a={}o(a,N)o(a,F)return a
end
local function ah(c,t,E,m)
local a={}local x=nil
if e(c)=="table"then
bm(a,c,al)x=c[t]if e(x)=="table"then
o(a,u(c,m))if m and ad(x)then
H(a)
end
o(a,x)elseif x~=nil then
o(a,u(c,m))if m then
H(a)
end
a.dp=x
else
o(a,u(c,m))
end
end
if a.key_prefix==nil and E~=nil then
a.key_prefix=E
end
a.item_options=aw(c,x)return a
end
local function P(c,r)
local p={}local ar=W(c,"config")o(p,ar)local ax=A(p[r])if ax~=nil then
p[r]=ax
else
local Z=A(p.switch_type)if Z==nil then
Z=W(c,"switch_type")
end
if e(Z)=="table"then
p[r]=Z
end
end
if r~="switch_type"then
p.switch_type=nil
end
if next(p)~=nil then
return p
end
return{}
end
local function Q(c,r)
local a={}if e(c)=="table"then
o(a,c)
end
local p=P(c,r)if next(p)~=nil then
a.config=p
end
a.switch_type=nil
return a
end
local function aV(c,r)
local a={}if e(c)=="table"then
o(a,c)
end
local V=Q(
y(c,"switch_module"),r)if next(V)~=nil then
a.switch_module=V
end
return a
end
local function bl(l,c,t,B)
local g=y(c,t)T(l,g.dp,B,g)
end
local function aE(l,c,t,B,L)
local g=y(c,t)aq(g,L)T(l,g.dp,B,g)
end
local function aT(l,c,t,B,aA)
local g=y(c,t)local s=ab(g)if s~=nil and aA~=nil then
ac(l,aA(s,g))return
end
T(l,g.dp,B,g)
end
local function aM(l,c,t,E,B)
local g=ah(c,t,E)ac(l,B(ae(g),g))
end
local function bg(s,B,h,c)
local l={}local ak=ao(s)local aj=e(c)=="table"and c.item_options or nil
for C,k in ipairs(ak)do
local a=d(aj,nil,h)if a.component==nil then
a.component=ai(C,c)
end
if a.key==nil and a.preference==nil then
a.key=az(C,c,h)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
O(l,B(k,a))
end
return l
end
local function aO(s,B,c)
local l={}local ak=ao(s)local aj=e(c)=="table"and c.item_options or nil
for C,k in ipairs(ak)do
local a=d(aj,nil,nil)if a.phase==nil then
a.phase=aK(C,c)
end
O(l,B(k,a))
end
return l
end
local function aN(c,t,B)
local g=nil
if e(c)=="table"then
g=y(c,t,true)else
g={dp=c}
end
local l={}T(l,g.dp,B,g)return l
end
function i.dp_temperature(k,b,c)
return w(k,"temperature",b,c)
end
function i.dp_humidity(k,b,c)
return w(k,"humidity",b,c)
end
function i.dp_battery(k,b,c)
return f(k,"battery",1,b,c)
end
function i.dp_illuminance(k,b,c)
local a=d(b,c,"illuminance")return i.dp_numeric(k,a)
end
function i.dp_temperature_unit(k,b,c)
local a=d(b,c,"temperature_unit")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=n.temperature_unit()
end
return i.dp_enum(k,a)
end
function i.dp_inlet_water_temperature(k,b,c)
return f(k,"inlet_water_temperature",100,b,c)
end
function i.dp_outlet_water_temperature(k,b,c)
return f(k,"outlet_water_temperature",100,b,c)
end
function i.dp_temperature_calibration(k,b,c)
return q(k,"temperature_calibration",10,b,c)
end
function i.dp_humidity_calibration(k,b,c)
return q(k,"humidity_calibration",1,b,c)
end
function i.dp_max_temperature_alarm(k,b,c)
return w(k,"max_temperature_alarm",b,c)
end
function i.dp_min_temperature_alarm(k,b,c)
return w(k,"min_temperature_alarm",b,c)
end
function i.dp_max_humidity_alarm(k,b,c)
return f(k,"max_humidity_alarm",1,b,c)
end
function i.dp_min_humidity_alarm(k,b,c)
return f(k,"min_humidity_alarm",1,b,c)
end
function i.dp_temperature_alarm(k,b,c)
local a=d(b,c,"temperature_alarm")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=n.alarm_state_lower_upper_cancel()
end
return i.dp_enum(k,a)
end
function i.dp_humidity_alarm(k,b,c)
local a=d(b,c,"humidity_alarm")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=n.alarm_state_lower_upper_cancel()
end
return i.dp_enum(k,a)
end
function i.dp_soil_moisture(k,b,c)
return f(k,"soil_moisture",1,b,c)
end
function i.dp_soil_calibration(k,b,c)
return q(k,"soil_calibration",1,b,c)
end
function i.dp_temperature_sampling(k,b,c)
return f(k,"temperature_sampling",1,b,c)
end
function i.dp_report_interval(k,b,c)
return f(k,"report_interval",1,b,c)
end
function i.dp_soil_sampling(k,b,c)
return f(k,"soil_sampling",1,b,c)
end
function i.dp_soil_warning(k,b,c)
return f(k,"soil_warning",1,b,c)
end
function i.dp_illuminance_calibration(k,b,c)
return q(k,"illuminance_calibration",1,b,c)
end
function i.dp_water_warning(k,b,c)
local a=d(b,c,"water_warning")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=n.water_warning()
end
return i.dp_enum(k,a)
end
function i.dp_soil_fertility(k,b,c)
return f(k,"soil_fertility",1,b,c)
end
function i.dp_soil_fertility_calibration(k,b,c)
return q(k,"soil_fertility_calibration",1,b,c)
end
function i.dp_soil_fertility_warning(k,b,c)
local a=d(b,c,"soil_fertility_warning")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=n.soil_fertility_warning()
end
return i.dp_enum(k,a)
end
function i.dp_water_consumed(k,b,c)
return j(
k,"water_consumed",1000,{bytes=4,from_tail=true},b,c)
end
function i.dp_reverse_water_consumed(k,b,c)
return j(
k,"reverse_water_consumed",1000,{bytes=4},b,c)
end
function i.dp_month_consumption(k,b,c)
return j(
k,"month_consumption",1000,{bytes=4,from_tail=true},b,c)
end
function i.dp_daily_consumption(k,b,c)
return j(
k,"daily_consumption",1000,{bytes=4,from_tail=true},b,c)
end
function i.dp_flow_rate(k,b,c)
return j(
k,"flow_rate",1000,{bytes=4},b,c)
end
function i.dp_instantaneous_flow_rate(k,b,c)
return j(
k,"instantaneous_flow_rate",1000,{bytes=4},b,c)
end
function i.dp_cumulative_heat(k,b,c)
return j(
k,"cumulative_heat",100,{bytes=4},b,c)
end
function i.dp_battery_voltage(k,b,c)
return f(k,"battery_voltage",100,b,c)
end
function i.dp_meter_id(k,b,c)
local a=d(b,c,"meter_id")if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=n.raw_identifier()
end
return i.dp_raw(k,a)
end
function i.dp_water_meter_faults(k,b,c)
local a=d(b,c,"faults")if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=n.water_meter_faults()
end
return i.dp_numeric(k,a)
end
function i.dp_alarm(k,b,c)
return i.dp_binary(k,d(b,c,"alarm"))
end
function i.dp_co2(k,b,c)
return f(k,"co2",1,b,c)
end
function i.dp_voc(k,b,c)
return f(k,"voc",1,b,c)
end
function i.dp_pm25(k,b,c)
return f(k,"pm25",1,b,c)
end
function i.dp_formaldehyde(k,b,c)
return f(k,"formaldehyde",1,b,c)
end
end
return at
