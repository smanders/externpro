########################################
# activemqcpp
xpProOption(activemqcpp)
set(VER 3.9.0)
set(PROJ activemq-cpp)
set(REPO https://github.com/smanders/${PROJ})
set(PRO_ACTIVEMQCPP
  NAME activemqcpp
  WEB "ActiveMQ-CPP" http://activemq.apache.org/cms/ "ActiveMQ CMS website"
  LICENSE "open" http://www.apache.org/licenses/LICENSE-2.0.html "Apache 2.0"
  DESC "ActiveMQ C++ Messaging Service (CMS) client library"
  REPO "repo" ${REPO} "forked ${PROJ} repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/${PROJ}.git
  GIT_UPSTREAM git://github.com/apache/${PROJ}.git
  GIT_TAG ${PROJ}-${VER} # what to 'git checkout'
  GIT_REF ${PROJ}-${VER} # create patch from this tag to 'git checkout'
  # Download ActiveMQ-CPP following links at http://activemq.apache.org/cms/download.html (mirrors)
  DLURL http://mirrors.koehn.com/apache/activemq/${PROJ}/${VER}/${PROJ}-library-${VER}-src.tar.gz
  DLMD5 414ac7de16d305058c7f0e2a333a5960
  #DLURL ${REPO}/archive/${PROJ}-${VER}.tar.gz
  #DLMD5 fe454166de637245987e859a2793208a
  #PATCH ${PATCH_DIR}/activemqcpp.patch
  #DIFF ${REPO}/compare/apache:
  )
########################################
function(mkpatch_activemqcpp)
  xpRepo(${PRO_ACTIVEMQCPP})
endfunction()
########################################
function(download_activemqcpp)
  xpNewDownload(${PRO_ACTIVEMQCPP})
endfunction()
########################################
function(patch_activemqcpp)
  xpPatch(${PRO_ACTIVEMQCPP})
endfunction()
########################################
function(build_activemqcpp)
  if(NOT (XP_DEFAULT OR XP_PRO_ACTIVEMQCPP))
    return()
  endif()
  return() # no build, yet
  configure_file(${PRO_DIR}/use/usexp-activemqcpp-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(activemqcpp)
endfunction()
