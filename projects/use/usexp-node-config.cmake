# NODE_FOUND - Node.js was found
# NODE_VER - Node.js version
# NODE_INCLUDE_DIR - the Node.js include directory
# NODE_LIBRARIES - the Node.js libraries (MSW-only)
# NODE_EXE - the Node.js executable
set(prj node)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
@USE_SCRIPT_INSERT@
if(NOT DEFINED XP_USE_LATEST_NODE)
  option(XP_USE_LATEST_NODE "build with node @NODE_NEWVER@ instead of @NODE_OLDVER@" OFF)
endif()
if(XP_USE_LATEST_NODE)
  set(ver @NODE_NEWVER@)
else()
  set(ver @NODE_OLDVER@)
endif()
set(${PRJ}_VER "${ver} [@PROJECT_NAME@]")
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR node/node.h PATHS ${XP_ROOTDIR}/include/node_${ver} NO_DEFAULT_PATH)
list(APPEND ${PRJ}_INCLUDE_DIR ${XP_ROOTDIR}/include/node_${ver}/node) # for internal header includes
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR)
if(MSVC)
  set(${PRJ}_LIBRARIES ${XP_ROOTDIR}/node_${ver}/lib/node.lib)
  list(APPEND reqVars ${PRJ}_LIBRARIES)
endif()
set(${PRJ}_EXE ${XP_ROOTDIR}/node_${ver}/bin/node${CMAKE_EXECUTABLE_SUFFIX})
list(APPEND reqVars ${PRJ}_EXE)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
