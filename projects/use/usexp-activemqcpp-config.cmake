# ACTIVEMQCPP_FOUND - ActiveMqCpp was found
# ACTIVEMQCPP_VER - ActiveMqCpp version
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
else()
  set(ver @AMQ_OLDVER@)
endif()
set(${PRJ}_VER "${ver} [@PROJECT_NAME@]")
xpFindPkg(PKGS APR OpenSSL) # dependencies
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}_${ver}-targets.cmake)
set(${PRJ}_LIBRARIES xpro::activemqcpp)
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
