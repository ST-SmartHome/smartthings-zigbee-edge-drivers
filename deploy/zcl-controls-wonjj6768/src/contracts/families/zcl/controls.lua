local k=require"contracts.families.zcl.controls.remotes"
local d=require"contracts.families.zcl.controls.advanced"
local l=require"contracts.families.zcl.controls.scene"
local g=require"contracts.families.zcl.controls.excellux"
local h=require"contracts.families.zcl.controls.security"
local f=require"contracts.families.zcl.controls.doorbell"
local j=require"contracts.families.zcl.controls.dimming"
local b=require"contracts.families.zcl.controls.scene_switches"
local m=require"contracts.families.zcl.controls.ir"
local e={
k,d,l,g,h,f,j,b,m,}local a={}for _,i in ipairs(e)do
for _,c in ipairs(i.registrations)do
a[#a+1]=c
end
end
return{
id="zcl.controls",registrations=a,}
