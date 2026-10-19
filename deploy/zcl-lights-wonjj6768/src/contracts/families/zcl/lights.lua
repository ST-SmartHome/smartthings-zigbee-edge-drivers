local h=require"contracts.families.zcl.lights.lights"
local f=require"contracts.families.zcl.lights.dimmers"
local g=require"contracts.families.zcl.lights.miboxer"
local j=require"contracts.families.zcl.lights.fans"
local i=require"contracts.families.zcl.lights.retail"
local k=require"contracts.families.zcl.lights.ikea"
local c=require"contracts.families.zcl.lights.schneider"
local d={
h,f,g,j,i,k,c,}local a={}for _,e in ipairs(d)do
for _,b in ipairs(e.registrations)do
a[#a+1]=b
end
end
return{
id="zcl.lights",registrations=a,}
