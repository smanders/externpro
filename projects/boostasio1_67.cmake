# boost asio
set(VER 1.67.0)
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1_\\2" VER2_ ${VER}) # 1_67
set(REPO github.com/boostorg/asio)
set(FORK github.com/smanders/asio)
set(PRO_BOOSTASIO${VER2_}
  NAME boostasio${VER2_}
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/asio
  WEB "asio" http://boost.org/libs/asio "boost asio website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "cross-platform C++ library for network and low-level I/O programming that provides developers with a consistent asynchronous model using a modern C++ approach"
  REPO "repo" https://${REPO} "asio repo on github"
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.asio.${VER2_}.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/boostorg:
  )
