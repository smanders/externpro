# cm256
xpProOption(cm256 DBG)
set(VER 20.10.30) # upstream repo has no tags
set(TAG 40ca807e091dec21ebc6d5cb633b425aaeb74155) # 2020.10.30 commit, head of master branch
set(REPO github.com/catid/cm256)
set(SIBLING github.com/catid/gf256)
set(FORK github.com/smanders/cm256)
set(PRO_CM256
  NAME cm256
  WEB "cm256" https://${REPO} "cm256 repo on github"
  LICENSE "open" https://${SIBLING}/blob/master/License.md "BSD 3-Clause New or Revised License in sibling project (no license file currently in cm256)"
  DESC "fast GF(256) Cauchy MDS Block Erasure Codec in C"
  REPO "repo" https://${REPO} "cm256 repo on github"
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${TAG} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/${TAG}.tar.gz
  DLMD5 a66f1854d5daa52c13ebd1d25185c227
  DLNAME cm256-${VER}.tar.gz
  PATCH ${PATCH_DIR}/cm256.patch
  DIFF https://${FORK}/compare/catid:
  )
########################################
function(build_cm256)
  if(NOT (XP_DEFAULT OR XP_PRO_CM256))
    return()
  endif()
  xpGetArgValue(${PRO_CM256} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-cm256-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_LIBDIR=lib # without this *some* platforms (RHEL, but not Ubuntu) install to lib64
    -DCMAKE_INSTALL_INCLUDEDIR=include/cm256_${VER}
    -DCM256_VER=${VER}
    -DXP_NAMESPACE:STRING=xpro
    )
  xpCmakeBuild(cm256 "" "${XP_CONFIGURE}")
endfunction()
