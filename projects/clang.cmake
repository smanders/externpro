# clang
include(${CMAKE_CURRENT_LIST_DIR}/llvm.cmake)
xpGetArgValue(${PRO_LLVM} ARG VER VALUE llvmVer)
xpGetArgValue(${PRO_LLVM} ARG GIT_TAG VALUE llvmTag)
set(REPO https://github.com/llvm-mirror/clang)
set(PRO_CLANG
  NAME clang
  SUPERPRO llvm
  SUBDIR tools/clang
  WEB "clang" http://clang.llvm.org/ "clang website"
  LICENSE "open" "http://clang.llvm.org/features.html#license" "LLVM 'BSD' License"
  DESC "clang: a C language family frontend for LLVM"
  REPO "repo" ${REPO} "clang repo on github"
  VER ${llvmVer}
  GIT_ORIGIN git://github.com/llvm-mirror/clang.git
  GIT_TAG ${llvmTag} # what to 'git checkout'
  DLURL http://llvm.org/releases/${llvmVer}/cfe-${llvmVer}.src.tar.xz
  DLMD5 29e1d86bee422ab5345f5e9fb808d2dc
  )
