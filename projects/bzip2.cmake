########################################
# bzip2
xpProOption(bzip2)
set(VER 1.0.6)
set(REPO https://github.com/smanders/bzip2)
set(PRO_BZIP2
  NAME bzip2
  WEB "bzip2" http://www.bzip.org/ "bzip2 website"
  LICENSE "open" http://www.bzip.org/index.html "bzip2 BSD-style license"
  DESC "lossless block-sorting data compression library"
  REPO "repo" ${REPO} "forked bzip2 repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/bzip2.git
  GIT_UPSTREAM git://github.com/LuaDist/bzip2.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://www.bzip.org/${VER}/bzip2-${VER}.tar.gz
  DLMD5 00b516f4704d4a7cb50a1d97e6e8e15b
  PATCH ${PATCH_DIR}/bzip2.patch
  DIFF ${REPO}/compare/
  )
########################################
function(mkpatch_bzip2)
  xpRepo(${PRO_BZIP2})
endfunction()
########################################
function(download_bzip2)
  xpNewDownload(${PRO_BZIP2})
endfunction()
########################################
function(patch_bzip2)
  xpPatch(${PRO_BZIP2})
endfunction()
########################################
function(build_bzip2)
  if(NOT (XP_DEFAULT OR XP_PRO_BZIP2))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-bzip2-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(bzip2 "" "" bzip2Targets)
  if(ARGN)
    set(${ARGN} "${bzip2Targets}" PARENT_SCOPE)
  endif()
endfunction()
