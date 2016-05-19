set(REPO https://github.com/smanders/wxcmake)
set(PRO_WXCMAKE30
  NAME wxcmake30
  SUPERPRO wx30
  SUBDIR build/cmake
  WEB "wxcmake" ${REPO} "wxcmake project on github"
  LICENSE "open" http://www.wxwidgets.org/about/newlicen.htm "wxWindows License -- essentially LGPL with an exception stating that derived works in binary form may be distributed on the user's own terms"
  DESC "build wxWidgets via cmake"
  REPO "repo" ${REPO} "wxcmake repo on github"
  VER 2015.10.02 # latest wx30 branch commit date
  GIT_ORIGIN git://github.com/smanders/wxcmake.git
  GIT_TAG wx30 # what to 'git checkout'
  GIT_REF wx0 # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/wxcmake30.patch
  DIFF ${REPO}/compare/
  )
