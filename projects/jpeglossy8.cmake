########################################
# jpeglossy8
set(VER 6b)
set(REPO https://github.com/smanders/libjpeg)
set(PRO_JPEGLOSSY8
  NAME jpeglossy8
  SUPERPRO jpegxp
  SUBDIR lossy8
  WEB "jpeglossy8" http://libjpeg.sourceforge.net/ "libjpeg on sourceforge"
  LICENSE "open" ${REPO}/blob/upstream/README "libjpeg: see LEGAL ISSUES, in README (no specific license mentioned)"
  DESC "lossy 8-bit encode and decode"
  REPO "repo" ${REPO} "libjpeg repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/libjpeg.git
  GIT_UPSTREAM git://github.com/LuaDist/libjpeg.git
  GIT_TAG lossy8.6b # what to 'git checkout'
  GIT_REF 09a4003 # create patch from this tag to 'git checkout'
  DLURL http://www.ijg.org/files/jpegsrc.v${VER}.tar.gz
  DLMD5 dbd5f3b47ed13132f04c685d608a7547
  PATCH ${PATCH_DIR}/jpegxp.lossy8.patch
  DIFF ${REPO}/compare/
  )
########################################
function(mkpatch_jpeglossy8)
  xpRepo(${PRO_JPEGLOSSY8})
endfunction()
########################################
function(download_jpeglossy8)
  xpNewDownload(${PRO_JPEGLOSSY8})
endfunction()
########################################
function(patch_jpeglossy8)
  patch_jpegxp()
  xpPatch(${PRO_JPEGLOSSY8})
endfunction()
