local function m(z)
local u=require"capabilities.events.all"
local A=require"st.zigbee.data_types"
local v=require"st.zigbee.constants"
local y=require"st.utils.safe_xy_to_hsv"
local function l(e,t)
if type(e)~="table"then
e={}
end
if type(t)~="table"then
return e
end
for w,r in pairs(t)do
e[w]=r
end
return e
end
local function i(e,a)
if type(e)~="table"or type(a)~="table"then
return e
end
for w,r in pairs(a)do
if e[w]==nil then
e[w]=r
end
end
return e
end
local function h(b,g)
local c={}if type(b)=="string"then
c.name=b
else
l(c,b)
end
l(c,g)return c
end
local function f(q,p,n)
return{
minimum_interval=q,maximum_interval=p,reportable_change=n,read_on_configure=true,}
end
local function j(...)
local s={}for _,a in ipairs({...})do
i(s,a)
end
return s
end
local function k(B,x,o)
z[B]=function(b,g)
local c=h(b,g)local d=c.configure_reporting
local a=o(c)c.configure_reporting=nil
if d==false then
a.minimum_interval=nil
a.maximum_interval=nil
a.reportable_change=nil
a.physical_reportable_change=nil
a.reporting_defaults=nil
end
i(c,a)return x(c)
end
end
k("battery",z.power_configuration_battery,function()
return j(
{
emit=u.battery(),scale=2,},f(300,21600,2))
end)
k("switch",z.on_off,function(g)
local d=g.configure_reporting
g.configure_reporting=nil
if d==false then
return{
emit=u.switch(),}
end
return j(
{
emit=u.switch(),},f(0,300,nil))
end)
end
return m
