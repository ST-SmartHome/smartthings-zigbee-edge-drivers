local a={}
local H={"off","on","normal","%","forward","reversed","back","up","opening","closing","down","s","start","fault","reset","motor_direction","stopped","set","calibration","motorDirection","ms","°","left","right","standby","success","learning","end","clickControl","clear","mode","up_delete","fully_open","fully_close","border","down_delete","remove_top_bottom","tilt","lift","stop","position_report","favoritePositionZbSm","positionBest","position_best","switch_type","manualModeEpjZbEnableDisable","windowDetectionEpjZbState","motorDirectionZbSmNormalRev","motorDirectionEpjZbSide","work_state","click_control","motorState","autoPower","reverseDirection","coverPositionReportRm28Le","coverPositionReportZm79eDt","coverPositionReportBx82Tyz1","zsm01PositionBest","zbSmCycleTime","zbSmCycleCount","zbSmActivePower","pims3028TimeTotal","timeTotal","time_total","pims3028PositionBest","pims3028AngleHorizontal","pims3028QuickCalibration","rm28leCountdownLeft","rm28leTimeTotal","rm28lePositionBest","coverOneMotorSpeed","motorSpeed","coverSixIllumination","dreamBlindsMotorSpeed","dreamBlindsFlipAngle","ts130fXbCalibTime","switchType","toggle","state","momentary","tiltModeMb60l","enable","disable","opened","closed","pending","motorDirectionZm79eDtLeftRight","motorDirectionBxTyzNormalRev","motorDirectionMbNormalRev","left_side","right_side","coverWorkPimsActual","value_123","coverWorkRmOpeningClosing","coverWorkStateZm79eDtLearning","coverCalibrationPims3028StartEnd","zsm01ControlBackMode","zsm01ClickControl","zbSmMotorState","zbSmTopLimit","zbSmBottomLimit","pims3028Mode","remove_up_down","pims3028ControlBack","pims3028AutoPower","auto_power","pims3028SituationSet","situationSet","situation_set","pims3028Fault","pims3028Border","pims3028BestTrigger","pims3028Reset","rm28leMode","morning","rm28leAutoPower","rm28leCountdown","countdown","cancel","rm28leSituationSet","rm28leMotorFault","motorFault","motor_fault","rm28leBorder","rm28leClickControl","coverThreeReverseDirection","reverse_direction","coverThreeLimit","set_up","set_down","delete_up","delete_down","delete_both","coverThreeClickControl","coverThreeMotorFault","coverOneReverseDirection","zm79eOpeningMode","openingMode","zm79eSetUpperLimit","zm79eFactoryReset","mb60lSetLimits","mb60lChildLock","childLock","child_lock","trwaxi57Calibration","trwaxi57Backlight","backlight_mode","trwaxi57MotorSteering","backward","trwaxi57ChildLock","coverSixOpening","coverSixWorkState","coverSixDirection","coverSixUpperLimit","ts0301Direction","dreamBlindsReverseDirection","zm25rxMotorDirection","zm25rxMotorState","zm25rxProgram","set_bottom","set_upper","zm25rxClickControl","upper_micro","lower_micro","cover15MotorDirection","cover15AutoPower","disabled","enabled","cover15MotorState","ts130fXbCalibration","ts130fXbDirection","ts130fXbBacklight","lastPowerResponseTime","zbSmMotorType"}
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
a.numeric=z({{55,nil,55,"coverPositionReportRmTwoEightLe",nil,0,0,41,"Cover Position Report Rm28Le",{0,100,1,4,nil,1},nil,nil,4},{56,nil,56,"coverPositionReportZmSevenNineeDt",nil,0,0,41,"Cover Position Report Zm79e Dt",{0,100,1,4,nil,2},nil,nil,4},{57,nil,57,"coverPositionReportBxEightTwoTyzOne",nil,0,0,41,"Cover Position Report Bx82Tyz1",{0,100,1,4,nil,3},nil,nil,4},{42,nil,42,42,nil,nil,nil,"favorite_position","Favorite Position Zb Sm",{0,100,1,4,nil,4},nil,nil,4},{58,nil,58,43,nil,nil,nil,44,"Zsm01Position Best",{0,100,1,4,nil,5},nil,nil,4},{59,nil,59,"cycleTime",nil,0,0,"cycle_time","Zb Sm Cycle Time",{0,999999,1,21,nil,6},nil,nil,21},{60,nil,60,"cycleCount",nil,0,0,"cycle_count","Zb Sm Cycle Count",{0,999999,1,nil,nil,7}},{61,nil,61,"activePower",nil,0,0,"active_power","Zb Sm Active Power",{0,999999,1,"mW",nil,8},nil,nil,"mW"},{62,nil,62,63,nil,0,0,64,"Pims3028Time Total",{0,600,1,12,nil,9},nil,nil,12},{65,nil,65,43,nil,nil,nil,44,"Pims3028Position Best",{1,100,1,4,nil,10},nil,nil,4},{66,nil,66,"angleHorizontal",nil,nil,nil,"angle_horizontal","Pims3028Angle Horizontal",{0,100,25,22,nil,11},nil,nil,22},{67,nil,67,"quickCalibration",nil,nil,nil,"quick_calibration","Pims3028Quick Calibration",{0,900,1,12,nil,12},nil,nil,12},{68,nil,68,"countdownLeft",nil,0,0,"countdown_left","Rm28le Countdown Left",{0,86400,1,12,nil,13},nil,nil,12},{69,nil,69,63,nil,0,0,64,"Rm28le Time Total",{0,999999,1,21,nil,14},nil,nil,21},{70,nil,70,43,nil,nil,nil,44,"Rm28le Position Best",{0,100,1,4,nil,15},nil,nil,4},{71,nil,71,72,nil,nil,nil,"motor_speed","Cover One Motor Speed",{0,255,1,nil,nil,16}},{73,nil,73,"illumination",nil,0,0,"cover_six_illumination","Cover Six Illumination",{nil,nil,nil,4,nil,17},nil,nil,4},{74,nil,74,72,nil,nil,nil,"dream_blinds_motor_speed","Dream Blinds Motor Speed",{0,255,1,nil,nil,18}},{75,nil,75,"flipAngle",nil,nil,nil,"dream_blinds_flip_angle","Dream Blinds Flip Angle",{0,180,1,22,nil,19},nil,nil,22},{76,nil,76,"calibrationTime",nil,0,0,"calibration_time","Ts130f Xb Calib Time",{nil,nil,nil,12,nil,20},nil,nil,12}},G)a.enum=z({{45,45,77,77,"supportedSwitchTypes",nil,nil,45,"Switch type",{78,79,80},{78,79,80},21,22,21},{81,nil,81,"tiltModeMbSixZerol",nil,nil,nil,"tilt_mode","Tilt Mode Mb60l",{1,2},{1,2},23,24,23},{46,nil,46,46,nil,nil,nil,"manual_mode","Manual Mode Epj Zb Enable Disable",{82,83},{82,83},25,26,25},{47,nil,47,47,nil,nil,nil,"window_detection","Window Detection Epj Zb State",{84,85,86},{84,85,86},27,28,27},{48,nil,48,48,nil,nil,nil,16,"Motor Direction Zb Sm Normal Rev",{3,6},{3,6},29,30,29},{87,nil,87,"caprayirlspeprfrwwysgxh",nil,nil,nil,16,"Motor Direction Zm79e Dt Left Right",{23,24},{23,24},31,32,31},{88,nil,88,"capnfcnnbmfkahvrbckxcij",nil,nil,nil,16,"Motor Direction Bx Tyz Normal Rev",{3,6},{3,6},33,34,33},{89,nil,89,"capultkjbczgdpnaciiuoqx",nil,nil,nil,16,"Motor Direction Mb Normal Rev",{3,6},{3,6},35,36,35},{49,nil,49,49,nil,nil,nil,16,"Motor Direction Epj Zb Side",{90,91},{90,91},37,38,37},{92,nil,92,"capcpcfsvmnkqqvbyfklqpl",nil,0,0,50,"Cover Work Pims Actual",{9,10,93},{9,10,93},39,40,39},{94,nil,94,"capmtldrdyfbzxvbdlnhcgl",nil,0,0,50,"Cover Work Rm Opening Closing",{9,10},{9,10},41,42,41},{95,nil,95,"coverWorkStateZmSevenNineeDtLearning",nil,0,0,50,"Cover Work State Zm79e Dt Learning",{25,26,27},{25,26,27},43,44,43},{96,nil,96,"capvonpjrddxpdpephlodgy",nil,nil,nil,19,"Cover Calibration Pims3028Start End",{13,28},{13,28},45,46,45},{97,nil,97,"controlBackMode",nil,nil,nil,"control_back_mode","Zsm01Control Back Mode",{5,7},{5,7},47,48,47},{98,nil,98,29,nil,nil,nil,51,"Zsm01Click Control",{8,11},{8,11},49,50,49},{99,nil,99,52,nil,0,0,"motor_state","Zb Sm Motor State",{9,17,10},{9,17,10},51,52,51},{100,nil,100,"topLimit",nil,nil,nil,"top_limit","Zb Sm Top Limit",{18,30},{18,30},53,54,53},{101,nil,101,"bottomLimit",nil,nil,nil,"bottom_limit","Zb Sm Bottom Limit",{18,30},{18,30},55,56,55},{102,nil,102,31,nil,nil,nil,31,"Pims3028Mode",{8,32,103},{8,32,103},57,58,57},{104,nil,104,"controlBack",nil,nil,nil,"control_back","Pims3028Control Back",{5,7},{5,7},59,60,59},{105,nil,105,53,nil,nil,nil,106,"Pims3028Auto Power",{1,2},{1,2},61,62,61},{107,nil,107,108,nil,0,0,109,"Pims3028Situation Set",{33,34},{33,34},63,64,63},{110,nil,110,14,nil,0,0,14,"Pims3028Fault",{3,14},{3,14},65,66,65},{111,nil,111,35,nil,nil,nil,35,"Pims3028Border",{36,37},{36,37},67,68,67},{112,nil,112,"bestTrigger",nil,nil,nil,"best_position_trigger","Pims3028Best Trigger",{1,2},{1,2},69,70,69},{113,nil,113,15,nil,nil,nil,15,"Pims3028Reset",{15},{15},71,72,71},{114,nil,114,31,nil,nil,nil,31,"Rm28le Mode",{115,"night"},{115,"night"},73,74,73},{116,nil,116,53,nil,nil,nil,106,"Rm28le Auto Power",{1,2},{1,2},75,76,75},{117,nil,117,118,nil,nil,nil,118,"Rm28le Countdown",{119,"1h","2h","3h","4h"},{119,"1h","2h","3h","4h"},77,78,77},{120,nil,120,108,nil,0,0,109,"Rm28le Situation Set",{33,34},{33,34},79,80,79},{121,nil,121,122,nil,0,0,123,"Rm28le Motor Fault",{3,14},{3,14},81,82,81},{124,nil,124,35,nil,nil,nil,35,"Rm28le Border",{8,11,32,36,37},{8,11,32,36,37},83,84,83},{125,nil,125,29,nil,nil,nil,51,"Rm28le Click Control",{8,11},{8,11},85,86,85},{126,nil,126,54,nil,nil,nil,127,"Cover Three Reverse Direction",{5,7},{5,7},87,88,87},{128,nil,128,"coverLimit",nil,nil,nil,"cover_limit","Cover Three Limit",{129,130,131,132,133},{129,130,131,132,133},89,90,89},{134,nil,134,29,nil,nil,nil,51,"Cover Three Click Control",{8,11},{8,11},91,92,91},{135,nil,135,122,nil,0,0,123,"Cover Three Motor Fault",{3,14},{3,14},93,94,93},{136,nil,136,54,nil,nil,nil,127,"Cover One Reverse Direction",{5,7},{5,7},95,96,95},{137,nil,137,138,nil,nil,nil,"opening_mode","Zm79e Opening Mode",{38,39},{38,39},97,98,97},{139,nil,139,"setUpperLimit",nil,nil,nil,"set_upper_limit","Zm79e Set Upper Limit",{13,40},{13,40},99,100,99},{140,nil,140,"factoryReset",nil,nil,nil,"factory_reset","Zm79e Factory Reset",{18},{18},101,102,101},{141,nil,141,"setLimits",nil,nil,nil,"set_limits","Mb60l Set Limits",{8,11,15},{8,11,15},103,104,103},{142,nil,142,143,nil,nil,nil,144,"Mb60l Child Lock",{1,2},{1,2},105,106,105},{145,nil,145,19,nil,nil,nil,19,"Trwaxi57Calibration",{13,28},{13,28},107,108,107},{146,nil,146,"backlight",nil,nil,nil,147,"Trwaxi57Backlight",{1,2},{1,2},109,110,109},{148,nil,148,"motorSteering",nil,nil,nil,"motor_steering","Trwaxi57Motor Steering",{5,149},{5,149},111,112,111},{150,nil,150,143,nil,nil,nil,144,"Trwaxi57Child Lock",{1,2},{1,2},113,114,113},{151,nil,151,138,nil,nil,nil,"cover_six_opening","Cover Six Opening",{38,39},{38,39},115,116,115},{152,nil,152,"workState",nil,0,0,"cover_six_work_state","Cover Six Work State",{25,26,27},{25,26,27},117,118,117},{153,nil,153,20,nil,nil,nil,"cover_six_direction","Cover Six Direction",{23,24},{23,24},119,120,119},{154,nil,154,"upperLimit",nil,nil,nil,"cover_six_upper_limit","Cover Six Upper Limit",{13,40},{13,40},121,122,121},{155,nil,155,20,nil,nil,nil,"ts0301_direction","Ts0301Direction",{5,7},{5,7},123,124,123},{156,nil,156,54,nil,nil,nil,"dream_blinds_reverse_direction","Dream Blinds Reverse Direction",{5,7},{5,7},125,126,125},{157,nil,157,20,nil,nil,nil,"zm25rx_motor_direction","Zm25rx Motor Direction",{3,6},{3,6},127,128,127},{158,nil,158,52,nil,0,0,"zm25rx_motor_state","Zm25rx Motor State",{9,10,17},{9,10,17},129,130,129},{159,nil,159,"program",nil,nil,nil,"zm25rx_program","Zm25rx Program",{160,161,15},{160,161,15},131,132,131},{162,nil,162,29,nil,nil,nil,"zm25rx_click_control","Zm25rx Click Control",{"upper",163,"lower",164},{"upper",163,"lower",164},133,134,133},{165,nil,165,20,nil,nil,nil,"cover15_motor_direction","Cover15Motor Direction",{3,6},{3,6},135,136,135},{166,nil,166,53,nil,nil,nil,"cover15_auto_power","Cover15Auto Power",{167,168},{167,168},137,138,137},{169,nil,169,52,nil,0,0,"cover15_motor_state","Cover15Motor State",{9,10,17},{9,10,17},139,140,139},{170,nil,170,19,nil,nil,nil,19,"Ts130f Xb Calibration",{2,1},{2,1},141,142,141},{171,nil,171,20,nil,nil,nil,16,"Ts130f Xb Direction",{3,6},{3,6},143,144,143},{172,nil,172,"backlightMode",nil,nil,nil,147,"Ts130f Xb Backlight",{2,1},{2,1},145,146,145}},K)a.text=z({{"last_power_response_time",173,173,0,0,nil,"Last power response time",64},{174,174,"motorType",0,0,"motor_type","Zb Sm Motor Type",32}},M)a.driver_message={attribute_name="driverMessage",capability_id="concertmirror08464.driverMessage",emit_name="driver_message",label="Driver message",maximum_length=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
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
minimum=type(h.minimum)=="number"and h.minimum or(d and d.minimum or nil),maximum=type(h.maximum)=="number"and h.maximum or(d and d.maximum or nil),step=type(h.step)=="number"and h.step or(d and d.step or nil),unit=type(h.unit)=="string"and h.unit or(d and d.unit or nil),allowed_values=type(h.allowed_values)=="table"and l(h.allowed_values)or l(d and d.allowed_values or nil)}
end
return a
