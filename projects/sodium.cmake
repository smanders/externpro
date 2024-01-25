# sodium
# xpbuild:cmake-scratch
xpProOption(sodium DBG)
set(VER 21.11.18)
set(TAG aa099f5e82ae78175f9c1c48372a123cb634dd92) # 2021.11.18 commit, head of stable branch
set(REPO https://github.com/jedisct1/libsodium)
set(FORK https://github.com/externpro/libsodium)
set(PRO_SODIUM
  NAME sodium
  WEB "sodium" https://doc.libsodium.org/ "libsodium website"
  LICENSE "open" "https://doc.libsodium.org/#license" "ISC license"
  DESC "library for encryption, decryption, signatures, password hashing and more"
  REPO "repo" ${REPO} "libsodium repo on github"
  GRAPH
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${TAG} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/${TAG}.tar.gz
  DLMD5 44dc8965223c87b10321d18a15616d8f
  DLNAME libsodium-${VER}.tar.gz
  PATCH ${PATCH_DIR}/sodium.patch
  DIFF ${FORK}/compare/jedisct1:
  DEPS_FUNC build_sodium
  )
########################################
function(build_sodium)
  if(NOT (XP_DEFAULT OR XP_PRO_SODIUM))
    return()
  endif()
  xpGetArgValue(${PRO_SODIUM} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_SODIUM} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DCMAKE_INSTALL_LIBDIR=lib
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(FIND_DEPS "set(THREAD_PREFER_PTHREAD_FLAG ON)\n")
  set(FIND_DEPS "${FIND_DEPS}find_package(Threads REQUIRED)")
  set(FIND_DEPS "${FIND_DEPS} # ${NAME} depends on Threads::Threads\n")
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME})\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}" ${NAME}Targets)
  if(ARGN)
    set(${ARGN} "${${NAME}Targets}" PARENT_SCOPE)
  endif()
endfunction()
