# openssl
xpProOption(openssl DBG)
set(BRANCH 1.0.2)
set(VER ${BRANCH}a)
string(REPLACE "." "_" VER_ ${VER})
set(REPO https://github.com/smanders/openssl)
set(PRO_OPENSSL
  NAME openssl
  WEB "OpenSSL" http://www.openssl.org/ "OpenSSL website"
  LICENSE "open" http://www.openssl.org/source/license.html "OpenSSL, SSLeay License: BSD-style"
  DESC "Cryptography and SSL/TLS Toolkit"
  REPO "repo" ${REPO} "forked openssl repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/openssl.git
  GIT_UPSTREAM git://github.com/openssl/openssl.git
  GIT_TAG xp_${VER_} # what to 'git checkout'
  GIT_REF OpenSSL_${VER_} # create patch from this tag to 'git checkout'
  # NOTE: warnings extracting tar.gz from openssl.org on Windows
  # cmake -E tar : warning : skipping symbolic link
  DLURL https://www.openssl.org/source/old/${BRANCH}/openssl-${VER}.tar.gz
  DLMD5 a06c547dac9044161a477211049f60ef
  PATCH ${PATCH_DIR}/openssl.patch
  DIFF ${REPO}/compare/openssl:
  )
########################################
function(build_openssl)
  if(NOT (XP_DEFAULT OR XP_PRO_OPENSSL))
    return()
  endif()
  xpGetArgValue(${PRO_OPENSSL} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-openssl-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(openssl "" "-DOPENSSL_VER=${VER}" opensslTargets)
  if(ARGN)
    set(${ARGN} "${opensslTargets}" PARENT_SCOPE)
  endif()
endfunction()
