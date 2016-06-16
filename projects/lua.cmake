# lua
xpProOption(lua)
set(VER 5.2.3)
set(REPO https://github.com/smanders/lua)
set(PRO_LUA
  NAME lua
  WEB "Lua" http://www.lua.org/ "Lua website"
  LICENSE "open" http://www.lua.org/license.html "MIT license"
  DESC "a powerful, fast, lightweight, embeddable scripting language"
  REPO "repo" ${REPO} "forked lua repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/lua.git
  GIT_UPSTREAM git://github.com/LuaDist/lua.git
  GIT_TAG xp${VER}
  GIT_REF ${VER}
  # NOTE: the tar.gz from lua.org doesn't have the cmake (and several other files)
  #DLURL http://www.lua.org/ftp/lua-${VER}.tar.gz
  #DLMD5 dc7f94ec6ff15c985d2d6ad0f1b35654
  DLURL ${REPO}/archive/${VER}.tar.gz
  DLMD5 710bba91186bb672b829cd05d78b614d
  DLNAME lua-${VER}.tar.gz
  PATCH ${PATCH_DIR}/lua.patch
  DIFF ${REPO}/compare/LuaDist:
  SUBPRO luabridge
  )
########################################
function(build_lua)
  if(NOT (XP_DEFAULT OR XP_PRO_LUA))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-lua-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE
    -DBUILD_SHARED_LIBS=OFF
    -DLUA_USE_READLINE=OFF
    -DLUA_USE_CURSES=OFF
    )
  xpCmakeBuild(lua "" "${XP_CONFIGURE}")
endfunction()
