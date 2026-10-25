local tuya = require "protocol.tuya"
local zcl = require "protocol.zcl"
local device_helpers = require "contracts.helpers.family"
local emit = require "capabilities.events.all"
local common = require "contracts.helpers.ef00_switches"
local capabilities = require "st.capabilities"

local converter = tuya.converter
local device_definitions, register_device_definition = device_helpers.definition_registry()

-- M9Pro: ZHC cff1de47, independent DP and group/weather contract.
do
  local GROUPS = "m9pro.group_settings"
  local WEATHER = "m9pro.weather_inputs"
  local weather_codes = {
    sunny=100, heavy_rain=101, cloudy=102, sandstorm=103, light_snow=104, snow=105,
    freezing_fog=106, rainstorm=107, shower=108, dust=109, spit=112, sleet=113,
    yin=114, freezing_rain=115, rain=118, fog=121, heavy_shower=123, heavy_snow=124,
    heavy_downpour=125, blizzard=126, hailstone=127, snow_shower=130, haze=140,
    thunder_shower=143,
  }
  local mode = converter.lookup_from_to({switch=0, scene=1, smart_light=2, curtain=3})
  local fourth_mode = converter.lookup_from_to({switch=0, scene=1, smart_light=2, curtain=3, thermostat=4})
  local screen = converter.lookup_from_to({motion=0, on_press=1, on=2})
  local recovery = converter.lookup_from_to({off=0, on=1, previous=2})
  local scene_switch = converter.lookup_from_to({
    switch_1=0, switch_2=1, switch_3=2, switch_4=3, switch_5=4,
    switch_6=5, switch_7=6, switch_8=7, switch_9=8,
  })

  -- JS slice(0,8) counts UTF-16 code units. A split supplementary character is
  -- encoded as U+FFFD by TextEncoder; runtime.utf8_text counts different units.
  local function name_to(value)
    if type(value) ~= "string" or not utf8.len(value) then return nil end
    local parts, units = {}, 0
    for _, codepoint in utf8.codes(value) do
      if units == 8 then break end
      local size = codepoint > 0xFFFF and 2 or 1
      if units + size > 8 then
        parts[#parts + 1] = utf8.char(0xFFFD)
        break
      end
      parts[#parts + 1] = utf8.char(codepoint)
      units = units + size
    end
    return (table.concat(parts):gsub(".", function(byte) return string.format("%04x", byte:byte()) end))
  end

  -- Primary parseInt(hex,16)->Uint8Array->TextDecoder. RX is NOT truncated.
  -- This replacement decoder belongs only to the M9 wire name representation.
  local function name_from(value)
    if type(value) ~= "string" then return nil end
    local bytes = {}
    for index = 1, #value, 4 do
      local word = value:sub(index, index + 3):gsub("^%s*([+-]?)0[xX]", "%1")
      local sign, digits = word:match("^%s*([+-]?)(%x+)")
      local number = tonumber(digits or "", 16) or 0
      if sign == "-" then number = -number end
      bytes[#bytes + 1] = string.char(number & 0xFF)
    end
    local raw, decoded = table.concat(bytes), {}
    local index = raw:sub(1, 3) == "\239\187\191" and 4 or 1
    while index <= #raw do
      local lead, count, low, high = raw:byte(index), 1, 0x80, 0xBF
      if lead >= 0xC2 and lead <= 0xDF then count = 2
      elseif lead >= 0xE0 and lead <= 0xEF then
        count = 3
        if lead == 0xE0 then low = 0xA0 elseif lead == 0xED then high = 0x9F end
      elseif lead >= 0xF0 and lead <= 0xF4 then
        count = 4
        if lead == 0xF0 then low = 0x90 elseif lead == 0xF4 then high = 0x8F end
      end
      local accepted, valid = 1, lead < 0x80 or count > 1
      for offset = 1, count - 1 do
        local byte = raw:byte(index + offset)
        local minimum, maximum = offset == 1 and low or 0x80, offset == 1 and high or 0xBF
        if not byte or byte < minimum or byte > maximum then valid = false; break end
        accepted = accepted + 1
      end
      decoded[#decoded + 1] = valid and raw:sub(index, index + count - 1) or utf8.char(0xFFFD)
      index = index + accepted
    end
    return table.concat(decoded)
  end
  local name_converter = {to=name_to, from=name_from}

  local function publish(device, emitter, value)
    if value == nil then return end
    local event = emitter(device, value)
    if event then device:emit_component_event({id="main"}, event) end
  end

  local function join_groups(device)
    local settings = device:get_field(GROUPS)
    if not settings then return end
    for channel = 1, 4 do
      local group = settings.values["l" .. channel]
      if group then device.driver:add_hub_to_zigbee_group(group) end
    end
  end

  local function group_channel(device, destination)
    local settings, selected = device:get_field(GROUPS), nil
    if not settings then return nil end
    -- Object.fromEntries in primary overwrites an earlier group->channel entry.
    for _, channel in ipairs(settings.order) do
      if settings.values[channel] == destination then selected = channel end
    end
    return selected
  end

  local function write_group(device, channel, value, emitter)
    if type(value) ~= "number" or value % 1 ~= 0 or value < 1 or value > 10000 then return false end
    local previous = device:get_field(GROUPS)
    local settings = {values={}, order={}}
    if previous then
      for key, group in pairs(previous.values) do settings.values[key] = group end
      for _, key in ipairs(previous.order) do settings.order[#settings.order + 1] = key end
    end
    if settings.values[channel] == nil then settings.order[#settings.order + 1] = channel end
    settings.values[channel] = value
    local zones = {}
    for index = 1, 4 do
      local group = settings.values["l" .. index]
      if group then zones[#zones + 1] = string.pack("<I2B", group, index) end
    end
    -- SDK Device.init stores the real driver in device.driver (st/device.lua:552).
    -- Join before the write so an immediate group command can be received.
    device.driver:add_hub_to_zigbee_group(value)
    if not zcl.send_raw_cluster_command(device, 0x0004, 0xF0,
        string.char(#zones) .. table.concat(zones), 1, "server", nil, true) then return false end
    device:set_field(GROUPS, settings, {persist=true})
    publish(device, emitter, value)
    return true
  end

  local function int16(value)
    if type(value) ~= "number" or value ~= value or value < -32768 or value > 32767 then return nil end
    -- Buffer.writeInt16BE truncates a finite number toward zero; no /10 scale.
    local integer = math.modf(value)
    return integer
  end

  local function weather_payload(values, days, current)
    -- The primary allocates 6+(current and 6 or 1)+days*6 bytes but writes
    -- 15+days*5 / 10+days*5. Below three days Buffer writes overflow; above
    -- three days the allocated BUFFER retains (days-3) trailing zero bytes.
    -- Preserve successful primary frames; never invent a short-request reply.
    if days < 3 then return nil end
    local parts = {string.char(0x11, 0, 0x12, days, 0x13, current and 1 or 0)}
    for item, kind in ipairs({"temperature", "humidity", "condition"}) do
      parts[#parts + 1] = string.char(item)
      for day = current and 0 or 1, days do
        local value = values[kind .. "_" .. day]
        if item == 3 then
          parts[#parts + 1] = string.char(value == nil and 0 or weather_codes[value])
        else
          parts[#parts + 1] = string.pack(">i2", int16(value == nil and 0 or value))
        end
      end
    end
    parts[#parts + 1] = "\0"
    parts[#parts + 1] = string.rep("\0", days - 3)
    return table.concat(parts)
  end

  local function write_weather(device, key, kind, value, emitter)
    if kind == "condition" then
      if weather_codes[value] == nil then return false end
    else
      if int16(value) == nil then return false end
      if key == "temperature_1" and (value < -65 or value > 99) then return false end
    end
    local values = {}
    for name, old in pairs(device:get_field(WEATHER) or {}) do values[name] = old end
    values[key] = value
    if not tuya.send_raw(device, 0x61, weather_payload(values, 3, true)) then return false end
    device:set_field(WEATHER, values, {persist=true})
    if emitter then publish(device, emitter, value) end
    return true
  end

  local function weather_request(payload)
    if not payload or #payload < 6 then return nil end
    local index, marker = 5, payload:byte(5)
    while marker and marker ~= 0x12 and marker ~= 0x13 do
      index = index + 1
      marker = payload:byte(index)
    end
    if not marker then return nil end
    index = index + 1
    local days = 0
    if marker == 0x12 then
      days = payload:byte(index)
      index = index + 2 -- day count then the primary's current-weather marker
    end
    local current = payload:byte(index)
    if days == nil or current == nil then return nil end
    return days, current ~= 0
  end

  local function body_bytes(body)
    if type(body.body_bytes) == "string" then return body.body_bytes end
    if type(body.serialize) == "function" then return body:serialize() end
  end

  local events = {
    mode_l1=emit.m9proModeOne(),
    mode_l2=emit.m9proModeTwo(),
    mode_l3=emit.m9proModeThree(),
    mode_l4=emit.m9proModeFour(),
    show_weather=emit.m9proShowWeather(),
    show_screen=emit.m9proScreen(),
    power_on_behavior=emit.m9proPowerMemory(),
    power_on_behavior_l1=emit.m9proPowerOne(),
    power_on_behavior_l2=emit.m9proPowerTwo(),
    power_on_behavior_l3=emit.m9proPowerThree(),
    power_on_behavior_l4=emit.m9proPowerFour(),
    backlight=emit.m9proBacklight(),
    scene_switch=emit.m9proScene(),
    name_l1=emit.m9proSwitchOneName({allow_empty=true}),
    name_l2=emit.m9proSwitchTwoName({allow_empty=true}),
    name_l3=emit.m9proSwitchThreeName({allow_empty=true}),
    name_l4=emit.m9proSwitchFourName({allow_empty=true}),
    scene_name_l1=emit.m9proSceneOneName({allow_empty=true}),
    scene_name_l2=emit.m9proSceneTwoName({allow_empty=true}),
    scene_name_l3=emit.m9proSceneThreeName({allow_empty=true}),
    scene_name_l4=emit.m9proSceneFourName({allow_empty=true}),
    dimmer_name_l1=emit.m9proDimmerOneName({allow_empty=true}),
    dimmer_name_l2=emit.m9proDimmerTwoName({allow_empty=true}),
    dimmer_name_l3=emit.m9proDimmerThreeName({allow_empty=true}),
    dimmer_name_l4=emit.m9proDimmerFourName({allow_empty=true}),
    curtain_name_l1=emit.m9proCurtainOneName({allow_empty=true}),
    curtain_name_l2=emit.m9proCurtainTwoName({allow_empty=true}),
    curtain_name_l3=emit.m9proCurtainThreeName({allow_empty=true}),
    curtain_name_l4=emit.m9proCurtainFourName({allow_empty=true}),
    curtain_switch_l1=emit.m9proCurtainOne(),
    curtain_switch_l2=emit.m9proCurtainTwo(),
    curtain_switch_l3=emit.m9proCurtainThree(),
    curtain_switch_l4=emit.m9proCurtainFour(),
    dimmer_switch_l1=emit.m9proDimmerOne(),
    dimmer_switch_l2=emit.m9proDimmerTwo(),
    dimmer_switch_l3=emit.m9proDimmerThree(),
    dimmer_switch_l4=emit.m9proDimmerFour(),
    thermostat=emit.m9proThermostat(),
    thermostat_name=emit.m9proThermostatName({allow_empty=true}),
    brightness_l1=emit.m9proBrightnessOne(),
    color_temp_l1=emit.m9proColorTempOne(),
    brightness_l2=emit.m9proBrightnessTwo(),
    color_temp_l2=emit.m9proColorTempTwo(),
    brightness_l3=emit.m9proBrightnessThree(),
    color_temp_l3=emit.m9proColorTempThree(),
    brightness_l4=emit.m9proBrightnessFour(),
    color_temp_l4=emit.m9proColorTempFour(),
    current_heating_setpoint=emit.m9proSetpoint(),
    fan_mode=emit.m9proFan(),
    group_id_l1=emit.m9proGroupOne(),
    group_id_l2=emit.m9proGroupTwo(),
    group_id_l3=emit.m9proGroupThree(),
    group_id_l4=emit.m9proGroupFour(),
    temperature_1=emit.m9proWeatherTemp(),
    condition_1=emit.m9proWeatherCondition(),
  }
  local switch_m9pro = {
    profile="switches-m9pro", package_group="switch-panel", datapoints={}, zcl_clusters={},
    protocol_writers={},
    magic_packet=true, query_on_configure=false, query_on_announce=false,
    initial_custom_state_query=false, refresh_state_query=false, post_switch_state_query=false,
    force_time_updates=false, time_start="1970", mcu_version_request_on_configure=false,
    button_actions={"pushed"},
    component_to_endpoint=function() return 1 end,
    endpoint_to_component=function() return "main" end,
    runtime_start=join_groups,
    configure=function(_, device) join_groups(device) end,
  }
  local datapoints = switch_m9pro.datapoints
  -- Same RO button pattern as add_panel_scenes. Datatype is not a RX filter in
  -- the current DP dispatcher; primary static(action) deliberately ignores it.
  for index, dp in ipairs({1, 2, 3, 4, 17}) do
    datapoints[#datapoints + 1] = tuya.dp_enum(dp, {
      name="action_" .. (index == 5 and 0 or index),
      component=index == 1 and "main" or "button" .. index, read_only=true,
      from_device=function() return "pushed" end,
      emit=function(_, value) return capabilities.button.button(value, {state_change=true}) end,
    })
  end
  for channel = 1, 4 do
    datapoints[#datapoints + 1] = tuya.dp_enum(17 + channel, {
      name="mode_l" .. channel, converter=channel == 4 and fourth_mode or mode,
      emit=events["mode_l" .. channel],
    })
  end
  -- Reuse the exact four-relay authoring pattern; actual Zigbee endpoint is 1.
  for channel = 1, 4 do
    datapoints[#datapoints + 1] = tuya.dp_on_off(23 + channel, {
      name="switch", component=channel == 1 and "main" or "switch" .. channel,
    })
  end
  datapoints[#datapoints + 1] = tuya.dp_binary(36, {
    name="show_weather", converter=common.panel_off_on_converter, emit=events["show_weather"],
  })
  datapoints[#datapoints + 1] = tuya.dp_enum(37, {
    name="show_screen", converter=screen, emit=events["show_screen"],
  })
  for channel = 0, 4 do
    local name = channel == 0 and "power_on_behavior" or "power_on_behavior_l" .. channel
    datapoints[#datapoints + 1] = tuya.dp_enum(38 + channel, {name=name, converter=recovery, emit=events[name]})
  end
  datapoints[#datapoints + 1] = tuya.dp_binary(101, {
    name="backlight", converter=common.panel_off_on_converter, emit=events["backlight"],
  })
  datapoints[#datapoints + 1] = tuya.dp_enum(102, {
    name="scene_switch", converter=scene_switch, emit=events["scene_switch"],
  })
  for _, group in ipairs({{103, "name"}, {107, "scene_name"}, {111, "dimmer_name"}, {115, "curtain_name"}}) do
    for channel = 1, 4 do
      local name = group[2] .. "_l" .. channel
      datapoints[#datapoints + 1] = tuya.dp_string(group[1] + channel - 1, {
        name=name, converter=name_converter, emit=events[name],
      })
    end
  end
  for _, group in ipairs({{119, "curtain_switch"}, {123, "dimmer_switch"}}) do
    for channel = 1, 4 do
      local name = group[2] .. "_l" .. channel
      datapoints[#datapoints + 1] = tuya.dp_binary(group[1] + channel - 1, {
        name=name, converter=common.panel_off_on_converter, emit=events[name],
      })
    end
  end
  datapoints[#datapoints + 1] = tuya.dp_binary(127, {
    name="thermostat", converter=common.panel_off_on_converter, emit=events["thermostat"],
  })
  datapoints[#datapoints + 1] = tuya.dp_string(128, {
    name="thermostat_name", converter=name_converter, emit=events["thermostat_name"],
  })
  for _, mapping in ipairs(datapoints) do
    mapping.suppress_optimistic_state = true
    if not mapping.read_only then
      -- Primary generic DP writes use herdsman seq=1 (LE 01 00). The common
      -- sender packs its transaction BE, so 0x0100 preserves those exact bytes.
      -- No response transaction matching or ACK ownership is introduced.
      mapping.command_id, mapping.transaction, mapping.match_transaction = 0x00, 0x0100, false
    end
  end

  for channel = 1, 4 do
    local logical = "l" .. channel
    local emitter = events["group_id_" .. logical]
    switch_m9pro.zcl_clusters[#switch_m9pro.zcl_clusters + 1] = zcl.cluster_attribute(0x0004, nil, {
      name="group_id_" .. logical, endpoint=1, read_only=false, write_only=true,
      emit=emitter, suppress_optimistic_state=true,
      sender=function(device, _, value) return write_group(device, logical, value, emitter) end,
    })
  end
  for _, kind in ipairs({"temperature", "condition"}) do
    local key, emitter = kind .. "_1", events[kind .. "_1"]
    switch_m9pro.zcl_clusters[#switch_m9pro.zcl_clusters + 1] = zcl.cluster_attribute(0xEF00, nil, {
      name=key, endpoint=1, read_only=false, write_only=true, emit=emitter, suppress_optimistic_state=true,
      sender=function(device, _, value) return write_weather(device, key, kind, value, emitter) end,
    })
  end
  for _, kind in ipairs({"temperature", "humidity", "condition"}) do
    for day = 0, 3 do
      local key, category = kind .. "_" .. day, kind
      switch_m9pro.protocol_writers[key] = function(device, value)
        return write_weather(device, key, category, value)
      end
    end
  end

  switch_m9pro.zigbee_message_handler = function(device, rx)
    local address, frame = rx.address_header, rx.body and rx.body.zcl_header
    if not address or not frame or address.src_endpoint.value ~= 1 or not frame.frame_ctrl:is_cluster_specific_set() then return end
    local cluster, command = address.cluster.value, frame.cmd.value
    if cluster == 0xEF00 and command == 0x00 then
      local report = tuya.parse_datapoint_report(rx)
      local first = report and report.datapoints[1]
      if not first then return end
      local raw = first.value_bytes
      if first.dp == 1 then
        publish(device, events["thermostat"], raw:byte(1) and raw:byte(1) ~= 0 and "on" or "off")
      elseif first.dp == 2 then
        publish(device, events["current_heating_setpoint"], raw:byte(4))
      elseif first.dp == 5 then
        publish(device, events["fan_mode"], raw:byte(1))
      end
    elseif cluster == 0xEF00 and command == 0x60 then
      local days, current = weather_request(body_bytes(rx.body.zcl_body))
      local payload = days ~= nil and weather_payload(device:get_field(WEATHER) or {}, days, current) or nil
      if payload then tuya.send_raw(device, 0x61, payload) end
    elseif (cluster == 0x0008 and (command == 0x00 or command == 0x04)) or (cluster == 0x0300 and command == 0x0A) then
      local channel = group_channel(device, address.dest_addr.value)
      if not channel then return end
      local body, value = rx.body.zcl_body, nil
      if cluster == 0x0008 then
        value = body.level and body.level.value
        local raw = value == nil and body_bytes(body) or nil
        if raw and #raw >= 3 then value = raw:byte(1) end
        publish(device, events["brightness_" .. channel], value)
      else
        value = body.color_temperature_mireds and body.color_temperature_mireds.value
        local raw = value == nil and body_bytes(body) or nil
        if raw and #raw >= 4 then value = string.unpack("<I2", raw) end
        publish(device, events["color_temp_" .. channel], value)
      end
    end
  end
  register_device_definition(switch_m9pro, device_helpers.create_fingerprints("TS0601", {"_TZE284_iwyqtclw"}))
end

return { id = "ef00.switch.panel.m9pro", registrations = device_definitions, }
