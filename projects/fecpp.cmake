# fecpp
xpProOption(fecpp DBG)
set(REPO github.com/randombit/fecpp)
set(FORK github.com/smanders/fecpp)
set(VER 0.9)
set(PRO_FECPP
  NAME fecpp
  WEB "fecpp" http://www.randombit.net/code/fecpp/ "C++ forward error correction with SIMD optimizations"
  LICENSE "open" http://www.randombit.net/code/fecpp/ "BSD License"
  DESC "fecpp is a Forward Error Correction Library"
  REPO "repo" https://${REPO} "fecpp repo on github"
  GRAPH BUILD_DEPS boost
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://files.randombit.net/fecpp/fecpp-${VER}.tgz
  DLMD5 990e5b529e1b86fb5ee141c6307fb7dd
  PATCH ${PATCH_DIR}/fecpp.patch
  DIFF https://${FORK}/compare/
  )
########################################
function(build_fecpp)
  if(NOT (XP_DEFAULT OR XP_PRO_FECPP))
    return()
  endif()
  xpBuildDeps(depsTgts ${PRO_FECPP})
  xpGetArgValue(${PRO_FECPP} ARG VER VALUE VER)
  set(XP_CONFIGURE -DXP_NAMESPACE:STRING=xpro -DFECPP_VER=${VER})
  configure_file(${PRO_DIR}/use/usexp-fecpp-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(fecpp "${depsTgts}" "${XP_CONFIGURE}")
endfunction()
