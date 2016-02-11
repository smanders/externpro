########################################
# llvm
xpProOption(llvm)
set(VER 3.6.0)
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
  DLMD5 f1e14e949f8df3047c59816c55278cec
  )
########################################
function(mkpatch_llvm)
  xpRepo(${PRO_LLVM})
endfunction()
########################################
function(download_llvm)
  xpNewDownload(${PRO_LLVM})
endfunction()
########################################
function(patch_llvm)
  xpPatch(${PRO_LLVM})
  xpPatch(${PRO_CLANG})
endfunction()
