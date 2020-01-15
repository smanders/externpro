# LIBSTROPHE_FOUND - libstrophe was found
# LIBSTROPHE_VER - libstrophe version
# LIBSTROPHE_LIBRARIES - the libstrophe libraries
set(prj libstrophe)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
@USE_SCRIPT_INSERT@
xpFindPkg(PKGS expat OpenSSL) # dependencies
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}_@VER@${VER_MOD}-targets.cmake)
set(${PRJ}_LIBRARIES xpro::libstrophe)
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
