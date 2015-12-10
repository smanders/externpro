########################################
# apr
xpProOption(apr)
set(VER 1.5.2)
set(REPO https://github.com/smanders/apr)
set(PRO_APR
  NAME apr
  WEB "APR" http://apr.apache.org/ "Apache Portable Runtime Project website"
  LICENSE "open" http://www.apache.org/licenses/LICENSE-2.0.html "Apache 2.0"
  DESC "Apache Portable Runtime project"
  REPO "repo" ${REPO} "forked apr repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/apr.git
  GIT_UPSTREAM git://github.com/apache/apr.git
  GIT_TRACKING_BRANCH trunk
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${VER} # create patch from this tag to 'git checkout'
  # Download APR following links at http://apr.apache.org/download.cgi (mirrors)
  DLURL http://www.webhostingjams.com/mirror/apache/apr/apr-${VER}.tar.gz
  DLMD5 98492e965963f852ab29f9e61b2ad700
  #DLURL ${REPO}/archive/${VER}.tar.gz
  #DLMD5 5b0bb763245c7d10b7c03214cc8756ec
  #DLNAME apr-tag-${VER}.tar.gz
  PATCH ${PATCH_DIR}/apr.patch
  DIFF ${REPO}/compare/apache:
  )
########################################
function(mkpatch_apr)
  xpRepo(${PRO_APR})
endfunction()
########################################
function(download_apr)
  xpNewDownload(${PRO_APR})
endfunction()
########################################
function(patch_apr)
  xpPatch(${PRO_APR})
endfunction()
########################################
function(build_apr)
  if(NOT (XP_DEFAULT OR XP_PRO_APR))
    return()
  endif()
  if(USE_OPENSSL)
  if(NOT (XP_DEFAULT OR XP_PRO_OPENSSL))
    message(FATAL_ERROR "apr.cmake: requires openssl")
    return()
  endif()
  if(NOT DEFINED opensslTgts)
    build_openssl(opensslTgts)
    list(APPEND depTgts ${opensslTgts})
  endif()
  endif()
  set(XP_CONFIGURE
    -DAPR_BUILD_TESTAPR=ON
    -DTEST_STATIC_LIBS=ON
    )
  configure_file(${PRO_DIR}/use/usexp-apr-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(apr "${depTgts}" "${XP_CONFIGURE}")
endfunction()
