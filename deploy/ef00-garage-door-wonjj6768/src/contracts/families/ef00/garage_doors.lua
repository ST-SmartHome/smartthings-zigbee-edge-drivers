local e=require"contracts.helpers.family"
local b=require"contracts.families.ef00.garage_door_opener"
local c=require"contracts.families.ef00.garage_door_opener_countdown"
local d,a=e.definition_registry()a(b.definition,b.fingerprint_groups[1])a(b.definition,b.fingerprint_groups[2])a(
c.definition,c.fingerprint_groups[1])return{
id="ef00.garage_doors",registrations=d}
