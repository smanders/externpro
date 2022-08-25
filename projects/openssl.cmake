# openssl
set(BRANCH 1.1.1)
set(VER ${BRANCH}l)
xpProOption(openssl DBG)
string(REPLACE "." "_" VER_ ${VER})
set(REPO github.com/openssl/openssl)
set(FORK github.com/smanders/openssl)
set(PRO_OPENSSL
  NAME openssl
  WEB "OpenSSL" http://www.openssl.org/ "OpenSSL website"
  LICENSE "open" http://www.openssl.org/source/license.html "OpenSSL, SSLeay License: BSD-style"
  DESC "Cryptography and SSL/TLS Toolkit"
  REPO "repo" https://${REPO} "openssl repo on github"
  GRAPH BUILD_DEPS opensslasm nasm
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp_${VER_} # what to 'git checkout'
  GIT_REF OpenSSL_${VER_} # create patch from this tag to 'git checkout'
  #DLURL https://www.openssl.org/source/old/${BRANCH}/openssl-${VER}.tar.gz
  DLURL https://www.openssl.org/source/openssl-${VER}.tar.gz
  DLMD5 ac0d4387f3ba0ad741b0580dd45f6ff3
  PATCH ${PATCH_DIR}/openssl_${VER}.patch
  DIFF https://${FORK}/compare/openssl:
  DEPS_FUNC build_openssl
  SUBPRO opensslasm
  )
########################################
function(build_openssl)
  if(NOT (XP_DEFAULT OR XP_PRO_OPENSSL))
    return()
  endif()
  if(WIN32)
    if(NOT (XP_DEFAULT OR XP_PRO_NASM))
      message(STATUS "openssl.cmake: requires nasm")
      set(XP_PRO_NASM ON CACHE BOOL "include nasm" FORCE)
      xpPatchProject(${PRO_NASM})
    endif()
    ExternalProject_Get_Property(nasm SOURCE_DIR)
    set(NASM_EXE "-DCMAKE_ASM_NASM_COMPILER=${SOURCE_DIR}/nasm.exe")
  endif()
  xpGetArgValue(${PRO_OPENSSL} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_OPENSSL} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_NAMESPACE:STRING=xpro
    ${NASM_EXE}
    )
  set(FIND_DEPS "set(THREAD_PREFER_PTHREAD_FLAG ON)\nfind_package(Threads REQUIRED) # crypto depends on Threads::Threads\n")
  set(TARGETS_FILE lib/cmake/${NAME}-targets.cmake)
  set(LIBRARIES "xpro::crypto xpro::ssl")
  configure_file(${PRO_DIR}/use/usexp-template-lib-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
