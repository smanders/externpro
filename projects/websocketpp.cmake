# WebSocket++
xpProOption(websocketpp)
set(VER 0.7.0)
set(REPO https://github.com/smanders/websocketpp)
set(PRO_WEBSOCKETPP
  NAME websocketpp
  WEB "WebSocket++" https://www.zaphoyd.com/websocketpp/ "WebSocket++ website"
  LICENSE "open" ${REPO}/blob/${VER}/COPYING "BSD"
  DESC "header only C++ library that implements RFC6455 The WebSocket Protocol"
  REPO "repo" ${REPO} "forked WebSocket++ repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/websocketpp.git
  GIT_UPSTREAM git://github.com/zaphoyd/websocketpp.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/${VER}.tar.gz
  DLMD5 5027c20cde76fdaef83a74acfcf98e23
  DLNAME websocketpp-${VER}.tar.gz
  PATCH ${PATCH_DIR}/websocketpp.patch
  DIFF ${REPO}/compare/zaphoyd:
  )
########################################
function(build_websocketpp)
  if(NOT (XP_DEFAULT OR XP_PRO_WEBSOCKETPP))
    return()
  endif()
  xpGetArgValue(${PRO_WEBSOCKETPP} ARG VER VALUE VER)
  set(verDir /websocketpp_${VER})
  set(XP_CONFIGURE
    -DINSTALL_CMAKE_DIR=${NULL_DIR} # don't want their config.cmake files
    -DverDir=${verDir}
    )
  configure_file(${PRO_DIR}/use/usexp-websocketpp-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpBuildOnlyRelease() # this project is only copying headers
  xpCmakeBuild(websocketpp "" "${XP_CONFIGURE}")
endfunction()
