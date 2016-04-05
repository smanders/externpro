########################################
# nodev0
xpProOption(nodev0)
set(VER 0.12.7)
set(REPO https://github.com/smanders/node)
set(PRO_NODEV0
  NAME nodev0
  WEB "Node.js" http://nodejs.org "Node.js website"
  LICENSE "open" https://raw.githubusercontent.com/nodejs/node/v${VER}/LICENSE "MIT license"
  DESC "platform to build scalable network applications"
  REPO "repo" ${REPO} "forked node repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/node.git
  GIT_UPSTREAM git://github.com/nodejs/node.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://nodejs.org/dist/v${VER}/node-v${VER}.tar.gz
  DLMD5 5523ec4347d7fe6b0f6dda1d1c7799d5
  PATCH ${PATCH_DIR}/nodev0.patch
  DIFF ${REPO}/compare/nodejs:
  )
########################################
function(mkpatch_nodev0)
  xpRepo(${PRO_NODEV0})
endfunction()
########################################
function(download_nodev0)
  xpNewDownload(${PRO_NODEV0})
endfunction()
########################################
function(patch_nodev0)
  xpPatch(${PRO_NODEV0})
endfunction()
########################################
function(build_nodev0)
  if(NOT (XP_DEFAULT OR XP_PRO_NODEV0))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_NODEV5))
    # use script requires both versions to be built
    message(STATUS "nodev0.cmake: requires nodev5")
    set(XP_PRO_NODEV5 ON CACHE BOOL "include nodev5" FORCE)
    patch_nodev5()
    build_nodev5()
  endif()
  build_node_ver(v0 CUR NEW)
endfunction()
