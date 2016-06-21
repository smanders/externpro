# fecpp
xpProOption(fecpp)
set(REPO https://github.com/smanders/fecpp)
set(VER 0.9)
set(PRO_FECPP
  NAME fecpp
  WEB "fecpp" http://www.randombit.net/code/fecpp/ "C++ forward error correction with SIMD optimizations"
  LICENSE "open" http://www.randombit.net/code/fecpp/ "BSD License"
  DESC "fecpp is a Forward Error Correction Library"
  REPO "repo" ${REPO} "forked fecpp repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/fecpp.git
  GIT_UPSTREAM git://github.com/randombit/fecpp.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://files.randombit.net/fecpp/fecpp-${VER}.tgz
  DLMD5 990e5b529e1b86fb5ee141c6307fb7dd
  PATCH ${PATCH_DIR}/fecpp.patch
  DIFF ${REPO}/compare/
  )
########################################
function(build_fecpp)
  if(NOT (XP_DEFAULT OR XP_PRO_FECPP))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_BOOST))
    message(STATUS "fecpp.cmake: requires boost")
    set(XP_PRO_BOOST ON CACHE BOOL "include boost" FORCE)
    xpPatchProject(${PRO_BOOST})
  endif()
  build_boost(TARGETS boostTgts)
  configure_file(${PRO_DIR}/use/usexp-fecpp-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(fecpp "${boostTgts}")
endfunction()
