# NODE_FOUND - Node.js was found
# NODE_INCLUDE_DIR - the Node.js include directory
# NODE_LIBRARIES - the Node.js libraries
# NODE_EXE - the Node.js executable
# NODE_NPM - the Node.js npm script
set(prj node)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
option(XP_USE_LATEST_NODE "build with node v@NEWNUM@ instead of v@CURNUM@" OFF)
if(XP_USE_LATEST_NODE)
  set(ver @NEWVER@)
else()
  set(ver @CURVER@)
endif()
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR node/node.h PATHS ${XP_ROOTDIR}/include/node${ver} NO_DEFAULT_PATH)
if(MSVC)
  set(${PRJ}_LIBRARIES ${XP_ROOTDIR}/node${ver}/lib/node.lib)
  set(${PRJ}_EXE ${XP_ROOTDIR}/node${ver}/bin/node.exe)
  set(reqVars ${PRJ}_LIBRARIES ${PRJ}_EXE)
else()
  set(${PRJ}_LIBRARIES)
  set(${PRJ}_EXE ${XP_ROOTDIR}/node${ver}/bin/node)
  set(reqVars ${PRJ}_EXE)
endif()
set(${PRJ}_NPM ${XP_ROOTDIR}/node${ver}/npm/bin/npm-cli.js)
list(APPEND reqVars ${PRJ}_NPM)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
