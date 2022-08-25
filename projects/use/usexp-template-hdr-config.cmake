string(TOUPPER @NAME@ PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
@FIND_DEPS@# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
set(includeDirs @LIBRARY_INCLUDEDIRS@)
list(TRANSFORM includeDirs PREPEND "${XP_ROOTDIR}/")
if(NOT TARGET @LIBRARY_HDR@)
  add_library(@LIBRARY_HDR@ INTERFACE IMPORTED)
  set_target_properties(@LIBRARY_HDR@ PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${includeDirs}"
    )
endif()
set(${PRJ}_LIBRARIES @LIBRARY_HDR@)
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(@NAME@ REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
