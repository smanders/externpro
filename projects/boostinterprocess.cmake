# boost interprocess
set(VER 1.76.0)
set(REPO github.com/boostorg/interprocess)
set(FORK github.com/smanders/interprocess)
set(PRO_BOOSTINTERPROCESS
  NAME boostinterprocess
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/interprocess
  WEB "interprocess" http://boost.org/libs/interprocess "Boost.Interprocess website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "Shared memory, memory mapped files, process-shared mutexes, condition variables, containers and allocators"
  REPO "repo" https://${REPO} "interprocess repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.interprocess.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/boostorg:
  )
