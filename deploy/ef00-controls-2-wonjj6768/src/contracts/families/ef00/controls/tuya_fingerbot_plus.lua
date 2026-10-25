local a=require"protocol.tuya"
local j=require"protocol.zcl"
local i=require"capabilities.events.all"
local d=require"contracts.helpers.family"
local f=a.converter
local e,b=d.definition_registry()
local function c(capability_id)
return assert(i[capability_id],"missing Fingerbot Plus emitter: "..capability_id)()
end
local h={
profile="controls-tuya-fingerbot-plus",package_group="finger-robot",magic_packet=true,query_on_configure=false,time_start="off",datapoints={
a.dp_enum(101,{
name="tuya_fingerbot_mode",command_id=a.SEND_DATA,transaction=256,converter=f.lookup_from_to{click=0,switch=1,program=2},emit=c"tuyaFingerbotMode"}),a.dp_numeric(102,{
name="tuya_fingerbot_lower_limit",command_id=a.SEND_DATA,transaction=256,emit=c"tuyaFingerbotLowerLimit"}),a.dp_numeric(103,{
name="tuya_fingerbot_delay",command_id=a.SEND_DATA,transaction=256,emit=c"tuyaFingerbotDelay"}),a.dp_enum(104,{
name="tuya_fingerbot_reverse",command_id=a.SEND_DATA,transaction=256,converter=f.lookup_from_to{ON=1,OFF=0},emit=c"tuyaFingerbotReverse"}),a.dp_battery(105,{
name="battery",read_only=true,emit=i.battery()}),a.dp_numeric(106,{
name="tuya_fingerbot_upper_limit",command_id=a.SEND_DATA,transaction=256,emit=c"tuyaFingerbotUpperLimit"}),a.dp_binary(107,{
name="tuya_fingerbot_touch",command_id=a.SEND_DATA,transaction=256,converter=f.lookup_from_to{ON=true,OFF=false},emit=c"tuyaFingerbotTouch"})},zcl_clusters={
j.switch{read_only=false,emit=i.switch()}}}b(h,d.create_fingerprints("TS0001",{
"_TZ3210_dse8ogfy","_TZ3210_j4pdtz9v","_TZ3210_7vgttna6","_TZ3210_a04acm9s","_TZ3210_cm9mbpr1"}))j.attach_reporting_capabilities(e,{
{1,"rpt-txr"}})return{
id="ef00.controls.tuya_fingerbot_plus",registrations=e}
