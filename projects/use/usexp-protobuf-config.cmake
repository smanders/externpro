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
set(nsPrefix xpro::) # TRICKY: nsPrefix also used in protobuf-module.cmake
# protobuf installs a config file which includes -targets.cmake and -module.cmake
include(${XP_ROOTDIR}/lib/cmake/protobuf_@VER@/${prj}-config.cmake)
set(${PRJ}_LIBRARIES ${nsPrefix}libprotobuf)
if(NOT TARGET libprotobuf)
  add_library(libprotobuf STATIC IMPORTED)
  foreach(prop
    INTERFACE_INCLUDE_DIRECTORIES
    IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE
    IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG
    IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE
    IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG
    IMPORTED_LOCATION_RELEASE
    IMPORTED_LOCATION_DEBUG
    )
    get_target_property(tmp ${nsPrefix}libprotobuf ${prop})
    if(tmp)
      set_target_properties(libprotobuf PROPERTIES ${prop} "${tmp}")
    endif()
  endforeach()
endif()
set(${PRJ}_PROTOC_EXECUTABLE ${nsPrefix}protoc) # TRICKY: must be named to match what's used in -module.cmake
get_target_property(PROTOBUF_INCLUDE_DIR ${nsPrefix}libprotobuf INTERFACE_INCLUDE_DIRECTORIES)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_PROTOC_EXECUTABLE)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
