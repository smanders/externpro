# boost
set(VER 1.57.0)
string(REPLACE "." "_" VER_ ${VER}) # 1_57_0
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1_\\2" VER2_ ${VER}) # 1_57
xpProOption(boost${VER2_})
set(REPO https://github.com/boostorg/boost)
set(PRO_BOOST${VER2_}
  NAME boost${VER2_}
  WEB "boost" http://www.boost.org/ "Boost website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "libraries that give C++ a boost"
  REPO "repo" ${REPO} "boost repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/boostorg/boost.git
  GIT_TAG boost-${VER} # what to 'git checkout'
  DLURL http://downloads.sourceforge.net/project/boost/boost/${VER}/boost_${VER_}.tar.bz2
  DLMD5 1be49befbdd9a5ce9def2983ba3e7b76
  SUBPRO boostconfig${VER2_} boostgil${VER2_} boostlog${VER2_} boostmpl${VER2_} boostunits${VER2_}
  )
