local a={}local H={"C","low","%","medium","high","s","mV","30","60","120","sensitivity","off","deviceTemperature","restartCount","m/s","celsius","fahrenheit","clear","keepTime","power_poll_interval","detectionInterval","battery_low","μg/m^3","heimanHs2aqPm10","heimanHs2aqAqi","thirdRths0324CelsiusCal","thirdRths0324HumidityCal","F","thirdRths0324FahrenheitCal","zg9032bTemperatureCompensation","zg9032bHumidityCompensation","°","ws90WindDirection","rbSrain01IlluminanceRaw","rbSrain01IlluminanceAverage20min","rbSrain01IlluminanceMaximumToday","rbSrain01RainIntensity","ecozyLocalTemperatureCalibration","ecozyPiHeatingDemand","miMotionRestarts","aqM11Restarts","aqT1Restarts","aqE1Restarts","aqP1Interval","aqT1Interval","aqE1Interval","aqP1DeviceTemp","aqT1DeviceTemp","aqE1DeviceTemp","aqM11DeviceTemp","lczTempMax","lczTempMin","lczHumidityMax","lczHumidityMin","rpsSensitivity","tsVibrationSensitivity","min","candeoLightInterval","t1HtDeviceTemperature","t1HtPowerOutageCount","shellyWs90WindSpeed","shellyWs90GustSpeed","shellyWs90UvIndex","mm","shellyWs90Precipitation","V","shellyWs90CapacitorVoltage","batteryLow","normal","zg9032bTemperatureDisplayUnit","ws90RainStatus","dry","raining","c3007Pressure","pressure","detected","rbSrain01CleaningReminder","needsCleaning","heimanHs2aqBatteryState","not_charging","charging","charged","ihRtOneSensitivity","ihRtOneKeepTime","ihRtTwoSensitivity","ihRtTwoKeepTime","zm35Sensitivity","zm35KeepTime","aqP1Sensitivity","aqP1Indicator","on","lczTempAlarm","below_min_temperature","over_temperature","lczHumidityAlarm","below_min_humdity","over_humidity","kctwDisplayUnit","rpsCalibration","Press","candeoMotionSensitivity","candeoMotionKeepTime","10","cwamLightState","dark","bright","lastPowerResponseTime","remoteAction"}
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
a.numeric=z({{20,20,"powerPollIntervalV2","powerPollInterval","powerPollIntervalRange",nil,nil,20,"Power poll interval",{5,3600,5,6,nil,1},5,3600,6},{24,nil,24,"pmTen",nil,0,0,"heiman_pmTen","Heiman Hs2aq Pm10",{0,65535,1,23,nil,2},nil,nil,23},{25,nil,25,"aqi",nil,0,0,"heiman_aqi","Heiman Hs2aq Aqi",{0,65535,1,nil,nil,3}},{26,nil,26,"rthsZeroThreeTwoFourCelsiusCal",nil,nil,nil,"third_rths0324_celsius_calibration","Third Rths0324Celsius Cal",{-200,200,1,1,nil,4},nil,nil,1},{27,nil,27,"rthsZeroThreeTwoFourHumidityCal",nil,nil,nil,"third_rths0324_humidity_calibration","Third Rths0324Humidity Cal",{-100,100,1,3,nil,5},nil,nil,3},{29,nil,29,"rthsZeroThreeTwoFourFahrenheitCal",nil,nil,nil,"third_rths0324_fahrenheit_calibration","Third Rths0324Fahrenheit Cal",{-200,200,1,28,nil,6},nil,nil,28},{30,nil,30,"zgNineZeroThreeTwoBTempComp",nil,nil,nil,"zg9032b_temperature_compensation","Zg9032b Temperature Compensation",{-5,5,1,1,nil,7},nil,nil,1},{31,nil,31,"zgNineZeroThreeTwoBHumidityComp",nil,nil,nil,"zg9032b_humidity_compensation","Zg9032b Humidity Compensation",{-5,5,1,3,nil,8},nil,nil,3},{33,nil,33,"wsNinetyWindDirection",nil,0,0,"ws90_wind_direction","Ws90Wind Direction",{0,360,0.1,32,nil,9},nil,nil,32},{34,nil,34,"illuminanceRaw",nil,0,0,"illuminance_raw","Rb Srain01Illuminance Raw",{0,2147483647,1,7,nil,10},nil,nil,7},{35,nil,35,"illuminanceAverageTwentyMin",nil,0,0,"illuminance_average_20min","Rb Srain01Illuminance Average20min",{0,2147483647,1,7,nil,11},nil,nil,7},{36,nil,36,"illuminanceMaximumToday",nil,0,0,"illuminance_maximum_today","Rb Srain01Illuminance Maximum Today",{0,2147483647,1,7,nil,12},nil,nil,7},{37,nil,37,"rainIntensity",nil,0,0,"rain_intensity","Rb Srain01Rain Intensity",{0,2147483647,1,7,nil,13},nil,nil,7},{38,nil,38,"localTemperatureCalibration",nil,nil,nil,"local_temperature_calibration","Ecozy Local Temperature Calibration",{-2.5,2.5,0.1,1,nil,14},nil,nil,1},{39,nil,39,"piHeatingDemand",nil,0,0,"pi_heating_demand","Ecozy Pi Heating Demand",{0,100,1,3,nil,15},nil,nil,3},{40,nil,40,14,nil,0,0,"mi_motion_restarts","Mi Motion Restarts",{nil,nil,nil,nil,nil,16}},{41,nil,41,14,nil,0,0,"aq_m_eleven_restarts","Aq M11Restarts",{nil,nil,nil,nil,nil,17}},{42,nil,42,14,nil,0,0,"aq_t_one_restarts","Aq T1Restarts",{nil,nil,nil,nil,nil,18}},{43,nil,43,14,nil,0,0,"aq_e_one_restarts","Aq E1Restarts",{nil,nil,nil,nil,nil,19}},{44,nil,44,21,nil,0,0,"aq_p_one_interval","Aq P1Interval",{2,65535,1,6,nil,20},nil,nil,6},{45,nil,45,21,nil,0,0,"aq_t_one_interval","Aq T1Interval",{2,65535,1,6,nil,21},nil,nil,6},{46,nil,46,21,nil,0,0,"aq_e_one_interval","Aq E1Interval",{2,65535,1,6,nil,22},nil,nil,6},{47,nil,47,13,nil,0,0,"aq_p_one_device_temp","Aq P1Device Temp",{-128,127,1,1,nil,23},nil,nil,1},{48,nil,48,13,nil,0,0,"aq_t_one_device_temp","Aq T1Device Temp",{-128,127,1,1,nil,24},nil,nil,1},{49,nil,49,13,nil,0,0,"aq_e_one_device_temp","Aq E1Device Temp",{-128,127,1,1,nil,25},nil,nil,1},{50,nil,50,13,nil,0,0,"aq_m_eleven_device_temp","Aq M11Device Temp",{-128,127,1,1,nil,26},nil,nil,1},{51,nil,51,"temperatureMax",nil,nil,nil,"lcz_temp_max","Lcz Temp Max",{-20,80,1,1,nil,27},nil,nil,1},{52,nil,52,"temperatureMin",nil,nil,nil,"lcz_temp_min","Lcz Temp Min",{-20,80,1,1,nil,28},nil,nil,1},{53,nil,53,"humidityMax",nil,nil,nil,"lcz_humidity_max","Lcz Humidity Max",{0,100,1,3,nil,29},nil,nil,3},{54,nil,54,"humidityMin",nil,nil,nil,"lcz_humidity_min","Lcz Humidity Min",{0,100,1,3,nil,30},nil,nil,3},{55,nil,55,11,nil,nil,nil,"rps_sensitivity","Rps Sensitivity",{1,5,1,nil,nil,31}},{56,nil,56,11,nil,nil,nil,"ts_vibration_sensitivity","Ts Vibration Sensitivity",{0,50,1,nil,nil,32}},{58,nil,58,"lightInterval",nil,nil,nil,"candeo_light_interval","Candeo Light Interval",{1,720,1,57,nil,33},nil,nil,57},{59,nil,59,13,nil,0,0,"t1_ht_device_temperature","T1Ht Device Temperature",{nil,nil,nil,1,nil,34},nil,nil,1},{60,nil,60,"powerOutageCount",nil,0,0,"t1_ht_power_outage_count","T1Ht Power Outage Count",{nil,nil,nil,nil,nil,35}},{61,nil,61,"windSpeed",nil,0,0,"ws90_wind_speed","Shelly Ws90Wind Speed",{0,40,0.1,15,nil,36},nil,nil,15},{62,nil,62,"gustSpeed",nil,0,0,"ws90_gust_speed","Shelly Ws90Gust Speed",{0,40,0.1,15,nil,37},nil,nil,15},{63,nil,63,"uvIndex",nil,0,0,"ws90_uv_index","Shelly Ws90Uv Index",{0,15,0.1,nil,nil,38}},{65,nil,65,"precipitation",nil,0,0,"ws90_precipitation","Shelly Ws90Precipitation",{0,9999,0.1,64,nil,39},nil,nil,64},{67,nil,67,"capacitorVoltage",nil,0,0,"ws90_capacitor_voltage","Shelly Ws90Capacitor Voltage",{nil,nil,nil,66,nil,40},nil,nil,66}},G)a.enum=z({{22,22,68,68,nil,nil,nil,22,"Battery low",{69,2},{69,2},41,42,41},{70,nil,70,"zgNineZeroThreeTwoBDisplayUnit",nil,nil,nil,"zg9032b_temperature_display_unit","Zg9032b Temperature Display Unit",{16,17},{16,17},43,44,43},{71,nil,71,"wsNinetyRainStatus",nil,0,0,"ws90_rain_status","Ws90Rain Status",{72,73},{72,73},45,46,45},{74,nil,74,75,nil,0,0,75,"C3007Pressure",{18,76},{18,76},47,48,47},{77,nil,77,"cleaningReminder",nil,0,0,"cleaning_reminder","Rb Srain01Cleaning Reminder",{18,78},{18,78},49,50,49},{79,nil,79,"batteryState",nil,0,0,"heiman_battery_state","Heiman Hs2aq Battery State",{80,81,82},{80,81,82},51,52,51},{83,nil,83,11,nil,nil,nil,"ih_rt_one_sensitivity","Ih Rt One Sensitivity",{2,4,5},{2,4,5},53,54,53},{84,nil,84,19,nil,nil,nil,"ih_rt_one_keep_time","Ih Rt One Keep Time",{8,9,10},{8,9,10},55,56,55},{85,nil,85,11,nil,nil,nil,"ih_rt_two_sensitivity","Ih Rt Two Sensitivity",{2,4,5},{2,4,5},57,58,57},{86,nil,86,19,nil,nil,nil,"ih_rt_two_keep_time","Ih Rt Two Keep Time",{8,9,10},{8,9,10},59,60,59},{87,nil,87,11,nil,nil,nil,"zm35_sensitivity","Zm35Sensitivity",{2,4,5},{2,4,5},61,62,61},{88,nil,88,19,nil,nil,nil,"zm35_keep_time","Zm35Keep Time",{8,9,10},{8,9,10},63,64,63},{89,nil,89,11,nil,nil,nil,"aq_p_one_sensitivity","Aq P1Sensitivity",{2,4,5},{2,4,5},65,66,65},{90,nil,90,"indicator",nil,nil,nil,"aq_p_one_indicator","Aq P1Indicator",{91,12},{91,12},67,68,67},{92,nil,92,"temperatureAlarm",nil,0,0,"lcz_temp_alarm","Lcz Temp Alarm",{93,94,12},{93,94,12},69,70,69},{95,nil,95,"humidityAlarm",nil,0,0,"lcz_humidity_alarm","Lcz Humidity Alarm",{96,97,12},{96,97,12},71,72,71},{98,nil,98,"displayUnit",nil,nil,nil,"kctw_display_unit","Kctw Display Unit",{16,17},{16,17},73,74,73},{99,nil,99,"calibration",nil,nil,nil,"rps_calibration","Rps Calibration",{100},{100},75,76,75},{101,nil,101,11,nil,nil,nil,"candeo_motion_sensitivity","Candeo Motion Sensitivity",{2,4,5},{2,4,5},77,78,77},{102,nil,102,19,nil,nil,nil,"candeo_motion_keep_time","Candeo Motion Keep Time",{103,8,9,10},{103,8,9,10},79,80,79},{104,nil,104,"lightState",nil,0,0,"cwam_light_state","Cwam Light State",{105,106},{105,106},81,82,81}},K)a.text=z({{"last_power_response_time",107,107,0,0,nil,"Last power response time",64},{"remote_action",108,108,0,0,nil,"Remote action",128}},M)a.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
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
