# boost units
set(VER 1.76.0)
set(REPO https://github.com/boostorg/units)
set(FORK https://github.com/smanders/units)
set(PRO_BOOSTUNITS
  NAME boostunits
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/units
  WEB "units" http://boost.org/libs/units "boost units website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "zero-overhead dimensional analysis and unit/quantity manipulation and conversion"
  REPO "repo" ${REPO} "units repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.units.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF ${FORK}/compare/boostorg:
  )
