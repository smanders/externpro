# luabridge
set(VER 2.0) # repo isn't tagged with version 2.0 - 1.0.2 was the last tag
set(TAG 244f9b35498feab3039a58ffb258367d7bc054ac) # 2017.03.31 commit, head of master branch on 2017.09.28
set(REPO https://github.com/vinniefalco/LuaBridge)
set(PRO_LUABRIDGE
  NAME luabridge
  SUPERPRO lua
  WEB "LuaBridge" http://vinniefalco.github.io/LuaBridge/Manual.html "LuaBridge Reference Manual"
  LICENSE "open" "${REPO}#official-repository" "MIT license"
  DESC "a lightweight, dependency-free library for binding Lua to C++"
  REPO "repo" ${REPO} "LuaBridge repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/vinniefalco/LuaBridge.git
  GIT_TAG ${TAG}
  DLURL ${REPO}/archive/${TAG}.tar.gz
  DLMD5 0ac0ac198ec37ad5782dd5269ebbbe23
  DLNAME LuaBridge-${VER}p.tar.gz
  )
