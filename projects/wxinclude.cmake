# wxinclude
# original source: http://users.skynet.be/towp/wxInclude.zip
# referenced from: http://wiki.wxwidgets.org/Embedding_PNG_Images
# another version: https://github.com/Forkk/MultiMC4/tree/master/src/wxinclude
# TODO: the functions and macros (which I usually don't generate) may need updating
# -- according to the discussion here: http://forums.wxwidgets.org/viewtopic.php?f=1&t=37288
xpProOption(wxinclude)
set(VER 1.0)
set(REPO github.com/smanders/wxInclude)
set(PRO_WXINCLUDE
  NAME wxinclude
  WEB "wxInclude" http://wiki.wxwidgets.org/Embedding_PNG_Images "wxInclude mentioned in this wxWiki page"
  LICENSE "open" http://wiki.wxwidgets.org/Embedding_PNG_Images "assumed wxWindows license, since source can be downloaded from wxWiki"
  DESC "embed resources into cross-platform code"
  REPO "repo" https://${REPO} "wxInclude repo on github"
  GRAPH GRAPH_SHAPE box BUILD_DEPS boost
  VER ${VER}
  GIT_ORIGIN https://${REPO}.git
  GIT_TAG rel # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 d4e482e18589df5eb05b862583e802fa
  DLNAME wxinclude-v${VER}.tar.gz
  PATCH ${PATCH_DIR}/wxInclude.patch
  DIFF https://${REPO}/compare/
  )
########################################
function(build_wxinclude)
  if(NOT (XP_DEFAULT OR XP_PRO_WXINCLUDE))
    return()
  endif()
  xpBuildDeps(depsTgts ${PRO_WXINCLUDE})
  set(oneValueArgs TARGETS EXE)
  cmake_parse_arguments(wxinc "" "${oneValueArgs}" "" ${ARGN})
  xpGetArgValue(${PRO_WXINCLUDE} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_WXINCLUDE} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  set(EXECUTABLE xpro::wxInclude)
  configure_file(${PRO_DIR}/use/template-exe-tgt.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  set(BUILD_CONFIGS Release) # we only need a release executable
  xpCmakeBuild(${NAME} "${depsTgts}" "${XP_CONFIGURE}" ${NAME}Targets)
  if(DEFINED wxinc_TARGETS)
    xpListAppendIfDne(${wxinc_TARGETS} "${${NAME}Targets}")
    set(${wxinc_TARGETS} "${${wxinc_TARGETS}}" PARENT_SCOPE)
  endif()
  if(DEFINED wxinc_EXE)
    set(${wxinc_EXE} ${STAGE_DIR}/bin/wxInclude${CMAKE_EXECUTABLE_SUFFIX} PARENT_SCOPE)
  endif()
endfunction()
