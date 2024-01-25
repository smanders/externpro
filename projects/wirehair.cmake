# wirehair
# xpbuild:cmake-patch
xpProOption(wirehair DBG)
set(VER 21.07.31) # upstream repo has no tags
set(TAG 6d84fad40cbbbb29d4eb91204750ddffe0dcacfe) # 2021.07.31 commit, head of master branch
set(REPO https://github.com/catid/wirehair)
set(FORK https://github.com/externpro/wirehair)
set(PRO_WIREHAIR
  NAME wirehair
  WEB "wirehair" ${REPO} "wirehair repo on github"
  LICENSE "open" ${REPO}/blob/master/LICENSE.txt "BSD 3-Clause New or Revised License"
  DESC "fast and portable fountain codes in C"
  REPO "repo" ${REPO} "wirehair repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${TAG} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/${TAG}.tar.gz
  DLMD5 1c2c8d59ed98c4a4dc3fb93f5d03b70f
  DLNAME wirehair-${VER}.tar.gz
  PATCH ${PATCH_DIR}/wirehair.patch
  DIFF ${FORK}/compare/catid:
  )
########################################
function(build_wirehair)
  if(NOT (XP_DEFAULT OR XP_PRO_WIREHAIR))
    return()
  endif()
  xpGetArgValue(${PRO_WIREHAIR} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_WIREHAIR} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DDONT_INSTALL_PYTHON:BOOL=TRUE
    -DMARCH_NATIVE=OFF
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
