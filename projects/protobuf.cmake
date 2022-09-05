# protobuf
xpProOption(protobuf DBG)
set(VER 3.21.5)
set(REPO github.com/protocolbuffers/protobuf)
set(FORK github.com/smanders/protobuf)
set(PRO_PROTOBUF
  NAME protobuf
  WEB "protobuf" https://developers.google.com/protocol-buffers/ "Protocol Buffers website"
  LICENSE "open" https://${REPO}/blob/v${VER}/LICENSE "3-clause BSD license"
  DESC "language-neutral, platform-neutral extensible mechanism for serializing structured data"
  REPO "repo" https://${REPO} "protobuf repo on github"
  GRAPH BUILD_DEPS zlib
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH main
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 fc2a640b83143b2c42cf838cf2925934
  DLNAME protobuf-${VER}.tar.gz
  PATCH ${PATCH_DIR}/protobuf.patch
  DIFF https://${FORK}/compare/protocolbuffers:
  )
########################################
function(build_protobuf)
  if(NOT (XP_DEFAULT OR XP_PRO_PROTOBUF))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_PROTOBUF})
  xpGetArgValue(${PRO_PROTOBUF} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_PROTOBUF} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCMAKE_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -Dprotobuf_BUILD_TESTS=OFF # no gmock, unless switch to release tar ball
    )
  set(FIND_DEPS "xpFindPkg(PKGS zlib) # dependencies\n")
  set(TARGETS_FILE tgt-${NAME}/${NAME}-config.cmake)
  configure_file(${PRO_DIR}/use/usexp-${NAME}-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}")
endfunction()
