# CURL_FOUND - curl was found
# CURL_VER - curl version
# CURL_LIBRARIES - the curl libraries
# CURL_EXE - the curl executable
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
xpFindPkg(PKGS libssh2 cares) # dependencies
# targets file installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${PRJ}_${ver}/${PRJ}Targets.cmake)
set(${PRJ}_LIBRARIES xpro::libcurl)
set(${PRJ}_EXE xpro::curl)
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES ${PRJ}_EXE)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
