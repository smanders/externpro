# EXPAT_FOUND - expat was found
# EXPAT_INCLUDE_DIR - the expat include directory
# EXPAT_INCLUDE_DIRS - the expat include directory (match FindEXPAT.cmake)
# EXPAT_LIBRARIES - the expat libraries
# EXPAT_DEFINITIONS - expat compile definitions
set(prj expat)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR expat.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
set(${PRJ}_INCLUDE_DIRS ${${PRJ}_INCLUDE_DIR})
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES expat)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_INCLUDE_DIRS ${PRJ}_LIBRARIES)
if(WIN32)
  add_definitions(-DXML_STATIC)
  set(${PRJ}_DEFINITIONS -DXML_STATIC)
  list(APPEND reqVars ${PRJ}_DEFINITIONS)
endif()
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
