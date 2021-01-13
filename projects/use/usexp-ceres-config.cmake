# CERES_FOUND - ceres was found
# CERES_VER - ceres version
# CERES_LIBRARIES - the ceres libraries
xpFindPkg(PKGS eigen) # dependencies
set(prj ceres)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
# ceres installs a Targets file among other .cmake files
include(${XP_ROOTDIR}/lib/cmake/${prj}_@VER@/CeresTargets.cmake)
set(${PRJ}_LIBRARIES xpro::ceres)
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
