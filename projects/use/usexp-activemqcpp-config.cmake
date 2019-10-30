# ACTIVEMQCPP_FOUND - ActiveMqCpp was found
# ACTIVEMQCPP_VER - ActiveMqCpp version
# ACTIVEMQCPP_INCLUDE_DIR - the ActiveMqCpp include directory
# ACTIVEMQCPP_LIBRARIES - the ActiveMqCpp libraries
set(prj activemqcpp)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR activemq/library/ActiveMQCPP.h PATHS ${XP_ROOTDIR}/include${verDir}/${prj} NO_DEFAULT_PATH)
if(COMMAND xpFindPkg)
  # TRICKY: OpenSSL isn't listed here because activemqcpp needs a specific version (see below)
  xpFindPkg(PKGS APR) # dependencies
endif()
foreach(dep @BUILD_DEPS@) # activemqcpp needs a specific version of openssl
  if(EXISTS ${XP_ROOTDIR}/lib/cmake/${dep}-targets.cmake)
    include(${XP_ROOTDIR}/lib/cmake/${dep}-targets.cmake)
  endif()
endforeach()
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES activemqcpp)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
