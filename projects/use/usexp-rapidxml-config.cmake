# RAPIDXML_FOUND - RapidXml was found
# RAPIDXML_VER - RapidXml version
set(prj rapidxml)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
if(NOT TARGET xpro::rapidxml)
  add_library(xpro::rapidxml INTERFACE IMPORTED)
  set_target_properties(xpro::rapidxml PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${XP_ROOTDIR}/include/${prj}_@VER@"
    )
endif()
set(reqVars ${PRJ}_VER)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
