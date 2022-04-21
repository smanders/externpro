# jpeglossy8
set(VER 6b)
set(REPO github.com/LuaDist/libjpeg)
set(FORK github.com/smanders/libjpeg)
set(PRO_JPEGLOSSY8
  NAME jpeglossy8
  SUPERPRO jpegxp
  SUBDIR lossy8
  WEB "jpeglossy8" http://libjpeg.sourceforge.net/ "libjpeg on sourceforge"
  LICENSE "open" https://${FORK}/blob/upstream/README "libjpeg: see LEGAL ISSUES, in README (no specific license mentioned)"
  DESC "lossy 8-bit encode and decode"
  REPO "repo" https://${FORK} "forked libjpeg repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG lossy8.6b # what to 'git checkout'
  GIT_REF 09a4003 # create patch from this tag to 'git checkout'
  DLURL http://www.ijg.org/files/jpegsrc.v${VER}.tar.gz
  DLMD5 dbd5f3b47ed13132f04c685d608a7547
  PATCH ${PATCH_DIR}/jpegxp.lossy8.patch
  DIFF https://${FORK}/compare/
  )
