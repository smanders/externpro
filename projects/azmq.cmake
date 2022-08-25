# azmq
xpProOption(azmq DBG)
set(VER 21.06.02)
set(TAG fc6b42acaaeaa65692e031d796a02011d2924713) # 2021.06.02 commit, head of master branch
set(REPO github.com/zeromq/azmq)
set(FORK github.com/smanders/azmq)
set(PRO_AZMQ
  NAME azmq
  WEB "azmq" https://zeromq.org/ "ZeroMQ website"
  LICENSE "open" https://${REPO}/blob/master/LICENSE-BOOST_1_0 "Boost Software License 1.0"
  DESC "provides Boost Asio style bindings for ZeroMQ"
  REPO "repo" https://${REPO} "zeromq/azmq repo on github"
  GRAPH BUILD_DEPS libzmq boost
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${TAG} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/${TAG}.tar.gz
  DLMD5 d3b3d48168a53d03c08be59bdc596709
  DLNAME azmq-${VER}.tar.gz
  PATCH ${PATCH_DIR}/azmq.patch
  DIFF https://${FORK}/compare/zeromq:
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
    -DXP_NAMESPACE:STRING=xpro
    )
  set(FIND_DEPS "xpFindPkg(PKGS boost libzmq)\n")
  set(TARGETS_FILE lib/cmake/${NAME}-targets.cmake)
  set(LIBRARIES xpro::azmq)
  configure_file(${PRO_DIR}/use/usexp-template-lib-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-azmq-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(azmq "${depsTgts}" "${XP_CONFIGURE}")
endfunction()
