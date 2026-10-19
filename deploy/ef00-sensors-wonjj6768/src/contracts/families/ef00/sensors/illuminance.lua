local g=require"protocol.tuya"
local h=require"capabilities.events.all"
local m=require"contracts.helpers.family"
local e=require"contracts.helpers.ef00"
local f=g.converter
local k,a=m.definition_registry()local d=f.lookup_from_to({
["5m"]=0,["10m"]=1,["15m"]=2,["20m"]=3,["30m"]=4,["1h"]=5,})
local function o(b,i)
if type(b)=="table"then
local p={}for r,q in pairs(b)do
p[r]=q
end
if p.query_on_configure==nil then
p.query_on_configure=true
end
a(p,i)return
end
a({
datapoints=b,query_on_configure=true,},i)
end
local l={
profile="sensors-illuminance-brightness-xfy",g.dp_enum(1,{
name="brightness_state",emit=h.xfyBrightnessState(),read_only=true,converter=f.from_only(f.lookup_value({
[0]="low",[1]="middle",[2]="high",[3]="strong",})),}),g.dp_illuminance(2,{emit=h.illuminance()}),}a(l,e.ts0601_fingerprints({
"_TZE200_yi4jtqq1","_TZE200_khx7nnka","_TZE204_khx7nnka",}))local j={
profile="sensors-illuminance-battery-brightness-slux",bind_basic_on_configure=true,g.dp_enum(1,{
name="brightness_level",emit=h.sluxBrightnessLevel(),read_only=true,converter=f.from_only(f.lookup_value({
[0]="low",[1]="middle",[2]="high",})),}),g.dp_illuminance(2,{emit=h.illuminance()}),g.dp_battery(4,{emit=h.battery()}),}a(j,e.ts0601_fingerprints({
"_TZE200_pisltm67",}))a(j,{
{manufacturer="_TYST11_pisltm67",model="isltm67"..string.char(0)},})local c={
profile="sensors-illuminance-battery-report-interval-aaeasoll",datapoints={
g.dp_illuminance(2,{emit=h.illuminance()}),g.dp_battery(4,{emit=h.battery()}),g.dp_enum(101,{
name="report_interval",emit=h.aaeasollReportInterval(),converter=d,}),},}a(c,e.ts0601_fingerprints({
"_TZE284_aaeasoll",}))local n={
profile="sensors-pressure-temp-display",datapoints={
g.dp_temperature(8,{emit=h.temperature("C"),scale=100}),g.dp_numeric(101,{name="pressure",emit=h.atmospheric_pressure(),scale=10}),g.dp_numeric(102,{name="display_brightness",emit=h.displayBrightnessPressureLevel8()}),},}a(n,e.ts0601_fingerprints({
"_TZE204_w2vunxzm",}))return{
id="ef00.sensors.illuminance",registrations=k,}
