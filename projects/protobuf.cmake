# protobuf
xpProOption(protobuf DBG)
set(VER 3.13.0)
set(REPO github.com/protocolbuffers/protobuf)
set(FORK github.com/cameronfrandsen/protobuf)
set(PRO_PROTOBUF
  NAME protobuf
  WEB "protobuf" https://developers.google.com/protocol-buffers/ "Protocol Buffers website"
  LICENSE "open" https://${REPO}/blob/v${VER}/LICENSE "3-clause BSD license"
  DESC "language-neutral, platform-neutral extensible mechanism for serializing structured data"
  REPO "repo" https://${REPO} "protobuf repo on github"
  GRAPH BUILD_DEPS zlib
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 1a6274bc4a65b55a6fa70e264d796490
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
  xpGetArgValue(${PRO_PROTOBUF} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-protobuf-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -Dprotobuf_BUILD_TESTS=OFF # we don't have gmock, unless we switch to a release tar ball
    -DZLIB_MODULE_PATH=ON # with this option ON, we don't need -DZLIB=ON
    -DCMAKE_INSTALL_LIBDIR=lib # without this *some* platforms (RHEL, but not Ubuntu) install to lib64
    -DXP_NAMESPACE:STRING=xpro
    -DPROTOBUF_VER=${VER}.0
    -DCMAKE_INSTALL_CMAKEDIR=lib/cmake/protobuf_${VER}
    )
  xpCmakeBuild(protobuf "${depTgts}" "${XP_CONFIGURE}")
endfunction()
