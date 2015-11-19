# LIBSSH2_FOUND - libssh2 was found
# LIBSSH2_INCLUDE_DIR - the libssh2 include directory (used by curl)
# LIBSSH2_INCLUDE_DIRS - the libssh2 include directory (used by libgit2)
# LIBSSH2_LIBRARIES - the libssh2 libraries
# LIBSSH2_LIBRARY - the libssh2 library
if(COMMAND xpFindPkg)
  xpFindPkg(PKGS zlib OpenSSL) # dependencies
endif()
set(prj libssh2)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}-targets.cmake)
string(TOUPPER ${prj} PRJ)
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR libssh2.h PATHS ${XP_ROOTDIR}/include/${prj} NO_DEFAULT_PATH)
set(${PRJ}_INCLUDE_DIRS ${${PRJ}_INCLUDE_DIR})
set(${PRJ}_LIBRARIES libssh2)
set(${PRJ}_LIBRARY libssh2)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_INCLUDE_DIRS ${PRJ}_LIBRARIES ${PRJ}_LIBRARY)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
