########################################
# hdphoto
xpProOption(hdphoto)
set(VER 1.0)
set(REPO https://github.com/smanders/hdphoto)
set(PRO_HDPHOTO
  NAME hdphoto
  WEB "HDPhoto" http://msdn.microsoft.com/en-us/library/windows/hardware/gg463381.aspx "HD Photo Device Porting Kit"
  LICENSE "open" http://blogs.msdn.com/b/billcrow/archive/2006/11/17/introducing-hd-photo.aspx "HD Photo License (no specific license mentioned)"
  DESC "JPEG XR standard, based on Microsoft HD Photo"
  REPO "repo" ${REPO} "hdphoto repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/hdphoto.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 1f8e06219f2f482809cc913f8fba2ab2
  DLNAME hdphoto-v${VER}.tar.gz
  PATCH ${PATCH_DIR}/hdphoto.patch
  DIFF ${REPO}/compare/
  )
########################################
function(mkpatch_hdphoto)
  xpRepo(${PRO_HDPHOTO})
endfunction()
########################################
function(download_hdphoto)
  xpNewDownload(${PRO_HDPHOTO})
endfunction()
########################################
function(patch_hdphoto)
  xpPatch(${PRO_HDPHOTO})
endfunction()
########################################
function(build_hdphoto)
  if(NOT (XP_DEFAULT OR XP_PRO_HDPHOTO))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-hdphoto-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(hdphoto)
endfunction()
