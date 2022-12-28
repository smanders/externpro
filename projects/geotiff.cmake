# geotiff
xpProOption(geotiff DBG)
# http://packages.debian.org/sid/libgeotiff-dev
# http://libgeotiff-dfsg.sourcearchive.com/
set(VER 1.2.4)
set(REPO github.com/smanders/libgeotiff)
set(PRO_GEOTIFF
  NAME geotiff
  WEB "geotiff" http://trac.osgeo.org/geotiff/ "GeoTIFF trac website"
  LICENSE "open" http://trac.osgeo.org/geotiff/ "trac site states it is an open source library (no specific license mentioned)"
  DESC "georeferencing info embedded within TIFF file"
  REPO "repo" https://${REPO} "libgeotiff repo on github"
  GRAPH BUILD_DEPS wx
  VER ${VER}
  GIT_ORIGIN https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  #DLURL http://libgeotiff-dfsg.sourcearchive.com/downloads/${VER}/libgeotiff-dfsg_${VER}.orig.tar.gz
  #DLMD5 35dca74146d6168bc5adcf3495d7546c
  # NOTE: version 1.2.4 appears to be no longer available to download
  # from sourcearchive.com (26 byte invalid file)
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 4bef0cc5f066a5f3c0b2352f39bbf140
  DLNAME libgeotiff-v${VER}.tar.gz
  PATCH ${PATCH_DIR}/geotiff.patch
  DIFF https://${REPO}/compare/
  )
########################################
function(build_geotiff)
  if(NOT (XP_DEFAULT OR XP_PRO_GEOTIFF))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_GEOTIFF}) # defines WX_INCDIR
  xpGetArgValue(${PRO_GEOTIFF} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_GEOTIFF} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DWX_INCLUDE=${WX_INCDIR}
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME})\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}")
endfunction()
