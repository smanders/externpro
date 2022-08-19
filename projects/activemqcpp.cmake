# activemqcpp
set(VER 3.9.5)
xpProOption(activemqcpp DBG)
set(PROJ activemq-cpp)
set(REPO github.com/apache/${PROJ})
set(FORK github.com/smanders/${PROJ})
set(PRO_ACTIVEMQCPP
  NAME activemqcpp
  WEB "ActiveMQ-CPP" http://activemq.apache.org/cms/ "ActiveMQ CMS website"
  LICENSE "open" http://www.apache.org/licenses/LICENSE-2.0.html "Apache 2.0"
  DESC "ActiveMQ C++ Messaging Service (CMS) client library"
  REPO "repo" https://${REPO} "${PROJ} repo on github"
  GRAPH BUILD_DEPS apr openssl
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp-${VER} # what to 'git checkout'
  GIT_REF ${PROJ}-${VER} # create patch from this tag to 'git checkout'
  DLURL https://archive.apache.org/dist/activemq/${PROJ}/${VER}/${PROJ}-library-${VER}-src.tar.gz
  DLMD5 c758cc8f36505a48680d454e376f4203
  PATCH ${PATCH_DIR}/activemqcpp_${VER}.patch
  # TRICKY: PATCH_STRIP because the repo has an extra level of directories that the .tar.gz file doesn't have
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/apache:
  )
########################################
function(build_activemqcpp)
  if(NOT (XP_DEFAULT OR XP_PRO_ACTIVEMQCPP))
    return()
  endif()
  xpGetArgValue(${PRO_ACTIVEMQCPP} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_ACTIVEMQCPP} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DXP_MODULE_PATH:BOOL=ON
    -DXP_NAMESPACE:STRING=xpro
    )
  set(FIND_DEPS "xpFindPkg(PKGS apr openssl) # dependencies\n")
  set(TARGETS_FILE lib/cmake/${NAME}-targets.cmake)
  set(LIBRARIES xpro::${NAME})
  configure_file(${PRO_DIR}/use/usexp-template-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpBuildDeps(depTgts ${PRO_ACTIVEMQCPP})
  xpCmakeBuild(activemqcpp "${depTgts}" "${XP_CONFIGURE}")
endfunction()
