# curl
set(CURL_OLDVER 7.42.1)
set(CURL_NEWVER 7.42.1)
########################################
function(build_curl)
  if(NOT (XP_DEFAULT OR XP_PRO_CURL_${CURL_OLDVER} OR XP_PRO_CURL_${CURL_NEWVER}))
    return()
  endif()
  if(XP_DEFAULT)
    set(CURL_VERSIONS ${CURL_OLDVER} ${CURL_NEWVER})
  else()
    if(XP_PRO_CURL_${CURL_OLDVER})
      set(CURL_VERSIONS ${CURL_OLDVER})
    endif()
    if(XP_PRO_CURL_${CURL_NEWVER})
      list(APPEND CURL_VERSIONS ${CURL_NEWVER})
    endif()
  endif()
  list(REMOVE_DUPLICATES CURL_VERSIONS)
  list(LENGTH CURL_VERSIONS NUM_VER)
  if(NUM_VER EQUAL 1)
    if(CURL_VERSIONS EQUAL CURL_OLDVER)
      set(boolean OFF)
    else() # CURL_VERSIONS EQUAL CURL_NEWVER
      set(boolean ON)
    endif()
    set(ONE_VER "set(XP_USE_LATEST_CURL ${boolean}) # currently only one version supported\n")
  endif()
  set(MOD_OPT "set(VER_MOD)")
  set(USE_SCRIPT_INSERT ${ONE_VER}${MOD_OPT})
  configure_file(${PRO_DIR}/use/usexp-curl-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  if(XP_DEFAULT OR XP_PRO_CMAKEXP)
    # if we're building cmake, we want it built before curl
    # otherwise cmake finds externpro curl and not it's own internal cmcurl
    build_cmakexp(cmTgts)
  endif()
  foreach(ver ${CURL_VERSIONS})
    xpBuildDeps(depTgts ${PRO_CURL_${ver}})
    list(APPEND depTgts ${cmTgts})
    set(XP_CONFIGURE
      -DCURL_VER=${ver}
      -DBUILD_CURL_EXE=ON
      -DBUILD_CURL_TESTS=OFF
      -DINSTALL_CURL_CONFIG=OFF
      -DCURL_STATICLIB=ON
      -DENABLE_ARES=ON
      -DFIND_ARES_MODULE_PATH=ON
      -DCURL_ZLIB_MODULE_PATH=ON
      -DCMAKE_USE_OPENSSL_MODULE_PATH=ON
      -DCMAKE_USE_LIBSSH2_MODULE_PATH=ON
      -DCURL_DISABLE_LDAP=ON
      -DENABLE_LIBIDN=OFF
      -DXP_USE_LATEST_OPENSSL=OFF
      -DXP_USE_LATEST_LIBSSH2=OFF
      )
    xpCmakeBuild(curl_${ver} "${depTgts}" "${XP_CONFIGURE}")
  endforeach()
endfunction()
