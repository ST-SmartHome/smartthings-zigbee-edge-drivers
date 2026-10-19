local a=require"tuya_common.core"
local c=require"capabilities.events.all"
local b={}a.apply_constants(b)require"tuya_common.message_protocol"(b,a)require"tuya_common.converters"(b,a)require"tuya_common.policy_helper"(b,a)require"tuya_common.datapoint_factory"(b,a)require"tuya_common.datapoint_preset"(b,a,c)require"tuya_common.datapoint_mapping"(b,a)require"tuya_common.device_runtime"(b,a)require"tuya_common.base_preset"(b,a)return b
