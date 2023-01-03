# lua
# xpbuild:cmake-patch
xpProOption(lua DBG)
set(VER 5.2.3)
set(REPO https://github.com/LuaDist/lua)
set(FORK https://github.com/smanders/lua)
set(PRO_LUA
  NAME lua
  WEB "Lua" http://www.lua.org/ "Lua website"
  LICENSE "open" http://www.lua.org/license.html "MIT license"
  DESC "a powerful, fast, lightweight, embeddable scripting language"
  REPO "repo" ${REPO} "lua repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER}
  GIT_REF ${VER}
  # NOTE: the tar.gz from lua.org doesn't have the cmake (and several other files)
  #DLURL http://www.lua.org/ftp/lua-${VER}.tar.gz
  #DLMD5 dc7f94ec6ff15c985d2d6ad0f1b35654
  DLURL ${REPO}/archive/${VER}.tar.gz
  DLMD5 710bba91186bb672b829cd05d78b614d
  DLNAME lua-${VER}.tar.gz
  PATCH ${PATCH_DIR}/lua.patch
  DIFF ${FORK}/compare/LuaDist:
  SUBPRO luabridge
  )
########################################
function(build_lua)
  if(NOT (XP_DEFAULT OR XP_PRO_LUA))
    return()
  endif()
  xpGetArgValue(${PRO_LUA} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_LUA} ARG VER VALUE VER)
  xpGetArgValue(${PRO_LUABRIDGE} ARG VER VALUE VERB)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DBUILD_SHARED_LIBS=OFF
    -DLUA_USE_READLINE=OFF
    -DLUA_USE_CURSES=OFF
    -DLUABRIDGE_INCDIR:STRING=include/luabridge_${VERB}
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_EXE xpro::${NAME})\n")
  set(USE_VARS "${USE_VARS}set(${PRJ}_LIBRARIES xpro::lib${NAME})\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_EXE ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
  if(NOT TARGET luabridge_bld)
    ExternalProject_Get_Property(${NAME} SOURCE_DIR)
    ExternalProject_Add(${NAME}_luabridge_bld DEPENDS ${NAME}_luabridge
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} CONFIGURE_COMMAND ""
      SOURCE_DIR ${SOURCE_DIR} BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
      BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory
        <SOURCE_DIR>/luabridge/Source ${STAGE_DIR}/include/luabridge_${VERB}
      INSTALL_COMMAND ""
      )
    set_property(TARGET ${NAME}_luabridge_bld PROPERTY FOLDER ${bld_folder})
    message(STATUS "target ${NAME}_luabridge_bld")
  endif()
endfunction()
