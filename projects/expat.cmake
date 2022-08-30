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
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${TAG} # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/expat.patch
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
  xpGetArgValue(${PRO_EXPAT} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_EXPAT} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_NAMESPACE:STRING=xpro
    -DBUILD_shared=OFF
    -DBUILD_doc=OFF
    )
  set(TARGETS_FILE lib/cmake/${NAME}-targets.cmake)
  set(LIBRARIES xpro::${NAME})
  configure_file(${PRO_DIR}/use/usexp-template-lib-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
