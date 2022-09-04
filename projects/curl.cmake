# curl
set(VER 7.80.0)
xpProOption(curl DBG)
string(REPLACE "." "_" VER_ ${VER})
set(REPO github.com/curl/curl)
set(FORK github.com/smanders/curl)
set(PRO_CURL
  NAME curl
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
  PATCH ${PATCH_DIR}/curl.patch
  DIFF https://${FORK}/compare/curl:
  )
########################################
function(build_curl)
  if(NOT (XP_DEFAULT OR XP_PRO_CURL))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_CURL})
  xpGetArgValue(${PRO_CURL} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_CURL} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DBUILD_CURL_EXE=ON
    -DBUILD_SHARED_LIBS=OFF
    -DBUILD_TESTING=OFF
    -DENABLE_ARES=ON
    -DCMAKE_USE_OPENSSL=ON
    -DCURL_DISABLE_LDAP=ON
    -DUSE_LIBIDN2=OFF
    )
  set(FIND_DEPS "xpFindPkg(PKGS libssh2 cares) # dependencies\n")
  set(TARGETS_FILE tgt-${NAME}/CURLTargets.cmake)
  set(EXECUTABLE xpro::${NAME})
  set(LIBRARIES xpro::lib${NAME})
  configure_file(${PRO_DIR}/use/template-exe-lib-tgt.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}")
endfunction()
