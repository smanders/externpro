########################################
# jxrlib
xpProOption(jxrlib)
set(VER 1.1-xp150831)
set(REPO https://github.com/smanders/jxrlib)
set(PRO_JXRLIB
  NAME jxrlib
  WEB "jxrlib" https://jxrlib.codeplex.com/ "jxrlib project hosted on CodePlex"
  LICENSE "open" https://jxrlib.codeplex.com/license "New BSD License (BSD)"
  DESC "open source implementation of the jpegxr image format standard"
  REPO "repo" ${REPO} "forked jxrlib repo on github"
  VER ${VER}
  GIT_UPSTREAM https://git01.codeplex.com/jxrlib
  GIT_FORK git://github.com/c0nk/jxrlib.git
  GIT_ORIGIN git://github.com/smanders/jxrlib.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  # NOTE: the download from codeplex is CR/LF, the repo is LF
  #DLURL https://jxrlib.codeplex.com/downloads/get/685250
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 a3545afc72f27b7954c82f262ac05994
  DLNAME jxrlib-v${VER}.tar.gz
  PATCH ${PATCH_DIR}/jxrlib.patch
  DIFF ${REPO}/compare/
  )
########################################
function(mkpatch_jxrlib)
  xpRepo(${PRO_JXRLIB})
endfunction()
########################################
function(download_jxrlib)
  xpNewDownload(${PRO_JXRLIB})
endfunction()
########################################
function(patch_jxrlib)
  xpPatch(${PRO_JXRLIB})
endfunction()
########################################
function(build_jxrlib)
  if(NOT (XP_DEFAULT OR XP_PRO_JXRLIB))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-jxrlib-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(jxrlib)
endfunction()
