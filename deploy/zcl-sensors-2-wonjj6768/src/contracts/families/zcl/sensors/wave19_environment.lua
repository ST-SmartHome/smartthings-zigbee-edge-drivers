local i=require"protocol.zcl"
local u=require"capabilities.events.all"
local be=require"contracts.helpers.family"
local g=be.create_fingerprint
local d=require"st.zigbee.data_types"
local x=require"st.capabilities"
local A=require"st.zigbee.device_management"
local ag=require"st.zigbee.cluster_base"
local dK=require"st.buf"
local at,b=be.definition_registry()local T=1
local bS=10
local di=1066
local bl=1067
local H=64641
local function r(aD,aC,dl,s,w)
return i.temperature({endpoint=s,minimum_interval=aD,maximum_interval=aC,reportable_change=dl,read_on_configure=w})
end
local function L(aD,aC,dl,s,w)
return i.humidity({endpoint=s,minimum_interval=aD,maximum_interval=aC,reportable_change=dl,read_on_configure=w})
end
local function j(s,w)
return i.temperature({endpoint=s or 1,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=w})
end
local function v(s,w)
return i.humidity({endpoint=s,minimum_interval=10,maximum_interval=3600,reportable_change=100,read_on_configure=w})
end
local function dm(capability_id)
return assert(u[capability_id],"missing Wave19 environment emitter: "..capability_id)()
end
local function bg(dG)
local cO=os.date("*t",dG)local dn=os.date("!*t",dG)cO.isdst=false
dn.isdst=false
return math.floor(os.difftime(os.time(cO),os.time(dn)))
end
local function ak(e,dj,dp)
local aa=ag.write_attribute(
e,d.ClusterId(bS),d.AttributeId(dj),dp)
if type(aa.to_endpoint)=="function"then aa=aa:to_endpoint(1)end
e:send(aa)
end
local function cu(W,e)
e:send(A.build_bind_request(
e,bS,W.environment_info.hub_zigbee_eui,1))local dd=os.time()local dq=math.max(0,dd-946684800)ak(e,1,d.Bitmap8(3))ak(e,0,d.Uint32(dq))ak(e,2,d.Int32(bg(dd)))
end
local dB={
profile="sensors-wave19-heiman-hs2aq-ef-three",package_group="wave19-environment",transport_classification="CUSTOM_PAYLOAD",z2m_converter_source="standard ZCL + heimanSpecificAirQuality short cluster",wire_cluster="0x0001/0x000A/0x0402/0x0405/0x042A/0x042B/0xFC81",zcl_clusters={
r(10,3600,100,nil,nil),L(10,3600,100,nil,nil),i.battery({
minimum_interval=3600,maximum_interval=65000,reportable_change=10,}),i.cluster_attribute(di,0,{
name="pm25",emit=u.pm25(),data_type=d.Uint16,minimum_interval=0,maximum_interval=3600,reportable_change=1,read_on_configure=true,read_only=true,}),i.cluster_attribute(bl,0,{
name="formaldehyde",emit=u.formaldehyde(),data_type=d.Uint16,scale=1000,minimum_interval=0,maximum_interval=3600,reportable_change=1,read_on_configure=true,read_only=true,}),i.cluster_attribute(H,61442,{
name="heiman_ef_three_charging_status",emit=dm("heimanEfThreeChargingStatus"),data_type=d.Uint8,
from_device=function(a)
return({[0]="NotCharged",[1]="Charging",[2]="FullyCharged"})[tonumber(a)]
end,
minimum_interval=0,maximum_interval=3600,reportable_change=1,read_on_configure=true,read_only=true,}),i.cluster_attribute(H,61443,{
name="heiman_ef_three_pm_ten",emit=dm("heimanEfThreePmTen"),data_type=d.Uint16,minimum_interval=0,maximum_interval=3600,reportable_change=1,read_on_configure=true,read_only=true,}),i.cluster_attribute(H,61445,{
name="heiman_ef_three_aqi",emit=dm("heimanEfThreeAqi"),data_type=d.Uint16,minimum_interval=0,maximum_interval=3600,reportable_change=1,read_on_configure=true,read_only=true,}),},configure=cu,}b(dB,{
g("HEIMAN","HS2AQ-EF-3.0"),})
local function dD(a,aD,aC)
if a<aD then return aD end
if a>aC then return aC end
return a
end
local function bz(_,a)
local bB=tonumber(a)
if bB==nil then return nil end
local V=math.floor((((dD(bB,2500,3000)-2500)/500)*100)+0.5)return{
x.battery.battery(V),x.voltageMeasurement.voltage({value=bB/1000,unit="V"}),}
end
local function cI(W,e)
e:send(A.build_bind_request(
e,T,W.environment_info.hub_zigbee_eui,1))
end
local dE={
profile="sensors-wave19-plaid-spruce",package_group="wave19-environment",transport_classification="CUSTOM_PAYLOAD",z2m_converter_source="fz.temperature+fz.humidity+fzLocal.plaid_battery",wire_cluster="0x0402/0x0405/0x0001 attr 0x0000",zcl_clusters={
r(10,3600,100,nil,nil),L(10,3600,100,nil,nil),i.cluster_attribute(T,0,{
name="plaid_mains_voltage_battery",emit=bz,data_type=d.Uint16,read_only=true,}),},configure=cI,}b(dE,{
g("PLAID SYSTEMS","PS-SPRZMS-SLP3"),})
local function R(a,_,k)
if k and k.raw_value==255 then return nil end
return a
end
local function Z(a,_,k)
local ae=k.zb_rx.body.zcl_body
local p=type(ae.get_attribute_data)=="function"and ae:get_attribute_data(32)
if type(p)=="table"then p=p.value end
if type(p)=="number"and p<255 then return end
if k.raw_value~=255 then return a end
end
local function h(ap)
ap.from_device=ap.from_device or R
return i.battery(ap)
end
local function q(ap)
ap.from_device=ap.from_device or R
return i.battery_voltage(ap)
end
local function E(cf,cN)
return{
i.temperature({minimum_interval=10,maximum_interval=3600,reportable_change=cf}),i.humidity({minimum_interval=10,maximum_interval=3600,reportable_change=cN}),h({minimum_interval=3600,maximum_interval=65000,reportable_change=10}),i.power_configuration_battery_voltage({name="battery_voltage",emit=u.voltage(),scale=10,read_only=true,read_on_configure=false,from_device=R}),}
end
local bR={
profile="sensors-zigbeetlc-th05-core",zcl_clusters=E(10,100),}b(bR,{
g("Tuya","TH05-z"),g("Xiaomi","LYWSD03MMC-z"),g("Xiaomi","MJWSD06MMC-z"),g("MiaoMiaoCe","MHO-C122-z"),g("MiaoMiaoCe","MHO-C401-z"),g("MiaoMiaoCe","MHO-C401N-z"),g("Qingping","CGG1-z"),g("Qingping","CGG1N-z"),g("Xiaomi","LYWSD03MMC-bz"),g("Xiaomi","MJWSD06MMC-bz"),g("MiaoMiaoCe","MHO-C122-bz"),g("MiaoMiaoCe","MHO-C401-bz"),g("MiaoMiaoCe","MHO-C401N-bz"),g("Qingping","CGG1-bz"),g("Qingping","CGG1N-bz"),})local aV={
profile="sensors-zigbeetlc-display-core",zcl_clusters=E(10,100),}b(aV,{
g("Qingping","CGDK2-z"),g("Qingping","CGDK2-bz"),g("Tuya","LKTMZL02-z"),})local bC={
profile="sensors-zigbeetlc-basic-core",zcl_clusters=E(10,100),}b(bC,{
g("Tuya","TS0201-z"),g("Wing","TS0201-z"),g("Tuya","TH03Z-z"),g("Tuya","ZTH01-z"),g("Tuya","ZTH02-z"),g("Tuya","ZY-ZTH02-z"),g("Tuya","TS0201-bz"),g("Tuya","TH03Z-bz"),g("Tuya","ZTH01-bz"),g("Tuya","ZTH02-bz"),})local bD={
profile="sensors-zigbeetlc-zg227-core",zcl_clusters=E(100,100),}b(bD,{
g("Tuya","ZG-227Z-z"),})local aW={
profile="sensors-zigbeetlc-zbeacon-core",zcl_clusters=E(10,50),}b(aW,{
g("ZBeacon","MC-z"),g("ZBeacon","TH01-z"),g("ZBeacon","TH01-2-z"),})local aP={
profile="safety-motion-battery-voltage",zcl_clusters={
i.occupancy({emit=u.motion(),minimum_interval=0,maximum_interval=3600,reportable_change=0,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end}),
h({minimum_interval=3600,maximum_interval=65000,reportable_change=10}),i.power_configuration_battery_voltage({name="battery_voltage",emit=u.voltage(),scale=10,read_only=true,read_on_configure=true,from_device=R}),},}b(aP,{
g("Tuya","TS202PIR1-z"),})
local function K(a)
if a==255 then return nil end
return math.floor(math.max(0,math.min(100,(a-25)*20))+0.5)
end
local function t(dI,s,w)
return i.cluster_attribute(1,32,{
name=dI or"battery_voltage_percent",endpoint=s or 1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=w,from_device=K,emit=u.battery(),})
end
local function D(_,a)
if a==255 then return end
return{x.battery.battery(K(a)),x.voltageMeasurement.voltage({value=a/10,unit="V"})}
end
local function o(_,a)
return(a&0xF03C0F)~=0 and x.batteryLevel.battery.critical()or x.batteryLevel.battery.normal()
end
local function S(_,a)
return a and x.batteryLevel.battery.critical()or x.batteryLevel.battery.normal()
end
local function y(z,dz)
z.minimum_interval=nil
z.maximum_interval=nil
z.reportable_change=nil
z.read_on_configure=false
z.emit=function(e,a,k)
if k.command_id==0 then return dz(e,a)end
end
return z
end
local function aR()
return{
y(i.motion({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end}),u.motion()),
y(i.tamper({endpoint=1}),u.tamper()),y(i.battery_low({endpoint=1}),S),j(1,false),i.illuminance({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),i.cluster_attribute(1,32,{name="radion_voltage",endpoint=1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,emit=D}),i.cluster_attribute(1,62,{name="radion_battery_alarm",endpoint=1,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o}),}
end
local function bh(e)i.read_attribute(e,1024,0,1)end
local cj={
profile="safety-motion-bosch-radion-core",parent_refresh=bh,zcl_clusters=aR(),}b(cj,{
g("BOSCH","RFDL-ZB-MS"),g("BOSCH","RFDL-ZB"),g("BOSCH","RFDL-ZB-EU"),g("BOSCH","RFDL-ZB-H"),g("BOSCH","RFDL-ZB-K"),g("BOSCH","RFDL-ZB-CHI"),g("BOSCH","RFDL-ZB-ES"),g("BOSCH","RFPR-ZB"),g("BOSCH","RFPR-ZB-EU"),g("BOSCH","RFPR-ZB-CHI"),g("BOSCH","RFPR-ZB-ES"),g("BOSCH","RFPR-ZB-MS"),})
local function bx(_,a)
if a==255 then return nil end
local O=math.floor(math.max(0,math.min(100,(a-25)*100/7))+0.5)return{
x.battery.battery(O),x.voltageMeasurement.voltage({value=a/10,unit="V"}),}
end
local bU={
profile="sensors-hmszb-core",zcl_clusters={
j(38),v(38,nil),i.cluster_attribute(1,32,{
name="hmszb_battery_voltage",endpoint=38,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,emit=bx,}),},}b(bU,{
g("Develco Products A/S","HMSZB-110"),g("Develco Products A/S","HMSZB-120"),g("frient A/S","HMSZB-110"),g("frient A/S","HMSZB-120"),})
local function aj()
local z=i.occupancy({ias_zone=true,endpoint=35,read_only=true,emit=u.motion()})z.minimum_interval=nil
z.maximum_interval=nil
z.reportable_change=nil
return z
end
local function M(_,a)
if type(a)=="table"then a=a.value end
return D(nil,a)
end
local bb={
profile="safety-motion-moszb130-core",zcl_clusters={aj()},}b(bb,{
g("Develco Products A/S","MOSZB-130"),})local bd={
profile="safety-motion-moszb141-core",zcl_clusters={aj()},}b(bd,{
g("Develco Products A/S","MOSZB-141"),g("frient A/S","MOSZB-141"),})local bc={
profile="safety-motion-moszb140-core",
parent_refresh=function(e)
i.read_attribute(e,1026,0,38)i.read_attribute(e,1024,0,39)i.read_attribute(e,1,32,35)
end,
zcl_clusters={
y(i.motion({endpoint=35}),u.motion()),y(i.tamper({endpoint=35}),u.tamper()),y(i.battery_low({endpoint=35}),S),r(60,3600,100,38,true),i.illuminance({endpoint=39,minimum_interval=300,maximum_interval=3600,reportable_change=100,read_on_configure=true}),i.cluster_attribute(1,32,{
name="moszb_battery_voltage",endpoint=35,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true,emit=M,}),},}b(bc,{
g("Develco Products A/S","MOSZB-140"),g("frient A/S","MOSZB-140"),g("Develco Products A/S","GWA1511_MotionSensor"),})local bw={
profile="safety-motion-moszb153-core",zcl_clusters={
i.occupancy({endpoint=35,ias_zone=true,emit=u.motion(),read_on_configure=true,minimum_interval=0,maximum_interval=65000,reportable_change=0}),j(38),i.illuminance({endpoint=39,component="main",minimum_interval=60,maximum_interval=3600,reportable_change=500,read_on_configure=true}),i.cluster_attribute(1,32,{
name="moszb_battery_voltage",endpoint=35,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true,emit=M,}),i.cluster_attribute(1,33,{
name="moszb153_battery_percentage",endpoint=35,data_type=d.Uint8,read_only=true,read_on_configure=false,scale=2,from_device=Z,emit=u.battery(),}),},}b(bw,{
g("frient A/S","MOSZB-153"),g("Develco Products A/S","MOSZB-153"),})
local function X()
local z=i.occupancy({ias_zone=true,endpoint=1,read_only=true,emit=u.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&2)~=0
end})
z.minimum_interval=nil
z.maximum_interval=nil
z.reportable_change=nil
return z
end
local function ay(_,a)
if a==255 then return nil end
return{
x.battery.battery(math.floor(math.max(0,math.min(100,(a-21)*100/9))+0.5)),x.voltageMeasurement.voltage({value=a/10,unit="V"}),}
end
local aF={
profile="safety-motion-centralite-a-core",zcl_clusters={
X(),j(),i.cluster_attribute(1,32,{
name="centralite_battery_voltage",endpoint=1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,emit=ay,}),},}b(aF,{
g("CentraLite","Motion Sensor-A"),})
local function U(e)
return e.zigbee_endpoints and e.zigbee_endpoints[3]and 3 or 1
end
local function aq(a,_,k)
local dc=k and k.raw_value or a
if dc>=32767 then return nil end
return k and a or dc/100
end
local function aI(a,_,k)
local dc=k and k.raw_value or a
if dc>=255 then return nil end
return k and a or dc/2
end
local function aJ(a,_,k)
local dc=k and k.raw_value or a
if dc>=255 then return nil end
return k and a or dc/10
end
local db={
profile="sensors-owon-ths317-et",zcl_clusters={
i.temperature({endpoint=U,minimum_interval=10,maximum_interval=3600,reportable_change=100,from_device=aq}),h({endpoint=U,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=aI}),q({endpoint=U,minimum_interval=3600,maximum_interval=65000,reportable_change=0,from_device=aJ}),},}b(db,{
g("OWON","THS317-ET"),})local aS={
profile="sensors-devbis-lywsd03mmc-core",
configure=function(W,e)
for _,ar in ipairs({{1026,0,d.Int16,10,300,10},{1029,0,d.Uint16,10,300,50},{1,33,d.Uint8,3600,65000,10}})do
if not e:supports_server_cluster(ar[1],1)then
e:send(A.build_bind_request(e,ar[1],W.environment_info.hub_zigbee_eui,1):to_endpoint(1))e:send(A.attr_config(e,{
cluster=ar[1],attribute=ar[2],data_type=ar[3],minimum_interval=ar[4],maximum_interval=ar[5],reportable_change=ar[3](ar[6]),}):to_endpoint(1))
end
end
end,
zcl_clusters={
r(10,300,10,1,nil),L(10,300,50,1,nil),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10}),},}b(aS,{
g("Xiaomi","LYWSD03MMC"),})local aX={
profile="safety-motion-zg204zl-z-core",zcl_clusters={
i.occupancy({endpoint=1,emit=u.motion(),minimum_interval=0,maximum_interval=3600,
reportable_change=0,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end}),
i.illuminance({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5}),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10}),},}b(aX,{
g("Sonoff","ZG-204ZL-z"),})local cQ={
profile="sensors-nodon-stph-core",zcl_clusters={
j(),v(1,nil),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10}),},}b(cQ,{
g("NodOn","STPH-4-1-00"),})
local function c(z)
z.minimum_interval=nil
z.maximum_interval=nil
z.reportable_change=nil
return z
end
local function B(s)
return c(h({endpoint=s,read_on_configure=false}))
end
local function n(s)
return c(q({endpoint=s,read_on_configure=false}))
end
local function ao(e,a)
if type(a)=="table"then a=a.value end
return o(e,a)
end
local function ad(e)
local s=e:get_endpoint(1)i.read_attribute(e,1,33,s)i.read_attribute(e,1,0,s)
end
local bL={
profile="sensors-namron-4512765-core",zcl_clusters={
c(i.temperature({endpoint=1})),c(i.humidity({endpoint=1})),c(h({endpoint=1})),},}b(bL,{
g("Namron AS","4512765"),})local bK={
profile="safety-motion-namron-4512763-core",zcl_clusters={
y(i.motion({endpoint=1}),u.motion()),y(i.tamper({endpoint=1}),u.tamper()),y(i.battery_low({endpoint=1}),S),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10}),c(q({endpoint=1})),},}b(bK,{
g("Namron AS","4512763"),})local ac={
profile="sensors-openlumi-router-temperature-core",magic_packet=false,zcl_clusters={
i.cluster_attribute(2,0,{
name="openlumi_device_temperature",endpoint=1,data_type=d.Int16,read_only=true,read_on_configure=true,minimum_interval=300,maximum_interval=3600,reportable_change=1,emit=u.temperature("C"),}),},}b(ac,{
g("OpenLumi","openlumi.gw_router.dgnwg05lm"),g("OpenLumi","openlumi.gw_router.zhwg11lm"),})local ca={
profile="sensors-salus-ss909zb-core",zcl_clusters={
j(9,false),t("ss909zb_battery",9,true),},}b(ca,{
g("Computime","SS909ZB"),g("Computime","PS600"),})local bo={
profile="sensors-centralite-3310-core",
parent_refresh=function()end,
zcl_clusters={
j(1,false),i.cluster_attribute(64581,0,{
name="centralite_humidity",endpoint=1,mfg_code=4174,data_type=d.Uint16,read_only=true,read_on_configure=false,scale=100,emit=u.humidity(),minimum_interval=10,maximum_interval=3600,reportable_change=10,}),i.cluster_attribute(1,32,{name="centralite_3310_voltage",endpoint=1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,emit=D}),i.cluster_attribute(1,62,{name="centralite_3310_alarm",endpoint=1,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o}),},}b(bo,{
g("CentraLite","3310-G"),g("CentraLite","3310-S"),g("SmartThings","3310-S"),})local bf=c(t())bf.read_on_configure=false
local cl={
profile="sensors-feibit-sth01-core",magic_packet=false,zcl_clusters={
c(i.temperature({endpoint=1,read_on_configure=false})),c(i.humidity({endpoint=1,read_on_configure=false})),bf,},}b(cl,{
g("fei","FNB54-THM17ML1.1"),g("Feibit Inc co.","FNB54-THM17ML1.1"),g("Feibit Inc co.","FB56-THM12HM1.2"),g("Feibit Inc co.","FNB56-THM14FB2.4"),g("Feibit Inc co.","FNB56-THM14FB2.5"),})local bq={
profile="safety-motion-centralite-3328-core",zcl_clusters={
X(),j(),},}b(bq,{
g("CentraLite","3328-G"),})
local function C(a)
if a==255 then return nil end
local p=a*100
local O=100
if p<2100 then O=0
elseif p<2440 then O=6-(2440-p)*6/340
elseif p<2740 then O=18-(2740-p)*12/300
elseif p<2900 then O=42-(2900-p)*24/160
elseif p<3000 then O=100-(3000-p)*58/100 end
return math.floor(O+0.5)
end
local function ai(dk,ds)
return{
y(i.motion({endpoint=1,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&2)~=0
end}),u.motion()),
y(i.tamper({endpoint=1}),u.tamper()),y(i.battery_low({endpoint=1}),S),j(1,false),i.cluster_attribute(1,32,{
name=dk,endpoint=1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,
emit=function(_,a)
if a==255 then return end
return{x.battery.battery(C(a)),x.voltageMeasurement.voltage({value=a/10,unit="V"})}
end,
}),i.cluster_attribute(1,62,{name=ds,endpoint=1,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o}),}
end
local cX={
profile="safety-motion-iris-3326-core",
parent_refresh=function()end,
zcl_clusters=ai("iris_battery","iris_alarm"),}b(cX,{
g("CentraLite","3326-L"),g("iMagic by GreatStar","3326-L"),})local co={
profile="sensors-sihas-tsm300-core",magic_packet=false,zcl_clusters={
r(30,300,30,1,false),L(30,3600,50,1,false),i.cluster_attribute(1,32,{
name="sihas_tsm_battery_voltage",endpoint=1,data_type=d.Uint8,read_only=true,read_on_configure=true,minimum_interval=30,maximum_interval=21600,reportable_change=1,
emit=function(_,a)
local O=C(a)
if O==nil then return nil end
return{x.battery.battery(O),x.voltageMeasurement.voltage({value=a/10,unit="V"})}
end,
}),},}b(co,{
g("ShinaSystem","TSM-300Z"),})local dg={
profile="sensors-konke-th-core",zcl_clusters={
j(),c(i.humidity({endpoint=1})),t(),},}b(dg,{
g("Konke","3AFE140103020000"),g("Konke","3AFE220103020000"),})local bW={
profile="safety-motion-ikea-vallhorn-core",zcl_clusters={
i.occupancy({endpoint=2,emit=u.motion(),minimum_interval=0,maximum_interval=3600,
reportable_change=0,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end}),
i.illuminance({endpoint=3,minimum_interval=10,maximum_interval=3600,reportable_change=5}),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10}),q({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10}),},}b(bW,{
g("IKEA of Sweden","VALLHORN Wireless Motion Sensor"),})
local function f(s,dF,dH)
return c(i.occupancy({endpoint=s,ias_zone=true,read_only=true,
read_on_configure=false,from_device=function(a,_,k)
if not k or k.command_id~=0 then return nil end
if type(a)=="table"then a=a.value end
return(a&(dH or 1))~=0
end,emit=function(e,dA)
if dF then
local aK=e:get_field("__core_ias_motion_timer")
if aK then aK:cancel()end
e:set_field("__core_ias_motion_timer",e.thread:call_with_delay(90,function()
e:set_field("__core_ias_motion_timer",nil)e:emit_event(x.motionSensor.motion.inactive())
end,"Motion reset"))
end
return x.motionSensor.motion(dA and"active"or"inactive")
end,
}))
end
local function l(s,aE)
return c(i.battery_low({endpoint=not aE and(s or 1)or nil,read_on_configure=false,
emit=function(_,a,k)
if k.command_id==0 then
return a and x.batteryLevel.battery.critical()or x.batteryLevel.battery.normal()
end
end,
}))
end
local cF={
profile="safety-motion-tuya-sm0202-core",magic_packet=false,zcl_clusters={
f(1,true),l(),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true}),n(1),},}b(cF,{
g("_TYZB01_u6uejz21","SM0202"),})local aZ={
profile="safety-motion-bitron-av2010-22-core",magic_packet=false,zcl_clusters={
f(1,true),c(i.tamper({endpoint=1,read_on_configure=false,
emit=function(e,dy,k)
if k.command_id==0 then return u.tamper()(e,dy)end
end,
})),l(),},}b(aZ,{
g("SMaBiT","902010/22"),g("SMaBiT","AV2010/22"),g("Bitron Home","902010/22"),g("Bitron Home","AV2010/22"),g("Bitron Video","902010/22"),g("Bitron Video","AV2010/22"),g("Bitron Video","IR_00.00.03.12TC"),g("SMaBiT","902010/22B"),g("SMaBiT","AV2010/22B"),g("Bitron Home","902010/22B"),g("Bitron Home","AV2010/22B"),g("Bitron Video","902010/22B"),g("Bitron Video","AV2010/22B"),})local aY={
profile="safety-motion-bitron-av2010-14-core",magic_packet=false,zcl_clusters={
f(1,true),l(),},}b(aY,{
g("SMaBiT","902010/14"),g("SMaBiT","AV2010/14"),g("Bitron Home","902010/14"),g("Bitron Home","AV2010/14"),g("Bitron Video","902010/14"),g("Bitron Video","AV2010/14"),g("SMaBiT","902010/22A"),g("SMaBiT","AV2010/22A"),g("Bitron Home","902010/22A"),g("Bitron Home","AV2010/22A"),g("Bitron Video","902010/22A"),g("Bitron Video","AV2010/22A"),})local az={
profile="safety-motion-smartthings-v4-core",magic_packet=false,zcl_clusters={
c(i.occupancy({endpoint=1,ias_zone=true,read_on_configure=false,emit=u.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&3)~=0
end,
})),c(i.tamper({endpoint=1,read_on_configure=false})),j(1,false),i.cluster_attribute(1,32,{
name="smartthings_v4_battery",endpoint=1,data_type=d.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,
from_device=function(a)
if a==255 then return nil end
return math.floor(math.max(0,math.min(100,235-370000/(a*100+1)))+0.5)
end,
emit=u.battery(),}),},}b(az,{
g("SmartThings","motionv4"),})
local function m(s,aE)
return c(i.tamper({endpoint=not aE and(s or 1)or nil,read_on_configure=false,
emit=function(e,a,k)
if k.command_id==0 then return u.tamper()(e,a)end
end,
}))
end
local cc={
profile="safety-motion-sercomm-pir02-core",magic_packet=false,zcl_clusters={
f(1,false),m(),l(),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,
from_device=function()return nil end,
}),i.cluster_attribute(1,32,{
name="sercomm_pir02_battery",endpoint=1,data_type=d.Uint8,read_only=true,read_on_configure=false,from_device=C,emit=u.battery(),}),i.cluster_attribute(1,62,{
name="sercomm_pir02_battery_alarm",endpoint=1,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o,}),},}b(cc,{
g("Sercomm Corp.","SZ-PIR02"),g("Sercomm Corp.","SZ-PIR02_SF"),})local cd={
profile="safety-motion-sercomm-pir04-core",magic_packet=false,zcl_clusters={
f(1,false),m(),j(1,false),i.illuminance({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),i.cluster_attribute(1,32,{
name="sercomm_pir04_battery_voltage",endpoint=1,data_type=d.Uint8,read_only=true,read_on_configure=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,
emit=function(_,a)
if a==255 then return nil end
local O=math.floor(math.max(0,math.min(100,(a-25)*100/7))+0.5)return{x.battery.battery(O),x.voltageMeasurement.voltage({value=a/10,unit="V"})}
end,
}),},}b(cd,{
g("Sercomm Corp.","SZ-PIR04N"),g("Sercomm Corp.","SZ-PIR04N_EU"),})local cU={
profile="safety-motion-bosch-isw-core",zcl_clusters={
f(5,false),m(5),l(5),j(5,false),t("isw_battery",5,true),},}b(cU,{
g("Bosch","ISW-ZPR1-WP13"),g("BOSCH","ISW-ZPR1-WP13"),})local cy={
profile="safety-motion-hive-mot003-core",zcl_clusters={
f(6,true),j(6),h({endpoint=6,minimum_interval=3600,maximum_interval=65000,reportable_change=0}),},}b(cy,{
g("HiveHome.com","MOT003"),})local cn={
profile="safety-motion-konke-core",zcl_clusters={
f(1,true),c(t()),},}b(cn,{
g("Konke","3AFE14010402000D"),g("Konke","3AFE27010402000D"),g("Konke","3AFE28010402000D"),})local bn={
profile="safety-motion-centralite-3305-core",
parent_refresh=function()end,
zcl_clusters={
f(1,false,2),m(),l(),j(1,false),i.cluster_attribute(1,32,{name="centralite_3305_voltage",endpoint=1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,emit=D}),i.cluster_attribute(1,62,{name="centralite_3305_alarm",endpoint=1,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o}),},}b(bn,{
g("CentraLite","3305-S"),g("CentraLite","3305"),g("SmartThings","3305-S"),g("SmartThings","3305"),})local bp={
profile="safety-motion-centralite-3325-core",
parent_refresh=function()end,
zcl_clusters=ai("centralite_3325_battery","centralite_3325_alarm"),}b(bp,{
g("CentraLite","3325-S"),g("SmartThings","3325-S"),})local aA={
profile="safety-motion-smartthings-v5-core",zcl_clusters={
f(1,false),j(),t(),},}b(aA,{
g("SmartThings","motionv5"),})local cm={
profile="sensors-keen-home-th-core",zcl_clusters={
c(i.temperature({endpoint=1,read_on_configure=false,from_device=function(a)
if a>-65 and a<65 then return a end
end})),
c(i.humidity({endpoint=1,read_on_configure=false})),i.cluster_attribute(1,32,{
name="keen_battery",endpoint=1,data_type=d.Uint8,read_only=true,read_on_configure=false,from_device=C,emit=u.battery(),}),n(1),i.cluster_attribute(1,62,{name="keen_battery_alarm",endpoint=1,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o}),},}b(cm,{
g("LUMI","RS-THP-MP-1.0"),g("Keen Home Inc","RS-THP-MP-1.0"),})local bJ={
profile="safety-motion-linkind-core",zcl_clusters={
f(1,false),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0}),},}b(bJ,{
g("lk","ZB-MotionSensor-D0003"),})local cS={
profile="safety-motion-trust-zpir-core",zcl_clusters={
f(1,false,2),m(),l(),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true}),},}b(cS,{
g("ADUROLIGHT","VMS_ADUROLIGHT"),g("Trust International B.V.","VMS_ADUROLIGHT"),g("AduroSmart Eria","VMS_ADUROLIGHT"),})local aT={
profile="safety-motion-livingwise-core",zcl_clusters={
f(1,true),B(1),n(1),},}b(aT,{
g("ORVIBO","895a2d80097f4ae2b2d40500d5e03dcc"),g("中性","700ae5aab3414ec09c1872efe7b8755a"),})
local function P()
return{
i.occupancy({endpoint=2,emit=u.motion(),minimum_interval=0,maximum_interval=3600,
reportable_change=0,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end}),
j(2),i.illuminance({endpoint=2,minimum_interval=10,maximum_interval=3600,reportable_change=5}),h({endpoint=2,minimum_interval=3600,maximum_interval=65000,reportable_change=0}),}
end
local cJ={
profile="safety-motion-hue-sml001-core",zcl_clusters=P(),}b(cJ,{
g("Philips","SML001"),})local cK={
profile="safety-motion-hue-sml002-core",zcl_clusters=P(),}b(cK,{
g("Philips","SML002"),})
local function ah()
local cD=P()cD[1].read_on_configure=false
cD[2].read_on_configure=false
cD[3].read_on_configure=true
cD[4].read_on_configure=true
cD[5]=n(2)cD[6]=i.cluster_attribute(1,62,{name="hue_battery_alarm",endpoint=2,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o})return cD
end
local function an(e)i.read_attribute(e,1024,0,2)end
local cL={
profile="safety-motion-hue-sml003-core",parent_refresh=an,zcl_clusters=ah(),}b(cL,{
g("Signify Netherlands B.V.","SML003"),g("Philips","SML003"),})local cM={
profile="safety-motion-hue-sml004-core",parent_refresh=an,zcl_clusters=ah(),}b(cM,{
g("Signify Netherlands B.V.","SML004"),g("Philips","SML004"),})local bT={
profile="safety-motion-adeo-ldsenk10-core",zcl_clusters={f(1,false)},}b(bT,{
g("ADEO","LDSENK10"),})
local function Q(am)
local J=am==false and{
configure_reporting=false,read_on_configure=true,}or{
minimum_interval=0,maximum_interval=3600,reportable_change=0,}local bI=am==false and{
endpoint=1,configure_reporting=false,read_on_configure=true,}or{
endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,}return{
i.occupancy({endpoint=1,emit=u.presence(),configure_reporting=J.configure_reporting,read_on_configure=J.read_on_configure,minimum_interval=J.minimum_interval,maximum_interval=J.maximum_interval,reportable_change=J.reportable_change,
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end}),
i.illuminance(bI),}
end
local bj={
profile="safety-presence-sonoff-snzb06p24-core",zcl_clusters=Q(false),
configure=function(W,e)
for _,cV in ipairs({1,1280})do
e:send(A.build_bind_request(
e,cV,W.environment_info.hub_zigbee_eui,1):to_endpoint(1))
end
end,
}b(bj,{
g("SONOFF","SNZB-06P24"),})local bk={
profile="safety-presence-third-reality-r3-core",zcl_clusters=Q(),}b(bk,{
g("Third Reality, Inc","3RPL01084Z"),})
local function ab()
return{
j(1,false),v(2,false),t(nil,2,true),h({endpoint=2,minimum_interval=3600,maximum_interval=65000,reportable_change=0,
read_on_configure=true,from_device=function()return nil end}),
}
end
local cB={
profile="sensors-orvibo-st20-core",zcl_clusters=ab(),}b(cB,{
g("Heiman","b467083cfc864f5e826459e5d8ea6079"),g("ORVIBO","b467083cfc864f5e826459e5d8ea6079"),})local cC={
profile="sensors-orvibo-st21-core",zcl_clusters=ab(),}b(cC,{
g("HEIMAN","888a434f3cfc47f29ec4a3a03e9fc442"),g("ORVIBO","888a434f3cfc47f29ec4a3a03e9fc442"),})local cz={
profile="safety-motion-imagic-1117-core",zcl_clusters={
f(1,false,2),j(),v(1,nil),i.cluster_attribute(1,32,{
name="imagic_battery",endpoint=1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,from_device=C,emit=u.battery(),}),q({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10}),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10}),},}b(cz,{
g("iMagic by GreatStar","1117-S"),})local bm={
profile="safety-motion-aurora-51-core",zcl_clusters={
f(1,false),i.illuminance({minimum_interval=10,maximum_interval=3600,reportable_change=5}),},}b(bm,{
g("Aurora","MotionSensor51AU"),})local cE={
profile="safety-motion-sengled-e1m-core",zcl_clusters={
c(i.occupancy({endpoint=1,ias_zone=true,emit=u.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10}),},}b(cE,{
g("sengled","E1M-G7H"),})local cb={
profile="safety-motion-samjin-core",
parent_refresh=function()end,
zcl_clusters={
f(1,false),m(),l(),j(1,false),i.cluster_attribute(1,32,{name="samjin_motion_voltage",endpoint=1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,emit=D}),i.cluster_attribute(1,62,{name="samjin_motion_alarm",endpoint=1,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o}),},}b(cb,{
g("Samjin","motion"),g("SmartThings","motion"),})local aU={
profile="safety-motion-thirdreality-3rms-core",zcl_clusters={
f(1,false),c(h({endpoint=1,read_on_configure=true})),n(1),},}b(aU,{
g("THIRDREALITY","3RMS16BZ"),})
local function I()
return{
r(30,1800,10,nil,false),L(30,1800,10,nil,false),h({minimum_interval=3600,maximum_interval=21600,reportable_change=1,read_on_configure=true}),q({minimum_interval=3600,maximum_interval=21600,reportable_change=1,read_on_configure=true}),}
end
local bu={
profile="sensors-efekta-th-v1-lr-core",magic_packet=false,zcl_clusters=I(),}b(bu,{
g("EfektaLab","EFEKTA_TH_v1_LR"),})local bv={
profile="sensors-efekta-th-v2-lr-core",magic_packet=false,zcl_clusters=I(),}b(bv,{
g("EfektaLab","EFEKTA_TH_v2_LR"),g("EfektaLab_for_Zigbee-Shop.ru","EFEKTA_TH_v2_LR"),})local bt={
profile="sensors-efekta-th-pow-r-core",magic_packet=false,parent_refresh=ad,zcl_clusters={
r(0,300,0,nil,false),L(0,300,0,nil,false),h({minimum_interval=10,maximum_interval=600,reportable_change=1,read_on_configure=true}),i.cluster_attribute(1,0,{
name="efekta_th_pow_mains_voltage",data_type=d.Uint16,scale=10,read_only=true,read_on_configure=true,emit=u.voltage(),}),i.cluster_attribute(1,62,{name="efekta_th_pow_battery_alarm",data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o}),},}b(bt,{
g("EfektaLab_for_Zigbee-Shop.ru","EFEKTA_TH_POW_R"),g("EfektaLab","EFEKTA_TH_POW_R"),g("EfektaLab","EFEKTA_TH_POW_E"),g("EfektaLab_for_Zigbee-Shop.ru","EFEKTA_TH_POW_E"),})local bs={
profile="sensors-efekta-t1-v2-lr-core",magic_packet=false,zcl_clusters={
r(30,1800,10,nil,false),h({minimum_interval=3600,maximum_interval=21600,reportable_change=1,read_on_configure=true}),q({minimum_interval=3600,maximum_interval=21600,reportable_change=1,read_on_configure=true}),},}b(bs,{
g("EfektaLab","EFEKTA_T1_v2_LR"),g("EfektaLab_for_Zigbee-Shop.ru","EFEKTA_T1_v2_LR"),})local br={
profile="sensors-efekta-t1-max-e-core",magic_packet=false,parent_refresh=ad,zcl_clusters={
r(0,300,0,nil,false),h({minimum_interval=10,maximum_interval=600,reportable_change=1,read_on_configure=true}),i.cluster_attribute(1,0,{
name="efekta_t1_max_mains_voltage",data_type=d.Uint16,scale=10,read_only=true,read_on_configure=true,emit=u.voltage(),}),i.cluster_attribute(1,62,{name="efekta_t1_max_battery_alarm",data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o}),},}b(br,{
g("EfektaLab","EFEKTA_T1_MAX_E"),g("EfektaLab","EFEKTA_T1_MAX_R"),})local bG={
profile="sensors-efekta-eth102z-core",magic_packet=false,zcl_clusters=I(),}b(bG,{
g("efektalab.com","EFEKTA_eTH102z"),})local bF={
profile="sensors-efekta-eon29wz-core",magic_packet=false,zcl_clusters={
r(0,21600,0,nil,true),L(0,21600,0,nil,true),i.illuminance({minimum_interval=0,maximum_interval=21600,reportable_change=0,read_on_configure=true}),h({minimum_interval=0,maximum_interval=21600,reportable_change=0,read_on_configure=true}),n(),},}b(bF,{
g("EfektaLab","EFEKTA_eON29wz"),})local by={
profile="sensors-ikea-vindstyrka-core",magic_packet=false,zcl_clusters={
r(10,3600,100,nil,true),v(nil,true),i.cluster_attribute(1066,0,{
name="ikea_vindstyrka_pm25",data_type=d.SinglePrecisionFloat,minimum_interval=60,maximum_interval=120,reportable_change=d.SinglePrecisionFloat(0,1,0),read_only=true,read_on_configure=true,
from_device=function(a)
if type(a)=="table"then a=a.value end
return math.floor(math.max(0,a)+0.5)
end,
emit=u.pm25(),}),},}b(by,{
g("IKEA of Sweden","VINDSTYRKA"),})local aG={
profile="sensors-miamiaoce-mho-c401n-core",magic_packet=false,zcl_clusters={
r(10,300,10,1,true),L(10,300,50,1,true),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true}),},}b(aG,{
g("MiaMiaoCe","MHO-C401N"),})local aO={
profile="sensors-zigbeetlc-mho-c401n-core",magic_packet=false,zcl_clusters={
r(10,3600,10,1,true),v(1,true),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true}),n(1),},}b(aO,{
g("MiaMiaoCe","MHO-C401N-z"),})local bi={
profile="sensors-sonoff-snzb02dr2-core",magic_packet=false,zcl_clusters={
r(10,3600,100,nil,true),v(nil,true),h({minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true}),q({minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true}),},
configure=function(W,e)
local s=e:get_endpoint(32)e:send(A.build_bind_request(e,32,W.environment_info.hub_zigbee_eui,s):to_endpoint(s))
end,
}b(bi,{
g("SONOFF","SNZB-02DR2"),})local bV={
profile="sensors-efekta-th-duo-core",magic_packet=false,
parent_refresh=function(e)
i.read_attribute(e,1,33,1)i.read_attribute(e,1,32,1)
end,
zcl_clusters={
i.temperature({endpoint=1,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),i.humidity({endpoint=1,component="main",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),i.temperature({endpoint=2,component="external",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),i.humidity({endpoint=2,component="external",minimum_interval=30,maximum_interval=1800,reportable_change=10,read_on_configure=false}),h({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,reportable_change=1,read_on_configure=true}),q({endpoint=1,component="main",minimum_interval=3600,maximum_interval=21600,reportable_change=1,read_on_configure=true}),i.cluster_attribute(1,62,{
name="efekta_th_duo_battery_alarm",endpoint=1,component="main",data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=ao,}),},}b(bV,{
g("EfektaLab","EFEKTA_TH_DUO_LR"),})local cw={
profile="sensors-efekta-t1-y-core",magic_packet=false,
parent_refresh=function(e)
i.read_attribute(e,1,33,e:get_endpoint(1))i.read_attribute(e,1,32,e:get_endpoint(1))
end,
zcl_clusters={
c(i.temperature({read_on_configure=false})),B(),n(),i.cluster_attribute(1,62,{
name="efekta_t1_y_battery_alarm",data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=ao,}),},}b(cw,{
g("EfektaLab","EFEKTA_T1_Y"),g("EfektaLab","EFEKTA_T1_Y_LR"),})local ck={
profile="sensors-efekta-t1-v2-core",magic_packet=false,
parent_refresh=function(e)
i.read_attribute(e,1,33,1)i.read_attribute(e,1,32,1)
end,
zcl_clusters={
r(30,1800,10,1,false),h({endpoint=1,minimum_interval=3600,maximum_interval=21600,reportable_change=1,read_on_configure=true}),q({endpoint=1,minimum_interval=3600,maximum_interval=21600,reportable_change=1,read_on_configure=true}),i.cluster_attribute(1,62,{
name="efekta_t1_v2_battery_alarm",endpoint=1,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o,}),},}b(ck,{
g("EfektaLab","EFEKTA_T1_v2"),})local cx={
profile="sensors-gs-sthm-i1h-core",magic_packet=false,zcl_clusters={
r(10,3600,100,nil,true),v(nil,true),h({minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true,from_device=Z,}),i.cluster_attribute(1,32,{
name="gs_sthm_battery_voltage",data_type=d.Uint8,read_only=true,read_on_configure=false,emit=M,}),},}b(cx,{
g("GS","STHM-I1H"),})local bZ={
profile="sensors-pushok-pok005-core",magic_packet=false,zcl_clusters={
c(i.temperature({})),c(i.humidity({})),B(),n(),},}b(bZ,{
g("PushOk Hardware","POK005"),})local ce={
profile="sensors-slacky-ts0201-core",magic_packet=false,zcl_clusters={
r(10,3600,10,nil,true),L(10,3600,10,nil,true),h({minimum_interval=3600,maximum_interval=21600,reportable_change=0,read_on_configure=true}),q({minimum_interval=3600,maximum_interval=21600,reportable_change=0,read_on_configure=true}),},}b(ce,{
g("Slacky-DIY","TS0201-z-SlD"),g("Slacky-DIY","TS0201-z21-SlD"),g("Slacky-DIY","TS0201-z22-SlD"),g("Slacky-DIY","TS0201-z23-SlD"),g("Slacky-DIY","TS0201-z24-SlD"),g("Slacky-DIY","TS0201-z28-SlD"),})local cq={
profile="safety-motion-yandex-00528-core",magic_packet=false,zcl_clusters={
i.occupancy({emit=u.motion(),minimum_interval=0,maximum_interval=3600,
reportable_change=0,read_on_configure=true,from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end}),
i.illuminance({minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),h({minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true}),n(),},}b(cq,{
g("Yandex","YNDX-00528"),})local cr={
profile="sensors-yandex-00529-core",magic_packet=false,zcl_clusters={
r(10,3600,100,nil,true),v(nil,true),h({minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true}),n(),},}b(cr,{
g("Yandex","YNDX-00529"),})
local function av(a,_,k)
local ae=k and k.zb_rx and k.zb_rx.body and k.zb_rx.body.zcl_body
if ae and type(ae.get_attribute_data)=="function"then
local au=ae:get_attribute_data(61441)if au~=nil then
if type(au)=="table"then au=au.value end
a=a+au/10
end
end
return a
end
local aw={
profile="sensors-pushok-extended-probe-core",magic_packet=false,zcl_clusters={
c(i.temperature({read_on_configure=false,from_device=av})),B(),n(),},}b(aw,{
g("PushOk Hardware","POK014"),g("PushOk Hardware","POK015"),})local bX={
profile="sensors-kmpcil-res005-core",magic_packet=false,zcl_clusters={
j(8,false),v(8,false),h({endpoint=8,minimum_interval=1,maximum_interval=120,reportable_change=1,read_on_configure=false}),c(q({endpoint=8,read_on_configure=false})),i.cluster_attribute(15,85,{
name="kmpcil_res005_motion",endpoint=8,data_type=d.Boolean,read_only=true,read_on_configure=false,minimum_interval=0,maximum_interval=30,reportable_change=true,
from_device=function(a)
if type(a)=="table"then a=a.value end
return a==1 or a==true
end,
emit=u.motion(),}),i.illuminance({minimum_interval=10,maximum_interval=3600,reportable_change=5}),},
configure=function(_,e)
for _,ar in ipairs({{81,d.Boolean,true},{257,d.Uint32,25}})do
local aa=ag.write_attribute(e,d.ClusterId(15),d.AttributeId(ar[1]),ar[2](ar[3]))aa.body.zcl_header.frame_ctrl:set_disable_default_response()e:send(aa:to_endpoint(8))
end
end,
}b(bX,{
g("KMPCIL","RES005"),})local aM={
profile="sensors-schneider-cct593011-core",magic_packet=false,zcl_clusters={
j(1,false),v(1,false),h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true}),n(1),},}b(aM,{
g("Schneider Electric","CCT593011_AS"),})local aN={
profile="safety-motion-schneider-cct595011-core",magic_packet=false,zcl_clusters={
c(i.occupancy({ias_zone=true,read_on_configure=false,emit=u.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&2)~=0
end})),
c(i.battery_low({read_on_configure=false,
emit=function(_,dv)
return dv and x.batteryLevel.battery.critical()or x.batteryLevel.battery.normal()
end})),
h({minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true}),i.illuminance({minimum_interval=10,maximum_interval=3600,reportable_change=5}),},}b(aN,{
g("Schneider Electric","CCT595011_AS"),})local bH={
profile="safety-motion-hobeian-zg204z-core",magic_packet=false,zcl_clusters={
c(i.occupancy({endpoint=1,ias_zone=true,read_on_configure=false,emit=u.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
c(i.battery_low({endpoint=1,read_on_configure=false,
emit=function(_,dv)
return dv and x.batteryLevel.battery.critical()or x.batteryLevel.battery.normal()
end})),
h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true}),q({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true}),},}b(bH,{
g("HOBEIAN","ZG-204Z"),})local cH={
profile="safety-presence-aqara-fp1e-core",magic_packet=false,zcl_clusters={
i.cluster_attribute(64704,322,{
name="aqara_fp1e_presence",endpoint=1,mfg_code=4447,data_type=d.Uint8,read_only=true,read_on_configure=true,
from_device=function(a)
if type(a)=="table"then a=a.value end
return a==1
end,
emit=u.presence(),}),},}b(cH,{
g("aqara","lumi.sensor_occupy.agl1"),})local dh={
profile="safety-motion-tcl-ms01-core",magic_packet=false,zcl_clusters={
c(i.occupancy({endpoint=1,ias_zone=true,read_on_configure=false,emit=u.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
c(i.battery_low({endpoint=1,read_on_configure=false,
emit=function(_,dv)
return dv and x.batteryLevel.battery.critical()or x.batteryLevel.battery.normal()
end})),
h({endpoint=1,minimum_interval=3600,maximum_interval=7200,reportable_change=2,read_on_configure=true}),q({endpoint=1,minimum_interval=3600,maximum_interval=7200,reportable_change=100,read_on_configure=true}),},}b(dh,{
g("TCL","MS01"),})local bY={
profile="safety-motion-orvibo-sn10zw-core",magic_packet=false,zcl_clusters={
f(nil,true),m(nil,true),l(nil,true),B(),n(),i.cluster_attribute(1,62,{name="orvibo_sn10_battery_alarm",data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o}),},}b(bY,{
g("欧瑞","585fdfb8c2304119a2432e9845cf2623"),g("ORVIBO","131c854783bc45c9b2ac58088d09571c"),g("ORVIBO","b2e57a0f606546cd879a1a54790827d6"),})
local function Y(a,_,k)
if k and k.raw_value==255 then return nil end
local rx=k and k.zb_rx
local ae=rx and rx.body and rx.body.zcl_body
if ae and type(ae.get_attribute_data)=="function"then
local V=ae:get_attribute_data(33)local p=ae:get_attribute_data(32)V=type(V)=="table"and V.value or V
p=type(p)=="table"and p.value or p
if V==200 and type(p)=="number"and p<30 then return nil end
end
return a
end
local function al(cW)
return{
i.tuya_magic_packet({endpoint=1}),c(i.temperature({read_on_configure=false})),c(i.humidity({scale=cW,read_on_configure=false,
from_device=function(a)if a>=0 and a<=100 then return a end end})),
c(h({read_on_configure=false,from_device=Y})),c(q({read_on_configure=false,from_device=Y})),}
end
local aB={
profile="sensors-tuya-ts0201-standard-core",zcl_clusters=al(100),}b(aB,{
g("_TZ2000_a476raq2","TS0201"),g("_TZ3000_i8jfiezr","TS0201"),g("_TYZB01_a476raq2","TS0201"),g("_TZ3000_nau60otv","TS0201"),g("_TZ2000_hjsgdkfl","TS0201"),g("_TZ3000_kchagk8y","TS0201"),g("_TZ2000_lxvycln5","TS0201"),g("_TZ3210_qkj7rujp","TS0201"),g("_TZ3000_cx6atb9s","TS0201"),g("_TZ3000_1o6x1bl0","TS0201"),g("_TZ2000_zrl0mqre","TS0201"),g("xn0","TY0201"),g("_TZ3210_huzkzqyk","TS0201"),g("_TZ3000_acklt5lf","TS0201"),g("_TZ3000_vira43zx","TS0201"),g("_TZ3000_unw0hpdv","TS0201"),g("_TZ3000_fejbrqvb","TS0201"),g("_TZ3000_lfa05ajd","TS0201"),g("_TZ3000_8fwzalxx","TS0201"),g("_TZ3000_vfpt3wk4","TS0201"),g("_TZ2000_zsfvulde","TS0201"),g("Wing","TS0201"),g("AoYan  ","TS0201"),g("_TZ3000_utwgoauk","TS0201"),g("_TZ3000_qzvaivin","TS0201"),g("_TZ3000_z1jcca2g","TS0201"),g("_TZ3210_k3qngb7u","TS0201"),})local bA={
profile="sensors-tuya-ty0201-ncw-core",zcl_clusters=al(10),}b(bA,{
g("_TZ3210_ncw88jfq","TY0201"),})local bO={
profile="sensors-tuyatec-rh3052-core",magic_packet=false,zcl_clusters={
c(i.temperature({read_on_configure=false})),c(i.humidity({read_on_configure=false})),B(),n(),},}b(bO,{
g("TUYATEC-prhs1rsd","RH3052"),g("TUYATEC-jigsujrv","RH3052"),g("TUYATEC-yg5dcbfu","RH3052"),g("TUYATEC-gqhxixyk","RH3052"),g("TUYATEC-4yn5mbem","RH3052"),g("TUYATEC-ef6iwyfl","RH3052"),g("TUYATEC-HaoiuWzy","RH3052"),g("TUYATEC-vmgh3fxd","RH3052"),g("TUYATEC-ehyenwmu","RH3052"),g("TUYATEC-lqyucvyd","RH3052"),})local ch={
profile="safety-motion-visonic-mp841-core",magic_packet=false,zcl_clusters={f(nil,false)},}b(ch,{
g("Visonic","MP-841"),})local cv={
profile="sensors-dawon-th110-core",magic_packet=false,zcl_clusters={
j(1,true),v(1,true),h({endpoint=1,scale=1,minimum_interval=30,maximum_interval=21600,reportable_change=1,read_on_configure=true}),q({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,
from_device=function()return nil end}),
},}b(cv,{
g("DAWON_DNS","ZB30C2"),})local cp={
profile="safety-motion-swann-core",magic_packet=false,zcl_clusters={
f(1,false),m(),l(),},}b(cp,{
g("SWANN","SWO-MOS1PA"),})local cg={
profile="safety-motion-visonic-mp840-core",magic_packet=false,zcl_clusters={
f(1,false),m(),l(),c(i.temperature({endpoint=1,read_on_configure=false})),i.cluster_attribute(1,32,{
name="visonic_mp840_battery_voltage",endpoint=1,data_type=d.Uint8,read_only=true,read_on_configure=false,emit=M,}),i.cluster_attribute(1,62,{
name="visonic_mp840_battery_alarm",endpoint=1,data_type=d.Bitmap32,read_only=true,read_on_configure=false,emit=o,}),},}b(cg,{
g("Visonic","MP-840"),})local bP={
profile="safety-motion-universal-xhs1-core",magic_packet=false,zcl_clusters={
f(1,false),m(),l(),j(),i.cluster_attribute(1,32,{
name="universal_xhs1_battery",endpoint=1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,
emit=function(_,a)
if type(a)=="table"then a=a.value end
if a==255 then return end
return{x.battery.battery(C(a)),x.voltageMeasurement.voltage({value=a/10,unit="V"})}
end,
}),},}b(bP,{
g("Universal Electronics Inc","URC4470BC0-X-R"),})
local function dw(a)
return string.char(
a&255,(a>>8)&255,(a>>16)&255,(a>>24)&255)
end
local function G(e)
i.send_raw_cluster_command(e,32,2,dw(24),1)local aa=ag.write_attribute(
e,d.ClusterId(32),d.AttributeId(0),d.Uint32(13200))e:send(aa:to_endpoint(1))return true
end
local bQ={
profile="safety-contact-universal-xhs2-core",magic_packet=false,announce_handler=G,
configure=function(_,e)
G(e)
end,
zcl_clusters={
c(i.contact({endpoint=1,read_on_configure=false,
emit=function(e,a,k)
if k.command_id==0 then return u.contact()(e,a)end
end,
})),m(),l(),j(),i.cluster_attribute(1,32,{
name="universal_xhs2_battery",endpoint=1,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true,
emit=function(_,a)
if type(a)=="table"then a=a.value end
if a==255 then return end
return{x.battery.battery(C(a)),x.voltageMeasurement.voltage({value=a/10,unit="V"})}
end,
}),},}b(bQ,{
g("Universal Electronics Inc","URC4460BC0-X-R"),})local bM={
profile="safety-motion-namron-4512770-core",magic_packet=false,zcl_clusters={
f(nil,false),c(i.temperature({endpoint=3,read_on_configure=false})),c(i.humidity({endpoint=4,read_on_configure=false})),B(),n(),i.illuminance({minimum_interval=10,maximum_interval=3600,reportable_change=5}),},
configure=function(W,e)
e:send(A.build_bind_request(e,1026,W.environment_info.hub_zigbee_eui,3))e:send(A.build_bind_request(e,1029,W.environment_info.hub_zigbee_eui,4))
end,
}b(bM,{
g("NAMRON AS","4512770"),g("NAMRON AS","4512771"),g("Namron AS","4512770"),g("Namron AS","4512771"),})local cG={
profile="safety-motion-tuya-ts0202-core",magic_packet=false,zcl_clusters={
c(i.occupancy({endpoint=1,ias_zone=true,read_on_configure=false,emit=u.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
h({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true}),q({endpoint=1,minimum_interval=3600,maximum_interval=65000,reportable_change=0,read_on_configure=true}),},}b(cG,{
g("_TZ3000_mmtwjmaq","TS0202"),g("_TZ3000_kmh5qpmb","TS0202"),g("_TZ3000_0b0c7d6h","TS0202"),g("_TZ3000_hgu1dlak","TS0202"),g("_TZ3000_tiwq83wk","TS0202"),g("_TZ3000_y56pgpgs","TS0202"),g("_TZ3000_k5wwrk7a","TS0202"),g("_TZ3000_c8ozah8n","TS0202"),g("_TYZB01_hqbdru35","TS0202"),g("_TYZB01_dl7cejts","TS0202"),})local bN={
profile="safety-motion-tuyatec-rh3040-core",magic_packet=false,zcl_clusters={
f(nil,false),B(),n(),},}b(bN,{
g("TUYATEC-zn9wyqtr","RH3040"),g("TUYATEC-bd5faf9p","RH3040"),g("TUYATEC-b3ov3nor","RH3040"),g("TUYATEC-2gn2zf9e","RH3040"),g("TUYATEC-b5g40alm","RH3040"),g("TUYATEC-kpz6r4qx","RH3040"),g("TUYATEC-dxnohkpd","RH3040"),g("TUYATEC-zw6hxafz","RH3040"),g("TUYATEC-deetibst","RH3040"),g("TUYATEC-kmfarmcu","RH3040"),g("TUYATEC-53o41joc","RH3040"),})
local function N(de)
local dr=B()dr.scale=de
return{
f(nil,false,2),c(i.occupancy({read_on_configure=false,emit=u.motion(),
from_device=function(a)
if type(a)=="table"then a=a.value end
return(a&1)~=0
end})),
c(i.temperature({read_on_configure=false})),c(i.humidity({read_on_configure=false})),dr,n(),}
end
local cY={
profile="safety-motion-nyce-3041-core",magic_packet=false,zcl_clusters=N(1),}b(cY,{
g("NYCE","3041"),})local cZ={
profile="safety-motion-nyce-3043-core",magic_packet=false,zcl_clusters=N(2),}b(cZ,{
g("NYCE","3043"),})local da={
profile="safety-motion-nyce-3045-core",magic_packet=false,zcl_clusters=N(1),}b(da,{
g("NYCE","3045"),})local af={
profile="safety-motion-bosch-radion-notification-core",parent_refresh=bh,zcl_clusters=aR(),}b(af,{
g("Bosch","RFPR-ZB"),g("Bosch","RFDL-ZB-MS"),g("Bosch","RFPR-ZB-MS"),})
local function F(_,cP)
return{
x.battery.battery(math.max(0,math.min(100,math.floor((cP-2850)*100/150+0.5)))),x.voltageMeasurement.voltage({value=cP/1000,unit="V"}),}
end
local ax={
profile="safety-motion-aqara-high-precision-core",magic_packet=false,zcl_clusters={
i.cluster_attribute(1030,0,{
name="aqara_high_precision_motion",endpoint=1,read_only=true,read_on_configure=false,
emit=function(e,a)
if type(a)=="table"then a=a.value end
if a~=1 then return end
local aK=e:get_field("__aqara_high_precision_timer")
if aK then aK:cancel()end
local dx=e:get_field("__aqara_high_precision_interval")or 60
e:set_field("__aqara_high_precision_timer",e.thread:call_with_delay(dx+2,function()
e:set_field("__aqara_high_precision_timer",nil)e:emit_event(x.motionSensor.motion.inactive())
end,"Aqara high precision motion reset"))
return x.motionSensor.motion.active()
end,
}),i.cluster_attribute(64704,258,{
name="aqara_high_precision_interval",endpoint=1,mfg_code=4447,read_only=true,read_on_configure=true,
handler=function(e,a)
if type(a)=="table"then a=a.value end
e:set_field("__aqara_high_precision_interval",a)
end,
}),i.cluster_attribute(1,32,{
name="aqara_high_precision_voltage",endpoint=1,data_type=d.Uint8,read_only=true,read_on_configure=true,
emit=function(e,a)
if type(a)=="table"then a=a.value end
if a~=255 then return F(e,a*100)end
end,
}),i.cluster_attribute(64704,247,{
name="aqara_high_precision_diagnostics",endpoint=1,read_only=true,read_on_configure=false,
emit=function(e,a)
if type(a)=="table"and a.value~=nil then a=a.value end
if type(a)=="string"then
local ci,aH={},1
while aH+1<=#a do
local dC,cA=a:byte(aH,aH+1)local width=cA>=32 and cA<=47 and((cA%8)+1)or cA==16 and 1
if not width or aH+1+width>#a then break end
ci[dC]=string.unpack("<"..(cA>=40 and"i"or"I")..width,a,aH+2)aH=aH+2+width
end
a=ci
end
if type(a)~="table"then return end
local p=a[1]or a["1"]
if type(p)=="table"then p=p.value end
if type(p)=="number"then return F(e,p)end
end,
}),},}b(ax,{
g("LUMI","lumi.motion.agl04"),})local ba={
profile="sensors-frient-aqszb110-core",magic_packet=false,zcl_clusters={
j(38,true),v(38,true),i.cluster_attribute(1,32,{
name="aqszb110_battery_voltage",endpoint=38,data_type=d.Uint8,read_only=true,minimum_interval=3600,maximum_interval=65000,reportable_change=10,read_on_configure=true,
emit=function(_,a)
if type(a)=="table"then a=a.value end
if a==255 then return end
return{
x.battery.battery(K(a)),x.voltageMeasurement.voltage({value=a/10,unit="V"}),a<=25 and x.batteryLevel.battery.critical()or x.batteryLevel.battery.normal(),}
end,
}),c(h({endpoint=38,read_on_configure=false,
from_device=function(a,_,k)
local ae=k.zb_rx.body.zcl_body
local p=type(ae.get_attribute_data)=="function"and ae:get_attribute_data(32)
if type(p)=="table"then p=p.value end
if type(p)=="number"and p<255 then return end
if type(a)=="table"then a=a.value end
if k.raw_value~=255 then return a end
end,
})),},}b(ba,{
g("frient A/S","AQSZB-110"),})
local function aQ(a,dt)
if type(a)=="table"and a.value~=nil then a=a.value end
if type(a)=="string"then
local cR=dK.Reader(a)local aL
while cR:remain()>=2 do
local dC,cA=cR:read_u8(),cR:read_u8()local ok,ci=pcall(d.parse_data_type,cA,cR)
if not ok then break end
if dC==dt then aL=ci.value end
end
return aL
end
if type(a)~="table"then return end
local aL=a[dt]or a[tostring(dt)]
if type(aL)=="table"then aL=aL.value end
return aL
end
local function bE(e,a)
local p=aQ(a,23)
if type(p)=="number"then return F(e,p)end
end
local ct={
profile="safety-presence-aqara-fp310-core",magic_packet=false,
parent_refresh=function(e)
i.read_attribute(e,64704,322,1,4447)
for _,cV in ipairs({1026,1029,1024})do i.read_attribute(e,cV,0,1)end
end,
zcl_clusters={
i.cluster_attribute(64704,322,{
name="aqara_fp310_presence",endpoint=1,mfg_code=4447,data_type=d.Uint8,read_only=true,read_on_configure=true,minimum_interval=0,maximum_interval=3600,reportable_change=1,
from_device=function(a)
if type(a)=="table"then a=a.value end
return a==1
end,
emit=u.presence(),}),j(1,true),v(1,true),i.illuminance({endpoint=1,minimum_interval=10,maximum_interval=3600,reportable_change=5,read_on_configure=true}),i.cluster_attribute(64704,247,{
name="aqara_fp310_battery",endpoint=1,mfg_code=4447,read_only=true,read_on_configure=false,emit=bE,}),i.cluster_attribute(64704,252,{
name="aqara_fp310_paired",endpoint=1,mfg_code=4447,data_type=d.Boolean,read_only=true,read_on_configure=false,
handler=function(e,a,k)
if type(a)=="table"then a=a.value end
if a==false and k.zb_rx.body.zcl_header.cmd.value==10 then
e:send(ag.write_manufacturer_specific_attribute(
e,64704,252,4447,d.Boolean,true):to_endpoint(1))
end
end,
}),},}b(ct,{
g("Aqara","lumi.sensor_occupy.acn1"),})
local function as(a)
if type(a)=="table"then a=a.value end
if a==0 then return false end
if a==1 then return true end
end
local cT={
profile="safety-presence-aqara-fp1-core",magic_packet=false,
parent_refresh=function(e)i.read_attribute(e,64704,322,1,4447)end,
zcl_clusters={
i.cluster_attribute(64704,322,{
name="aqara_fp1_presence",endpoint=1,mfg_code=4447,data_type=d.Uint8,read_only=true,read_on_configure=true,from_device=as,emit=u.presence(),}),i.cluster_attribute(64704,247,{
name="aqara_fp1_heartbeat_presence",endpoint=1,mfg_code=4447,read_only=true,read_on_configure=false,
from_device=function(a)return as(aQ(a,101))end,
emit=u.presence(),}),},}b(cT,{
g("aqara","lumi.motion.ac01"),})i.attach_reporting_capabilities(at,{
{1,"rpt-hbj"},{2,"rpt-pha"},{3,"rpt-tjc"},{4,"rpt-tjc"},{5,"rpt-tjc"},{6,"rpt-tjc"},{7,"rpt-tjc"},{8,"rpt-tla"},{9,"rpt-rkp"},{10,"rpt-hew"},{13,"rpt-mos"},{14,"rpt-mnz"},{15,"rpt-min"},{16,"rpt-twu"},{17,"rpt-lrf"},{18,"rpt-zfm"},{19,"rpt-lrf"},{21,"rpt-zqa"},{22,"rpt-oyj"},{23,"rpt-scj"},{24,"rpt-zus"},{26,"rpt-zdq"},{27,"rpt-zif"},{28,"rpt-hew"},{29,"rpt-zun"},{30,"rpt-vaw"},{31,"rpt-slz"},{34,"rpt-mzh"},{35,"rpt-sfw"},{36,"rpt-slc"},{37,"rpt-ioq"},{38,"rpt-mgr"},{40,"rpt-zbp"},{41,"rpt-zbp"},{42,"rpt-mex"},{44,"rpt-zsl"},{45,"rpt-vjq"},{47,"rpt-sjc"},{48,"rpt-sjc"},{49,"rpt-skq"},{50,"rpt-skq"},{53,"rpt-zxi"},{54,"rpt-bbf"},{55,"rpt-bbf"},{56,"rpt-zth"},{57,"rpt-moz"},{58,"rpt-zsl"},{59,"rpt-zbp"},{61,"rpt-ejv"},{62,"rpt-ejv"},{63,"rpt-enq"},{64,"rpt-ekk"},{65,"rpt-els"},{66,"rpt-ejv"},{67,"rpt-eou"},{68,"rpt-vbu"},{69,"rpt-lrf"},{70,"rpt-tjc"},{71,"rpt-sxh"},{72,"rpt-eoa",{["zr040200001"]="Temp",["zr040200002"]="TempTwo",["zr040500001"]="Humidity",["zr040500002"]="HumidityTwo"}},{74,"rpt-esn"},{75,"rpt-tjc"},{77,"rpt-sxh"},{78,"rpt-ybf"},{79,"rpt-tjc"},{81,"rpt-rgu"},{82,"rpt-cfw"},{83,"rpt-csr"},{84,"rpt-znf"},{86,"rpt-znf"},{92,"rpt-zfz"},{95,"rpt-uis"},{96,"rpt-uti"},{97,"rpt-zim"},{98,"rpt-tue"},{103,"rpt-rkp"},{105,"rpt-ala"},{106,"rpt-lam"},})return{
id="zcl.sensors.wave19_environment",registrations=at,}
