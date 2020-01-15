# expat
xpProOption(expat DBG)
set(VER 2.2.5)
string(REPLACE "." "_" VER_ ${VER})
set(TAG R_${VER_})
set(REPO github.com/libexpat/libexpat)
set(FORK github.com/smanders/libexpat)
set(PRO_EXPAT
  NAME expat
  WEB "Expat" https://libexpat.github.io "Expat website"
  LICENSE "open" https://${REPO}/blob/${TAG}/expat/COPYING "Expat License (MIT/X Consortium license)"
  DESC "a stream-oriented XML parser library written in C"
  REPO "repo" https://${REPO} "libexpat repo on github"
  GRAPH
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${TAG} # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/expat_${VER}.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names
  DIFF https://${FORK}/compare/libexpat:
  DLURL https://${REPO}/releases/download/${TAG}/expat-${VER}.tar.bz2
  DLMD5 789e297f547980fc9ecc036f9a070d49
  DEPS_FUNC build_expat
  )
########################################
function(build_expat)
  if(NOT (XP_DEFAULT OR XP_PRO_EXPAT))
    return()
  endif()
  xpGetArgValue(${PRO_EXPAT} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-expat-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -DBUILD_shared=OFF
    -DBUILD_doc=OFF
    -DINSTALL_extra=OFF
    -DXP_NAMESPACE:STRING=xpro
    )
  xpCmakeBuild(expat "" "${XP_CONFIGURE}" expatTargets)
  if(ARGN)
    set(${ARGN} "${expatTargets}" PARENT_SCOPE)
  endif()
endfunction()
