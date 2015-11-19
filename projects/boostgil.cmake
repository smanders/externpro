########################################
# boost gil
set(VER 1.57.0)
set(REPO https://github.com/smanders/gil)
set(PRO_BOOSTGIL
  NAME boostgil
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/gil
  WEB "gil" http://boost.org/libs/gil "boost gil website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "gil (generic image library)"
  REPO "repo" ${REPO} "forked gil repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/gil.git
  GIT_UPSTREAM git://github.com/boostorg/gil.git
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.gil.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF ${REPO}/compare/boostorg:
  )
########################################
function(mkpatch_boostgil)
  xpRepo(${PRO_BOOSTGIL})
endfunction()
########################################
function(patch_boostgil)
  patch_boost()
  xpPatch(${PRO_BOOSTGIL})
endfunction()
