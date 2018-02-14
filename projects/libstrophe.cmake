# libstrophe
xpProOption(libstrophe)
set(VER 0.9.1)
set(REPO https://github.com/strophe/libstrophe)
set(FORK https://github.com/smanders/libstrophe)
set(PRO_LIBSTROPHE
  NAME libstrophe
  WEB "libstrophe" http://strophe.im/libstrophe/ "libstrophe website"
  LICENSE "open" "${REPO}/blob/${VER}/LICENSE.txt" "dual licensed under MIT and GPLv3"
  DESC "A simple, lightweight C library for writing XMPP client"
  REPO "repo" ${REPO} "libstrophe repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/libstrophe.git
  GIT_UPSTREAM git://github.com/strophe/libstrophe.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${VER} # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/libstrophe_${VER}.patch
  DIFF ${FORK}/compare/strophe:
  DLURL ${REPO}/releases/download/${VER}/libstrophe-${VER}.tar.bz2
  DLMD5 f5475547891fc0697c46ecc004bdfd95
  )
########################################
function(build_libstrophe)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBSTROPHE))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_EXPAT))
    message(STATUS "libstrophe: requires expat")
    set(XP_PRO_EXPAT ON CACHE BOOL "include expat" FORCE)
    xpPatchProject(${PRO_EXPAT})
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_OPENSSL))
    message(STATUS "libstrophe: requires openssl")
    set(XP_PRO_OPENSSL ON CACHE BOOL "include openssl" FORCE)
    xpPatchProject(${PRO_OPENSSL})
  endif()
  build_expat(expatTgts)
  build_openssl(osslTgts)
  set(depTgts ${expatTgts} ${osslTgts})
  xpGetArgValue(${PRO_LIBSTROPHE} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-libstrophe-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -DLIBSTROPHE_VER=${VER}
    -DCMAKE_USE_OPENSSL_MODULE_PATH=ON
    -DCMAKE_USE_EXPAT_MODULE_PATH=ON
    )
  xpCmakeBuild(libstrophe "${depTgts}" "${XP_CONFIGURE}")
endfunction()
