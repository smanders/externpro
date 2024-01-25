# libzmq
# xpbuild:cmake-patch
xpProOption(libzmq DBG)
set(VER 4.3.4)
set(REPO https://github.com/zeromq/libzmq)
set(FORK https://github.com/externpro/libzmq)
set(PRO_LIBZMQ
  NAME libzmq
  WEB "libzmq" https://zeromq.org/ "ZeroMQ website"
  LICENSE "open" http://wiki.zeromq.org/area:licensing "GNU LGPL plus static linking exception"
  DESC "high-performance asynchronous messaging library"
  REPO "repo" ${REPO} "zeromq/libzmq repo on github"
  GRAPH BUILD_DEPS sodium
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 cc20b769ac10afa352e5ed2769bb23b3
  DLNAME libzmq-${VER}.tar.gz
  PATCH ${PATCH_DIR}/libzmq.patch
  DIFF ${FORK}/compare/zeromq:
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
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_MODULE_PATH=${CMAKE_DIR}
    -DXP_NAMESPACE:STRING=xpro
    -DBUILD_SHARED:BOOL=OFF
    -DENABLE_CPACK:BOOL=OFF
    )
  set(FIND_DEPS "xpFindPkg(PKGS sodium) # dependencies\n")
  set(TARGETS_FILE tgt-${NAME}/ZeroMQTargets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME}-static)\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depsTgts}" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
