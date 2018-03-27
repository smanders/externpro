# CERES_FOUND - ceres was found
# CERES_INCLUDE_DIR - the ceres include directory
# CERES_LIBRARIES - the ceres libraries
set(prj ceres)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(verDir /${prj}_@VER@)
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR ceres/ceres.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
# ceres installs a Targets file among other .cmake files
include(${XP_ROOTDIR}/lib/cmake${verDir}/CeresTargets.cmake)
set(${PRJ}_LIBRARIES ceres)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
