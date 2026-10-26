local j=require"contracts.families.zcl.sensors.general"
local k=require"contracts.families.zcl.sensors.safety"
local l=require"contracts.families.zcl.sensors.sirens"
local g=require"contracts.families.zcl.sensors.repeaters"
local e=require"contracts.families.zcl.sensors.thermostats"
local b=require"contracts.families.zcl.sensors.retail_sensors"
local f=require"contracts.families.zcl.sensors.aqara_lumi"
local c=require"contracts.families.zcl.sensors.shelly_retail"
local h={
j,k,l,g,e,b,f,c}local a={}for _,i in ipairs(h)do
for _,d in ipairs(i.registrations)do
a[#a+1]=d
end
end
return{
id="zcl.sensors",registrations=a}
