# libssh2
set(LIBSSH2_OLDVER 1.5.0)
set(LIBSSH2_NEWVER 1.5.0)
########################################
function(build_libssh2)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBSSH2_${LIBSSH2_OLDVER} OR XP_PRO_LIBSSH2_${LIBSSH2_NEWVER}))
    return()
  endif()
  if(XP_DEFAULT)
    set(LIBSSH2_VERSIONS ${LIBSSH2_OLDVER} ${LIBSSH2_NEWVER})
  else()
    if(XP_PRO_LIBSSH2_${LIBSSH2_OLDVER})
      set(LIBSSH2_VERSIONS ${LIBSSH2_OLDVER})
    endif()
    if(XP_PRO_LIBSSH2_${LIBSSH2_NEWVER})
      list(APPEND LIBSSH2_VERSIONS ${LIBSSH2_NEWVER})
    endif()
  endif()
  list(REMOVE_DUPLICATES LIBSSH2_VERSIONS)
  list(LENGTH LIBSSH2_VERSIONS NUM_VER)
  if(NUM_VER EQUAL 1)
    if(LIBSSH2_VERSIONS EQUAL LIBSSH2_OLDVER)
      set(boolean OFF)
    else() # LIBSSH2_VERSIONS EQUAL LIBSSH2_NEWVER
      set(boolean ON)
    endif()
    set(ONE_VER "set(XP_USE_LATEST_LIBSSH2 ${boolean}) # currently only one version supported\n")
  endif()
  set(MOD_OPT "set(VER_MOD)")
  set(USE_SCRIPT_INSERT ${ONE_VER}${MOD_OPT})
  configure_file(${PRO_DIR}/use/usexp-libssh2-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  foreach(ver ${LIBSSH2_VERSIONS})
    xpBuildDeps(depTgts ${PRO_LIBSSH2_${ver}})
    set(XP_CONFIGURE
      -DCRYPTO_BACKEND:STRING=OpenSSL
      -DFIND_OPENSSL_MODULE_PATH=ON
      -DCMAKE_USE_ZLIB_MODULE_PATH=ON
      -DLIBSSH2_VER=${ver}
      )
    xpCmakeBuild(libssh2_${ver} "${depTgts}" "${XP_CONFIGURE}" libssh2Targets_${ver})
    list(APPEND libssh2Targets ${libssh2Targets_${ver}})
  endforeach()
  if(ARGN)
    set(${ARGN} "${libssh2Targets}" PARENT_SCOPE)
  endif()
endfunction()
