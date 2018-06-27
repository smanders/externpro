# LUA_FOUND - lua was found
# LUA_VER - lua version
# LUA_INCLUDE_DIR - the lua and LuaBridge include directories
# LUA_LIBRARIES - the lua libraries
set(prj lua)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR lua/lua.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
# targets file (-targets) installed to lib/cmake
include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
set(${PRJ}_LIBRARIES liblua)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
# LuaBridge
set(prjB luabridge)
string(TOUPPER ${prjB} PRJB)
set(verDirB /${prjB}_@VERB@)
unset(${PRJB}_INCLUDE_DIR CACHE)
find_path(${PRJB}_INCLUDE_DIR LuaBridge/LuaBridge.h PATHS ${XP_ROOTDIR}/include${verDirB} NO_DEFAULT_PATH)
list(APPEND ${PRJ}_INCLUDE_DIR ${${PRJB}_INCLUDE_DIR})
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars} ${PRJB}_INCLUDE_DIR)
