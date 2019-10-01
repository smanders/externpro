# eigen
xpProOption(eigen)
set(VER 3.2.7)
set(PRO_EIGEN
  NAME eigen
  WEB "Eigen" http://eigen.tuxfamily.org/ "Eigen website"
  LICENSE "open" "http://eigen.tuxfamily.org/index.php?title=Main_Page#License" "Eigen license: MPL2 (aka Mozilla Public License)"
  DESC "C++ template library for linear algebra"
  REPO "repo" https://bitbucket.org/eigen/eigen "eigen hg repo on bitbucket"
  GRAPH
  VER ${VER}
  DLURL http://bitbucket.org/eigen/eigen/get/${VER}.tar.bz2
  DLMD5 cc1bacbad97558b97da6b77c9644f184
  DLNAME eigen-${VER}.tar.bz2
  DEPS_FUNC build_eigen
  DEPS_VARS EIGEN_INCDIR
  )
########################################
function(build_eigen)
  if(NOT (XP_DEFAULT OR XP_PRO_EIGEN))
    return()
  endif()
  xpGetArgValue(${PRO_EIGEN} ARG VER VALUE VER)
  set(verDir /eigen_${VER})
  set(incDir include${verDir}/eigen3)
  set(XP_CONFIGURE -DEIGEN_BUILD_PKGCONFIG:BOOL=OFF -DEIGEN_INCLUDE_INSTALL_DIR:PATH=${incDir})
  configure_file(${PRO_DIR}/use/usexp-eigen-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(BUILD_CONFIGS Release) # this project is only copying headers
  xpCmakeBuild(eigen "" "${XP_CONFIGURE}" eigenTargets)
  if(ARGN)
    set(${ARGN} "${eigenTargets}" PARENT_SCOPE)
    set(EIGEN_INCDIR ${incDir} PARENT_SCOPE)
  endif()
endfunction()
