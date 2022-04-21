# boost regex
set(VER 1.76.0)
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1_\\2" VER2_ ${VER}) # 1_76
set(REPO github.com/boostorg/regex)
set(FORK github.com/smanders/regex)
set(PRO_BOOSTREGEX${VER2_}
  NAME boostregex${VER2_}
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/regex
  WEB "regex" http://boost.org/libs/regex "boost regex website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "Regular expression library"
  REPO "repo" https://${REPO} "regex repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.regex.${VER2_}.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/boostorg:
  )
