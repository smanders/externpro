# ACTIVEMQCPP_FOUND - ActiveMqCpp was found
# ACTIVEMQCPP_INCLUDE_DIR - the ActiveMqCpp include directory
# ACTIVEMQCPP_LIBRARIES - the ActiveMqCpp libraries
if(COMMAND xpFindPkg)
  xpFindPkg(PKGS APR OpenSSL) # dependencies
endif()
set(prj activemqcpp)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR activemq/library/ActiveMQCPP.h PATHS ${XP_ROOTDIR}/include${verDir}/${prj} NO_DEFAULT_PATH)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES activemqcpp)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
