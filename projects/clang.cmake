# clang
include(${CMAKE_CURRENT_LIST_DIR}/llvm.cmake)
xpGetArgValue(${PRO_LLVM} ARG VER VALUE llvmVer)
set(PRO_CLANG
  NAME clang
  SUPERPRO llvm
  SUBDIR tools/clang
  WEB "clang" http://clang.llvm.org/ "clang website"
  LICENSE "open" "http://clang.llvm.org/features.html#license" "LLVM 'Apache 2' License"
  DESC "clang: a C language family frontend for LLVM"
  GRAPH GRAPH_SHAPE box BUILD_DEPS llvm
  VER ${llvmVer}
  DLURL http://llvm.org/releases/${llvmVer}/cfe-${llvmVer}.src.tar.xz
  DLMD5 0df6971e2f99b1e99e7bfb533e4067af
  )
