# BZIP2_FOUND - bzip2 was found
# BZIP2_INCLUDE_DIR - the bzip2 include directory
# BZIP2_LIBRARIES - the bzip2 libraries
set(prj bzip2)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}-targets.cmake)
string(TOUPPER ${prj} PRJ)
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR bzip2/bzlib.h PATHS ${XP_ROOTDIR}/include NO_DEFAULT_PATH)
set(${PRJ}_LIBRARIES bz2)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
