# sodium
xpProOption(sodium DBG)
set(VER 21.11.18)
set(TAG aa099f5e82ae78175f9c1c48372a123cb634dd92) # 2021.11.18 commit, head of stable branch
set(REPO github.com/jedisct1/libsodium)
set(FORK github.com/smanders/libsodium)
set(PRO_SODIUM
  NAME sodium
  WEB "sodium" https://doc.libsodium.org/ "libsodium website"
  LICENSE "open" "https://doc.libsodium.org/#license" "ISC license"
  DESC "library for encryption, decryption, signatures, password hashing and more"
  REPO "repo" https://${REPO} "libsodium repo on github"
  GRAPH
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF ${TAG} # create patch from this tag to 'git checkout'
  DLURL https://${REPO}/archive/${TAG}.tar.gz
  DLMD5 44dc8965223c87b10321d18a15616d8f
  DLNAME libsodium-${VER}.tar.gz
  PATCH ${PATCH_DIR}/sodium.patch
  DIFF https://${FORK}/compare/jedisct1:
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
    -DXP_NAMESPACE:STRING=xpro
    )
  set(FIND_DEPS "set(THREAD_PREFER_PTHREAD_FLAG ON)\nfind_package(Threads REQUIRED) # ${NAME} depends on Threads::Threads\n")
  set(TARGETS_FILE lib/cmake/${NAME}-targets.cmake)
  set(LIBRARIES xpro::${NAME})
  configure_file(${PRO_DIR}/use/usexp-template-lib-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-sodium-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(sodium "" "${XP_CONFIGURE}" sodiumTargets)
  if(ARGN)
    set(${ARGN} "${sodiumTargets}" PARENT_SCOPE)
  endif()
endfunction()
