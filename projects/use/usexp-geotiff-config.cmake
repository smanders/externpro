# GEOTIFF_FOUND - geotiff was found
# GEOTIFF_INCLUDE_DIR - the geotiff include directory
# GEOTIFF_LIBRARIES - the geotiff libraries
set(prj geotiff)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(gtifVer _@GTIFVER@)
set(gtifVerDir /${prj}${gtifVer})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR geotiff/geotiff.h PATHS ${XP_ROOTDIR}/include${gtifVerDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${gtifVer}-targets.cmake)
set(${PRJ}_LIBRARIES geotiff)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
