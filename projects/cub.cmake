# cub
xpProOption(cub)
set(VER 1.8.0)
set(REPO github.com/NVlabs/cub)
set(PRO_CUB
  NAME cub
  WEB "CUB" http://nvlabs.github.io/cub/ "CUB Project Website"
  LICENSE "open" "https://${REPO}/tree/v${VER}#open-source-license" "BSD 3-Clause"
  DESC "flexible library of cooperative threadblock primitives and other utilites for CUDA kernel programming"
  REPO "repo" https://${REPO} "CUB repo on github"
  VER ${VER}
  GIT_ORIGIN https://${REPO}.git
  GIT_TAG v${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 9203ea2499b56782601fddf8a12e9b08
  DLNAME cub-v${VER}.tar.gz
  )
########################################
function(build_cub)
  if(NOT (XP_DEFAULT OR XP_PRO_CUB))
    return()
  endif()
  xpGetArgValue(${PRO_CUB} ARG VER VALUE VER)
  set(verDir /cub_${VER})
  configure_file(${PRO_DIR}/use/usexp-cub-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  ExternalProject_Get_Property(cub SOURCE_DIR)
  ExternalProject_Add(cub_bld DEPENDS cub
    DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} CONFIGURE_COMMAND ""
    SOURCE_DIR ${SOURCE_DIR} BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory
      <SOURCE_DIR>/cub ${STAGE_DIR}/include${verDir}/cub
    INSTALL_COMMAND ""
    )
  set_property(TARGET cub_bld PROPERTY FOLDER ${bld_folder})
  message(STATUS "target cub_bld")
endfunction()
