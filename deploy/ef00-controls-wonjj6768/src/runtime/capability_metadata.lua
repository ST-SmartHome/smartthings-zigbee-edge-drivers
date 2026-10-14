local custom_capabilities={}local strings={"security_remote_action","securityRemoteAction","supportedSecurityRemoteActions","Security remote action","disarm","arm_day_zones","arm_night_zones","arm_all_zones","exit_delay","emergency","foriaSceneBacklight","foria_scene_backlight","Foria Scene Backlight","off","on","foriaSceneIlluminationDetection","foria_scene_illumination_detection","Foria Scene Illumination Detection","foriaSceneApproachDetection","foria_scene_approach_detection","Foria Scene Approach Detection","foriaSceneVibration","foria_scene_vibration","Foria Scene Vibration","zrf01LearningMode","learningMode","zrf01_learning_mode","Zrf01Learning Mode","zrf01PacketMode","packetMode","zrf01_packet_mode","Zrf01Packet Mode","zrf01Code1","code","zrf01_code_1","Zrf01Code1","Learn","Delete","Saved","zrf01Transmit1","transmit","zrf01_transmit_1","Zrf01Transmit1","Transmit","zrf01Code2","zrf01_code_2","Zrf01Code2","zrf01Transmit2","zrf01_transmit_2","Zrf01Transmit2","zrf01Code3","zrf01_code_3","Zrf01Code3","zrf01Transmit3","zrf01_transmit_3","Zrf01Transmit3","zrf01Code4","zrf01_code_4","Zrf01Code4","zrf01Transmit4","zrf01_transmit_4","Zrf01Transmit4","zrf01Code5","zrf01_code_5","Zrf01Code5","zrf01Transmit5","zrf01_transmit_5","Zrf01Transmit5","zrf01Code6","zrf01_code_6","Zrf01Code6","zrf01Transmit6","zrf01_transmit_6","Zrf01Transmit6","zrf01Code7","zrf01_code_7","Zrf01Code7","zrf01Transmit7","zrf01_transmit_7","Zrf01Transmit7","zrf01Code8","zrf01_code_8","Zrf01Code8","zrf01Transmit8","zrf01_transmit_8","Zrf01Transmit8","last_power_response_time","lastPowerResponseTime","Last power response time"}
local function string_value(value)
if type(value)=="number"then return strings[value]end
return value
end
local function capability_id(value)local suffix=string_value(value);if suffix==nil then return nil end;return"concertmirror08464."..suffix end
local table_groups={}
local function grouped_table(group_id)
if type(group_id)~="number"then return{}end
local existing=table_groups[group_id]
if existing~=nil then return existing end
local out={}table_groups[group_id]=out
return out
end
local function string_list(values,group_id)
if type(values)~="table"then return nil end
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
if type(attribute_name)~="string"or attribute_name==""then return nil end
return"set"..attribute_name:sub(1,1):upper()..attribute_name:sub(2)
end
local function range(value)
if type(value)~="table"then return nil end
local out=grouped_table(value[6])out.minimum=value[1]out.maximum=value[2]out.step=value[3]out.unit=string_value(value[4])out.allowed_values=string_list(value[5],value[7])return out
end
local function allowed_range(allowed_values,group_id)
if allowed_values==nil and group_id==nil then return nil end
local out=grouped_table(group_id)out.allowed_values=allowed_values
return out
end
local function numeric(row)
local attribute_name=string_value(row[4])return{kind="numeric",emit_name=string_value(row[1]),range_key=string_value(row[2]),capability_id=capability_id(row[3]),attribute_name=attribute_name,range_attribute_name=string_value(row[5]),command_name=optional_string(row[6],command_default(attribute_name)),argument_name=optional_string(row[7],attribute_name),mapping_name=string_value(row[8]),label=string_value(row[9]),default_range=range(row[10]),event_minimum=row[11],event_maximum=row[12],event_unit=string_value(row[13])}
end
local function enum(row)
local attribute_name=string_value(row[4])local supported_values=string_list(row[10],row[12])local default_allowed_values=string_list(row[11],row[14])local default_range=allowed_range(default_allowed_values,row[13])return{kind="enum",emit_name=string_value(row[1]),range_key=string_value(row[2]),capability_id=capability_id(row[3]),attribute_name=attribute_name,supported_attribute_name=string_value(row[5]),command_name=optional_string(row[6],command_default(attribute_name)),argument_name=optional_string(row[7],attribute_name),mapping_name=string_value(row[8]),label=string_value(row[9]),supported_values=supported_values,default_range=default_range}
end
local function text(row)
local attribute_name=string_value(row[3])return{kind="text",emit_name=string_value(row[1]),capability_id=capability_id(row[2]),attribute_name=attribute_name,command_name=optional_string(row[4],command_default(attribute_name)),argument_name=optional_string(row[5],attribute_name),mapping_name=string_value(row[6]),label=string_value(row[7]),maximum_length=row[8]}
end
local function build(rows,factory)
local out={}
for _,row in ipairs(rows)do out[#out+1]=factory(row)end
return out
end
custom_capabilities.numeric=build({},numeric)custom_capabilities.enum=build({{1,1,2,2,3,nil,nil,1,4,{5,6,7,8,9,10},{5,6,7,8,9,10},1,2,1},{11,nil,11,11,nil,nil,nil,12,13,{14,15},{14,15},3,4,3},{16,nil,16,16,nil,nil,nil,17,18,{14,15},{14,15},5,6,5},{19,nil,19,19,nil,nil,nil,20,21,{14,15},{14,15},7,8,7},{22,nil,22,22,nil,nil,nil,23,24,{14,15},{14,15},9,10,9},{25,nil,25,26,nil,nil,nil,27,28,{15,14},{15,14},11,12,11},{29,nil,29,30,nil,nil,nil,31,32,{15,14},{15,14},13,14,13},{33,nil,33,34,nil,nil,nil,35,36,{37,38,39},{37,38,39},15,16,15},{40,nil,40,41,nil,nil,nil,42,43,{44},{44},17,18,17},{45,nil,45,34,nil,nil,nil,46,47,{37,38,39},{37,38,39},19,20,19},{48,nil,48,41,nil,nil,nil,49,50,{44},{44},21,22,21},{51,nil,51,34,nil,nil,nil,52,53,{37,38,39},{37,38,39},23,24,23},{54,nil,54,41,nil,nil,nil,55,56,{44},{44},25,26,25},{57,nil,57,34,nil,nil,nil,58,59,{37,38,39},{37,38,39},27,28,27},{60,nil,60,41,nil,nil,nil,61,62,{44},{44},29,30,29},{63,nil,63,34,nil,nil,nil,64,65,{37,38,39},{37,38,39},31,32,31},{66,nil,66,41,nil,nil,nil,67,68,{44},{44},33,34,33},{69,nil,69,34,nil,nil,nil,70,71,{37,38,39},{37,38,39},35,36,35},{72,nil,72,41,nil,nil,nil,73,74,{44},{44},37,38,37},{75,nil,75,34,nil,nil,nil,76,77,{37,38,39},{37,38,39},39,40,39},{78,nil,78,41,nil,nil,nil,79,80,{44},{44},41,42,41},{81,nil,81,34,nil,nil,nil,82,83,{37,38,39},{37,38,39},43,44,43},{84,nil,84,41,nil,nil,nil,85,86,{44},{44},45,46,45}},enum)custom_capabilities.text=build({{87,88,88,0,0,nil,89,64}},text)custom_capabilities.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}custom_capabilities.by_range_key={}custom_capabilities.by_emit_name={}custom_capabilities.by_capability_id={}
local function index_metadata(definitions)
for _,metadata in ipairs(definitions)do
custom_capabilities.by_emit_name[metadata.emit_name]=metadata
if type(metadata.capability_id)=="string"and metadata.capability_id~=""then custom_capabilities.by_capability_id[metadata.capability_id]=metadata end
if type(metadata.range_key)=="string"and metadata.range_key~=""then custom_capabilities.by_range_key[metadata.range_key]=metadata end
end
end
index_metadata(custom_capabilities.numeric)index_metadata(custom_capabilities.enum)index_metadata(custom_capabilities.text)custom_capabilities.by_emit_name[custom_capabilities.driver_message.emit_name]=custom_capabilities.driver_message
custom_capabilities.by_capability_id[custom_capabilities.driver_message.capability_id]=custom_capabilities.driver_message
local function clone_allowed_values(allowed_values)
if type(allowed_values)~="table"then return nil end
local copied={}
for index,value in ipairs(allowed_values)do copied[index]=value end
return copied
end
function custom_capabilities.resolve_range(definition,metadata)
if type(metadata)~="table"then return nil end
local default_range=type(metadata.default_range)=="table"and metadata.default_range or nil
local ranges=type(definition)=="table"and definition.presence_capability_ranges or nil
local resolved=type(ranges)=="table"and ranges[metadata.range_key]or nil
if type(resolved)~="table"then resolved=default_range end
if type(resolved)~="table"then return nil end
return{
minimum=type(resolved.minimum)=="number"and resolved.minimum or(default_range and default_range.minimum or nil),maximum=type(resolved.maximum)=="number"and resolved.maximum or(default_range and default_range.maximum or nil),step=type(resolved.step)=="number"and resolved.step or(default_range and default_range.step or nil),unit=type(resolved.unit)=="string"and resolved.unit or(default_range and default_range.unit or nil),allowed_values=type(resolved.allowed_values)=="table"and clone_allowed_values(resolved.allowed_values)or clone_allowed_values(default_range and default_range.allowed_values or nil),}
end
return custom_capabilities
