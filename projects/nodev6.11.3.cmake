set(VER 6.11.3)
xpProOption(nodev${VER})
set(REPO https://github.com/nodejs/node)
set(PRO_NODEV${VER}
  NAME nodev${VER}
  WEB "Node.js" http://nodejs.org "Node.js website"
  LICENSE "open" https://raw.githubusercontent.com/nodejs/node/v${VER}/LICENSE "MIT license"
  DESC "platform to build scalable network applications"
  REPO "repo" ${REPO} "node repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/nodejs/node.git
  GIT_TAG v${VER} # what to 'git checkout'
  DLURL http://nodejs.org/dist/v${VER}/node-v${VER}.tar.gz
  DLMD5 9503dc359b4cb3ac7d748d35331a5096
  )
