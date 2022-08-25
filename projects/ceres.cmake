# ceres
xpProOption(ceres DBG)
set(VER 1.14.0)
set(REPO github.com/ceres-solver/ceres-solver)
set(FORK github.com/smanders/ceres-solver)
set(PRO_CERES
  NAME ceres
  WEB "ceres-solver" http://ceres-solver.org "Ceres Solver website"
  LICENSE "open" "http://ceres-solver.org/license.html" "New BSD License"
  DESC "C++ library for modeling and solving large, complicated optimization problems"
  REPO "repo" https://${REPO} "ceres-solver repo on github"
  GRAPH BUILD_DEPS eigen
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${VER} # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/ceres.patch
  DIFF https://${FORK}/compare/ceres-solver:
  DLURL https://${REPO}/archive/${VER}.tar.gz
  DLMD5 c3a63fa496468cbe65536f1f34c5609b
  DLNAME ceres-solver-${VER}.tar.gz
  )
########################################
function(build_ceres)
  if(NOT (XP_DEFAULT OR XP_PRO_CERES))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_CERES}) # defines EIGEN_INCDIR
  xpGetArgValue(${PRO_CERES} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_CERES} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_NAMESPACE:STRING=xpro
    -DMINIGLOG:BOOL=ON
    -DGFLAGS:BOOL=OFF
    -DSUITESPARSE:BOOL=OFF
    -DCXSPARSE:BOOL=OFF
    -DLAPACK:BOOL=OFF
    -DCXX11:BOOL=ON
    -DOPENMP:BOOL=OFF
    -DCXX11_THREADS:BOOL=ON
    -DEIGENSPARSE:BOOL=ON # default as of 1.14.0
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DEIGEN_INCLUDE_DIR_HINTS:PATH=${STAGE_DIR}/${EIGEN_INCDIR}
    )
  if(MSVC)
    list(APPEND XP_CONFIGURE -DMSVC_USE_STATIC_CRT:BOOL=ON)
  elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    list(APPEND XP_CONFIGURE -DLIB_SUFFIX:STRING=) # lib, not lib64
  endif()
  set(FIND_DEPS "xpFindPkg(PKGS eigen) # dependencies\n")
  set(TARGETS_FILE lib/cmake/Ceres/CeresTargets.cmake)
  set(LIBRARIES xpro::${NAME})
  configure_file(${PRO_DIR}/use/usexp-template-lib-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}")
endfunction()
