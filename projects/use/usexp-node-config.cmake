string(TOUPPER node PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
@FIND_DEPS@# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
set(reqVars ${PRJ}_VER)
if(MSVC)
  set(${PRJ}_LIBRARIES ${XP_ROOTDIR}/lib/node.lib)
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
set(includeDirs ${XP_ROOTDIR}/include/node_@VER@ ${XP_ROOTDIR}/include/node_@VER@/node)
set_target_properties(xpro::node PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${includeDirs}"
  )
set(${PRJ}_EXE ${XP_ROOTDIR}/bin/node${CMAKE_EXECUTABLE_SUFFIX})
list(APPEND reqVars ${PRJ}_EXE)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
