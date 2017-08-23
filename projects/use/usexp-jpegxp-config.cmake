# JPEGXP_FOUND - jpegxp was found
# JPEGXP_INCLUDE_DIR - the jpegxp include directory
# JPEGXP_LIBRARIES - the jpegxp libraries
set(prj jpegxp)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(jxpVer _@JXPVER@)
set(jxpVerDir /${prj}${jxpVer})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR jpegxp/jpeglib.h PATHS ${XP_ROOTDIR}/include${jxpVerDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${jxpVer}-targets.cmake)
set(${PRJ}_LIBRARIES jpegxp)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
