# jpeglossy12
set(VER 6b)
set(REPO https://github.com/LuaDist/libjpeg)
set(FORK https://github.com/smanders/libjpeg)
set(PRO_JPEGLOSSY12
  NAME jpeglossy12
  SUPERPRO jpegxp
  SUBDIR lossy12
  WEB "jpeglossy12" http://libjpeg.sourceforge.net/ "libjpeg on sourceforge"
  LICENSE "open" ${FORK}/blob/upstream/README "libjpeg: see LEGAL ISSUES, in README (no specific license mentioned)"
  DESC "lossy 12-bit encode and decode"
  REPO "repo" ${FORK} "forked libjpeg repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG lossy12.6b # what to 'git checkout'
  GIT_REF 09a4003 # create patch from this tag to 'git checkout'
  DLURL http://www.ijg.org/files/jpegsrc.v${VER}.tar.gz
  DLMD5 dbd5f3b47ed13132f04c685d608a7547
  PATCH ${PATCH_DIR}/jpegxp.lossy12.patch
  DIFF ${FORK}/compare/
  )
