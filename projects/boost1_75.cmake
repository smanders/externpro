# boost
set(VER 1.75.0)
string(REPLACE "." "_" VER_ ${VER}) # 1_75_0
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1_\\2" VER2_ ${VER}) # 1_75
xpProOption(boost${VER2_})
set(REPO github.com/boostorg/boost)
set(PRO_BOOST${VER2_}
  NAME boost${VER2_}
  WEB "boost" http://www.boost.org/ "Boost website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "libraries that give C++ a boost"
  REPO "repo" https://${REPO} "boost repo on github"
  GRAPH GRAPH_NODE boost
  BUILD_DEPS zlib bzip2
  VER ${VER}
  GIT_ORIGIN git://${REPO}.git
  GIT_TAG boost-${VER} # what to 'git checkout'
  DLURL https://boostorg.jfrog.io/artifactory/main/release/${VER}/source/boost_${VER_}.tar.bz2
  DLMD5 ea217ed7c4414e93d44106c316966ae1
  SUBPRO boostgil${VER2_} boostunits${VER2_} boostinstall${VER2_}
  )
