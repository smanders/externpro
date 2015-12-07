# ACTIVEMQCPP_FOUND - ActiveMqCpp was found
# ACTIVEMQCPP_INCLUDE_DIR - the ActiveMqCpp include directory
# ACTIVEMQCPP_LIBRARIES - the ActiveMqCpp libraries
# ACTIVEMQCPP_OPTIMIZED_DLLS - the ActiveMqCpp optimized DLLs
# ACTIVEMQCPP_DEBUG_DLLS - the ActiveMqCpp debug DLLs
set(prj activemqcpp)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR activemq/util/ActiveMQProperties.h PATHS ${XP_ROOTDIR}/include/${prj} NO_DEFAULT_PATH)
include_directories(SYSTEM ${${PRJ}_INCLUDE_DIR})
set(reqVars ${PRJ}_INCLUDE_DIR)
if(MSVC AND ${CMAKE_GENERATOR} MATCHES "Win64$")
  set(${PRJ}_LIBRARIES
    optimized libactivemq-cpp-s.lib
    debug libactivemq-cpp-sd.lib
    optimized libapr-1-s.lib
    debug libapr-1-sd.lib
    )
  set(${PRJ}_OPTIMIZED_DLLS
    ${XP_ROOTDIR}/lib/libapr-1-s.dll
    )
  set(${PRJ}_DEBUG_DLLS
    ${XP_ROOTDIR}/lib/libapr-1-sd.dll
    )
  list(APPEND reqVars ${PRJ}_LIBRARIES ${PRJ}_OPTIMIZED_DLLS ${PRJ}_DEBUG_DLLS)
endif()
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
