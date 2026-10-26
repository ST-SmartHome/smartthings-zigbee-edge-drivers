local e=require"protocol.tuya"
local f=require"capabilities.events.all"
local b=require"contracts.helpers.family"
local d,a=b.definition_registry()local c={
profile="safety-presence-mw836p-core",magic_packet=true,query_on_configure=true,query_on_announce=true,announce_delay=0,time_start="off",datapoints={
e.dp_enum(1,{name="presence",endpoint=1,read_only=true,
converter=e.converter.from_only(function(g)return g==1 end),emit=f.presence()}),
e.dp_illuminance(103,{endpoint=1,read_only=true,emit=f.illuminance()})}}a(c,{
b.create_fingerprint("_TZE284_mexuq6lm","TS0601")})return{
id="ef00.presence.simple_sensors",registrations=d}
