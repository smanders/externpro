# glew
# http://glew.sourceforge.net/
xpProOption(glew)
set(VER 1.7.0)
set(PRO_GLEW
  NAME glew
  WEB "GLEW" http://glew.sourceforge.net/ "GLEW on sourceforge.net"
  LICENSE "open" http://glew.sourceforge.net/credits.html "Modified BSD, Mesa 3-D (MIT), and Khronos (MIT)"
  DESC "pre-built (MSW-only) The OpenGL Extension Wrangler Library"
  REPO "repo" https://github.com/nigels-com/glew "GLEW repo on github"
  VER ${VER}
  #GIT_ORIGIN git://github.com/nigels-com/glew.git
  #GIT_TAG 4a5f85e49034c7c3364dc2658040dc18cb8eed71 # tags start at glew-1.10.0
  )
########################################
set(GLEW_PLATFORMS WIN32 WIN64)
set(DL_URL http://downloads.sourceforge.net/project/glew/glew/${VER})
set(PRO_URL_GLEW_WIN32 ${DL_URL}/glew-${VER}-win32.zip)
set(PRO_MD5_GLEW_WIN32 655c4e371335aa6c19d6f5b121f0e262)
set(PRO_URL_GLEW_WIN64 ${DL_URL}/glew-${VER}-win64.zip)
set(PRO_MD5_GLEW_WIN64 7e2059b66a7867031a74f341aaf7a91f)
set(PRO_URL_GLEW ${DL_URL}/glew-${VER}.tgz)
set(PRO_MD5_GLEW fb7a8bb79187ac98a90b57f0f27a3e84)
########################################
function(download_glew)
  foreach(pltfrm ${GLEW_PLATFORMS})
    xpDownload(${PRO_URL_GLEW_${pltfrm}} ${PRO_MD5_GLEW_${pltfrm}} ${DWNLD_DIR})
  endforeach()
  #xpDownload(${PRO_URL_GLEW} ${PRO_MD5_GLEW} ${DWNLD_DIR})
endfunction()
########################################
macro(getGlewOs)
  if(WIN32 AND ${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    set(OS WIN)
  else()
    message(FATAL_ERROR "glew.cmake: OS support lacking")
  endif()
endmacro()
########################################
function(patch_glew)
  if(NOT (XP_DEFAULT OR XP_PRO_GLEW))
    return()
  endif()
  if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    getGlewOs()
    set(pf ${BUILD_PLATFORM})
    ExternalProject_Add(glew_${OS}${pf}
      URL ${PRO_URL_GLEW_${OS}${pf}} URL_MD5 ${PRO_MD5_GLEW_${OS}${pf}} DOWNLOAD_DIR ${DWNLD_DIR}
      PATCH_COMMAND "" UPDATE_COMMAND "" CONFIGURE_COMMAND "" BUILD_COMMAND "" INSTALL_COMMAND ""
      BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
      )
    set_property(TARGET glew_${OS}${pf} PROPERTY FOLDER ${src_folder})
  endif()
endfunction()
########################################
function(build_glew)
  if(NOT (XP_DEFAULT OR XP_PRO_GLEW))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-glew-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    getGlewOs()
    set(pf ${BUILD_PLATFORM})
    list(APPEND glew_DEPENDS glew_${OS}${pf})
    ExternalProject_Get_Property(glew_${OS}${pf} SOURCE_DIR)
    set(glew_SOURCE ${SOURCE_DIR})
    ExternalProject_Add(glew_${OS}${pf}_bld DEPENDS ${glew_DEPENDS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
      SOURCE_DIR ${glew_SOURCE} BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
      CONFIGURE_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/include/GL/*.h
        -Ddst:STRING=${STAGE_DIR}/include/GL/ -P ${MODULES_DIR}/cmscopyfiles.cmake
      BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/lib/*.lib
        -Ddst:STRING=${STAGE_DIR}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
      INSTALL_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/bin/*.dll
        -Ddst:STRING=${STAGE_DIR}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
      )
    set_property(TARGET glew_${OS}${pf}_bld PROPERTY FOLDER ${bld_folder})
    if(XP_BUILD_VERBOSE)
      message(STATUS "target glew_${OS}${pf}_bld")
      xpVerboseListing("[DEPENDS]" "${glew_DEPENDS}")
    else()
      message(STATUS "target glew_${OS}${pf}_bld")
    endif()
    list(APPEND glew_DEPENDS glew_${OS}${pf}_bld) # serialize the build
  endif()
endfunction()
