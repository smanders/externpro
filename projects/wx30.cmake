# wx30
xpProOption(wx30)
set(REPO https://github.com/smanders/wxWidgets)
set(VER30 3.0.2)
string(REPLACE "." "_" VER30_ ${VER30})
set(PRO_WX30
  NAME wx30
  WEB "wxWidgets" http://wxwidgets.org/ "wxWidgets website"
  LICENSE "open" http://www.wxwidgets.org/about/newlicen.htm "wxWindows License -- essentially LGPL with an exception stating that derived works in binary form may be distributed on the user's own terms"
  DESC "Cross-Platform GUI Library"
  REPO "repo" ${REPO} "forked wxWidgets repo on github"
  VER ${VER30}
  GIT_ORIGIN git://github.com/smanders/wxWidgets.git
  GIT_UPSTREAM git://github.com/wxWidgets/wxWidgets.git
  GIT_TAG xp${VER30} # what to 'git checkout'
  GIT_REF WX_${VER30_}_pkg # patch from REF to TAG
  DLURL http://downloads.sourceforge.net/project/wxwindows/${VER30}/wxWidgets-${VER30}.tar.bz2
  DLMD5 ba4cd1f3853d0cd49134c5ae028ad080
  PATCH ${PATCH_DIR}/wx30.patch
  DIFF ${REPO}/compare/
  SUBPRO wxcmake30
  )
