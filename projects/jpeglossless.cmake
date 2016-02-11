########################################
# jpeglossless
set(VER 62.1)
set(REPO https://github.com/smanders/libjpeg)
set(PRO_JPEGLOSSLESS
  NAME jpeglossless
  SUPERPRO jpegxp
  SUBDIR lossless
  WEB "jpeglossless" http://sourceforge.net/projects/jpeg/ "JPEG on sourceforge"
  LICENSE "open" ${REPO}/blob/upstream/README "libjpeg: see LEGAL ISSUES, in README (no specific license mentioned)"
  DESC "lossless decode"
  REPO "repo" ${REPO} "forked libjpeg repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/libjpeg.git
  GIT_UPSTREAM git://github.com/LuaDist/libjpeg.git
  GIT_TAG lossless.6b # what to 'git checkout'
  GIT_REF eccc424 # create patch from this tag to 'git checkout'
  DLURL http://downloads.sourceforge.net/project/jpeg/ljpeg/ljpeg%20${VER}/ljpeg-${VER}.0.tar.bz2
  DLMD5 539225d39bc8deb4802e3e2ba12fa5d1
  PATCH ${PATCH_DIR}/jpegxp.lossless.patch
  DIFF ${REPO}/compare/
  )
########################################
function(mkpatch_jpeglossless)
  xpRepo(${PRO_JPEGLOSSLESS})
endfunction()
########################################
function(download_jpeglossless)
  xpNewDownload(${PRO_JPEGLOSSLESS})
endfunction()
