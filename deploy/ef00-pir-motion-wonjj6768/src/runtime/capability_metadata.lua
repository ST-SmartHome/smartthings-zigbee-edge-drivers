local a={}local H={"m","on","off","s","low","high","min","sensitivity","ON","OFF","keep_time","keepTime","medium","10","30","60","120","presence_sensitivity","static_detection_sensitivity","motion_detection_sensitivity","move_sensitivity","keep_sensitivity","trigger_sensitivity","entry_sensitivity","fall_sensitivity","tumble_alarm_time","large_motion_detection_sensitivity","medium_motion_detection_sensitivity","small_motion_detection_sensitivity","small_move_sensitivity","breath_sensitivity","large_motion_detection_distance","medium_motion_detection_distance","small_motion_detection_distance","move_detection_max_distance","move_detection_min_distance","small_move_detection_max_distance","small_move_detection_min_distance","breath_detection_max_distance","breath_detection_min_distance","minimum_range","detection_delay","illuminance_threshold_min","shield_range","entry_filter_time","entry_distance_indentation","block_time","presence_time","presence_delay","detection_cycle","presence_detection_range","presence_fading_time","presence_target_distance","presence_illuminance_threshold","light_switch","presence_illuminance_switch","light_linkage","breaker_mode","breaker_status","sensor_state_mode","status_indication","motion_detection_mode","radar_scene","detection_method","radar_switch","tumble_switch","presenceSensitivity","staticDetectionSensitivity","motionDetectionSensitivity","moveSensitivity","keepSensitivity","triggerSensitivity","entrySensitivity","fallSensitivity","tumbleAlarmTime","largeMotionDetectionSensitivity","smallMotionDetectionSensitivity","smallMoveSensitivity","breathSensitivity","largeMotionDetectionDistance","mediumMotionDetectionDistance","smallMotionDetectionDistance","moveDetectionMaxDistance","moveDetectionMinDistance","smallMoveDetectionMaxDistance","smallMoveDetectionMinDistance","breathDetectionMaxDistance","breathDetectionMinDistance","minimumRange","detectionDelay","lux","illuminanceThresholdMin","shieldRange","entryFilterTime","entryDistanceIndentation","blockTime","presenceTime","presenceDelay","detectionCycle","presenceDetectionRange","detectionHoldTime","presenceTargetDistance","presenceIlluminanceThreshold","zg204zlIlluminanceInterval","tre6haifAlarmTime","auin8mzrVacancyDelay","auin8mzrVacantConfirmTime","auin8mzrReferenceLuminance","auin8mzrLightOnLuminance","auin8mzrLightOffLuminance","auin8mzrLuminanceLevel","seq9cm6uIntervalTime","szlm04uFadingTime","lightSwitch","presenceIlluminanceSwitch","lightLinkage","breakerMode","standard","local","breakerStatus","sensorStateMode","occupied","unoccupied","statusIndication","motionDetectionMode","only_pir","pir_and_radar","pir_or_radar","only_radar","radarScene","default","area","toilet","bedroom","parlour","office","hotel","bathroom","sleeping","unknown","detectionMethod","only_move","exist_move","radarSwitch","tumbleSwitch","zg204zlSensitivity","zg204zlKeepTime","tre6haifPirSensitivity","tre6haifAlarmMode","arm","silent","disarm","auin8mzrVSensitivity","speed_priority","normal_priority","accuracy_priority","auin8mzrOSensitivity","sensitive","normal","cautious","auin8mzrMode","mode","general_model","temporaty_stay","basic_detection","sensor_test","auin8mzrLedStatus","seq9cm6uSensitivity","middle","seq9cm6uWorkState","presence","none","presence_5min","presence_30min","none_5min","none_30min","szlm04uUsbPower","szlm04uSensorSwitch","ay204zSensitivity","ay204zKeepTime","lastPowerResponseTime"}
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
a.numeric=z({{18,18,67,67,"presenceSensitivityRange",nil,nil,18,"Presence sensitivity",{0,10,1,nil,nil,1},nil,10},{19,19,68,68,"staticDetectionSensitivityRange",nil,nil,19,"Static detection sensitivity",{0,20,1,nil,nil,2},nil,100},{20,20,69,69,"motionDetectionSensitivityRange",nil,nil,20,"Motion detection sensitivity",{0,20,1,nil,nil,3},nil,100},{21,21,70,70,"moveSensitivityRange",nil,nil,21,"Move sensitivity",{0,10,1,nil,nil,4},nil,100},{22,22,71,71,"keepSensitivityRange",nil,nil,22,"Keep sensitivity",{0,10,1,nil,nil,5},nil,100},{23,23,72,72,"triggerSensitivityRange",nil,nil,23,"Trigger sensitivity",{0,20,1,nil,nil,6},nil,100},{24,24,73,73,"entrySensitivityRange",nil,nil,24,"Entry sensitivity",{0,9,1,nil,nil,7},nil,100},{25,25,74,74,"fallSensitivityRange",nil,nil,25,"Fall sensitivity",{1,10,1,nil,nil,8},nil,100},{26,26,75,75,"tumbleAlarmTimeRange",nil,nil,26,"Tumble alarm time",{1,5,1,7,nil,9},nil,600,7},{27,27,76,76,"largeMotionDetectionSensitivityRange",nil,nil,27,"Large motion detection sensitivity",{0,10,1,nil,nil,10},nil,100},{28,28,"mediumMotionSensitivity","mediumMotionDetectionSensitivity","mediumMotionDetectionSensitivityRange",nil,nil,28,"Medium motion detection sensitivity",{0,10,1,nil,nil,11},nil,100},{29,29,77,77,"smallMotionDetectionSensitivityRange",nil,nil,29,"Small motion detection sensitivity",{0,10,1,nil,nil,12},nil,100},{30,30,78,78,"smallMoveSensitivityRange",nil,nil,30,"Small move sensitivity",{0,10,1,nil,nil,13},nil,100},{31,31,79,79,"breathSensitivityRange",nil,nil,31,"Breath sensitivity",{0,10,1,nil,nil,14},nil,100},{32,32,80,80,"largeMotionDetectionDistanceRange",nil,nil,32,"Large motion detection distance",{0,10,0.01,1,nil,15},nil,100,1},{33,33,81,81,"mediumMotionDetectionDistanceRange",nil,nil,33,"Medium motion detection distance",{0,6,0.01,1,nil,16},nil,100,1},{34,34,82,82,"smallMotionDetectionDistanceRange",nil,nil,34,"Small motion detection distance",{0,6,0.01,1,nil,17},nil,100,1},{35,35,83,83,"moveDetectionMaxDistanceRange",nil,nil,35,"Move detection max distance",{0,10,0.01,1,nil,18},nil,100,1},{36,36,84,84,"moveDetectionMinDistanceRange",nil,nil,36,"Move detection min distance",{0,10,0.01,1,nil,19},nil,100,1},{37,37,85,85,"smallMoveDetectionMaxDistanceRange",nil,nil,37,"Small move detection max distance",{0,6,0.01,1,nil,20},nil,100,1},{38,38,86,86,"smallMoveDetectionMinDistanceRange",nil,nil,38,"Small move detection min distance",{0,6,0.01,1,nil,21},nil,100,1},{39,39,87,87,"breathDetectionMaxDistanceRange",nil,nil,39,"Breath detection max distance",{0,6,0.01,1,nil,22},nil,100,1},{40,40,88,88,"breathDetectionMinDistanceRange",nil,nil,40,"Breath detection min distance",{0,6,0.01,1,nil,23},nil,100,1},{41,41,89,89,"minimumRangeRange",nil,nil,41,"Minimum range",{0,20,0.1,1,nil,24},nil,100},{42,42,90,90,"detectionDelayRange",nil,nil,42,"Detection delay",{0,3600,1,4,nil,25},nil,3600},{11,11,12,12,"keepTimeRange",nil,nil,11,"Keep time",{0,3600,1,4,nil,26},nil,3600},{43,43,92,92,"illuminanceThresholdMinRange",nil,nil,43,"Minimum illuminance threshold",{0,20000,1,91,nil,27},nil,20000},{44,44,93,93,"shieldRangeRange",nil,nil,44,"Shield range",{0,20,0.1,1,nil,28},nil,100},{45,45,94,94,"entryFilterTimeRange",nil,nil,45,"Entry filter time",{0,3600,1,4,nil,29},nil,3600},{46,46,95,95,"entryDistanceIndentationRange",nil,nil,46,"Entry distance indentation",{0,20,0.01,1,nil,30},nil,100},{47,47,96,96,"blockTimeRange",nil,nil,47,"Block time",{0,3600,1,4,nil,31},nil,3600},{48,48,97,97,"presenceTimeRange",nil,nil,48,"Presence time",{0,3600,1,4,nil,32},nil,3600},{49,49,98,98,"presenceDelayRange",nil,nil,49,"Presence delay",{0,3600,1,4,nil,33},nil,3600},{50,50,99,99,"detectionCycleRange",nil,nil,50,"Detection cycle",{0,3600,1,4,nil,34},nil,3600},{51,51,100,100,"presenceDetectionRangeRange",nil,nil,51,"Presence detection range",{0,20,0.1,1,nil,35},nil,20},{52,52,101,101,"detectionHoldTimeRange",nil,nil,52,"Detection hold time",{0,300,1,4,nil,36},nil,300},{53,53,102,102,"presenceTargetDistanceRange",nil,nil,53,"Presence target distance",{0,20,0.1,1,nil,37},nil,20},{54,54,103,103,"presenceIlluminanceThresholdRange",nil,nil,54,"Presence illuminance threshold",{0,20000,1,91,nil,38},nil,20000},{104,nil,104,"illuminanceInterval",nil,nil,nil,"illuminance_interval","Zg204zl Illuminance Interval",{1,720,1,7,nil,39},nil,nil,7},{105,nil,105,"alarmTime",nil,nil,nil,"alarm_time","Tre6haif Alarm Time",{1,180,1,4,nil,40},nil,nil,4},{106,nil,106,"vacancyDelay",nil,nil,nil,"vacancy_delay","Auin8mzr Vacancy Delay",{0,1000,1,4,nil,41},nil,nil,4},{107,nil,107,"vacantConfirmTime",nil,0,0,"vacant_confirm_time","Auin8mzr Vacant Confirm Time",{nil,nil,nil,nil,nil,42}},{108,nil,108,"referenceLuminance",nil,0,0,"reference_luminance","Auin8mzr Reference Luminance",{nil,nil,nil,nil,nil,43}},{109,nil,109,"lightOnLuminance",nil,nil,nil,"light_on_luminance_prefer","Auin8mzr Light On Luminance",{0,10000,1,nil,nil,44}},{110,nil,110,"lightOffLuminance",nil,nil,nil,"light_off_luminance_prefer","Auin8mzr Light Off Luminance",{0,10000,1,nil,nil,45}},{111,nil,111,"luminanceLevel",nil,0,0,"luminance_level","Auin8mzr Luminance Level",{nil,nil,nil,nil,nil,46}},{112,nil,112,"intervalTime",nil,nil,nil,"interval_time","Seq9cm6u Interval Time",{5,720,5,7,nil,47},nil,nil,7},{113,nil,113,"fadingTime",nil,nil,nil,"fading_time","Szlm04u Fading Time",{5,300,1,4,nil,48},nil,nil,4}},G)a.enum=z({{55,55,114,114,nil,nil,nil,55,"Light switch",{2,3},{2,3},49,50,49},{56,56,115,115,nil,nil,nil,56,"Presence illuminance switch",{2,3},{2,3},49,51,49},{57,57,116,116,nil,nil,nil,57,"Light linkage",{2,3},{2,3},49,52,49},{58,58,117,117,"supportedBreakerModes",nil,nil,58,"Breaker mode",{118,119},{118,119},53,54,53},{59,59,120,120,nil,nil,nil,59,"Breaker status",{2,3},{2,3},49,55,49},{60,60,121,121,"supportedSensorStateModes",nil,nil,60,"Sensor state mode",{2,3,122,123},{2,3,122,123},56,57,56},{61,61,124,124,nil,nil,nil,61,"Status indication",{2,3},{2,3},49,58,49},{62,62,125,125,"supportedMotionDetectionModes",nil,nil,62,"Motion detection mode",{126,127,128,129},{126,127,128,129},59,60,59},{63,63,130,130,"supportedRadarScenes",nil,nil,63,"Radar scene",{131,132,133,134,135,136,137,138,139,140},{131,132,133,134,135,136,137,138,139,140},61,62,61},{64,64,141,141,"supportedDetectionMethods",nil,nil,64,"Detection method",{142,143},{142,143},63,64,63},{65,65,144,144,nil,nil,nil,65,"Radar switch",{2,3},{2,3},49,65,49},{66,66,145,145,nil,nil,nil,66,"Tumble switch",{2,3},{2,3},49,66,49},{146,nil,146,8,nil,nil,nil,8,"Zg204zl Sensitivity",{5,13,6},{5,13,6},67,68,67},{147,nil,147,12,nil,nil,nil,11,"Zg204zl Keep Time",{14,15,16,17},{14,15,16,17},69,70,69},{148,nil,148,"pirSensitivity",nil,nil,nil,"pir_sensitivity","Tre6haif Pir Sensitivity",{6,5},{6,5},71,72,71},{149,nil,149,"alarmMode",nil,nil,nil,"alarm_mode","Tre6haif Alarm Mode",{150,151,152},{150,151,152},73,74,73},{153,nil,153,"vSensitivity",nil,nil,nil,"v_sensitivity","Auin8mzr VSensitivity",{154,155,156},{154,155,156},75,76,75},{157,nil,157,"oSensitivity",nil,nil,nil,"o_sensitivity","Auin8mzr OSensitivity",{158,159,160},{158,159,160},77,78,77},{161,nil,161,162,nil,nil,nil,162,"Auin8mzr Mode",{163,164,165,166},{163,164,165,166},79,80,79},{167,nil,167,"ledStatus",nil,nil,nil,"led_status","Auin8mzr Led Status",{9,10},{9,10},81,82,81},{168,nil,168,8,nil,nil,nil,8,"Seq9cm6u Sensitivity",{5,169,6},{5,169,6},83,84,83},{170,nil,170,"workState",nil,0,0,"work_state","Seq9cm6u Work State",{171,172,173,174,175,176},{171,172,173,174,175,176},85,86,85},{177,nil,177,"usbPower",nil,0,0,"usb_power","Szlm04u Usb Power",{9,10},{9,10},87,88,87},{178,nil,178,"sensorSwitch",nil,0,0,"switch","Szlm04u Sensor Switch",{9,10},{9,10},89,90,89},{179,nil,179,8,nil,nil,nil,8,"Ay204z Sensitivity",{5,13,6},{5,13,6},91,92,91},{180,nil,180,12,nil,nil,nil,11,"Ay204z Keep Time",{14,15,16,17},{14,15,16,17},93,94,93}},K)a.text=z({{"last_power_response_time",181,181,0,0,nil,"Last power response time",64}},M)a.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
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
