set(VER 10.16.0)
xpProOption(node_${VER})
set(REPO github.com/nodejs/node)
set(PRO_NODE_${VER}
  NAME node_${VER}
  WEB "Node.js" http://nodejs.org "Node.js website"
  LICENSE "open" https://raw.githubusercontent.com/nodejs/node/v${VER}/LICENSE "MIT license"
  DESC "platform to build scalable network applications"
  REPO "repo" https://${REPO} "node repo on github"
  GRAPH GRAPH_NODE nodejs GRAPH_DEPS nasm
  VER ${VER}
  GIT_ORIGIN git://${REPO}.git
  GIT_TAG v${VER} # what to 'git checkout'
  DLURL http://nodejs.org/dist/v${VER}/node-v${VER}.tar.gz
  DLMD5 46f47630e088540968962f1ad71b9d0a
  )
