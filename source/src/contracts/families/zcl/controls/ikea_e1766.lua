local zcl = require "protocol.zcl"
local family = require "contracts.helpers.family"
local helpers = require "contracts.helpers.zcl"
local capabilities = require "st.capabilities"
local types = require "st.zigbee.data_types"
local management = require "st.zigbee.device_management"
local bind = require "st.zigbee.zdo.bind_request"

local registrations, register = family.definition_registry()
local VERSION, HUB = "__ikea1766_version", "__ikea1766_hub"

local function battery_divisor(build)
  if type(build) ~= "string" then return 2 end
  local major, minor, patch, tail = build:match("^[v=%s]*(%d+)%.(%d+)%.(%d+)(.-)%s*$")
  if major == nil then return 2 end
  local prerelease, metadata = tail:match("^(.-)%+(.+)$")
  if tail:find("+", 1, true) and metadata == nil then return 2 end
  prerelease = prerelease or tail
  local function identifiers(value)
    return value ~= "" and not value:find("[^A-Za-z0-9%.%-]") and value:sub(1, 1) ~= "."
      and value:sub(-1) ~= "." and not value:find("..", 1, true)
  end
  if metadata ~= nil and not identifiers(metadata) then return 2 end
  if prerelease ~= "" then
    if #prerelease > 1 and prerelease:sub(1, 1) == "-" then prerelease = prerelease:sub(2) end
    if prerelease:sub(1, 1) == "." and #patch > 1 then
      prerelease, patch = patch:sub(-1) .. prerelease, patch:sub(1, -2)
    end
    if not identifiers(prerelease) then return 2 end
  end
  major, minor, patch = tonumber(major), tonumber(minor), tonumber(patch)
  if major > 9007199254740991 or minor > 9007199254740991 or patch > 9007199254740991 then return 2 end
  if major ~= 2 then return major < 2 and 1 or 2 end
  if minor ~= 4 then return minor < 4 and 1 or 2 end
  return patch == 0 and prerelease ~= "" and 1 or 2
end

local function version_number(value)
  value = value:match("^%s*(.-)%s*$")
  if value == "" then return 0 end
  if value == "Infinity" or value == "+Infinity" then return math.huge end
  if value == "-Infinity" then return -math.huge end
  if value:match("^0[bB][01]+$") then return tonumber(value:sub(3), 2) end
  if value:match("^0[oO][0-7]+$") then return tonumber(value:sub(3), 8) end
  if value:match("^0[xX]%x+$") then return tonumber(value) end
  if not value:find("[^%d%.eE%+%-]") then return tonumber(value) or false end
  return false
end

local function bind_on_off(device)
  local build, hub = device:get_field(VERSION), device:get_field(HUB)
  if type(build) ~= "string" or build == "" or hub == nil then return end
  local parts = {}
  for value in (build .. "."):gmatch("(.-)%.") do parts[#parts + 1] = version_number(value) end
  local endpoint = parts[1] and (parts[1] > 2 or parts[1] == 2 and parts[2]
    and (parts[2] > 3 or parts[2] == 3 and parts[3] and parts[3] >= 75))
  local request = management.build_bind_request(device, 6, hub, 1)
  if not endpoint then request.body.zdo_body = bind.BindRequest(device.zigbee_eui, 1, 6, bind.ADDRESS_MODE_16_BIT, 901) end
  device:send(request)
end

local function refresh(device)
  zcl.read_attribute(device, 0, 0x4000, 1)
  zcl.read_attribute(device, 1, 0x21, 1)
end

local e1766 = {
  profile = "buttons-ikea-e1766", magic_packet = false, initial_custom_state_query = false,
  button_actions = {"pushed"}, advanced_remote = true,
  component_to_endpoint = function() return 1 end,
  endpoint_to_component = function() return "main" end,
  remote_action_emit_name = "ikeaE1766Action",
  standard_action_metadata_emit_names = {action_group = "ikeaE1766ActionGroup"},
  standard_command_action_resolver = function(rx, cluster, command, endpoint, device)
    local action = cluster == 0x0102 and endpoint == 1 and ({[0] = "open", [1] = "close", [2] = "stop"})[command]
    local header = rx.body.zcl_header
    if not action or header.frame_ctrl:is_mfg_specific_set() or header.frame_ctrl:is_direction_set()
      or helpers.duplicate_transaction(device, 1, header.seqno.value, "__ikea1766_transactions") then return nil, "main", true end
    return action, "main", true
  end,
  remote_action_handler = function(device, _, action)
    local component = action == "open" and "button1" or action == "close" and "button2"
    if component then
      device:emit_component_event({id = component}, capabilities.button.button.pushed({state_change = true}))
      zcl.schedule_battery_refresh_after_button(device)
    end
  end,
  protocol_writers = {ikea_e1766_identify = helpers.identify},
  capability_commands = {
    {capability_id = "concertmirror08464.ikeaE1766Identify", command_name = "identify", mapping_name = "ikea_e1766_identify", value = 3},
    {capability_id = "concertmirror08464.ikeaE1766Identify", command_name = "setIdentifyTime", mapping_name = "ikea_e1766_identify", argument_name = "identifyTime"},
  },
  parent_refresh = refresh,
  zcl_clusters = {
    zcl.cluster_attribute(0, 0x4000, {
      name = "ikea_e1766_version", endpoint = 1, component = "main", data_type = types.CharString,
      read_only = true, read_on_configure = false, read_on_refresh = false,
      handler = function(device, build)
        if type(build) ~= "string" then return end
        local changed = device:get_field(VERSION) ~= build
        device:set_field(VERSION, build, {persist = true})
        if changed then bind_on_off(device) end
      end,
    }),
    zcl.battery({
      endpoint = 1, component = "main", read_on_configure = false, read_on_refresh = false,
      minimum_interval = 3600, maximum_interval = 65000, reportable_change = 10,
      from_device = function(_, device, context)
        local raw = context.raw_value
        if raw < 255 then return raw / battery_divisor(device:get_field(VERSION)) end
      end,
    }),
  },
  configure = function(driver, device)
    device:set_field(HUB, driver.environment_info.hub_zigbee_eui, {persist = false})
    driver:add_hub_to_zigbee_group(901)
    for _, cluster in ipairs({0x0102, 1}) do zcl.bind_cluster(device, cluster, driver.environment_info.hub_zigbee_eui, 1) end
    bind_on_off(device)
    refresh(device)
  end,
}
register(e1766, {
  family.create_fingerprint("IKEA of Sweden", "TRADFRI open/close remote"),
  family.create_fingerprint("KE", "TRADFRI open/close remote"),
  family.create_fingerprint("\002KE", "TRADFRI open/close remote"),
})

-- ZCL REPORTING CAPABILITIES BEGIN
zcl.attach_reporting_capabilities(registrations, {
  {1, "rpt-twy"},
})
-- ZCL REPORTING CAPABILITIES END

return {
  id = "zcl.controls.ikea_e1766",
  registrations = registrations,
}
