# wxcmake
set(REPO github.com/smanders/wxcmake)
set(PRO_WXCMAKE
  NAME wxcmake
  SUPERPRO wxWidgets
  SUBDIR build/cmake
  WEB "wxcmake" https://${REPO} "wxcmake project on github"
  LICENSE "open" http://www.wxwidgets.org/about/newlicen.htm "wxWindows License -- essentially LGPL with an exception stating that derived works in binary form may be distributed on the user's own terms"
  DESC "build wxWidgets via cmake"
  REPO "repo" https://${REPO} "wxcmake repo on github"
  VER 2019.11.08 # latest wx31 branch commit date
  GIT_ORIGIN https://${REPO}.git
  GIT_TAG wx31 # what to 'git checkout'
  GIT_REF wx0 # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/wxcmake.patch
  DIFF https://${REPO}/compare/
  )
