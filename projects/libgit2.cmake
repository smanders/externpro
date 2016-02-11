########################################
# libgit2
xpProOption(libgit2)
set(REPO https://github.com/smanders/libgit2)
set(VER 0.22.2)
set(PRO_LIBGIT2
  NAME libgit2
  WEB "libgit2" https://libgit2.github.com/ "libgit2 website"
  LICENSE "open" "https://github.com/libgit2/libgit2/blob/master/README.md#license" "GPL2 with linking exception"
  DESC "portable, pure C implementation of the Git core methods"
  REPO "repo" ${REPO} "forked libgit2 repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/libgit2.git
  GIT_UPSTREAM git://github.com/libgit2/libgit2.git
  GIT_TAG xp${VER}
  GIT_REF v${VER}
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 7b21448c471dc76a3ca4801b61ac856a
  DLNAME libgit2-${VER}.tar.gz
  PATCH ${PATCH_DIR}/libgit2.patch
  DIFF ${REPO}/compare/libgit2:
  )
########################################
function(mkpatch_libgit2)
  xpRepo(${PRO_LIBGIT2})
endfunction()
########################################
function(download_libgit2)
  xpNewDownload(${PRO_LIBGIT2})
endfunction()
########################################
function(patch_libgit2)
  xpPatch(${PRO_LIBGIT2})
endfunction()
########################################
function(build_libgit2)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBGIT2))
    return()
  endif()
  set(XP_CONFIGURE
    -DBUILD_SHARED_LIBS=OFF
    -DTHREADSAFE=ON
    )
  if(WIN32)
    set(libssh2Tgts)
    list(APPEND XP_CONFIGURE
      -DSKIP_MSVC_FLAGS=ON
      )
  else()
    if(NOT (XP_DEFAULT OR XP_PRO_LIBSSH2))
      message(STATUS "libgit2.cmake: requires libssh2")
      set(XP_PRO_LIBSSH2 ON CACHE BOOL "include libssh2" FORCE)
      patch_libssh2()
    endif()
    build_libssh2(libssh2Tgts)
    list(APPEND XP_CONFIGURE
      -DOPENSSL_MODULE_PATH=ON
      -DZLIB_MODULE_PATH=ON
      -DLIBSSH2_MODULE_PATH=ON
      )
  endif()
  configure_file(${PRO_DIR}/use/usexp-libgit2-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(libgit2 "${libssh2Tgts}" "${XP_CONFIGURE}")
endfunction()
