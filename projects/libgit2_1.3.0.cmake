# libgit2
set(VER 1.3.0)
xpProOption(libgit2_${VER} DBG)
set(REPO github.com/libgit2/libgit2)
set(FORK github.com/smanders/libgit2)
set(PRO_LIBGIT2_${VER}
  NAME libgit2_${VER}
  WEB "libgit2" https://libgit2.github.com/ "libgit2 website"
  LICENSE "open" "https://${REPO}/blob/master/README.md#license" "GPL2 with linking exception"
  DESC "portable, pure C implementation of the Git core methods"
  REPO "repo" https://${REPO} "libgit2 repo on github"
  GRAPH BUILD_DEPS libssh2_1.9.0
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH main
  GIT_TAG xp${VER}
  GIT_REF v${VER}
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 c8b6658e421d51f0e1a5fe0c17fc41dc
  DLNAME libgit2-${VER}.tar.gz
  PATCH ${PATCH_DIR}/libgit2_${VER}.patch
  DIFF https://${FORK}/compare/libgit2:
  )
