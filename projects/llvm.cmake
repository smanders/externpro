# llvm
xpProOption(llvm)
set(VER 11.0.0)
set(REPO github.com/llvm/llvm-project)
set(PRO_LLVM
  NAME llvm
  WEB "LLVM" http://llvm.org/ "LLVM website"
  LICENSE "open" https://releases.llvm.org/${VER}/LICENSE.TXT "Apache License v2.0 with LLVM Exceptions"
  DESC "The LLVM Compiler Infrastructure"
  REPO "repo" https://${REPO} "llvm repo on github"
  GRAPH GRAPH_SHAPE box
  VER ${VER}
  GIT_ORIGIN https://${REPO}.git
  GIT_TAG llvmorg-${VER}
  DLURL https://${REPO}/releases/download/llvmorg-${VER}/llvm-${VER}.src.tar.xz
  DLMD5 85844102335b2e01b3c64b6734fb56f2
  SUBPRO clang
  )
########################################
function(build_llvm)
  if(NOT (XP_DEFAULT OR XP_PRO_LLVM))
    return()
  endif()
  find_package(PythonInterp)
  if(NOT PYTHONINTERP_FOUND)
    message(AUTHOR_WARNING "Unable to build llvm/clang tools, required python not found")
    return()
  endif()
  set(XP_DEPS llvm llvm_clang)
  set(XP_CONFIGURE -DLLVM_TARGETS_TO_BUILD:STRING=X86)
  set(BUILD_CONFIGS Release) # only need release builds of clang tool executables
  xpCmakeBuild(llvm "${XP_DEPS}" "${XP_CONFIGURE}" llvmTgt NO_INSTALL BUILD_TARGET clang-format TGT format)
  if(ARGN)
    set(${ARGN} "${llvmTgt}" PARENT_SCOPE)
  endif()
endfunction()
