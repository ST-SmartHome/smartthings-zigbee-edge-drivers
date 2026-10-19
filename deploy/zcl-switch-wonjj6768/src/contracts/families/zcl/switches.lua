local f=require"contracts.families.zcl.switches.switches"
local e=require"contracts.families.zcl.switches.din_rail"
local i=require"contracts.families.zcl.switches.valves"
local b=require"contracts.families.zcl.switches.retail_switches"
local h=require"contracts.families.zcl.switches.easyiot"
local d={
f,e,i,b,h,}local a={}for _,g in ipairs(d)do
for _,c in ipairs(g.registrations)do
a[#a+1]=c
end
end
return{
id="zcl.switches",registrations=a,}
