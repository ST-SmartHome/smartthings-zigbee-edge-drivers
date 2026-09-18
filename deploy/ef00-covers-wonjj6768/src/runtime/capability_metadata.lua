local custom_capabilities={}
local strings={"%","coverPositionReportRm28Le","coverPositionReportRmTwoEightLe","position_report","Cover Position Report Rm28Le","coverPositionReportZm79eDt","coverPositionReportZmSevenNineeDt","Cover Position Report Zm79e Dt","coverPositionReportBx82Tyz1","coverPositionReportBxEightTwoTyzOne","Cover Position Report Bx82Tyz1","favoritePositionZbSm","favorite_position","Favorite Position Zb Sm","zsm01PositionBest","positionBest","position_best","Zsm01Position Best","ms","zbSmCycleTime","cycleTime","cycle_time","Zb Sm Cycle Time","zbSmCycleCount","cycleCount","cycle_count","Zb Sm Cycle Count","mW","zbSmActivePower","activePower","active_power","Zb Sm Active Power","s","pims3028TimeTotal","timeTotal","time_total","Pims3028Time Total","pims3028PositionBest","Pims3028Position Best","°","pims3028AngleHorizontal","angleHorizontal","angle_horizontal","Pims3028Angle Horizontal","pims3028QuickCalibration","quickCalibration","quick_calibration","Pims3028Quick Calibration","rm28leCountdownLeft","countdownLeft","countdown_left","Rm28le Countdown Left","rm28leTimeTotal","Rm28le Time Total","rm28lePositionBest","Rm28le Position Best","coverOneMotorSpeed","motorSpeed","motor_speed","Cover One Motor Speed","coverSixIllumination","illumination","cover_six_illumination","Cover Six Illumination","switch_type","switchType","supportedSwitchTypes","Switch type","toggle","state","momentary","tiltModeMb60l","tiltModeMbSixZerol","tilt_mode","Tilt Mode Mb60l","off","on","manualModeEpjZbEnableDisable","manual_mode","Manual Mode Epj Zb Enable Disable","enable","disable","windowDetectionEpjZbState","window_detection","Window Detection Epj Zb State","opened","closed","pending","motorDirectionZbSmNormalRev","motor_direction","Motor Direction Zb Sm Normal Rev","normal","reversed","motorDirectionZm79eDtLeftRight","caprayirlspeprfrwwysgxh","Motor Direction Zm79e Dt Left Right","left","right","motorDirectionBxTyzNormalRev","capnfcnnbmfkahvrbckxcij","Motor Direction Bx Tyz Normal Rev","motorDirectionMbNormalRev","capultkjbczgdpnaciiuoqx","Motor Direction Mb Normal Rev","motorDirectionEpjZbSide","Motor Direction Epj Zb Side","left_side","right_side","coverWorkPimsActual","capcpcfsvmnkqqvbyfklqpl","work_state","Cover Work Pims Actual","opening","closing","value_123","coverWorkRmOpeningClosing","capmtldrdyfbzxvbdlnhcgl","Cover Work Rm Opening Closing","coverWorkStateZm79eDtLearning","coverWorkStateZmSevenNineeDtLearning","Cover Work State Zm79e Dt Learning","standby","success","learning","coverCalibrationPims3028StartEnd","capvonpjrddxpdpephlodgy","calibration","Cover Calibration Pims3028Start End","start","end","zsm01ControlBackMode","controlBackMode","control_back_mode","Zsm01Control Back Mode","forward","back","zsm01ClickControl","clickControl","click_control","Zsm01Click Control","up","down","zbSmMotorState","motorState","motor_state","Zb Sm Motor State","stopped","zbSmTopLimit","topLimit","top_limit","Zb Sm Top Limit","set","clear","zbSmBottomLimit","bottomLimit","bottom_limit","Zb Sm Bottom Limit","pims3028Mode","mode","Pims3028Mode","up_delete","remove_up_down","pims3028ControlBack","controlBack","control_back","Pims3028Control Back","pims3028AutoPower","autoPower","auto_power","Pims3028Auto Power","pims3028SituationSet","situationSet","situation_set","Pims3028Situation Set","fully_open","fully_close","pims3028Fault","fault","Pims3028Fault","pims3028Border","border","Pims3028Border","down_delete","remove_top_bottom","pims3028BestTrigger","bestTrigger","best_position_trigger","Pims3028Best Trigger","pims3028Reset","reset","Pims3028Reset","rm28leMode","Rm28le Mode","morning","night","rm28leAutoPower","Rm28le Auto Power","rm28leCountdown","countdown","Rm28le Countdown","cancel","1h","2h","3h","4h","rm28leSituationSet","Rm28le Situation Set","rm28leMotorFault","motorFault","motor_fault","Rm28le Motor Fault","rm28leBorder","Rm28le Border","rm28leClickControl","Rm28le Click Control","coverThreeReverseDirection","reverseDirection","reverse_direction","Cover Three Reverse Direction","coverThreeLimit","coverLimit","cover_limit","Cover Three Limit","set_up","set_down","delete_up","delete_down","delete_both","coverThreeClickControl","Cover Three Click Control","coverThreeMotorFault","Cover Three Motor Fault","coverOneReverseDirection","Cover One Reverse Direction","zm79eOpeningMode","openingMode","opening_mode","Zm79e Opening Mode","tilt","lift","zm79eSetUpperLimit","setUpperLimit","set_upper_limit","Zm79e Set Upper Limit","stop","zm79eFactoryReset","factoryReset","factory_reset","Zm79e Factory Reset","mb60lSetLimits","setLimits","set_limits","Mb60l Set Limits","mb60lChildLock","childLock","child_lock","Mb60l Child Lock","trwaxi57Calibration","Trwaxi57Calibration","trwaxi57Backlight","backlight","backlight_mode","Trwaxi57Backlight","trwaxi57MotorSteering","motorSteering","motor_steering","Trwaxi57Motor Steering","backward","trwaxi57ChildLock","Trwaxi57Child Lock","coverSixOpening","cover_six_opening","Cover Six Opening","coverSixWorkState","workState","cover_six_work_state","Cover Six Work State","coverSixDirection","motorDirection","cover_six_direction","Cover Six Direction","coverSixUpperLimit","upperLimit","cover_six_upper_limit","Cover Six Upper Limit","ts0301Direction","ts0301_direction","Ts0301Direction","last_power_response_time","lastPowerResponseTime","Last power response time","zbSmMotorType","motorType","motor_type","Zb Sm Motor Type"}
local function string_value(value)
if type(value)=="number" then return strings[value]end
return value
end
local function capability_id(value)local suffix=string_value(value);if suffix==nil then return nil end;return "concertmirror08464." .. suffix end
local table_groups={}
local function grouped_table(group_id)
if type(group_id)~="number" then return{}end
local existing=table_groups[group_id]
if existing ~=nil then return existing end
local out={}
table_groups[group_id]=out
return out
end
local function string_list(values,group_id)
if type(values)~="table" then return nil end
local out=grouped_table(group_id)
for index,value in ipairs(values)do out[index]=string_value(value)end
return out
end
local function optional_string(value,default)
if value==nil then return default end
if value==0 then return nil end
return string_value(value)
end
local function command_default(attribute_name)
if type(attribute_name)~="string" or attribute_name=="" then return nil end
return "set" .. attribute_name:sub(1,1):upper().. attribute_name:sub(2)
end
local function range(value)
if type(value)~="table" then return nil end
local out=grouped_table(value[6])
out.minimum=value[1]
out.maximum=value[2]
out.step=value[3]
out.unit=string_value(value[4])
out.allowed_values=string_list(value[5],value[7])
return out
end
local function allowed_range(allowed_values,group_id)
if allowed_values==nil and group_id==nil then return nil end
local out=grouped_table(group_id)
out.allowed_values=allowed_values
return out
end
local function numeric(row)
local attribute_name=string_value(row[4])
return{kind="numeric",emit_name=string_value(row[1]),range_key=string_value(row[2]),capability_id=capability_id(row[3]),attribute_name=attribute_name,range_attribute_name=string_value(row[5]),command_name=optional_string(row[6],command_default(attribute_name)),argument_name=optional_string(row[7],attribute_name),mapping_name=string_value(row[8]),label=string_value(row[9]),default_range=range(row[10]),event_minimum=row[11],event_maximum=row[12],event_unit=string_value(row[13])}
end
local function enum(row)
local attribute_name=string_value(row[4])
local supported_values=string_list(row[10],row[12])
local default_allowed_values=string_list(row[11],row[14])
local default_range=allowed_range(default_allowed_values,row[13])
return{kind="enum",emit_name=string_value(row[1]),range_key=string_value(row[2]),capability_id=capability_id(row[3]),attribute_name=attribute_name,supported_attribute_name=string_value(row[5]),command_name=optional_string(row[6],command_default(attribute_name)),argument_name=optional_string(row[7],attribute_name),mapping_name=string_value(row[8]),label=string_value(row[9]),supported_values=supported_values,default_range=default_range}
end
local function text(row)
local attribute_name=string_value(row[3])
return{kind="text",emit_name=string_value(row[1]),capability_id=capability_id(row[2]),attribute_name=attribute_name,command_name=optional_string(row[4],command_default(attribute_name)),argument_name=optional_string(row[5],attribute_name),mapping_name=string_value(row[6]),label=string_value(row[7]),maximum_length=row[8]}
end
local function build(rows,factory)
local out={}
for _,row in ipairs(rows)do out[#out + 1]=factory(row)end
return out
end
custom_capabilities.numeric=build({{2,nil,2,3,nil,0,0,4,5,{0,100,1,1,nil,1,nil},nil,nil,1},{6,nil,6,7,nil,0,0,4,8,{0,100,1,1,nil,2,nil},nil,nil,1},{9,nil,9,10,nil,0,0,4,11,{0,100,1,1,nil,3,nil},nil,nil,1},{12,nil,12,12,nil,nil,nil,13,14,{0,100,1,1,nil,4,nil},nil,nil,1},{15,nil,15,16,nil,nil,nil,17,18,{0,100,1,1,nil,5,nil},nil,nil,1},{20,nil,20,21,nil,0,0,22,23,{0,999999,1,19,nil,6,nil},nil,nil,19},{24,nil,24,25,nil,0,0,26,27,{0,999999,1,nil,nil,7,nil},nil,nil,nil},{29,nil,29,30,nil,0,0,31,32,{0,999999,1,28,nil,8,nil},nil,nil,28},{34,nil,34,35,nil,0,0,36,37,{0,600,1,33,nil,9,nil},nil,nil,33},{38,nil,38,16,nil,nil,nil,17,39,{1,100,1,1,nil,10,nil},nil,nil,1},{41,nil,41,42,nil,nil,nil,43,44,{0,100,25,40,nil,11,nil},nil,nil,40},{45,nil,45,46,nil,nil,nil,47,48,{0,900,1,33,nil,12,nil},nil,nil,33},{49,nil,49,50,nil,0,0,51,52,{0,86400,1,33,nil,13,nil},nil,nil,33},{53,nil,53,35,nil,0,0,36,54,{0,999999,1,19,nil,14,nil},nil,nil,19},{55,nil,55,16,nil,nil,nil,17,56,{0,100,1,1,nil,15,nil},nil,nil,1},{57,nil,57,58,nil,nil,nil,59,60,{0,255,1,nil,nil,16,nil},nil,nil,nil},{61,nil,61,62,nil,0,0,63,64,{nil,nil,nil,1,nil,17,nil},nil,nil,1}},numeric)
custom_capabilities.enum=build({{65,65,66,66,67,nil,nil,65,68,{69,70,71},{69,70,71},18,19,18},{72,nil,72,73,nil,nil,nil,74,75,{76,77},{76,77},20,21,20},{78,nil,78,78,nil,nil,nil,79,80,{81,82},{81,82},22,23,22},{83,nil,83,83,nil,nil,nil,84,85,{86,87,88},{86,87,88},24,25,24},{89,nil,89,89,nil,nil,nil,90,91,{92,93},{92,93},26,27,26},{94,nil,94,95,nil,nil,nil,90,96,{97,98},{97,98},28,29,28},{99,nil,99,100,nil,nil,nil,90,101,{92,93},{92,93},30,31,30},{102,nil,102,103,nil,nil,nil,90,104,{92,93},{92,93},32,33,32},{105,nil,105,105,nil,nil,nil,90,106,{107,108},{107,108},34,35,34},{109,nil,109,110,nil,0,0,111,112,{113,114,115},{113,114,115},36,37,36},{116,nil,116,117,nil,0,0,111,118,{113,114},{113,114},38,39,38},{119,nil,119,120,nil,0,0,111,121,{122,123,124},{122,123,124},40,41,40},{125,nil,125,126,nil,nil,nil,127,128,{129,130},{129,130},42,43,42},{131,nil,131,132,nil,nil,nil,133,134,{135,136},{135,136},44,45,44},{137,nil,137,138,nil,nil,nil,139,140,{141,142},{141,142},46,47,46},{143,nil,143,144,nil,0,0,145,146,{113,147,114},{113,147,114},48,49,48},{148,nil,148,149,nil,nil,nil,150,151,{152,153},{152,153},50,51,50},{154,nil,154,155,nil,nil,nil,156,157,{152,153},{152,153},52,53,52},{158,nil,158,159,nil,nil,nil,159,160,{141,161,162},{141,161,162},54,55,54},{163,nil,163,164,nil,nil,nil,165,166,{135,136},{135,136},56,57,56},{167,nil,167,168,nil,nil,nil,169,170,{76,77},{76,77},58,59,58},{171,nil,171,172,nil,0,0,173,174,{175,176},{175,176},60,61,60},{177,nil,177,178,nil,0,0,178,179,{92,178},{92,178},62,63,62},{180,nil,180,181,nil,nil,nil,181,182,{183,184},{183,184},64,65,64},{185,nil,185,186,nil,nil,nil,187,188,{76,77},{76,77},66,67,66},{189,nil,189,190,nil,nil,nil,190,191,{190},{190},68,69,68},{192,nil,192,159,nil,nil,nil,159,193,{194,195},{194,195},70,71,70},{196,nil,196,168,nil,nil,nil,169,197,{76,77},{76,77},72,73,72},{198,nil,198,199,nil,nil,nil,199,200,{201,202,203,204,205},{201,202,203,204,205},74,75,74},{206,nil,206,172,nil,0,0,173,207,{175,176},{175,176},76,77,76},{208,nil,208,209,nil,0,0,210,211,{92,178},{92,178},78,79,78},{212,nil,212,181,nil,nil,nil,181,213,{141,142,161,183,184},{141,142,161,183,184},80,81,80},{214,nil,214,138,nil,nil,nil,139,215,{141,142},{141,142},82,83,82},{216,nil,216,217,nil,nil,nil,218,219,{135,136},{135,136},84,85,84},{220,nil,220,221,nil,nil,nil,222,223,{224,225,226,227,228},{224,225,226,227,228},86,87,86},{229,nil,229,138,nil,nil,nil,139,230,{141,142},{141,142},88,89,88},{231,nil,231,209,nil,0,0,210,232,{92,178},{92,178},90,91,90},{233,nil,233,217,nil,nil,nil,218,234,{135,136},{135,136},92,93,92},{235,nil,235,236,nil,nil,nil,237,238,{239,240},{239,240},94,95,94},{241,nil,241,242,nil,nil,nil,243,244,{129,245},{129,245},96,97,96},{246,nil,246,247,nil,nil,nil,248,249,{152},{152},98,99,98},{250,nil,250,251,nil,nil,nil,252,253,{141,142,190},{141,142,190},100,101,100},{254,nil,254,255,nil,nil,nil,256,257,{76,77},{76,77},102,103,102},{258,nil,258,127,nil,nil,nil,127,259,{129,130},{129,130},104,105,104},{260,nil,260,261,nil,nil,nil,262,263,{76,77},{76,77},106,107,106},{264,nil,264,265,nil,nil,nil,266,267,{135,268},{135,268},108,109,108},{269,nil,269,255,nil,nil,nil,256,270,{76,77},{76,77},110,111,110},{271,nil,271,236,nil,nil,nil,272,273,{239,240},{239,240},112,113,112},{274,nil,274,275,nil,0,0,276,277,{122,123,124},{122,123,124},114,115,114},{278,nil,278,279,nil,nil,nil,280,281,{97,98},{97,98},116,117,116},{282,nil,282,283,nil,nil,nil,284,285,{129,245},{129,245},118,119,118},{286,nil,286,279,nil,nil,nil,287,288,{135,136},{135,136},120,121,120}},enum)
custom_capabilities.text=build({{289,290,290,0,0,nil,291,64},{292,292,293,0,0,294,295,32}},text)
custom_capabilities.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}
custom_capabilities.by_range_key={}
custom_capabilities.by_emit_name={}
custom_capabilities.by_capability_id={}
local function index_metadata(definitions)
for _,metadata in ipairs(definitions)do
custom_capabilities.by_emit_name[metadata.emit_name]=metadata
if type(metadata.capability_id)=="string" and metadata.capability_id ~="" then custom_capabilities.by_capability_id[metadata.capability_id]=metadata end
if type(metadata.range_key)=="string" and metadata.range_key ~="" then custom_capabilities.by_range_key[metadata.range_key]=metadata end
end
end
index_metadata(custom_capabilities.numeric)
index_metadata(custom_capabilities.enum)
index_metadata(custom_capabilities.text)
custom_capabilities.by_emit_name[custom_capabilities.driver_message.emit_name]=custom_capabilities.driver_message
custom_capabilities.by_capability_id[custom_capabilities.driver_message.capability_id]=custom_capabilities.driver_message
local function clone_allowed_values(allowed_values)
if type(allowed_values)~="table" then return nil end
local copied={}
for index,value in ipairs(allowed_values)do copied[index]=value end
return copied
end
function custom_capabilities.resolve_range(definition,metadata)
if type(metadata)~="table" then return nil end
local default_range=type(metadata.default_range)=="table" and metadata.default_range or nil
local ranges=type(definition)=="table" and definition.presence_capability_ranges or nil
local resolved=type(ranges)=="table" and ranges[metadata.range_key]or nil
if type(resolved)~="table" then resolved=default_range end
if type(resolved)~="table" then return nil end
return{
minimum=type(resolved.minimum)=="number" and resolved.minimum or(default_range and default_range.minimum or nil),
maximum=type(resolved.maximum)=="number" and resolved.maximum or(default_range and default_range.maximum or nil),
step=type(resolved.step)=="number" and resolved.step or(default_range and default_range.step or nil),
unit=type(resolved.unit)=="string" and resolved.unit or(default_range and default_range.unit or nil),
allowed_values=type(resolved.allowed_values)=="table" and clone_allowed_values(resolved.allowed_values)or clone_allowed_values(default_range and default_range.allowed_values or nil),
}
end
return custom_capabilities
