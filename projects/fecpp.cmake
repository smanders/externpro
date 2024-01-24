# fecpp
# xpbuild:cmake-scratch
xpProOption(fecpp DBG)
set(REPO https://github.com/randombit/fecpp)
set(FORK https://github.com/smanders/fecpp)
set(VER 0.9)
set(PRO_FECPP
  NAME fecpp
  WEB "fecpp" http://www.randombit.net/code/fecpp/ "C++ forward error correction with SIMD optimizations"
  LICENSE "open" http://www.randombit.net/code/fecpp/ "BSD License"
  DESC "fecpp is a Forward Error Correction Library"
  REPO "repo" ${REPO} "fecpp repo on github"
  GRAPH BUILD_DEPS boost # library test code depends on boost
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://files.randombit.net/fecpp/fecpp-${VER}.tgz
  DLMD5 990e5b529e1b86fb5ee141c6307fb7dd
  PATCH ${PATCH_DIR}/fecpp.patch
  DIFF ${FORK}/compare/
  )
########################################
function(build_fecpp)
  if(NOT (XP_DEFAULT OR XP_PRO_FECPP))
    return()
  endif()
  xpBuildDeps(depsTgts ${PRO_FECPP})
  xpGetArgValue(${PRO_FECPP} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_FECPP} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_MODULE_PATH=${CMAKE_DIR}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME})\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depsTgts}" "${XP_CONFIGURE}")
endfunction()
