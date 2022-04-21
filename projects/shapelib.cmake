# shapelib
# http://freecode.com/projects/shapelib
# http://packages.debian.org/sid/shapelib
# http://shapelib.sourcearchive.com/
xpProOption(shapelib DBG)
set(VER 1.2.10)
set(REPO github.com/asapnet/shapelib)
set(FORK github.com/smanders/shapelib)
set(PRO_SHAPELIB
  NAME shapelib
  WEB "shapelib" http://shapelib.maptools.org/ "Shapefile C Library website"
  LICENSE "open" http://shapelib.maptools.org/license.html "MIT Style -or- LGPL"
  DESC "reading, writing, updating ESRI Shapefiles"
  REPO "repo" https://${FORK} "forked shapelib repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://download.osgeo.org/shapelib/shapelib-${VER}.tar.gz
  DLMD5 4d96bd926167193d27bf14d56e2d484e
  PATCH ${PATCH_DIR}/shapelib.patch
  DIFF https://${FORK}/compare/
  )
########################################
function(build_shapelib)
  if(NOT (XP_DEFAULT OR XP_PRO_SHAPELIB))
    return()
  endif()
  xpGetArgValue(${PRO_SHAPELIB} ARG VER VALUE VER)
  set(XP_CONFIGURE -DXP_NAMESPACE:STRING=xpro -DSHAPELIB_VER=${VER})
  configure_file(${PRO_DIR}/use/usexp-shapelib-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(shapelib "" "${XP_CONFIGURE}")
endfunction()
