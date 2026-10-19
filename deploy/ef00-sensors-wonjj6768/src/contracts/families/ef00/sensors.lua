local b=require"contracts.families.ef00.sensors.temp_humidity"
local i=require"contracts.families.ef00.sensors.soil"
local e=require"contracts.families.ef00.sensors.air_quality"
local c=require"contracts.families.ef00.sensors.liquid_level"
local f=require"contracts.families.ef00.sensors.illuminance"
local g={
b,i,e,c,f,}local a={}for _,h in ipairs(g)do
for _,d in ipairs(h.registrations)do
a[#a+1]=d
end
end
return{
id="ef00.sensors",registrations=a,}
