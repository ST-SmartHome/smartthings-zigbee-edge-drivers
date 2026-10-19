local a={}local H={"off","on","s","toggle","previous","restore","state","momentary","powerOnBehavior","switchType","off_on","on_off","DISABLE","ENABLE","indicatorMode","V","off/on","on/off","powerOutageMemory","power_poll_interval","temperature_threshold","power_threshold","over_voltage_threshold","countdownOne","countdownTwo","countdownTimerZclTwelveHours","temperature_breaker","power_breaker","over_current_breaker","over_voltage_breaker","under_voltage_breaker","indicator_mode","power_on_behavior","power_outage_memory","switch_type","childLock","C","temperatureThreshold","kW","powerThreshold","overVoltageThreshold","ts0003Module2CountdownOne","ts0003Module2CountdownTwo","ts0003Module2CountdownThree","countdownThree","nfzb03CountdownOne","nfzb03CountdownTwo","nfzb03CountdownThree","nfzb03InchingTimeOne","nfzb03InchingTimeTwo","nfzb03InchingTimeThree","A","ts011fDinOverCurrentThreshold","ts011fDinUnderVoltageThreshold","min","haozeeHzWt02WaterCountdown","easyiotSp1000PlayVoice","easyiotSp1000Volume","sonoffZbminir2DelayPowerTime","sonoffZbminir2InchingTime","nousB3zCountdown1","nousB3zCountdown2","temperatureBreaker","powerBreaker","overCurrentBreaker","overVoltageBreaker","underVoltageBreaker","ts0001BbebPowerOnBehavior","ts0001BbebBacklightMode","backlightMode","ts0001BbebIndicatorPattern","ts0003Module2SwitchType","ts0003Module2IndicatorMode","nfzb03PowerOutageMemory","nfzb03SwitchType","nfzb03IndicatorMode","nfzb03BacklightMode","nfzb03InchingControlOne","nfzb03InchingControlTwo","nfzb03InchingControlThree","lellkiWp33PowerOnBehavior","candeoSm30PowerBehavior","ts011fDinIndicatorMode","sonoffZbminir2NetworkIndicator","sonoffZbminir2TurboMode","sonoffZbminir2DelayPowerState","sonoffZbminir2DetachRelayMode","sonoffZbminir2ExtTriggerMode","edge","pulse","following_off","following_on","sonoffZbminir2InchingControl","sonoffZbminir2InchingMode","sonoffZbminir2PowerOnBehavior","lyaiRainState","rain","no_rain","lyaiRainEnabled","lyaiChargeState","no_charge","charging","charged","ts0002RuxSwitchType","ts0002RuxPowerOutageMemory","nousB3zPowerBehavior","powerBehavior","nousB3zSwitchType","spp04PowerBehavior","lastPowerResponseTime","easyiotSp1000Status"}
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
a.numeric=z({{20,20,"powerPollIntervalV2","powerPollInterval","powerPollIntervalRange",nil,nil,20,"Power poll interval",{5,3600,5,3,nil,1},5,3600,3},{21,21,38,38,"temperatureThresholdRange",nil,nil,21,"Temperature threshold",{40,100,1,37,nil,2},40,100,37},{22,22,40,40,"powerThresholdRange",nil,nil,22,"Power threshold",{1,26,1,39,nil,3},1,26,39},{23,23,41,41,"overVoltageThresholdRange",nil,nil,23,"Over voltage threshold",{220,265,1,16,nil,4},220,265,16},{42,nil,42,24,nil,nil,nil,"ts0003_module2_countdown_one","Ts0003Module2Countdown One",{0,43200,1,3,nil,5},nil,nil,3},{43,nil,43,25,nil,nil,nil,"ts0003_module2_countdown_two","Ts0003Module2Countdown Two",{0,43200,1,3,nil,6},nil,nil,3},{44,nil,44,45,nil,nil,nil,"ts0003_module2_countdown_three","Ts0003Module2Countdown Three",{0,43200,1,3,nil,7},nil,nil,3},{46,nil,46,24,nil,nil,nil,"nfzb03_countdown_one","Nfzb03Countdown One",{0,43200,1,3,nil,8},nil,nil,3},{47,nil,47,25,nil,nil,nil,"nfzb03_countdown_two","Nfzb03Countdown Two",{0,43200,1,3,nil,9},nil,nil,3},{48,nil,48,45,nil,nil,nil,"nfzb03_countdown_three","Nfzb03Countdown Three",{0,43200,1,3,nil,10},nil,nil,3},{49,nil,49,"inchingTimeOne",nil,nil,nil,"nfzb03_inching_time_one","Nfzb03Inching Time One",{1,65535,1,3,nil,11},nil,nil,3},{50,nil,50,"inchingTimeTwo",nil,nil,nil,"nfzb03_inching_time_two","Nfzb03Inching Time Two",{1,65535,1,3,nil,12},nil,nil,3},{51,nil,51,"inchingTimeThree",nil,nil,nil,"nfzb03_inching_time_three","Nfzb03Inching Time Three",{1,65535,1,3,nil,13},nil,nil,3},{53,nil,53,"overCurrentThreshold",nil,nil,nil,"ts011f_din_over_current_threshold","Ts011f Din Over Current Threshold",{1,65,1,52,nil,14},nil,nil,52},{54,nil,54,"underVoltageThreshold",nil,nil,nil,"ts011f_din_under_voltage_threshold","Ts011f Din Under Voltage Threshold",{75,240,1,16,nil,15},nil,nil,16},{56,nil,56,"waterCountdown",nil,nil,nil,"haozee_hz_wt02_water_countdown","Haozee Hz Wt02Water Countdown",{1,1440,1,55,nil,16},nil,nil,55},{57,nil,57,"playVoice",nil,nil,nil,"easyiot_sp1000_play_voice","Easyiot Sp1000Play Voice",{1,999,1,nil,nil,17}},{58,nil,58,"volume",nil,nil,nil,"easyiot_sp1000_volume","Easyiot Sp1000Volume",{1,30,1,nil,nil,18}},{59,nil,59,"delayedPowerOnTime",nil,nil,nil,"sonoff_zbmini_r2_delayed_power_on_time","Sonoff Zbminir2Delay Power Time",{0.5,3599.5,0.5,3,nil,19},nil,nil,3},{60,nil,60,"inchingTime",nil,nil,nil,"sonoff_zbmini_r2_inching_time","Sonoff Zbminir2Inching Time",{0.5,3599.5,0.5,3,nil,20},nil,nil,3},{26,nil,26,26,nil,nil,nil,"countdown_timer","Countdown Timer Zcl Twelve Hours",{0,43200,1,3,nil,21},nil,nil,3},{61,nil,61,24,nil,nil,nil,"nous_b3z_countdown1","Nous B3z Countdown1",{0,43200,1,3,nil,22},nil,nil,3},{62,nil,62,25,nil,nil,nil,"nous_b3z_countdown2","Nous B3z Countdown2",{0,43200,1,3,nil,23},nil,nil,3}},G)a.enum=z({{27,27,63,63,"supportedTemperatureBreakers",nil,nil,27,"Temperature breaker",{2,1},{2,1},24,25,24},{28,28,64,64,"supportedPowerBreakers",nil,nil,28,"Power breaker",{2,1},{2,1},24,26,24},{29,29,65,65,"supportedOverCurrentBreakers",nil,nil,29,"Over current breaker",{2,1},{2,1},24,27,24},{30,30,66,66,"supportedOverVoltageBreakers",nil,nil,30,"Over voltage breaker",{2,1},{2,1},24,28,24},{31,31,67,67,"supportedUnderVoltageBreakers",nil,nil,31,"Under voltage breaker",{2,1},{2,1},24,29,24},{32,32,15,15,"supportedIndicatorModes",nil,nil,32,"Indicator mode",{1,17,18,2},{1,17,18,2},30,31,30},{33,33,9,9,"supportedPowerOnBehaviors",nil,nil,33,"Power on behavior",{1,2,5},{1,2,5},32,33,32},{34,34,19,19,"supportedPowerOutageMemories",nil,nil,34,"Power outage memory",{1,2,6},{1,2,6},34,35,34},{35,35,10,10,"supportedSwitchTypes",nil,nil,35,"Switch type",{4,7,8},{4,7,8},36,37,36},{68,nil,68,9,nil,nil,nil,"ts0001_bbeb_power_on_behavior","Ts0001Bbeb Power On Behavior",{1,2,5},{1,2,5},38,39,38},{69,nil,69,70,nil,nil,nil,"ts0001_bbeb_backlight_mode","Ts0001Bbeb Backlight Mode",{1,2},{1,2},40,41,40},{71,nil,71,"indicatorPattern",nil,nil,nil,"ts0001_bbeb_indicator_mode","Ts0001Bbeb Indicator Pattern",{1,17,18,2},{1,17,18,2},42,43,42},{72,nil,72,10,nil,nil,nil,"ts0003_module2_switch_type","Ts0003Module2Switch Type",{4,7,8},{4,7,8},44,45,44},{73,nil,73,15,nil,nil,nil,"ts0003_module2_indicator_mode","Ts0003Module2Indicator Mode",{1,11,12,2},{1,11,12,2},46,47,46},{74,nil,74,19,nil,nil,nil,"nfzb03_power_outage_memory","Nfzb03Power Outage Memory",{1,2,6},{1,2,6},48,49,48},{75,nil,75,10,nil,nil,nil,"nfzb03_switch_type","Nfzb03Switch Type",{4,7,8},{4,7,8},50,51,50},{76,nil,76,15,nil,nil,nil,"nfzb03_indicator_mode","Nfzb03Indicator Mode",{1,11,12,2},{1,11,12,2},52,53,52},{77,nil,77,70,nil,nil,nil,"nfzb03_backlight_mode","Nfzb03Backlight Mode",{1,2},{1,2},54,55,54},{78,nil,78,"inchingControlOne",nil,nil,nil,"nfzb03_inching_enabled_one","Nfzb03Inching Control One",{13,14},{13,14},56,57,56},{79,nil,79,"inchingControlTwo",nil,nil,nil,"nfzb03_inching_enabled_two","Nfzb03Inching Control Two",{13,14},{13,14},58,59,58},{80,nil,80,"inchingControlThree",nil,nil,nil,"nfzb03_inching_enabled_three","Nfzb03Inching Control Three",{13,14},{13,14},60,61,60},{81,nil,81,9,nil,nil,nil,"lellki_wp33_power_on_behavior","Lellki Wp33Power On Behavior",{1,2,5},{1,2,5},62,63,62},{82,nil,82,9,nil,nil,nil,"candeo_sm30_power_on_behavior","Candeo Sm30Power Behavior",{1,2,5},{1,2,5},64,65,64},{83,nil,83,15,nil,nil,nil,"ts011f_din_indicator_mode","Ts011f Din Indicator Mode",{1,11,12},{1,11,12},66,67,66},{84,nil,84,"networkIndicator",nil,nil,nil,"sonoff_zbmini_r2_network_indicator","Sonoff Zbminir2Network Indicator",{1,2},{1,2},68,69,68},{85,nil,85,"turboMode",nil,nil,nil,"sonoff_zbmini_r2_turbo_mode","Sonoff Zbminir2Turbo Mode",{1,2},{1,2},70,71,70},{86,nil,86,"delayedPowerOnState",nil,nil,nil,"sonoff_zbmini_r2_delayed_power_on_state","Sonoff Zbminir2Delay Power State",{1,2},{1,2},72,73,72},{87,nil,87,"detachRelayMode",nil,nil,nil,"sonoff_zbmini_r2_detach_relay_mode","Sonoff Zbminir2Detach Relay Mode",{1,2},{1,2},74,75,74},{88,nil,88,"externalTriggerMode",nil,nil,nil,"sonoff_zbmini_r2_external_trigger_mode","Sonoff Zbminir2Ext Trigger Mode",{89,90,91,92},{89,90,91,92},76,77,76},{93,nil,93,"inchingControl",nil,nil,nil,"sonoff_zbmini_r2_inching_control","Sonoff Zbminir2Inching Control",{1,2},{1,2},78,79,78},{94,nil,94,"inchingMode",nil,nil,nil,"sonoff_zbmini_r2_inching_mode","Sonoff Zbminir2Inching Mode",{1,2},{1,2},80,81,80},{95,nil,95,9,nil,nil,nil,"sonoff_zbmini_r2_power_on_behavior","Sonoff Zbminir2Power On Behavior",{1,2,4,5},{1,2,4,5},82,83,82},{36,nil,36,36,nil,nil,nil,"child_lock","Child Lock",{1,2},{1,2},84,85,84},{96,nil,96,"rainState",nil,0,0,"lyai_rain_state","Lyai Rain State",{97,98},{97,98},86,87,86},{99,nil,99,"rainEnabled",nil,nil,nil,"lyai_rain_enabled","Lyai Rain Enabled",{2,1},{2,1},88,89,88},{100,nil,100,"chargeState",nil,0,0,"lyai_charge_state","Lyai Charge State",{101,102,103},{101,102,103},90,91,90},{104,nil,104,10,nil,nil,nil,"ts0002_rux_switch_type","Ts0002Rux Switch Type",{4,7,8},{4,7,8},92,93,92},{105,nil,105,19,nil,nil,nil,"ts0002_rux_power_outage_memory","Ts0002Rux Power Outage Memory",{1,2,6},{1,2,6},94,95,94},{106,nil,106,107,nil,nil,nil,"nous_b3z_power_behavior","Nous B3z Power Behavior",{1,2,6},{1,2,6},96,97,96},{108,nil,108,10,nil,nil,nil,"nous_b3z_switch_type","Nous B3z Switch Type",{4,7,8},{4,7,8},98,99,98},{109,nil,109,107,nil,nil,nil,"spp04_power_behavior","Spp04Power Behavior",{1,2,6},{1,2,6},100,101,100}},K)a.text=z({{"last_power_response_time",110,110,0,0,nil,"Last power response time",64},{111,111,"status",0,0,"easyiot_sp1000_status","Easyiot Sp1000Status",16}},M)a.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
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
