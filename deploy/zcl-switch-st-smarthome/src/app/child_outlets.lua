-- ST-SmartHome: optional EDGE_CHILD devices for secondary outlets.
--
-- A definition opts in with child_outlets={<component_id>="<label suffix>"}.
-- The parent keeps its component as-is (routines on it keep working); the
-- child is a plain switch that forwards commands to that parent component
-- and mirrors its state (switch and countdown). This is what lets Alexa and
-- Google see outlet 2 as its own device.
local capabilities=require "st.capabilities"
local log=require "log"
local child_outlets={}
local CHILD_PROFILE="child-outlet"
local PREFERENCE="outletChildDevices"
-- Plug-side countdown (see the SPP02GIP definition); mirrored like switch.
child_outlets.COUNTDOWN_ID="concertmirror08464.countdownTimerZclTwelveHours"
local COUNTDOWN_ATTRIBUTE="countdownTimerZclTwelveHours"
local COUNTDOWN_COMMAND="setCountdownTimerZclTwelveHours"
child_outlets.COUNTDOWN_COMMAND=COUNTDOWN_COMMAND
local resolve_definition=function()return nil end
function child_outlets.set_definition_resolver(resolver)
resolve_definition=resolver
end
function child_outlets.is_child(device)
return type(device)=="table" and type(device.parent_assigned_child_key)=="string"
end
local function outlets_for(device)
local definition=resolve_definition(device)
local outlets=definition and definition.child_outlets
if type(outlets)~="table" then
return nil
end
return outlets
end
local function enabled(device)
local preferences=device.preferences
if type(preferences)~="table" or preferences[PREFERENCE]==nil then
return true
end
return preferences[PREFERENCE]==true
end
local function has_component(device,component_id)
return device.profile ~=nil and type(device.profile.components)=="table" and
device.profile.components[component_id]~=nil
end
local function emit_child_switch(child,value)
if value=="on" then
child:emit_event(capabilities.switch.switch.on())
elseif value=="off" then
child:emit_event(capabilities.switch.switch.off())
end
end
local function has_capability(device,component_id,capability_id)
local component=device.profile and type(device.profile.components)=="table" and device.profile.components[component_id]or nil
return component ~=nil and type(component.capabilities)=="table" and component.capabilities[capability_id]~=nil
end
local function countdown_event(value)
local ok,capability=pcall(function()return capabilities[child_outlets.COUNTDOWN_ID]end)
if not ok or capability==nil or capability[COUNTDOWN_ATTRIBUTE]==nil then
return nil
end
return capability[COUNTDOWN_ATTRIBUTE]({value=value,unit="s"})
end
local function emit_child_countdown(child,value)
if type(value)~="number" or not has_capability(child,"main",child_outlets.COUNTDOWN_ID)then
return
end
local event=countdown_event(value)
if event ~=nil then
child:emit_event(event)
end
end
local function mirror_current(parent,component_id,child)
local value=parent:get_latest_state(component_id,capabilities.switch.ID,capabilities.switch.switch.NAME)
emit_child_switch(child,value)
emit_child_countdown(child,parent:get_latest_state(component_id,child_outlets.COUNTDOWN_ID,COUNTDOWN_ATTRIBUTE))
end
-- Create/remove children to match the definition and the parent's preference.
function child_outlets.sync_parent(driver,device)
local outlets=outlets_for(device)
if outlets==nil then
return
end
for component_id,suffix in pairs(outlets)do
local child=device:get_child_by_parent_assigned_key(component_id)
if enabled(device)and has_component(device,component_id)then
if child==nil then
log.info(string.format("creating child device for %s %s",tostring(device.label),component_id))
driver:try_create_device({
type="EDGE_CHILD",
label=string.format("%s %s",device.label,suffix),
profile=CHILD_PROFILE,
parent_device_id=device.id,
parent_assigned_child_key=component_id,
vendor_provided_label=suffix,
})
else
mirror_current(device,component_id,child)
end
elseif child ~=nil and not enabled(device)then
log.info(string.format("removing child device for %s %s",tostring(device.label),component_id))
driver:try_delete_device(child.id)
end
end
end
-- Returns false when the child isn't one we manage (caller cleans it up).
function child_outlets.init_child(driver,child)
local parent=child:get_parent_device()
if parent==nil then
return false
end
local outlets=outlets_for(parent)
local component_id=child.parent_assigned_child_key
if outlets==nil or outlets[component_id]==nil then
return false
end
mirror_current(parent,component_id,child)
return true
end
-- Run a parent capability handler against the child's parent component.
function child_outlets.forward(driver,child,command,handler)
local parent=child:get_parent_device()
if parent==nil then
return
end
local component_id=child.parent_assigned_child_key
if command.capability==capabilities.refresh.ID then
component_id="main"
end
handler(driver,parent,{
component=component_id,
capability=command.capability,
command=command.command,
args=command.args or{},
positional_args=command.positional_args or{},
named_args=command.named_args or{},
})
end
local function event_ids(event)
local capability_id=event.capability_id or(type(event.capability)=="table" and event.capability.ID)or nil
local attribute_id=event.attribute_id or(type(event.attribute)=="table" and event.attribute.NAME)or nil
local value=(type(event.value)=="table" and event.value.value)or
(type(event.state)=="table" and event.state.value)or nil
return capability_id,attribute_id,value
end
-- The countdown tile shows the time last set; once the outlet is off
-- (timer finished, or switched off) it goes back to 0.
local function reset_countdown(device,component_id)
if not has_capability(device,component_id,child_outlets.COUNTDOWN_ID)then
return
end
local current=device:get_latest_state(component_id,child_outlets.COUNTDOWN_ID,COUNTDOWN_ATTRIBUTE)
if current==nil or current==0 then
return
end
local event=countdown_event(0)
if event==nil then
return
end
if component_id=="main" then
device:emit_event(event)
else
device:emit_component_event({id=component_id},event)
end
end
-- Called for every attribute event the parent emits; mirrors switch and
-- countdown state to the child, and resets the countdown when switched off.
function child_outlets.on_parent_event(device,component_id,event)
if type(component_id)~="string" or type(event)~="table" then
return
end
if child_outlets.is_child(device)or type(device.get_child_by_parent_assigned_key)~="function" then
return
end
local capability_id,attribute_id,value=event_ids(event)
local is_switch=capability_id==capabilities.switch.ID and attribute_id==capabilities.switch.switch.NAME
if is_switch and value=="off" then
reset_countdown(device,component_id)
end
if component_id=="main" then
return
end
local child=device:get_child_by_parent_assigned_key(component_id)
if child==nil then
return
end
if is_switch then
emit_child_switch(child,value)
if value=="off" then
local current=child:get_latest_state("main",child_outlets.COUNTDOWN_ID,COUNTDOWN_ATTRIBUTE)
if current ~=nil and current ~=0 then
emit_child_countdown(child,0)
end
end
elseif capability_id==child_outlets.COUNTDOWN_ID and attribute_id==COUNTDOWN_ATTRIBUTE then
emit_child_countdown(child,value)
end
end
return child_outlets
