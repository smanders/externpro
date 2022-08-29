# curl
set(VER 7.80.0)
xpProOption(curl_${VER} DBG)
string(REPLACE "." "_" VER_ ${VER})
set(REPO github.com/curl/curl)
set(FORK github.com/smanders/curl)
set(PRO_CURL_${VER}
  NAME curl_${VER}
  WEB "cURL" http://curl.haxx.se/libcurl/ "libcurl website"
  LICENSE "open" http://curl.haxx.se/docs/copyright.html "curl license: MIT/X derivate license"
  DESC "the multiprotocol file transfer library"
  REPO "repo" https://${REPO} "curl repo on github"
  GRAPH BUILD_DEPS libssh2 cares
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp-${VER_} # what to 'git checkout'
  GIT_REF curl-${VER_} # create patch from this tag to 'git checkout'
  DLURL http://curl.haxx.se/download/curl-${VER}.tar.bz2
  DLMD5 6be3ed3a8069d81dd18e80872bc80ba6
  PATCH ${PATCH_DIR}/curl_${VER}.patch
  DIFF https://${FORK}/compare/curl:
  )
