local c=require"contracts.families.zcl.sensors.z2m_absorption_ewelink_7037"
local i=require"contracts.families.zcl.sensors.z2m_absorption_water"
local h=require"contracts.families.zcl.sensors.z2m_absorption_heiwa"
local e=require"contracts.families.zcl.sensors.linknlink"
local b=require"contracts.families.zcl.sensors.shelly_presence"
local f={c,i,h,e,b}local a={}for _,g in ipairs(f)do
for _,d in ipairs(g.registrations)do
a[#a+1]=d
end
end
return{
id="zcl.sensors.z2m_absorption",registrations=a}
