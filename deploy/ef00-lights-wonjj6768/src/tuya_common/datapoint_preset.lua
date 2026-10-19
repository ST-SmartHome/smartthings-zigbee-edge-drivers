local function av(m,aI,bA)
bA=bA or{switch=function()return nil end}
local e=aI.type_check
local N=aI.table_insert
local aY=aI.tonumber_check
local n=aI.merge_options
local bt=aI.copy_keys
local l=m.converter
local function as(aa,K)
if e(aa)~="table"or e(K)~="table"then
return aa
end
for au,R in pairs(K)do
if aa[au]==nil then
aa[au]=R
end
end
return aa
end
local function d(c,b,h)
local a={}if e(c)=="string"then
a.name=c
else
n(a,c)
end
n(a,b)if a.name==nil and h~=nil then
a.name=h
end
return a
end
local ap={
"send_policy","command_id","transaction","batch_key","match_transaction","response_dp","response_dps","match_response",}
local function ao(b)
if e(b)~="table"then
return false
end
for _,au in ipairs(ap)do
if b[au]~=nil then
return true
end
end
return false
end
local function g(bo,b)
if ao(b)then
return bo
end
return m.apply_fixed_send_policy(bo)
end
local function ba(t,h,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=10
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=l.divide_by_pair(w)
end
a.scale=nil
return m.dp_numeric(t,a)
end
local function y(t,h,C,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=C
end
if a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=l.divide_by_pair(w)
end
a.scale=nil
return m.dp_numeric(t,a)
end
local function ae(t,h,C,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=C
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
local ar=l.power()local bl=ar.from
if w~=1 then
a.from_device=l.pipe(
bl,l.divide_by(w))else
a.converter=ar
end
end
a.scale=nil
return m.dp_numeric(t,a)
end
local function bb(t,h,C,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=C
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=l.signed_number_pair(w)
end
if a.signed==nil then
a.signed=true
end
a.scale=nil
return m.dp_numeric(t,a)
end
local function aM(t,h,C,bi,c,b)
local a=d(c,b,h)local w=a.scale
if w==nil then
w=C
end
local bz=
a.datatype==m.DP_TYPE_RAW or
a.raw==true or
a.raw_bytes~=nil or
a.raw_length~=nil or
a.raw_from_tail~=nil or
a.raw_start~=nil or
a.raw_offset~=nil
if bz and a.converter==nil and a.from_device==nil and a.to_device==nil then
local aK={
bytes=a.raw_bytes or a.raw_length,length=a.raw_length,from_tail=a.raw_from_tail,start=a.raw_start,offset=a.raw_offset,}as(aK,bi)a.converter=l.raw_uint_be(w,aK)if a.datatype==nil then
a.datatype=m.DP_TYPE_RAW
end
elseif a.converter==nil and a.from_device==nil and a.to_device==nil and w~=1 then
a.converter=l.divide_by_pair(w)
end
a.scale=nil
a.raw=nil
a.raw_bytes=nil
a.raw_length=nil
a.raw_from_tail=nil
a.raw_start=nil
a.raw_offset=nil
return m.dp_numeric(t,a)
end
local function X(R,bx,bw)
local aH=aY(R)if aH==nil then
return nil
end
return bx+bw-aH
end
local function B(t,h,K,c,b)
local a=d(c,b,h)local ai=a.raw_min
if ai==nil then
ai=K.raw_min
end
local ah=a.raw_max
if ah==nil then
ah=K.raw_max
end
local I=a.value_min
if I==nil then
I=K.value_min
end
local H=a.value_max
if H==nil then
H=K.value_max
end
local bD=a.invert==true or a.invert_position==true
if a.converter==nil and a.from_device==nil and a.to_device==nil then
if bD then
local bq=l.scale(ai,ah,I,H)local bB=l.scale(I,H,ai,ah)a.converter=l.from_to(
function(R,be,aV)
local by=bq(R,be,aV)if by==nil then
return nil
end
return X(by,I,H)
end,
function(R,be,aV)
local bg=X(R,I,H)if bg==nil then
return nil
end
return bB(bg,be,aV)
end
)elseif ai~=I or ah~=H then
a.converter=l.scale_pair(ai,ah,I,H)
end
end
a.raw_min=nil
a.raw_max=nil
a.value_min=nil
a.value_max=nil
a.invert=nil
a.invert_position=nil
return m.dp_numeric(t,a)
end
local function bs(phase,bf)
if e(phase)=="string"and phase~=""then
return(bf or"phase").."_"..phase
end
return bf or"phase"
end
local function bh(bF,phase)
local bv={}for _,au in ipairs(bF or{})do
local aO=au
if e(phase)=="string"and phase~=""then
aO=au.."_"..phase
end
bv[aO]=true
end
return bv
end
local function bj(t,h,aX,bp,c,b)
local bd=
e(c)=="string"or
(e(c)=="table"and c.name~=nil)or
(e(b)=="table"and b.name~=nil)local a=d(c,b,h)local phase=a.phase
if not bd and a.name==h then
a.name=bs(phase,h)
end
if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=aX(a)
end
if a.field==nil and a.fields==nil then
a.fields=bh(bp,phase)
end
return m.dp_raw(t,a)
end
local function bk(t,c,b)
local a=d(c,b,"threshold")if a.read_only==nil then
a.read_only=true
end
if a.converter==nil and a.from_device==nil and a.to_device==nil then
a.converter=l.threshold_parser()
end
if a.field==nil and a.fields==nil then
a.fields={
threshold_1=true,threshold_1_protection=true,threshold_1_value=true,threshold_2=true,threshold_2_protection=true,threshold_2_value=true,}
end
return m.dp_raw(t,a)
end
local function aq(q)
if e(q)=="number"and q%1==0 and q>=0 then
return{q}
end
if e(q)~="table"then
return{}
end
local aP={}for _,t in ipairs(q)do
if e(t)=="number"and t%1==0 and t>=0 then
N(aP,t)
end
end
return aP
end
local function ac(b)
if e(b)~="table"then
return b
end
local q=b.dps
if q==nil then
q=b.dp_list
end
if q==nil and b[1]~=nil then
q=b
end
return q
end
local function ag(b)
local q=ac(b)if q~=nil then
return q
end
if e(b)~="table"then
return b
end
return b.dp
end
local function aQ(A,b)
b=b or{}local aR=b.phases
if e(aR)~="table"then
aR=b.phase_names
end
local phase=e(aR)=="table"and aR[A]or nil
if e(phase)=="string"and phase~=""then
return phase
end
local F=b.phase_prefix
if F==false then
return nil
end
if e(F)~="string"or F==""then
F=nil
end
if F~=nil then
return F..tostring(A)
end
return tostring(A)
end
local function ak(A,b)
b=b or{}local L=b.first_is_main~=false
local J=b.component_prefix
if e(J)~="string"or J==""then
J="switch"
end
local Q=b.main_component
if e(Q)~="string"or Q==""then
Q="main"
end
local s=b.index_offset
if e(s)~="number"or s%1~=0 then
s=0
end
if A==1 and L then
return Q
end
local suffix=L and(A-1+s)or(A+s)if suffix<1 then
return b.default_component
end
return J..tostring(suffix)
end
local function aF(A,b,aW)
b=b or{}local L=b.first_is_main~=false
local Y=b.key_prefix
if e(Y)~="string"or Y==""then
Y=aW or"switch"
end
local az=b.main_key
if e(az)~="string"or az==""then
az=Y
end
local s=b.index_offset
if e(s)~="number"or s%1~=0 then
s=0
end
if A==1 and L then
return az
end
local suffix=L and(A-1+s)or(A+s)if suffix<1 then
return b.default_key
end
return Y..tostring(suffix)
end
local function T(i,t,z,b)
if e(t)~="number"or t%1~=0 or t<0 then
return
end
N(i,z(t,b))
end
local function ad(aa,bC)
if e(bC)~="table"then
return aa
end
for _,bE in ipairs(bC)do
N(aa,bE)
end
return aa
end
local an={
"first_is_main","main_component","component_prefix","index_offset","default_component","key_prefix","main_key","default_key",}
local function aE(R)
return e(R)=="number"and R%1==0 and R>0
end
local function r(b,j)
local a={}if e(b)~="table"then
return a
end
for au,R in pairs(b)do
local aL=true
if not j then
if au=="dp"or au=="dps"or au=="dp_list"then
aL=false
elseif aE(au)then
aL=false
end
end
if aL then
a[au]=R
end
end
return a
end
local function af(b)
if e(b)~="table"then
return false
end
if b.dp~=nil or b.dps~=nil or b.dp_list~=nil or b[1]~=nil then
return true
end
return false
end
local function G(b)
if e(b)~="table"then
return b
end
b.dp=nil
b.dps=nil
b.dp_list=nil
local A=1
while b[A]~=nil do
b[A]=nil
A=A+1
end
return b
end
local function v(b,k,j)
if e(b)~="table"then
return{}
end
local u=b[k]if u==nil then
return r(b,j)
end
local a=r(b,j)if e(u)=="table"then
n(a,u)else
a.dp=u
end
return a
end
local function x(u)
if u==nil then
return nil
end
if e(u)=="table"then
return u
end
return{dp=u}
end
local function W(b,k)
if e(b)~="table"then
return nil
end
return x(b[k])
end
local function aA(aw,f)
local M=e(aw)=="table"and aw.item_options or nil
local E=e(f)=="table"and f.item_options or nil
if e(M)~="table"then
return e(E)=="table"and E or nil
end
if e(E)~="table"then
return M
end
local a={}n(a,M)n(a,E)return a
end
local function aj(b,k,D,j)
local a={}local u=nil
if e(b)=="table"then
bt(a,b,an)u=b[k]if e(u)=="table"then
n(a,r(b,j))if j and af(u)then
G(a)
end
n(a,u)elseif u~=nil then
n(a,r(b,j))if j then
G(a)
end
a.dp=u
else
n(a,r(b,j))
end
end
if a.key_prefix==nil and D~=nil then
a.key_prefix=D
end
a.item_options=aA(b,u)return a
end
local function O(b,p)
local o={}local at=W(b,"config")n(o,at)local aC=x(o[p])if aC~=nil then
o[p]=aC
else
local Z=x(o.switch_type)if Z==nil then
Z=W(b,"switch_type")
end
if e(Z)=="table"then
o[p]=Z
end
end
if p~="switch_type"then
o.switch_type=nil
end
if next(o)~=nil then
return o
end
return{}
end
local function P(b,p)
local a={}if e(b)=="table"then
n(a,b)
end
local o=O(b,p)if next(o)~=nil then
a.config=o
end
a.switch_type=nil
return a
end
local function bc(b,p)
local a={}if e(b)=="table"then
n(a,b)
end
local V=P(
v(b,"switch_module"),p)if next(V)~=nil then
a.switch_module=V
end
return a
end
local function aD(i,b,k,z)
local f=v(b,k)T(i,f.dp,z,f)
end
local function aJ(i,b,k,z,K)
local f=v(b,k)as(f,K)T(i,f.dp,z,f)
end
local function aZ(i,b,k,z,aG)
local f=v(b,k)local q=ac(f)if q~=nil and aG~=nil then
ad(i,aG(q,f))return
end
T(i,f.dp,z,f)
end
local function aS(i,b,k,D,z)
local f=aj(b,k,D)ad(i,z(ag(f),f))
end
local function bn(q,z,h,b)
local i={}local am=aq(q)local al=e(b)=="table"and b.item_options or nil
for A,t in ipairs(am)do
local a=d(al,nil,h)if a.component==nil then
a.component=ak(A,b)
end
if a.key==nil and a.preference==nil then
a.key=aF(A,b,h)
end
if a.field==nil and a.fields==nil and a.key~=nil then
a.field=a.key
end
N(i,z(t,a))
end
return i
end
local function aU(q,z,b)
local i={}local am=aq(q)local al=e(b)=="table"and b.item_options or nil
for A,t in ipairs(am)do
local a=d(al,nil,nil)if a.phase==nil then
a.phase=aQ(A,b)
end
N(i,z(t,a))
end
return i
end
local function ab(b,k,z)
local f=nil
if e(b)=="table"then
f=v(b,k,true)else
f={dp=b}
end
local i={}T(i,f.dp,z,f)return i
end
function m.dp_on_off(t,c,b)
local a=d(c,b,"switch")if a.name=="switch"and a.emit==nil then
a.emit=bA.switch()
end
return m.dp_binary(t,a)
end
function m.dp_child_lock(t,c,b)
return m.dp_binary(t,d(c,b,"child_lock"))
end
function m.dp_brightness(t,c,b)
return m.dp_light(t,d(c,b,"brightness"))
end
function m.dp_voltage(t,c,b)
return y(t,"voltage",10,c,b)
end
function m.dp_current(t,c,b)
return y(t,"current",1000,c,b)
end
function m.dp_power(t,c,b)
return ae(t,"power",10,c,b)
end
function m.dp_power_on_behavior(t,c,b)
local a=d(c,b,"power_on_behavior")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=l.power_on_behavior()
end
return g(m.dp_enum(t,a),a)
end
function m.dp_switch_type(t,c,b)
local a=d(c,b,"switch_type")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=l.switch_type()
end
return g(m.dp_enum(t,a),a)
end
function m.dp_switch_mode(t,c,b)
local a=d(c,b,"switch_mode")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=l.switch_mode()
end
return g(m.dp_enum(t,a),a)
end
function m.dp_backlight_mode(t,c,b)
local a=d(c,b,"backlight_mode")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=l.backlight_mode_off_normal_inverted()
end
return g(m.dp_enum(t,a),a)
end
function m.dp_backlight_mode_off_on(t,c,b)
local a=d(c,b,"backlight_mode")return g(m.dp_binary(t,a),a)
end
function m.dp_indicator_mode(t,c,b)
local a=d(c,b,"indicator_mode")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=l.indicator_mode()
end
return g(m.dp_enum(t,a),a)
end
function m.dp_indicator_mode_none_relay_pos(t,c,b)
local a=d(c,b,"indicator_mode")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=l.indicator_mode_none_relay_pos()
end
return g(m.dp_enum(t,a),a)
end
function m.dp_color_temperature(t,c,b)
return B(
t,"color_temperature",{raw_min=0,raw_max=1000,value_min=0,value_max=100},c,b)
end
function m.dp_fan_mode(t,c,b)
return m.dp_enum(t,d(c,b,"fan_mode"))
end
function m.dp_countdown(t,c,b)
return y(t,"countdown",1,c,b)
end
function m.dp_light_type(t,c,b)
local a=d(c,b,"light_type")if a.converter==nil and a.from_device==nil and a.to_device==nil and a.lookup==nil then
a.converter=l.light_type()
end
return g(m.dp_enum(t,a),a)
end
function m.dp_min_brightness(t,c,b)
return B(
t,"min_brightness",{raw_min=0,raw_max=1000,value_min=0,value_max=100},c,b)
end
function m.dp_max_brightness(t,c,b)
return B(
t,"max_brightness",{raw_min=0,raw_max=1000,value_min=0,value_max=100},c,b)
end
local aB={
{"switch","switch","on_off"},"temperature","humidity","battery","battery_state",{"battery_state_low_medium_high","battery_state"},"contact","occupancy","illuminance","temperature_unit","child_lock","power_on_behavior","power_outage_memory","switch_type","switch_type_button","switch_type_curtain","switch_mode","backlight_mode","backlight_mode_low_medium_high","backlight_mode_off_on","indicator_mode","indicator_mode_none_relay_pos","brightness","action","countdown","voltage","current","power","energy","ac_frequency","phase_variant1","phase_variant2","phase_variant3","threshold","color_temperature","color_hue","color_saturation","color_data","cover_position","local_temperature","current_heating_setpoint","occupied_heating_setpoint","occupied_cooling_setpoint","local_temperature_calibration","open_window_temperature","comfort_temperature","eco_temperature","holiday_temperature","max_temperature_limit","min_temperature_limit","deadzone_temperature","inlet_water_temperature","outlet_water_temperature","open_window_time","system_mode","running_state","fan_mode","fan_speed","frost_protection","window_detection","open_window","window_open","boost_heating","scale_protection","eco_mode","valve_state",{"valve_state_unknown_open_closed","valve_state"},"temperature_sensor_select",{"temperature_sensor_select_internal_external_both","temperature_sensor_select"},"temperature_calibration","humidity_calibration","max_temperature_alarm","min_temperature_alarm","max_humidity_alarm","min_humidity_alarm","temperature_alarm","humidity_alarm","soil_moisture","soil_calibration","temperature_sampling","report_interval","soil_sampling","soil_warning","illuminance_calibration","water_warning","soil_fertility","soil_fertility_calibration","soil_fertility_warning_setting","soil_fertility_warning","water_consumed","reverse_water_consumed","month_consumption","daily_consumption","flow_rate","instantaneous_flow_rate","cumulative_heat","battery_voltage","meter_id",{"water_meter_faults","faults"},{"water_meter_report_period","report_period"},"gas","gas_value","smoke","smoke_concentration","self_test_result",{"self_test_state","self_test"},"fault_alarm","silence","alarm_time","alarm_volume","alarm_ringtone","preheat","alarm_switch","device_fault","gas_fault_status","tamper","battery_low",{"pir_sensitivity","sensitivity"},"hold_time","keep_time","alarm","presence","motion_state","indicator","fading_time","illuminance_interval","static_detection_distance","static_detection_sensitivity","motion_detection_mode","motion_detection_sensitivity","target_distance","carbon_monoxide","co","co2","voc","pm25","formaldehyde","boost_time","boost_timeset_countdown","light_type","light_mode","motor_direction","error_status","water_leak",{"switch_mode_curtain","switch_mode"},"color_power_on_behavior","power_factor","min_brightness","max_brightness",}for _,ay in ipairs(aB)do
local suffix,br,dp_suffix
if e(ay)=="string"then
suffix,br,dp_suffix=ay,ay,ay
else
suffix=ay[1]br=ay[2]or suffix
dp_suffix=ay[3]or suffix
end
m["build_"..suffix.."_datapoints"]=function(b)
return ab(b,br,m["dp_"..dp_suffix])
end
end
local ax={
temperature="dp_temperature",humidity="dp_humidity",battery="dp_battery",battery_state="dp_battery_state",contact="dp_contact",illuminance="dp_illuminance",temperature_unit="dp_temperature_unit",temperature_calibration="dp_temperature_calibration",humidity_calibration="dp_humidity_calibration",max_temperature_alarm="dp_max_temperature_alarm",min_temperature_alarm="dp_min_temperature_alarm",max_humidity_alarm="dp_max_humidity_alarm",min_humidity_alarm="dp_min_humidity_alarm",temperature_alarm="dp_temperature_alarm",humidity_alarm="dp_humidity_alarm",soil_moisture="dp_soil_moisture",soil_calibration="dp_soil_calibration",temperature_sampling="dp_temperature_sampling",report_interval="dp_report_interval",soil_sampling="dp_soil_sampling",soil_warning="dp_soil_warning",illuminance_calibration="dp_illuminance_calibration",water_warning="dp_water_warning",soil_fertility="dp_soil_fertility",soil_fertility_calibration="dp_soil_fertility_calibration",soil_fertility_warning_setting="dp_soil_fertility_warning_setting",soil_fertility_warning="dp_soil_fertility_warning",}
local function aT(b,bm)
b=b or{}local i={}for _,k in ipairs(bm or{})do
local aN=ax[k]if aN~=nil then
aD(i,b,k,m[aN])
end
end
return i
end
end
return av
