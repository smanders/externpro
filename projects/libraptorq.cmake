########################################
# libRaptorQ
xpProOption(libraptorq)
set(REPO https://github.com/smanders/libRaptorQ)
set(VER 0.1.4)
set(PRO_LIBRAPTORQ
  NAME libraptorq
  WEB "libRaptorQ" https://www.fenrirproject.org/projects/libraptorq/wiki "libRaptorQ wiki"
  LICENSE "open" https://github.com/LucaFulchir/libRaptorQ/blob/master/LICENSE.lgpl3.txt "LGPL3"
  DESC "RaptorQ is a Forward Error Correction algorithm, implements RFC6330"
  REPO "repo" ${REPO} "forked libRaptorQ repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/libRaptorQ.git
  GIT_UPSTREAM git://github.com/LucaFulchir/libRaptorQ.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 ec0af3ca687bfd5c446ca5eccef4c1e1
  DLNAME libraptorq-${VER}.tar.gz
  PATCH ${PATCH_DIR}/libraptorq.patch
  DIFF ${REPO}/compare/LucaFulchir:
  )
########################################
function(mkpatch_libraptorq)
  xpRepo(${PRO_LIBRAPTORQ})
endfunction()
########################################
function(download_libraptorq)
  xpNewDownload(${PRO_LIBRAPTORQ})
endfunction()
########################################
function(patch_libraptorq)
  xpPatch(${PRO_LIBRAPTORQ})
endfunction()
########################################
function(build_libraptorq)
  if(NOT (XP_DEFAULT OR XP_PRO_LIBRAPTORQ))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_EIGEN))
    message(STATUS "libraptorq.cmake: requires eigen")
    set(XP_PRO_EIGEN ON CACHE BOOL "include eigen" FORCE)
    patch_eigen()
  endif()
  build_eigen(eigenTgts)
  set(XP_CONFIGURE
    -DOVERRIDE_CMAKE_GENERATOR=OFF
    -DPROFILING=OFF
    -DBUILD_SHARED_LIB=OFF
    )
  if(${CMAKE_SYSTEM_NAME} STREQUAL SunOS OR ${CMAKE_SYSTEM_NAME} STREQUAL Darwin)
    # TODO: Solaris and MacOSX linker error when LTO turned ON
    list(APPEND XP_CONFIGURE -DLTO=OFF)
  else()
    list(APPEND XP_CONFIGURE -DLTO=ON)
  endif()
  configure_file(${PRO_DIR}/use/usexp-libraptorq-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(libraptorq "${eigenTgts}" "${XP_CONFIGURE}")
endfunction()
