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
  GIT_TAG xp-${VER} # what to 'git checkout'
  GIT_REF ${PROJ}-${VER} # create patch from this tag to 'git checkout'
  # Download ActiveMQ-CPP following links at http://activemq.apache.org/cms/download.html (mirrors)
  DLURL http://mirrors.koehn.com/apache/activemq/${PROJ}/${VER}/${PROJ}-library-${VER}-src.tar.gz
  DLMD5 414ac7de16d305058c7f0e2a333a5960
  PATCH ${PATCH_DIR}/activemqcpp.patch
  # TRICKY: PATCH_STRIP because the repo has an extra level of directories that the .tar.gz file doesn't have
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF ${REPO}/compare/apache:
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
  if(NOT (XP_DEFAULT OR XP_PRO_APR))
    message(FATAL_ERROR "activemqcpp.cmake: requires apr")
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_OPENSSL))
    message(FATAL_ERROR "activemqcpp.cmake: requires openssl")
    return()
  endif()
  if(NOT DEFINED aprTgts)
    build_apr(aprTgts)
    list(APPEND depTgts ${aprTgts})
  endif()
  if(NOT DEFINED osslTgts)
    build_openssl(osslTgts)
    list(APPEND depTgts ${osslTgts})
  endif()
  set(XP_CONFIGURE
    -DFIND_APR_MODULE_PATH=ON
    -DFIND_OPENSSL_MODULE_PATH=ON
    )
  configure_file(${PRO_DIR}/use/usexp-activemqcpp-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(activemqcpp "${depTgts}" "${XP_CONFIGURE}")
endfunction()
