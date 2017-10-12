# protobuf
xpProOption(protobuf)
set(VER 3.0.0-beta-1)
set(REPO https://github.com/smanders/protobuf)
set(REPO_UPSTREAM https://github.com/google/protobuf)
set(PRO_PROTOBUF
  NAME protobuf
  WEB "protobuf" https://developers.google.com/protocol-buffers/ "Protocol Buffers website"
  LICENSE "open" ${REPO_UPSTREAM}/blob/v${VER}/LICENSE "3-clause BSD license"
  DESC "language-neutral, platform-neutral extensible mechanism for serializing structured data"
  REPO "repo" ${REPO} "forked protobuf repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/protobuf.git
  GIT_UPSTREAM git://github.com/google/protobuf.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO_UPSTREAM}/archive/v${VER}.tar.gz
  DLMD5 63aad3f1814b5c6cd06c7712cd5ba9db
  DLNAME protobuf-${VER}.tar.gz
  PATCH ${PATCH_DIR}/protobuf.patch
  DIFF ${REPO}/compare/google:
  )
########################################
function(build_protobuf)
  if(NOT (XP_DEFAULT OR XP_PRO_PROTOBUF))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_ZLIB))
    message(STATUS "protobuf.cmake: requires zlib")
    set(XP_PRO_ZLIB ON CACHE BOOL "include zlib" FORCE)
    xpPatchProject(${PRO_ZLIB})
  endif()
  build_zlib(zlibTgts)
  xpGetArgValue(${PRO_PROTOBUF} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-protobuf-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -DBUILD_TESTING=OFF # we don't have gmock, unless we switch to a release tar ball
    -DZLIB_MODULE_PATH=ON # with this option ON, we don't need -DZLIB=ON
    -DCMAKE_INSTALL_LIBDIR=lib # without this *some* platforms (RHEL, but not Ubuntu) install to lib64
    -DPROTOBUF_VER=${VER}
    )
  xpCmakeBuild(protobuf "${zlibTgts}" "${XP_CONFIGURE}")
endfunction()
