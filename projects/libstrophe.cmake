# libstrophe
xpProOption(libstrophe DBG)
set(VER 0.9.1)
set(REPO github.com/strophe/libstrophe)
set(FORK github.com/smanders/libstrophe)
set(PRO_LIBSTROPHE
  NAME libstrophe
  WEB "libstrophe" http://strophe.im/libstrophe/ "libstrophe website"
  LICENSE "open" "https://${REPO}/blob/${VER}/LICENSE.txt" "dual licensed under MIT and GPLv3"
  DESC "A simple, lightweight C library for writing XMPP client"
  REPO "repo" https://${REPO} "libstrophe repo on github"
  GRAPH BUILD_DEPS expat openssl
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${VER} # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/libstrophe.patch
  DIFF https://${FORK}/compare/strophe:
  DLURL https://${REPO}/releases/download/${VER}/libstrophe-${VER}.tar.bz2
  DLMD5 f5475547891fc0697c46ecc004bdfd95
  )
########################################
function(build_libstrophe)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBSTROPHE))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_LIBSTROPHE})
  xpGetArgValue(${PRO_LIBSTROPHE} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_LIBSTROPHE} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(FIND_DEPS "xpFindPkg(PKGS expat openssl) # dependencies\n")
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  set(LIBRARIES xpro::${NAME})
  configure_file(${PRO_DIR}/use/template-lib-tgt.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}")
endfunction()
