# RapidJSON
# xpbuild:cmake-patch
xpProOption(rapidjson)
set(VER 1.1.0)
set(REPO https://github.com/Tencent/rapidjson)
set(FORK https://github.com/externpro/rapidjson)
set(PRO_RAPIDJSON
  NAME rapidjson
  WEB "RapidJSON" http://Tencent.github.io/rapidjson/ "RapidJSON on githubio"
  LICENSE "open" https://raw.githubusercontent.com/Tencent/rapidjson/master/license.txt "The MIT License - http://opensource.org/licenses/mit-license.php"
  DESC "C++ library for parsing and generating JSON"
  REPO "repo" ${REPO} "rapidjson repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 badd12c511e081fec6c89c43a7027bce
  DLNAME rapidjson-${VER}.tar.gz
  PATCH ${PATCH_DIR}/rapidjson.patch
  DIFF ${FORK}/compare/Tencent:
  )
########################################
function(build_rapidjson)
  if(NOT (XP_DEFAULT OR XP_PRO_RAPIDJSON))
    return()
  endif()
  xpGetArgValue(${PRO_RAPIDJSON} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_RAPIDJSON} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME})\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  set(BUILD_CONFIGS Release) # this project is only copying headers
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
endfunction()
