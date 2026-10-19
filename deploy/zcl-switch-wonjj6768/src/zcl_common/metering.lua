local function bf(r)
local as=require"st.capabilities"
local af=require"runtime.capability_metadata"
local U=require"runtime.capability_support"
local O=require"st.zigbee.constants"
local bt=require"st.zigbee.device_management"
local f=af.by_emit_name.power_poll_interval
local p=af.by_emit_name.last_power_response_time
local R="_zcl_power_poll_interval_seconds"
local F="_zcl_last_power_response_at"
local T="_zcl_switch_state"
local i=f and f.default_range or{}local o=i.minimum or 5
local n=i.maximum or 3600
local A=i.step or 5
local S=i.unit or"s"
local Z="--"
local aw=3600
local ag={1,3,10,30}local ae={1,3}local j={}local Q=setmetatable({},{__mode="k"})local C=setmetatable({},{__mode="k"})
local function aN(d)
if type(d)=="table"then
d=d.value
end
if type(d)~="number"then
return nil
end
return d
end
local function q(c)
return r.normalize_endpoint(c)or 1
end
local function aM(d)
if type(d)=="table"then
d=d.value
end
if type(d)=="string"and d~=""then
local bs=tonumber(d)if bs~=nil then
d=bs
end
end
if type(d)~="number"or d~=d or d==math.huge or d==-math.huge then
return nil
end
return math.floor(d+0.5)
end
local function y(d)
d=aM(d)if d==nil then
return nil
end
if d<o then
d=o
elseif d>n then
d=n
end
d=math.floor((d/A)+0.5)*A
if d<o then
d=o
elseif d>n then
d=n
end
return d
end
local function B(a,m)
if m==nil then
return false
end
return U.supports(a,m.ID,"main")
end
local function am(a,be)
return U.supports(a,be,"main")
end
local function ac(a,bm)
if bm==nil then
return false
end
if type(a.emit_component_event)=="function"then
a:emit_component_event({id="main"},bm)return true
end
if type(a.emit_event)=="function"then
a:emit_event(bm)return true
end
return false
end
local aP=U.is_callable
local function t(a,aT,W)
if type(aT)~="table"or type(W)~="string"or W==""then
return nil,nil
end
if not am(a,aT.capability_id)then
return nil,nil
end
local m=as[aT.capability_id]local w=m and m[W]or nil
if not aP(w)and m and type(m.attributes)=="table"then
w=m.attributes[W]
end
if not aP(w)then
w=nil
end
return m,w
end
local function an(aq)
if type(aq)~="number"or aq<=0 then
return Z
end
return os.date("!%Y-%m-%d %H:%M:%S UTC",aq)
end
local function L(a,b)
if type(b)~="table"then
return nil
end
local aA=nil
for _,h in ipairs(b)do
if type(h)=="table"then
local e=r.mapping_meta(h)if e~=nil and e.metering_kind=="power"and not e.write_only then
local aK=r.build_mapping_context(a,h,nil)local bb={
mapping=h,meta=e,context=aK,}if aK.component_id=="main"then
return bb
end
if aA==nil then
aA=bb
end
end
end
end
return aA
end
local function N(a,b)
local bv=L(a,b)if bv==nil then
return nil
end
return y(bv.meta.poll_interval)
end
local function J(a,b)
local bh=y(a:get_field(R))if bh~=nil then
return bh
end
return N(a,b)
end
local function bp()
local aq=os.time()if type(aq)=="number"then
return aq
end
return nil
end
local function E(d)
if d==true or d=="on"then
return"on"
end
if d==false or d=="off"then
return"off"
end
return nil
end
local function V(a)
local bw=E(a:get_field(T))if bw~=nil then
return bw
end
local br=E(type(a.get_latest_state)=="function"and
a:get_latest_state("main",as.switch.ID,"switch")or nil)if br~=nil then
return br
end
return nil
end
local function u(a)
return B(a,as.switch)
end
local function ak(a,b)
if type(b)~="table"then
return false
end
local aG=0
local ah={}for _,h in ipairs(b)do
if type(h)=="table"then
local e=r.mapping_meta(h)if e~=nil and e.metering_kind~=nil and not e.write_only then
local k=r.build_mapping_context(a,h,nil)local aX=string.format(
"%04X:%04X:%s:%s",e.cluster_id or 0,e.attribute_id or 0,tostring(k.endpoint),tostring(e.mfg_code))if not ah[aX]then
ah[aX]=true
r.read_mapping(a,h,k)aG=aG+1
end
end
end
end
return aG>0
end
local function K(a,b,ba,bq,bo)
if type(b)~="table"or a.thread==nil or type(a.thread.call_with_delay)~="function"then
return false
end
if type(bq)~="table"then
return false
end
local bd=false
local M=Q[a]if type(M)~="table"then
M={}Q[a]=M
end
for _,bl in ipairs(bq)do
if type(bl)=="number"and bl>0 then
local az=a.thread:call_with_delay(bl,function()
if V(a)==ba then
ak(a,b)
end
end,bo)
if az~=nil then
M[#M+1]=az
bd=true
end
end
end
return bd
end
local function ax(a,b,e)
if e==nil then
return nil
end
local l=e.poll_interval
if e.metering_kind=="power"then
l=J(a,b)
end
if type(l)~="number"or l<=0 then
return l
end
if not u(a)or e.metering_kind==nil then
return l
end
if V(a)=="off"and e.metering_kind~="voltage"then
return aw
end
return l
end
local function ad(a,b)
local au=J(a,b)local m,w=t(
a,f,f and f.attribute_name or nil)if au==nil or w==nil or not B(a,m)then
return false
end
local _,ay=t(
a,f,f and f.range_attribute_name or nil)if ay~=nil then
ac(a,ay({
value={
minimum=o,maximum=n,step=A,},unit=S,}))
end
ac(a,w({
value=au,unit=S,}))return true
end
local function D(a)
local m,w=t(
a,p,p and p.attribute_name or nil)if w==nil or not B(a,m)then
return false
end
ac(a,w({
value=an(a:get_field(F)),}))return true
end
local function bc(bu,v,c)
return string.format("_zcl_metering:%s:%s:%d",tostring(bu),tostring(v),q(c))
end
local function ab(bu,at,aY,bg,aF,aL)
local ap=r.get_generated_cluster_id(at)local z=r.get_generated_attribute_by_name(at,aY)local H=r.get_generated_attribute_by_name(at,bg)if ap==nil or z==nil or H==nil then
return nil
end
return{
kind=bu,cluster_id=ap,multiplier_attribute_id=z.ID,divisor_attribute_id=H.ID,multiplier_store_key=aF,divisor_store_key=aL,}
end
local function aZ(a,g,v,d,c)
local P=aN(d)if P==nil then
return false
end
a:set_field(bc(g.kind,v,c),P,{persist=true})if q(c)==1 then
if v=="multiplier"and g.multiplier_store_key~=nil then
a:set_field(g.multiplier_store_key,P,{persist=true})elseif v=="divisor"and g.divisor_store_key~=nil then
a:set_field(g.divisor_store_key,P,{persist=true})
end
end
return true
end
local function ar(a,g,v,c)
c=q(c)local P=a:get_field(bc(g.kind,v,c))if type(P)=="number"then
return P
end
if c==1 then
local ao=v=="multiplier"and g.multiplier_store_key or g.divisor_store_key
if ao~=nil then
P=a:get_field(ao)if type(P)=="number"then
return P
end
end
end
return nil
end
local function aj(a,h,e,g,c)
local aU=e.physical_reportable_change
if type(aU)~="number"or aU<=0 then
return nil
end
local z=ar(a,g,"multiplier",c)local H=ar(a,g,"divisor",c)if type(z)~="number"or z<=0 or type(H)~="number"or H<=0 then
return nil
end
local bk=aU*H/z
if bk~=bk or bk==math.huge or bk==-math.huge then
return nil
end
local aD=math.floor(bk+0.5)if aD<=0 or math.abs(bk-aD)>0.000000001 then
return nil
end
if type(e.data_type)=="function"then
return e.data_type(aD)
end
if type(e.data_type)=="table"then
local mt=getmetatable(e.data_type)
if type(mt)=="table"and type(mt.__call)=="function"then
return e.data_type(aD)
end
end
return aD
end
local function al(a,g,c,b)
if type(b)~="table"or type(a.send)~="function"then
return false
end
local aJ=false
local ah={}for _,h in ipairs(b)do
local e=type(h)=="table"and r.mapping_meta(h)or nil
if e~=nil and e.metering_kind==g.kind and e.physical_reportable_change~=nil then
local aK=r.build_mapping_context(a,h,nil)local aS=q(aK.endpoint)if aS==c and e.cluster_id~=nil and e.attribute_id~=nil then
local aX=string.format("%04X:%04X:%d",e.cluster_id,e.attribute_id,c)if not ah[aX]then
ah[aX]=true
local Y=aj(a,h,e,g,c)if Y~=nil then
local aI=require"zcl_common.reporting"
local bx=aI.configuration(r,a,h,Y)or{
cluster=e.cluster_id,attribute=e.attribute_id,minimum_interval=e.minimum_interval or 0,maximum_interval=e.maximum_interval or 300,data_type=e.data_type,reportable_change=Y,mfg_code=e.mfg_code,}local aW=aI.describe(r,h,a)aI.send_config(a,aW and aW.key,bx,c)aJ=true
end
end
end
end
end
return aJ
end
local function X(a,g,v,c,b)
local s=C[a]if s==nil then
s={}C[a]=s
end
s[g.kind]=s[g.kind]or{}local bn=s[g.kind][c]or{}s[g.kind][c]=bn
bn[v]=true
if bn.multiplier~=true or bn.divisor~=true then
return false
end
s[g.kind][c]={}return al(a,g,c,b)
end
local function av(a,g,c)
local s=C[a]if s==nil then
s={}C[a]=s
end
s[g.kind]=s[g.kind]or{}s[g.kind][c]={}
end
local function aQ(a,g,aa,c)
if r.read_attribute==nil then
return false
end
return r.read_attribute(a,g.cluster_id,aa,c)
end
local function ai(a)
local M=Q[a]
if type(M)~="table"or a.thread==nil or type(a.thread.cancel_timer)~="function"then
Q[a]=nil
return
end
for _,az in ipairs(M)do
if az~=nil then
a.thread:cancel_timer(az)
end
end
Q[a]=nil
end
local function I()
if next(j)~=nil then
return
end
j.energy=ab(
"energy","SimpleMetering","Multiplier","Divisor",O.SIMPLE_METERING_MULTIPLIER_KEY,O.SIMPLE_METERING_DIVISOR_KEY)j.power=ab(
"power","ElectricalMeasurement","ACPowerMultiplier","ACPowerDivisor",O.ELECTRICAL_MEASUREMENT_MULTIPLIER_KEY,O.ELECTRICAL_MEASUREMENT_DIVISOR_KEY)j.voltage=ab(
"voltage","ElectricalMeasurement","ACVoltageMultiplier","ACVoltageDivisor")j.current=ab(
"current","ElectricalMeasurement","ACCurrentMultiplier","ACCurrentDivisor")j.frequency=ab(
"frequency","ElectricalMeasurement","ACFrequencyMultiplier","ACFrequencyDivisor")for _,g in pairs(j)do
if g~=nil then
r.register_attribute(g.cluster_id,g.multiplier_attribute_id)r.register_attribute(g.cluster_id,g.divisor_attribute_id)
end
end
end
function r.handle_internal_attribute(a,ap,aa,x,G)
I()local c=q(type(G)=="table"and
(G.endpoint or G.src_endpoint)or nil)local b=type(G)=="table"and G.zcl_clusters or nil
for _,g in pairs(j)do
if g~=nil and ap==g.cluster_id then
if aa==g.multiplier_attribute_id then
local aB=aZ(a,g,"multiplier",x,c)if aB then
X(a,g,"multiplier",c,b)
end
return aB
end
if aa==g.divisor_attribute_id then
local aB=aZ(a,g,"divisor",x,c)if aB then
X(a,g,"divisor",c,b)
end
return aB
end
end
end
return false
end
function r.scale_mapping_value(a,h,x,e,k)
if x==nil or e==nil then
return x
end
local g=e.metering_kind and j[e.metering_kind]or nil
if g~=nil and type(x)=="number"and not e.ignore_reported_scaler then
local c=k and k.endpoint or nil
local aH=ar(a,g,"multiplier",c)local aV=ar(a,g,"divisor",c)local z=aH or 1
local H=aV or 1
if H==0 then
H=1
end
if z~=H then
return x*z/H
end
end
if e.scale==nil or e.scale==1 then
return x
end
if type(x)=="number"and type(e.scale)=="number"and e.scale~=0 then
return x/e.scale
end
return x
end
function r.read_metering_scalers(a,b)
I()if type(b)~="table"then
return false
end
local aJ=false
local ah={}local aR={}for _,h in ipairs(b)do
if type(h)=="table"then
local e=r.mapping_meta(h)local g=e and e.metering_kind and j[e.metering_kind]or nil
if g~=nil and not e.ignore_reported_scaler then
local k=r.build_mapping_context(a,h,nil)local c=q(k.endpoint)local bi=string.format("%s:%d",g.kind,c)if not aR[bi]then
aR[bi]=true
av(a,g,c)
end
local aE=string.format("%04X:%04X:%d",g.cluster_id,g.multiplier_attribute_id,c)if not ah[aE]then
ah[aE]=true
aJ=aQ(a,g,g.multiplier_attribute_id,c)or aJ
end
local aO=string.format("%04X:%04X:%d",g.cluster_id,g.divisor_attribute_id,c)if not ah[aO]then
ah[aO]=true
aJ=aQ(a,g,g.divisor_attribute_id,c)or aJ
end
end
end
end
return aJ
end
function r.emit_power_polling_state(a,b)
if L(a,b)==nil then
return false
end
local aC=false
aC=ad(a,b)or aC
aC=D(a)or aC
return aC
end
function r.set_power_poll_interval(a,b,d)
if N(a,b)==nil then
return false
end
local au=y(d)if au==nil then
return false
end
a:set_field(R,au,{persist=true})r.start_runtime(a,b)r.emit_power_polling_state(a,b)return true
end
function r.handle_metering_value(a,_,d,e)
if e==nil or e.metering_kind~="power"or type(d)~="number"then
return false
end
local aq=os.time()if type(aq)~="number"then
return false
end
a:set_field(F,aq,{persist=false})D(a)return true
end
function r.begin_power_poll_burst(a,b)
if not u(a)then
return false
end
a:set_field(T,"on",{persist=false})if type(b)=="table"then
r.start_runtime(a,b)K(a,b,"on",ag,"zcl on-state confirm poll")
end
return true
end
function r.handle_switch_state(a,b,d)
d=E(d)if not u(a)or d==nil then
return false
end
local bj=V(a)a:set_field(T,d,{persist=false})if d=="on"and bj~="on"then
return r.begin_power_poll_burst(a,b)
end
if d=="off"and bj~="off"then
if type(b)=="table"then
r.start_runtime(a,b)K(a,b,"off",ae,"zcl off-state confirm poll")
end
return true
end
return false
end
function r.start_runtime(a,b)
ai(a)
if type(b)~="table"or a.thread==nil or type(a.thread.call_on_schedule)~="function"then
return false
end
local M={}local ah={}for _,h in ipairs(b)do
if type(h)=="table"then
local e=r.mapping_meta(h)local l=ax(a,b,e)if e~=nil and type(l)=="number"and l>0 and not e.write_only then
local k=r.build_mapping_context(a,h,nil)local aX=string.format(
"%04X:%04X:%s:%s",e.cluster_id or 0,e.attribute_id or 0,tostring(k.endpoint),tostring(e.mfg_code))if not ah[aX]then
ah[aX]=true
local az=a.thread:call_on_schedule(l,function()
r.read_mapping(a,h,r.build_mapping_context(a,h,nil))
end,string.format("zcl metering poll %s",tostring(e.name or aX)))
if az~=nil then
M[#M+1]=az
end
end
end
end
end
Q[a]=M
return #M>0
end
function r.stop_runtime(a)
ai(a)
end
I()
end
return bf
