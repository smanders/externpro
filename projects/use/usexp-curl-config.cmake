# CURL_FOUND - curl was found
# CURL_VER - curl version
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
@USE_SCRIPT_INSERT@
if(NOT DEFINED XP_USE_LATEST_CURL)
  option(XP_USE_LATEST_CURL "build with curl latest @CURL_NEWVER@ instead of @CURL_OLDVER@" ON)
endif()
if(XP_USE_LATEST_CURL)
  set(ver @CURL_NEWVER@)
else()
  set(ver @CURL_OLDVER@)
endif()
set(${PRJ}_VER "${ver} [@PROJECT_NAME@]")
set(verUnd _${ver})
set(verDir /${prj}${verUnd})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR curl/curl.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to [bin|lib]/cmake
include(${XP_ROOTDIR}/lib/cmake/lib${prj}${verUnd}-targets.cmake)
include(${XP_ROOTDIR}/bin/cmake/${prj}${verUnd}-targets.cmake)
set(${PRJ}_LIBRARIES libcurl)
set(${PRJ}_EXE curl)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_EXE)
if(WIN32)
  # tell cURL not to __declspec(dllimport) its symbols (required by libcurl)
  set(${PRJ}_DEFINITIONS -DCURL_STATICLIB)
  list(APPEND reqVars ${PRJ}_DEFINITIONS)
endif()
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
