# boost install
set(VER 1.76.0)
set(REPO https://github.com/boostorg/boost_install)
set(FORK https://github.com/smanders/boost_install)
set(PRO_BOOSTINSTALL
  NAME boostinstall
  SUPERPRO boost
  SUBDIR tools/boost_install
  WEB "boost_install" ${REPO} "boost_install repo"
  DESC "implementation of the boost-install rule"
  REPO "repo" ${REPO} "boost_install repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.install.patch
  DIFF ${FORK}/compare/boostorg:
  )
