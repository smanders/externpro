# luabridge
set(VER 2.0) # repo isn't tagged with version 2.0 - 1.0.2 was the last tag
set(TAG 04b47d723d35b47ff8efce63d54ef264a59152b5)
set(TAGDATE 131019) # 2013.10.19 commit, head of master branch on 2014.12.05
set(REPO https://github.com/smanders/LuaBridge)
set(PRO_LUABRIDGE
  NAME luabridge
  SUPERPRO lua
  WEB "LuaBridge" http://vinniefalco.com/LuaBridge/Manual.html "LuaBridge Reference Manual"
  LICENSE "open" "${REPO}#official-repository" "MIT license"
  DESC "a lightweight, dependency-free library for binding Lua to C++"
  REPO "repo" ${REPO} "forked LuaBridge repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/LuaBridge.git
  GIT_UPSTREAM git://github.com/vinniefalco/LuaBridge.git
  GIT_TAG xp${TAGDATE}
  GIT_REF ${TAG}
  DLURL ${REPO}/archive/${TAG}.tar.gz
  DLMD5 54e72d497c898b9c7a133c653878682e
  DLNAME LuaBridge-${VER}.tar.gz
  PATCH ${PATCH_DIR}/luabridge.patch
  DIFF ${REPO}/compare/vinniefalco:
  )
########################################
function(build_luabridge)
  if(NOT (XP_DEFAULT OR XP_PRO_LUA))
    return()
  endif()
  if(NOT TARGET lua)
    patch_lua()
  endif()
  if(NOT TARGET luabridge_bld)
    ExternalProject_Get_Property(lua SOURCE_DIR)
    ExternalProject_Add(luabridge_bld DEPENDS luabridge
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} CONFIGURE_COMMAND ""
      SOURCE_DIR ${SOURCE_DIR} BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
      BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory
        <SOURCE_DIR>/luabridge/Source ${STAGE_DIR}/include
      INSTALL_COMMAND ""
      )
    set_property(TARGET luabridge_bld PROPERTY FOLDER ${bld_folder})
    message(STATUS "target luabridge_bld")
  endif()
endfunction()
