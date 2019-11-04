# ACTIVEMQCPP_FOUND - ActiveMqCpp was found
# ACTIVEMQCPP_VER - ActiveMqCpp version
# ACTIVEMQCPP_INCLUDE_DIR - the ActiveMqCpp include directory
# ACTIVEMQCPP_LIBRARIES - the ActiveMqCpp libraries
set(prj activemqcpp)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
@USE_SCRIPT_INSERT@
if(NOT DEFINED XP_USE_LATEST_ACTIVEMQCPP)
  option(XP_USE_LATEST_ACTIVEMQCPP "build with activemqcpp latest @AMQ_NEWVER@ instead of @AMQ_OLDVER@" ON)
endif()
if(XP_USE_LATEST_ACTIVEMQCPP)
  set(ver @AMQ_NEWVER@)
  set(XP_USE_LATEST_OPENSSL ON) # 1.1.1d
else()
  set(ver @AMQ_OLDVER@)
  set(XP_USE_LATEST_OPENSSL OFF) # 1.0.2a
endif()
set(${PRJ}_VER "${ver} [@PROJECT_NAME@]")
set(verDir /${prj}_${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR activemq/library/ActiveMQCPP.h PATHS ${XP_ROOTDIR}/include${verDir}/${prj} NO_DEFAULT_PATH)
xpFindPkg(PKGS APR OpenSSL) # dependencies
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}_${ver}-targets.cmake)
set(${PRJ}_LIBRARIES activemqcpp)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
