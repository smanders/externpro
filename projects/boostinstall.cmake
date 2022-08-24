# boost install
set(VER 1.76.0)
set(REPO github.com/boostorg/boost_install)
set(FORK github.com/smanders/boost_install)
set(PRO_BOOSTINSTALL
  NAME boostinstall
  SUPERPRO boost
  SUBDIR tools/boost_install
  WEB "boost_install" https://${REPO} "boost_install repo"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "implementation of the boost-install rule"
  REPO "repo" https://${REPO} "boost_install repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.install.patch
  DIFF https://${FORK}/compare/boostorg:
  )
