########################################
# wxx
xpProOption(wxx) # include wx extras
set(REPO https://github.com/smanders/wxx)
set(PRO_WXX
  NAME wxx
  WEB "wxx" ${REPO} "wxx project on github"
  LICENSE "open" http://wxcode.sourceforge.net/rules.php "wxCode components must use wxWindows license"
  DESC "wxWidget-based extra components"
  REPO "repo" ${REPO} "wxx repo on github"
  VER 2015.10.02 # latest xpro branch commit date
  GIT_ORIGIN git://github.com/smanders/wxx.git
  GIT_TAG xpro # what to 'git checkout'
  GIT_REF wxx.01 # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/wxx.xpro.patch
  DIFF ${REPO}/compare/
  )
########################################
function(mkpatch_wxx)
  xpRepo(${PRO_WXX})
endfunction()
########################################
function(patch_wxx)
  xpPatch(${PRO_WXX})
endfunction()
########################################
function(build_wxx)
  if(NOT (XP_DEFAULT OR XP_PRO_WXX))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_WX))
    message(FATAL_ERROR "wxx.cmake: requires wx")
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-wxx-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  cmake_parse_arguments(wxx "" TARGETS "" ${ARGN})
  build_wx(TARGETS wxTgts INCDIR wxInc SRCDIR wxSrc)
  set(WXX_PROJECTS wxxplotctrl wxxthings wxxtlc)
  set(XP_DEPS ${wxTgts} ${WXX_PROJECTS})
  set(XP_CONFIGURE
    -DWX_INCLUDE:PATH=${wxInc}
    -DWX_SOURCE:PATH=${wxSrc}
    )
  xpCmakeBuild(wxx "${XP_DEPS}" "${XP_CONFIGURE}" wxxTargets)
  if(DEFINED wxx_TARGETS)
    xpListAppendIfDne(${wxx_TARGETS} "${wxxTargets}")
    set(${wxx_TARGETS} "${${wxx_TARGETS}}" PARENT_SCOPE)
  endif()
endfunction()
