# GEOTRANS_FOUND - geotrans was found
# GEOTRANS_VER - geotrans version
# GEOTRANS_LIBRARIES - the geotrans libraries
# GEOTRANS_DATA_DIR - the geotrans data directory
set(prj geotrans)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}_@VER@-targets.cmake)
set(${PRJ}_LIBRARIES xpro::geotrans)
set(${PRJ}_DATA_DIR ${XP_ROOTDIR}/include/${prj}_@VER@/${prj}/data)
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES ${PRJ}_DATA_DIR)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
