# JASPER_FOUND - jasper was found
# JASPER_INCLUDE_DIR - the jasper include directory
# JASPER_LIBRARIES - the jasper libraries
set(prj jasper)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(ver _@JASVER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR jasper/jasper.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES libjasper)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
