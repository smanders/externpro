# yasm
# xpbuild:cmake-patch
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
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
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
  find_package(PythonInterp)
  if(NOT PYTHONINTERP_FOUND)
    message(FATAL_ERROR "Unable to build yasm, required python not found")
    return()
  endif()
  xpGetArgValue(${PRO_YASM} ARG NAME VALUE NAME)
  set(XP_CONFIGURE
    -DXP_INSTALL_YASM_EXE_ONLY:BOOL=ON
    -DBUILD_SHARED_LIBS:BOOL=OFF
    )
  set(BUILD_CONFIGS Release) # we only need a release executable
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
    set(YASM_EXE ${STAGE_DIR}/bin/${NAME}${CMAKE_EXECUTABLE_SUFFIX} PARENT_SCOPE)
  endif()
endfunction()
