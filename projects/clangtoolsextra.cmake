# clang-tools-extra
include(${CMAKE_CURRENT_LIST_DIR}/llvm.cmake)
xpGetArgValue(${PRO_LLVM} ARG VER VALUE llvmVer)
xpGetArgValue(${PRO_LLVM} ARG GIT_TAG VALUE llvmBranch)
set(REPO github.com/llvm-mirror/clang-tools-extra)
set(PRO_CLANGTOOLSEXTRA
  NAME clangtoolsextra
  SUPERPRO llvm
  SUBDIR tools/clang/tools/extra
  WEB "clang-tools-extra" http://clang.llvm.org/docs/ClangTools.html "clang-tools-extra website"
  LICENSE "open" "http://clang.llvm.org/features.html#license" "LLVM 'BSD' License"
  DESC "Clang Tools: standalone command line (and potentially GUI) tools designed for use by C++ developers"
  REPO "repo" https://${REPO} "clang-tools-extra repo on github"
  GRAPH GRAPH_SHAPE box BUILD_DEPS llvm
  VER ${llvmVer}
  GIT_ORIGIN git://${REPO}.git
  GIT_TAG ${LLVM_BRANCH} # what to 'git checkout'
  DLURL http://llvm.org/releases/${llvmVer}/clang-tools-extra-${llvmVer}.src.tar.xz
  DLMD5 f4f663068c77fc742113211841e94d5e
  )
