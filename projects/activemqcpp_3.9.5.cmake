# activemqcpp
set(VER 3.9.5)
xpProOption(activemqcpp_${VER} DBG)
set(PROJ activemq-cpp)
set(REPO https://github.com/smanders/${PROJ})
set(PRO_ACTIVEMQCPP_${VER}
  NAME activemqcpp_${VER}
  WEB "ActiveMQ-CPP" http://activemq.apache.org/cms/ "ActiveMQ CMS website"
  LICENSE "open" http://www.apache.org/licenses/LICENSE-2.0.html "Apache 2.0"
  DESC "ActiveMQ C++ Messaging Service (CMS) client library"
  REPO "repo" ${REPO} "forked ${PROJ} repo on github"
  GRAPH BUILD_DEPS apr openssl_1.1.1d
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/${PROJ}.git
  GIT_UPSTREAM git://github.com/apache/${PROJ}.git
  GIT_TAG xp-${VER} # what to 'git checkout'
  GIT_REF ${PROJ}-${VER} # create patch from this tag to 'git checkout'
  DLURL https://archive.apache.org/dist/activemq/${PROJ}/${VER}/${PROJ}-library-${VER}-src.tar.gz
  DLMD5 c758cc8f36505a48680d454e376f4203
  PATCH ${PATCH_DIR}/activemqcpp_${VER}.patch
  # TRICKY: PATCH_STRIP because the repo has an extra level of directories that the .tar.gz file doesn't have
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF ${REPO}/compare/apache:
  )
