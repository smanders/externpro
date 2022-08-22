# libzmq
xpProOption(libzmq DBG)
set(VER 4.3.4)
set(REPO github.com/zeromq/libzmq)
set(FORK github.com/smanders/libzmq)
set(PRO_LIBZMQ
  NAME libzmq
  WEB "libzmq" https://zeromq.org/ "ZeroMQ website"
  LICENSE "open" http://wiki.zeromq.org/area:licensing "GNU LGPL plus static linking exception"
  DESC "high-performance asynchronous messaging library"
  REPO "repo" https://${REPO} "zeromq/libzmq repo on github"
  GRAPH BUILD_DEPS sodium
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 cc20b769ac10afa352e5ed2769bb23b3
  DLNAME libzmq-${VER}.tar.gz
  PATCH ${PATCH_DIR}/libzmq.patch
  DIFF https://${FORK}/compare/zeromq:
  DEPS_FUNC build_libzmq
  )
########################################
function(build_libzmq)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBZMQ))
    return()
  endif()
  xpBuildDeps(depsTgts ${PRO_LIBZMQ})
  xpGetArgValue(${PRO_LIBZMQ} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_LIBZMQ} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKECFGDIR=lib/cmake/ZeroMQ
    -DXP_INSTALL_PKGCONFIG:BOOL=OFF
    -DXP_NAMESPACE:STRING=xpro
    -DBUILD_SHARED:BOOL=OFF
    -DENABLE_CPACK:BOOL=OFF
    )
  set(FIND_DEPS "xpFindPkg(PKGS sodium) # dependencies\n")
  set(TARGETS_FILE lib/cmake/ZeroMQ/ZeroMQTargets.cmake)
  set(LIBRARIES xpro::${NAME}-static)
  configure_file(${PRO_DIR}/use/usexp-template-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(libzmq "${depsTgts}" "${XP_CONFIGURE}" zmqTargets)
  if(ARGN)
    set(${ARGN} "${zmqTargets}" PARENT_SCOPE)
  endif()
endfunction()
