# APR_FOUND - apr was found
# APR_INCLUDE_DIR - the apr include directory
# APR_INCLUDE_DIRS - the apr include directory (used by activemq-cpp)
# APR_LIBRARIES - the apr libraries
# APR_DEFINITIONS - apr compile definitions
set(prj apr)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR apr/apr.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
set(${PRJ}_INCLUDE_DIRS ${${PRJ}_INCLUDE_DIR}/apr)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES apr-1)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_INCLUDE_DIRS ${PRJ}_LIBRARIES)
if(WIN32)
  add_definitions(-DAPR_DECLARE_STATIC)
  set(${PRJ}_DEFINITIONS -DAPR_DECLARE_STATIC)
  list(APPEND reqVars ${PRJ}_DEFINITIONS)
endif()
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
