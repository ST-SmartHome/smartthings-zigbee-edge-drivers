local a={}local H={"auto","1200","2400","4800","9600","19200","38400","57600","115200","230400","460800","921600","none","even","odd","1","1.5","2","lastReceivedCommand","C","easyiotIr01AcTemperature","easyiotIr01AcKfid","easyiotZl01TempUser","easyiotZl01TempValid","easyiotZl01TempClearUser","easyiot24gDetectionRange","easyiot24gPirDelay","easyiot24gUltrasonicOccupiedDelay","easyiot24gUsUnoccupiedDelay","easyiot24gMotionCoefficient","easyiot24gHoldCoefficient","easyiot24gMicroCoefficient","easyiot24gAutoCalibrationProgress","easyiotIr01AcMode","cooling","dehumidification","air_supply","heating","easyiotIr01AcWindSpeed","low","medium","high","strong","easyiotRs485BaudRate","baudRate","easyiotRs485Parity","parity","easyiotRs485StopBits","stopBits","easyiotRs232BaudRate","easyiotRs232Parity","easyiotRs232StopBits","easyiot24gWorkMode","pirOnly","radarOnly","pirRadarAnd","occupied_first","unoccupied_first","lastPowerResponseTime","easyiotIr01LastReceivedCommand","easyiotTts01LastReceivedStatus","easyiotRs485LastReceivedCommand","easyiotRs232LastReceivedCommand"}
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
a.numeric=z({{21,nil,21,"acTemperature",nil,nil,nil,"easyiot_ir01_ac_temperature","Easyiot Ir01Ac Temperature",{16,32,1,20,nil,1},nil,nil,20},{22,nil,22,"acKfid",nil,nil,nil,"easyiot_ir01_ac_kfid","Easyiot Ir01Ac Kfid",{0,1354,1,nil,nil,2}},{23,nil,23,"temporaryUser",nil,nil,nil,"easyiot_zl01_temp_user","Easyiot Zl01Temp User",{1,20,1,nil,nil,3}},{24,nil,24,"temporaryValidTimes",nil,nil,nil,"easyiot_zl01_temp_valid","Easyiot Zl01Temp Valid",{0,255,1,nil,nil,4}},{25,nil,25,"temporaryClearUser",nil,nil,nil,"easyiot_zl01_temp_clear_user","Easyiot Zl01Temp Clear User",{1,20,1,nil,nil,5}},{26,nil,26,"detectionRange",nil,nil,nil,"easyiot_24g_detection_range","Easyiot24g Detection Range",{0.7,10,0.1,nil,nil,6}},{27,nil,27,"pirDelay",nil,nil,nil,"easyiot_24g_pir_delay","Easyiot24g Pir Delay",{0,65534,1,nil,nil,7}},{28,nil,28,"ultrasonicOccupiedDelay",nil,nil,nil,"easyiot_24g_ultrasonic_occupied_delay","Easyiot24g Ultrasonic Occupied Delay",{0,65534,1,nil,nil,8}},{29,nil,29,"ultrasonicUnoccupiedDelay",nil,nil,nil,"easyiot_24g_ultrasonic_unoccupied_delay","Easyiot24g Us Unoccupied Delay",{0,65534,1,nil,nil,9}},{30,nil,30,"motionCoefficient",nil,nil,nil,"easyiot_24g_motion_coefficient","Easyiot24g Motion Coefficient",{10,200,1,nil,nil,10}},{31,nil,31,"holdCoefficient",nil,nil,nil,"easyiot_24g_hold_coefficient","Easyiot24g Hold Coefficient",{10,200,1,nil,nil,11}},{32,nil,32,"microCoefficient",nil,nil,nil,"easyiot_24g_micro_coefficient","Easyiot24g Micro Coefficient",{10,200,1,nil,nil,12}},{33,nil,33,"autoCalibrationProgress",nil,0,0,"easyiot_24g_auto_calibration_progress","Easyiot24g Auto Calibration Progress",{0,100,1,nil,nil,13}}},G)a.enum=z({{34,nil,34,"acMode",nil,nil,nil,"easyiot_ir01_ac_mode","Easyiot Ir01Ac Mode",{1,35,36,37,38},{1,35,36,37,38},14,15,14},{39,nil,39,"acWindSpeed",nil,nil,nil,"easyiot_ir01_ac_wind_speed","Easyiot Ir01Ac Wind Speed",{1,40,41,42,43},{1,40,41,42,43},16,17,16},{44,nil,44,45,nil,nil,nil,"easyiot_rs485_baud_rate","Easyiot Rs485Baud Rate",{2,3,4,5,6,7,8,9,10,11,12},{2,3,4,5,6,7,8,9,10,11,12},18,19,18},{46,nil,46,47,nil,nil,nil,"easyiot_rs485_parity","Easyiot Rs485Parity",{13,14,15},{13,14,15},20,21,20},{48,nil,48,49,nil,nil,nil,"easyiot_rs485_stop_bits","Easyiot Rs485Stop Bits",{16,17,18},{16,17,18},22,23,22},{50,nil,50,45,nil,nil,nil,"easyiot_rs232_baud_rate","Easyiot Rs232Baud Rate",{2,3,4,5,6,7,8,9,10,11,12},{2,3,4,5,6,7,8,9,10,11,12},24,25,24},{51,nil,51,47,nil,nil,nil,"easyiot_rs232_parity","Easyiot Rs232Parity",{13,14,15},{13,14,15},26,27,26},{52,nil,52,49,nil,nil,nil,"easyiot_rs232_stop_bits","Easyiot Rs232Stop Bits",{16,17,18},{16,17,18},28,29,28},{53,nil,53,"workMode",nil,nil,nil,"easyiot_24g_work_mode","Easyiot24g Work Mode",{54,55,56,57,58},{54,55,56,57,58},30,31,30}},K)a.text=z({{"last_power_response_time",59,59,0,0,nil,"Last power response time",64},{60,60,19,0,0,"easyiot_ir01_last_received_command","Easyiot Ir01Last Received Command",2048},{61,61,"lastReceivedStatus",0,0,"easyiot_tts01_last_received_status","Easyiot Tts01Last Received Status",2048},{62,62,19,0,0,"easyiot_rs485_last_received_command","Easyiot Rs485Last Received Command",2048},{63,63,19,0,0,"easyiot_rs232_last_received_command","Easyiot Rs232Last Received Command",2048}},M)a.driver_message={["attribute_name"]="driverMessage",["capability_id"]="concertmirror08464.driverMessage",["emit_name"]="driver_message",["label"]="Driver message",["maximum_length"]=512}a.by_range_key={}a.by_emit_name={}a.by_capability_id={}
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
