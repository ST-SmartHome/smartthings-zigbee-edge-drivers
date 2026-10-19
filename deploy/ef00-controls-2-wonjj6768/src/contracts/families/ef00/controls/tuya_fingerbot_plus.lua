local f=require"protocol.tuya"
local j=require"protocol.zcl"
local i=require"capabilities.events.all"
local c=require"contracts.helpers.family"
local e=f.converter
local d,a=c.definition_registry()
local function b(capability_id)
return assert(i[capability_id],"missing Fingerbot Plus emitter: "..capability_id)()
end
local h={
profile="controls-tuya-fingerbot-plus",package_group="finger-robot",transport_classification="HYBRID_ZCL_EF00",z2m_converter_source="fz.on_off + tz.on_off + meta.tuyaDatapoints",wire_cluster="genOnOff+manuSpecificTuya",magic_packet=true,query_on_configure=false,time_start="off",datapoints={
f.dp_enum(101,{
name="tuya_fingerbot_mode",converter=e.lookup_from_to({click=0,switch=1,program=2}),emit=b("tuyaFingerbotMode"),}),f.dp_numeric(102,{
name="tuya_fingerbot_lower_limit",emit=b("tuyaFingerbotLowerLimit"),}),f.dp_numeric(103,{
name="tuya_fingerbot_delay",emit=b("tuyaFingerbotDelay"),}),f.dp_enum(104,{
name="tuya_fingerbot_reverse",converter=e.lookup_from_to({ON=1,OFF=0}),emit=b("tuyaFingerbotReverse"),}),f.dp_battery(105,{
name="battery",read_only=true,emit=i.battery(),}),f.dp_numeric(106,{
name="tuya_fingerbot_upper_limit",emit=b("tuyaFingerbotUpperLimit"),}),f.dp_binary(107,{
name="tuya_fingerbot_touch",converter=e.lookup_from_to({ON=true,OFF=false}),emit=b("tuyaFingerbotTouch"),}),},zcl_clusters={
j.switch({read_only=false,emit=i.switch()}),},}a(h,c.create_fingerprints("TS0001",{
"_TZ3210_dse8ogfy","_TZ3210_j4pdtz9v","_TZ3210_7vgttna6","_TZ3210_a04acm9s","_TZ3210_cm9mbpr1",}))j.attach_reporting_capabilities(d,{
{1,"rpt-txr"},})return{
id="ef00.controls.tuya_fingerbot_plus",registrations=d,}
