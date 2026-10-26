local G=require"st.zigbee.device_management"
local aj=require"st.capabilities"
local ab=require"st.zigbee.data_types"
local s=require"st.zigbee.zcl.global_commands".ReadReportingConfigurationResponse.ReportingConfigurationRecord
local S,ah=s.deserialize,s.get_fields
s.deserialize=function(aC)
local g=S(aC)if g.status.value~=0 and not g.direction then
g.direction=ab.Uint8.deserialize(aC)g.attr_id=ab.AttributeId.deserialize(aC)
end
return g
end
s.get_fields=function(g)
local N=ah(g)N[2],N[3]=g.direction,g.attr_id
return N
end
local c={}local d=setmetatable({},{__mode="k"})local R={[1032]=true,[1037]=true,[1066]=true,[1067]=true}local X={
[0]={[0]="Heartbeat"},[1]={[32]="BattVolt",[33]="Battery",[62]="BattAlarm",[64]="BattTwo"},[2]={[0]="DeviceTmp"},[6]={[0]="Switch",[16387]="PowerOn"},[8]={[0]="Level"},[13]={[85]="Analog"},[15]={[85]="Binary"},[257]={[0]="Lock"},[258]={[8]="Position",[9]="Tilt"},[513]={[0]="LocalTemp",[8]="Demand",[16]="TempCal",[17]="CoolSet",[18]="HeatSet",[19]="CoolSet",[20]="HeatSet",[28]="Mode",[41]="State",[69]="Louver"},[514]={[0]="FanMode"},[768]={[0]="Hue",[1]="Sat",[7]="ColorTemp"},[1024]={[0]="Light"},[1026]={[0]="Temp"},[1027]={[0]="Pressure",[4]="ScalePres"},[1029]={[0]="Humidity"},[1030]={[0]="Occupancy"},[1032]={[0]="Soil"},[1036]={[0]="Co"},[1037]={[0]="CoTwo"},[1066]={[0]="PmFine"},[1067]={[0]="Hcho"},[1280]={[2]="Ias"},[1794]={[0]="Energy",[1]="Export",[1024]="Power"},[2820]={[768]="Frequency",[772]="TotalPwr",[773]="ReactivePwr",[1285]="Voltage",[1288]="Current",[1291]="Power",[2309]="VoltageB",[2565]="VoltageC",[2312]="CurrentB",[2568]="CurrentC"}}local N={
{"minimum_interval","Min","minimumInterval"},{"maximum_interval","Max","maximumInterval"},{"reportable_change","Change","reportableChange"}}
function c.describe(q,l,b,aI)
local e=q.mapping_meta(l,aI)local m=e.reporting_defaults or e
if e.write_only or e.cluster_id==nil or e.attribute_id==nil or
e.data_type==nil or e.mfg_code~=nil or e.cluster_id>=64512 or
(m.minimum_interval==nil and m.maximum_interval==nil and
m.reportable_change==nil and e.physical_reportable_change==nil)or
(b~=nil and m.supported~=nil and not m.supported(b))or
(q.get_generated_attribute(e.cluster_id,e.attribute_id)==nil and
not(R[e.cluster_id]and e.attribute_id==0)and
not(e.cluster_id==1794 and e.attribute_id==1 and e.data_type.ID==37))then
return nil
end
local endpoint=type(e.endpoint)=="number"and tostring(e.endpoint)or"auto"
local item=m.label=="Soil moisture"and"Soil"or(X[e.cluster_id]or{})[e.attribute_id]
if item==nil then return nil end
return{
key=m.key or string.format("zr%04x%04x%s",e.cluster_id,e.attribute_id,endpoint),group=string.format("%04x:%04x",e.cluster_id,e.attribute_id),meta=e,defaults=m,analog=not e.data_type.is_discrete,item=item}
end
local function af(b,key)
local X=d[b]local item=X and X[key]
if item and item.expires<=os.time()then X[key],item=nil,nil end
return item
end
local function M(b,descriptor,ad)
local f=ad and af(b,descriptor.key)return f and not f.failed and f.selected or b:get_field("zcl_reporting:"..descriptor.key)
end
local function ac(b,k,C,o,aG)
if o==nil or not b:supports_capability_by_id(k)then return end
local aw={value=o}
if aG then aw.unit=aG end
b:emit_event(aj[k][C](aw))
end
function c.configuration(q,b,l,t)
local descriptor=c.describe(q,l,b)
if descriptor==nil then return nil end
local e=descriptor.meta
local m=descriptor.defaults
local i=M(b,descriptor,true)if t~=nil then
local ae=type(t)=="table"and t.value or t
b:set_field("zcl_reporting_default:"..descriptor.key,ae)local ar=b:get_field("zcl_reporting_change:"..descriptor.key)if ar and(i==nil or i.reportable_change==nil)then
ac(b,ar,"reportableChange",ae)
end
end
local ao=i or{}local r=ao.maximum_interval or m.maximum_interval or 300
local u=ao.reportable_change
if u==nil then
u=m.reportable_change
if e.physical_reportable_change~=nil then
u=t
end
end
if r==65535 then u=0 end
if descriptor.analog and u==nil then return nil end
if descriptor.analog and type(u)~="table"then
if e.data_type.ID==57 then
local az=require"st.buf".Reader
u=e.data_type.deserialize(az(string.pack("<f",u)))else
u=e.data_type(u)
end
end
return{
cluster=e.cluster_id,attribute=e.attribute_id,data_type=e.data_type,minimum_interval=ao.minimum_interval or m.minimum_interval or 0,maximum_interval=r,reportable_change=descriptor.analog and u or nil},i~=nil
end
local function y(q,b,j,n)
local l=j.zcl_clusters[n]local descriptor=c.describe(q,l,b)
if descriptor then return descriptor end
local am=c.describe(q,l)if am then
for _,av in ipairs(j.zcl_clusters)do
descriptor=c.describe(q,av,b)
if descriptor and descriptor.key==am.key then return descriptor end
end
end
end
function c.discard_unsupported(q,b)
for key,f in pairs(d[b]or{})do
if not y(q,b,f.entry,f.mapping_index)then
d[b][key]=nil
end
end
end
local function E(q,b,j)
for _,item in ipairs(j.reporting_settings)do
local descriptor=y(q,b,j,item.mapping_index)if descriptor then
local i=M(b,descriptor)or{}for B,field in ipairs(N)do
local k=item.capabilities[B]if k then
local o=i[field[1]]or descriptor.defaults[field[1]]if o==nil and B==3 then
o=b:get_field("zcl_reporting_default:"..descriptor.key)
end
if type(o)=="table"then o=o.value end
if B==3 then b:set_field("zcl_reporting_change:"..descriptor.key,k)end
ac(b,k,field[3],o,B<3 and"s")
end
end
end
end
end
function c.set(q,b,j,n,field,o)
local descriptor=y(q,b,j,n)
if descriptor==nil or type(o)~="number"or o~=o or o<0 then return false end
local L=descriptor.meta.data_type
local al=field=="reportable_change"and L.ID==57
local at=field=="minimum_interval"and 65534 or 65535
if field=="reportable_change"then
if not descriptor.analog then return false end
local aF=L.ID>=40 and L.ID<=47
at=al and 3.4028234663852886e38 or(2 ^(8*L.byte_length-(aF and 1 or 0))-1)
end
if o>at or(not al and o%1~=0)then return false end
local i={}
for key,aJ in pairs(M(b,descriptor,true)or{})do i[key]=aJ end
i[field]=o
local ax=i.minimum_interval or descriptor.defaults.minimum_interval or 0
local r=i.maximum_interval or descriptor.defaults.maximum_interval or 300
if r~=0 and r~=65535 and ax>r then return false end
if field=="reportable_change"and r==65535 then return false end
d[b]=d[b]or{}d[b][descriptor.key]={selected=i,entry=j,mapping_index=n,targets={},expires=os.time()+30}local O={[descriptor.group]={[descriptor.key]=true}}local aL,v=pcall(c.send,q,b,j.zcl_clusters,O,false)if not aL then
d[b][descriptor.key]=nil
return false
end
if v and q.read_metering_scalers then
q.read_metering_scalers(b,j.zcl_clusters)
end
return true
end
function c.send_config(b,key,z,endpoint)
local tx=G.attr_config(b,z):to_endpoint(endpoint)local f=key and af(b,key)if f and not f.failed then
f.targets[z.cluster..":"..endpoint]={wire=tx.body.zcl_body:_serialize()}
end
b:send(tx)
end
function c.global_handlers(q,D)
local function Z(_,b,rx)
local w,endpoint=rx.address_header.cluster.value,rx.address_header.src_endpoint.value
local W,au=rx.body.zcl_header.cmd.value,rx.body.zcl_body
local ap=w..":"..endpoint
c.discard_unsupported(q,b)for key in pairs(d[b]or{})do
local f=af(b,key)local an=f and f.targets[ap]if an then
local C=string.unpack("<I2",an.wire,2)if W==7 then
local aD=require"st.zigbee.zcl.global_commands.read_reporting_configuration"
local tx=G.attr_refresh(b,w,C):to_endpoint(endpoint)tx.body.zcl_body=aD.ReadReportingConfiguration{aD.ReadReportingConfigurationAttributeRecord(0,C)}tx.body.zcl_header.cmd.value=8
if not pcall(b.send,b,tx)then
d[b][key]=nil
end
elseif W==11 then
if(au.cmd.value==6 or au.cmd.value==8)and au.status.value~=0 then f.failed=true end
else
for _,g in ipairs(au.read_reporting_records)do
if getmetatable(g)==s and g.direction.value==0 and g.attr_id.value==C then
if g:_serialize():sub(2)==an.wire then
f.targets[ap]=nil
if not next(f.targets)then
b:set_field("zcl_reporting:"..key,f.selected,{persist=true})b:remove_configured_attribute(w,C)d[b][key]=nil
E(q,b,f.entry)
end
else
f.failed=true
end
end
end
end
end
end
end
for w in pairs(X)do
D[w]=D[w]or{}D[w][7],D[w][9],D[w][11]=Z,Z,Z
end
return D
end
function c.attach(q,ai,Q)
for _,V in ipairs(Q)do
local j=ai[V[1]]local P,K=j.runtime_start,j.zcl_refresh_before_read_all
local ag,I={},{}
for key,aH in pairs(j.protocol_writers or{})do ag[key]=aH end
for _,W in ipairs(j.capability_commands or{})do I[#I+1]=W end
j.protocol_writers,j.capability_commands,j.reporting_settings=ag,I,{}local aa={zcl_clusters=j.zcl_clusters,reporting_settings=j.reporting_settings}j.profile=V[2]local aE={}for n,l in ipairs(j.zcl_clusters or{})do
local descriptor=c.describe(q,l,nil,false)if descriptor and not aE[descriptor.key]then
aE[descriptor.key]=true
local logical_item=V[3]and V[3][descriptor.key]
if logical_item==nil then logical_item=descriptor.item end
if logical_item~=false then
local item={mapping_index=n,key=descriptor.key,capabilities={}}j.reporting_settings[#j.reporting_settings+1]=item
for B,field in ipairs(N)do
if B<3 or descriptor.analog then
local short_id="zcl"..logical_item.."Report"..field[2]..
(B==3 and string.format("%02x",descriptor.meta.data_type.ID)or"")local k="concertmirror08464."..short_id
local ak="set"..field[3]:sub(1,1):upper()..field[3]:sub(2)local T="zcl_reporting_"..short_id
item.capabilities[B]=k
I[#I+1]={capability_id=k,command_name=ak,argument_name=field[3],mapping_name=T,attribute_name=field[3]}
ag[T]=function(b,o)
return c.set(q,b,aa,n,field[1],o)
end
end
end
end
end
end
j.runtime_start=function(b,...)
local U
if P then U=P(b,...)end
E(q,b,aa)return U
end
j.zcl_refresh_before_read_all=function(b,...)
local U
if K then U=K(b,...)end
E(q,b,aa)return U
end
end
end
function c.groups(q,b,Y)
local O={}for _,l in ipairs(Y or{})do
local descriptor=c.describe(q,l,b)if descriptor~=nil then
if M(b,descriptor)~=nil then
O[descriptor.group]=true
end
end
end
return O
end
function c.send(q,b,Y,O,aB)
local H,as,Q,v={},{},{},false
for _,l in ipairs(Y or{})do
local descriptor=c.describe(q,l,b)local i=descriptor and O[descriptor.group]if descriptor~=nil and i and(i==true or i[descriptor.key])and
not(aB and descriptor.meta.reporting_defaults~=nil)then
local e=descriptor.meta
local aq=q.build_mapping_context(b,l)local p={}if e.reporting_defaults and e.reporting_defaults.all_endpoints then
for _,endpoint in pairs(b.zigbee_endpoints or{})do
if b:supports_server_cluster(e.cluster_id,endpoint.id)then p[#p+1]=endpoint.id end
end
table.sort(p)elseif aq.endpoint~=nil then
p[1]=aq.endpoint
elseif e.reporting_defaults~=nil then
p[1]=b:get_endpoint(e.cluster_id)else
for _,endpoint in ipairs(b.zigbee_endpoints or{})do
if b:supports_server_cluster(e.cluster_id,endpoint.id)then p[#p+1]=endpoint.id end
end
if #p==0 then p[1]=b:get_endpoint(e.cluster_id)end
end
local z=c.configuration(q,b,l)
if z==nil then v=e.physical_reportable_change~=nil or v end
for _,endpoint in ipairs(p)do
local key=descriptor.group..":"..endpoint
local B=as[key]local g={config=z,endpoint=endpoint,explicit=e.endpoint~=nil,key=descriptor.key}if B==nil then
as[key]=#H+1
H[#H+1]=g
elseif g.explicit and not H[B].explicit then
H[B]=g
end
end
end
end
for _,g in ipairs(H)do
local z,endpoint=g.config,g.endpoint
if z~=nil then
local key=z.cluster..":"..endpoint
if aB and not Q[key]then
q.bind_cluster(b,z.cluster,b.driver.environment_info.hub_zigbee_eui,endpoint)Q[key]=true
end
c.send_config(b,g.key,z,endpoint)
end
end
return v
end
return c
