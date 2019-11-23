# clang
include(${CMAKE_CURRENT_LIST_DIR}/llvm.cmake)
xpGetArgValue(${PRO_LLVM} ARG VER VALUE llvmVer)
set(REPO github.com/llvm-mirror/clang)
set(FORK github.com/smanders/clang)
set(PRO_CLANG
  NAME clang
  SUPERPRO llvm
  SUBDIR tools/clang
  WEB "clang" http://clang.llvm.org/ "clang website"
  LICENSE "open" "http://clang.llvm.org/features.html#license" "LLVM 'BSD' License"
  DESC "clang: a C language family frontend for LLVM"
  REPO "repo" https://${REPO} "clang repo on github"
  GRAPH GRAPH_SHAPE box BUILD_DEPS llvm
  VER ${llvmVer}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  # NOTE: forked repo (we used to patch clang), upstream doesn't have tag
  GIT_TAG v${llvmVer} # what to 'git checkout'
  DLURL http://llvm.org/releases/${llvmVer}/cfe-${llvmVer}.src.tar.xz
  DLMD5 29e1d86bee422ab5345f5e9fb808d2dc
  )
