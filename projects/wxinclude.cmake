# wxinclude
# original source: http://users.skynet.be/towp/wxInclude.zip
# referenced from: http://wiki.wxwidgets.org/Embedding_PNG_Images
# another version: https://github.com/Forkk/MultiMC4/tree/master/src/wxinclude
# TODO: the functions and macros (which I usually don't generate) may need updating
# -- according to the discussion here: http://forums.wxwidgets.org/viewtopic.php?f=1&t=37288
xpProOption(wxinclude)
set(VER 1.0)
set(REPO https://github.com/smanders/wxInclude)
set(PRO_WXINCLUDE
  NAME wxinclude
  WEB "wxInclude" http://wiki.wxwidgets.org/Embedding_PNG_Images "wxInclude mentioned in this wxWiki page"
  LICENSE "open" http://wiki.wxwidgets.org/Embedding_PNG_Images "assumed wxWindows license, since source can be downloaded from wxWiki"
  DESC "embed resources into cross-platform code"
  REPO "repo" ${REPO} "wxInclude repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/wxInclude.git
  GIT_TAG rel # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 d4e482e18589df5eb05b862583e802fa
  DLNAME wxinclude-v${VER}.tar.gz
  PATCH ${PATCH_DIR}/wxInclude.patch
  DIFF ${REPO}/compare/
  )
########################################
function(build_wxinclude)
  if(NOT (XP_DEFAULT OR XP_PRO_WXINCLUDE))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_BOOST))
    message(STATUS "wxinclude.cmake: requires boost")
    set(XP_PRO_BOOST ON CACHE BOOL "include boost" FORCE)
    patch_boost()
  endif()
  set(oneValueArgs TARGETS EXE)
  cmake_parse_arguments(wxinc "" "${oneValueArgs}" "" ${ARGN})
  build_boost(TARGETS boostTgts)
  xpGetArgValue(${PRO_BOOST} ARG VER VALUE boostVer)
  set(XP_CONFIGURE -DBOOST_VER=${boostVer})
  # since we only need a release executable...
  xpBuildOnlyRelease()
  configure_file(${PRO_DIR}/use/usexp-wxinclude-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(wxinclude "${boostTgts}" "${XP_CONFIGURE}" wxincludeTargets)
  if(DEFINED wxinc_TARGETS)
    xpListAppendIfDne(${wxinc_TARGETS} "${wxincludeTargets}")
    set(${wxinc_TARGETS} "${${wxinc_TARGETS}}" PARENT_SCOPE)
  endif()
  if(DEFINED wxinc_EXE)
    if(MSVC)
      set(${wxinc_EXE} ${STAGE_DIR}/bin/wxInclude.exe PARENT_SCOPE)
    else()
      set(${wxinc_EXE} ${STAGE_DIR}/bin/wxInclude PARENT_SCOPE)
    endif()
  endif()
endfunction()
