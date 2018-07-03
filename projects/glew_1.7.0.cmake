# glew
set(VER ${GLEW_MSWVER})
cmake_dependent_option(XP_PRO_GLEW_${VER} "include glew_${VER}" OFF "NOT XP_DEFAULT;WIN32" OFF)
set(GLLN http://glew.sourceforge.net)
set(GLDL https://downloads.sourceforge.net/project/glew/glew/${VER})
set(REPO https://github.com/nigels-com/glew)
set(PRO_GLEW_${VER}
  NAME glew_${VER}
  WEB "GLEW" ${GLLN} "GLEW on sourceforge.net"
  LICENSE "open" ${GLLN}/credits.html "Modified BSD, Mesa 3-D (MIT), and Khronos (MIT)"
  DESC "pre-built (MSW-only) The OpenGL Extension Wrangler Library"
  REPO "repo" ${REPO} "GLEW repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/nigels-com/glew.git
  GIT_TAG glew-${VER}
  DLURL ${GLDL}/glew-${VER}.tgz
  DLMD5 fb7a8bb79187ac98a90b57f0f27a3e84
  DLMD5_WIN32 655c4e371335aa6c19d6f5b121f0e262 DLURL_WIN32 ${GLDL}/glew-${VER}-win32.zip
  DLMD5_WIN64 7e2059b66a7867031a74f341aaf7a91f DLURL_WIN64 ${GLDL}/glew-${VER}-win64.zip
  DLADD _WIN32 _WIN64
  BUILD_FUNC build_glew_mswver
  )
########################################
function(build_glew_mswver)
  set(gl_VER ${GLEW_MSWVER})
  if(NOT WIN32 OR NOT (XP_DEFAULT OR XP_PRO_GLEW_${gl_VER}))
    return()
  endif()
  set(pf ${BUILD_PLATFORM})
  set(verDir /glew_${gl_VER})
  xpGetArgValue(${PRO_GLEW_${gl_VER}} ARG DLURL_WIN${pf} VALUE dwnldUrl)
  xpGetArgValue(${PRO_GLEW_${gl_VER}} ARG DLMD5_WIN${pf} VALUE dwnldMd5)
  ExternalProject_Add(glew_${gl_VER}_WIN${pf}_bld DEPENDS glew_${gl_VER}
    URL ${dwnldUrl} URL_MD5 ${dwnldMd5} DOWNLOAD_DIR ${DWNLD_DIR}
    BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
    CONFIGURE_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/include/GL/*.h
      -Ddst:STRING=${STAGE_DIR}/include${verDir}/GL/ -P ${MODULES_DIR}/cmscopyfiles.cmake
    BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/lib/*.lib
      -Ddst:STRING=${STAGE_DIR}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
    INSTALL_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/bin/*.dll
      -Ddst:STRING=${STAGE_DIR}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
    )
  set_property(TARGET glew_${gl_VER}_WIN${pf}_bld PROPERTY FOLDER ${bld_folder})
  message(STATUS "target glew_${gl_VER}_WIN${pf}_bld")
endfunction()
