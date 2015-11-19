# WXX_FOUND - wxx was found
# WXX_INCLUDE_DIR - the wxx include directory
# WXX_LIBRARIES - the wxx libraries
if(COMMAND xpFindPkg)
  xpFindPkg(PKGS wxWidgets) # dependencies
endif()
set(prj wxx)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}-targets.cmake)
string(TOUPPER ${prj} PRJ)
set(${PRJ}_INCLUDE_DIR ${WXWIDGETS_INCLUDE_DIR})
if(NOT DEFINED wxx_libs)
  set(wxx_libs plotctrl things tlc)
endif()
set(${PRJ}_LIBRARIES ${wxx_libs})
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
