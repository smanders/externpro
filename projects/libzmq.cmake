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
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
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
  xpGetArgValue(${PRO_LIBZMQ} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-libzmq-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_LIBDIR=lib # without this *some* platforms (RHEL, but not Ubuntu) install to lib64
    -DCMAKE_INSTALL_INCLUDEDIR=include/libzmq_${VER}
    -DZEROMQ_CMAKECONFIG_INSTALL_DIR=lib/cmake/ZeroMQ_${VER}
    -DBUILD_SHARED:BOOL=OFF
    -DENABLE_CPACK:BOOL=OFF
    -DINSTALL_PKGCONFIG:BOOL=OFF
    -DLIBZMQ_VER=${VER}
    -DXP_NAMESPACE:STRING=xpro
    )
  xpCmakeBuild(libzmq "${depsTgts}" "${XP_CONFIGURE}" zmqTargets)
  if(ARGN)
    set(${ARGN} "${zmqTargets}" PARENT_SCOPE)
  endif()
endfunction()
