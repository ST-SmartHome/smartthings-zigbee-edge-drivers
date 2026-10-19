local function s(B)
local p=require"capabilities.events.all"
local K=require"st.zigbee.data_types"
local G=require"st.zigbee.constants"
local I=require"st.utils.safe_xy_to_hsv"
local function r(g,F)
if type(g)~="table"then
g={}
end
if type(F)~="table"then
return g
end
for D,b in pairs(F)do
g[D]=b
end
return g
end
local function n(g,e)
if type(g)~="table"or type(e)~="table"then
return g
end
for D,b in pairs(e)do
if g[D]==nil then
g[D]=b
end
end
return g
end
local function m(f,l)
local h={}if type(f)=="string"then
h.name=f
else
r(h,f)
end
r(h,l)return h
end
local function v(L,t,A,C)
local o={}for D,b in pairs(L)do
o[b]=D
end
if type(C)=="table"then
for J,g in pairs(C)do
if o[g]~=nil then
o[J]=o[g]
end
end
end
return{
from=function(b)
local u=L[b]if u~=nil then
return u
end
if t~=nil then
return t
end
return b
end,
to=function(b)
local u=o[b]if u~=nil then
return u
end
if A~=nil then
return A
end
return b
end,
}
end
local function q()
return v({
[0]="off",[1]="auto",[3]="cool",[4]="heat",[5]="emergency heat",})
end
local function k()
return{
from=function(b)
local i=b
if type(b)=="table"then
if type(b.is_heat_on_set)=="function"and(b:is_heat_on_set()or(type(b.is_heat_second_stage_on_set)=="function"and b:is_heat_second_stage_on_set()))then
return"heating"
end
if type(b.is_cool_on_set)=="function"and(b:is_cool_on_set()or(type(b.is_cool_second_stage_on_set)=="function"and b:is_cool_second_stage_on_set()))then
return"cooling"
end
if type(b.is_fan_on_set)=="function"and(
b:is_fan_on_set()or
(type(b.is_fan_second_stage_on_set)=="function"and b:is_fan_second_stage_on_set())or
(type(b.is_fan_third_stage_on_set)=="function"and b:is_fan_third_stage_on_set())
)then
return"fan only"
end
i=b.value
end
if type(i)~="number"then
return i
end
if bit32.band(i,1)~=0 or bit32.band(i,8)~=0 then
return"heating"
end
if bit32.band(i,2)~=0 or bit32.band(i,16)~=0 then
return"cooling"
end
if bit32.band(i,4)~=0 or bit32.band(i,32)~=0 or bit32.band(i,64)~=0 then
return"fan only"
end
return"idle"
end,
}
end
local function a(z,y,w)
return{
minimum_interval=z,maximum_interval=y,reportable_change=w,read_on_configure=true,}
end
local function c(...)
local E={}for _,e in ipairs({...})do
n(E,e)
end
return E
end
local function d(M,H,x)
B[M]=function(f,l)
local h=m(f,l)local j=h.configure_reporting
local e=x(h)h.configure_reporting=nil
if j==false then
e.minimum_interval=nil
e.maximum_interval=nil
e.reportable_change=nil
e.physical_reportable_change=nil
e.reporting_defaults=nil
end
n(h,e)return H(h)
end
end
d("humidity",B.relative_humidity,function()
return c(
{
emit=p.humidity(),scale=100,},a(30,300,100))
end)
d("battery",B.power_configuration_battery,function()
return c(
{
emit=p.battery(),scale=2,},a(300,21600,2))
end)
d("switch",B.on_off,function(l)
local j=l.configure_reporting
l.configure_reporting=nil
if j==false then
return{
emit=p.switch(),}
end
return c(
{
emit=p.switch(),},a(0,300,nil))
end)
d("local_temperature",B.thermostat_local_temperature,function()
return c(
{
emit=p.temperature("C"),scale=100,},a(30,300,50))
end)
d("heating_setpoint",B.thermostat_heating_setpoint,function()
return c(
{
name="current_heating_setpoint",emit=p.heating_setpoint("C"),scale=100,},a(30,300,50))
end)
d("system_mode",B.thermostat_system_mode,function()
return c(
{
emit=p.thermostat_mode(),converter=q(),},a(1,300,nil))
end)
d("cooling_setpoint",B.thermostat_cooling_setpoint,function()
return c(
{
name="current_cooling_setpoint",emit=p.cooling_setpoint("C"),scale=100,},a(30,300,50))
end)
d("thermostat_operating_state",B.thermostat_running_state,function()
return c(
{
name="thermostat_operating_state",emit=p.thermostat_operating_state(),converter=k(),},a(1,300,nil))
end)
end
return s
