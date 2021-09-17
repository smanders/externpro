# openssl
set(BRANCH 1.1.1)
set(VER ${BRANCH}l)
xpProOption(openssl_${VER} DBG)
string(REPLACE "." "_" VER_ ${VER})
string(TOUPPER ${VER} VER_UC)
set(REPO github.com/openssl/openssl)
set(FORK github.com/smanders/openssl)
set(PRO_OPENSSL_${VER_UC}
  NAME openssl_${VER}
  WEB "OpenSSL" http://www.openssl.org/ "OpenSSL website"
  LICENSE "open" http://www.openssl.org/source/license.html "OpenSSL, SSLeay License: BSD-style"
  DESC "Cryptography and SSL/TLS Toolkit"
  REPO "repo" https://${REPO} "openssl repo on github"
  GRAPH BUILD_DEPS opensslasm nasm
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp_${VER_} # what to 'git checkout'
  GIT_REF OpenSSL_${VER_} # create patch from this tag to 'git checkout'
  #DLURL https://www.openssl.org/source/old/${BRANCH}/openssl-${VER}.tar.gz
  DLURL https://www.openssl.org/source/openssl-${VER}.tar.gz
  DLMD5 ac0d4387f3ba0ad741b0580dd45f6ff3
  PATCH ${PATCH_DIR}/openssl_${VER}.patch
  DIFF https://${FORK}/compare/openssl:
  DEPS_FUNC build_openssl
  SUBPRO opensslasm
  )
