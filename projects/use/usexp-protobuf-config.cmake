# PROTOBUF_FOUND - protobuf was found
# PROTOBUF_VER - protobuf version
# PROTOBUF_INCLUDE_DIR - the protobuf include directory
# PROTOBUF_LIBRARIES - the protobuf libraries
# PROTOBUF_PROTOC_EXECUTABLE - the protobuf compiler (protoc) executable
if(COMMAND xpFindPkg)
  xpFindPkg(PKGS zlib) # dependencies
endif()
set(prj protobuf)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR google/protobuf/service.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
# protobuf installs a config file which includes -targets.cmake and -module.cmake
include(${XP_ROOTDIR}/lib/cmake/protobuf${ver}/${prj}-config.cmake)
set(${PRJ}_LIBRARIES libprotobuf)
set(${PRJ}_PROTOC_EXECUTABLE protoc) # TRICKY: must be named this to match what's used in -module.cmake
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_PROTOC_EXECUTABLE)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
