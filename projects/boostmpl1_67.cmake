# boost mpl
set(VER 1.67.0)
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1_\\2" VER2_ ${VER}) # 1_67
set(REPO github.com/boostorg/mpl)
set(FORK github.com/smanders/mpl)
set(PRO_BOOSTMPL${VER2_}
  NAME boostmpl${VER2_}
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/mpl
  WEB "mpl" http://boost.org/libs/mpl "boost mpl website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "mpl (metaprogramming library)"
  REPO "repo" https://${REPO} "mpl repo on github"
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.mpl.${VER2_}.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/boostorg:
  )
