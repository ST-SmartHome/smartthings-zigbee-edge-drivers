-- ST-SmartHome: per-outlet plug-side countdown, in minutes.
--
-- Setting the Auto Off Timer turns the outlet on and has the plug turn it off
-- again after that time (OnOff OnWithTimedOff), so the timer survives hub
-- restarts and the plug reports the off itself. Tuya firmware counts
-- OnWithTimedOff in whole seconds, not the ZCL spec's tenths. Setting it
-- again restarts the countdown; 0 cancels it and leaves the outlet as it is,
-- and switching the outlet off cancels it too. The plug's onTime attribute
-- doesn't track the remaining time, so the tile shows the time last set and
-- goes back to 0 when the outlet turns off (see app.child_outlets).
local capabilities=require "st.capabilities"
local data_types=require "st.zigbee.data_types"
local on_off=(require "st.zigbee.zcl.clusters").OnOff
local log=require "log"
local outlet_countdown={}
outlet_countdown.ID="aboutisland47519.autoOffTimer"
outlet_countdown.ATTRIBUTE="autoOffTimer"
outlet_countdown.COMMAND="setAutoOffTimer"
local MAX_MINUTES=720
local UNIT="min"
function outlet_countdown.has_capability(device,component_id)
local components=type(device)=="table" and device.profile and device.profile.components or nil
local component=type(components)=="table" and components[component_id]or nil
return component ~=nil and type(component.capabilities)=="table" and
component.capabilities[outlet_countdown.ID]~=nil
end
function outlet_countdown.event(minutes)
local ok,capability=pcall(function()return capabilities[outlet_countdown.ID]end)
if not ok or capability==nil or capability[outlet_countdown.ATTRIBUTE]==nil then
return nil
end
return capability[outlet_countdown.ATTRIBUTE]({value=minutes,unit=UNIT})
end
function outlet_countdown.emit(device,component_id,minutes)
local event=outlet_countdown.event(minutes)
if event==nil then
return
end
if component_id=="main" then
device:emit_event(event)
else
device:emit_component_event({id=component_id},event)
end
require("app.child_outlets").on_parent_event(device,component_id,event)
end
function outlet_countdown.handle(_,device,command)
local component_id=command.component or "main"
if not outlet_countdown.has_capability(device,component_id)then
return
end
local args=command.args or{}
local raw=args.minutes
if raw==nil and type(command.positional_args)=="table" then
raw=command.positional_args[1]
end
local minutes=math.floor(math.max(0,math.min(tonumber(raw)or 0,MAX_MINUTES)))
local seconds=minutes*60
if seconds>0 then
device:send_to_component(component_id,on_off.server.commands.On(device))
end
device:send_to_component(component_id,on_off.server.commands.OnWithTimedOff(
device,
data_types.Uint8(0),
data_types.Uint16(seconds),
data_types.Uint16(seconds)
))
log.info(string.format("[%s] auto-off %s: %d min",tostring(device.label),component_id,minutes))
outlet_countdown.emit(device,component_id,minutes)
end
return outlet_countdown
