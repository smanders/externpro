# opensslasm
set(VER 10.17.0) # NOTE: matches node version assembly came from
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
  DLMD5 ef6694b85edd07ec20125b662f197e7d
  DLNAME opensslasm-${VER}.tar.gz
  )
