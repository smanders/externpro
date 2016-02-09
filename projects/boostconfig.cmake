########################################
# boost config
set(VER 1.57.0)
set(REPO https://github.com/smanders/config)
set(PRO_BOOSTCONFIG
  NAME boostconfig
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/config
  WEB "config" http://boost.org/libs/config "boost config website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "config helps Boost library developers adapt to compiler idiosyncrasies"
  REPO "repo" ${REPO} "forked config repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/config.git
  GIT_UPSTREAM git://github.com/boostorg/config.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.config.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF ${REPO}/compare/boostorg:
  )
########################################
function(mkpatch_boostconfig)
  xpRepo(${PRO_BOOSTCONFIG})
endfunction()
########################################
function(patch_boostconfig)
  patch_boost()
  xpPatch(${PRO_BOOSTCONFIG})
endfunction()
