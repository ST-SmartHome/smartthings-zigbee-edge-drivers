local aQ=require"protocol.zcl"
local function aJ()local c=require"protocol.tuya"
local d=require"capabilities.events.all"
local a=require"contracts.helpers.family"
local f=c.converter
local C,b=a.definition_registry()
local function aq(e)
local n=tonumber(e)
if n==nil then return nil end
if n<0 then return 0 end
if n>100 then return 100 end
return math.floor(n+0.5)
end
local aj=f.from_to(
function(e)
if e==0 then return"low"end
if e==1 then return"medium"end
if e==2 then return"high"end
return nil
end,
function(e)
if e=="low"then return 0 end
if e=="medium"then return 1 end
if e=="high"or e=="on"then return 2 end
return nil
end
)local ah=f.from_to(
function(e)
local n=tonumber(e)or 0
if n<=0 then return"low"end
if n==1 then return"low"end
if n==2 then return"medium"end
return"high"
end,
function(e)
if e=="low"then return 1 end
if e=="medium"then return 2 end
if e=="high"or e=="on"then return 4 end
return nil
end
)local ax=f.from_to(
function(e)
if e<=300 then return 20 end
if e<=410 then return 40 end
if e<=520 then return 60 end
if e<=650 then return 80 end
return 100
end,
function(e)
local P=aq(e)
if P==nil then return nil end
if P<=20 then return 300 end
if P<=40 then return 410 end
if P<=60 then return 520 end
if P<=80 then return 650 end
return 1000
end
)local am=f.from_to(
function(e)
if e<=300 then return 10 end
if e<=410 then return 30 end
if e<=520 then return 50 end
if e<=650 then return 70 end
return 100
end,
function(e)
local P=aq(e)
if P==nil then return nil end
if P<=10 then return 300 end
if P<=30 then return 410 end
if P<=50 then return 520 end
if P<=70 then return 650 end
return 1000
end
)local ab=f.from_to(aq,aq)local N={
profile="fans-fan-light-switch",c.dp_on_off(1,{name="switch",component="main",emit=d.switch()}),c.dp_fan_mode(101,{component="main",emit=d.fan_mode(),converter=aj}),c.dp_power_on_behavior(11,{emit=d.fanLightHmqzPowerOnBehavior()}),c.dp_on_off(5,{name="switch",component="light",emit=d.switch()})}local O=f.from_to(
function(e)
local n=tonumber(e)
if n==nil then return nil end
return n+1
end,
function(e)
local n=tonumber(e)
if n==nil then return nil end
if n<1 then n=1 end
if n>5 then n=5 end
return n-1
end
)local ao={
profile="fans-switch-fan-speed-r32ctezx",c.dp_on_off(1,{name="switch",component="main",emit=d.switch()}),c.dp_countdown(2,{name="countdown",emit=d.fanSwitchR32Countdown()}),c.dp_enum(3,{
name="fan_speed",emit=d.fanSwitchR32FanSpeed(),converter=O}),c.dp_power_on_behavior(11,{emit=d.fanSwitchR32PowerOnBehavior()})}b(ao,a.create_fingerprints("TS0601",{
"_TZE200_r32ctezx","_TZE204_r32ctezx","_TZE28C1000000_z5jz7wpo"}))b(N,a.create_fingerprints("TS0601",{
"_TZE200_hmqzfqml","_TZE200_qanl25yu"}))b(N,{
a.create_fingerprint("Liwokit","Fan+Light-01"),a.create_fingerprint("Lerlink","T2-Z67/T2-W67")})local R={
profile="fans-fan-speed-light-switch-lawxy9e2",c.dp_on_off(1,{name="switch",component="main",emit=d.switch()}),c.dp_enum(3,{
name="fan_speed",emit=d.fanLightLawxFanSpeed(),converter=O}),c.dp_power_on_behavior(11,{emit=d.fanLightHmqzPowerOnBehavior()}),c.dp_on_off(5,{name="switch",component="light",emit=d.switch()})}b(R,a.create_fingerprints("TS0601",{
"_TZE200_lawxy9e2","_TZE204_lawxy9e2"}))local x={
profile="fans-fan-level-light-switch",c.dp_on_off(1,{name="switch",component="main",emit=d.switch()}),c.dp_numeric(4,{name="brightness",component="main",emit=d.level(),converter=ab}),c.dp_on_off(5,{name="switch",component="light",emit=d.switch()}),c.dp_power_on_behavior(11,{emit=d.fanDimmerBqlPowerOnBehavior()}),c.dp_indicator_mode(12,{
name="indicator_mode",emit=d.fanDimmerBqlIndicator(),converter=f.lookup_from_to{
off=0,off_on=1,on=2}}),c.dp_on_off(13,{
name="backlight",emit=d.fanDimmerBqlBacklight(),converter=f.lookup_from_to{off=false,on=true}}),c.dp_child_lock(104,{
name="child_lock",emit=d.fanDimmerBqlChildLock(),converter=f.lookup_from_to{off=false,on=true}}),c.dp_numeric(105,{
name="minimum_speed",emit=d.fanDimmerBqlMinimumSpeed(),converter=ab})}b(x,a.create_fingerprints("TS0601",{
"_TZE204_bql5khqx","_TZE204_2jnoy8dj"}))b(x,{
a.create_fingerprint("Coswall","X99-G-kbFan-1g-ZG-LN-11"),a.create_fingerprint("Zemismart","ZN2S-RS1E-FL / ZN2S-US1U-FL")})local J={
profile="fans-fan-level-light-dimmer",c.dp_on_off(1,{name="switch",component="main",emit=d.switch()}),c.dp_numeric(6,{name="brightness",component="main",emit=d.level(),converter=ax}),c.dp_on_off(104,{name="switch",component="light",emit=d.switch()}),c.dp_numeric(105,{name="brightness",component="light",emit=d.level(),converter=am})}b(J,a.create_fingerprints("TS0601",{
"_TZE284_ikul00sx"}))local ac=f.from_to(
function(e)
local ag=tonumber(e)
if ag==nil then return nil end
return math.floor(ag/3600*100+0.5)/100
end,
function(e)
local aM=tonumber(e)
if aM==nil then return nil end
local ag=math.floor(aM*3600+0.5)
if ag>43200 then return 43200 end
return ag
end
)local an={
profile="fans-switch-fan-mode-ceiling-z5jz7wpo",c.dp_on_off(1,{name="switch",component="main",emit=d.switch()}),c.dp_countdown(2,{
name="countdown_hours",emit=d.fanCeilingZ5jzCountdownHours(),converter=ac}),c.dp_fan_mode(3,{component="main",emit=d.fan_mode(),converter=ah}),c.dp_power_on_behavior(11,{emit=d.fanCeilingZ5jzPowerOnBehavior()}),c.dp_enum(12,{
name="light_mode",emit=d.fanCeilingZ5jzLightMode(),converter=f.lookup_from_to{none=0,relay=1,pos=2}})}b(an,a.create_fingerprints("TS0601",{
"_TZE284_z5jz7wpo"}))
return C end
local function aC()
local ay=require"st.capabilities"
local c=require"protocol.tuya"
local d=require"capabilities.events.all"
local a=require"contracts.helpers.family"
local as=require"st.zigbee.device_management"
local C,b=a.definition_registry()local f=c.converter
local B="oa1odmga_color_hue"
local r="oa1odmga_color_saturation"
local q="oa1odmga_color_brightness"
local t={minimum=2000,maximum=6536}
local function ad(e,aG,aF)
if e<aG then return aG end
if e>aF then return aF end
return e
end
local function ar(e)
return math.floor(e+0.5)
end
local function T(e,aK)
if type(e)~="string"or #e<12 then
return nil
end
return tonumber(e:sub(aK,aK+3),16)
end
local function aa(e,h)
local aD=T(e,1)
if aD==nil then return nil end
local ak=ad(aD/3.6,0,100)h:set_field(B,ak,{persist=false})return ak
end
local function L(e,h)
local aS=T(e,5)
if aS==nil then return nil end
local l=ad(aS/10,0,100)h:set_field(r,l,{persist=false})return l
end
local function Z()
return f.from_to(
function(e,h)
local y=ad((tonumber(e)or 0)*100/254,0,100)h:set_field(q,y,{persist=false})return y
end,
function(e,h)
local y=ad(tonumber(e)or 0,0,100)h:set_field(q,y,{persist=false})return ar(y*254/100)
end
)
end
local function K()
return f.from_to(
function(e)
local aH=tonumber(e)
if aH==nil or aH<=0 then return nil end
return ar(1000000/aH)
end,
function(e)
local az=tonumber(e)
if az==nil or az<=0 then return nil end
return ad(ar(1000000/az),153,500)
end
)
end
local function Q(h,aR,aw,av,aL)
local e=h:get_field(aR)
if e==nil and type(h.get_latest_state)=="function"then
e=h:get_latest_state("main",aw,av)
end
return tonumber(e)or aL
end
local function af(h,ak,l)
ak=ad(tonumber(ak)or 0,0,100)l=ad(tonumber(l)or 0,0,100)local y=ad(Q(
h,q,"switchLevel","level",100
),0,100)h:set_field(B,ak,{persist=false})h:set_field(r,l,{persist=false})return string.format("%04x%04x%04x",ar(ak*3.6),ar(l*10),ar(y*10))
end
local function z(h,e)
if type(e)~="table"then return nil end
local ak=e.hue
local l=e.saturation
if ak==nil or l==nil then return nil end
return{
{dp=2,datatype=c.DP_TYPE_ENUM,value=1},{dp=5,datatype=c.DP_TYPE_STRING,value=af(h,ak,l)}}
end
local function ap(h,e)
local l=Q(
h,r,"colorControl","saturation",100)return z(h,{hue=e,saturation=l})
end
local function X(h,e)
local ak=Q(h,B,"colorControl","hue",0)return z(h,{hue=ak,saturation=e})
end
local p=K()
local function H(_,e)
local aE=p.to(e)
if aE==nil then return nil end
return{
{dp=2,datatype=c.DP_TYPE_ENUM,value=0},{dp=4,datatype=c.DP_TYPE_VALUE,value=aE}}
end
local ae=c.dp_on_off(1,{name="switch",emit=d.switch()})local S=c.dp_numeric(3,{
name="brightness",emit=d.level(),converter=Z()})local V=c.dp_numeric(4,{
name="oa1odmga_color_temperature_report",read_only=true,emit=d.color_temperature(),converter=f.from_only(p.from)})local aA=c.dp_string(5,{
name="oa1odmga_color_hue_report",read_only=true,emit=d.color_hue(),converter=f.from_only(aa)})local al=c.dp_string(5,{
name="oa1odmga_color_saturation_report",read_only=true,emit=d.color_saturation(),converter=f.from_only(L)})local ai={
profile="lights-color-temperature-color",color_temperature_range=t,named_mapping={
named_mappings={
switch=ae,brightness=S,color_temperature=H,color=z,color_hue=ap,color_saturation=X}},datapoints={
ae,c.dp_enum(2,{name="oa1odmga_work_mode",read_only=true}),S,V,aA,al},
runtime_start=function(h)
h:emit_component_event(
{id="main"},ay.colorTemperature.colorTemperatureRange{
value=t,unit="K"})return true
end
}b(ai,a.create_fingerprints("TS0601",{
"_TZE284_oa1odmga"}))local i=f.scale_pair(0,1000,0,100)local D=f.lookup_from_to{
toggle=0,state=1,momentary=2}local m=f.from_to(
function(e)return math.floor(e*254/1000+0.5)end,
function(e)return math.floor(e*1000/254+0.5)end
)
local function j(o,U)
o.magic_packet=true
o.mcu_version_request_on_configure=true
o.query_on_configure=false
o.query_on_announce=false
o.initial_custom_state_query=false
o.refresh_state_query=false
o.time_start="off"
o.parent_refresh=function()end
o.zcl_clusters={
aQ.switch{name="knob_switch",read_only=true,read_on_configure=false,configure_reporting=U,maximum_interval=U and 0 or nil},aQ.level{name="knob_level",read_only=true,read_on_configure=false,configure_reporting=U,maximum_interval=U and 0 or nil}}
o.configure=U and function(aO,h)
for _,aN in ipairs{6,8}do
h:send(as.build_bind_request(h,aN,aO.environment_info.hub_zigbee_eui,1))
end
end or nil
end
local w={
profile="lights-dimmer-options-ts0601-la2c2uo9",minimum_brightness_capability="la2DimmerMinBrightness",c.dp_on_off(1,{name="switch",emit=d.switch(),skip=c.skip.state_on_and_brightness_present()}),c.dp_brightness(2,{name="brightness",emit=d.level()}),c.dp_min_brightness(3,{name="la2_dimmer_min_brightness",value_max=1000,emit=d.la2DimmerMinBrightness()}),c.dp_light_type(4,{datatype=c.DP_TYPE_VALUE,name="la2_dimmer_light_type",emit=d.la2DimmerLightType()}),c.dp_countdown(6,{name="la2_dimmer_countdown",emit=d.la2DimmerCountdown()}),c.dp_power_on_behavior(14,{name="la2_dimmer_power_on_behavior",datatype=c.DP_TYPE_VALUE,emit=d.la2DimmerPowerOnBehavior()}),c.dp_backlight_mode(21,{name="la2_dimmer_backlight_mode",emit=d.la2DimmerBacklightMode()})}j(w,false)b(w,a.create_fingerprints("TS0601",{
"_TZE200_la2c2uo9"}))local v={
profile="lights-dimmer-options-ts0601-dfxkcots",minimum_brightness_capability="dfxDimmerMinBrightness",c.dp_on_off(1,{name="switch",emit=d.switch(),skip=c.skip.state_on_and_brightness_present()}),c.dp_brightness(2,{name="brightness",emit=d.level()}),c.dp_min_brightness(3,{name="dfx_dimmer_min_brightness",value_max=1000,emit=d.dfxDimmerMinBrightness()}),c.dp_light_type(4,{datatype=c.DP_TYPE_VALUE,name="dfx_dimmer_light_type",emit=d.dfxDimmerLightType()}),c.dp_countdown(6,{name="dfx_dimmer_countdown",emit=d.dfxDimmerCountdown()}),c.dp_power_on_behavior(14,{name="dfx_dimmer_power_on_behavior",datatype=c.DP_TYPE_VALUE,emit=d.dfxDimmerPowerOnBehavior()})}j(v,false)b(v,a.create_fingerprints("TS0601",{
"_TZE200_dfxkcots"}))local g={
profile="lights-dimmer-options-ts0601",minimum_brightness_capability="tsd1MinimumBrightness",c.dp_on_off(1,{name="switch",emit=d.switch(),skip=c.skip.state_on_and_brightness_present()}),c.dp_brightness(2,{name="brightness",emit=d.level()}),c.dp_min_brightness(3,{name="tsd1_min_brightness",converter=m,emit=d.tsd1MinimumBrightness()}),c.dp_light_type(4,{datatype=c.DP_TYPE_VALUE,name="tsd1_light_type",emit=d.tsd1LightType()}),c.dp_max_brightness(5,{name="tsd1_max_brightness",converter=m,emit=d.tsd1MaximumBrightness()}),c.dp_countdown(6,{name="tsd1_countdown",emit=d.tsd1Countdown()}),c.dp_power_on_behavior(14,{name="tsd1_power_on_behavior",datatype=c.DP_TYPE_VALUE,emit=d.tsd1PowerOnBehavior()}),c.dp_backlight_mode(21,{name="tsd1_backlight_mode",emit=d.tsd1BacklightMode()})}j(g,false)b(g,a.create_fingerprints("TS0601",{
"_TZE200_ip2akl4w","_TZE200_1agwnems","_TZE200_579lguh2","_TZE200_vucankjx","_TZE204_hlx9tnzb","_TZE204_n9ctkb6j","_TZE204_9qhuzgo0","_TZE200_9cxuhakf","_TZE200_a0syesf5","_TZE200_3p5ydos3","_TZE200_swaamsoy","_TZE200_ojzhk75b","_TZE200_w4cryh2i","_TZE204_68utemio","_TZE200_9i9dt8is","_TZE200_ctq0k47x","_TZE200_ebwgzdqq","_TZE204_vevc4c6g","_TZE200_0nauxa0p","_TZE284_m1cvyneb","_TZE284_68utemio","_TZE28C1000000_68utemio","_TZE284_xc7dve2g"}))j(g,true)b(g,{
a.create_fingerprint("Lerlink","X706U"),a.create_fingerprint("Moes","ZS-EUD_1gang"),a.create_fingerprint("Larkkey","ZSTY-SM-1DMZG-EU"),a.create_fingerprint("Earda","EDM-1ZAA-EU"),a.create_fingerprint("Earda","EDM-1ZAB-EU"),a.create_fingerprint("Earda","EDM-1ZBA-EU"),a.create_fingerprint("Mercator Ikuü","SSWD01"),a.create_fingerprint("Moes","ZS-USD"),a.create_fingerprint("Lonsonho","EDM-1ZBB-EU"),a.create_fingerprint("Moes","EDM-1ZBB-EU"),a.create_fingerprint("Moes","ZS-SR-EUD-1"),a.create_fingerprint("Moes","MS-105Z"),a.create_fingerprint("Mercator Ikuü","SSWM-DIMZ"),a.create_fingerprint("Zemismart","ZN2S-US1-SD"),a.create_fingerprint("Mercator Ikuü","SSWRM-ZB")})local W={
profile="lights-dimmer-ion",minimum_brightness_capability="ionDimmerMin",c.dp_on_off(1,{name="switch",emit=d.switch(),skip=c.skip.state_on_and_brightness_present()}),c.dp_brightness(2,{name="brightness",emit=d.level()}),c.dp_min_brightness(3,{name="ion_min_brightness",converter=m,emit=d.ionDimmerMin()}),c.dp_max_brightness(5,{name="ion_max_brightness",converter=m,emit=d.ionDimmerMax()}),c.dp_countdown(6,{name="ion_countdown",emit=d.ionDimmerCountdown()}),c.dp_power_on_behavior(14,{datatype=c.DP_TYPE_VALUE,name="ion_power_on",emit=d.ionDimmerPowerOn()})}j(W,true)b(W,{
a.create_fingerprint("_TZE200_4mh6tyyo","TS0601"),a.create_fingerprint("_TZE200_ykgar0ow","TS0601"),a.create_fingerprint("ION Industries","ID200W-ZIGB"),a.create_fingerprint("ION Industries","90.500.090"),a.create_fingerprint("ION Industries","90.500.040")})j(W,false)b(W,{
a.create_fingerprint("_TZE200_0hb4rdnp","TS0601"),a.create_fingerprint("_TZE200_gne0e6mk","TS0601"),a.create_fingerprint("_TZE200_itp8dt7f","TS0601")})local at={
profile="lights-dimmer-zdms16-1",c.dp_on_off(1,{name="switch",emit=d.switch()}),c.dp_numeric(2,{name="brightness",emit=d.level(),converter=i}),c.dp_numeric(3,{name="zdms161_minimum_brightness",emit=d.zdmsOneMinimumBrightness(),converter=i}),c.dp_enum(4,{name="zdms161_switch_type",emit=d.zdmsOneSwitchType(),converter=D}),c.dp_numeric(5,{name="zdms161_maximum_brightness",emit=d.zdmsOneMaximumBrightness(),converter=i}),c.dp_countdown(6,{name="zdms161_countdown",emit=d.zdmsOneCountdown()}),c.dp_power_on_behavior(14,{name="zdms161_power_on_behavior",emit=d.zdmsOnePowerOnBehavior()})}b(at,a.create_fingerprints("TS0601",{
"_TZE204_2cyb66xl","_TZE204_5cuocqty","_TZE204_huu3td85","_TZE204_nqqylykc","_TZE204_tgdnh7pw","_TZE284_huu3td85","_TZE284_nqqylykc"}))local au={
profile="lights-dimmer-2-zdms16-2",c.dp_on_off(1,{name="switch",component="main",emit=d.switch()}),c.dp_numeric(2,{name="brightness",component="main",emit=d.level(),converter=i}),c.dp_numeric(3,{name="zdms162_minimum_brightness",component="main",emit=d.zdmsTwoMinimumBrightness(),converter=i}),c.dp_enum(4,{name="zdms162_switch_type",component="main",emit=d.zdmsTwoSwitchType(),converter=D}),c.dp_numeric(5,{name="zdms162_maximum_brightness",component="main",emit=d.zdmsTwoMaximumBrightness(),converter=i}),c.dp_countdown(6,{name="zdms162_countdown",component="main",emit=d.zdmsTwoCountdown()}),c.dp_on_off(7,{name="switch",component="switch2",emit=d.switch()}),c.dp_numeric(8,{name="brightness",component="switch2",emit=d.level(),converter=i}),c.dp_numeric(9,{name="zdms162_minimum_brightness",component="switch2",emit=d.zdmsTwoMinimumBrightness(),converter=i}),c.dp_enum(10,{name="zdms162_switch_type",component="switch2",emit=d.zdmsTwoSwitchType(),converter=D}),c.dp_numeric(11,{name="zdms162_maximum_brightness",component="switch2",emit=d.zdmsTwoMaximumBrightness(),converter=i}),c.dp_countdown(12,{name="zdms162_countdown",component="switch2",emit=d.zdmsTwoCountdown()}),c.dp_power_on_behavior(14,{name="zdms162_power_on_behavior",emit=d.zdmsTwoPowerOnBehavior()})}b(au,a.create_fingerprints("TS0601",{
"_TZE204_fjms2pi9","_TZE204_jtbgusdc","_TZE204_o9gyszw2","_TZE284_fjms2pi9","_TZE284_jtbgusdc","_TZE28C1000000_jtbgusdc"}))local E={
profile="lights-dimmer-whpb9yts",c.dp_on_off(1,{name="switch",emit=d.switch()}),c.dp_brightness(3,{name="brightness",emit=d.level()}),c.dp_light_type(4,{name="light_type",emit=d.whpb9ytsLightType()}),c.dp_max_brightness(5,{
name="max_brightness",value_max=1000,emit=d.whpb9ytsMaxBrightness()}),c.dp_countdown(6,{name="countdown",emit=d.whpb9ytsCountdown()}),c.dp_power_on_behavior(14,{emit=d.whpb9ytsPowerOnBehavior()}),c.dp_backlight_mode(21,{name="backlight_mode",emit=d.whpb9ytsBacklightMode()})}b(E,a.create_fingerprints("TS0601",{
"_TZE200_whpb9yts"}))local F={
profile="lights-dimmer-qzaing2g",c.dp_backlight_mode_off_on(16,{
name="backlight_mode",emit=d.qzaing2gBacklightMode()}),c.dp_current(21,{emit=d.current()}),c.dp_power(22,{emit=d.power()}),c.dp_voltage(23,{emit=d.voltage()}),c.dp_child_lock(101,{name="child_lock",emit=d.qzaing2gChildLock()}),c.dp_on_off(141,{name="switch",emit=d.switch()}),c.dp_brightness(142,{name="brightness",emit=d.level()})}b(F,a.create_fingerprints("TS0601",{
"_TZE200_qzaing2g"}))local k={
profile="lights-dimmer-2",c.dp_on_off(1,{name="switch",component="main",emit=d.switch()}),c.dp_brightness(2,{name="brightness",component="main",emit=d.level()}),c.dp_min_brightness(3,{
name="min_brightness",component="main",value_max=1000,emit=d.dimmer2gMinBrightnessCh1()}),c.dp_light_type(4,{
name="light_type",component="main",emit=d.dimmer2gLightTypeCh1()}),c.dp_max_brightness(5,{
name="max_brightness",component="main",value_max=1000,emit=d.dimmer2gMaxBrightnessCh1()}),c.dp_countdown(6,{
name="countdown",component="main",emit=d.dimmer2gCountdownCh1()}),c.dp_on_off(7,{name="switch",component="switch2",emit=d.switch()}),c.dp_brightness(8,{name="brightness",component="switch2",emit=d.level()}),c.dp_min_brightness(9,{
name="min_brightness",component="switch2",value_max=1000,emit=d.dimmer2gMinBrightnessCh2()}),c.dp_light_type(10,{
name="light_type",component="switch2",emit=d.dimmer2gLightTypeCh2()}),c.dp_max_brightness(11,{
name="max_brightness",component="switch2",value_max=1000,emit=d.dimmer2gMaxBrightnessCh2()}),c.dp_countdown(12,{
name="countdown",component="switch2",emit=d.dimmer2gCountdownCh2()}),c.dp_power_on_behavior(14,{emit=d.dimmer2gPowerOnBehavior()})}b(k,a.create_fingerprints("TS0601",{
"_TZE200_bxoo2swd","_TZE204_bxoo2swd","_TZE200_tsxpl0d0","_TZE200_fjjbhx9d","_TZE200_e3oitdyu","_TZE200_gwkapsoq","_TZE204_zenj4lxv"}))b(k,a.create_fingerprints("TS110E",{
"_TZE200_ubgdwsnr"}))b(k,{
a.create_fingerprint("Moes","ZM-105B-M"),a.create_fingerprint("KnockautX","FMD2C018"),a.create_fingerprint("Moes","ZS-EUD_2gang"),a.create_fingerprint("Moes","MS-105B"),a.create_fingerprint("Moes","ZS-SR-EUD-2")})local s={
profile="lights-dimmer-3",c.dp_on_off(1,{name="switch",component="main",emit=d.switch()}),c.dp_brightness(2,{name="brightness",component="main",emit=d.level()}),c.dp_min_brightness(3,{
name="min_brightness",component="main",value_max=1000,emit=d.dimmer3gMinBrightnessCh1()}),c.dp_light_type(4,{
name="light_type",component="main",emit=d.dimmer3gLightTypeCh1()}),c.dp_max_brightness(5,{
name="max_brightness",component="main",value_max=1000,emit=d.dimmer3gMaxBrightnessCh1()}),c.dp_countdown(6,{
name="countdown",component="main",emit=d.dimmer3gCountdownCh1()}),c.dp_on_off(7,{name="switch",component="switch2",emit=d.switch()}),c.dp_brightness(8,{name="brightness",component="switch2",emit=d.level()}),c.dp_min_brightness(9,{
name="min_brightness",component="switch2",value_max=1000,emit=d.dimmer3gMinBrightnessCh2()}),c.dp_light_type(10,{
name="light_type",component="switch2",emit=d.dimmer3gLightTypeCh2()}),c.dp_max_brightness(11,{
name="max_brightness",component="switch2",value_max=1000,emit=d.dimmer3gMaxBrightnessCh2()}),c.dp_countdown(12,{
name="countdown",component="switch2",emit=d.dimmer3gCountdownCh2()}),c.dp_power_on_behavior(14,{emit=d.dimmer3gPowerOnBehavior()}),c.dp_on_off(15,{name="switch",component="switch3",emit=d.switch()}),c.dp_brightness(16,{name="brightness",component="switch3",emit=d.level()}),c.dp_min_brightness(17,{
name="min_brightness",component="switch3",value_max=1000,emit=d.dimmer3gMinBrightnessCh3()}),c.dp_light_type(18,{
name="light_type",component="switch3",emit=d.dimmer3gLightTypeCh3()}),c.dp_max_brightness(19,{
name="max_brightness",component="switch3",value_max=1000,emit=d.dimmer3gMaxBrightnessCh3()}),c.dp_countdown(20,{
name="countdown",component="switch3",emit=d.dimmer3gCountdownCh3()}),c.dp_backlight_mode(21,{
name="backlight_mode",emit=d.dimmer3gBacklightMode()}),c.dp_enum(101,{
name="backlight_color",emit=d.dimmer3gBacklightColor(),converter=f.lookup_from_to{
red=0,blue=1,green=2,white=3,yellow=4,magenta=5,cyan=6,warm_white=7}}),c.dp_numeric(103,{
name="backlight_brightness",emit=d.dimmer3gBacklightBrightness()})}b(s,a.create_fingerprints("TS0601",{
"_TZE200_vm1gyrso","_TZE204_1v1dxkck","_TZE204_znvwzxkq","_TZE284_znvwzxkq","_TZE200_vizxbhco"}))b(s,{
a.create_fingerprint("Moes","ZS-EUD_3gang"),a.create_fingerprint("Moes","ZS-SR-EUD-3"),a.create_fingerprint("Zemismart","ZN2S-RS3E-DH")})local u={
profile="lights-dimmer-dcnsggvz",c.dp_on_off(1,{name="switch",emit=d.switch()}),c.dp_brightness(2,{name="brightness",emit=d.level()}),c.dp_min_brightness(3,{
name="min_brightness",value_max=1000,emit=d.dcnsggvzMinBrightness()}),c.dp_light_type(4,{name="light_type",emit=d.dcnsggvzLightType()}),c.dp_max_brightness(5,{
name="max_brightness",value_max=1000,emit=d.dcnsggvzMaxBrightness()}),c.dp_countdown(6,{name="countdown",emit=d.dcnsggvzCountdown()}),c.dp_power_on_behavior(14,{emit=d.dcnsggvzPowerOnBehavior()}),c.dp_switch_type(57,{emit=d.dcnsggvzSwitchType()})}b(u,a.create_fingerprints("TS0601",{
"_TZE204_dcnsggvz","_TZE200_dcnsggv","_TZE200_dcnsggvz"}))local I={
profile="lights-dimmer-knob-p0gzbqct",c.dp_on_off(1,{name="switch",emit=d.switch()}),c.dp_brightness(2,{name="brightness",emit=d.level()}),c.dp_min_brightness(3,{
name="min_brightness",value_max=1000,emit=d.p0gzbqctMinBrightness()}),c.dp_light_type(4,{name="light_type",emit=d.p0gzbqctLightType()}),c.dp_indicator_mode_none_relay_pos(21,{
name="indicator_mode",emit=d.p0gzbqctIndicatorMode()})}b(I,a.create_fingerprints("TS0601",{
"_TZE200_p0gzbqct"}))local A={
profile="lights-color-temperature",c.dp_on_off(102,{name="switch",emit=d.switch()}),c.dp_brightness(103,{name="brightness",emit=d.level(),scale=1000}),c.dp_color_temperature(107,{name="color_temperature",emit=d.color_temperature(),scale=1000}),c.dp_enum(105,{name="adjustment_mode"}),c.dp_power_on_behavior(106,{}),c.dp_enum(111,{name="action_1"}),c.dp_enum(112,{name="action_2"}),c.dp_on_off(121,{name="state_l1"}),c.dp_on_off(122,{name="state_l2"}),c.dp_switch_mode(131,{name="switch_mode_l1"}),c.dp_switch_mode(132,{name="switch_mode_l2"}),c.dp_enum(141,{name="mode"})}b(A,a.create_fingerprints("TS0601",{
"_TZE200_tgeqdjgk","_TZE284_tgeqdjgk"}))local Y={
profile="lights-dimmer-ts0601-light",c.dp_on_off(1,{name="switch",emit=d.switch()}),c.dp_power_on_behavior(2,{emit=d.ts0601LightPowerOnBehavior()}),c.dp_brightness(3,{name="brightness",emit=d.level()})}b(Y,a.create_fingerprints("TS0601",{
"_TZE200_86nbew0j","_TZE200_io0zdqh1","_TZE200_drs6j6m5","_TZE204_drs6j6m5","_TZE200_ywe90lt0","_TZE200_qyss8gjy"}))return C
end
local G={}
local function M(aP)
for _,aB in ipairs(aP)do
G[#G+1]=aB
end
end
M(aJ())M(aC())aQ.attach_reporting_capabilities(G,{
{13,"rpt-txv"},{14,"rpt-tpf"}})return{
id="ef00.lights",registrations=G}
