-- Family-owned translation of ZHC cff1de47 color.ts math, not SDK safe helpers.
local lookup = require "contracts.helpers.ikea1624_xy"
local color = {}

function color.finite(value)
  return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end

function color.round(value, precision)
  local factor = 10 ^ (precision or 0)
  return math.floor(value * factor + 0.5) / factor
end

function color.rgb_xy(red, green, blue, gamma, rounded)
  if gamma then
    local function correct(value)
      return value > 0.04045 and ((value + 0.055) / 1.055) ^ 2.4 or value / 12.92
    end
    red, green, blue = correct(red), correct(green), correct(blue)
  end
  local x = red * 0.664511 + green * 0.154324 + blue * 0.162028
  local y = red * 0.283881 + green * 0.668433 + blue * 0.047685
  local z = red * 0.000088 + green * 0.07231 + blue * 0.986039
  local sum = x + y + z
  if sum == 0 then return 0, 0 end
  if rounded == false then return x / sum, y / sum end
  return color.round(x / sum, 4), color.round(y / sum, 4)
end

function color.hsv_xy(hue, saturation, rounded)
  local h, s = hue / 360, saturation / 100
  local i = math.floor(h * 6)
  local f = h * 6 - i
  local p, q, t = 1 - s, 1 - f * s, 1 - (1 - f) * s
  local rgb = ({ {1, t, p}, {q, 1, p}, {p, 1, t}, {p, q, 1}, {t, p, 1}, {1, p, q} })[i % 6 + 1]
  return color.rgb_xy(rgb[1], rgb[2], rgb[3], false, rounded)
end

function color.mired_xy(mired)
  if not color.finite(mired) or mired <= 0 then return nil end
  local kelvin = color.round(1000000 / mired)
  local row = lookup.at(kelvin)
  if row == nil then return nil end
  -- No rounding4 here: primary viaColor maps the full lookup precision to wire.
  return row[1], row[2]
end

function color.xy_mired(x, y)
  local n = (x - 0.332) / (0.1858 - y)
  return 1000000 / math.abs(437 * n ^ 3 + 3601 * n ^ 2 + 6861 * n + 5517)
end

function color.xy_hs(x, y)
  local X, Z = x / y, (1 - x - y) / y
  local red = X * 1.656492 - 0.354851 - Z * 0.255038
  local green = -X * 0.707196 + 1.655397 + Z * 0.036152
  local blue = X * 0.051713 - 0.121364 + Z * 1.01153
  if red > blue and red > green and red > 1 then
    green, blue, red = green / red, blue / red, 1
  elseif green > blue and green > red and green > 1 then
    red, blue, green = red / green, blue / green, 1
  elseif blue > red and blue > green and blue > 1 then
    red, green, blue = red / blue, green / blue, 1
  end
  if red ~= red or red < 0 then red = 0 end
  if green ~= green or green < 0 then green = 0 end
  if blue ~= blue or blue < 0 then blue = 0 end
  local maximum, minimum = math.max(red, green, blue), math.min(red, green, blue)
  local delta, hue = maximum - minimum, 0
  if maximum ~= minimum then
    if maximum == red then
      hue = (green - blue + delta * (green < blue and 6 or 0)) / (6 * delta)
    elseif maximum == green then
      hue = (blue - red + delta * 2) / (6 * delta)
    else
      hue = (red - green + delta * 4) / (6 * delta)
    end
  end
  return color.round(hue * 360), color.round(maximum == 0 and 0 or delta / maximum * 100)
end

-- Shape: {mode=0/1/2, color={x,y,hue,saturation}, mired=n}.
-- ST projection is separate: this function follows primary target discovery.
function color.sync(new, old, enabled)
  if not enabled then return new end
  local nc, oc = new.color or {}, old.color or {}
  local mode = new.mode
  if mode == nil then mode = old.mode end
  if mode == nil then
    if new.mired ~= nil then mode = 2 end
    if new.color ~= nil then mode = nc.hue ~= nil and 0 or 1 end
  end
  local xy_target = (oc.x ~= nil and oc.y ~= nil) or (nc.x ~= nil and nc.y ~= nil)
  local hs_target = (oc.hue ~= nil and oc.saturation ~= nil) or (nc.hue ~= nil and nc.saturation ~= nil)
  local mired_target = old.mired ~= nil or new.mired ~= nil
  local result = { mode = mode, color = {} }
  local out = result.color
  local function take(key)
    if nc[key] ~= nil then return nc[key] end
    return oc[key]
  end
  local function derive_mired(x, y)
    local value = color.round(color.xy_mired(x, y))
    if not color.finite(value) then return nil end
    if old.physical_min ~= nil and value < old.physical_min then return old.physical_min end
    if old.physical_max ~= nil and value > old.physical_max then return old.physical_max end
    return value
  end
  if mode == 0 then
    out.hue, out.saturation = take("hue"), take("saturation")
    if out.hue ~= nil and out.saturation ~= nil then
      local x, y = color.hsv_xy(out.hue, out.saturation, false)
      if mired_target then result.mired = derive_mired(x, y) end
      if xy_target then out.x, out.y = color.round(x, 4), color.round(y, 4) end
    end
  elseif mode == 1 then
    out.x, out.y = take("x"), take("y")
    if out.x ~= nil and out.y ~= nil then
      if mired_target then result.mired = derive_mired(out.x, out.y) end
      if hs_target then out.hue, out.saturation = color.xy_hs(out.x, out.y) end
    end
  elseif mode == 2 then
    result.mired = new.mired ~= nil and new.mired or old.mired
    if result.mired ~= nil then
      local x, y = color.mired_xy(result.mired)
      if x ~= nil then
        if xy_target then out.x, out.y = color.round(x, 4), color.round(y, 4) end
        if hs_target then out.hue, out.saturation = color.xy_hs(x, y) end
      end
    end
  end
  if next(out) == nil then result.color = nil end
  return result
end

return color
