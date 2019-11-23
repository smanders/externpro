# cmakexp
xpProOption(cmakexp)
set(VER 3.12.0)
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1.\\2" VER2 ${VER})
set(REPO github.com/Kitware/CMake)
set(FORK github.com/smanders/CMake)
set(PRO_CMAKEXP
  NAME cmakexp
  WEB "CMake" http://cmake.org/ "CMake website"
  LICENSE "open" http://www.cmake.org/cmake/project/license.html "CMake License"
  DESC "the cross-platform, open-source build system"
  REPO "repo" https://${REPO} "CMake repo on github"
  GRAPH GRAPH_SHAPE box BUILD_DEPS openssl_1.1.1d
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://www.cmake.org/files/v${VER2}/cmake-${VER}.tar.gz
  DLMD5 ab4aa7df9301c94cdd6f8ee4fe66458b
  PATCH ${PATCH_DIR}/cmakexp.patch
  DIFF https://${FORK}/compare/Kitware:
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
  xpBuildDeps(depTgts ${PRO_CMAKEXP})
  option(XP_BUILD_CCMAKE "build ccmake as part of cmakexp project" ON)
  mark_as_advanced(XP_BUILD_CCMAKE)
  if(XP_BUILD_CCMAKE)
    # check if Curses is installed so we can build ccmake
    find_package(Curses QUIET)
    if(NOT CURSES_FOUND)
      message(FATAL_ERROR "\n"
        "curses not found -- ccmake can't be built. install on linux:\n"
        "  apt install libncurses5-dev\n"
        "  yum install ncurses-devel\n"
        "or set advanced cmake option XP_BUILD_CCMAKE=OFF\n"
        )
    endif()
  endif()
  set(XP_CONFIGURE
    -DCPACK_OUTPUT_FILE_PREFIX:PATH=${STAGE_DIR}/pkg
    -DCPACK_RPM_EXCLUDE_FROM_AUTO_FILELIST_ADDITION=/usr/share/aclocal
    -DCMAKE_USE_OPENSSL=ON
    -DCMAKE_USE_OPENSSL_MODULE_PATH=ON
    -Dusexp-OpenSSL_DIR=${STAGE_DIR}/share/cmake
    -DXP_USE_LATEST_OPENSSL=ON
    )
  set(BUILD_CONFIGS Release) # we only need a release version
  xpCmakeBuild(cmakexp "${depTgts}" "${XP_CONFIGURE}" cmakexpTgts NO_INSTALL)
  xpCmakePackage("${cmakexpTgts}" pkgTgts)
  if(ARGN)
    list(APPEND cmakexpTgts ${pkgTgts})
    set(${ARGN} "${cmakexpTgts}" PARENT_SCOPE)
  endif()
endfunction()
