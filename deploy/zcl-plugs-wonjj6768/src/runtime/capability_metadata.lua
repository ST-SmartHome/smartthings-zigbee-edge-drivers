local a={}local H={"off","on","s","childLock","indicatorMode","restore","off_on","on_off","release","press","power_poll_interval","countdownTimerZclTwelveHours","indicator_mode","power_outage_memory","powerOutageMemory","identify","ts011fPlug1Countdown","countdown","bacchusPumpDuration","nousA11zCountdown","off/on","on/off","ts011fPlug1PowerOutageMemory","ts011fPlug1IndicatorMode","ts011fPlug1ChildLock","ts011fPlug1SwitchTypeButton","bacchusBeeperOnLeak","bacchusTankFull","normal","full","nousA11zPowerBehavior","previous","nousA11zIndicatorMode","nousA11zChildLock","nousA11zSwitchType","nousA11zIdentify","lastPowerResponseTime"}
local function b(g)
if type(g)=="number"then return H[g]end
return g
end
local function p(g)local suffix=b(g);if suffix==nil then return nil end;return"concertmirror08464."..suffix end
local t={}
local function q(k)
if type(k)~="number"then return{}end
local x=t[k]
if x~=nil then return x end
local n={}t[k]=n
return n
end
local function s(D,k)
if type(D)~="table"then return nil end
local n=q(k)
for A,g in ipairs(D)do n[A]=b(g)end
return n
end
local function i(g,E)
if g==nil then return E end
if g==0 then return nil end
return b(g)
end
local function m(attribute_name)
if type(attribute_name)~="string"or attribute_name==""then return nil end
return"set"..attribute_name:sub(1,1):upper()..attribute_name:sub(2)
end
local function J(g)
if type(g)~="table"then return nil end
local n=q(g[6])n.minimum=g[1]n.maximum=g[2]n.step=g[3]n.unit=b(g[4])n.allowed_values=s(g[5],g[7])return n
end
local function w(j,k)
if j==nil and k==nil then return nil end
local n=q(k)n.allowed_values=j
return n
end
local function G(f)
local attribute_name=b(f[4])return{kind="numeric",emit_name=b(f[1]),range_key=b(f[2]),capability_id=p(f[3]),attribute_name=attribute_name,range_attribute_name=b(f[5]),command_name=i(f[6],m(attribute_name)),argument_name=i(f[7],attribute_name),mapping_name=b(f[8]),label=b(f[9]),default_range=J(f[10]),event_minimum=f[11],event_maximum=f[12],event_unit=b(f[13])}
end
local function K(f)
local attribute_name=b(f[4])local u=s(f[10],f[12])local r=s(f[11],f[14])local d=w(r,f[13])return{kind="enum",emit_name=b(f[1]),range_key=b(f[2]),capability_id=p(f[3]),attribute_name=attribute_name,supported_attribute_name=b(f[5]),command_name=i(f[6],m(attribute_name)),argument_name=i(f[7],attribute_name),mapping_name=b(f[8]),label=b(f[9]),supported_values=u,default_range=d}
end
local function M(f)
local attribute_name=b(f[3])return{kind="text",emit_name=b(f[1]),capability_id=p(f[2]),attribute_name=attribute_name,command_name=i(f[4],m(attribute_name)),argument_name=i(f[5],attribute_name),mapping_name=b(f[6]),label=b(f[7]),maximum_length=f[8]}
end
local function z(L,F)
local n={}
for _,f in ipairs(L)do n[#n+1]=F(f)end
return n
end
a.numeric=z({{11,11,"powerPollIntervalV2","powerPollInterval","powerPollIntervalRange",nil,nil,11,"Power poll interval",{5,3600,5,3,nil,1},5,3600,3},{17,nil,17,18,nil,nil,nil,"ts011f_plug1_countdown","Ts011f Plug1Countdown",{0,43200,1,3,nil,2},nil,nil,3},{19,nil,19,"pumpDuration",nil,nil,nil,"bacchus_pump_duration","Bacchus Pump Duration",{0,600,1,3,nil,3},nil,nil,3},{20,nil,20,18,nil,nil,nil,"nous_a11z_countdown","Nous A11z Countdown",{0,43200,1,3,nil,4},nil,nil,3},{12,nil,12,12,nil,nil,nil,"countdown_timer","Countdown Timer Zcl Twelve Hours",{0,43200,1,3,nil,5},nil,nil,3}},G)a.enum=z({{13,13,5,5,"supportedIndicatorModes",nil,nil,13,"Indicator mode",{1,21,22,2},{1,21,22,2},6,7,6},{14,14,15,15,"supportedPowerOutageMemories",nil,nil,14,"Power outage memory",{1,2,6},{1,2,6},8,9,8},{23,nil,23,15,nil,nil,nil,"ts011f_plug1_power_outage_memory","Ts011f Plug1Power Outage Memory",{1,2,6},{1,2,6},10,11,10},{24,nil,24,5,nil,nil,nil,"ts011f_plug1_indicator_mode","Ts011f Plug1Indicator Mode",{1,7,8,2},{1,7,8,2},12,13,12},{25,nil,25,4,nil,nil,nil,"ts011f_plug1_child_lock","Ts011f Plug1Child Lock",{1,2},{1,2},14,15,14},{26,nil,26,"switchTypeButton",nil,nil,nil,"ts011f_plug1_switch_type_button","Ts011f Plug1Switch Type Button",{9,10},{9,10},16,17,16},{27,nil,27,"beeperOnLeak",nil,nil,nil,"bacchus_beeper_on_leak","Bacchus Beeper On Leak",{1,2},{1,2},18,19,18},{28,nil,28,"tankFull",nil,0,0,"bacchus_tank_full","Bacchus Tank Full",{29,30},{29,30},20,21,20},{31,nil,31,"powerOnBehavior",nil,nil,nil,"nous_a11z_power_on_behavior","Nous A11z Power Behavior",{1,2,32},{1,2,32},22,23,22},{33,nil,33,5,nil,nil,nil,"nous_a11z_indicator_mode","Nous A11z Indicator Mode",{1,7,8,2},{1,7,8,2},24,25,24},{34,nil,34,4,nil,nil,nil,"nous_a11z_child_lock","Nous A11z Child Lock",{1,2},{1,2},26,27,26},{35,nil,35,"switchType",nil,nil,nil,"nous_a11z_switch_type","Nous A11z Switch Type",{9,10},{9,10},28,29,28},{36,nil,36,16,nil,nil,nil,"nous_a11z_identify","Nous A11z Identify",{16},{16},30,31,30},{4,nil,4,4,nil,nil,nil,"child_lock","Child Lock",{1,2},{1,2},32,33,32}},K)a.text=z({{"last_power_response_time",37,37,0,0,nil,"Last power response time",64}},M)a.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
local function o(y)
for _,e in ipairs(y)do
a.by_emit_name[e.emit_name]=e
if type(e.capability_id)=="string"and e.capability_id~=""then a.by_capability_id[e.capability_id]=e end
if type(e.range_key)=="string"and e.range_key~=""then a.by_range_key[e.range_key]=e end
end
end
o(a.numeric)o(a.enum)o(a.text)a.by_emit_name[a.driver_message.emit_name]=a.driver_message
a.by_capability_id[a.driver_message.capability_id]=a.driver_message
local function l(j)
if type(j)~="table"then return nil end
local B={}
for A,g in ipairs(j)do B[A]=g end
return B
end
function a.resolve_range(v,e)
if type(e)~="table"then return nil end
local d=type(e.default_range)=="table"and e.default_range or nil
local C=type(v)=="table"and v.presence_capability_ranges or nil
local h=type(C)=="table"and C[e.range_key]or nil
if type(h)~="table"then h=d end
if type(h)~="table"then return nil end
return{
minimum=type(h.minimum)=="number"and h.minimum or(d and d.minimum or nil),maximum=type(h.maximum)=="number"and h.maximum or(d and d.maximum or nil),step=type(h.step)=="number"and h.step or(d and d.step or nil),unit=type(h.unit)=="string"and h.unit or(d and d.unit or nil),allowed_values=type(h.allowed_values)=="table"and l(h.allowed_values)or l(d and d.allowed_values or nil),}
end
return a
