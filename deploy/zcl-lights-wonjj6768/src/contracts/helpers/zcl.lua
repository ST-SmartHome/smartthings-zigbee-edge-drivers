local o=require"protocol.zcl"
local c={}
local function a(b,i)
if i~=nil then
b[#b+1]=i
end
end
function c.append_clusters(b,...)
for y=1,select("#",...)do
local r=select(y,...)if type(r)=="table"and r[1]~=nil then
for _,i in ipairs(r)do
a(b,i)
end
else
a(b,r)
end
end
return b
end
function c.metering_clusters(d)
d=d or{}local e=d.endpoint
local p=d.include_switch~=false
local l=d.include_current==true
local w=d.power_poll or 300
local u=d.voltage_poll or 300
local s=d.current_poll or 300
local v=d.energy_poll or 900
local t=d.energy_scale or 100
local b={}if p then
a(b,o.switch({
endpoint=e,component=d.switch_component,}))
end
a(b,o.power({
endpoint=e,poll_interval=w,}))a(b,o.voltage({
endpoint=e,poll_interval=u,}))if l then
a(b,o.current({
endpoint=e,poll_interval=s,}))
end
a(b,o.energy({
endpoint=e,scale=t,ignore_reported_scaler=d.energy_ignore_reported_scaler,poll_interval=v,}))return b
end
function c.switch_cluster(e,q)
if e==nil and q==nil then
return o.switch()
end
return o.switch({
endpoint=e,component=q,})
end
local function g(j,...)
local x=j and j.body and j.body.zcl_body or nil
if type(x)~="table"then return nil end
for _,z in ipairs({...})do
local n=x[z]
if type(n)=="table"and n.value~=nil then return n.value end
if n~=nil then return n end
end
end
function c.resolve_rd1p_rotary_action(j,k,h,m)
if m~=2 then return nil,nil,true end
if k==o.CLUSTER_ON_OFF then
return({
[0]="double_pressed",[1]="pressed",[2]="held",[3]="released",})[h],"main",true
end
if k==o.CLUSTER_LEVEL_CONTROL then
if h==3 then return"stopped_rotating","main",true end
local f
if h==5 then
f=g(j,"move_mode","movemode","mode")
if f==0 then return"started_rotating_right","main",true end
if f==1 then return"started_rotating_left","main",true end
elseif h==6 then
f=g(j,"step_mode","stepmode","mode")
if f==0 then return"rotating_right","main",true end
if f==1 then return"rotating_left","main",true end
end
end
return nil,nil,true
end
return c
