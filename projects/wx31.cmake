# wx31
xpProOption(wx31)
set(REPO https://github.com/smanders/wxWidgets)
set(REPO_UPSTREAM https://github.com/wxWidgets/wxWidgets)
set(VER31 3.1.0)
set(PRO_WX31
  NAME wx31
  WEB "wxWidgets" http://wxwidgets.org/ "wxWidgets website"
  LICENSE "open" http://www.wxwidgets.org/about/newlicen.htm "wxWindows License: essentially LGPL with an exception"
  DESC "Cross-Platform GUI Library"
  REPO "repo" ${REPO} "forked wxWidgets repo on github"
  VER ${VER31}
  GIT_ORIGIN git://github.com/smanders/wxWidgets.git
  GIT_UPSTREAM git://github.com/wxWidgets/wxWidgets.git
  GIT_TAG xp${VER31} # what to 'git checkout'
  GIT_REF v${VER31}_pkg # patch from REF to TAG
  DLURL ${REPO_UPSTREAM}/releases/download/v${VER31}/wxWidgets-${VER31}.tar.bz2
  DLMD5 ba4cd1f3853d0cd49134c5ae028ad080
  DLMD5 e20c14bb9bf5d4ec0979a3cd7510dece
  PATCH ${PATCH_DIR}/wx31.patch
  DIFF ${REPO}/compare/
  SUBPRO wxcmake31
  )
