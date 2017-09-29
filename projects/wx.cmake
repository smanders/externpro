# wx
set(WX_VERSIONS 31)
if(UNIX AND NOT ${CMAKE_SYSTEM_NAME} STREQUAL Darwin)
  set(GTK_VER_RECORDED FALSE CACHE BOOL "gtk version not recorded" FORCE)
  set_property(CACHE GTK_VER_RECORDED PROPERTY TYPE INTERNAL)
endif()
########################################
function(build_wx)
  if(UNIX AND NOT ${CMAKE_SYSTEM_NAME} STREQUAL Darwin)
    # TODO: detect package required to build on rhel6:
    #   yum install libSM-devel.x86_64
    find_package(PkgConfig)
    #####
    # gtk
    if(NOT GTK2_FOUND)
      pkg_check_modules(GTK3 gtk+-3.0)
    endif()
    if(GTK3_FOUND)
      set(GTK_VER 3)
      if(NOT GTK_VER_RECORDED)
        file(APPEND ${XP_INFOFILE} "gtk3 version: ${GTK3_VERSION}\n")
        set(GTK_VER_RECORDED TRUE CACHE BOOL "gtk version recorded" FORCE)
        set_property(CACHE GTK_VER_RECORDED PROPERTY TYPE INTERNAL)
      endif()
    else()
      pkg_check_modules(GTK2 gtk+-2.0)
      if(GTK2_FOUND)
        set(GTK_VER 2)
        if(NOT GTK_VER_RECORDED)
          file(APPEND ${XP_INFOFILE} "gtk2 version: ${GTK2_VERSION}\n")
          set(GTK_VER_RECORDED TRUE CACHE BOOL "gtk version recorded" FORCE)
          set_property(CACHE GTK_VER_RECORDED PROPERTY TYPE INTERNAL)
        endif()
      else()
        message(FATAL_ERROR "\n"
          "gtk development not found -- wxWidgets can't be built. install on linux:\n"
          "  apt install libgtk2.0-dev or libgtk-3-dev\n"
          "  yum install gtk2-devel.x86_64 or gtk3-devel.x86_64\n"
          )
      endif()
    endif()
    ########
    # OpenGL
    find_package(OpenGL)
    if(NOT OPENGL_FOUND OR NOT OPENGL_GLU_FOUND)
      message(FATAL_ERROR "\n"
        "OpenGL or GLU not found -- wxWidgets can't be built. install on linux:\n"
        "  apt install libglu1-mesa-dev\n"
        "  yum install mesa-libGL-devel.x86_64 mesa-libGLU-devel.x86_64\n"
        )
    endif()
  else()
    set(GTK_VER UNDEFINED)
  endif()
  set(GTK_VER ${GTK_VER} PARENT_SCOPE)
  configure_file(${PRO_DIR}/use/usexp-wxwidgets-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  foreach(ver ${WX_VERSIONS})
    build_wxv(VER ${ver})
  endforeach()
endfunction()
########################################
function(build_wxv)
  set(oneValueArgs VER TARGETS INCDIR SRCDIR)
  cmake_parse_arguments(wx "" "${oneValueArgs}" "" ${ARGN})
  if(NOT (XP_DEFAULT OR XP_PRO_WX${wx_VER}))
    return()
  endif()
  if(MSVC)
    set(XP_CONFIGURE -DWX_VERSION:STRING=${wx_VER})
    xpCmakeBuild(wx${wx_VER} wx${wx_VER}_wxcmake${wx_VER} "${XP_CONFIGURE}")
    set(config msvc)
    list(APPEND wx${wx_VER}targets wx${wx_VER}_${config})
  else()
    xpGetConfigureFlags(CXX wx_CONFIGURE_FLAGS)
    if(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
      # http://forums.wxwidgets.org/viewtopic.php?f=19&t=37432
      set(XP_CONFIGURE_BASE <SOURCE_DIR>/configure --with-osx_cocoa
        --with-macosx-version-min=10.7
        --enable-universal_binary=i386,x86_64
        )
      execute_process(
        COMMAND xcrun --sdk macosx --show-sdk-path
        OUTPUT_VARIABLE sdkPath
        OUTPUT_STRIP_TRAILING_WHITESPACE
        )
      if(sdkPath)
        list(APPEND XP_CONFIGURE_BASE --with-macosx-sdk=${sdkPath})
      endif()
    else()
      set(XP_CONFIGURE_BASE <SOURCE_DIR>/configure --with-gtk=${GTK_VER})
    endif()
    if(${CMAKE_CXX_COMPILER_ID} MATCHES "Clang")
      list(APPEND XP_CONFIGURE_BASE CXX=clang++)
    endif()
    if(${CMAKE_C_COMPILER_ID} MATCHES "Clang")
      list(APPEND XP_CONFIGURE_BASE CC=clang)
    endif()
    list(APPEND XP_CONFIGURE_BASE ${wx_CONFIGURE_FLAGS} --with-opengl
      --with-libjpeg=builtin --with-libpng=builtin --with-libtiff=builtin
      --with-expat=builtin --with-regex=builtin --with-zlib=builtin
      #TODO: --without-subdirs (what does this option do? saw it used in wx forums)
      --disable-shared --disable-precomp-headers --without-libnotify
      # NOTE: without-libnotify so we can build externpro on a system that has libnotify
      # and use the built externpro installer on a system that doesn't have it
      --enable-display --enable-std_string --enable-std_iostreams --enable-std_containers
      )
    set(XP_CONFIGURE_Install --prefix=<INSTALL_DIR> --includedir=<INSTALL_DIR>/include
      --bindir=<INSTALL_DIR>/bin --libdir=<INSTALL_DIR>/lib
      )
    set(XP_CONFIGURE_Release ${XP_CONFIGURE_BASE})
    set(XP_CONFIGURE_Debug ${XP_CONFIGURE_BASE}
      --enable-debug --enable-debug_flag --enable-debug_info --enable-debug_gdb
      )
    # release version of wx is all we need
    # http://wxwidgets.blogspot.com/2009/09/debug-build-changes-in-wx3.html
    set(BUILD_CONFIGS Release)
    foreach(cfg ${BUILD_CONFIGS})
      set(XP_CONFIGURE_CMD ${XP_CONFIGURE_${cfg}} ${XP_CONFIGURE_Install})
      addproject_wx(wx${wx_VER} ${cfg})
    endforeach()
    list(GET BUILD_CONFIGS 0 config)
  endif()
  # stage_hdrs is a one-time thing, so copy headers from one of the wx build
  # targets, but depend on all of them so this will always happen last
  # (and wxx can depend on this)
  ExternalProject_Get_Property(wx${wx_VER} SOURCE_DIR)
  ExternalProject_Get_Property(wx${wx_VER}_${config} BINARY_DIR)
  ExternalProject_Get_Property(wx${wx_VER}_${config} INSTALL_DIR)
  set(wxSOURCE_DIR ${SOURCE_DIR})
  set(wxBINARY_DIR ${BINARY_DIR})
  set(wxINSTALL_DIR ${INSTALL_DIR})
  set(wxWINUNDEF ${wxSOURCE_DIR}/include/wx/msw/winundef.h)
  if(${wx_VER} EQUAL 31)
    set(wxSTAGE_DIR ${STAGE_DIR}/include/wx-3.1)
    set(TIFF_HDRS "src/tiff/libtiff/*.h")
  elseif(${wx_VER} EQUAL 30)
    set(wxSTAGE_DIR ${STAGE_DIR}/include/wx-3.0)
    set(TIFF_HDRS "src/tiff/libtiff/*.h")
  else()
    message(FATAL_ERROR "wx.cmake: wx version ${wx_VER} support lacking")
  endif()
  if(NOT TARGET wx${wx_VER}_stage_hdrs)
    ExternalProject_Add(wx${wx_VER}_stage_hdrs DEPENDS ${wx${wx_VER}targets}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} BINARY_DIR ${NULL_DIR}
      SOURCE_DIR ${wxSOURCE_DIR}  INSTALL_DIR ${wxSTAGE_DIR}
      PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${wxINSTALL_DIR}/include/ ${STAGE_DIR}/include/
      CONFIGURE_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${wxWINUNDEF}
        -Ddst:STRING=<INSTALL_DIR>/externpro/
        -P ${MODULES_DIR}/cmscopyfiles.cmake
      BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${wxSOURCE_DIR}/${TIFF_HDRS}
        -Ddst:STRING=<INSTALL_DIR>/wx/tiff/
        -P ${MODULES_DIR}/cmscopyfiles.cmake
      INSTALL_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${wxBINARY_DIR}/${TIFF_HDRS}
        -Ddst:STRING=<INSTALL_DIR>/wx/tiff/
        -P ${MODULES_DIR}/cmscopyfiles.cmake
      )
    set_property(TARGET wx${wx_VER}_stage_hdrs PROPERTY FOLDER ${bld_folder})
  endif()
  if(DEFINED wx_TARGETS)
    xpListAppendIfDne(${wx_TARGETS} ${wx${wx_VER}targets})
    xpListAppendIfDne(${wx_TARGETS} wx${wx_VER}_stage_hdrs)
    set(${wx_TARGETS} "${${wx_TARGETS}}" PARENT_SCOPE)
  endif()
  if(DEFINED wx_INCDIR)
    set(${wx_INCDIR} ${wxSTAGE_DIR} PARENT_SCOPE)
  endif()
  if(DEFINED wx_SRCDIR)
    set(${wx_SRCDIR} ${wxSOURCE_DIR} PARENT_SCOPE)
  endif()
endfunction()
####################
macro(addproject_wx basename cfg)
  set(XP_TARGET ${basename}_${cfg})
  ExternalProject_Get_Property(${basename} SOURCE_DIR)
  set(wxSOURCE_DIR ${SOURCE_DIR})
  if(NOT TARGET ${XP_TARGET})
    if(XP_BUILD_VERBOSE)
      message(STATUS "target ${XP_TARGET}")
      xpVerboseListing("[CONFIGURE]" "${XP_CONFIGURE_CMD}")
    else()
      message(STATUS "target ${XP_TARGET}")
    endif()
    ExternalProject_Add(${XP_TARGET} DEPENDS ${basename}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} SOURCE_DIR ${wxSOURCE_DIR}
      CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
      BUILD_COMMAND   # use default
      INSTALL_COMMAND # use default
      )
    ExternalProject_Add_Step(${XP_TARGET} postinstall_${XP_TARGET}
      COMMAND ${CMAKE_COMMAND} -E copy_directory
        <INSTALL_DIR>/lib ${STAGE_DIR}/lib
      DEPENDEES install
      )
    set_property(TARGET ${XP_TARGET} PROPERTY FOLDER ${bld_folder})
  endif()
  if(NOT TARGET ${XP_TARGET}_wxconfig)
    ExternalProject_Add(${XP_TARGET}_wxconfig DEPENDS ${XP_TARGET}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} SOURCE_DIR ${wxSOURCE_DIR}
      CONFIGURE_COMMAND ${XP_CONFIGURE_${cfg}}
      BUILD_COMMAND ${CMAKE_COMMAND} -DcfgDir:STRING=<BINARY_DIR>/lib/wx/config
        -DstgDir:STRING=${STAGE_DIR} -P ${MODULES_DIR}/cmswxconfig.cmake
      INSTALL_COMMAND "" INSTALL_DIR ${NULL_DIR}
      )
    set_property(TARGET ${XP_TARGET}_wxconfig PROPERTY FOLDER ${bld_folder})
  endif()
  list(APPEND ${basename}targets ${XP_TARGET} ${XP_TARGET}_wxconfig)
endmacro()
