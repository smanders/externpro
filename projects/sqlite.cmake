# SQLite
# xpbuild:cmake-patch
xpProOption(sqlite DBG)
set(REPO https://github.com/azadkuh/sqlite-amalgamation)
set(FORK https://github.com/externpro/sqlite-amalgamation)
set(VER 3.37.2)
set(PRO_SQLITE
  NAME sqlite
  WEB "SQLite" https://www.sqlite.org/index.html "SQLite website"
  LICENSE "open" https://www.sqlite.org/copyright.html "Public Domain"
  DESC "C-language library that implements a small, fast, self-contained, high-reliability, full-featured, SQL database engine"
  REPO "repo" ${REPO} "sqlite-amalgamation repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/${VER}.tar.gz
  DLMD5 3c0ea08d0fdadb8927d536a50a3967aa
  DLNAME sqlite-${VER}.tar.gz
  PATCH ${PATCH_DIR}/sqlite.patch
  DIFF ${FORK}/compare/
  )
########################################
function(build_sqlite)
  if(NOT (XP_DEFAULT OR XP_PRO_SQLITE))
    return()
  endif()
  xpGetArgValue(${PRO_SQLITE} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_SQLITE} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    -DBUILD_SHELL=ON
    )
  set(TARGETS_FILE tgt-${NAME}/SQLite3Config.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::SQLite3)\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
endfunction()
