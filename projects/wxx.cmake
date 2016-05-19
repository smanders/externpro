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
set(WXX_TARGETS wxxplotctrl wxxthings wxxtlc)
########################################
function(mkpatch_wxx)
  xpRepo(${PRO_WXX})
endfunction()
########################################
function(patch_wxx)
  xpPatch(${PRO_WXX})
  foreach(tgt ${WXX_TARGETS})
    string(TOUPPER ${tgt} TGT)
    xpPatch(${PRO_${TGT}})
  endforeach()
endfunction()
########################################
function(build_wxx)
  if(NOT (XP_DEFAULT OR XP_PRO_WXX))
    return()
  endif()
  build_wxxv(30)
  build_wxxv(31)
endfunction()
function(build_wxxv ver)
  if(NOT (XP_DEFAULT OR XP_PRO_WX${ver}))
    message(STATUS "wxx.cmake: requires wx${ver}")
    set(XP_PRO_WX${ver} ON CACHE BOOL "include wx${ver}" FORCE)
    patch_wx()
  endif()
  configure_file(${PRO_DIR}/use/usexp-wxx-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  build_wxv(VER ${ver} TARGETS wxTgts INCDIR wxInc SRCDIR wxSrc)
  set(XP_DEPS ${wxTgts} ${WXX_TARGETS})
  set(XP_CONFIGURE
    -DWX_INCLUDE:PATH=${wxInc}
    -DWX_SOURCE:PATH=${wxSrc}
    )
  xpCmakeBuild(wxx "${XP_DEPS}" "${XP_CONFIGURE}" "" "" "" ${ver})
endfunction()
