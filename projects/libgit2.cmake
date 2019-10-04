# libgit2
xpProOption(libgit2 DBG)
set(REPO https://github.com/smanders/libgit2)
set(VER 0.22.2)
set(PRO_LIBGIT2
  NAME libgit2
  WEB "libgit2" https://libgit2.github.com/ "libgit2 website"
  LICENSE "open" "https://github.com/libgit2/libgit2/blob/master/README.md#license" "GPL2 with linking exception"
  DESC "portable, pure C implementation of the Git core methods"
  REPO "repo" ${REPO} "forked libgit2 repo on github"
  GRAPH BUILD_DEPS libssh2_1.9.0
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/libgit2.git
  GIT_UPSTREAM git://github.com/libgit2/libgit2.git
  GIT_TAG xp${VER}
  GIT_REF v${VER}
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 67e0aca83964bfbb5c8806854f13fa41
  DLNAME libgit2-${VER}.tar.gz
  PATCH ${PATCH_DIR}/libgit2.patch
  DIFF ${REPO}/compare/libgit2:
  )
########################################
function(build_libgit2)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBGIT2))
    return()
  endif()
  xpGetArgValue(${PRO_LIBGIT2} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DBUILD_SHARED_LIBS=OFF
    -DTHREADSAFE=ON
    -DINSTALL_LIBGIT2_CONFIG=OFF
    -DLIBGIT2_VER=${VER}
    )
  if(WIN32)
    set(depTgts)
    list(APPEND XP_CONFIGURE
      -DSKIP_MSVC_FLAGS=ON
      )
  else()
    xpBuildDeps(depTgts ${PRO_LIBGIT2})
    list(APPEND XP_CONFIGURE
      -DXP_USE_LATEST_OPENSSL=ON
      -DXP_USE_LATEST_LIBSSH2=ON
      -DOPENSSL_MODULE_PATH=ON
      -DZLIB_MODULE_PATH=ON
      -DLIBSSH2_MODULE_PATH=ON
      )
  endif()
  configure_file(${PRO_DIR}/use/usexp-libgit2-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(libgit2 "${depTgts}" "${XP_CONFIGURE}")
endfunction()
