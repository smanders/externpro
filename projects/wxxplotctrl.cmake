# wxxplotctrl
# repo http://wxcode.svn.sourceforge.net/viewvc/wxcode/trunk/wxCode/components/plotctrl/
# dwnl http://sourceforge.net/projects/wxcode/files/Components/wxPlotCtrl/
set(VER 2006.04.28)
string(REPLACE "." "_" VER_ ${VER})
set(REPO https://github.com/smanders/wxplotctrl)
set(PRO_WXXPLOTCTRL
  NAME wxxplotctrl
  SUPERPRO wxx
  SUBDIR wxplotctrl
  WEB "wxPlotCtrl" http://wxcode.sourceforge.net/showcomp.php?name=wxPlotCtrl "wxplotctrl on sourceforge"
  DESC "interactive xy data plotting widgets"
  REPO "repo" ${REPO} "wxplotctrl repo on github"
  VER ${VER}
  GIT_ORIGIN ${REPO}
  GIT_TAG xp${VER}
  GIT_REF v${VER}
  DLURL http://downloads.sourceforge.net/project/wxcode/Components/wxPlotCtrl/wxplotctrl_${VER_}.tar.gz
  DLMD5 3a0a4feddc5fead1152e6752bfe473bc
  PATCH ${PATCH_DIR}/wxx.plotctrl.patch
  DIFF ${REPO}/compare/
  )
