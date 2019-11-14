# libstrophe
xpProOption(libstrophe DBG)
set(VER 0.9.1)
set(REPO https://github.com/strophe/libstrophe)
set(FORK https://github.com/smanders/libstrophe)
set(PRO_LIBSTROPHE
  NAME libstrophe
  WEB "libstrophe" http://strophe.im/libstrophe/ "libstrophe website"
  LICENSE "open" "${REPO}/blob/${VER}/LICENSE.txt" "dual licensed under MIT and GPLv3"
  DESC "A simple, lightweight C library for writing XMPP client"
  REPO "repo" ${REPO} "libstrophe repo on github"
  GRAPH BUILD_DEPS expat openssl_1.1.1d
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
  if(FALSE)
    # build multiple versions against different versions of openssl
    set(MOD_OLD _ossl10)
    set(MOD_NEW _ossl11)
    set(MOD_OPT "if(XP_USE_LATEST_OPENSSL)\n  set(VER_MOD ${MOD_NEW})\nelse()\n  set(VER_MOD ${MOD_OLD})\nendif()")
    set(VER_CFG ${MOD_OLD} ${MOD_NEW})
  elseif(FALSE)
    # build against single version of openssl
    set(MOD_NEW _ossl11)
    set(MOD_OPT "set(VER_MOD ${MOD_NEW})")
    set(VER_CFG ${MOD_NEW})
  else()
    set(MOD_OPT "set(VER_MOD)")
    set(VER_CFG xpConfigBase)
  endif()
  set(USE_SCRIPT_INSERT ${MOD_OPT})
  xpGetArgValue(${PRO_LIBSTROPHE} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-libstrophe-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpBuildDeps(depTgts ${PRO_LIBSTROPHE})
  set(xpConfigBase
    -DLIBSTROPHE_VER=${VER}
    -DCMAKE_USE_OPENSSL_MODULE_PATH=ON
    -DCMAKE_USE_EXPAT_MODULE_PATH=ON
    )
  set(${MOD_OLD} ${xpConfigBase}
    -DVER_MOD:STRING=${MOD_OLD}
    -DXP_USE_LATEST_OPENSSL:BOOL=OFF
    )
  set(${MOD_NEW} ${xpConfigBase}
    -DVER_MOD:STRING=${MOD_NEW}
    -DXP_USE_LATEST_OPENSSL:BOOL=ON
    )
  foreach(cfg ${VER_CFG})
    build_libstrophe_cfg(${cfg})
  endforeach()
endfunction()
function(build_libstrophe_cfg cfg)
  if(${cfg} STREQUAL xpConfigBase)
    xpCmakeBuild(libstrophe "${depTgts}" "${${cfg}}")
  else()
    xpCmakeBuild(libstrophe "${depTgts}" "${${cfg}}" "" TGT ${cfg})
  endif()
endfunction()
