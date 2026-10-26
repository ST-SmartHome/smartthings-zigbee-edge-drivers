local a=require"protocol.zcl.stub_base"()a.ATTR_MEASURED_VALUE=nil
require"zcl_common.generated_helper"(a)require"zcl_common.cluster_mapping"(a)require"zcl_common.mapping_preset"(a)require"zcl_common.component_helper"(a)require"zcl_common.runtime"(a)
function a.handle_internal_attribute(...)return false end
require"zcl_common.attribute_handler"(a)require"zcl_common.attribute_reader"(a)
function a.send_named_command(...)return false end
function a.send_raw_cluster_command(...)return false end
function a.register_sender(...)return nil end
function a.get_sender(...)return nil end
require"zcl_common.cluster_command_handler"(a)require"zcl_common.configuration"(a)return a
