# LIBGIT2_FOUND - libgit2 was found
# LIBGIT2_VER - libgit2 version
# LIBGIT2_LIBRARIES - the libgit2 libraries
set(prj libgit2)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
@USE_SCRIPT_INSERT@
if(NOT DEFINED XP_USE_LATEST_LIBGIT2)
  option(XP_USE_LATEST_LIBGIT2 "build with libgit2 latest @LIBGIT2_NEWVER@ instead of @LIBGIT2_OLDVER@" ON)
endif()
if(XP_USE_LATEST_LIBGIT2)
  set(ver @LIBGIT2_NEWVER@)
else()
  set(ver @LIBGIT2_OLDVER@)
endif()
set(${PRJ}_VER "${ver} [@PROJECT_NAME@]")
xpFindPkg(PKGS libssh2) # dependency
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}_${ver}${VER_MOD}-targets.cmake)
set(${PRJ}_LIBRARIES xpro::git2)
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
