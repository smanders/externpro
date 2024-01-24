# azmq
# xpbuild:cmake-patch
xpProOption(azmq DBG)
set(VER 21.12.05)
set(TAG e0058a38976399006f535a9010d29e763b43fcd8) # 2021.12.05 commit
set(REPO https://github.com/zeromq/azmq)
set(FORK https://github.com/smanders/azmq)
set(PRO_AZMQ
  NAME azmq
  WEB "azmq" https://zeromq.org/ "ZeroMQ website"
  LICENSE "open" ${REPO}/blob/master/LICENSE-BOOST_1_0 "Boost Software License 1.0"
  DESC "provides Boost Asio style bindings for ZeroMQ"
  REPO "repo" ${REPO} "zeromq/azmq repo on github"
  GRAPH BUILD_DEPS libzmq boost
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${TAG} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/${TAG}.tar.gz
  DLMD5 814c9b8d8655dda9ef82f6018b8a8384
  DLNAME azmq-${VER}.tar.gz
  PATCH ${PATCH_DIR}/azmq.patch
  DIFF ${FORK}/compare/zeromq:
  )
########################################
function(build_azmq)
  if(NOT (XP_DEFAULT OR XP_PRO_AZMQ))
    return()
  endif()
  xpBuildDeps(depsTgts ${PRO_AZMQ})
  xpGetArgValue(${PRO_AZMQ} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_AZMQ} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_MODULE_PATH=${CMAKE_DIR}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(FIND_DEPS "xpFindPkg(PKGS boost libzmq)\n")
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME})\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depsTgts}" "${XP_CONFIGURE}")
endfunction()
