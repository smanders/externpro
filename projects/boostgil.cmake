# boost gil
set(VER 1.76.0)
set(REPO https://github.com/boostorg/gil)
set(FORK https://github.com/externpro/gil)
set(PRO_BOOSTGIL
  NAME boostgil
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/gil
  WEB "gil" http://boost.org/libs/gil "boost gil website"
  DESC "gil (generic image library)"
  REPO "repo" ${REPO} "gil repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.gil.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF ${FORK}/compare/boostorg:
  )
