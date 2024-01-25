# jasper
# xpbuild:cmake-scratch
xpProOption(jasper DBG)
set(VER 1.900.1)
set(REPO https://github.com/mdadams/jasper)
set(FORK https://github.com/externpro/jasper)
set(PRO_JASPER
  NAME jasper
  WEB "JasPer" http://www.ece.uvic.ca/~frodo/jasper/ "JasPer website"
  LICENSE "open" "http://www.ece.uvic.ca/~frodo/jasper/#license" "JasPer License (based on MIT license)"
  DESC "JPEG 2000 Part-1 codec implementation"
  REPO "repo" ${FORK} "forked jasper repo on github"
  VER ${VER}
  GIT_UPSTREAM ${REPO}
  GIT_ORIGIN ${FORK}
  GIT_TAG xp-${VER} # what to 'git checkout'
  GIT_REF version-${VER} # create patch from this tag to 'git checkout'
  DLURL http://www.ece.uvic.ca/~frodo/jasper/software/jasper-${VER}.zip
  DLMD5 a342b2b4495b3e1394e161eb5d85d754
  PATCH ${PATCH_DIR}/jasper.patch
  DIFF ${FORK}/compare/
  )
########################################
function(build_jasper)
  if(NOT (XP_DEFAULT OR XP_PRO_JASPER))
    return()
  endif()
  xpGetArgValue(${PRO_JASPER} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_JASPER} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::lib${NAME})\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
endfunction()
