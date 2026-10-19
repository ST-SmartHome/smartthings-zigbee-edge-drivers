local a={}
local H={"normal","reversed","ON","OFF","motorDirection","opening","closing","s","stop","set_up","set_down","delete_up","delete_down","stopped","charging","calibration","%","fully_open","fully_close","none","START","END","FORWARD","BACKWARD","delete_both","start","coverLimit","motorState","adcbziTotalTime","totalTime","adcbziOpenThreshold","adcbziCloseThreshold","adcbziCurtainStatus","m","adcbziTotalDistance","adcbziFactoryTest","tsCoverTwoFavoritePosition","favoritePosition","znUscCalibrationTime","moesSfTravelTime","ms","cover14A0TotalTime","cover14A0FavoritePosition","gm25TeqMotorDirection","adcbziWorkState","standby","adcbziSituationSet","situationSet","adcbziFault","adcbziChargingStatus","uncharged","charged","adcbziCalibration","calibrate","calibrate_reverse","blTyzMotorDirection","blTyzAutoPower","zsSrCalibration","zsSrMotorSteering","motorSteering","zcLpCharging","not_charging","zcLpAutomaticMode","zcLpSlowMode","slowMode","zcLpButtonPosition","UP","DOWN","fwjzMotorDirection","fwjzCoverLimit","tsCoverTwoMotorState","tsCoverTwoSlowMode","tsCoverTwoMotorDirection","tsCoverTwoCoverType","roman_pole","roller_blind","canopy_curtain","roman_blind","honeycomb_curtain","tsCoverTwoCoverLimit","tsCoverTwoClickControl","up","down","xSevenCalibration","finish","znUscMotorSteering","zmpOneMotorState","zmpOneMotorDirection","ercSixDirection","forward","back","ercSixRecordRf","record","ercSixClearRf","clear","moesSfCalibration","end","moesSfBacklight","backlight","on","off","moesSfDirection","limitedCoverMotorDirection","cover5PxCalibration","cover5PxBacklight","cover5PxMotorDirection","cover5PxChildLock","cover14A0MotorDirection","cover14A0MotorState","cover14A0SituationSet","fwjz16ebMotorDirection","fwjz16ebCoverLimit","lastPowerResponseTime","adcbziCustomWeekProgOne","adcbziCustomWeekProgTwo","adcbziCustomWeekProgThree","adcbziCustomWeekProgFour"}
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
a.numeric=z({{29,nil,29,30,nil,0,0,"adcbzi_total_time","Adcbzi Total Time",{nil,nil,nil,8,nil,1},nil,nil,8},{31,nil,31,"openThreshold",nil,nil,nil,"adcbzi_open_threshold","Adcbzi Open Threshold",{0,100,1,nil,nil,2}},{32,nil,32,"closeThreshold",nil,nil,nil,"adcbzi_close_threshold","Adcbzi Close Threshold",{0,100,1,nil,nil,3}},{33,nil,33,"curtainStatus",nil,nil,nil,"adcbzi_curtain_status","Adcbzi Curtain Status",{0,255,1,nil,nil,4}},{35,nil,35,"totalDistance",nil,0,0,"adcbzi_total_distance","Adcbzi Total Distance",{nil,nil,nil,34,nil,5},nil,nil,34},{36,nil,36,"factoryTest",nil,0,0,"adcbzi_factory_test","Adcbzi Factory Test",{0,100,1,nil,nil,6}},{37,nil,37,38,nil,nil,nil,"ts_cover_two_favorite_position","Ts Cover Two Favorite Position",{0,100,1,17,nil,7},nil,nil,17},{39,nil,39,"calibrationTime",nil,nil,nil,"zn_usc_calibration_time","Zn Usc Calibration Time",{0,500,1,8,nil,8},nil,nil,8},{40,nil,40,"travelTime",nil,nil,nil,"moes_sf_travel_time","Moes Sf Travel Time",{10,180,1,8,nil,9},nil,nil,8},{42,nil,42,30,nil,0,0,"cover14_a0_total_time","Cover14A0Total Time",{nil,nil,nil,41,nil,10},nil,nil,41},{43,nil,43,38,nil,nil,nil,"cover14_a0_favorite_position","Cover14A0Favorite Position",{0,100,1,17,nil,11},nil,nil,17}},G)a.enum=z({{44,nil,44,"gmTwoFiveTeqMotorDirection",nil,nil,nil,"motor_direction","Gm25Teq Motor Direction",{1,2},{1,2},12,13,12},{45,nil,45,"workState",nil,0,0,"adcbzi_work_state","Adcbzi Work State",{46,6,7},{46,6,7},14,15,14},{47,nil,47,48,nil,nil,nil,"adcbzi_situation_set","Adcbzi Situation Set",{18,19},{18,19},16,17,16},{49,nil,49,"fault",nil,0,0,"adcbzi_fault","Adcbzi Fault",{20},{20},18,19,18},{50,nil,50,"chargingStatus",nil,0,0,"adcbzi_charging_status","Adcbzi Charging Status",{20,51,15,52},{20,51,15,52},20,21,20},{53,nil,53,16,nil,nil,nil,"adcbzi_calibration","Adcbzi Calibration",{9,54,55},{9,54,55},22,23,22},{56,nil,56,5,nil,nil,nil,"bl_tyz_motor_direction","Bl Tyz Motor Direction",{1,2},{1,2},24,25,24},{57,nil,57,"autoPower",nil,nil,nil,"bl_tyz_auto_power","Bl Tyz Auto Power",{3,4},{3,4},26,27,26},{58,nil,58,16,nil,nil,nil,"zs_sr_calibration","Zs Sr Calibration",{21,22},{21,22},28,29,28},{59,nil,59,60,nil,nil,nil,"zs_sr_motor_steering","Zs Sr Motor Steering",{23,24},{23,24},30,31,30},{61,nil,61,15,nil,0,0,"zc_lp_charging","Zc Lp Charging",{15,62},{15,62},32,33,32},{63,nil,63,"automaticMode",nil,nil,nil,"zc_lp_automatic_mode","Zc Lp Automatic Mode",{3,4},{3,4},34,35,34},{64,nil,64,65,nil,nil,nil,"zc_lp_slow_mode","Zc Lp Slow Mode",{3,4},{3,4},36,37,36},{66,nil,66,"buttonPosition",nil,nil,nil,"zc_lp_button_position","Zc Lp Button Position",{67,68},{67,68},38,39,38},{69,nil,69,5,nil,nil,nil,"fwjz_motor_direction","Fwjz Motor Direction",{1,2},{1,2},40,41,40},{70,nil,70,27,nil,nil,nil,"fwjz_cover_limit","Fwjz Cover Limit",{10,11,12,13,25},{10,11,12,13,25},42,43,42},{71,nil,71,28,nil,0,0,"ts_cover_two_motor_state","Ts Cover Two Motor State",{6,7,14},{6,7,14},44,45,44},{72,nil,72,65,nil,nil,nil,"ts_cover_two_slow_mode","Ts Cover Two Slow Mode",{3,4},{3,4},46,47,46},{73,nil,73,5,nil,nil,nil,"ts_cover_two_motor_direction","Ts Cover Two Motor Direction",{1,2},{1,2},48,49,48},{74,nil,74,"coverType",nil,nil,nil,"ts_cover_two_cover_type","Ts Cover Two Cover Type",{75,76,77,78,79},{75,76,77,78,79},50,51,50},{80,nil,80,27,nil,nil,nil,"ts_cover_two_cover_limit","Ts Cover Two Cover Limit",{10,11,12,13,25},{10,11,12,13,25},52,53,52},{81,nil,81,"clickControl",nil,nil,nil,"ts_cover_two_click_control","Ts Cover Two Click Control",{82,83},{82,83},54,55,54},{84,nil,84,16,nil,nil,nil,"x_seven_calibration","X Seven Calibration",{26,85},{26,85},56,57,56},{86,nil,86,60,nil,nil,nil,"zn_usc_motor_steering","Zn Usc Motor Steering",{23,24},{23,24},58,59,58},{87,nil,87,28,nil,0,0,"zmp_one_motor_state","Zmp One Motor State",{6,7,14},{6,7,14},60,61,60},{88,nil,88,5,nil,nil,nil,"zmp_one_motor_direction","Zmp One Motor Direction",{1,2},{1,2},62,63,62},{89,nil,89,"direction",nil,nil,nil,"erc_six_direction","Erc Six Direction",{90,91},{90,91},64,65,64},{92,nil,92,"recordRf",nil,nil,nil,"erc_six_record_rf","Erc Six Record Rf",{93,9},{93,9},66,67,66},{94,nil,94,"clearRf",nil,nil,nil,"erc_six_clear_rf","Erc Six Clear Rf",{95,9},{95,9},68,69,68},{96,nil,96,16,nil,nil,nil,"moes_sf_calibration","Moes Sf Calibration",{26,97},{26,97},70,71,70},{98,nil,98,99,nil,nil,nil,"moes_sf_backlight","Moes Sf Backlight",{100,101},{100,101},72,73,72},{102,nil,102,5,nil,nil,nil,"moes_sf_direction","Moes Sf Direction",{1,2},{1,2},74,75,74},{103,nil,103,5,nil,nil,nil,"limited_cover_motor_direction","Limited Cover Motor Direction",{1,2},{1,2},76,77,76},{104,nil,104,16,nil,nil,nil,"cover5_px_calibration","Cover5Px Calibration",{21,22},{21,22},78,79,78},{105,nil,105,99,nil,nil,nil,"cover5_px_backlight","Cover5Px Backlight",{3,4},{3,4},80,81,80},{106,nil,106,5,nil,nil,nil,"cover5_px_motor_direction","Cover5Px Motor Direction",{1,2},{1,2},82,83,82},{107,nil,107,"childLock",nil,nil,nil,"cover5_px_child_lock","Cover5Px Child Lock",{3,4},{3,4},84,85,84},{108,nil,108,5,nil,nil,nil,"cover14_a0_motor_direction","Cover14A0Motor Direction",{1,2},{1,2},86,87,86},{109,nil,109,28,nil,0,0,"cover14_a0_motor_state","Cover14A0Motor State",{6,7,14},{6,7,14},88,89,88},{110,nil,110,48,nil,nil,nil,"cover14_a0_situation_set","Cover14A0Situation Set",{19,18},{19,18},90,91,90},{111,nil,111,5,nil,nil,nil,"fwjz_16eb_motor_direction","Fwjz16eb Motor Direction",{1,2},{1,2},92,93,92},{112,nil,112,27,nil,nil,nil,"fwjz_16eb_cover_limit","Fwjz16eb Cover Limit",{10,11,12,13},{10,11,12,13},94,95,94}},K)a.text=z({{"last_power_response_time",113,113,0,0,nil,"Last power response time",64},{114,114,"customWeekProgOne",nil,nil,"adcbzi_custom_week_prog_one","Adcbzi Custom Week Prog One",512},{115,115,"customWeekProgTwo",nil,nil,"adcbzi_custom_week_prog_two","Adcbzi Custom Week Prog Two",512},{116,116,"customWeekProgThree",nil,nil,"adcbzi_custom_week_prog_three","Adcbzi Custom Week Prog Three",512},{117,117,"customWeekProgFour",nil,nil,"adcbzi_custom_week_prog_four","Adcbzi Custom Week Prog Four",512}},M)a.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
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
