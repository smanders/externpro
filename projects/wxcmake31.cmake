# wxcmake31
set(REPO https://github.com/smanders/wxcmake)
set(PRO_WXCMAKE31
  NAME wxcmake31
  SUPERPRO wxWidgets31
  SUBDIR build/cmake
  WEB "wxcmake" ${REPO} "wxcmake project on github"
  LICENSE "open" http://www.wxwidgets.org/about/newlicen.htm "wxWindows License -- essentially LGPL with an exception stating that derived works in binary form may be distributed on the user's own terms"
  DESC "build wxWidgets via cmake"
  REPO "repo" ${REPO} "wxcmake repo on github"
  VER 2019.11.08 # latest wx31 branch commit date
  GIT_ORIGIN git://github.com/smanders/wxcmake.git
  GIT_TAG wx31 # what to 'git checkout'
  GIT_REF wx0 # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/wxcmake31.patch
  DIFF ${REPO}/compare/
  )
