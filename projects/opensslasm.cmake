# opensslasm
set(VER 1.1.1l) # openssl version of assembly from node
# NOTE: node version where assembly came from:
# https://github.com/nodejs/node/tree/v14.17.6/deps/openssl/config
set(REPO https://github.com/smanders/opensslasm)
set(PRO_OPENSSLASM
  NAME opensslasm
  SUPERPRO openssl
  SUBDIR asmfromnode
  WEB "opensslasm" ${REPO} "opensslasm project on github"
  LICENSE "open" http://www.openssl.org/source/license.html "OpenSSL, SSLeay License: BSD-style"
  DESC "openssl assembly"
  REPO "repo" ${REPO} "opensslasm repo on github"
  GRAPH
  VER ${VER}
  GIT_ORIGIN ${REPO}
  GIT_TAG asm_${VER} # what to 'git checkout'
  DLURL ${REPO}/archive/asm_${VER}.tar.gz
  DLMD5 f9ad9ef70e25298756fd08b5cf4bcafc
  DLNAME opensslasm-${VER}.tar.gz
  )
