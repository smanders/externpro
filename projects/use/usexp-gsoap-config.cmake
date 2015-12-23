# GSOAP_FOUND - gsoap was found
# GSOAP_INCLUDE_DIR - the gsoap include directory
# GSOAP_LIBRARIES - the gsoap libraries
set(prj gsoap)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}-targets.cmake)
string(TOUPPER ${prj} PRJ)
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR gsoap/stdsoap2.h PATHS ${XP_ROOTDIR}/include NO_DEFAULT_PATH)
list(APPEND ${PRJ}_INCLUDE_DIR ${XP_ROOTDIR}/include/gsoap) # for internal header includes
set(${PRJ}_LIBRARIES gsoap)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
