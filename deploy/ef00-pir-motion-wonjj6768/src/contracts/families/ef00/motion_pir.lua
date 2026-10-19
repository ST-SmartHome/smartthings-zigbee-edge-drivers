local e=require"contracts.families.ef00.motion.pir"
local b=require"contracts.families.ef00.lincukoo_szlm04u"
local c=require"contracts.families.ef00.aoyan_ay_204z"
local a={}for _,d in ipairs(e.registrations)do
a[#a+1]=d
end
a[#a+1]=b.definition
a[#a+1]=c.definition
return{
id="ef00.motion_pir",registrations=a,}
