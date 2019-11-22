# EIGEN_FOUND - Eigen was found
# EIGEN_VER - Eigen version
# EIGEN_INCLUDE_DIR - the Eigen include directory
set(prj eigen)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
set(verDir /${prj}_@VER@)
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR eigen3/Eigen/Eigen PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
list(APPEND ${PRJ}_INCLUDE_DIR ${XP_ROOTDIR}/include${verDir}/eigen3)
if(NOT TARGET xpro::eigen)
  add_library(xpro::eigen INTERFACE IMPORTED)
  if(${PRJ}_INCLUDE_DIR)
    set_target_properties(xpro::eigen PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES "${${PRJ}_INCLUDE_DIR}"
      )
  endif()
endif()
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
