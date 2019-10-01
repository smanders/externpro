# libssh2
set(VER 1.5.0)
xpProOption(libssh2_${VER} DBG)
set(REPO https://github.com/smanders/libssh2)
set(PRO_LIBSSH2_${VER}
  NAME libssh2_${VER}
  WEB "libssh2" http://www.libssh2.org/ "libssh2 website"
  LICENSE "open" http://www.libssh2.org/license.html "BSD 3-Clause License - https://www.openhub.net/licenses/BSD-3-Clause"
  DESC "client-side C library implementing SSH2 protocol"
  REPO "repo" ${REPO} "forked libssh2 repo on github"
  GRAPH BUILD_DEPS zlib openssl_1.0.2a
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/libssh2.git
  GIT_UPSTREAM git://github.com/libssh2/libssh2.git
  GIT_TAG xp-${VER} # what to 'git checkout'
  GIT_REF libssh2-${VER} # create patch from this tag to 'git checkout'
  DLURL http://www.libssh2.org/download/libssh2-${VER}.tar.gz
  DLMD5 e7fa3f5c6bd2d67a9b360ff726bbc6ba
  PATCH ${PATCH_DIR}/libssh2_${VER}.patch
  DIFF ${REPO}/compare/libssh2:
  DEPS_FUNC build_libssh2
  )
