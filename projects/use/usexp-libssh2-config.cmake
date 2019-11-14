# LIBSSH2_FOUND - libssh2 was found
# LIBSSH2_VER - libssh2 version
# LIBSSH2_INCLUDE_DIRS - the libssh2 include directory (used by libgit2, curl)
# LIBSSH2_LIBRARIES - the libssh2 libraries
# LIBSSH2_LIBRARY - the libssh2 library (used by curl)
set(prj libssh2)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
@USE_SCRIPT_INSERT@
if(NOT DEFINED XP_USE_LATEST_LIBSSH2)
  option(XP_USE_LATEST_LIBSSH2 "build with libssh2 latest @LIBSSH2_NEWVER@ instead of @LIBSSH2_OLDVER@" ON)
endif()
if(XP_USE_LATEST_LIBSSH2)
  set(ver @LIBSSH2_NEWVER@)
else()
  set(ver @LIBSSH2_OLDVER@)
endif()
set(${PRJ}_VER "${ver} [@PROJECT_NAME@]")
set(${PRJ}_INCLUDE_DIRS ${XP_ROOTDIR}/include/${prj}_${ver}/libssh2)
xpFindPkg(PKGS zlib OpenSSL) # dependencies
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}_${ver}/Libssh2Config.cmake)
set(${PRJ}_LIBRARIES Libssh2::libssh2)
set(${PRJ}_LIBRARY Libssh2::libssh2)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIRS ${PRJ}_LIBRARIES ${PRJ}_LIBRARY)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
