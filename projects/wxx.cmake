# wxx
# xpbuild:cmake-scratch
xpProOption(wxx DBG) # include wx extras
set(REPO https://github.com/smanders/wxx)
set(WXX_TARGETS wxxplotctrl wxxthings wxxtlc)
set(PRO_WXX
  NAME wxx
  WEB "wxx" ${REPO} "wxx project on github"
  LICENSE "open" http://wxcode.sourceforge.net/rules.php "wxCode components must use wxWindows license"
  DESC "wxWidget-based extra components"
  REPO "repo" ${REPO} "wxx repo on github"
  GRAPH BUILD_DEPS wx
  VER 2022.04.21 # latest xpro branch commit date
  GIT_ORIGIN ${REPO}
  GIT_TAG xpro # what to 'git checkout'
  GIT_REF wxx.02 # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/wxx.xpro.patch
  DIFF ${REPO}/compare/
  SUBPRO ${WXX_TARGETS}
  )
########################################
function(build_wxx)
  if(NOT (XP_DEFAULT OR XP_PRO_WXX))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_WXX}) # defines WX_INCDIR WX_SRCDIR
  xpGetArgValue(${PRO_WXX} ARG SUBPRO VALUES subs)
  foreach(sub ${subs})
    list(APPEND depTgts wxx_${sub})
  endforeach()
  xpGetArgValue(${PRO_WXX} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_WXX} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=${WX_INCDIR}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=${NAME}
    -DWX_SOURCE:PATH=${WX_SRCDIR}
    )
  set(FIND_DEPS "xpFindPkg(PKGS wxwidgets) # dependencies\n")
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES ${NAME}::plotctrl ${NAME}::things ${NAME}::tlc)\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}")
endfunction()
