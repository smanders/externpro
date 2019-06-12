set(VER 10.15.2)
xpProOption(node_${VER})
set(REPO https://github.com/nodejs/node)
set(PRO_NODE_${VER}
  NAME node_${VER}
  WEB "Node.js" http://nodejs.org "Node.js website"
  LICENSE "open" https://raw.githubusercontent.com/nodejs/node/v${VER}/LICENSE "MIT license"
  DESC "platform to build scalable network applications"
  REPO "repo" ${REPO} "node repo on github"
  GRAPH GRAPH_NODE nodejs GRAPH_DEPS nasm
  VER ${VER}
  GIT_ORIGIN git://github.com/nodejs/node.git
  GIT_TAG v${VER} # what to 'git checkout'
  DLURL http://nodejs.org/dist/v${VER}/node-v${VER}.tar.gz
  DLMD5 4ecb2ff4c835a669502ad98437c75123
  )
