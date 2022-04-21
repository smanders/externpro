# flatbuffers
xpProOption(flatbuffers DBG)
set(VER 2.0.6)
set(REPO github.com/google/flatbuffers)
set(FORK github.com/smanders/flatbuffers)
set(PRO_FLATBUFFERS
  NAME flatbuffers
  WEB "flatbuffers" http://google.github.io/flatbuffers/ "FlatBuffers website"
  LICENSE "open" https://${REPO}/blob/v${VER}/LICENSE.txt "Apache license, v2"
  DESC "efficient cross platform serialization library"
  REPO "repo" https://${REPO} "flatbuffers repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 231d9070d4b58ed91da539815543e07f
  DLNAME flatbuffers-${VER}.tar.gz
  PATCH ${PATCH_DIR}/flatbuffers.patch
  DIFF https://${FORK}/compare/google:
  )
########################################
function(build_flatbuffers)
  if(NOT (XP_DEFAULT OR XP_PRO_FLATBUFFERS))
    return()
  endif()
  xpGetArgValue(${PRO_FLATBUFFERS} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-flatbuffers-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_LIBDIR=lib # without this *some* platforms (RHEL, but not Ubuntu) install to lib64
    -DCMAKE_INSTALL_INCLUDEDIR=include/flatbuffers_${VER}
    -DFLATBUFFERS_VER=${VER}
    -DXP_NAMESPACE:STRING=xpro
    )
  xpCmakeBuild(flatbuffers "" "${XP_CONFIGURE}")
endfunction()
