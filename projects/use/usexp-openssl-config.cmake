# OPENSSL_FOUND - OpenSSL was found
# OPENSSL_VER - OpenSSL version
# OPENSSL_INCLUDE_DIR - the OpenSSL include directory
# OPENSSL_LIBRARIES - the OpenSSL libraries
set(prj openssl)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
@USE_SCRIPT_INSERT@
if(NOT DEFINED XP_USE_LATEST_OPENSSL)
  option(XP_USE_LATEST_OPENSSL "build with OpenSSL latest @OPENSSL_NEWVER@ instead of @OPENSSL_OLDVER@" OFF)
endif()
if(XP_USE_LATEST_OPENSSL)
  set(ver @OPENSSL_NEWVER@)
else()
  set(ver @OPENSSL_OLDVER@)
endif()
set(verUnd _${ver})
set(verDir /${prj}${verUnd})
set(${PRJ}_VER "${ver} [@PROJECT_NAME@]")
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR openssl/opensslv.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
set(THREAD_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED) # crypto depends on Threads::Threads
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${verUnd}-targets.cmake)
set(${PRJ}_LIBRARIES crypto ssl)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
