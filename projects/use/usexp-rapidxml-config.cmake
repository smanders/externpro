# RAPIDXML_FOUND - RapidXml was found
# RAPIDXML_INCLUDE_DIR - the RapidXml include directory
set(prj rapidxml)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(verDir /${prj}_@RXMLVER@)
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR rapidxml/rapidxml.hpp PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
set(reqVars ${PRJ}_INCLUDE_DIR)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
