# shapelib
# xpbuild:cmake-scratch
# http://freecode.com/projects/shapelib
# http://packages.debian.org/sid/shapelib
# http://shapelib.sourcearchive.com/
xpProOption(shapelib DBG)
set(VER 1.2.10)
set(REPO https://github.com/asapnet/shapelib)
set(FORK https://github.com/externpro/shapelib)
set(PRO_SHAPELIB
  NAME shapelib
  WEB "shapelib" http://shapelib.maptools.org/ "Shapefile C Library website"
  LICENSE "open" http://shapelib.maptools.org/license.html "MIT Style -or- LGPL"
  DESC "reading, writing, updating ESRI Shapefiles"
  REPO "repo" ${FORK} "forked shapelib repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://download.osgeo.org/shapelib/shapelib-${VER}.tar.gz
  DLMD5 4d96bd926167193d27bf14d56e2d484e
  PATCH ${PATCH_DIR}/shapelib.patch
  DIFF ${FORK}/compare/
  )
########################################
function(build_shapelib)
  if(NOT (XP_DEFAULT OR XP_PRO_SHAPELIB))
    return()
  endif()
  xpGetArgValue(${PRO_SHAPELIB} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_SHAPELIB} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::shape)\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
endfunction()
