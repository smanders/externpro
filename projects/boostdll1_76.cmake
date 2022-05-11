# boost dll
set(VER 1.76.0)
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1_\\2" VER2_ ${VER}) # 1_76
set(REPO github.com/boostorg/dll)
set(FORK github.com/smanders/dll)
set(PRO_BOOSTDLL${VER2_}
  NAME boostdll${VER2_}
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
  PATCH ${PATCH_DIR}/boost.dll.${VER2_}.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/boostorg:
  )
