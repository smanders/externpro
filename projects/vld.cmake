########################################
# vld - visual leak detector
xpProOption(vld)
set(VER 2.4.1-xp)
set(REPO https://github.com/smanders/vld)
set(PRO_VLD
  NAME vld
  WEB "vld" http://vld.codeplex.com/ "vld website"
  LICENSE "open" http://vld.codeplex.com/license "LGPL"
  DESC "(MSW-only) Visual Leak Detector for Visual C++"
  REPO "repo" ${REPO} "forked vld repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/vld.git
  GIT_UPSTREAM git://github.com/KindDragon/vld.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 7c48675df832af24d04e82f7c475629c
  DLNAME vld-v${VER}.tar.gz
  PATCH ${PATCH_DIR}/vld.patch
  DIFF ${REPO}/compare/ # KindDragon doesn't have v2.4.1-xp tag
  )
########################################
function(mkpatch_vld)
  xpRepo(${PRO_VLD})
endfunction()
########################################
function(download_vld)
  xpNewDownload(${PRO_VLD})
endfunction()
########################################
function(patch_vld)
  xpPatch(${PRO_VLD})
endfunction()
########################################
function(build_vld)
  if(NOT (XP_DEFAULT OR XP_PRO_VLD))
    return()
  endif()
  set(BUILD_CONFIGS Release)
  xpCmakeBuild(vld)
endfunction()
