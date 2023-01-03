# glew
# xpbuild:cmake-patch
xpProOption(glew DBG)
set(VER 1.13.0)
set(REPO https://github.com/nigels-com/glew)
set(FORK https://github.com/smanders/glew)
set(PRO_GLEW
  NAME glew
  WEB "GLEW" http://glew.sourceforge.net "GLEW on sourceforge.net"
  LICENSE "open" http://glew.sourceforge.net/credits.html "Modified BSD, Mesa 3-D (MIT), and Khronos (MIT)"
  DESC "The OpenGL Extension Wrangler Library"
  REPO "repo" ${REPO} "GLEW repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp-${VER}
  GIT_REF glew-${VER}
  DLURL https://downloads.sourceforge.net/project/glew/glew/${VER}/glew-${VER}.tgz
  DLMD5 7cbada3166d2aadfc4169c4283701066
  PATCH ${PATCH_DIR}/glew.patch
  DIFF ${FORK}/compare/nigels-com:
  )
########################################
function(build_glew)
  if(NOT (XP_DEFAULT OR XP_PRO_GLEW))
    return()
  endif()
  xpGetArgValue(${PRO_GLEW} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_GLEW} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DBUILD_UTILS=OFF
    -DBUILD_SHARED_LIBS=OFF
    -DINSTALL_PKGCONFIG=OFF
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES GLEW::glew_s) # GLEW::glewmx_s also exists\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
endfunction()
