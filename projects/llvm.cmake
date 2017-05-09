# llvm
xpProOption(llvm)
set(VER 3.9.0)
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "release_\\1\\2" LLVM_BRANCH ${VER})
set(REPO https://github.com/llvm-mirror/llvm)
set(PRO_LLVM
  NAME llvm
  WEB "LLVM" http://llvm.org/ "LLVM website"
  LICENSE "open" http://llvm.org/svn/llvm-project/llvm/trunk/LICENSE.TXT "LLVM Release License"
  DESC "The LLVM Compiler Infrastructure"
  REPO "repo" ${REPO} "llvm repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/llvm-mirror/llvm.git
  GIT_TAG ${LLVM_BRANCH}
  DLURL http://llvm.org/releases/${VER}/llvm-${VER}.src.tar.xz
  DLMD5 f2093e98060532449eb7d2fcfd0bc6c6
  SUBPRO clang clangtoolsextra
  )
