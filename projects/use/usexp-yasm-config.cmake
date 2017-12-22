# YASM_FOUND - yasm was found
# YASM_INCLUDE_DIR - the yasm include directory
# YASM_LIBRARIES - the yasm libraries
# YASM_EXE - the yasm executable
set(prj yasm)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR libyasm.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to bin/cmake
include(${XP_ROOTDIR}/bin/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES libyasm)
set(${PRJ}_EXE yasm)
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_EXE)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
