local function t(q)
local l=require"capabilities.events.all"
local K=require"st.zigbee.data_types"
local G=require"st.zigbee.constants"
local I=require"st.utils.safe_xy_to_hsv"
local function s(g,F)
if type(g)~="table"then
g={}
end
if type(F)~="table"then
return g
end
for D,d in pairs(F)do
g[D]=d
end
return g
end
local function o(g,e)
if type(g)~="table"or type(e)~="table"then
return g
end
for D,d in pairs(e)do
if g[D]==nil then
g[D]=d
end
end
return g
end
local function n(f,m)
local h={}if type(f)=="string"then
h.name=f
else
s(h,f)
end
s(h,m)return h
end
local function w(L,u,B,C)
local p={}for D,d in pairs(L)do
p[d]=D
end
if type(C)=="table"then
for J,g in pairs(C)do
if p[g]~=nil then
p[J]=p[g]
end
end
end
return{
from=function(d)
local v=L[d]if v~=nil then
return v
end
if u~=nil then
return u
end
return d
end,
to=function(d)
local v=p[d]if v~=nil then
return v
end
if B~=nil then
return B
end
return d
end
}
end
local function r()
return w{
[0]="off",[1]="auto",[3]="cool",[4]="heat",[5]="emergency heat"}
end
local function k()
return{
from=function(d)
local i=d
if type(d)=="table"then
if type(d.is_heat_on_set)=="function"and(d:is_heat_on_set()or(type(d.is_heat_second_stage_on_set)=="function"and d:is_heat_second_stage_on_set()))then
return"heating"
end
if type(d.is_cool_on_set)=="function"and(d:is_cool_on_set()or(type(d.is_cool_second_stage_on_set)=="function"and d:is_cool_second_stage_on_set()))then
return"cooling"
end
if type(d.is_fan_on_set)=="function"and(
d:is_fan_on_set()or
(type(d.is_fan_second_stage_on_set)=="function"and d:is_fan_second_stage_on_set())or
(type(d.is_fan_third_stage_on_set)=="function"and d:is_fan_third_stage_on_set())
)then
return"fan only"
end
i=d.value
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
end
}
end
local function a(A,z,x)
return{
minimum_interval=A,maximum_interval=z,reportable_change=x,read_on_configure=true}
end
local function c(...)
local E={}for _,e in ipairs{...}do
o(E,e)
end
return E
end
local function b(M,H,y)
q[M]=function(f,m)
local h=n(f,m)local j=h.configure_reporting
local e=y(h)h.configure_reporting=nil
if j==false then
e.minimum_interval=nil
e.maximum_interval=nil
e.reportable_change=nil
e.physical_reportable_change=nil
e.reporting_defaults=nil
end
o(h,e)return H(h)
end
end
b("humidity",q.relative_humidity,function()
return c(
{
emit=l.humidity(),scale=100},a(30,300,100))
end)
b("battery",q.power_configuration_battery,function()
return c(
{
emit=l.battery(),scale=2},a(300,21600,2))
end)
b("switch",q.on_off,function(m)
local j=m.configure_reporting
m.configure_reporting=nil
if j==false then
return{
emit=l.switch()}
end
return c(
{
emit=l.switch()},a(0,300,nil))
end)
b("power",q.electrical_measurement_power,function()
return c(
{
emit=l.power(),metering_kind="power",poll_interval=300},a(5,300,1))
end)
b("current",q.electrical_measurement_current,function()
return c(
{
emit=l.current(),scale=1000,metering_kind="current",poll_interval=300},a(5,300,1))
end)
b("voltage",q.electrical_measurement_voltage,function()
return c(
{
emit=l.voltage(),metering_kind="voltage",poll_interval=300},a(5,300,1))
end)
b("energy",q.simple_metering,function()
return{
emit=l.energy(),read_on_configure=true,metering_kind="energy",poll_interval=900}
end)
b("local_temperature",q.thermostat_local_temperature,function()
return c(
{
emit=l.temperature"C",scale=100},a(30,300,50))
end)
b("heating_setpoint",q.thermostat_heating_setpoint,function()
return c(
{
name="current_heating_setpoint",emit=l.heating_setpoint"C",scale=100},a(30,300,50))
end)
b("system_mode",q.thermostat_system_mode,function()
return c(
{
emit=l.thermostat_mode(),converter=r()},a(1,300,nil))
end)
b("cooling_setpoint",q.thermostat_cooling_setpoint,function()
return c(
{
name="current_cooling_setpoint",emit=l.cooling_setpoint"C",scale=100},a(30,300,50))
end)
b("thermostat_operating_state",q.thermostat_running_state,function()
return c(
{
name="thermostat_operating_state",emit=l.thermostat_operating_state(),converter=k()},a(1,300,nil))
end)
end
return t
