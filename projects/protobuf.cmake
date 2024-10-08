# protobuf
# xpbuild:cmake-patch
xpProOption(protobuf DBG)
set(VER 3.14.0)
set(REPO https://github.com/protocolbuffers/protobuf)
set(FORK https://github.com/externpro/protobuf)
set(PRO_PROTOBUF
  NAME protobuf
  WEB "protobuf" https://developers.google.com/protocol-buffers/ "Protocol Buffers website"
  LICENSE "open" ${REPO}/blob/v${VER}/LICENSE "3-clause BSD license"
  DESC "language-neutral, platform-neutral extensible mechanism for serializing structured data"
  REPO "repo" ${REPO} "protobuf repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TRACKING_BRANCH main
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 0c9d2a96f3656ba7ef3b23b533fb6170
  DLNAME protobuf-${VER}.tar.gz
  PATCH ${PATCH_DIR}/protobuf.patch
  DIFF ${FORK}/compare/protocolbuffers:
  )
########################################
function(build_protobuf)
  if(NOT (XP_DEFAULT OR XP_PRO_PROTOBUF))
    return()
  endif()
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
  set(FIND_DEPS "${FIND_DEPS}set(FPHSA_NAME_MISMATCHED TRUE)")
  set(FIND_DEPS "${FIND_DEPS} # FIND_PACKAGE_HANDLE_STANDARD_ARGS NAME_MISMATCHED\n")
  set(FIND_DEPS "${FIND_DEPS}set(protobuf_MODULE_COMPATIBLE ON)")
  set(FIND_DEPS "${FIND_DEPS} # necessary for GENERATE_PROTOBUF_CPP\n")
  set(TARGETS_FILE tgt-${NAME}/${NAME}-config.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::libprotobuf)\n")
  set(USE_VARS "${USE_VARS}set(${PRJ}_PROTOC_EXECUTABLE xpro::protoc)")
  set(USE_VARS "${USE_VARS} # TRICKY: match name in -module.cmake\n")
  set(USE_VARS "${USE_VARS}get_target_property(${PRJ}_INCLUDE_DIR xpro::libprotobuf INTERFACE_INCLUDE_DIRECTORIES)\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_PROTOC_EXECUTABLE)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
endfunction()
