# yasm
xpProOption(yasm)
set(VER 1.3.0)
set(REPO github.com/yasm/yasm)
set(FORK github.com/smanders/yasm)
set(PRO_YASM
  NAME yasm
  WEB "yasm" http://yasm.tortall.net/ "yasm website"
  LICENSE "open" https://${REPO}/blob/v${VER}/COPYING "new BSD license"
  DESC "assembler and disassembler for the Intel x86 architecture"
  REPO "repo" https://${REPO} "yasm repo on github"
  GRAPH GRAPH_SHAPE box
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp${VER}
  GIT_REF v${VER}
  DLURL http://www.tortall.net/projects/yasm/releases/yasm-${VER}.tar.gz
  DLMD5 fc9e586751ff789b34b1f21d572d96af
  PATCH ${PATCH_DIR}/yasm.patch
  DIFF https://${FORK}/compare/yasm:
  DEPS_FUNC build_yasm
  DEPS_VARS YASM_EXE
  )
########################################
function(build_yasm)
  if(NOT (XP_DEFAULT OR XP_PRO_YASM))
    return()
  endif()
  set(XP_CONFIGURE -DBUILD_SHARED_LIBS=OFF -DINSTALL_YASM_ONLY:BOOL=ON)
  set(BUILD_CONFIGS Release) # we only need a release executable
  xpCmakeBuild(yasm "" "${XP_CONFIGURE}" yasmTargets)
  if(ARGN)
    set(${ARGN} "${yasmTargets}" PARENT_SCOPE)
    if(WIN32)
      set(ext ".exe")
    endif()
    set(YASM_EXE ${STAGE_DIR}/bin/yasm${ext} PARENT_SCOPE)
  endif()
endfunction()
