# PROTOBUF_FOUND - protobuf was found
# PROTOBUF_VER - protobuf version
# PROTOBUF_INCLUDE_DIR - the protobuf include directory
# PROTOBUF_LIBRARIES - the protobuf libraries
# PROTOBUF_PROTOC_EXECUTABLE - the protobuf compiler (protoc) executable
xpFindPkg(PKGS zlib) # dependencies
set(prj protobuf)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
set(nsPrefix xpro::) # TRICKY: nsPrefix also used in protobuf-module.cmake
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
set(protobuf_MODULE_COMPATIBLE ON) # necessary for GENERATE_PROTOBUF_CPP
# protobuf installs a config file which includes -targets.cmake and -module.cmake
include(${XP_ROOTDIR}/lib/cmake/protobuf_@VER@/${prj}-config.cmake)
set(${PRJ}_LIBRARIES ${nsPrefix}libprotobuf)
set(${PRJ}_PROTOC_EXECUTABLE ${nsPrefix}protoc) # TRICKY: must be named to match what's used in -module.cmake
get_target_property(PROTOBUF_INCLUDE_DIR ${nsPrefix}libprotobuf INTERFACE_INCLUDE_DIRECTORIES)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_PROTOC_EXECUTABLE)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
