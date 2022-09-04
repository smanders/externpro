# openh264
xpProOption(openh264 DBG)
set(VER 1.4.0)
set(REPO github.com/cisco/openh264)
set(FORK github.com/smanders/openh264)
set(PRO_OPENH264
  NAME openh264
  WEB "OpenH264" http://www.openh264.org/ "OpenH264 website"
  LICENSE "open" http://www.openh264.org/faq.html "Two-Clause BSD license"
  DESC "a codec library which supports H.264 encoding and decoding"
  REPO "repo" https://${REPO} "openh264 repo on github"
  GRAPH BUILD_DEPS yasm
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/openh264.patch
  DIFF https://${FORK}/compare/cisco:
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 ca77b91a7a33efb4c5e7c56a5c0f599f
  DLNAME openh264-${VER}.tar.gz
  DEPS_FUNC build_openh264
  )
########################################
function(build_openh264)
  if(NOT (XP_DEFAULT OR XP_PRO_OPENH264))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_OPENH264}) # sets YASM_EXE
  xpGetArgValue(${PRO_OPENH264} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_OPENH264} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DCMAKE_ASM_NASM_COMPILER=${YASM_EXE}
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DXP_PRO_VER=${VER}
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  set(LIBRARIES xpro::${NAME})
  configure_file(${PRO_DIR}/use/template-lib-tgt.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
