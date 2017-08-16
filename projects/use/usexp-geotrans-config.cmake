# GEOTRANS_FOUND - geotrans was found
# GEOTRANS_INCLUDE_DIR - the geotrans include directory
# GEOTRANS_LIBRARIES - the geotrans libraries
# GEOTRANS_DATA_DIR - the geotrans data directory
set(prj geotrans)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(geoVer _@GEOTVER@)
set(geoVerDir /geotrans${geoVer})
unset(${PRJ}_INCLUDE_DIR CACHE)
unset(${PRJ}_DATA_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR geotrans/engine.h PATHS ${XP_ROOTDIR}/include${geoVerDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${geoVer}-targets.cmake)
set(${PRJ}_LIBRARIES geotrans)
set(${PRJ}_DATA_DIR ${${PRJ}_INCLUDE_DIR}/geotrans/data)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_DATA_DIR)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
