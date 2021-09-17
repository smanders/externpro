# libssh2
set(VER 1.9.0)
xpProOption(libssh2_${VER} DBG)
set(REPO github.com/libssh2/libssh2)
set(FORK github.com/smanders/libssh2)
set(PRO_LIBSSH2_${VER}
  NAME libssh2_${VER}
  WEB "libssh2" http://www.libssh2.org/ "libssh2 website"
  LICENSE "open" http://www.libssh2.org/license.html "BSD 3-Clause License - https://www.openhub.net/licenses/BSD-3-Clause"
  DESC "client-side C library implementing SSH2 protocol"
  REPO "repo" https://${REPO} "libssh2 repo on github"
  GRAPH BUILD_DEPS zlib openssl_1.1.1l
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp-${VER} # what to 'git checkout'
  GIT_REF libssh2-${VER} # create patch from this tag to 'git checkout'
  DLURL http://www.libssh2.org/download/libssh2-${VER}.tar.gz
  DLMD5 1beefafe8963982adc84b408b2959927
  PATCH ${PATCH_DIR}/libssh2_${VER}.patch
  DIFF https://${FORK}/compare/libssh2:
  DEPS_FUNC build_libssh2
  )
