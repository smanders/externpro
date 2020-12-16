# LIBZMQ_FOUND - libzmq was found
# LIBZMQ_VER - libzmq version
# LIBZMQ_LIBRARIES - the libzmq libraries
set(prj libzmq)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
# targets file installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/ZeroMQ_@VER@/ZeroMQTargets.cmake)
set(${PRJ}_LIBRARIES xpro::libzmq-static)
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
