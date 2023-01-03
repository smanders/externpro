# jxrlib
# xpbuild:cmake-scratch
xpProOption(jxrlib DBG)
set(VER 15.08)
set(REPO https://github.com/c0nk/jxrlib)
set(FORK https://github.com/smanders/jxrlib)
set(PRO_JXRLIB
  NAME jxrlib
  WEB "jxrlib" https://jxrlib.codeplex.com/ "jxrlib project hosted on CodePlex"
  LICENSE "open" https://jxrlib.codeplex.com/license "New BSD License (BSD)"
  DESC "open source implementation of the jpegxr image format standard"
  REPO "repo" ${FORK} "forked jxrlib repo on github"
  VER ${VER}
  GIT_ORIGINAL_UPSTREAM https://git01.codeplex.com/jxrlib # CodePlex is shutting down!
  GIT_UPSTREAM ${REPO}
  GIT_ORIGIN ${FORK}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  # NOTE: the download from codeplex is CR/LF, the repo is LF
  #DLURL https://jxrlib.codeplex.com/downloads/get/685250
  DLURL ${FORK}/archive/v${VER}.tar.gz
  DLMD5 93822c8ba22b44ee7d1a4810e2a9468b
  DLNAME jxrlib-v${VER}.tar.gz
  PATCH ${PATCH_DIR}/jxrlib.patch
  DIFF ${FORK}/compare/
  )
########################################
function(build_jxrlib)
  if(NOT (XP_DEFAULT OR XP_PRO_JXRLIB))
    return()
  endif()
  xpGetArgValue(${PRO_JXRLIB} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_JXRLIB} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME})\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
endfunction()
