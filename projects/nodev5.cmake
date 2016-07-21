# nodev5
xpProOption(nodev5)
set(VER 5.10.1)
set(REPO https://github.com/nodejs/node)
set(PRO_NODEV5
  NAME nodev5
  WEB "Node.js" http://nodejs.org "Node.js website"
  LICENSE "open" https://raw.githubusercontent.com/nodejs/node/v${VER}/LICENSE "MIT license"
  DESC "platform to build scalable network applications"
  REPO "repo" ${REPO} "node repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/nodejs/node.git
  GIT_TAG v${VER} # what to 'git checkout'
  #GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://nodejs.org/dist/v${VER}/node-v${VER}.tar.gz
  DLMD5 1378c65a30b5ebcd3a2fc7384477379e
  #PATCH ${PATCH_DIR}/nodev5.patch
  #DIFF ${REPO}/compare/nodejs:
  )
