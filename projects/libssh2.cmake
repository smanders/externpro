########################################
# libssh2
xpProOption(libssh2)
set(VER 1.5.0)
set(REPO https://github.com/smanders/libssh2)
set(PRO_LIBSSH2
  NAME libssh2
  WEB "libssh2" http://www.libssh2.org/ "libssh2 website"
  LICENSE "open" http://www.libssh2.org/license.html "BSD 3-Clause License - https://www.openhub.net/licenses/BSD-3-Clause"
  DESC "client-side C library implementing SSH2 protocol"
  REPO "repo" ${REPO} "forked libssh2 repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/libssh2.git
  GIT_UPSTREAM git://github.com/libssh2/libssh2.git
  GIT_TAG xp-${VER} # what to 'git checkout'
  GIT_REF libssh2-${VER} # create patch from this tag to 'git checkout'
  DLURL http://www.libssh2.org/download/libssh2-${VER}.tar.gz
  DLMD5 e7fa3f5c6bd2d67a9b360ff726bbc6ba
  PATCH ${PATCH_DIR}/libssh2.patch
  DIFF ${REPO}/compare/libssh2:
  )
########################################
function(mkpatch_libssh2)
  xpRepo(${PRO_LIBSSH2})
endfunction()
########################################
function(download_libssh2)
  xpNewDownload(${PRO_LIBSSH2})
endfunction()
########################################
function(patch_libssh2)
  xpPatch(${PRO_LIBSSH2})
endfunction()
########################################
function(build_libssh2)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBSSH2))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_OPENSSL))
    message(FATAL_ERROR "libssh2.cmake: requires openssl")
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_ZLIB))
    message(FATAL_ERROR "libssh2.cmake: requires zlib")
    return()
  endif()
  if(NOT DEFINED osslTgts)
    build_openssl(osslTgts)
    set(depTgts ${osslTgts})
  endif()
  if(NOT DEFINED zlibTgts)
    build_zlib(zlibTgts)
    list(APPEND depTgts ${zlibTgts})
  endif()
  configure_file(${PRO_DIR}/use/usexp-libssh2-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -DCRYPTO_BACKEND:STRING=OpenSSL
    -DFIND_OPENSSL_MODULE_PATH=ON
    -DCMAKE_USE_ZLIB_MODULE_PATH=ON
    )
  xpCmakeBuild(libssh2 "${depTgts}" "${XP_CONFIGURE}" libssh2Targets)
  if(ARGN)
    set(${ARGN} "${libssh2Targets}" PARENT_SCOPE)
  endif()
endfunction()
