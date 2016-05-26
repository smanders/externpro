# WXWIDGETS_FOUND - wxwidgets was found
# WXWIDGETS_INCLUDE_DIR - the wxwidgets include directory
# WXWIDGETS_LIBRARIES - the wxwidgets libraries
# WXWIDGETS_VER - the wxwidgets version
set(prj wxwidgets)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
#set(XP_USE_LATEST_WX ON)
option(XP_USE_LATEST_WX "build with wxWidgets 3.1 instead of 3.0" OFF)
if(XP_USE_LATEST_WX)
  set(wxVersion "3.1")
else()
  set(wxVersion "3.0")
endif()
# WXWIDGETS_VER should be of the form: 30, 31 (not 3.0, 3.1)
# to account for how the targets.cmake files are named
# this will be used by the wxx use script, too
string(REGEX REPLACE "([0-9])\\.([0-9])?" "\\1\\2" ${PRJ}_VER ${wxVersion})
# NOTE: geotiff needs to find tiff, and we use the tiff bundled with wx
list(APPEND ${PRJ}_INCLUDE_DIR ${XP_ROOTDIR}/include/wx-${wxVersion}/wx/tiff)
if(NOT DEFINED wx_libs)
  # http://docs.wxwidgets.org/trunk/page_libs.html
  # TRICKY: reverse dependency order (base should be last)
  set(wx_libs aui richtext adv gl html core net xml base)
  if(${CMAKE_SYSTEM_NAME} STREQUAL SunOS)
    # wxGL brings in -lGL -lGLU, and -lGLU caused us segfaults on Solaris
    list(REMOVE_ITEM wx_libs gl)
  endif()
endif()
if(UNIX)
  set(wxWidgets_CONFIG_OPTIONS --prefix=${XP_ROOTDIR} --version=${wxVersion})
  unset(wxWidgets_CONFIG_EXECUTABLE CACHE)
  set(wxWidgets_CONFIG_EXECUTABLE ${XP_ROOTDIR}/bin/wx-config)
  find_package(wxWidgets REQUIRED ${wx_libs})
  include(${wxWidgets_USE_FILE})
  #set(wx_DEBUG TRUE)
  if(wx_DEBUG)
    message(STATUS "wxWidgets_USE_FILE: ${wxWidgets_USE_FILE}")
    message(STATUS "wxWidgets_INCLUDE_DIRS: ${wxWidgets_INCLUDE_DIRS}")
    message(STATUS "wxWidgets_LIBRARIES: ${wxWidgets_LIBRARIES}")
    message(STATUS "wxWidgets_LIBRARY_DIRS: ${wxWidgets_LIBRARY_DIRS}")
    message(STATUS "wxWidgets_DEFINITIONS: ${wxWidgets_DEFINITIONS}")
    message(STATUS "wxWidgets_CXX_FLAGS: ${wxWidgets_CXX_FLAGS}")
  endif()
  mark_as_advanced(wxWidgets_USE_DEBUG)
  mark_as_advanced(wxWidgets_wxrc_EXECUTABLE)
  list(APPEND ${PRJ}_INCLUDE_DIR ${wxWidgets_INCLUDE_DIRS})
  set(${PRJ}_LIBRARIES ${wxWidgets_LIBRARIES})
  execute_process(COMMAND sh "${wxWidgets_CONFIG_EXECUTABLE}" --prefix=${XP_ROOTDIR}
    --version=${wxVersion} --version
    OUTPUT_VARIABLE wxver OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET
    )
  if(wx_DEBUG)
    message(STATUS "wxWidgets version: ${wxver}")
  endif()
  ############################
  # GTK2
  if(NOT ${CMAKE_SYSTEM_NAME} STREQUAL Darwin)
    if(${CMAKE_SYSTEM_NAME} STREQUAL Linux)
      set(GTK2_ADDITIONAL_SUFFIXES x86_64-linux-gnu/glib-2.0)
    endif()
    find_package(PkgConfig)
    pkg_check_modules(GTK2 REQUIRED gtk+-2.0)
    if(GTK2_FOUND)
      list(APPEND ${PRJ}_INCLUDE_DIR ${GTK2_INCLUDE_DIRS})
    else()
      message(SEND_ERROR "GTK2 not found")
    endif()
  endif()
elseif(MSVC)
  add_definitions(-DwxUSE_NO_MANIFEST)
  list(APPEND ${PRJ}_INCLUDE_DIR
    ${XP_ROOTDIR}/include/wx-${wxVersion}
    ${XP_ROOTDIR}/include/wx-${wxVersion}/wx/msvc
    )
  # targets file (-targets) installed to lib/cmake
  include(${XP_ROOTDIR}/lib/cmake/${prj}${${PRJ}_VER}-targets.cmake)
  set(${PRJ}_LIBRARIES ${wx_libs}
    # on unix these libs come from wx-config --libs
    wxexpat wxjpeg wxpng wxregex wxscintilla wxtiff wxzlib
    rpcrt4 comctl32 # system libraries required by wxCore
    gdiplus # wxUSE_GRAPHICS_CONTEXT set to 1 in setup.h
    )
endif()
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_VER)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
