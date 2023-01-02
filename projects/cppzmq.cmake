# cppzmq
# xpbuild:cmake-patch
xpProOption(cppzmq DBG)
set(VER 4.7.1)
set(REPO github.com/zeromq/cppzmq)
set(FORK github.com/smanders/cppzmq)
set(PRO_CPPZMQ
  NAME cppzmq
  WEB "cppzmq" https://zeromq.org/ "ZeroMQ website"
  LICENSE "open" http://wiki.zeromq.org/area:licensing "GNU LGPL plus static linking exception"
  DESC "header-only C++ binding for libzmq"
  REPO "repo" https://${REPO} "zeromq/cppzmq repo on github"
  GRAPH BUILD_DEPS libzmq
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 e85cf23b5aed263c2c5c89657737d107
  DLNAME cppzmq-${VER}.tar.gz
  PATCH ${PATCH_DIR}/cppzmq.patch
  DIFF https://${FORK}/compare/zeromq:
  )
########################################
function(build_cppzmq)
  if(NOT (XP_DEFAULT OR XP_PRO_CPPZMQ))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_CPPZMQ})
  xpGetArgValue(${PRO_CPPZMQ} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_CPPZMQ} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DCPPZMQ_BUILD_TESTS:BOOL=OFF
    )
  set(FIND_DEPS "xpFindPkg(PKGS libzmq)\n")
  set(TARGETS_FILE tgt-${NAME}/${NAME}Targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME}-static)\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}")
endfunction()
