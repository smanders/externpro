# apr
xpProOption(apr DBG)
set(VER 1.5.2)
set(REPO github.com/apache/apr)
set(FORK github.com/smanders/apr)
set(PRO_APR
  NAME apr
  WEB "APR" http://apr.apache.org/ "Apache Portable Runtime Project website"
  LICENSE "open" http://www.apache.org/licenses/LICENSE-2.0.html "Apache 2.0"
  DESC "Apache Portable Runtime project [cmake-patch]"
  REPO "repo" https://${REPO} "apr repo on github"
  GRAPH
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH trunk
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${VER} # create patch from this tag to 'git checkout'
  # Download APR following links at http://apr.apache.org/download.cgi (mirrors)
  #DLURL http://ftp.wayne.edu/apache/apr/apr-${VER}.tar.gz
  #DLMD5 d41d8cd98f00b204e9800998ecf8427e
  # TODO: version 1.5.2 no longer appears to be available from apache mirrors,
  #  so until we move to a new version that is available, download from the repo
  DLURL https://${REPO}/archive/${VER}.tar.gz
  DLMD5 4a6bdfe8aba67891aead7f7ed11e3361
  DLNAME apr-tag-${VER}.tar.gz
  PATCH ${PATCH_DIR}/apr.patch
  DIFF https://${FORK}/compare/apache:
  DEPS_FUNC build_apr
  )
########################################
function(build_apr)
  if(NOT (XP_DEFAULT OR XP_PRO_APR))
    return()
  endif()
  xpGetArgValue(${PRO_APR} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_APR} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DAPR_BUILD_TESTAPR:BOOL=ON
    -DTEST_STATIC_LIBS:BOOL=ON
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME}-1)\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
