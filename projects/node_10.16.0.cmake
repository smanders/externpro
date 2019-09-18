set(VER 10.16.0)
xpProOption(node_${VER})
set(REPO github.com/nodejs/node)
set(FORK github.com/smanders/node)
set(PRO_NODE_${VER}
  NAME node_${VER}
  WEB "Node.js" http://nodejs.org "Node.js website"
  LICENSE "open" https://raw.githubusercontent.com/nodejs/node/v${VER}/LICENSE "MIT license"
  DESC "platform to build scalable network applications"
  REPO "repo" https://${REPO} "node repo on github"
  GRAPH GRAPH_NODE nodejs BUILD_DEPS nasm
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/node_${VER}.patch
  DIFF https://${FORK}/compare/nodejs:
  DLURL http://nodejs.org/dist/v${VER}/node-v${VER}.tar.gz
  DLMD5 46f47630e088540968962f1ad71b9d0a
  )
