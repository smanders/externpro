# boost dll
set(VER 1.76.0)
set(REPO github.com/boostorg/dll)
set(FORK github.com/smanders/dll)
set(PRO_BOOSTDLL
  NAME boostdll
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/dll
  WEB "dll" http://boost.org/libs/dll "Boost.DLL website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "library for comfortable work with DLL and DSO"
  REPO "repo" https://${REPO} "dll repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.dll.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/boostorg:
  )
