# WXWIDGETS_FOUND - wxwidgets was found
# WXWIDGETS_VERSION - the wxwidgets version
# WXWIDGETS_INCLUDE_DIR - the wxwidgets include directory
# WXWIDGETS_LIBRARIES - the wxwidgets libraries
# WXWIDGETS_DEFINITIONS - wxwidgets compile definitions
set(prj wxwidgets)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(XP_USE_LATEST_WX ON)
if(NOT DEFINED XP_USE_LATEST_WX)
  option(XP_USE_LATEST_WX "build with wxWidgets @WX_NEWVER@ instead of @WX_OLDVER@" ON)
endif()
if(XP_USE_LATEST_WX)
  set(wxVersion "@WX_NEWVER@")
else()
  set(wxVersion "@WX_OLDVER@")
endif()
set(${PRJ}_VERSION "${wxVersion} [@PROJECT_NAME@]")
# WXWIDGETS_VER should be of the form: 30, 31 (not 3.0, 3.1)
# to account for how the targets.cmake files are named
# this will be used by the wxx use script, too
string(REGEX REPLACE "([0-9])\\.([0-9])?" "\\1\\2" ${PRJ}_VER ${wxVersion})
# http://docs.wxwidgets.org/trunk/page_libs.html
# TRICKY: reverse dependency order (base should be last)
set(wx_all_libs aui propgrid richtext adv gl html core net xml base)
if(NOT DEFINED wx_libs)
  set(wx_libs ${wx_all_libs})
endif()
unset(wxLibs)
foreach(lib ${wx_libs})
  list(APPEND wxLibs "wx::${lib}") # prepend NAMESPACE from install(EXPORT
endforeach()
set(${PRJ}_LIBRARIES ${wxLibs})
# NOTE: geotiff needs to find tiff, and we use the tiff bundled with wx
set(${PRJ}_INCLUDE_DIR ${XP_ROOTDIR}/include/wx-${wxVersion}/wx/tiff)
if(UNIX)
  unset(_filename CACHE) # temp variable in FindwxWidgets.cmake script
  unset(wxWidgets_CONFIG_EXECUTABLE CACHE)
  set(wxWidgets_CONFIG_EXECUTABLE ${XP_ROOTDIR}/bin/wx-config)
  set(wxWidgets_CONFIG_OPTIONS --prefix=${XP_ROOTDIR} --version=${wxVersion})
  find_package(wxWidgets REQUIRED ${wx_libs})
  if(XP_WXDEBUG)
    message(STATUS "wxWidgets_INCLUDE_DIRS: ${wxWidgets_INCLUDE_DIRS}")
    #message(STATUS "wxWidgets_LIBRARIES: ${wxWidgets_LIBRARIES}")
    #message(STATUS "wxWidgets_LIBRARY_DIRS: ${wxWidgets_LIBRARY_DIRS}")
    message(STATUS "wxWidgets_DEFINITIONS: ${wxWidgets_DEFINITIONS}")
    message(STATUS "wxWidgets_CXX_FLAGS: ${wxWidgets_CXX_FLAGS}")
  endif()
  mark_as_advanced(wxWidgets_USE_DEBUG)
  mark_as_advanced(wxWidgets_wxrc_EXECUTABLE)
  mark_as_advanced(_filename)
  #if(DEFINED wxWidgets_CXX_FLAGS)
  #  # -pthread from wxWidgets_CXX_FLAGS, was from include(${wxWidgets_USE_FILE})
  #  xpListAppendIfDne(CMAKE_CXX_FLAGS ${wxWidgets_CXX_FLAGS})
  #endif()
  set(${PRJ}_DEFINITIONS ${wxWidgets_DEFINITIONS})
  list(APPEND ${PRJ}_INCLUDE_DIR ${wxWidgets_INCLUDE_DIRS})
  ##################
  include(CheckLibraryExists)
  function(checkLibraryConcat lib symbol liblist)
    string(TOUPPER ${lib} LIB)
    check_library_exists("${lib}" "${symbol}" "" XP_WX_HAS_${LIB})
    if(XP_WX_HAS_${LIB})
      list(APPEND ${liblist} ${lib})
      set(${liblist} ${${liblist}} PARENT_SCOPE)
    endif()
  endfunction()
  ########
  function(getLibname target _ret)
    set(unicode u)
    if(${target} STREQUAL "base")
      set(${_ret} wx_${target}${unicode}-${wxVersion} PARENT_SCOPE)
    elseif(${target} STREQUAL "net" OR ${target} STREQUAL "xml")
      set(${_ret} wx_base${unicode}_${target}-${wxVersion} PARENT_SCOPE)
    elseif(${target} MATCHES "^wx") # any target that starts with "wx"
      if(NOT ${target} STREQUAL "wxregex")
        unset(unicode)
      endif()
      set(${_ret} ${target}${unicode}-${wxVersion} PARENT_SCOPE)
    else()
      set(${_ret} ${wxbasename}_${target}-${wxVersion} PARENT_SCOPE)
    endif()
  endfunction()
  ##################
  execute_process(COMMAND sh "${wxWidgets_CONFIG_EXECUTABLE}" --prefix=${XP_ROOTDIR}
    --version=${wxVersion} --basename --debug=no
    OUTPUT_VARIABLE wxbasename OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET
    )
  if(wxbasename MATCHES wx_gtk)
    if(@GTK_VER@ EQUAL 2)
      # NOTE: previously used pkg-config to find GTK2 and GTK3...
      # but hit an issue building externpro on CentOS 6 and using that build of
      # externpro for another project building on CentOS 7: pkg-config with GTK2
      # didn't return gthread-2.0 and resulted in a link error
      # libwx_gtk2u_core-3.1.a(corelib_gtk_app.o): undefined reference to symbol 'g_thread_init'
      # //lib64/libgthread-2.0.so.0: error adding symbols: DSO missing from command line
      find_package(GTK2 REQUIRED)
      if(GTK2_FOUND)
        list(APPEND ${PRJ}_INCLUDE_DIR ${GTK2_INCLUDE_DIRS})
        set(_wx_core_libs ${GTK2_TARGETS})
      endif()
    else()
      find_package(PkgConfig)
      pkg_check_modules(GTK REQUIRED gtk+-@GTK_VER@.0)
      if(GTK_FOUND)
        list(APPEND ${PRJ}_INCLUDE_DIR ${GTK_INCLUDE_DIRS})
        set(_wx_core_libs ${GTK_LIBRARIES})
      endif()
    endif()
    checkLibraryConcat(X11 XGetWindowAttributes _wx_core_libs)
    checkLibraryConcat(Xxf86vm XF86VidModeGetAllModeLines _wx_core_libs)
    checkLibraryConcat(SM SmcOpenConnection _wx_core_libs)
  endif()
  set(_wx_adv_deps core)
  set(_wx_aui_deps adv html)
  set(_wx_base_link wxregex wxzlib)
  set(_wx_core_deps base)
  set(_wx_core_link wxjpeg wxpng wxtiff)
  set(_wx_gl_deps core)
  #set(_wx_gl_libs GL GLU) # TODO determine if needed
  set(_wx_html_deps core)
  set(_wx_net_deps base)
  set(_wx_propgrid_deps adv)
  set(_wx_richtext_deps adv html xml)
  set(_wx_wxpng_link wxzlib)
  set(_wx_wxtiff_link wxjpeg wxzlib)
  set(_wx_xml_deps base)
  set(_wx_xml_link wxexpat)
  set(THREADS_PREFER_PTHREAD_FLAG ON)
  find_package(Threads REQUIRED)
  set(_wx_base_libs Threads::Threads)
  checkLibraryConcat(dl dlclose _wx_base_libs)
  checkLibraryConcat(m pow _wx_base_libs)
  # standard way is to get these _wx_link libs from 'wx-config --libs'
  set(_wx_link wxexpat wxjpeg wxpng wxregex wxscintilla wxtiff wxzlib)
  foreach(lib ${wx_all_libs} ${_wx_link})
    if(NOT TARGET wx::${lib})
      add_library(wx::${lib} STATIC IMPORTED)
      getLibname(${lib} ${lib}filename)
      set(${lib}_RELEASE ${XP_ROOTDIR}/lib/lib${${lib}filename}.a)
      if(EXISTS "${${lib}_RELEASE}")
        set_property(TARGET wx::${lib} APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
        set_target_properties(wx::${lib} PROPERTIES
          IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "C;CXX"
          IMPORTED_LOCATION_RELEASE "${${lib}_RELEASE}"
          )
        if(${PRJ}_INCLUDE_DIR)
          set_target_properties(wx::${lib} PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${${PRJ}_INCLUDE_DIR}"
            )
        endif()
        if(${PRJ}_DEFINITIONS)
          set_target_properties(wx::${lib} PROPERTIES
            INTERFACE_COMPILE_DEFINITIONS "${${PRJ}_DEFINITIONS}"
            )
        endif()
        if(_wx_${lib}_deps OR _wx_${lib}_link OR _wx_${lib}_libs)
          unset(linkLibs)
          foreach(dep ${_wx_${lib}_deps})
            list(APPEND linkLibs wx::${dep})
          endforeach()
          foreach(dep ${_wx_${lib}_link})
            list(APPEND linkLibs \$<LINK_ONLY:wx::${dep}>)
          endforeach()
          foreach(dep ${_wx_${lib}_libs})
            list(APPEND linkLibs \$<LINK_ONLY:${dep}>)
          endforeach()
          set_target_properties(wx::${lib} PROPERTIES
            INTERFACE_LINK_LIBRARIES "${linkLibs}"
            )
        endif()
      endif()
    endif()
  endforeach()
  execute_process(COMMAND sh "${wxWidgets_CONFIG_EXECUTABLE}" --prefix=${XP_ROOTDIR}
    --version=${wxVersion} --version
    OUTPUT_VARIABLE wxver OUTPUT_STRIP_TRAILING_WHITESPACE ERROR_QUIET
    )
  if(XP_WXDEBUG)
    message(STATUS "wxWidgets version: ${wxver}")
    message(STATUS "wxWidgets LIBRARIES: ${${PRJ}_LIBRARIES}")
  endif()
elseif(MSVC)
  set(${PRJ}_DEFINITIONS -DwxUSE_NO_MANIFEST)
  list(APPEND ${PRJ}_INCLUDE_DIR
    ${XP_ROOTDIR}/include/wx-${wxVersion}
    ${XP_ROOTDIR}/include/wx-${wxVersion}/wx/msvc
    )
  # targets file (-targets) installed to lib/cmake
  include(${XP_ROOTDIR}/lib/cmake/${prj}${${PRJ}_VER}-targets.cmake)
  list(APPEND ${PRJ}_LIBRARIES
    rpcrt4 comctl32 # system libraries required by wxCore
    gdiplus # wxUSE_GRAPHICS_CONTEXT set to 1 in setup.h
    )
endif()
set(reqVars ${PRJ}_VERSION ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_DEFINITIONS)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
