# flatbuffers
# xpbuild:cmake-patch
xpProOption(flatbuffers DBG)
set(VER 2.0.6)
set(REPO https://github.com/google/flatbuffers)
set(FORK https://github.com/smanders/flatbuffers)
set(PRO_FLATBUFFERS
  NAME flatbuffers
  WEB "flatbuffers" http://google.github.io/flatbuffers/ "FlatBuffers website"
  LICENSE "open" ${REPO}/blob/v${VER}/LICENSE.txt "Apache license, v2"
  DESC "efficient cross platform serialization library"
  REPO "repo" ${REPO} "flatbuffers repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 231d9070d4b58ed91da539815543e07f
  DLNAME flatbuffers-${VER}.tar.gz
  PATCH ${PATCH_DIR}/flatbuffers.patch
  DIFF ${FORK}/compare/google:
  )
########################################
function(build_flatbuffers)
  if(NOT (XP_DEFAULT OR XP_PRO_FLATBUFFERS))
    return()
  endif()
  xpGetArgValue(${PRO_FLATBUFFERS} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_FLATBUFFERS} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(TARGETS_FILE tgt-${NAME}/FlatbuffersConfig.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "include(\${CMAKE_CURRENT_LIST_DIR}/tgt-${NAME}/BuildFlatBuffers.cmake) # build_flatbuffers cmake func\n")
  set(USE_VARS "${USE_VARS}include(\${CMAKE_CURRENT_LIST_DIR}/xpflatbuffers.cmake) # xpFlatBuffersBuild[TS] cmake funcs\n")
  set(USE_VARS "${USE_VARS}set(${PRJ}_FLATC_EXECUTABLE xpro::flatc)\n")
  set(USE_VARS "${USE_VARS}set(${PRJ}_LIBRARIES xpro::flatbuffers)\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_FLATC_EXECUTABLE ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  configure_file(${MODULES_DIR}/xpflatbuffers.cmake ${STAGE_DIR}/share/cmake/ COPYONLY)
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
endfunction()
