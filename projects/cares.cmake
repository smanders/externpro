########################################
# cares
xpProOption(cares)
set(VER 1.10.0)
string(REPLACE "." "_" VER_ ${VER})
set(REPO https://github.com/smanders/c-ares)
set(PRO_CARES
  NAME cares
  WEB "c-ares" http://c-ares.haxx.se/ "c-ares website"
  LICENSE "open" http://c-ares.haxx.se/license.html "c-ares license: MIT license"
  DESC "C library for asynchronous DNS requests (including name resolves)"
  REPO "repo" ${REPO} "forked c-ares repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/c-ares.git
  GIT_UPSTREAM git://github.com/bagder/c-ares.git
  GIT_TAG xp-${VER_} # what to 'git checkout'
  GIT_REF cares-${VER_} # create patch from this tag to 'git checkout'
  DLURL http://c-ares.haxx.se/download/c-ares-${VER}.tar.gz
  DLMD5 1196067641411a75d3cbebe074fd36d8
  PATCH ${PATCH_DIR}/cares.patch
  DIFF ${REPO}/compare/bagder:
  )
########################################
function(mkpatch_cares)
  xpRepo(${PRO_CARES})
endfunction()
########################################
function(download_cares)
  xpNewDownload(${PRO_CARES})
endfunction()
########################################
function(patch_cares)
  xpPatch(${PRO_CARES})
endfunction()
########################################
function(build_cares)
  if(NOT (XP_DEFAULT OR XP_PRO_CARES))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-cares-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(cares "" "" caresTargets)
  if(ARGN)
    set(${ARGN} "${caresTargets}" PARENT_SCOPE)
  endif()
endfunction()
