local h=require"protocol.zcl"
local t=require"capabilities.events.all"
local g=require"contracts.helpers.family"
local n=require"contracts.helpers.shelly_gen4"
local l=require"st.zigbee.device_management"
local m=require"st.zigbee.data_types"
local c,d=g.definition_registry()
local function e(p)
if type(p)~="number"then return p end
return math.max(0,math.min(2147483647,p))
end
local function r(k,f,j,o)
f:send(l.build_bind_request(
f,o,k.environment_info.hub_zigbee_eui,j))
end
local i={
h.switch({
endpoint=1,minimum_interval=0,maximum_interval=65000,read_on_configure=true,}),}for a=2,3 do
local suffix=a==2 and"Two"or"Three"
local b="meter"..tostring(a)for _,s in ipairs({
h.power({
endpoint=a,component=b,minimum_interval=10,maximum_interval=65000,physical_reportable_change=5,read_on_configure=true,}),h.voltage({
endpoint=a,component=b,minimum_interval=10,maximum_interval=65000,physical_reportable_change=5,read_on_configure=true,}),h.current({
endpoint=a,component=b,minimum_interval=10,maximum_interval=65000,physical_reportable_change=0.05,read_on_configure=true,}),h.energy({
endpoint=a,component=b,minimum_interval=10,maximum_interval=65000,physical_reportable_change=0.1,read_on_configure=true,}),h.cluster_attribute(h.CLUSTER_SIMPLE_METERING,1,{
name="shelly_em_produced_energy_"..tostring(a),endpoint=a,component=b,emit=assert(t["shellyEmProducedEnergy"..suffix],"missing Shelly EM produced-energy emitter")(),data_type=m.Uint48,metering_kind="energy",from_device=e,minimum_interval=10,maximum_interval=65000,physical_reportable_change=0.1,read_on_configure=true,}),h.cluster_attribute(h.CLUSTER_ELECTRICAL_MEASUREMENT,768,{
name="shelly_em_ac_frequency_"..tostring(a),endpoint=a,component=b,emit=assert(t["shellyEmAcFrequency"..suffix],"missing Shelly EM AC-frequency emitter")(),data_type=m.Uint16,metering_kind="frequency",minimum_interval=10,maximum_interval=65000,physical_reportable_change=1,read_on_configure=true,}),})do
i[#i+1]=s
end
end
n.append_wifi_mappings(i,"shelly_em","shellyEm")local q={
profile="switches-shelly-em-gen4",zcl_clusters=i,zcl_refresh_before_read_all=n.begin_wifi_refresh,
configure=function(k,f)
r(k,f,1,h.CLUSTER_ON_OFF)for _,j in ipairs({2,3})do
r(k,f,j,h.CLUSTER_ELECTRICAL_MEASUREMENT)r(k,f,j,h.CLUSTER_SIMPLE_METERING)
end
n.refresh_wifi(f)
end,
}d(q,{
g.create_fingerprint("Shelly","EM"),})h.attach_reporting_capabilities(c,{
{1,"rpt-eqx",{["zr070200002"]="Energy",["zr070200003"]="EnergyTwo",["zr0b0403002"]="Frequency",["zr0b0403003"]="FrequencyTwo",["zr0b0405052"]="Voltage",["zr0b0405053"]="VoltageTwo",["zr0b0405082"]="Current",["zr0b0405083"]="CurrentTwo",["zr0b04050b2"]="Power",["zr0b04050b3"]="PowerTwo"}},})return{
id="zcl.switches.shelly_em",registrations=c,}
