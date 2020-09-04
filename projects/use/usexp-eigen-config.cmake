# EIGEN_FOUND - Eigen was found
# EIGEN_VER - Eigen version
set(prj eigen)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
set(verDir /${prj}_@VER@)
set(includeDirs ${XP_ROOTDIR}/include${verDir} ${XP_ROOTDIR}/include${verDir}/eigen3)
if(NOT TARGET xpro::eigen)
  add_library(xpro::eigen INTERFACE IMPORTED)
  set_target_properties(xpro::eigen PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${includeDirs}"
    )
endif()
set(reqVars ${PRJ}_VER)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
