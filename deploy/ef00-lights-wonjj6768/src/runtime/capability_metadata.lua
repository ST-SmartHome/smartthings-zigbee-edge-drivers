local custom_capabilities={}
local strings={"s","countdown_timer","countdownTimer","countdownTimerRange","Countdown timer","min_brightness","minimumBrightness","minBrightness","minBrightnessRange","Minimum brightness","max_brightness","maximumBrightness","maxBrightness","maxBrightnessRange","Maximum brightness","%","zdmsOneMinimumBrightness","zdms161_minimum_brightness","Zdms One Minimum Brightness","zdmsOneMaximumBrightness","zdms161_maximum_brightness","Zdms One Maximum Brightness","zdmsOneCountdown","countdown","zdms161_countdown","Zdms One Countdown","zdmsTwoMinimumBrightness","zdms162_minimum_brightness","Zdms Two Minimum Brightness","zdmsTwoMaximumBrightness","zdms162_maximum_brightness","Zdms Two Maximum Brightness","zdmsTwoCountdown","zdms162_countdown","Zdms Two Countdown","countdownTsOneTenHours","Countdown Ts One Ten Hours","ef00Ts0601MinimumBrightness","efTsMinBrightness","Ef00Ts0601Minimum Brightness","ef00Ts0601MaximumBrightness","efTsMaxBrightness","Ef00Ts0601Maximum Brightness","whpb9ytsMaxBrightness","Whpb9yts Max Brightness","whpb9ytsCountdown","Whpb9yts Countdown","p0gzbqctMinBrightness","P0gzbqct Min Brightness","dcnsggvzMinBrightness","Dcnsggvz Min Brightness","dcnsggvzMaxBrightness","Dcnsggvz Max Brightness","dcnsggvzCountdown","Dcnsggvz Countdown","dimmer2gMinBrightnessCh1","Dimmer2g Min Brightness Ch1","dimmer2gMaxBrightnessCh1","Dimmer2g Max Brightness Ch1","dimmer2gCountdownCh1","Dimmer2g Countdown Ch1","dimmer2gMinBrightnessCh2","Dimmer2g Min Brightness Ch2","dimmer2gMaxBrightnessCh2","Dimmer2g Max Brightness Ch2","dimmer2gCountdownCh2","Dimmer2g Countdown Ch2","dimmer3gMinBrightnessCh1","Dimmer3g Min Brightness Ch1","dimmer3gMaxBrightnessCh1","Dimmer3g Max Brightness Ch1","dimmer3gCountdownCh1","Dimmer3g Countdown Ch1","dimmer3gMinBrightnessCh2","Dimmer3g Min Brightness Ch2","dimmer3gMaxBrightnessCh2","Dimmer3g Max Brightness Ch2","dimmer3gCountdownCh2","Dimmer3g Countdown Ch2","dimmer3gMinBrightnessCh3","Dimmer3g Min Brightness Ch3","dimmer3gMaxBrightnessCh3","Dimmer3g Max Brightness Ch3","dimmer3gCountdownCh3","Dimmer3g Countdown Ch3","dimmer3gBacklightBrightness","backlightBrightness","backlight_brightness","Dimmer3g Backlight Brightness","fanSwitchR32FanSpeed","fanSpeed","fan_speed","Fan Switch R32Fan Speed","fanSwitchR32Countdown","Fan Switch R32Countdown","fanLightLawxFanSpeed","Fan Light Lawx Fan Speed","fanDimmerBqlMinimumSpeed","minimumSpeed","minimum_speed","Fan Dimmer Bql Minimum Speed","h","fanCeilingZ5jzCountdownHours","countdownHours","countdown_hours","Fan Ceiling Z5jz Countdown Hours","ionDimmerMin","ion_min_brightness","Ion Dimmer Min","ionDimmerMax","ion_max_brightness","Ion Dimmer Max","ionDimmerCountdown","ion_countdown","Ion Dimmer Countdown","indicator_mode","indicatorMode","supportedIndicatorModes","Indicator mode","off","off/on","on/off","on","power_on_behavior","powerOnBehavior","supportedPowerOnBehaviors","Power on behavior","previous","switch_type","switchType","supportedSwitchTypes","Switch type","toggle","state","momentary","light_type","lightType","supportedLightTypes","Light type","led","incandescent","halogen","zdmsOneSwitchType","zdms161_switch_type","Zdms One Switch Type","zdmsOnePowerOnBehavior","zdms161_power_on_behavior","Zdms One Power On Behavior","zdmsTwoSwitchType","zdms162_switch_type","Zdms Two Switch Type","zdmsTwoPowerOnBehavior","zdms162_power_on_behavior","Zdms Two Power On Behavior","la2c2uo9BacklightMode","backlightMode","la2c2uo9_backlight_mode","La2c2uo9Backlight Mode","normal","inverted","whpb9ytsLightType","Whpb9yts Light Type","whpb9ytsPowerOnBehavior","Whpb9yts Power On Behavior","whpb9ytsBacklightMode","backlight_mode","Whpb9yts Backlight Mode","qzaing2gBacklightMode","Qzaing2g Backlight Mode","qzaing2gChildLock","childLock","child_lock","Qzaing2g Child Lock","unlocked","locked","p0gzbqctLightType","P0gzbqct Light Type","p0gzbqctIndicatorMode","P0gzbqct Indicator Mode","none","relay","pos","dcnsggvzLightType","Dcnsggvz Light Type","dcnsggvzPowerOnBehavior","Dcnsggvz Power On Behavior","dcnsggvzSwitchType","Dcnsggvz Switch Type","ts0601LightPowerOnBehavior","Ts0601Light Power On Behavior","dimmer2gLightTypeCh1","Dimmer2g Light Type Ch1","dimmer2gLightTypeCh2","Dimmer2g Light Type Ch2","dimmer2gPowerOnBehavior","Dimmer2g Power On Behavior","dimmer3gLightTypeCh1","Dimmer3g Light Type Ch1","dimmer3gLightTypeCh2","Dimmer3g Light Type Ch2","dimmer3gLightTypeCh3","Dimmer3g Light Type Ch3","dimmer3gPowerOnBehavior","Dimmer3g Power On Behavior","dimmer3gBacklightMode","Dimmer3g Backlight Mode","dimmer3gBacklightColor","backlightColor","backlight_color","Dimmer3g Backlight Color","red","blue","green","white","yellow","magenta","cyan","warm_white","fanSwitchR32PowerOnBehavior","Fan Switch R32Power On Behavior","fanLightHmqzPowerOnBehavior","Fan Light Hmqz Power On Behavior","fanDimmerBqlPowerOnBehavior","Fan Dimmer Bql Power On Behavior","fanDimmerBqlIndicator","indicator","Fan Dimmer Bql Indicator","off_on","fanDimmerBqlBacklight","backlight","Fan Dimmer Bql Backlight","fanDimmerBqlChildLock","Fan Dimmer Bql Child Lock","fanCeilingZ5jzPowerOnBehavior","Fan Ceiling Z5jz Power On Behavior","restore","fanCeilingZ5jzLightMode","lightMode","light_mode","Fan Ceiling Z5jz Light Mode","tsDimmerBacklight","ts_dimmer_backlight","Ts Dimmer Backlight","ionDimmerPowerOn","ion_power_on","Ion Dimmer Power On","last_power_response_time","lastPowerResponseTime","Last power response time"}
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
custom_capabilities.numeric=build({{2,2,3,3,4,nil,nil,2,5,{0,43200,1,1,nil,1,nil},0,43200,1},{6,6,7,8,9,nil,nil,6,10,{1,1000,1,nil,nil,2,nil},1,1000,nil},{11,11,12,13,14,nil,nil,11,15,{1,1000,1,nil,nil,3,nil},1,1000,nil},{17,nil,17,7,nil,nil,nil,18,19,{0,100,1,16,nil,4,nil},nil,nil,16},{20,nil,20,12,nil,nil,nil,21,22,{0,100,1,16,nil,5,nil},nil,nil,16},{23,nil,23,24,nil,nil,nil,25,26,{0,43200,1,1,nil,6,nil},nil,nil,1},{27,nil,27,7,nil,nil,nil,28,29,{0,100,1,16,nil,7,nil},nil,nil,16},{30,nil,30,12,nil,nil,nil,31,32,{0,100,1,16,nil,8,nil},nil,nil,16},{33,nil,33,24,nil,nil,nil,34,35,{0,43200,1,1,nil,9,nil},nil,nil,1},{36,nil,36,36,nil,nil,nil,2,37,{0,43200,1,1,nil,10,nil},nil,nil,1},{38,nil,38,39,nil,nil,nil,6,40,{0,1000,1,nil,nil,11,nil},nil,nil,nil},{41,nil,41,42,nil,nil,nil,11,43,{0,1000,1,nil,nil,12,nil},nil,nil,nil},{44,nil,44,13,nil,nil,nil,11,45,{0,1000,1,nil,nil,13,nil},nil,nil,nil},{46,nil,46,24,nil,nil,nil,24,47,{0,43200,1,1,nil,14,nil},nil,nil,1},{48,nil,48,8,nil,nil,nil,6,49,{0,1000,1,nil,nil,15,nil},nil,nil,nil},{50,nil,50,8,nil,nil,nil,6,51,{0,1000,1,nil,nil,16,nil},nil,nil,nil},{52,nil,52,13,nil,nil,nil,11,53,{0,1000,1,nil,nil,17,nil},nil,nil,nil},{54,nil,54,24,nil,nil,nil,24,55,{0,43200,1,1,nil,18,nil},nil,nil,1},{56,nil,56,8,nil,nil,nil,6,57,{0,1000,1,nil,nil,19,nil},nil,nil,nil},{58,nil,58,13,nil,nil,nil,11,59,{0,1000,1,nil,nil,20,nil},nil,nil,nil},{60,nil,60,24,nil,nil,nil,24,61,{0,43200,1,1,nil,21,nil},nil,nil,1},{62,nil,62,8,nil,nil,nil,6,63,{0,1000,1,nil,nil,22,nil},nil,nil,nil},{64,nil,64,13,nil,nil,nil,11,65,{0,1000,1,nil,nil,23,nil},nil,nil,nil},{66,nil,66,24,nil,nil,nil,24,67,{0,43200,1,1,nil,24,nil},nil,nil,1},{68,nil,68,8,nil,nil,nil,6,69,{0,1000,1,nil,nil,25,nil},nil,nil,nil},{70,nil,70,13,nil,nil,nil,11,71,{0,1000,1,nil,nil,26,nil},nil,nil,nil},{72,nil,72,24,nil,nil,nil,24,73,{0,43200,1,1,nil,27,nil},nil,nil,1},{74,nil,74,8,nil,nil,nil,6,75,{0,1000,1,nil,nil,28,nil},nil,nil,nil},{76,nil,76,13,nil,nil,nil,11,77,{0,1000,1,nil,nil,29,nil},nil,nil,nil},{78,nil,78,24,nil,nil,nil,24,79,{0,43200,1,1,nil,30,nil},nil,nil,1},{80,nil,80,8,nil,nil,nil,6,81,{0,1000,1,nil,nil,31,nil},nil,nil,nil},{82,nil,82,13,nil,nil,nil,11,83,{0,1000,1,nil,nil,32,nil},nil,nil,nil},{84,nil,84,24,nil,nil,nil,24,85,{0,43200,1,1,nil,33,nil},nil,nil,1},{86,nil,86,87,nil,nil,nil,88,89,{0,1000,1,nil,nil,34,nil},nil,nil,nil},{90,nil,90,91,nil,nil,nil,92,93,{1,5,1,nil,nil,35,nil},nil,nil,nil},{94,nil,94,24,nil,nil,nil,24,95,{0,43200,1,1,nil,36,nil},nil,nil,1},{96,nil,96,91,nil,nil,nil,92,97,{1,5,1,nil,nil,37,nil},nil,nil,nil},{98,nil,98,99,nil,nil,nil,100,101,{0,100,1,16,nil,38,nil},nil,nil,16},{103,nil,103,104,nil,nil,nil,105,106,{0.25,12,0.25,102,nil,39,nil},nil,nil,102},{107,nil,107,7,nil,nil,nil,108,109,{0,254,1,nil,nil,40,nil},nil,nil,nil},{110,nil,110,12,nil,nil,nil,111,112,{0,254,1,nil,nil,41,nil},nil,nil,nil},{113,nil,113,24,nil,nil,nil,114,115,{0,43200,1,1,nil,42,nil},nil,nil,1}},numeric)
custom_capabilities.enum=build({{116,116,117,117,118,nil,nil,116,119,{120,121,122,123},{120,121,122,123},43,44,43},{124,124,125,125,126,nil,nil,124,127,{120,123,128},{120,123,128},45,46,45},{129,129,130,130,131,nil,nil,129,132,{133,134,135},{133,134,135},47,48,47},{136,136,137,137,138,nil,nil,136,139,{140,141,142},{140,141,142},49,50,49},{143,nil,143,130,nil,nil,nil,144,145,{133,134,135},{133,134,135},51,52,51},{146,nil,146,125,nil,nil,nil,147,148,{120,123,128},{120,123,128},53,54,53},{149,nil,149,130,nil,nil,nil,150,151,{133,134,135},{133,134,135},55,56,55},{152,nil,152,125,nil,nil,nil,153,154,{120,123,128},{120,123,128},57,58,57},{155,nil,155,156,nil,nil,nil,157,158,{120,159,160},{120,159,160},59,60,59},{161,nil,161,137,nil,nil,nil,136,162,{140,141,142},{140,141,142},61,62,61},{163,nil,163,125,nil,nil,nil,124,164,{120,123,128},{120,123,128},63,64,63},{165,nil,165,156,nil,nil,nil,166,167,{120,159,160},{120,159,160},65,66,65},{168,nil,168,156,nil,nil,nil,166,169,{120,123},{120,123},67,68,67},{170,nil,170,171,nil,nil,nil,172,173,{174,175},{174,175},69,70,69},{176,nil,176,137,nil,nil,nil,136,177,{140,141,142},{140,141,142},71,72,71},{178,nil,178,117,nil,nil,nil,116,179,{180,181,182},{180,181,182},73,74,73},{183,nil,183,137,nil,nil,nil,136,184,{140,141,142},{140,141,142},75,76,75},{185,nil,185,125,nil,nil,nil,124,186,{120,123,128},{120,123,128},77,78,77},{187,nil,187,130,nil,nil,nil,129,188,{133,134,135},{133,134,135},79,80,79},{189,nil,189,125,nil,nil,nil,124,190,{120,123,128},{120,123,128},81,82,81},{191,nil,191,137,nil,nil,nil,136,192,{140,141,142},{140,141,142},83,84,83},{193,nil,193,137,nil,nil,nil,136,194,{140,141,142},{140,141,142},85,86,85},{195,nil,195,125,nil,nil,nil,124,196,{120,123,128},{120,123,128},87,88,87},{197,nil,197,137,nil,nil,nil,136,198,{140,141,142},{140,141,142},89,90,89},{199,nil,199,137,nil,nil,nil,136,200,{140,141,142},{140,141,142},91,92,91},{201,nil,201,137,nil,nil,nil,136,202,{140,141,142},{140,141,142},93,94,93},{203,nil,203,125,nil,nil,nil,124,204,{120,123,128},{120,123,128},95,96,95},{205,nil,205,156,nil,nil,nil,166,206,{120,159,160},{120,159,160},97,98,97},{207,nil,207,208,nil,nil,nil,209,210,{211,212,213,214,215,216,217,218},{211,212,213,214,215,216,217,218},99,100,99},{219,nil,219,125,nil,nil,nil,124,220,{120,123},{120,123},101,102,101},{221,nil,221,125,nil,nil,nil,124,222,{120,123},{120,123},103,104,103},{223,nil,223,125,nil,nil,nil,124,224,{120,123,128},{120,123,128},105,106,105},{225,nil,225,226,nil,nil,nil,116,227,{120,228,123},{120,228,123},107,108,107},{229,nil,229,230,nil,nil,nil,230,231,{120,123},{120,123},109,110,109},{232,nil,232,171,nil,nil,nil,172,233,{120,123},{120,123},111,112,111},{234,nil,234,125,nil,nil,nil,124,235,{120,123,236},{120,123,236},113,114,113},{237,nil,237,238,nil,nil,nil,239,240,{180,181,182},{180,181,182},115,116,115},{241,nil,241,230,nil,nil,nil,242,243,{120,159,160},{120,159,160},117,118,117},{244,nil,244,125,nil,nil,nil,245,246,{120,123,128},{120,123,128},119,120,119}},enum)
custom_capabilities.text=build({{247,248,248,0,0,nil,249,64}},text)
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
