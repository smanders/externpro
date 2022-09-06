# boost beast
set(VER 1.76.0)
set(REPO github.com/boostorg/beast)
set(FORK github.com/smanders/beast)
set(PRO_BOOSTBEAST
  NAME boostbeast
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/beast
  WEB "beast" http://boost.org/libs/beast "Boost.Beast website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "HTTP and WebSocket built on Boost.Asio in C++11"
  REPO "repo" https://${REPO} "beast repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.beast.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/boostorg:
  )
