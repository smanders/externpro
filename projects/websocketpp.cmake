# WebSocket++
xpProOption(websocketpp)
set(VER 0.7.0)
set(REPO https://github.com/zaphoyd/websocketpp)
set(PRO_WEBSOCKETPP
  NAME websocketpp
  WEB "WebSocket++" https://www.zaphoyd.com/websocketpp/ "WebSocket++ website"
  LICENSE "open" ${REPO}/blob/${VER}/COPYING "BSD"
  DESC "header only C++ library that implements RFC6455 The WebSocket Protocol"
  REPO "repo" ${REPO} "WebSocket++ repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/zaphoyd/websocketpp.git
  GIT_TAG ${VER} # what to 'git checkout'
  DLURL ${REPO}/archive/${VER}.tar.gz
  DLMD5 5027c20cde76fdaef83a74acfcf98e23
  DLNAME websocketpp-${VER}.tar.gz
  )
########################################
function(build_websocketpp)
  if(NOT (XP_DEFAULT OR XP_PRO_WEBSOCKETPP))
    return()
  endif()
  set(XP_CONFIGURE
    -DINSTALL_CMAKE_DIR=${NULL_DIR} # don't want their config.cmake files
    )
  configure_file(${PRO_DIR}/use/usexp-websocketpp-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpBuildOnlyRelease() # this project is only copying headers
  xpCmakeBuild(websocketpp "" "${XP_CONFIGURE}")
endfunction()
