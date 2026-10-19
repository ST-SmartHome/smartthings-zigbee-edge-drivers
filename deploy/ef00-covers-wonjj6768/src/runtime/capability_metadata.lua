local a={}
local H={"%","off","on","normal","forward","back","up","down","reversed","opening","closing","start","fault","reset","s","set","motor_direction","ms","°","left","right","standby","success","learning","end","clickControl","stopped","clear","mode","up_delete","fully_open","fully_close","border","down_delete","remove_top_bottom","tilt","lift","stop","position_report","favoritePositionZbSm","positionBest","position_best","switch_type","manualModeEpjZbEnableDisable","windowDetectionEpjZbState","motorDirectionZbSmNormalRev","motorDirectionEpjZbSide","work_state","calibration","click_control","reverseDirection","motorDirection","coverPositionReportRm28Le","coverPositionReportZm79eDt","coverPositionReportBx82Tyz1","zsm01PositionBest","zbSmCycleTime","zbSmCycleCount","mW","zbSmActivePower","pims3028TimeTotal","timeTotal","time_total","pims3028PositionBest","pims3028AngleHorizontal","pims3028QuickCalibration","rm28leCountdownLeft","rm28leTimeTotal","rm28lePositionBest","coverOneMotorSpeed","motorSpeed","coverSixIllumination","dreamBlindsMotorSpeed","dreamBlindsFlipAngle","switchType","toggle","state","momentary","tiltModeMb60l","enable","disable","opened","closed","pending","motorDirectionZm79eDtLeftRight","motorDirectionBxTyzNormalRev","motorDirectionMbNormalRev","left_side","right_side","coverWorkPimsActual","value_123","coverWorkRmOpeningClosing","coverWorkStateZm79eDtLearning","coverCalibrationPims3028StartEnd","zsm01ControlBackMode","zsm01ClickControl","zbSmMotorState","motorState","zbSmTopLimit","zbSmBottomLimit","pims3028Mode","remove_up_down","pims3028ControlBack","pims3028AutoPower","autoPower","auto_power","pims3028SituationSet","situationSet","situation_set","pims3028Fault","pims3028Border","pims3028BestTrigger","pims3028Reset","rm28leMode","morning","night","rm28leAutoPower","rm28leCountdown","countdown","cancel","1h","2h","3h","4h","rm28leSituationSet","rm28leMotorFault","motorFault","motor_fault","rm28leBorder","rm28leClickControl","coverThreeReverseDirection","reverse_direction","coverThreeLimit","set_up","set_down","delete_up","delete_down","delete_both","coverThreeClickControl","coverThreeMotorFault","coverOneReverseDirection","zm79eOpeningMode","openingMode","zm79eSetUpperLimit","zm79eFactoryReset","mb60lSetLimits","mb60lChildLock","childLock","child_lock","trwaxi57Calibration","trwaxi57Backlight","trwaxi57MotorSteering","backward","trwaxi57ChildLock","coverSixOpening","coverSixWorkState","coverSixDirection","coverSixUpperLimit","ts0301Direction","dreamBlindsReverseDirection","zm25rxMotorDirection","zm25rxMotorState","zm25rxProgram","set_bottom","set_upper","zm25rxClickControl","upper","upper_micro","lower","lower_micro","lastPowerResponseTime","zbSmMotorType"}
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
a.numeric=z({{53,nil,53,"coverPositionReportRmTwoEightLe",nil,0,0,39,"Cover Position Report Rm28Le",{0,100,1,1,nil,1},nil,nil,1},{54,nil,54,"coverPositionReportZmSevenNineeDt",nil,0,0,39,"Cover Position Report Zm79e Dt",{0,100,1,1,nil,2},nil,nil,1},{55,nil,55,"coverPositionReportBxEightTwoTyzOne",nil,0,0,39,"Cover Position Report Bx82Tyz1",{0,100,1,1,nil,3},nil,nil,1},{40,nil,40,40,nil,nil,nil,"favorite_position","Favorite Position Zb Sm",{0,100,1,1,nil,4},nil,nil,1},{56,nil,56,41,nil,nil,nil,42,"Zsm01Position Best",{0,100,1,1,nil,5},nil,nil,1},{57,nil,57,"cycleTime",nil,0,0,"cycle_time","Zb Sm Cycle Time",{0,999999,1,18,nil,6},nil,nil,18},{58,nil,58,"cycleCount",nil,0,0,"cycle_count","Zb Sm Cycle Count",{0,999999,1,nil,nil,7}},{60,nil,60,"activePower",nil,0,0,"active_power","Zb Sm Active Power",{0,999999,1,59,nil,8},nil,nil,59},{61,nil,61,62,nil,0,0,63,"Pims3028Time Total",{0,600,1,15,nil,9},nil,nil,15},{64,nil,64,41,nil,nil,nil,42,"Pims3028Position Best",{1,100,1,1,nil,10},nil,nil,1},{65,nil,65,"angleHorizontal",nil,nil,nil,"angle_horizontal","Pims3028Angle Horizontal",{0,100,25,19,nil,11},nil,nil,19},{66,nil,66,"quickCalibration",nil,nil,nil,"quick_calibration","Pims3028Quick Calibration",{0,900,1,15,nil,12},nil,nil,15},{67,nil,67,"countdownLeft",nil,0,0,"countdown_left","Rm28le Countdown Left",{0,86400,1,15,nil,13},nil,nil,15},{68,nil,68,62,nil,0,0,63,"Rm28le Time Total",{0,999999,1,18,nil,14},nil,nil,18},{69,nil,69,41,nil,nil,nil,42,"Rm28le Position Best",{0,100,1,1,nil,15},nil,nil,1},{70,nil,70,71,nil,nil,nil,"motor_speed","Cover One Motor Speed",{0,255,1,nil,nil,16}},{72,nil,72,"illumination",nil,0,0,"cover_six_illumination","Cover Six Illumination",{nil,nil,nil,1,nil,17},nil,nil,1},{73,nil,73,71,nil,nil,nil,"dream_blinds_motor_speed","Dream Blinds Motor Speed",{0,255,1,nil,nil,18}},{74,nil,74,"flipAngle",nil,nil,nil,"dream_blinds_flip_angle","Dream Blinds Flip Angle",{0,180,1,19,nil,19},nil,nil,19}},G)a.enum=z({{43,43,75,75,"supportedSwitchTypes",nil,nil,43,"Switch type",{76,77,78},{76,77,78},20,21,20},{79,nil,79,"tiltModeMbSixZerol",nil,nil,nil,"tilt_mode","Tilt Mode Mb60l",{2,3},{2,3},22,23,22},{44,nil,44,44,nil,nil,nil,"manual_mode","Manual Mode Epj Zb Enable Disable",{80,81},{80,81},24,25,24},{45,nil,45,45,nil,nil,nil,"window_detection","Window Detection Epj Zb State",{82,83,84},{82,83,84},26,27,26},{46,nil,46,46,nil,nil,nil,17,"Motor Direction Zb Sm Normal Rev",{4,9},{4,9},28,29,28},{85,nil,85,"caprayirlspeprfrwwysgxh",nil,nil,nil,17,"Motor Direction Zm79e Dt Left Right",{20,21},{20,21},30,31,30},{86,nil,86,"capnfcnnbmfkahvrbckxcij",nil,nil,nil,17,"Motor Direction Bx Tyz Normal Rev",{4,9},{4,9},32,33,32},{87,nil,87,"capultkjbczgdpnaciiuoqx",nil,nil,nil,17,"Motor Direction Mb Normal Rev",{4,9},{4,9},34,35,34},{47,nil,47,47,nil,nil,nil,17,"Motor Direction Epj Zb Side",{88,89},{88,89},36,37,36},{90,nil,90,"capcpcfsvmnkqqvbyfklqpl",nil,0,0,48,"Cover Work Pims Actual",{10,11,91},{10,11,91},38,39,38},{92,nil,92,"capmtldrdyfbzxvbdlnhcgl",nil,0,0,48,"Cover Work Rm Opening Closing",{10,11},{10,11},40,41,40},{93,nil,93,"coverWorkStateZmSevenNineeDtLearning",nil,0,0,48,"Cover Work State Zm79e Dt Learning",{22,23,24},{22,23,24},42,43,42},{94,nil,94,"capvonpjrddxpdpephlodgy",nil,nil,nil,49,"Cover Calibration Pims3028Start End",{12,25},{12,25},44,45,44},{95,nil,95,"controlBackMode",nil,nil,nil,"control_back_mode","Zsm01Control Back Mode",{5,6},{5,6},46,47,46},{96,nil,96,26,nil,nil,nil,50,"Zsm01Click Control",{7,8},{7,8},48,49,48},{97,nil,97,98,nil,0,0,"motor_state","Zb Sm Motor State",{10,27,11},{10,27,11},50,51,50},{99,nil,99,"topLimit",nil,nil,nil,"top_limit","Zb Sm Top Limit",{16,28},{16,28},52,53,52},{100,nil,100,"bottomLimit",nil,nil,nil,"bottom_limit","Zb Sm Bottom Limit",{16,28},{16,28},54,55,54},{101,nil,101,29,nil,nil,nil,29,"Pims3028Mode",{7,30,102},{7,30,102},56,57,56},{103,nil,103,"controlBack",nil,nil,nil,"control_back","Pims3028Control Back",{5,6},{5,6},58,59,58},{104,nil,104,105,nil,nil,nil,106,"Pims3028Auto Power",{2,3},{2,3},60,61,60},{107,nil,107,108,nil,0,0,109,"Pims3028Situation Set",{31,32},{31,32},62,63,62},{110,nil,110,13,nil,0,0,13,"Pims3028Fault",{4,13},{4,13},64,65,64},{111,nil,111,33,nil,nil,nil,33,"Pims3028Border",{34,35},{34,35},66,67,66},{112,nil,112,"bestTrigger",nil,nil,nil,"best_position_trigger","Pims3028Best Trigger",{2,3},{2,3},68,69,68},{113,nil,113,14,nil,nil,nil,14,"Pims3028Reset",{14},{14},70,71,70},{114,nil,114,29,nil,nil,nil,29,"Rm28le Mode",{115,116},{115,116},72,73,72},{117,nil,117,105,nil,nil,nil,106,"Rm28le Auto Power",{2,3},{2,3},74,75,74},{118,nil,118,119,nil,nil,nil,119,"Rm28le Countdown",{120,121,122,123,124},{120,121,122,123,124},76,77,76},{125,nil,125,108,nil,0,0,109,"Rm28le Situation Set",{31,32},{31,32},78,79,78},{126,nil,126,127,nil,0,0,128,"Rm28le Motor Fault",{4,13},{4,13},80,81,80},{129,nil,129,33,nil,nil,nil,33,"Rm28le Border",{7,8,30,34,35},{7,8,30,34,35},82,83,82},{130,nil,130,26,nil,nil,nil,50,"Rm28le Click Control",{7,8},{7,8},84,85,84},{131,nil,131,51,nil,nil,nil,132,"Cover Three Reverse Direction",{5,6},{5,6},86,87,86},{133,nil,133,"coverLimit",nil,nil,nil,"cover_limit","Cover Three Limit",{134,135,136,137,138},{134,135,136,137,138},88,89,88},{139,nil,139,26,nil,nil,nil,50,"Cover Three Click Control",{7,8},{7,8},90,91,90},{140,nil,140,127,nil,0,0,128,"Cover Three Motor Fault",{4,13},{4,13},92,93,92},{141,nil,141,51,nil,nil,nil,132,"Cover One Reverse Direction",{5,6},{5,6},94,95,94},{142,nil,142,143,nil,nil,nil,"opening_mode","Zm79e Opening Mode",{36,37},{36,37},96,97,96},{144,nil,144,"setUpperLimit",nil,nil,nil,"set_upper_limit","Zm79e Set Upper Limit",{12,38},{12,38},98,99,98},{145,nil,145,"factoryReset",nil,nil,nil,"factory_reset","Zm79e Factory Reset",{16},{16},100,101,100},{146,nil,146,"setLimits",nil,nil,nil,"set_limits","Mb60l Set Limits",{7,8,14},{7,8,14},102,103,102},{147,nil,147,148,nil,nil,nil,149,"Mb60l Child Lock",{2,3},{2,3},104,105,104},{150,nil,150,49,nil,nil,nil,49,"Trwaxi57Calibration",{12,25},{12,25},106,107,106},{151,nil,151,"backlight",nil,nil,nil,"backlight_mode","Trwaxi57Backlight",{2,3},{2,3},108,109,108},{152,nil,152,"motorSteering",nil,nil,nil,"motor_steering","Trwaxi57Motor Steering",{5,153},{5,153},110,111,110},{154,nil,154,148,nil,nil,nil,149,"Trwaxi57Child Lock",{2,3},{2,3},112,113,112},{155,nil,155,143,nil,nil,nil,"cover_six_opening","Cover Six Opening",{36,37},{36,37},114,115,114},{156,nil,156,"workState",nil,0,0,"cover_six_work_state","Cover Six Work State",{22,23,24},{22,23,24},116,117,116},{157,nil,157,52,nil,nil,nil,"cover_six_direction","Cover Six Direction",{20,21},{20,21},118,119,118},{158,nil,158,"upperLimit",nil,nil,nil,"cover_six_upper_limit","Cover Six Upper Limit",{12,38},{12,38},120,121,120},{159,nil,159,52,nil,nil,nil,"ts0301_direction","Ts0301Direction",{5,6},{5,6},122,123,122},{160,nil,160,51,nil,nil,nil,"dream_blinds_reverse_direction","Dream Blinds Reverse Direction",{5,6},{5,6},124,125,124},{161,nil,161,52,nil,nil,nil,"zm25rx_motor_direction","Zm25rx Motor Direction",{4,9},{4,9},126,127,126},{162,nil,162,98,nil,0,0,"zm25rx_motor_state","Zm25rx Motor State",{10,11,27},{10,11,27},128,129,128},{163,nil,163,"program",nil,nil,nil,"zm25rx_program","Zm25rx Program",{164,165,14},{164,165,14},130,131,130},{166,nil,166,26,nil,nil,nil,"zm25rx_click_control","Zm25rx Click Control",{167,168,169,170},{167,168,169,170},132,133,132}},K)a.text=z({{"last_power_response_time",171,171,0,0,nil,"Last power response time",64},{172,172,"motorType",0,0,"motor_type","Zb Sm Motor Type",32}},M)a.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
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
