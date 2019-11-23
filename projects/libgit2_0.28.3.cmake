# libgit2
set(VER 0.28.3)
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
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp${VER}
  GIT_REF v${VER}
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 f9f2a2a2da09b4cdb8b1a596eb799179
  DLNAME libgit2-${VER}.tar.gz
  PATCH ${PATCH_DIR}/libgit2_${VER}.patch
  DIFF https://${FORK}/compare/libgit2:
  )
