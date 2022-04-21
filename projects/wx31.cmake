# wx31
xpProOption(wx31 DBG_MSVC)
set(REPO github.com/wxWidgets/wxWidgets)
set(FORK github.com/smanders/wxWidgets)
set(VER31 3.1.0)
set(PRO_WX31
  NAME wx31
  WEB "wxWidgets" http://wxwidgets.org/ "wxWidgets website"
  LICENSE "open" http://www.wxwidgets.org/about/newlicen.htm "wxWindows License: essentially LGPL with an exception"
  DESC "Cross-Platform GUI Library"
  REPO "repo" https://${REPO} "wxWidgets repo on github"
  GRAPH GRAPH_NODE wx
  VER ${VER31}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER31} # what to 'git checkout'
  GIT_REF v${VER31}_pkg # patch from REF to TAG
  DLURL https://${REPO}/releases/download/v${VER31}/wxWidgets-${VER31}.tar.bz2
  DLMD5 ba4cd1f3853d0cd49134c5ae028ad080
  DLMD5 e20c14bb9bf5d4ec0979a3cd7510dece
  PATCH ${PATCH_DIR}/wx31.patch
  DIFF https://${FORK}/compare/
  SUBPRO wxcmake31
  )
