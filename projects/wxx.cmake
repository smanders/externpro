# wxx
xpProOption(wxx DBG) # include wx extras
set(REPO https://github.com/smanders/wxx)
set(WXX_TARGETS wxxplotctrl wxxthings wxxtlc)
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
  SUBPRO ${WXX_TARGETS}
  )
########################################
function(build_wxx)
  if(NOT (XP_DEFAULT OR XP_PRO_WXX))
    return()
  endif()
  build_wx() # determine WX_VERSIONS, GTK_VER
  foreach(ver ${WX_VERSIONS})
    build_wxxv(${ver})
  endforeach()
endfunction()
function(build_wxxv ver)
  if(NOT (XP_DEFAULT OR XP_PRO_WX${ver}))
    message(STATUS "wxx.cmake: requires wx${ver}")
    set(XP_PRO_WX${ver} ON CACHE BOOL "include wx${ver}" FORCE)
    xpPatchProject(${PRO_WX${ver}})
  endif()
  configure_file(${PRO_DIR}/use/usexp-wxx-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  build_wxv(VER ${ver} TARGETS wxTgts INCDIR wxInc SRCDIR wxSrc)
  set(XP_DEPS ${wxTgts})
  xpGetArgValue(${PRO_WXX} ARG SUBPRO VALUES subs)
  foreach(sub ${subs})
    list(APPEND XP_DEPS wxx_${sub})
  endforeach()
  set(XP_CONFIGURE
    -DWX_INCLUDE:PATH=${wxInc}
    -DWX_SOURCE:PATH=${wxSrc}
    -DGTK_VER:STRING=${GTK_VER}
    )
  xpCmakeBuild(wxx "${XP_DEPS}" "${XP_CONFIGURE}" "" TGT ${ver})
endfunction()
