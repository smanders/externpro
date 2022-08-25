# cares
xpProOption(cares DBG)
set(VER 1.18.1)
string(REPLACE "." "_" VER_ ${VER})
set(REPO github.com/c-ares/c-ares)
set(FORK github.com/smanders/c-ares)
set(PRO_CARES
  NAME cares
  WEB "c-ares" http://c-ares.haxx.se/ "c-ares website"
  LICENSE "open" http://c-ares.haxx.se/license.html "c-ares license: MIT license"
  DESC "C library for asynchronous DNS requests (including name resolves)"
  REPO "repo" https://${REPO} "c-ares repo on github"
  GRAPH GRAPH_LABEL "c-ares"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH main
  GIT_TAG xp-${VER_} # what to 'git checkout'
  GIT_REF cares-${VER_} # create patch from this tag to 'git checkout'
  DLURL http://c-ares.haxx.se/download/c-ares-${VER}.tar.gz
  DLMD5 bf770c0d3131ec0dd0575a0d2dcab226
  PATCH ${PATCH_DIR}/cares.patch
  DIFF https://${FORK}/compare/c-ares:
  DEPS_FUNC build_cares
  )
########################################
function(build_cares)
  if(NOT (XP_DEFAULT OR XP_PRO_CARES))
    return()
  endif()
  xpGetArgValue(${PRO_CARES} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_CARES} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCARES_BUILD_TOOLS:BOOL=OFF
    -DCARES_SHARED:BOOL=OFF
    -DCARES_STATIC:BOOL=ON
    )
  set(TARGETS_FILE lib/cmake/c-ares/c-ares-targets.cmake)
  set(LIBRARIES c-ares::${NAME})
  configure_file(${PRO_DIR}/use/usexp-template-lib-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
