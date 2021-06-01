# opensslasm
set(VER 1.1.1k) # openssl version of assembly from node
# NOTE: node version where assembly came from:
# https://github.com/nodejs/node/tree/v14.17.0/deps/openssl/config
set(REPO github.com/smanders/opensslasm)
set(PRO_OPENSSLASM
  NAME opensslasm
  SUPERPRO openssl
  SUBDIR asmfromnode
  WEB "opensslasm" https://${REPO} "opensslasm project on github"
  LICENSE "open" http://www.openssl.org/source/license.html "OpenSSL, SSLeay License: BSD-style"
  DESC "openssl assembly"
  REPO "repo" https://${REPO} "opensslasm repo on github"
  GRAPH
  VER ${VER}
  GIT_ORIGIN git://${REPO}.git
  GIT_TAG asm_${VER} # what to 'git checkout'
  DLURL https://${REPO}/archive/asm_${VER}.tar.gz
  DLMD5 a2ee4b8222319d4fdac38dac03d36319
  DLNAME opensslasm-${VER}.tar.gz
  )
