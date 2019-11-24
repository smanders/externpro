# ceres
xpProOption(ceres DBG)
set(VER 1.14.0)
set(REPO github.com/ceres-solver/ceres-solver)
set(FORK github.com/smanders/ceres-solver)
set(PRO_CERES
  NAME ceres
  WEB "ceres-solver" http://ceres-solver.org "Ceres Solver website"
  # https://choosealicense.com/licenses/bsd-3-clause/
  LICENSE "BSD 3-Clause" "http://ceres-solver.org/license.html" "BSD 3-Clause New or Revised License"
  DESC "C++ library for modeling and solving large, complicated optimization problems"
  REPO "repo" https://${REPO} "ceres-solver repo on github"
  GRAPH BUILD_DEPS eigen
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
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
  xpGetArgValue(${PRO_CERES} ARG VER VALUE VER)
  set(XP_CONFIGURE
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
    -DCERES_VER:STRING=${VER}
    )
  if(MSVC)
    list(APPEND XP_CONFIGURE -DMSVC_USE_STATIC_CRT:BOOL=ON)
  elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    list(APPEND XP_CONFIGURE -DLIB_SUFFIX:STRING=) # install to lib, not lib64
  endif()
  configure_file(${PRO_DIR}/use/usexp-ceres-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(ceres "${depTgts}" "${XP_CONFIGURE}")
endfunction()
