local a={}local H={"ON","OFF","low","high","off","on","normal","alarm","medium","mute","min","alarm_sound","alarm_light","alarm_sound_light","middle","s","%LEL","ppm","tone_1","tone_2","tone_3","ring1","ring2","ring3","checking","others","idle","neoAbSixAlarmTime","sensitivity","ringtone","alarmStatus","neoAbSixAlarmState","neoAbSixAlarmSwitch","neoAbSixTamperAlarmSwitch","neoAbSixTamperAlarm","neoAbSixAlarmMelody","neoAbSixAlarmMode","neoAbSixCharging","batteryState","test","neoAbTwoDuration","duration","eFourGasLevel","eFourMaxGasAlarm","eFourMaxCoAlarm","times","aZeroEightAlarmTime","zas01pDuration","hs118zTuyaSensitivity","hs118zTuyaIlluminanceSampling","illuminanceSampling","hs118zSensitivity","hs118zIlluminanceSampling","moesZcHmCo","nousE9WarmingUp","warmingUp","nousE9EndOfLife","endOfLife","nousE13WaterLeakAlarm","clear","detected","nousE13AlarmMode","water_presence","water_absence","nousE13Ringtone","muted","lincukooSzw08AlarmStatus","lincukooSzw08Mode","leakage","shortage","lincukooSzw08Ringtone","alarmRingtone","moesZcHmSelfTestResult","success","failure","moesZcHmSilence","no_alarm","melody_1","melody_2","melody_3","not_charging","charging","tuyaVibrationAlarmStatus","tuyaVibrationSensitivity","tuyaVibrationBatteryState","tuyaVibrationDismissAlarm","DISMISS","tuyaVibrationSilentMode","silentMode","neoAbTwoMelody","melody","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","neoAbTwoVolume","volume","lincukooWFourAlarmStatus","lincukooWFourAlarmSwitch","lincukooWFourBatteryState","lincukooWFourRingtone","nousETwelveWarmingUp","nousETwelveTest","nousETwelveTesting","nousETwelveEndOfLife","nousETwelveBatteryState","eFourSelfChecking","eFourCheckingResult","check_success","check_failure","aZeroEightAlarmState","aZeroEightAlarmVolume","aZeroEightMute","aZeroEightAlarmRingtone","ringtone_1","ringtone_2","ringtone_3","ringtone_4","ringtone_5","ringtone_6","ringtone_7","ringtone_8","ringtone_9","ringtone_10","ringtone_11","ringtone_12","ringtone_13","ringtone_14","ringtone_15","ringtone_16","ringtone_17","ringtone_18","ringtone_19","ringtone_20","ringtone_21","ringtone_22","ringtone_23","ringtone_24","ringtone_25","ringtone_26","ringtone_27","immax07519lSilentMode","immax07519lRingtone","zas01pVolume","zas01pMelody","doorbell","alarm_1","alarm_2","alarm_clock","notification","countdown","emergency_button","fall_detected","equipment_moved","carbon_dioxide","circuit_breaker","door_open","window_open","air_quality","motion_detected","person_detected","camera","vibration","ambient_temperature","target_temperature_reached","heating","water_level_alarm","valve_closed","scheduled_task","door_lock_alarm","smoke_alarm","gas_alarm","low_battery","water_leak_alarm","device_offline","alarm_system_disarmed","alarm_system_armed","zas01pLightMode","breathing","red_flash","white","zsd20SelfCheck","zsd20Muffling","lastPowerResponseTime"}
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
a.numeric=z({{28,nil,28,28,nil,nil,nil,"neo_ab_six_alarm_time","Neo Ab Six Alarm Time",{1,60,1,11,nil,1},nil,nil,11},{41,nil,41,42,nil,nil,nil,"neo_ab_two_duration","Neo Ab Two Duration",{0,1800,1,16,nil,2},nil,nil,16},{43,nil,43,"gasLevel",nil,0,0,"e_four_gas_level","E Four Gas Level",{0,20,nil,17,nil,3},nil,nil,17},{44,nil,44,"maxGasAlarm",nil,nil,nil,"e_four_max_gas_alarm","E Four Max Gas Alarm",{0.1,20,0.1,17,nil,4},nil,nil,17},{45,nil,45,"maxCoAlarm",nil,nil,nil,"e_four_max_co_alarm","E Four Max Co Alarm",{10,1000,10,18,nil,5},nil,nil,18},{47,nil,47,"alarmTime",nil,nil,nil,"a_zero_eight_alarm_time","A Zero Eight Alarm Time",{0,100,1,46,nil,6},nil,nil,46},{48,nil,48,42,nil,nil,nil,"zas01p_duration","Zas01p Duration",{10,1800,1,16,nil,7},nil,nil,16},{49,nil,49,29,nil,nil,nil,"hs118z_tuya_sensitivity","Hs118z Tuya Sensitivity",{0,9,1,nil,nil,8}},{50,nil,50,51,nil,nil,nil,"hs118z_tuya_illuminance_sampling","Hs118z Tuya Illuminance Sampling",{1,480,1,11,nil,9},nil,nil,11},{52,nil,52,29,nil,nil,nil,"hs118z_sensitivity","Hs118z Sensitivity",{0,9,1,nil,nil,10}},{53,nil,53,51,nil,nil,nil,"hs118z_illuminance_sampling","Hs118z Illuminance Sampling",{1,480,1,11,nil,11},nil,nil,11},{54,nil,54,"co",nil,0,0,"moes_zc_hm_co","Moes Zc Hm Co",{nil,nil,nil,18,nil,12},nil,nil,18}},G)a.enum=z({{55,nil,55,56,nil,0,0,"nous_e9_warming_up","Nous E9Warming Up",{5,6},{5,6},13,14,13},{57,nil,57,58,nil,0,0,"nous_e9_end_of_life","Nous E9End Of Life",{5,6},{5,6},15,16,15},{59,nil,59,"waterLeakAlarm",nil,0,0,"nous_e13_water_leak_alarm","Nous E13Water Leak Alarm",{60,61},{60,61},17,18,17},{62,nil,62,"alarmMode",nil,nil,nil,"nous_e13_alarm_mode","Nous E13Alarm Mode",{63,64},{63,64},19,20,19},{65,nil,65,30,nil,nil,nil,"nous_e13_ringtone","Nous E13Ringtone",{66,19,20,21},{66,19,20,21},21,22,21},{67,nil,67,31,nil,0,0,"lincukoo_szw08_alarm_status","Lincukoo Szw08Alarm Status",{7,8},{7,8},23,24,23},{68,nil,68,"mode",nil,nil,nil,"lincukoo_szw08_mode","Lincukoo Szw08Mode",{69,70},{69,70},25,26,25},{71,nil,71,72,nil,nil,nil,"lincukoo_szw08_alarm_ringtone","Lincukoo Szw08Ringtone",{10,22,23,24},{10,22,23,24},27,28,27},{73,nil,73,"selfTestResult",nil,0,0,"moes_zc_hm_self_test_result","Moes Zc Hm Self Test Result",{25,74,75,26},{25,74,75,26},29,30,29},{76,nil,76,"silence",nil,nil,nil,"moes_zc_hm_silence","Moes Zc Hm Silence",{5,6},{5,6},31,32,31},{32,nil,32,32,nil,0,0,"neo_ab_six_alarm_state","Neo Ab Six Alarm State",{12,13,14,77},{12,13,14,77},33,34,33},{33,nil,33,33,nil,nil,nil,"neo_ab_six_alarm_switch","Neo Ab Six Alarm Switch",{1,2},{1,2},35,36,35},{34,nil,34,34,nil,nil,nil,"neo_ab_six_tamper_alarm_switch","Neo Ab Six Tamper Alarm Switch",{1,2},{1,2},37,38,37},{35,nil,35,35,nil,0,0,"neo_ab_six_tamper_alarm","Neo Ab Six Tamper Alarm",{1,2},{1,2},39,40,39},{36,nil,36,36,nil,nil,nil,"neo_ab_six_alarm_melody","Neo Ab Six Alarm Melody",{78,79,80},{78,79,80},41,42,41},{37,nil,37,37,nil,nil,nil,"neo_ab_six_alarm_mode","Neo Ab Six Alarm Mode",{12,13,14},{12,13,14},43,44,43},{38,nil,38,38,nil,0,0,"neo_ab_six_charging","Neo Ab Six Charging",{81,82},{81,82},45,46,45},{83,nil,83,31,nil,0,0,"tuya_vibration_alarm_status","Tuya Vibration Alarm Status",{7,8},{7,8},47,48,47},{84,nil,84,29,nil,nil,nil,"tuya_vibration_sensitivity","Tuya Vibration Sensitivity",{3,15,4},{3,15,4},49,50,49},{85,nil,85,39,nil,0,0,"tuya_vibration_battery_state","Tuya Vibration Battery State",{3,9,4},{3,9,4},51,52,51},{86,nil,86,"dismissAlarm",nil,nil,nil,"tuya_vibration_dismiss_alarm","Tuya Vibration Dismiss Alarm",{27,87},{27,87},53,54,53},{88,nil,88,89,nil,nil,nil,"tuya_vibration_silent_mode","Tuya Vibration Silent Mode",{2,1},{2,1},55,56,55},{90,nil,90,91,nil,nil,nil,"neo_ab_two_melody","Neo Ab Two Melody",{92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109},{92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109},57,58,57},{110,nil,110,111,nil,nil,nil,"neo_ab_two_volume","Neo Ab Two Volume",{3,9,4},{3,9,4},59,60,59},{112,nil,112,31,nil,0,0,"lincukoo_w_four_alarm_status","Lincukoo WFour Alarm Status",{7,8},{7,8},61,62,61},{113,nil,113,"alarmSwitch",nil,nil,nil,"lincukoo_w_four_alarm_switch","Lincukoo WFour Alarm Switch",{10,8},{10,8},63,64,63},{114,nil,114,39,nil,0,0,"lincukoo_w_four_battery_state","Lincukoo WFour Battery State",{3,15,4},{3,15,4},65,66,65},{115,nil,115,30,nil,nil,nil,"lincukoo_w_four_ringtone","Lincukoo WFour Ringtone",{22,23,24},{22,23,24},67,68,67},{116,nil,116,56,nil,0,0,"nous_e_twelve_warming_up","Nous ETwelve Warming Up",{5,6},{5,6},69,70,69},{117,nil,117,40,nil,nil,nil,"nous_e_twelve_test","Nous ETwelve Test",{27,40},{27,40},71,72,71},{118,nil,118,"testing",nil,0,0,"nous_e_twelve_testing","Nous ETwelve Testing",{5,6},{5,6},73,74,73},{119,nil,119,58,nil,0,0,"nous_e_twelve_end_of_life","Nous ETwelve End Of Life",{5,6},{5,6},75,76,75},{120,nil,120,39,nil,0,0,"nous_e_twelve_battery_state","Nous ETwelve Battery State",{3,9,4},{3,9,4},77,78,77},{121,nil,121,"selfChecking",nil,nil,nil,"e_four_self_checking","E Four Self Checking",{1,2},{1,2},79,80,79},{122,nil,122,"checkingResult",nil,0,0,"e_four_checking_result","E Four Checking Result",{25,123,124,26},{25,123,124,26},81,82,81},{125,nil,125,"alarmState",nil,nil,nil,"a_zero_eight_alarm_state","A Zero Eight Alarm State",{12,13,14,7},{12,13,14,7},83,84,83},{126,nil,126,"alarmVolume",nil,nil,nil,"a_zero_eight_alarm_volume","A Zero Eight Alarm Volume",{3,15,4,10},{3,15,4,10},85,86,85},{127,nil,127,10,nil,nil,nil,"a_zero_eight_mute","A Zero Eight Mute",{1,2},{1,2},87,88,87},{128,nil,128,72,nil,nil,nil,"a_zero_eight_alarm_ringtone","A Zero Eight Alarm Ringtone",{129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155},{129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155},89,90,89},{156,nil,156,89,nil,nil,nil,"immax_07519l_silent_mode","Immax07519l Silent Mode",{2,1},{2,1},91,92,91},{157,nil,157,30,nil,nil,nil,"immax_07519l_ringtone","Immax07519l Ringtone",{19,20,21},{19,20,21},93,94,93},{158,nil,158,111,nil,nil,nil,"zas01p_volume","Zas01p Volume",{3,9,4},{3,9,4},95,96,95},{159,nil,159,91,nil,nil,nil,"zas01p_melody","Zas01p Melody",{160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191},{160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191},97,98,97},{192,nil,192,"lightMode",nil,nil,nil,"zas01p_light_mode","Zas01p Light Mode",{193,194,195},{193,194,195},99,100,99},{196,nil,196,"selfCheck",nil,nil,nil,"zsd20_self_check","Zsd20Self Check",{1,2},{1,2},101,102,101},{197,nil,197,"muffling",nil,nil,nil,"zsd20_muffling","Zsd20Muffling",{1,2},{1,2},103,104,103}},K)a.text=z({{"last_power_response_time",198,198,0,0,nil,"Last power response time",64}},M)a.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
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
