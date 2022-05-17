# boost
set(VER 1.76.0)
string(REPLACE "." "_" VER_ ${VER}) # 1_76_0
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1_\\2" VER2_ ${VER}) # 1_76
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
  GIT_ORIGIN https://${REPO}.git
  GIT_TAG boost-${VER} # what to 'git checkout'
  DLURL https://boostorg.jfrog.io/artifactory/main/release/${VER}/source/boost_${VER_}.tar.bz2
  DLMD5 33334dd7f862e8ac9fe1cc7c6584fb6d
  DEPS_FUNC build_boost
  SUBPRO boostdll${VER2_} boostgil${VER2_} boostgraph${VER2_} boostinstall${VER2_} boostinterprocess${VER2_} boostprogram_options${VER2_} boostprogram_optionshpp${VER2_} boostregex${VER2_} boostunits${VER2_}
  )
