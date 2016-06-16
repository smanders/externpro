# eigen
xpProOption(eigen)
set(VER 3.2.7)
set(PRO_EIGEN
  NAME Eigen
  WEB "Eigen" http://eigen.tuxfamily.org/ "Eigen website"
  LICENSE "open" "http://eigen.tuxfamily.org/index.php?title=Main_Page#License" "Eigen license: MPL2 (aka Mozilla Public License)"
  DESC "C++ template library for linear algebra"
  REPO "repo" https://bitbucket.org/eigen/eigen "eigen hg repo on bitbucket"
  VER ${VER}
  DLURL http://bitbucket.org/eigen/eigen/get/${VER}.tar.bz2
  DLMD5 cc1bacbad97558b97da6b77c9644f184
  DLNAME eigen-${VER}.tar.bz2
  )
########################################
function(build_eigen)
  if(NOT (XP_DEFAULT OR XP_PRO_EIGEN))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-eigen-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  # since eigen is currently header only, do a single build config
  set(BUILD_CONFIGS Release)
  xpCmakeBuild(eigen "" "" eigenTargets)
  if(ARGN)
    set(${ARGN} "${eigenTargets}" PARENT_SCOPE)
  endif()
endfunction()
