local function b(c,e,module_name)
assert(type(c)=="table","Canonical catalog must return a table: "..module_name)for j in next,c do
assert(j=="id"or j=="registrations","Canonical catalog has extra key: "..module_name ..":"..tostring(j))
end
assert(c.id==e,"Canonical catalog id mismatch: "..module_name)assert(type(c.registrations)=="table","Canonical catalog registrations missing: "..module_name)return c.registrations
end
local a={}local f=require"contracts.families.zcl.switches.z2m_absorption"
for _,d in ipairs(b(f,"zcl.switches.z2m_absorption","contracts.families.zcl.switches.z2m_absorption"))do
a[#a+1]=d
end
local g=require"contracts.families.zcl.switches.shelly_em"
for _,d in ipairs(b(g,"zcl.switches.shelly_em","contracts.families.zcl.switches.shelly_em"))do
a[#a+1]=d
end
local h=require"contracts.families.zcl.switches.wave14_sber_zcl"
for _,d in ipairs(b(h,"wave14.sber.zcl_switches","contracts.families.zcl.switches.wave14_sber_zcl"))do
a[#a+1]=d
end
local i=require"contracts.families.zcl.switches.wave14_terncy_zcl"
for _,d in ipairs(b(i,"wave14.terncy.zcl_switch","contracts.families.zcl.switches.wave14_terncy_zcl"))do
a[#a+1]=d
end
return a
