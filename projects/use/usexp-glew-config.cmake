# GLEW_FOUND - GLEW was found
# GLEW_VER - GLEW version
# GLEW_LIBRARIES - the GLEW libraries
# GLEW_DLLS - the GLEW DLLs
set(prj glew)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
if(NOT WIN32)
  set(XP_USE_LATEST_GLEW ON)
elseif(WIN32 AND NOT DEFINED XP_USE_LATEST_GLEW)
  option(XP_USE_LATEST_GLEW "build with glew @GLEW_BLDVER@ instead of pre-built @GLEW_MSWVER@" OFF)
endif()
if(XP_USE_LATEST_GLEW)
  set(glewVer @GLEW_BLDVER@)
else()
  set(glewVer @GLEW_MSWVER@)
endif()
set(${PRJ}_VER "${glewVer} [@PROJECT_NAME@]")
set(reqVars ${PRJ}_VER)
if(EXISTS ${XP_ROOTDIR}/lib/cmake/${prj}_${glewVer}/${prj}-targets.cmake) # built via cmake
  include(${XP_ROOTDIR}/lib/cmake/${prj}_${glewVer}/${prj}-targets.cmake)
  set(${PRJ}_LIBRARIES GLEW::glew_s) # GLEW::glewmx_s also exists
  list(APPEND reqVars ${PRJ}_LIBRARIES)
elseif(WIN32) # pre-built
  if(NOT TARGET GLEW::glew_s)
    add_library(GLEW::glew_s STATIC IMPORTED)
    set(glewRelease ${XP_ROOTDIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}glew32${CMAKE_STATIC_LIBRARY_SUFFIX})
    if(EXISTS "${glewRelease}")
      set_property(TARGET GLEW::glew_s APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(GLEW::glew_s PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C"
        IMPORTED_LOCATION_RELEASE "${glewRelease}"
        )
    endif()
    set_target_properties(GLEW::glew_s PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES ${XP_ROOTDIR}/include/${prj}_${glewVer}
      )
  endif()
  set(${PRJ}_LIBRARIES GLEW::glew_s)
  set(${PRJ}_DLLS
    ${XP_ROOTDIR}/lib/glew32.dll
    ${XP_ROOTDIR}/lib/glew32mx.dll # TODO determine if this is needed
    )
  list(APPEND reqVars ${PRJ}_LIBRARIES ${PRJ}_DLLS)
endif()
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
