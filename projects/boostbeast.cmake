# boost beast
set(VER 1.76.0)
set(REPO https://github.com/boostorg/beast)
set(FORK https://github.com/externpro/beast)
set(PRO_BOOSTBEAST
  NAME boostbeast
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/beast
  WEB "beast" http://boost.org/libs/beast "Boost.Beast website"
  DESC "HTTP and WebSocket built on Boost.Asio in C++11"
  REPO "repo" ${REPO} "beast repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.beast.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF ${FORK}/compare/boostorg:
  )
