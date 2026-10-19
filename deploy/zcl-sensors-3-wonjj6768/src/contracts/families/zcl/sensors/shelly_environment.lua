local g=require"protocol.zcl"
local c=require"contracts.helpers.family"
local h=require"capabilities.events.all"
local d=require"st.zigbee.data_types"
local e,b=c.definition_registry()
local function i(m,f)
return g.cluster_attribute(64545,0,{
name=m,endpoint=1,data_type=d.Uint8,mfg_code=5264,read_only=true,read_on_configure=true,minimum_interval=60,maximum_interval=900,reportable_change=0,emit=f,
from_device=function(j)
return({[0]="dark",[1]="twilight",[2]="bright"})[j]
end,
})
end
local function a(m,k,f)
return g.cluster_attribute(64545,k,{
name=m,endpoint=1,data_type=d.Uint24,write_type=d.Uint24,mfg_code=5264,read_on_configure=true,numeric_range={minimum=0,maximum=65535,step=1,unit="lx"},emit=f,})
end
local n={
profile="sensors-illuminance-temp-humidity-battery-shelly-display",zcl_clusters={
g.temperature(),g.humidity(),i("shelly_blu_display_light_level",h.shellyBluDisplayLightLevel()),a("shelly_blu_display_dark_threshold",1,h.shellyBluDisplayDarkThreshold()),a("shelly_blu_display_bright_threshold",2,h.shellyBluDisplayBrightThreshold()),g.battery(),},}local q={
profile="safety-contact-illuminance-battery-low-handle-shelly",zcl_clusters={
g.contact(),g.shelly_handle_position(),g.battery_low(),i("shelly_blu_door_light_level",h.shellyBluDoorLightLevel()),a("shelly_blu_door_dark_threshold",1,h.shellyBluDoorDarkThreshold()),a("shelly_blu_door_bright_threshold",2,h.shellyBluDoorBrightThreshold()),g.battery(),},}local p={
profile="safety-motion-illuminance-battery-low-battery",
configure=function(o,l)
l:remove_configured_attribute(1280,2)g.bind_cluster(l,1280,o.environment_info.hub_zigbee_eui,1)
end,
zcl_clusters={
g.motion({configure_reporting=false}),i("shelly_blu_motion_light_level",h.shellyBluMotionLightLevel()),a("shelly_blu_motion_dark_threshold",1,h.shellyBluMotionDarkThreshold()),a("shelly_blu_motion_bright_threshold",2,h.shellyBluMotionBrightThreshold()),g.battery_low({configure_reporting=false}),g.battery(),g.cluster_attribute(1280,19,{
name="shelly_blu_motion_sensitivity",endpoint=1,data_type=d.Uint8,write_type=d.Uint8,read_on_configure=true,emit=h.shellyBluSensitivity(),
from_device=function(j)
return({"low","medium","high"})[j]
end,
to_device=function(j)
return({low=1,medium=2,high=3})[j]
end,
}),},}b(n,{
c.create_fingerprint("Shelly","BLU H&T Display ZB"),})b(q,{
c.create_fingerprint("Shelly","BLU DoorWindow ZB"),})b(p,{
c.create_fingerprint("Shelly","BLU Motion ZB"),})g.attach_reporting_capabilities(e,{
{1,"rpt-bbx"},{2,"rpt-bicq"},{3,"rpt-blp"},})return{
id="zcl.sensors.shelly_environment",registrations=e,}
