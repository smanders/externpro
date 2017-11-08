# glew
xpProOption(glew)
set(VER 1.7.0)
set(GLLN http://glew.sourceforge.net)
set(GLDL https://downloads.sourceforge.net/project/glew/glew/${VER})
set(PRO_GLEW
  NAME glew
  WEB "GLEW" ${GLLN} "GLEW on sourceforge.net"
  LICENSE "open" ${GLLN}/credits.html "Modified BSD, Mesa 3-D (MIT), and Khronos (MIT)"
  DESC "pre-built (MSW-only) The OpenGL Extension Wrangler Library"
  REPO "repo" https://github.com/nigels-com/glew "GLEW repo on github"
  VER ${VER}
  #GIT_ORIGIN git://github.com/nigels-com/glew.git
  #GIT_TAG 4a5f85e49034c7c3364dc2658040dc18cb8eed71 # tags start at glew-1.10.0
  DLURL ${GLDL}/glew-${VER}.tgz
  DLMD5 fb7a8bb79187ac98a90b57f0f27a3e84
  DLMD5_WIN32 655c4e371335aa6c19d6f5b121f0e262 DLURL_WIN32 ${GLDL}/glew-${VER}-win32.zip
  DLMD5_WIN64 7e2059b66a7867031a74f341aaf7a91f DLURL_WIN64 ${GLDL}/glew-${VER}-win64.zip
  DLADD _WIN32 _WIN64
  )
########################################
macro(getGlewOs)
  if(WIN32 AND ${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    set(OS WIN)
  else()
    message(FATAL_ERROR "glew.cmake: OS support lacking")
  endif()
endmacro()
########################################
function(build_glew)
  if(NOT (XP_DEFAULT OR XP_PRO_GLEW))
    return()
  endif()
  xpGetArgValue(${PRO_GLEW} ARG VER VALUE VER)
  set(verDir /glew_${VER})
  configure_file(${PRO_DIR}/use/usexp-glew-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  if(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    getGlewOs()
    set(pf ${BUILD_PLATFORM})
    xpGetArgValue(${PRO_GLEW} ARG DLURL_${OS}${pf} VALUE dwnldUrl)
    xpGetArgValue(${PRO_GLEW} ARG DLMD5_${OS}${pf} VALUE dwnldMd5)
    ExternalProject_Add(glew_${OS}${pf}_bld DEPENDS glew
      URL ${dwnldUrl} URL_MD5 ${dwnldMd5} DOWNLOAD_DIR ${DWNLD_DIR}
      BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
      CONFIGURE_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/include/GL/*.h
        -Ddst:STRING=${STAGE_DIR}/include${verDir}/GL/ -P ${MODULES_DIR}/cmscopyfiles.cmake
      BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/lib/*.lib
        -Ddst:STRING=${STAGE_DIR}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
      INSTALL_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/bin/*.dll
        -Ddst:STRING=${STAGE_DIR}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
      )
    set_property(TARGET glew_${OS}${pf}_bld PROPERTY FOLDER ${bld_folder})
    message(STATUS "target glew_${OS}${pf}_bld")
  endif()
endfunction()
