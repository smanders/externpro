# llvm
xpProOption(llvm)
set(VER 3.9.0)
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "release_\\1\\2" LLVM_BRANCH ${VER})
set(REPO github.com/llvm-mirror/llvm)
set(PRO_LLVM
  NAME llvm
  WEB "LLVM" http://llvm.org/ "LLVM website"
  LICENSE "open" http://llvm.org/svn/llvm-project/llvm/trunk/LICENSE.TXT "LLVM Release License"
  DESC "The LLVM Compiler Infrastructure"
  REPO "repo" https://${REPO} "llvm repo on github"
  GRAPH GRAPH_SHAPE box
  VER ${VER}
  GIT_ORIGIN git://${REPO}.git
  GIT_TAG ${LLVM_BRANCH}
  DLURL http://llvm.org/releases/${VER}/llvm-${VER}.src.tar.xz
  DLMD5 f2093e98060532449eb7d2fcfd0bc6c6
  SUBPRO clang clangtoolsextra
  )
########################################
function(build_llvm)
  if(NOT (XP_DEFAULT OR XP_PRO_LLVM))
    return()
  endif()
  find_package(PythonInterp 2.7)
  if(NOT PYTHONINTERP_FOUND)
    message(AUTHOR_WARNING "Unable to build llvm/clang tools, required python not found")
    return()
  endif()
  set(XP_DEPS llvm llvm_clang llvm_clangtoolsextra)
  set(XP_CONFIGURE -DLLVM_TARGETS_TO_BUILD:STRING=X86)
  set(BUILD_CONFIGS Release) # only need release builds of clang tool executables
  option(XP_BUILD_CLANGTIDY "build all of llvm to get clang-tidy" OFF)
  mark_as_advanced(XP_BUILD_CLANGTIDY)
  if(XP_BUILD_CLANGTIDY)
    xpCmakeBuild(llvm "${XP_DEPS}" "${XP_CONFIGURE}" llvmTgt NO_INSTALL)
  else()
    xpCmakeBuild(llvm "${XP_DEPS}" "${XP_CONFIGURE}" llvmTgt NO_INSTALL BUILD_TARGET clang-format TGT format)
  endif()
  if(ARGN)
    set(${ARGN} "${llvmTgt}" PARENT_SCOPE)
  endif()
endfunction()
