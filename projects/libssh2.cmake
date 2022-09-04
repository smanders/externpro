# libssh2
set(VER 1.9.0)
xpProOption(libssh2 DBG)
set(REPO github.com/libssh2/libssh2)
set(FORK github.com/smanders/libssh2)
set(PRO_LIBSSH2
  NAME libssh2
  WEB "libssh2" http://www.libssh2.org/ "libssh2 website"
  LICENSE "open" http://www.libssh2.org/license.html "BSD 3-Clause License - https://www.openhub.net/licenses/BSD-3-Clause"
  DESC "client-side C library implementing SSH2 protocol"
  REPO "repo" https://${REPO} "libssh2 repo on github"
  GRAPH BUILD_DEPS zlib openssl
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp-${VER} # what to 'git checkout'
  GIT_REF libssh2-${VER} # create patch from this tag to 'git checkout'
  DLURL http://www.libssh2.org/download/libssh2-${VER}.tar.gz
  DLMD5 1beefafe8963982adc84b408b2959927
  PATCH ${PATCH_DIR}/libssh2.patch
  DIFF https://${FORK}/compare/libssh2:
  DEPS_FUNC build_libssh2
  )
########################################
function(build_libssh2)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBSSH2))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_LIBSSH2})
  xpGetArgValue(${PRO_LIBSSH2} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_LIBSSH2} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DCRYPTO_BACKEND:STRING=OpenSSL
    -DENABLE_ZLIB_COMPRESSION=ON
    )
  set(FIND_DEPS "xpFindPkg(PKGS zlib openssl) # dependencies\n")
  set(TARGETS_FILE tgt-${NAME}/Libssh2Config.cmake)
  set(LIBRARIES xpro::${NAME})
  configure_file(${PRO_DIR}/use/template-lib-tgt.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
