local F=require"st.zigbee.device_management"
local ai=require"st.capabilities"
local ab=require"st.zigbee.data_types"
local q=require("st.zigbee.zcl.global_commands").ReadReportingConfigurationResponse.ReportingConfigurationRecord
local S,ag=q.deserialize,q.get_fields
q.deserialize=function(aA)
local e=S(aA)if e.status.value~=0 and not e.direction then
e.direction=ab.Uint8.deserialize(aA)e.attr_id=ab.AttributeId.deserialize(aA)
end
return e
end
q.get_fields=function(e)
local N=ag(e)N[2],N[3]=e.direction,e.attr_id
return N
end
local c={}local i=setmetatable({},{__mode="k"})local R={[1032]=true,[1037]=true,[1066]=true,[1067]=true}local X={
[0]={[0]="Heartbeat"},[1]={[32]="BattVolt",[33]="Battery",[62]="BattAlarm",[64]="BattTwo"},[2]={[0]="DeviceTmp"},[6]={[0]="Switch",[16387]="PowerOn"},[8]={[0]="Level"},[13]={[85]="Analog"},[15]={[85]="Binary"},[257]={[0]="Lock"},[258]={[8]="Position",[9]="Tilt"},[513]={[0]="LocalTemp",[8]="Demand",[16]="TempCal",[17]="CoolSet",[18]="HeatSet",[28]="Mode",[41]="State"},[514]={[0]="FanMode"},[768]={[0]="Hue",[1]="Sat",[7]="ColorTemp"},[1024]={[0]="Light"},[1026]={[0]="Temp"},[1027]={[0]="Pressure",[4]="ScalePres"},[1029]={[0]="Humidity"},[1030]={[0]="Occupancy"},[1032]={[0]="Soil"},[1037]={[0]="CoTwo"},[1066]={[0]="PmFine"},[1067]={[0]="Hcho"},[1280]={[2]="Ias"},[1794]={[0]="Energy",[1]="Export",[1024]="Power"},[2820]={[768]="Frequency",[772]="TotalPwr",[1285]="Voltage",[1288]="Current",[1291]="Power",[2309]="VoltageB",[2565]="VoltageC",[2312]="CurrentB",[2568]="CurrentC"},}local N={
{"minimum_interval","Min","minimumInterval"},{"maximum_interval","Max","maximumInterval"},{"reportable_change","Change","reportableChange"},}
function c.describe(r,l,b,aH)
local d=r.mapping_meta(l,aH)local m=d.reporting_defaults or d
if d.write_only or d.cluster_id==nil or d.attribute_id==nil or
d.data_type==nil or d.mfg_code~=nil or d.cluster_id>=64512 or
(m.minimum_interval==nil and m.maximum_interval==nil and
m.reportable_change==nil and d.physical_reportable_change==nil)or
(b~=nil and m.supported~=nil and not m.supported(b))or
(r.get_generated_attribute(d.cluster_id,d.attribute_id)==nil and
not(R[d.cluster_id]and d.attribute_id==0))then
return nil
end
local endpoint=type(d.endpoint)=="number"and tostring(d.endpoint)or"auto"
local item=m.label=="Soil moisture"and"Soil"or(X[d.cluster_id]or{})[d.attribute_id]
if item==nil then return nil end
return{
key=m.key or string.format("zr%04x%04x%s",d.cluster_id,d.attribute_id,endpoint),group=string.format("%04x:%04x",d.cluster_id,d.attribute_id),meta=d,defaults=m,analog=not d.data_type.is_discrete,item=item,}
end
local function ae(b,key)
local X=i[b]local item=X and X[key]
if item and item.expires<=os.time()then X[key],item=nil,nil end
return item
end
local function M(b,descriptor,ad)
local j=ad and ae(b,descriptor.key)return j and not j.failed and j.selected or b:get_field("zcl_reporting:"..descriptor.key)
end
local function ac(b,h,z,n,aE)
if n==nil or not b:supports_capability_by_id(h)then return end
local av={value=n}
if aE then av.unit=aE end
b:emit_event(ai[h][z](av))
end
function c.configuration(r,b,l,y)
local descriptor=c.describe(r,l,b)
if descriptor==nil then return nil end
local d=descriptor.meta
local m=descriptor.defaults
local f=M(b,descriptor,true)if y~=nil then
b:set_field("zcl_reporting_default:"..descriptor.key,y)local aq=b:get_field("zcl_reporting_change:"..descriptor.key)if aq and(f==nil or f.reportable_change==nil)then
ac(b,aq,"reportableChange",y)
end
end
local an=f or{}local o=an.maximum_interval or m.maximum_interval or 300
local s=an.reportable_change
if s==nil then
s=m.reportable_change
if d.physical_reportable_change~=nil then
s=y
end
end
if o==65535 then s=0 end
if descriptor.analog and s==nil then return nil end
if descriptor.analog and type(s)~="table"then
if d.data_type.ID==57 then
local ay=require"st.buf".Reader
s=d.data_type.deserialize(ay(string.pack("<f",s)))else
s=d.data_type(s)
end
end
return{
cluster=d.cluster_id,attribute=d.attribute_id,data_type=d.data_type,minimum_interval=an.minimum_interval or m.minimum_interval or 0,maximum_interval=o,reportable_change=descriptor.analog and s or nil,},f~=nil
end
local function E(r,b,g,p)
local l=g.zcl_clusters[p]local descriptor=c.describe(r,l,b)
if descriptor then return descriptor end
local al=c.describe(r,l)if al then
for _,au in ipairs(g.zcl_clusters)do
descriptor=c.describe(r,au,b)
if descriptor and descriptor.key==al.key then return descriptor end
end
end
end
local function C(r,b,g)
for _,item in ipairs(g.reporting_settings)do
local descriptor=E(r,b,g,item.mapping_index)if descriptor then
local f=M(b,descriptor)or{}for x,field in ipairs(N)do
local h=item.capabilities[x]if h then
local n=f[field[1]]or descriptor.defaults[field[1]]
if type(n)=="table"then n=n.value end
if n==nil and x==3 then
n=b:get_field("zcl_reporting_default:"..descriptor.key)
end
if x==3 then b:set_field("zcl_reporting_change:"..descriptor.key,h)end
ac(b,h,field[3],n,x<3 and"s")
end
end
end
end
end
function c.set(r,b,g,p,field,n)
local descriptor=E(r,b,g,p)
if descriptor==nil or type(n)~="number"or n~=n or n<0 then return false end
local L=descriptor.meta.data_type
local ak=field=="reportable_change"and L.ID==57
local as=field=="minimum_interval"and 65534 or 65535
if field=="reportable_change"then
if not descriptor.analog then return false end
local aD=L.ID>=40 and L.ID<=47
as=ak and 3.4028234663852886e38 or(2 ^(8*L.byte_length-(aD and 1 or 0))-1)
end
if n>as or(not ak and n%1~=0)then return false end
local f={}
for key,aI in pairs(M(b,descriptor,true)or{})do f[key]=aI end
f[field]=n
local aw=f.minimum_interval or descriptor.defaults.minimum_interval or 0
local o=f.maximum_interval or descriptor.defaults.maximum_interval or 300
if o~=0 and o~=65535 and aw>o then return false end
if field=="reportable_change"and o==65535 then return false end
i[b]=i[b]or{}i[b][descriptor.key]={selected=f,entry=g,targets={},expires=os.time()+30}local O={[descriptor.group]={[descriptor.key]=true}}if c.send(r,b,g.zcl_clusters,O,false)and r.read_metering_scalers then
r.read_metering_scalers(b,g.zcl_clusters)
end
return true
end
function c.send_config(b,key,w,endpoint)
local tx=F.attr_config(b,w):to_endpoint(endpoint)local j=key and ae(b,key)if j and not j.failed then
j.targets[w.cluster..":"..endpoint]={wire=tx.body.zcl_body:_serialize()}
end
b:send(tx)
end
function c.global_handlers(r,B)
local function Z(_,b,rx)
local u,endpoint=rx.address_header.cluster.value,rx.address_header.src_endpoint.value
local W,at=rx.body.zcl_header.cmd.value,rx.body.zcl_body
local ao=u..":"..endpoint
for key in pairs(i[b]or{})do
local j=ae(b,key)local am=j and j.targets[ao]if am then
local z=string.unpack("<I2",am.wire,2)if W==7 then
local aB=require"st.zigbee.zcl.global_commands.read_reporting_configuration"
local tx=F.attr_refresh(b,u,z):to_endpoint(endpoint)tx.body.zcl_body=aB.ReadReportingConfiguration({aB.ReadReportingConfigurationAttributeRecord(0,z)})tx.body.zcl_header.cmd.value=8
b:send(tx)elseif W==11 then
if(at.cmd.value==6 or at.cmd.value==8)and at.status.value~=0 then j.failed=true end
else
for _,e in ipairs(at.read_reporting_records)do
if getmetatable(e)==q and e.direction.value==0 and e.attr_id.value==z then
if e:_serialize():sub(2)==am.wire then
j.targets[ao]=nil
if not next(j.targets)then
b:set_field("zcl_reporting:"..key,j.selected,{persist=true})b:remove_configured_attribute(u,z)i[b][key]=nil
C(r,b,j.entry)
end
else
j.failed=true
end
end
end
end
end
end
end
for u in pairs(X)do
B[u]=B[u]or{}B[u][7],B[u][9],B[u][11]=Z,Z,Z
end
return B
end
function c.attach(r,ah,Q)
for _,V in ipairs(Q)do
local g=ah[V[1]]local P,K=g.runtime_start,g.zcl_refresh_before_read_all
local af,H={},{}
for key,aF in pairs(g.protocol_writers or{})do af[key]=aF end
for _,W in ipairs(g.capability_commands or{})do H[#H+1]=W end
g.protocol_writers,g.capability_commands,g.reporting_settings=af,H,{}local aa={zcl_clusters=g.zcl_clusters,reporting_settings=g.reporting_settings}g.profile=V[2]local aC={}for p,l in ipairs(g.zcl_clusters or{})do
local descriptor=c.describe(r,l,nil,false)if descriptor and not aC[descriptor.key]then
aC[descriptor.key]=true
local logical_item=V[3]and V[3][descriptor.key]
if logical_item==nil then logical_item=descriptor.item end
if logical_item~=false then
local item={mapping_index=p,key=descriptor.key,capabilities={}}g.reporting_settings[#g.reporting_settings+1]=item
for x,field in ipairs(N)do
if x<3 or descriptor.analog then
local short_id="zcl"..logical_item.."Report"..field[2]..
(x==3 and string.format("%02x",descriptor.meta.data_type.ID)or"")local h="concertmirror08464."..short_id
local aj="set"..field[3]:sub(1,1):upper()..field[3]:sub(2)local T="zcl_reporting_"..short_id
item.capabilities[x]=h
H[#H+1]={capability_id=h,command_name=aj,argument_name=field[3],mapping_name=T,attribute_name=field[3]}
af[T]=function(b,n)
return c.set(r,b,aa,p,field[1],n)
end
end
end
end
end
end
g.runtime_start=function(b,...)
local U
if P then U=P(b,...)end
C(r,b,aa)return U
end
g.zcl_refresh_before_read_all=function(b,...)
local U
if K then U=K(b,...)end
C(r,b,aa)return U
end
end
end
function c.groups(r,b,Y)
local O={}for _,l in ipairs(Y or{})do
local descriptor=c.describe(r,l,b)if descriptor~=nil then
if M(b,descriptor)~=nil then
O[descriptor.group]=true
end
end
end
return O
end
function c.send(r,b,Y,O,az)
local G,ar,Q,J={},{},{},false
for _,l in ipairs(Y or{})do
local descriptor=c.describe(r,l,b)local f=descriptor and O[descriptor.group]if descriptor~=nil and f and(f==true or f[descriptor.key])and
not(az and descriptor.meta.reporting_defaults~=nil)then
local d=descriptor.meta
local ap=r.build_mapping_context(b,l)local t={}if ap.endpoint~=nil then
t[1]=ap.endpoint
elseif d.reporting_defaults~=nil then
t[1]=b:get_endpoint(d.cluster_id)else
for _,endpoint in ipairs(b.zigbee_endpoints or{})do
if b:supports_server_cluster(d.cluster_id,endpoint.id)then t[#t+1]=endpoint.id end
end
if #t==0 then t[1]=b:get_endpoint(d.cluster_id)end
end
local w=c.configuration(r,b,l)
if w==nil then J=d.physical_reportable_change~=nil or J end
for _,endpoint in ipairs(t)do
local key=descriptor.group..":"..endpoint
local x=ar[key]local e={config=w,endpoint=endpoint,explicit=d.endpoint~=nil,key=descriptor.key}if x==nil then
ar[key]=#G+1
G[#G+1]=e
elseif e.explicit and not G[x].explicit then
G[x]=e
end
end
end
end
for _,e in ipairs(G)do
local w,endpoint=e.config,e.endpoint
if w~=nil then
local key=w.cluster..":"..endpoint
if az and not Q[key]then
r.bind_cluster(b,w.cluster,b.driver.environment_info.hub_zigbee_eui,endpoint)Q[key]=true
end
c.send_config(b,e.key,w,endpoint)
end
end
return J
end
return c
