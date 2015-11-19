########################################
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
  LICENSE "open" http://wxcode.sourceforge.net/rules.php "wxCode components must use wxWindows license"
  DESC "interactive xy data plotting widgets"
  REPO "repo" ${REPO} "wxplotctrl repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/wxplotctrl.git
  GIT_TAG sdl_${VER_} # TODO: rename tag
  GIT_REF v${VER}
  DLURL http://downloads.sourceforge.net/project/wxcode/Components/wxPlotCtrl/wxplotctrl_${VER_}.tar.gz
  DLMD5 3a0a4feddc5fead1152e6752bfe473bc
  PATCH ${PATCH_DIR}/wxx.plotctrl.patch
  DIFF ${REPO}/compare/
  )
########################################
function(mkpatch_wxxplotctrl)
  xpRepo(${PRO_WXXPLOTCTRL})
endfunction()
########################################
function(download_wxxplotctrl)
  xpNewDownload(${PRO_WXXPLOTCTRL})
endfunction()
########################################
function(patch_wxxplotctrl)
  patch_wxx()
  xpPatch(${PRO_WXXPLOTCTRL})
endfunction()
