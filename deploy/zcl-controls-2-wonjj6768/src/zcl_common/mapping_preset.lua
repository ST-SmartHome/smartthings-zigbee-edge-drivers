local function q(n)
local o=require"capabilities.events.all"
local H=require"st.zigbee.data_types"
local D=require"st.zigbee.constants"
local G=require"st.utils.safe_xy_to_hsv"
local function p(l,C)
if type(l)~="table"then
l={}
end
if type(C)~="table"then
return l
end
for E,d in pairs(C)do
l[E]=d
end
return l
end
local function m(l,c)
if type(l)~="table"or type(c)~="table"then
return l
end
for E,d in pairs(c)do
if l[E]==nil then
l[E]=d
end
end
return l
end
local function k(f,i)
local e={}if type(f)=="string"then
e.name=f
else
p(e,f)
end
p(e,i)return e
end
local function A(d,z,y)
if d<z then
return z
end
if d>y then
return y
end
return d
end
local function r()
return{
from=function(d)
if type(d)~="number"then
return d
end
return math.floor((A(d,0,254)*100/254)+0.5)
end,
to=function(d)
if type(d)~="number"then
return d
end
return math.floor((A(d,0,100)*254/100)+0.5)
end,
}
end
local function j()
return{
from=function(d)
if type(d)~="number"then
return d
end
return math.floor((A(d,0,254)*100/254)+0.5)
end,
to=function(d)
if type(d)~="number"then
return d
end
return math.floor((A(d,0,100)*254/100)+0.5)
end,
}
end
local function b(v,u,s)
return{
minimum_interval=v,maximum_interval=u,reportable_change=s,read_on_configure=true,}
end
local function h(...)
local B={}for _,c in ipairs({...})do
m(B,c)
end
return B
end
local function g(J,F,t)
n[J]=function(f,i)
local e=k(f,i)local a=e.configure_reporting
local c=t(e)e.configure_reporting=nil
if a==false then
c.minimum_interval=nil
c.maximum_interval=nil
c.reportable_change=nil
c.physical_reportable_change=nil
c.reporting_defaults=nil
end
m(e,c)return F(e)
end
end
g("battery",n.power_configuration_battery,function()
return h(
{
emit=o.battery(),scale=2,},b(300,21600,2))
end)
g("battery_voltage",n.power_configuration_battery_voltage,function()
return h(
{
emit=o.voltage(),scale=10,},b(300,21600,1))
end)
g("switch",n.on_off,function(i)
local a=i.configure_reporting
i.configure_reporting=nil
if a==false then
return{
emit=o.switch(),}
end
return h(
{
emit=o.switch(),},b(0,300,nil))
end)
n.tuya_magic_packet=function(f,i)
local e=k(f,i)m(e,{
name="tuya_magic_packet",read_only=true,read_on_configure=true,})return n.cluster_attribute(0,65534,e)
end
g("level",n.level_control,function(i)
local a=i.configure_reporting
i.configure_reporting=nil
local c={
name="brightness",emit=o.level(),converter=r(),}
if a==false then return c end
return h(c,b(1,3600,1))
end)
g("power",n.electrical_measurement_power,function()
return h(
{
emit=o.power(),metering_kind="power",poll_interval=300,},b(5,300,1))
end)
g("current",n.electrical_measurement_current,function()
return h(
{
emit=o.current(),scale=1000,metering_kind="current",poll_interval=300,},b(5,300,1))
end)
g("voltage",n.electrical_measurement_voltage,function()
return h(
{
emit=o.voltage(),metering_kind="voltage",poll_interval=300,},b(5,300,1))
end)
g("energy",n.simple_metering,function()
return{
emit=o.energy(),read_on_configure=true,metering_kind="energy",poll_interval=900,}
end)
g("color_hue",n.color_control_hue,function(i)
local a=i.configure_reporting
i.configure_reporting=nil
local c={
name="color_hue",emit=o.color_hue(),converter=j(),tx_command_id=0,
to_device=function(d)
local x=j().to(d)return{x,0,0,0,0}
end,
}
if a==false then return c end
return h(c,b(1,300,1))
end)
g("color_saturation",n.color_control_saturation,function(i)
local a=i.configure_reporting
i.configure_reporting=nil
local c={
name="color_saturation",emit=o.color_saturation(),converter=j(),tx_command_id=3,
to_device=function(d)
local x=j().to(d)return{x,0,0,0}
end,
}
if a==false then return c end
return h(c,b(1,300,1))
end)
n.color=function(f,i)
local e=k(f,i)m(e,{
name="color",cluster_id=n.CLUSTER_COLOR_CONTROL,attribute_id=n.ATTR_CURRENT_HUE,write_only=true,tx_command_id=6,
to_device=function(d)
if type(d)~="table"then
return d
end
local I=j().to(d.hue)local w=j().to(d.saturation)if type(I)~="number"or type(w)~="number"then
return nil
end
return{I,w,0,0,0}
end,
})return n.cluster_attribute(e.cluster_id,e.attribute_id,e)
end
end
return q
