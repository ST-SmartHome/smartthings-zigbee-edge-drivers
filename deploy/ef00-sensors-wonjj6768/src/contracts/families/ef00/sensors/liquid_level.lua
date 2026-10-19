local b=require"protocol.tuya"
local c=require"capabilities.events.all"
local e=require"contracts.helpers.family"
local a=b.converter
local l,g=e.definition_registry()
local function d(f,h)
if type(f)=="table"then
local n={}for p,o in pairs(f)do
n[p]=o
end
if n.query_on_configure==nil then
n.query_on_configure=true
end
g(n,h)return
end
g({
datapoints=f,query_on_configure=true,},h)
end
local m={
profile="sensors-liquid-level-872wz",force_time_updates=true,time_start="1970",datapoints={
b.dp_enum(1,{
name="liquid_state",emit=c.liquid_state(),read_only=true,converter=a.from_only(a.lookup_value({
[0]="normal",[1]="low",[2]="high",})),}),b.dp_numeric(2,{
name="liquid_depth",emit=c.wls872LiquidDepth(),read_only=true,converter=a.divide_by_pair(100),}),b.dp_numeric(7,{name="max_set",emit=c.wls872MaximumPercent()}),b.dp_numeric(8,{name="min_set",emit=c.wls872MinimumPercent()}),b.dp_binary(9,{
name="silent_mode",emit=c.wls872SilentMode(),converter=a.lookup_from_to({on=true,off=false}),}),b.dp_numeric(19,{
name="installation_height",emit=c.wls872InstallationHeight(),converter=a.divide_by_pair(100),}),b.dp_numeric(21,{
name="liquid_depth_max",emit=c.wls872MaximumDepth(),converter=a.divide_by_pair(100),}),b.dp_numeric(22,{
name="liquid_level_percent",emit=c.liquid_level_percent(),read_only=true,}),b.dp_numeric(27,{name="alarm_time",emit=c.wls872AlarmDuration()}),},query_on_configure=true,}d(m,{
e.create_fingerprint("_TZE204_7yyuo8sr","TS0601"),})local i={
profile="sensors-liquid-level-me201wz",force_time_updates=true,time_start="1970",datapoints={
b.dp_enum(1,{
name="liquid_state",emit=c.liquid_state(),read_only=true,converter=a.from_only(a.lookup_value({
[0]="normal",[1]="low",[2]="high",})),}),b.dp_numeric(2,{
name="liquid_depth",emit=c.me201LiquidDepth(),read_only=true,converter=a.divide_by_pair(100),}),b.dp_numeric(5,{
name="voltage",emit=c.voltage(),read_only=true,converter=a.divide_by_pair(10),}),b.dp_numeric(7,{name="max_set",emit=c.me201MaximumPercent()}),b.dp_numeric(8,{name="min_set",emit=c.me201MinimumPercent()}),b.dp_numeric(19,{
name="installation_height",emit=c.me201InstallationHeight(),converter=a.divide_by_pair(100),}),b.dp_numeric(21,{
name="liquid_depth_max",emit=c.me201MaximumDepth(),converter=a.divide_by_pair(100),}),b.dp_numeric(22,{
name="liquid_level_percent",emit=c.liquid_level_percent(),read_only=true,}),b.dp_binary(24,{
name="relay_switch",emit=c.me201RelaySwitch(),converter=a.lookup_from_to({on=true,off=false}),}),b.dp_binary(101,{
name="pump_mode",emit=c.me201PumpMode(),converter=a.lookup_from_to({supply=true,drainage=false}),}),b.dp_binary(102,{
name="pump_control",emit=c.me201PumpControl(),converter=a.lookup_from_to({auto=true,manual=false}),}),b.dp_string(103,{name="version",emit=c.me201Version(),read_only=true}),},query_on_configure=true,}d(i,{
e.create_fingerprint("_TZE284_kyyu8rbj","TS0601"),})local k={
profile="sensors-liquid-level-tlc2206",force_time_updates=true,time_start="1970",datapoints={
b.dp_enum(1,{
name="liquid_state",emit=c.liquid_state(),read_only=true,converter=a.from_only(a.lookup_value({
[0]="normal",[1]="low",[2]="high",})),}),b.dp_numeric(2,{
name="liquid_depth",emit=c.tlc2206LiquidDepth(),read_only=true,converter=a.divide_by_pair(100),}),b.dp_numeric(7,{name="max_set",emit=c.tlc2206MaximumPercent()}),b.dp_numeric(8,{name="min_set",emit=c.tlc2206MinimumPercent()}),b.dp_numeric(19,{
name="installation_height",emit=c.tlc2206InstallationHeight(),converter=a.divide_by_pair(1000),}),b.dp_numeric(21,{
name="liquid_depth_max",emit=c.tlc2206MaximumDepth(),converter=a.divide_by_pair(1000),}),b.dp_numeric(22,{
name="liquid_level_percent",emit=c.liquid_level_percent(),read_only=true,}),},query_on_configure=true,}d(k,{
e.create_fingerprint("_TZE200_lvkk0hdg","TS0601"),})local j={
profile="sensors-liquid-level-me202wz",force_time_updates=true,time_start="1970",datapoints={
b.dp_enum(1,{
name="liquid_state",emit=c.liquid_state(),read_only=true,converter=a.from_only(a.lookup_value({
[0]="normal",[1]="low",[2]="high",})),}),b.dp_numeric(2,{
name="liquid_depth",emit=c.me202LiquidDepth(),read_only=true,converter=a.divide_by_pair(100),}),b.dp_numeric(5,{
name="voltage",emit=c.voltage(),read_only=true,converter=a.divide_by_pair(10),}),b.dp_numeric(7,{name="max_set",emit=c.me202MaximumPercent()}),b.dp_numeric(8,{name="min_set",emit=c.me202MinimumPercent()}),b.dp_numeric(21,{
name="liquid_depth_max",emit=c.me202MaximumDepth(),converter=a.divide_by_pair(100),}),b.dp_numeric(22,{
name="liquid_level_percent",emit=c.liquid_level_percent(),read_only=true,}),b.dp_binary(24,{
name="relay_switch",emit=c.me202RelaySwitch(),converter=a.lookup_from_to({on=true,off=false}),}),b.dp_binary(101,{
name="pump_mode",emit=c.me202PumpMode(),converter=a.lookup_from_to({supply=true,drainage=false}),}),b.dp_binary(102,{
name="pump_control",emit=c.me202PumpControl(),converter=a.lookup_from_to({auto=true,manual=false}),}),b.dp_string(103,{name="version",emit=c.me202Version(),read_only=true}),},query_on_configure=true,}d(j,{
e.create_fingerprint("_TZE284_mxujdmxo","TS0601"),})return{
id="ef00.sensors.liquid_level",registrations=l,}
