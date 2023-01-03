# luabridge
set(VER 2.5)
set(REPO https://github.com/vinniefalco/LuaBridge)
set(PRO_LUABRIDGE
  NAME luabridge
  SUPERPRO lua
  WEB "LuaBridge" http://vinniefalco.github.io/LuaBridge/Manual.html "LuaBridge Reference Manual"
  LICENSE "open" "${REPO}#official-repository" "MIT license"
  DESC "a lightweight, dependency-free library for binding Lua to C++"
  REPO "repo" ${REPO} "LuaBridge repo on github"
  VER ${VER}
  GIT_ORIGIN ${REPO}
  GIT_TAG ${VER}
  DLURL ${REPO}/archive/${VER}.tar.gz
  DLMD5 3fda2f8e635cf0263cd9e4a696b4bfa2
  DLNAME LuaBridge-${VER}.tar.gz
  )
