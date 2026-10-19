local function b(c,e,module_name)
assert(type(c)=="table","Canonical catalog must return a table: "..module_name)for j in next,c do
assert(j=="id"or j=="registrations","Canonical catalog has extra key: "..module_name ..":"..tostring(j))
end
assert(c.id==e,"Canonical catalog id mismatch: "..module_name)assert(type(c.registrations)=="table","Canonical catalog registrations missing: "..module_name)return c.registrations
end
local a={}local f=require"contracts.families.zcl.sensors.wave19_hvac"
for _,d in ipairs(b(f,"zcl.sensors.wave19_hvac","contracts.families.zcl.sensors.wave19_hvac"))do
a[#a+1]=d
end
local g=require"contracts.families.zcl.thermostats.wave19_sber"
for _,d in ipairs(b(g,"zcl.thermostats.wave19.sber","contracts.families.zcl.thermostats.wave19_sber"))do
a[#a+1]=d
end
local h=require"contracts.families.zcl.thermostats.aqara_w500"
for _,d in ipairs(b(h,"zcl.thermostats.aqara_w500","contracts.families.zcl.thermostats.aqara_w500"))do
a[#a+1]=d
end
local i=require"contracts.families.zcl.thermostats.namron_edge"
for _,d in ipairs(b(i,"zcl.thermostats.namron_edge","contracts.families.zcl.thermostats.namron_edge"))do
a[#a+1]=d
end
return a
