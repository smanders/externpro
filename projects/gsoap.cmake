# gsoap
xpProOption(gsoap DBG)
set(VER 2.7.17)
set(REPO github.com/stoneyrh/gSOAP)
set(FORK github.com/smanders/gSOAP)
set(PRO_GSOAP
  NAME gsoap
  WEB "gSOAP" http://www.cs.fsu.edu/~engelen/soap.html "gSOAP website"
  LICENSE "??" http://www.cs.fsu.edu/~engelen/soaplicense.html "gSOAP Public License 1.3, based on Mozilla public license 1.1 -- some components are GPL v2"
  DESC "toolkit for SOAP/XML Web services"
  REPO "repo" https://${FORK} "forked gSOAP repo on github"
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL https://github.com/smanders/externpro/releases/download/17.05.1/gsoap_${VER}.zip
  DLMD5 6f58cabfc67b4d5eafd1a30057fc4343
  PATCH ${PATCH_DIR}/gsoap.patch
  DIFF https://${FORK}/compare/
  )
########################################
function(build_gsoap)
  if(NOT (XP_DEFAULT OR XP_PRO_GSOAP))
    return()
  endif()
  xpGetArgValue(${PRO_GSOAP} ARG VER VALUE VER)
  set(XP_CONFIGURE -DXP_NAMESPACE:STRING=xpro -DGSOAP_VER=${VER})
  configure_file(${PRO_DIR}/use/usexp-gsoap-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(gsoap "" "${XP_CONFIGURE}")
endfunction()
