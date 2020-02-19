# libgit2
set(LIBGIT2_OLDVER 0.28.3)
set(LIBGIT2_NEWVER 0.28.3)
########################################
function(build_libgit2)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBGIT2_${LIBGIT2_OLDVER} OR XP_PRO_LIBGIT2_${LIBGIT2_NEWVER}))
    return()
  endif()
  if(XP_DEFAULT)
    set(LIBGIT2_VERSIONS ${LIBGIT2_OLDVER} ${LIBGIT2_NEWVER})
  else()
    if(XP_PRO_LIBGIT2_${LIBGIT2_OLDVER})
      set(LIBGIT2_VERSIONS ${LIBGIT2_OLDVER})
    endif()
    if(XP_PRO_LIBGIT2_${LIBGIT2_NEWVER})
      list(APPEND LIBGIT2_VERSIONS ${LIBGIT2_NEWVER})
    endif()
  endif()
  list(REMOVE_DUPLICATES LIBGIT2_VERSIONS)
  list(LENGTH LIBGIT2_VERSIONS NUM_VER)
  if(NUM_VER EQUAL 1)
    if(LIBGIT2_VERSIONS VERSION_EQUAL LIBGIT2_OLDVER)
      set(boolean OFF)
    else() # LIBGIT2_VERSIONS VERSION_EQUAL LIBGIT2_NEWVER
      set(boolean ON)
    endif()
    set(ONE_VER "set(XP_USE_LATEST_LIBGIT2 ${boolean}) # currently only one version supported\n")
  endif()
  if(WIN32)
    set(MOD_OPT "set(VER_MOD)")
    set(VER_CFG xpConfigBase)
  elseif(FALSE)
    # build multiple versions against different versions of openssl/libssh2
    set(MOD_OLD _ossl10)
    set(MOD_NEW _ossl11)
    set(MOD_OPT "if(XP_USE_LATEST_OPENSSL)\n  set(VER_MOD ${MOD_NEW})\nelse()\n  set(VER_MOD ${MOD_OLD})\nendif()")
    set(VER_CFG ${MOD_OLD} ${MOD_NEW})
  elseif(FALSE)
    # build against single versions of openssl/libssh2
    set(MOD_OLD _ossl10)
    set(MOD_OPT "set(VER_MOD ${MOD_OLD})")
    set(VER_CFG ${MOD_OLD})
  else()
    set(MOD_OPT "set(VER_MOD)")
    set(VER_CFG xpConfigBase)
  endif()
  set(USE_SCRIPT_INSERT ${ONE_VER}${MOD_OPT})
  configure_file(${PRO_DIR}/use/usexp-libgit2-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  if(NOT WIN32)
    set(XP_CONFIGURE_${LIBGIT2_OLDVER}
      )
    set(XP_CONFIGURE_${LIBGIT2_NEWVER}
      )
    set(${MOD_OLD}
      -DXP_USE_LATEST_OPENSSL:BOOL=OFF
      -DXP_USE_LATEST_LIBSSH2:BOOL=OFF
      -DVER_MOD:STRING=${MOD_OLD}
      )
    set(${MOD_NEW}
      -DXP_USE_LATEST_OPENSSL:BOOL=ON
      -DXP_USE_LATEST_LIBSSH2:BOOL=ON
      -DVER_MOD:STRING=${MOD_NEW}
      )
  endif()
  foreach(ver ${LIBGIT2_VERSIONS})
    if(WIN32)
      set(depTgts)
    else()
      xpBuildDeps(depTgts ${PRO_LIBGIT2_${ver}})
    endif()
    set(xpConfigBase
      -DBUILD_CLAR:BOOL=OFF
      -DBUILD_SHARED_LIBS=OFF
      -DTHREADSAFE=ON
      -DINSTALL_LIBGIT2_CONFIG=OFF
      -DXP_NAMESPACE:STRING=xpro
      -DLIBGIT2_VER=${ver}
      )
    if(WIN32)
      list(APPEND xpConfigBase
        -DSKIP_MSVC_FLAGS=ON
        )
    else()
      list(APPEND xpConfigBase
        -DOPENSSL_MODULE_PATH=ON
        -DZLIB_MODULE_PATH=ON
        -DLIBSSH2_MODULE_PATH=ON
        ${XP_CONFIGURE_${ver}}
        )
    endif()
    foreach(cfg ${VER_CFG})
      list(INSERT ${cfg} 0 ${xpConfigBase})
      list(REMOVE_DUPLICATES ${cfg})
      build_libgit2_ver(${ver} ${cfg})
    endforeach()
  endforeach()
endfunction()
function(build_libgit2_ver ver cfg)
  if(${cfg} STREQUAL xpConfigBase)
    xpCmakeBuild(libgit2_${ver} "${depTgts}" "${${cfg}}")
  else()
    xpCmakeBuild(libgit2_${ver} "${depTgts}" "${${cfg}}" "" TGT ${cfg})
  endif()
endfunction()
