local custom_capabilities={}
local strings={"s","adcbziTotalTime","totalTime","adcbzi_total_time","Adcbzi Total Time","adcbziOpenThreshold","openThreshold","adcbzi_open_threshold","Adcbzi Open Threshold","adcbziCloseThreshold","closeThreshold","adcbzi_close_threshold","Adcbzi Close Threshold","adcbziCurtainStatus","curtainStatus","adcbzi_curtain_status","Adcbzi Curtain Status","m","adcbziTotalDistance","totalDistance","adcbzi_total_distance","Adcbzi Total Distance","adcbziFactoryTest","factoryTest","adcbzi_factory_test","Adcbzi Factory Test","%","tsCoverTwoFavoritePosition","favoritePosition","ts_cover_two_favorite_position","Ts Cover Two Favorite Position","znUscCalibrationTime","calibrationTime","zn_usc_calibration_time","Zn Usc Calibration Time","moesSfTravelTime","travelTime","moes_sf_travel_time","Moes Sf Travel Time","gm25TeqMotorDirection","gmTwoFiveTeqMotorDirection","motor_direction","Gm25Teq Motor Direction","normal","reversed","adcbziWorkState","workState","adcbzi_work_state","Adcbzi Work State","standby","opening","closing","adcbziSituationSet","situationSet","adcbzi_situation_set","Adcbzi Situation Set","fully_open","fully_close","adcbziFault","fault","adcbzi_fault","Adcbzi Fault","none","adcbziChargingStatus","chargingStatus","adcbzi_charging_status","Adcbzi Charging Status","uncharged","charging","charged","adcbziCalibration","calibration","adcbzi_calibration","Adcbzi Calibration","stop","calibrate","calibrate_reverse","blTyzMotorDirection","motorDirection","bl_tyz_motor_direction","Bl Tyz Motor Direction","blTyzAutoPower","autoPower","bl_tyz_auto_power","Bl Tyz Auto Power","ON","OFF","zsSrCalibration","zs_sr_calibration","Zs Sr Calibration","START","END","zsSrMotorSteering","motorSteering","zs_sr_motor_steering","Zs Sr Motor Steering","FORWARD","BACKWARD","zcLpCharging","zc_lp_charging","Zc Lp Charging","not_charging","zcLpAutomaticMode","automaticMode","zc_lp_automatic_mode","Zc Lp Automatic Mode","zcLpSlowMode","slowMode","zc_lp_slow_mode","Zc Lp Slow Mode","zcLpButtonPosition","buttonPosition","zc_lp_button_position","Zc Lp Button Position","UP","DOWN","fwjzMotorDirection","fwjz_motor_direction","Fwjz Motor Direction","fwjzCoverLimit","coverLimit","fwjz_cover_limit","Fwjz Cover Limit","set_up","set_down","delete_up","delete_down","delete_both","tsCoverTwoMotorState","motorState","ts_cover_two_motor_state","Ts Cover Two Motor State","stopped","tsCoverTwoSlowMode","ts_cover_two_slow_mode","Ts Cover Two Slow Mode","tsCoverTwoMotorDirection","ts_cover_two_motor_direction","Ts Cover Two Motor Direction","tsCoverTwoCoverType","coverType","ts_cover_two_cover_type","Ts Cover Two Cover Type","roman_pole","roller_blind","canopy_curtain","roman_blind","honeycomb_curtain","tsCoverTwoCoverLimit","ts_cover_two_cover_limit","Ts Cover Two Cover Limit","tsCoverTwoClickControl","clickControl","ts_cover_two_click_control","Ts Cover Two Click Control","up","down","xSevenCalibration","x_seven_calibration","X Seven Calibration","start","finish","znUscMotorSteering","zn_usc_motor_steering","Zn Usc Motor Steering","zmpOneMotorState","zmp_one_motor_state","Zmp One Motor State","zmpOneMotorDirection","zmp_one_motor_direction","Zmp One Motor Direction","ercSixDirection","direction","erc_six_direction","Erc Six Direction","forward","back","ercSixRecordRf","recordRf","erc_six_record_rf","Erc Six Record Rf","record","ercSixClearRf","clearRf","erc_six_clear_rf","Erc Six Clear Rf","clear","moesSfCalibration","moes_sf_calibration","Moes Sf Calibration","end","moesSfBacklight","backlight","moes_sf_backlight","Moes Sf Backlight","on","off","moesSfDirection","moes_sf_direction","Moes Sf Direction","last_power_response_time","lastPowerResponseTime","Last power response time","adcbziCustomWeekProgOne","customWeekProgOne","adcbzi_custom_week_prog_one","Adcbzi Custom Week Prog One","adcbziCustomWeekProgTwo","customWeekProgTwo","adcbzi_custom_week_prog_two","Adcbzi Custom Week Prog Two","adcbziCustomWeekProgThree","customWeekProgThree","adcbzi_custom_week_prog_three","Adcbzi Custom Week Prog Three","adcbziCustomWeekProgFour","customWeekProgFour","adcbzi_custom_week_prog_four","Adcbzi Custom Week Prog Four"}
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
custom_capabilities.numeric=build({{2,nil,2,3,nil,0,0,4,5,{nil,nil,nil,1,nil,1,nil},nil,nil,1},{6,nil,6,7,nil,nil,nil,8,9,{0,100,1,nil,nil,2,nil},nil,nil,nil},{10,nil,10,11,nil,nil,nil,12,13,{0,100,1,nil,nil,3,nil},nil,nil,nil},{14,nil,14,15,nil,nil,nil,16,17,{0,255,1,nil,nil,4,nil},nil,nil,nil},{19,nil,19,20,nil,0,0,21,22,{nil,nil,nil,18,nil,5,nil},nil,nil,18},{23,nil,23,24,nil,0,0,25,26,{0,100,1,nil,nil,6,nil},nil,nil,nil},{28,nil,28,29,nil,nil,nil,30,31,{0,100,1,27,nil,7,nil},nil,nil,27},{32,nil,32,33,nil,nil,nil,34,35,{0,500,1,1,nil,8,nil},nil,nil,1},{36,nil,36,37,nil,nil,nil,38,39,{10,180,1,1,nil,9,nil},nil,nil,1}},numeric)
custom_capabilities.enum=build({{40,nil,40,41,nil,nil,nil,42,43,{44,45},{44,45},10,11,10},{46,nil,46,47,nil,0,0,48,49,{50,51,52},{50,51,52},12,13,12},{53,nil,53,54,nil,nil,nil,55,56,{57,58},{57,58},14,15,14},{59,nil,59,60,nil,0,0,61,62,{63},{63},16,17,16},{64,nil,64,65,nil,0,0,66,67,{63,68,69,70},{63,68,69,70},18,19,18},{71,nil,71,72,nil,nil,nil,73,74,{75,76,77},{75,76,77},20,21,20},{78,nil,78,79,nil,nil,nil,80,81,{44,45},{44,45},22,23,22},{82,nil,82,83,nil,nil,nil,84,85,{86,87},{86,87},24,25,24},{88,nil,88,72,nil,nil,nil,89,90,{91,92},{91,92},26,27,26},{93,nil,93,94,nil,nil,nil,95,96,{97,98},{97,98},28,29,28},{99,nil,99,69,nil,0,0,100,101,{69,102},{69,102},30,31,30},{103,nil,103,104,nil,nil,nil,105,106,{86,87},{86,87},32,33,32},{107,nil,107,108,nil,nil,nil,109,110,{86,87},{86,87},34,35,34},{111,nil,111,112,nil,nil,nil,113,114,{115,116},{115,116},36,37,36},{117,nil,117,79,nil,nil,nil,118,119,{44,45},{44,45},38,39,38},{120,nil,120,121,nil,nil,nil,122,123,{124,125,126,127,128},{124,125,126,127,128},40,41,40},{129,nil,129,130,nil,0,0,131,132,{51,52,133},{51,52,133},42,43,42},{134,nil,134,108,nil,nil,nil,135,136,{86,87},{86,87},44,45,44},{137,nil,137,79,nil,nil,nil,138,139,{44,45},{44,45},46,47,46},{140,nil,140,141,nil,nil,nil,142,143,{144,145,146,147,148},{144,145,146,147,148},48,49,48},{149,nil,149,121,nil,nil,nil,150,151,{124,125,126,127,128},{124,125,126,127,128},50,51,50},{152,nil,152,153,nil,nil,nil,154,155,{156,157},{156,157},52,53,52},{158,nil,158,72,nil,nil,nil,159,160,{161,162},{161,162},54,55,54},{163,nil,163,94,nil,nil,nil,164,165,{97,98},{97,98},56,57,56},{166,nil,166,130,nil,0,0,167,168,{51,52,133},{51,52,133},58,59,58},{169,nil,169,79,nil,nil,nil,170,171,{44,45},{44,45},60,61,60},{172,nil,172,173,nil,nil,nil,174,175,{176,177},{176,177},62,63,62},{178,nil,178,179,nil,nil,nil,180,181,{182,75},{182,75},64,65,64},{183,nil,183,184,nil,nil,nil,185,186,{187,75},{187,75},66,67,66},{188,nil,188,72,nil,nil,nil,189,190,{161,191},{161,191},68,69,68},{192,nil,192,193,nil,nil,nil,194,195,{196,197},{196,197},70,71,70},{198,nil,198,79,nil,nil,nil,199,200,{44,45},{44,45},72,73,72}},enum)
custom_capabilities.text=build({{201,202,202,0,0,nil,203,64},{204,204,205,nil,nil,206,207,512},{208,208,209,nil,nil,210,211,512},{212,212,213,nil,nil,214,215,512},{216,216,217,nil,nil,218,219,512}},text)
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
