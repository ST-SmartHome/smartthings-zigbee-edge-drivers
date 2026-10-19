local a={}local H={"off","on","previous","switch","scene","operation_mode","command","event","disarm","arm_all_zones","emergency","toggle","battery_low","power_on_behavior","switch_mode","switchMode","operationMode","learn_ir_code","security_remote_action","heiman_rc_partial_security_action","tsfKnobStep","tsfKnobBrightnessDelta","mired","tsfKnobColorDelta","s","tsfKnobTransition","tsfKnobRate","batteryLow","normal","low","powerOnBehavior","learnIrCode","start","stop","securityRemoteAction","arm_day_zones","arm_night_zones","exit_delay","heimanRcPartialSecurityAction","arm_partial_zones","shellyOneSwitchType","momentary","candeoRd1pRemAction","pressed","double_pressed","held","released","started_rotating_left","started_rotating_right","rotating_right","rotating_left","stopped_rotating","ts0726FourScenePowerBehavior","ts0726FourSceneSwitchMode","tsfKnobAction","single","double","hold","rotate_left","rotate_right","brightness_step_up","brightness_step_down","color_temperature_step_up","color_temperature_step_down","hue_move","hue_down","hue_stop","tsfKnobMode","lastPowerResponseTime","remoteAction","learnedIrCode","irCodeToSend"}
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
a.numeric=z({{21,nil,21,"stepSize",nil,0,0,"action_step_size","Tsf Knob Step",{0,255,1,nil,nil,1}},{22,nil,22,"brightnessDelta",nil,0,0,"action_brightness_delta","Tsf Knob Brightness Delta",{-255,255,1,nil,nil,2}},{24,nil,24,"colorDelta",nil,0,0,"action_color_temperature_delta","Tsf Knob Color Delta",{-65535,65535,1,23,nil,3},nil,nil,23},{26,nil,26,"transitionTime",nil,0,0,"action_transition_time","Tsf Knob Transition",{0,6553.5,0.1,25,nil,4},nil,nil,25},{27,nil,27,"rate",nil,0,0,"action_rate","Tsf Knob Rate",{0,255,1,nil,nil,5}}},G)a.enum=z({{13,13,28,28,nil,nil,nil,13,"Battery low",{29,30},{29,30},6,7,6},{14,14,31,31,"supportedPowerOnBehaviors",nil,nil,14,"Power on behavior",{1,2,3},{1,2,3},8,9,8},{15,15,16,16,"supportedSwitchModes",nil,nil,15,"Switch mode",{4,5},{4,5},10,11,10},{6,6,17,17,"supportedOperationModes",nil,nil,6,"Operation mode",{7,8},{7,8},12,13,12},{18,18,32,32,"supportedLearnIrCodes",nil,nil,18,"Learn IR code",{33,34},{33,34},14,15,14},{19,19,35,35,"supportedSecurityRemoteActions",nil,nil,19,"Security remote action",{9,36,37,10,38,11},{9,36,37,10,38,11},16,17,16},{20,20,39,39,nil,nil,nil,20,"HEIMAN RC partial security action",{9,40,10,11},{9,40,10,11},18,19,18},{41,nil,41,"switchType",nil,nil,nil,"shelly_one_switch_type","Shelly One Switch Type",{12,42},{12,42},20,21,20},{43,nil,43,"candeoRdOnepRemAction",nil,0,0,"candeo_rd1p_rem_action","Candeo Rd1p Rem Action",{44,45,46,47,48,49,50,51,52},{44,45,46,47,48,49,50,51,52},22,23,22},{53,nil,53,"powerBehavior",nil,nil,nil,"ts0726_four_scene_power_behavior","Ts0726Four Scene Power Behavior",{1,2,3},{1,2,3},24,25,24},{54,nil,54,16,nil,nil,nil,"ts0726_four_scene_switch_mode","Ts0726Four Scene Switch Mode",{4,5},{4,5},26,27,26},{55,nil,55,"action",nil,0,0,"tsf_knob_action","Tsf Knob Action",{56,57,58,59,60,12,61,62,63,64,65,66,67},{56,57,58,59,60,12,61,62,63,64,65,66,67},28,29,28},{68,nil,68,17,nil,nil,nil,6,"Tsf Knob Mode",{7,8},{7,8},30,31,30}},K)a.text=z({{"last_power_response_time",69,69,0,0,nil,"Last power response time",64},{"remote_action",70,70,0,0,nil,"Remote action",128},{"learned_ir_code",71,71,0,0,nil,"Learned IR code",2048},{"ir_code_to_send",72,72,nil,nil,nil,"IR code to send",2048}},M)a.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
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
