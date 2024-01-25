# wxxthings
# repo http://wxcode.svn.sourceforge.net/viewvc/wxcode/trunk/wxCode/components/wxthings/
# dwnl http://sourceforge.net/projects/wxcode/files/Components/wxThings/
set(VER 2006.04.28)
string(REPLACE "." "_" VER_ ${VER})
set(REPO https://github.com/externpro/wxthings)
set(PRO_WXXTHINGS
  NAME wxxthings
  SUPERPRO wxx
  SUBDIR wxthings
  WEB "wxThings" http://wxcode.sourceforge.net/showcomp.php?name=wxThings "wxthings on sourceforge"
  DESC "a variety of data containers and controls"
  REPO "repo" ${REPO} "wxthings repo on github"
  VER ${VER}
  GIT_ORIGIN ${REPO}
  GIT_TAG xp${VER}
  GIT_REF v${VER}
  DLURL http://downloads.sourceforge.net/project/wxcode/Components/wxThings/wxthings_${VER_}.tar.gz
  DLMD5 1d769a677c0f3f10d51de579873c2613
  PATCH ${PATCH_DIR}/wxx.things.patch
  DIFF ${REPO}/compare/
  )
