# openssl
# xpbuild:cmake-scratch
set(BRANCH 1.1.1)
set(VER ${BRANCH}l)
xpProOption(openssl DBG)
string(REPLACE "." "_" VER_ ${VER})
set(REPO https://github.com/openssl/openssl)
set(FORK https://github.com/externpro/openssl)
set(PRO_OPENSSL
  NAME openssl
  WEB "OpenSSL" http://www.openssl.org/ "OpenSSL website"
  LICENSE "open" http://www.openssl.org/source/license.html "OpenSSL, SSLeay License: BSD-style"
  DESC "Cryptography and SSL/TLS Toolkit"
  REPO "repo" ${REPO} "openssl repo on github"
  GRAPH BUILD_DEPS opensslasm
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp_${VER_} # what to 'git checkout'
  GIT_REF OpenSSL_${VER_} # create patch from this tag to 'git checkout'
  #DLURL https://www.openssl.org/source/old/${BRANCH}/openssl-${VER}.tar.gz
  DLURL https://www.openssl.org/source/openssl-${VER}.tar.gz
  DLMD5 ac0d4387f3ba0ad741b0580dd45f6ff3
  PATCH ${PATCH_DIR}/openssl.patch
  DIFF ${FORK}/compare/openssl:
  DEPS_FUNC build_openssl
  SUBPRO opensslasm
  )
########################################
function(build_openssl)
  if(NOT (XP_DEFAULT OR XP_PRO_OPENSSL))
    return()
  endif()
  if(WIN32)
    xpBuildDeps(depTgts ${PRO_OPENSSL})
    xpFindPkg(PKGS nasm)
    xpGetPkgVar(nasm EXE) # sets NASM_EXE
    set(NASM_PATH "-DCMAKE_ASM_NASM_COMPILER=${NASM_EXE}")
  endif()
  xpGetArgValue(${PRO_OPENSSL} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_OPENSSL} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    ${NASM_PATH}
    )
  set(FIND_DEPS "set(THREAD_PREFER_PTHREAD_FLAG ON)\n")
  set(FIND_DEPS "${FIND_DEPS}find_package(Threads REQUIRED)")
  set(FIND_DEPS "${FIND_DEPS} # crypto depends on Threads::Threads\n")
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::crypto xpro::ssl)\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "${depTgts}" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
