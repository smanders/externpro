# LIBRAPTORQ_FOUND - libRaptorQ was found
# LIBRAPTORQ_INCLUDE_DIRS - the libRaptorQ include directory
# LIBRAPTORQ_LIBRARIES - the libRaptorQ libraries
set(prj libraptorq)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}-targets.cmake)
string(TOUPPER ${prj} PRJ)
unset(${PRJ}_INCLUDE_DIRS CACHE)
find_path(${PRJ}_INCLUDE_DIRS RaptorQ/RaptorQ.hpp PATHS ${XP_ROOTDIR}/include NO_DEFAULT_PATH)
# needed for libRaptorQ (internally) to find eigen's includes
include_directories(SYSTEM ${XP_ROOTDIR}/include/eigen3)
set(${PRJ}_LIBRARIES RaptorQ_static)
set(reqVars ${PRJ}_INCLUDE_DIRS ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
