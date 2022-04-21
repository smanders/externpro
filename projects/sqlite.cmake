# SQLite
xpProOption(sqlite DBG)
set(REPO github.com/azadkuh/sqlite-amalgamation)
set(FORK github.com/smanders/sqlite-amalgamation)
set(VER 3.37.2)
set(PRO_SQLITE
  NAME sqlite
  WEB "SQLite" https://www.sqlite.org/index.html "SQLite website"
  LICENSE "open" https://www.sqlite.org/copyright.html "Public Domain"
  DESC "C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine"
  REPO "repo" https://${REPO} "sqlite-amalgamation repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${VER} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/${VER}.tar.gz
  DLMD5 3c0ea08d0fdadb8927d536a50a3967aa
  DLNAME sqlite-${VER}.tar.gz
  PATCH ${PATCH_DIR}/sqlite.patch
  DIFF https://${FORK}/compare/
  )
########################################
function(build_sqlite)
  if(NOT (XP_DEFAULT OR XP_PRO_SQLITE))
    return()
  endif()
  xpGetArgValue(${PRO_SQLITE} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_LIBDIR=lib # without this *some* platforms (RHEL, but not Ubuntu) install to lib64
    -DCMAKE_INSTALL_INCLUDEDIR=include/sqlite_${VER}
    -DBUILD_SHELL=ON
    -DSQLITE_VER=${VER}
    -DXP_NAMESPACE:STRING=xpro
    )
  configure_file(${PRO_DIR}/use/usexp-sqlite-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(sqlite "" "${XP_CONFIGURE}")
endfunction()
