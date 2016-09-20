# cmakexp
xpProOption(cmakexp)
set(VER 3.6.2)
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1.\\2" VER2 ${VER})
set(REPO https://github.com/smanders/CMake)
set(PRO_CMAKEXP
  NAME cmakexp
  WEB "CMake" http://cmake.org/ "CMake website"
  LICENSE "open" http://www.cmake.org/cmake/project/license.html "CMake License"
  DESC "the cross-platform, open-source build system"
  REPO "repo" ${REPO} "forked CMake repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/CMake.git
  GIT_UPSTREAM git://github.com/Kitware/CMake.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://www.cmake.org/files/v${VER2}/cmake-${VER}.tar.gz
  DLMD5 139d7affdd4e8ab1edfc9f4322d69e43
  PATCH ${PATCH_DIR}/cmakexp.patch
  DIFF ${REPO}/compare/Kitware:
  )
########################################
function(build_cmakexp)
  if(NOT (XP_DEFAULT OR XP_PRO_CMAKEXP))
    return()
  endif()
  # don't build platforms that have an installer readily available
  # from http://cmake.org/download/
  if(${CMAKE_SYSTEM_NAME} STREQUAL Windows OR ${CMAKE_SYSTEM_NAME} STREQUAL Darwin)
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_OPENSSL))
    message(STATUS "cmakexp.cmake: requires openssl")
    set(XP_PRO_OPENSSL ON CACHE BOOL "include openssl" FORCE)
    xpPatchProject(${PRO_OPENSSL})
  endif()
  build_openssl(osslTgts)
  # check if Curses is installed so we can build ccmake
  find_package(Curses QUIET)
  if(NOT CURSES_FOUND)
    message(AUTHOR_WARNING "\n"
      "curses not found -- ccmake can't be built. install on linux:\n"
      "  apt install libncurses5-dev\n"
      "  yum install ncurses-devel\n"
      )
  else()
    # TRICKY: this should be marked as advanced by FindCurses.cmake, but isn't as of v3.6.2
    mark_as_advanced(CURSES_FORM_LIBRARY)
  endif()
  # we only need a release version
  xpBuildOnlyRelease()
  set(XP_CONFIGURE
    -DCPACK_OUTPUT_FILE_PREFIX:PATH=${STAGE_DIR}/pkg
    -DCMAKE_USE_OPENSSL=ON
    -DCMAKE_USE_OPENSSL_MODULE_PATH=ON
    -Dusexp-OpenSSL_DIR=${STAGE_DIR}/share/cmake
    )
  xpCmakeBuild(cmakexp "${osslTgts}" "${XP_CONFIGURE}" cmakexpTgts NO_INSTALL)
  xpCmakePackage("${cmakexpTgts}" pkgTgts)
  if(ARGN)
    list(APPEND cmakexpTgts ${pkgTgts})
    set(${ARGN} "${cmakexpTgts}" PARENT_SCOPE)
  endif()
endfunction()
