# PROTOBUF_VER - protobuf version
# PROTOBUF_INCLUDE_DIR - the protobuf include directory
# PROTOBUF_LIBRARIES - the protobuf libraries
# PROTOBUF_PROTOC_EXECUTABLE - the protobuf compiler (protoc) executable
string(TOUPPER @NAME@ PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
@FIND_DEPS@set(nsPrefix xpro::) # TRICKY: nsPrefix also used in protobuf-module.cmake
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
set(protobuf_MODULE_COMPATIBLE ON) # necessary for GENERATE_PROTOBUF_CPP
include(${CMAKE_CURRENT_LIST_DIR}/@TARGETS_FILE@)
set(${PRJ}_LIBRARIES ${nsPrefix}libprotobuf)
set(${PRJ}_PROTOC_EXECUTABLE ${nsPrefix}protoc) # TRICKY: match name in -module.cmake
get_target_property(PROTOBUF_INCLUDE_DIR ${nsPrefix}libprotobuf INTERFACE_INCLUDE_DIRECTORIES)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_PROTOC_EXECUTABLE)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(@NAME@ REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
