# LIBSTROPHE_FOUND - libstrophe was found
# LIBSTROPHE_VER - libstrophe version
# LIBSTROPHE_INCLUDE_DIR - the libstrophe include directory
# LIBSTROPHE_LIBRARIES - the libstrophe libraries
if(COMMAND xpFindPkg)
  xpFindPkg(PKGS expat OpenSSL) # dependencies
endif()
set(prj libstrophe)
set(ver _@VER@)
set(verDir /${prj}${ver})
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR libstrophe/strophe.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES libstrophe)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
