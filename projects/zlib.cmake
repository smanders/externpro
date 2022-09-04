# zlib
xpProOption(zlib DBG)
set(VER 1.2.8)
set(REPO github.com/madler/zlib)
set(FORK github.com/smanders/zlib)
set(PRO_ZLIB
  NAME zlib
  WEB "zlib" http://zlib.net/ "zlib website"
  LICENSE "open" http://zlib.net/zlib_license.html "zlib license"
  DESC "compression library"
  REPO "repo" https://${REPO} "zlib repo on github"
  GRAPH
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://zlib.net/fossils/zlib-${VER}.tar.gz
  DLMD5 44d667c142d7cda120332623eab69f40
  PATCH ${PATCH_DIR}/zlib.patch
  DIFF https://${FORK}/compare/madler:
  DEPS_FUNC build_zlib
  )
########################################
function(build_zlib)
  if(NOT (XP_DEFAULT OR XP_PRO_ZLIB))
    return()
  endif()
  xpGetArgValue(${PRO_ZLIB} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_ZLIB} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DSKIP_INSTALL_SHARED_LIBRARIES=ON # only need static library
    -DSKIP_INSTALL_FILES=ON # no need for share/man and share/pkgconfig
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  set(LIBRARIES xpro::${NAME}static)
  configure_file(${PRO_DIR}/use/template-lib-tgt.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
