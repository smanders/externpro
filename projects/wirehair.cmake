# wirehair
xpProOption(wirehair DBG)
set(VER 20.11.21) # upstream repo has no tags
set(TAG 9e8923a200045c7bdb9e89b449692dbfed6b6de0) # 2020.11.21 commit, head of master branch
set(REPO github.com/catid/wirehair)
set(FORK github.com/smanders/wirehair)
set(PRO_WIREHAIR
  NAME wirehair
  WEB "wirehair" https://${REPO} "wirehair repo on github"
  LICENSE "open" https://${REPO}/blob/master/LICENSE.txt "BSD 3-Clause New or Revised License"
  DESC "fast and portable fountain codes in C"
  REPO "repo" https://${REPO} "wirehair repo on github"
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${TAG} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/${TAG}.tar.gz
  DLMD5 f379fd3123d5f5b4484e222816343ad2
  DLNAME wirehair-${VER}.tar.gz
  PATCH ${PATCH_DIR}/wirehair.patch
  DIFF https://${FORK}/compare/catid:
  )
########################################
function(build_wirehair)
  if(NOT (XP_DEFAULT OR XP_PRO_WIREHAIR))
    return()
  endif()
  xpGetArgValue(${PRO_WIREHAIR} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-wirehair-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_LIBDIR=lib # without this *some* platforms (RHEL, but not Ubuntu) install to lib64
    -DCMAKE_INSTALL_INCLUDEDIR=include/wirehair_${VER}
    -DWIREHAIR_VER=${VER}
    -DDONT_INSTALL_PYTHON:BOOL=TRUE
    -DXP_NAMESPACE:STRING=xpro
    )
  xpCmakeBuild(wirehair "" "${XP_CONFIGURE}")
endfunction()
