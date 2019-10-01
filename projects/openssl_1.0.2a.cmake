# openssl
set(BRANCH 1.0.2)
set(VER ${BRANCH}a)
xpProOption(openssl_${VER} DBG)
string(REPLACE "." "_" VER_ ${VER})
string(TOUPPER ${VER} VER_UC)
set(REPO https://github.com/smanders/openssl)
set(PRO_OPENSSL_${VER_UC}
  NAME openssl_${VER}
  WEB "OpenSSL" http://www.openssl.org/ "OpenSSL website"
  LICENSE "open" http://www.openssl.org/source/license.html "OpenSSL, SSLeay License: BSD-style"
  DESC "Cryptography and SSL/TLS Toolkit"
  REPO "repo" ${REPO} "forked openssl repo on github"
  GRAPH
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/openssl.git
  GIT_UPSTREAM git://github.com/openssl/openssl.git
  GIT_TAG xp_${VER_} # what to 'git checkout'
  GIT_REF OpenSSL_${VER_} # create patch from this tag to 'git checkout'
  # NOTE: warnings extracting tar.gz from openssl.org on Windows
  # cmake -E tar : warning : skipping symbolic link
  DLURL https://www.openssl.org/source/old/${BRANCH}/openssl-${VER}.tar.gz
  DLMD5 a06c547dac9044161a477211049f60ef
  PATCH ${PATCH_DIR}/openssl_${VER}.patch
  DIFF ${REPO}/compare/openssl:
  DEPS_FUNC build_openssl
  )
