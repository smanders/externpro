# libgit2
set(VER 1.3.0)
xpProOption(libgit2 DBG)
set(REPO github.com/libgit2/libgit2)
set(FORK github.com/smanders/libgit2)
set(PRO_LIBGIT2
  NAME libgit2
  WEB "libgit2" https://libgit2.github.com/ "libgit2 website"
  LICENSE "open" "https://${REPO}/blob/master/README.md#license" "GPL2 with linking exception"
  DESC "portable, pure C implementation of the Git core methods"
  REPO "repo" https://${REPO} "libgit2 repo on github"
  GRAPH BUILD_DEPS libssh2
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH main
  GIT_TAG xp${VER}
  GIT_REF v${VER}
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 c8b6658e421d51f0e1a5fe0c17fc41dc
  DLNAME libgit2-${VER}.tar.gz
  PATCH ${PATCH_DIR}/libgit2.patch
  DIFF https://${FORK}/compare/libgit2:
  )
########################################
function(build_libgit2)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBGIT2))
    return()
  endif()
  if(WIN32)
    set(depTgts)
  else()
    xpBuildDeps(depTgts ${PRO_LIBGIT2})
  endif()
  xpGetArgValue(${PRO_LIBGIT2} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_LIBGIT2} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_NAMESPACE:STRING=xpro
    -DBUILD_CLAR:BOOL=OFF
    -DBUILD_SHARED_LIBS=OFF
    -DREGEX_BACKEND=builtin
    -DTHREADSAFE=ON
    )
  if(WIN32)
    list(APPEND XP_CONFIGURE
      -DXP_SKIP_MSVC_FLAGS=ON
      )
  endif()
  set(FIND_DEPS "xpFindPkg(PKGS libssh2) # dependency\n")
  set(TARGETS_FILE lib/cmake/${NAME}-targets.cmake)
  set(LIBRARIES xpro::git2)
  configure_file(${PRO_DIR}/use/usexp-template-lib-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}")
endfunction()
