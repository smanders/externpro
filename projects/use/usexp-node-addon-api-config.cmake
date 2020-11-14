# NODE-ADDON-API_FOUND - node-addon-api was found
# NODE-ADDON-API_VER - node-addon-api version
set(prj node-addon-api)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
if(NOT TARGET xpro::node-addon-api)
  xpFindPkg(PKGS node)
  add_library(xpro::node-addon-api INTERFACE IMPORTED)
  set_target_properties(xpro::node-addon-api PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${XP_ROOTDIR}/include/${prj}_@VER@"
    INTERFACE_LINK_LIBRARIES xpro::node
    INTERFACE_COMPILE_DEFINITIONS "NODE_ADDON_API_DISABLE_DEPRECATED;NAPI_CPP_EXCEPTIONS"
    )
endif()
set(reqVars ${PRJ}_VER)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
