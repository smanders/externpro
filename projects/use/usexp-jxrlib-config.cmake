# JXRLIB_FOUND - jxrlib was found
# JXRLIB_INCLUDE_DIR - the jxrlib include directory
# JXRLIB_LIBRARIES - the jxrlib libraries
set(prj jxrlib)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(ver _@JXRVER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR jxrlib/windowsmediaphoto.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES jxrlib)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
