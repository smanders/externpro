# CARES_FOUND - cares was found
# CARES_INCLUDE_DIR - the cares include directory
# CARES_INCLUDE_DIRS - the cares include directory (used by curl)
# CARES_LIBRARIES - the cares libraries
# CARES_LIBRARY - the cares library (used by curl)
set(prj cares)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR cares/ares.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
set(${PRJ}_INCLUDE_DIRS ${${PRJ}_INCLUDE_DIR}/cares)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES cares)
set(${PRJ}_LIBRARY cares)
if(WIN32)
  add_definitions(-DCARES_STATICLIB)
endif()
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_INCLUDE_DIRS ${PRJ}_LIBRARIES ${PRJ}_LIBRARY)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
