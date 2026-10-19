local b=require"protocol.zcl"
local d=require"contracts.helpers.family"
local a,c=d.definition_registry()local f={
profile="lights-dimmer",zcl_clusters={
b.switch(),b.level(),},}local g={
profile="lights-color-temperature",zcl_clusters={
b.switch(),b.level(),b.color_temperature(),},}local e={
profile="lights-color",zcl_clusters={
b.switch(),b.level(),b.color_hue(),b.color_saturation(),b.color(),},}local h={
profile="lights-color-temperature-color",zcl_clusters={
b.switch(),b.level(),b.color_temperature(),b.color_hue(),b.color_saturation(),b.color(),},}c(e,{
d.create_fingerprint("_TZ3210_778drfdt","TS0503B"),})b.attach_reporting_capabilities(a,{
{1,"rpt-tot"},})return{
id="zcl.lights.miboxer",registrations=a,}
