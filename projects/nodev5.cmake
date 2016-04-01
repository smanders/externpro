########################################
# nodev5
xpProOption(nodev5)
set(VER 5.9.1)
set(REPO https://github.com/smanders/node)
set(PRO_NODEV5
  NAME nodev5
  WEB "Node.js" http://nodejs.org "Node.js website"
  LICENSE "open" https://raw.githubusercontent.com/nodejs/node/v${VER}/LICENSE "MIT license"
  DESC "platform to build scalable network applications"
  REPO "repo" ${REPO} "forked node repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/node.git
  GIT_UPSTREAM git://github.com/nodejs/node.git
  #GIT_TAG xp${VER} # what to 'git checkout'
  GIT_TAG v${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://nodejs.org/dist/v${VER}/node-v${VER}.tar.gz
  DLMD5 346c9325912271dc7614fe955c75c3a6
  #PATCH ${PATCH_DIR}/nodev5.patch
  #DIFF ${REPO}/compare/nodejs:
  )
########################################
function(mkpatch_nodev5)
  xpRepo(${PRO_NODEV5})
endfunction()
########################################
function(download_nodev5)
  xpNewDownload(${PRO_NODEV5})
endfunction()
########################################
function(patch_nodev5)
  xpPatch(${PRO_NODEV5})
endfunction()
########################################
function(build_nodev5)
  if(NOT (XP_DEFAULT OR XP_PRO_NODEV5))
    return()
  endif()
  build_node_ver(v5)
endfunction()
