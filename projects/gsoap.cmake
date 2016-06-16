# gsoap
# http://gsoap2.sourceforge.net/
# http://packages.debian.org/sid/gsoap
# http://gsoap.sourcearchive.com/
xpProOption(gsoap)
set(VER 2.7.17)
set(REPO https://github.com/smanders/gSOAP)
set(PRO_GSOAP
  NAME gsoap
  WEB "gSOAP" http://www.cs.fsu.edu/~engelen/soap.html "gSOAP website"
  LICENSE "??" http://www.cs.fsu.edu/~engelen/soaplicense.html "gSOAP Public License 1.3, based on Mozilla public license 1.1 -- some components are GPL v2"
  DESC "toolkit for SOAP/XML Web services"
  REPO "repo" ${REPO} "forked gSOAP repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/gSOAP.git
  GIT_UPSTREAM git://github.com/stoneyrh/gSOAP.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://downloads.sourceforge.net/project/gsoap2/gSOAP/gsoap_${VER}.zip
  DLMD5 6f58cabfc67b4d5eafd1a30057fc4343
  PATCH ${PATCH_DIR}/gsoap.patch
  DIFF ${REPO}/compare/smanders:
  )
########################################
function(build_gsoap)
  if(NOT (XP_DEFAULT OR XP_PRO_GSOAP))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-gsoap-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(gsoap)
endfunction()
