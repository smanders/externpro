# wxcmake
set(REPO https://github.com/externpro/wxcmake)
set(PRO_WXCMAKE
  NAME wxcmake
  SUPERPRO wxWidgets
  SUBDIR build/cmake
  WEB "wxcmake" ${REPO} "wxcmake project on github"
  DESC "build wxWidgets via cmake"
  REPO "repo" ${REPO} "wxcmake repo on github"
  VER 2019.11.08 # latest wx31 branch commit date
  GIT_ORIGIN ${REPO}
  GIT_TAG wx31 # what to 'git checkout'
  GIT_REF wx0 # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/wxcmake.patch
  DIFF ${REPO}/compare/
  )
