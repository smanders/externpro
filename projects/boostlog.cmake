########################################
# boost log
set(VER 1.57.0)
set(REPO https://github.com/smanders/log)
set(PRO_BOOSTLOG
  NAME boostlog
  SUPERPRO boost
  SUBDIR libs/log
  WEB "log" http://boost.org/libs/log "boost log website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "logging library"
  REPO "repo" ${REPO} "forked log repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/log.git
  GIT_UPSTREAM git://github.com/boostorg/log.git
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.log.patch
  DIFF ${REPO}/compare/boostorg:
  )
########################################
function(mkpatch_boostlog)
  xpRepo(${PRO_BOOSTLOG})
endfunction()
########################################
function(patch_boostlog)
  patch_boost()
  xpPatch(${PRO_BOOSTLOG})
endfunction()
