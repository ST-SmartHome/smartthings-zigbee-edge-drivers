local function w(r)
local n=require"capabilities.events.all"
local M=require"st.zigbee.data_types"
local f=require"st.zigbee.constants"
local L=require"st.utils.safe_xy_to_hsv"
local function v(q,G)
if type(q)~="table"then
q={}
end
if type(G)~="table"then
return q
end
for K,e in pairs(G)do
q[K]=e
end
return q
end
local function m(q,j)
if type(q)~="table"or type(j)~="table"then
return q
end
for K,e in pairs(j)do
if q[K]==nil then
q[K]=e
end
end
return q
end
local function D(J,...)
local y=n[J]
if type(y)=="function"then
return y(...)
end
return nil
end
local function p(k,l)
local h={}if type(k)=="string"then
h.name=k
else
v(h,k)
end
v(h,l)return h
end
local function o()
return{
from=function(e)
if type(e)~="number"then
return e
end
if e<=0 then
return 0
end
local N=10 ^((e-1)/10000)return math.floor(N+0.5)
end,
to=function(e)
if type(e)~="number"then
return e
end
if e<=0 then
return 0
end
local O=10000*(math.log(e)/math.log(10))+1
return math.floor(O+0.5)
end,
}
end
local function i(I)
return{
from=function(e)
if type(e)=="table"then
if I==1 then
if type(e.is_alarm1_set)=="function"and e:is_alarm1_set()then
return true
end
if type(e.is_alarm2_set)=="function"and e:is_alarm2_set()then
return true
end
elseif I==4 and type(e.is_tamper_set)=="function"then
return e:is_tamper_set()elseif e.value~=nil then
e=e.value
else
return e
end
end
if type(e)~="number"then
return e
end
return bit32.band(e,I)~=0
end,
}
end
local function t()
return{
from=function(e)
local u
local x
if type(e)=="table"then
if type(e.is_alarm1_set)=="function"then u=e:is_alarm1_set()end
if type(e.is_alarm2_set)=="function"then x=e:is_alarm2_set()end
if u==nil and e.value~=nil then e=e.value end
end
if type(e)=="number"then
u=bit32.band(e,1)~=0
x=bit32.band(e,2)~=0
end
if u==nil or x==nil then return e end
if not u and not x then return"closed"end
if u and not x then return"tilted"end
return"open"
end,
}
end
local function a(E)
local s=E and E.body and E.body.zcl_body and E.body.zcl_body.zone_status or nil
if s==nil then
return nil
end
return{
raw_value=s.value or s,typed_value=s,}
end
local function b(C,B,z)
return{
minimum_interval=C,maximum_interval=B,reportable_change=z,read_on_configure=true,}
end
local function c(...)
local F={}for _,j in ipairs({...})do
m(F,j)
end
return F
end
local function d(J,y,A)
r[J]=function(k,l)
local h=p(k,l)local g=h.configure_reporting
local j=A(h)h.configure_reporting=nil
if g==false then
j.minimum_interval=nil
j.maximum_interval=nil
j.reportable_change=nil
j.physical_reportable_change=nil
j.reporting_defaults=nil
end
m(h,j)return y(h)
end
end
d("temperature",r.temperature_measurement,function()
return c(
{
emit=n.temperature("C"),scale=100,},b(30,300,50))
end)
d("humidity",r.relative_humidity,function()
return c(
{
emit=n.humidity(),scale=100,},b(30,300,100))
end)
d("battery",r.power_configuration_battery,function()
return c(
{
emit=n.battery(),scale=2,},b(300,21600,2))
end)
d("battery_voltage",r.power_configuration_battery_voltage,function()
return c(
{
emit=n.voltage(),scale=10,},b(300,21600,1))
end)
d("illuminance",r.illuminance_measurement,function(l)
local g=l.configure_reporting
l.configure_reporting=nil
if g==false then
return{
emit=n.illuminance(),converter=o(),read_on_configure=true,}
end
return c(
{
emit=n.illuminance(),converter=o(),},b(30,300,100))
end)
d("pressure",r.pressure_measurement,function()
return c(
{
emit=n.atmospheric_pressure(),scale=10,},b(30,300,1))
end)
r.occupancy=function(k,l)
local h=p(k,l)local H=h.ias_zone==true
local g=h.configure_reporting
h.ias_zone=nil
h.configure_reporting=nil
if H then
m(h,c(
{
name="occupancy",emit=n.occupancy(),converter=i(1),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,},b(30,300,nil)))return r.ias_zone(h)
end
if g==false then
m(h,{
emit=n.occupancy(),read_on_configure=true,})return r.occupancy_sensing(h)
end
m(h,c(
{
emit=n.occupancy(),},b(0,300,nil)))return r.occupancy_sensing(h)
end
d("contact",r.ias_zone,function()
return c(
{
name="contact",emit=n.contact(),converter=i(1),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,},b(30,300,nil))
end)
d("shelly_handle_position",r.ias_zone,function()
return c(
{
name="shelly_handle_position",emit=n.shellyBluDoorHandlePosition(),converter=t(),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,},b(30,300,nil))
end)
d("water",r.ias_zone,function()
return c(
{
name="water",emit=n.water(),converter=i(1),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,},b(0,300,nil))
end)
d("smoke",r.ias_zone,function()
return c(
{
name="smoke",emit=n.smoke(),converter=i(1),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,},b(0,180,nil))
end)
d("gas",r.ias_zone,function()
return c(
{
name="gas",emit=n.gas(),converter=i(1),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,},b(0,300,nil))
end)
d("gas_alarm_2",r.ias_zone,function()
return c(
{
name="gas",emit=n.gas(),converter=i(2),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,},b(0,300,nil))
end)
d("carbon_monoxide",r.ias_zone,function()
return c(
{
name="carbon_monoxide",emit=n.carbon_monoxide(),converter=i(1),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,},b(0,180,nil))
end)
d("motion",r.ias_zone,function(l)
local g=l.configure_reporting
l.configure_reporting=nil
local j={
name="motion",emit=n.motion(),converter=i(1),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,read_on_configure=true,}if g==false then
return j
end
return c(j,b(30,300,nil))
end)
d("tamper",r.ias_zone,function()
return c(
{
name="tamper",emit=n.tamper(),converter=i(4),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,},b(0,300,nil))
end)
d("battery_low",r.ias_zone,function(l)
local g=l.configure_reporting
l.configure_reporting=nil
local j={
name="battery_low",emit=D("battery_low"),converter=i(8),ias_configure_method=f.IAS_ZONE_CONFIGURE_TYPE.AUTO_ENROLL_RESPONSE,command_id=0,command_extractor=a,read_on_configure=true,}if g==false then
return j
end
return c(j,b(0,300,nil))
end)
end
return w
