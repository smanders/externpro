########################################
# jasper
# http://packages.debian.org/sid/libjasper-dev
# http://jasper.sourcearchive.com/
xpProOption(jasper)
set(VER 1.900.1)
set(REPO https://github.com/smanders/jasper)
set(PRO_JASPER
  NAME jasper
  WEB "JasPer" http://www.ece.uvic.ca/~frodo/jasper/ "JasPer website"
  LICENSE "open" "http://www.ece.uvic.ca/~frodo/jasper/#license" "JasPer License (based on MIT license)"
  DESC "JPEG 2000 Part-1 codec implementation"
  REPO "repo" ${REPO} "jasper repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/jasper.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF jv${VER} # create patch from this tag to 'git checkout'
  DLURL http://www.ece.uvic.ca/~frodo/jasper/software/jasper-${VER}.zip
  DLMD5 a342b2b4495b3e1394e161eb5d85d754
  PATCH ${PATCH_DIR}/jasper.patch
  DIFF ${REPO}/compare/
  )
########################################
function(mkpatch_jasper)
  xpRepo(${PRO_JASPER})
endfunction()
########################################
function(download_jasper)
  xpNewDownload(${PRO_JASPER})
endfunction()
########################################
function(patch_jasper)
  xpPatch(${PRO_JASPER})
endfunction()
########################################
function(build_jasper)
  if(NOT (XP_DEFAULT OR XP_PRO_JASPER))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-jasper-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(jasper)
endfunction()
