# CURL_FOUND - curl was found
# CURL_INCLUDE_DIR - the curl include directory
# CURL_LIBRARIES - the curl libraries
# CURL_EXE - the curl executable
# CURL_DEFINITIONS - curl compile definitions
if(COMMAND xpFindPkg)
  xpFindPkg(PKGS libssh2 cares) # dependencies
endif()
set(prj curl)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR curl/curl.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to [bin|lib]/cmake
include(${XP_ROOTDIR}/lib/cmake/lib${prj}${ver}-targets.cmake)
include(${XP_ROOTDIR}/bin/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES libcurl)
set(${PRJ}_EXE curl)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_EXE)
if(WIN32)
  # tell cURL not to __declspec(dllimport) its symbols (required by libcurl)
  add_definitions(-DCURL_STATICLIB)
  set(${PRJ}_DEFINITIONS -DCURL_STATICLIB)
  list(APPEND reqVars ${PRJ}_DEFINITIONS)
endif()
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
