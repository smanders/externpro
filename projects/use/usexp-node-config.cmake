# NODE_FOUND - Node.js was found
# NODE_VER - Node.js version
# NODE_LIBRARIES - the Node.js libraries (MSW-only)
# NODE_EXE - the Node.js executable
set(prj node)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
@USE_SCRIPT_INSERT@
if(NOT DEFINED XP_USE_LATEST_NODE)
  option(XP_USE_LATEST_NODE "build with node @NODE_NEWVER@ instead of @NODE_OLDVER@" ON)
endif()
if(XP_USE_LATEST_NODE)
  set(ver @NODE_NEWVER@)
else()
  set(ver @NODE_OLDVER@)
endif()
set(${PRJ}_VER "${ver} [@PROJECT_NAME@]")
set(reqVars ${PRJ}_VER)
if(MSVC)
  set(${PRJ}_LIBRARIES ${XP_ROOTDIR}/node_${ver}/lib/node.lib)
  list(APPEND reqVars ${PRJ}_LIBRARIES)
  if(NOT TARGET xpro::node)
    add_library(xpro::node STATIC IMPORTED)
    set_property(TARGET xpro::node APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
    set_target_properties(xpro::node PROPERTIES
      IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C;CXX"
      IMPORTED_LOCATION_RELEASE "${${PRJ}_LIBRARIES}"
      )
  endif()
else()
  if(NOT TARGET xpro::node)
    add_library(xpro::node INTERFACE IMPORTED)
  endif()
endif()
set(includeDirs ${XP_ROOTDIR}/include/node_${ver} ${XP_ROOTDIR}/include/node_${ver}/node)
set_target_properties(xpro::node PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${includeDirs}"
  )
set(${PRJ}_EXE ${XP_ROOTDIR}/node_${ver}/bin/node${CMAKE_EXECUTABLE_SUFFIX})
list(APPEND reqVars ${PRJ}_EXE)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
