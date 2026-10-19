local g=require"protocol.zcl"
local b=require"contracts.helpers.family"
local h,a=b.definition_registry()
local function d()
return{
from=function(e)
if type(e)~="number"then
return e
end
return 100-math.max(0,math.min(100,e))
end,
to=function(e)
if type(e)~="number"then
return e
end
return 100-math.max(0,math.min(100,e))
end,
}
end
local function c()
return{
from=function(e)
if type(e)~="number"then
return e
end
if e<=0 then
return"open"
end
if e>=100 then
return"closed"
end
return"partially open"
end,
}
end
local i={
profile="covers-cover",zcl_clusters={
g.tuya_magic_packet(),g.cover_position(),g.window_shade_state(),g.cover_state(),},}local k={
profile="covers-cover-2",zcl_clusters={
g.tuya_magic_packet(),g.cover_position({endpoint=1,component="main"}),g.window_shade_state({endpoint=1,component="main"}),g.cover_state({endpoint=1,component="main"}),g.cover_position({endpoint=2,component="shade2"}),g.window_shade_state({endpoint=2,component="shade2"}),g.cover_state({endpoint=2,component="shade2"}),},}local f={
profile="covers-cover-battery",zcl_clusters={
g.cover_position({converter=d()}),g.window_shade_state({converter=c()}),g.cover_state(),g.battery(),},}a(i,b.create_fingerprints("TS130F",{
"_TZ3000_bs93npae","_TZ3000_dojqjapa","_TZ3000_8h7wgocw","_TZ3000_e3vhyirx","_TZ3000_femsaaua","_TZ3000_5iixzdo7","_TZ3000_yruungrl","_TZ3000_jwv3cwak","_TZ3000_74hsp7qy","_TZ3210_dwytrmda","_TZ3210_jrhczaaa","_TZ3000_vw8pawxa","_TZ3210_xbpt8ewc","_TZ3000_egq7y6pr","_TZ3000_fccpjz5z","_TZ3000_vd43bbfq","_TZ3000_zirycpws","_TZ3210_ol1uhvza",}))a(i,{
b.create_fingerprint("Aqara","lumi.curtain.acn04"),b.create_fingerprint("LUMI","lumi.curtain.acn04"),b.create_fingerprint("LUMI","lumi.curtain.acn018"),})a(i,b.create_fingerprints("TS130F",{
"_TZ3000_1dd0d5yi",}))a(k,b.create_fingerprints("TS130F",{
"_TZ3000_bmhwnl7s","_TZ3000_esynmmox","_TZ3000_j1xl73iw","_TZ3000_kmsbwdol","_TZ3000_l6iqph4f","_TZ3000_wvedmwyp","_TZ3000_xdo0hj1k",}))a(f,b.create_fingerprints("TS0301",{
"_TZE200_9caxna4s",}))a(f,b.create_fingerprints("TS030F",{
"_TZB000_42ha4rsc",}))a(f,{
b.create_fingerprint("IKEA of Sweden","FYRTUR block-out roller blind"),b.create_fingerprint("IKEA of Sweden","KADRILJ roller blind"),b.create_fingerprint("IKEA of Sweden","PRAKTLYSING cellular blind"),b.create_fingerprint("IKEA of Sweden","TREDANSEN block-out cellul blind"),})
local function d()
return{
from=function(e)
if type(e)~="number"then
return e
end
return 100-math.max(0,math.min(100,e))
end,
to=function(e)
if type(e)~="number"then
return e
end
return 100-math.max(0,math.min(100,e))
end,
}
end
local function c()
return{
from=function(e)
if type(e)~="number"then
return e
end
if e<=0 then
return"open"
end
if e>=100 then
return"closed"
end
return"partially open"
end,
}
end
local l={
profile="covers-cover",zcl_clusters={
g.cover_position(),g.window_shade_state(),g.cover_state(),},}local j={
profile="covers-cover-battery",zcl_clusters={
g.cover_position({converter=d()}),g.window_shade_state({converter=c()}),g.cover_state(),g.battery(),},}a({
profile="covers-cover-battery",zcl_clusters={
g.cover_position(),g.window_shade_state(),g.cover_state(),g.battery(),},},{
b.create_fingerprint("eWeLink","AM25C-1-25-ES-E-Z"),b.create_fingerprint("eWeLink","CK-MG22-Z310EE07DOOYA-01(7015)"),b.create_fingerprint("eWeLink","MYDY25Z-1"),b.create_fingerprint("eWeLink","ZM25-EAZ"),})a(l,{
b.create_fingerprint("Sunricher","HK-ZCC-A"),})a(j,{
b.create_fingerprint("Third Reality, Inc","TRZB3"),})a(j,{
b.create_fingerprint("Third Reality, Inc","3RSB015BZ"),b.create_fingerprint("Third Reality, Inc","3RSB02015Z"),})g.attach_reporting_capabilities(h,{
{1,"rpt-tci"},{2,"rpt-tci"},{3,"rpt-tci"},{4,"rpt-tuv",{["zr010200081"]="Position",["zr010200082"]="PositionTwo"}},{5,"rpt-txq"},{6,"rpt-txq"},{7,"rpt-txq"},{8,"rpt-txq"},{9,"rpt-tci"},{10,"rpt-txq"},{11,"rpt-txq"},})return{
id="zcl.covers",registrations=h,}
