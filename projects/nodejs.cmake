# nodejs
set(NODEJS_OLDVER 14.17.0)
set(NODEJS_NEWVER 14.17.0)
####################
xpProOption(nodejs)
set(PRO_NODEJS
  NAME nodejs
  NO_README
  DEPS_FUNC build_nodejs_all
  BUILD_DEPS nodejs_${NODEJS_OLDVER} nodejs_${NODEJS_NEWVER}
  )
function(build_nodejs_all)
  xpBuildDeps(depTgts ${PRO_NODEJS})
  if(ARGN)
    set(${ARGN} "${depsTgts}" PARENT_SCOPE)
  endif()
endfunction()
####################
function(build_nodejs)
  if(NOT (XP_DEFAULT OR XP_PRO_NODEJS_${NODEJS_OLDVER} OR XP_PRO_NODEJS_${NODEJS_NEWVER}))
    return()
  endif()
  find_package(PythonInterp)
  if(NOT PYTHONINTERP_FOUND)
    message(AUTHOR_WARNING "Unable to build nodejs, required python not found")
    return()
  endif()
  if(WIN32)
    if(NOT (XP_DEFAULT OR XP_PRO_NASM))
      message(STATUS "nodejs.cmake: requires nasm")
      set(XP_PRO_NASM ON CACHE BOOL "include nasm" FORCE)
      xpPatchProject(${PRO_NASM})
    endif()
  endif()
  if(XP_DEFAULT)
    set(NODEJS_VERSIONS ${NODEJS_OLDVER} ${NODEJS_NEWVER})
  else()
    if(XP_PRO_NODEJS_${NODEJS_OLDVER})
      set(NODEJS_VERSIONS ${NODEJS_OLDVER})
    endif()
    if(XP_PRO_NODEJS_${NODEJS_NEWVER})
      list(APPEND NODEJS_VERSIONS ${NODEJS_NEWVER})
    endif()
  endif()
  list(REMOVE_DUPLICATES NODEJS_VERSIONS)
  list(LENGTH NODEJS_VERSIONS NUM_VER)
  if(NUM_VER EQUAL 1)
    if(NODEJS_VERSIONS VERSION_EQUAL NODEJS_OLDVER)
      set(boolean OFF)
    else() # NODEJS_VERSIONS VERSION_EQUAL NODEJS_NEWVER
      set(boolean ON)
    endif()
    set(ONE_VER "set(XP_USE_LATEST_NODE ${boolean}) # currently only one version supported\n")
  endif()
  set(MOD_OPT "set(VER_MOD)")
  set(USE_SCRIPT_INSERT ${ONE_VER}${MOD_OPT})
  configure_file(${PRO_DIR}/use/usexp-node-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  foreach(ver ${NODEJS_VERSIONS})
    build_nodejs_ver(${ver})
  endforeach()
endfunction()
####################
function(build_nodejs_ver ver)
  # TODO: support Debug by renaming files going into STAGE_DIR?
  set(BUILD_CONFIGS Release)
  set(nodejs_${ver}_DEPS nodejs_${ver})
  if(${CMAKE_SYSTEM_PROCESSOR} MATCHES "arm")
    if(${BUILD_PLATFORM} STREQUAL "64")
      set(destcpu arm64)
    elseif(${BUILD_PLATFORM} STREQUAL "32")
      set(destcpu arm)
    endif()
  elseif(${CMAKE_SYSTEM_PROCESSOR} MATCHES "aarch64")
    set(destcpu arm64)
  else()
    if(${BUILD_PLATFORM} STREQUAL "64")
      set(destcpu x64)
    elseif(${BUILD_PLATFORM} STREQUAL "32")
      set(destcpu ia32)
    else()
      message(FATAL_ERROR "nodejs.cmake: cpu")
    endif()
  endif()
  if(MSVC)
    set(XP_CONFIGURE_BASE vcbuild)
    set(XP_CONFIGURE_Release ${XP_CONFIGURE_BASE} release ${destcpu})
    set(XP_CONFIGURE_Debug ${XP_CONFIGURE_BASE} debug ${destcpu})
  elseif(UNIX)
    if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
      set(destos linux)
    elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
      set(destos mac)
    else()
      message(FATAL_ERROR "nodejs.cmake: os")
    endif()
    list(APPEND XP_CONFIGURE_BASE <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --without-etw --without-dtrace
      # TODO: explore --tag=TAG custom build tag
      # TODO: explore --fully-static
      --dest-cpu=${destcpu} --dest-os=${destos}
      )
    set(XP_CONFIGURE_Release ${XP_CONFIGURE_BASE})
    set(XP_CONFIGURE_Debug ${XP_CONFIGURE_BASE} --debug --gdb)
  else()
    message(FATAL_ERROR "nodejs.cmake: unsupported OS platform")
  endif()
  foreach(cfg ${BUILD_CONFIGS})
    set(XP_CONFIGURE_CMD ${XP_CONFIGURE_${cfg}})
    addproject_nodejs(nodejs_${ver} ${cfg})
  endforeach() # cfg
  # copy headers to STAGE_DIR
  ExternalProject_Get_Property(nodejs_${ver} SOURCE_DIR)
  set(nodejsHdrs ${SOURCE_DIR}/src/*.h)
  set(uvDir ${SOURCE_DIR}/deps/uv/include)
  set(v8Hdrs ${SOURCE_DIR}/deps/v8/include/*.h)
  set(XP_TARGET nodejs_${ver}_stage)
  if(NOT TARGET ${XP_TARGET})
    ExternalProject_Add(${XP_TARGET} DEPENDS ${nodejs_${ver}_DEPS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} BINARY_DIR ${NULL_DIR}
      SOURCE_DIR ${NULL_DIR} INSTALL_DIR ${STAGE_DIR}/include/node_${ver}/node
      CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy_directory ${uvDir} <INSTALL_DIR>
      BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${nodejsHdrs}
        -Ddst:STRING=<INSTALL_DIR> -P ${MODULES_DIR}/cmscopyfiles.cmake
      INSTALL_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${v8Hdrs}
        -Ddst:STRING=<INSTALL_DIR> -P ${MODULES_DIR}/cmscopyfiles.cmake
      )
    set_property(TARGET ${XP_TARGET} PROPERTY FOLDER ${bld_folder})
  endif()
endfunction()
####################
macro(addproject_nodejs basename cfg)
  set(XP_TARGET ${basename}_${cfg})
  ExternalProject_Get_Property(${basename} SOURCE_DIR)
  set(nodejsSrcDir ${SOURCE_DIR})
  if(NOT TARGET ${XP_TARGET})
    if(XP_BUILD_VERBOSE)
      message(STATUS "target ${XP_TARGET}")
      xpVerboseListing("[CONFIGURE]" "${XP_CONFIGURE_CMD}")
    else()
      message(STATUS "target ${XP_TARGET}")
    endif()
    if(MSVC)
      # TRICKY: vcbuild doesn't seem to return a good exit status or something...
      #   MSVC thinks it always needs to build this (after what appears to be a
      #   successful build) -- and there can't be any external project steps
      #   after the step with vcbuild or they won't execute
      ExternalProject_Add(${XP_TARGET}vcbuild DEPENDS ${nodejs_${ver}_DEPS}
        DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
        SOURCE_DIR ${nodejsSrcDir} INSTALL_DIR ${NULL_DIR}
        CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
        BUILD_IN_SOURCE 1 # <BINARY_DIR>==<SOURCE_DIR>
        )
      set_property(TARGET ${XP_TARGET}vcbuild PROPERTY FOLDER ${bld_folder})
      list(APPEND nodejs_${ver}_DEPS ${XP_TARGET}vcbuild) # serialize the build
      set(binNode <SOURCE_DIR>/${cfg}/node.exe)
      set(libNode <SOURCE_DIR>/${cfg}/node.lib)
      set(XP_CONFIGURE_CMD ${CMAKE_COMMAND} -E echo "Configure MSVC...")
      set(XP_BUILD_CMD ${CMAKE_COMMAND} -E make_directory ${STAGE_DIR}/node_${ver}/lib)
      set(XP_INSTALL_CMD ${CMAKE_COMMAND} -E copy ${libNode} ${STAGE_DIR}/node_${ver}/lib)
    elseif(UNIX)
      set(binNode <SOURCE_DIR>/out/${cfg}/node)
      set(XP_BUILD_CMD)   # use default
      set(XP_INSTALL_CMD) # use default
    endif()
    ExternalProject_Add(${XP_TARGET} DEPENDS ${nodejs_${ver}_DEPS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
      SOURCE_DIR ${nodejsSrcDir} INSTALL_DIR ${NULL_DIR}
      CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
      BUILD_COMMAND ${XP_BUILD_CMD}
      BUILD_IN_SOURCE 1 # <BINARY_DIR>==<SOURCE_DIR>
      INSTALL_COMMAND ${XP_INSTALL_CMD}
      )
    ExternalProject_Add_Step(${XP_TARGET} copy_bin
      COMMAND ${CMAKE_COMMAND} -E make_directory ${STAGE_DIR}/node_${ver}/bin
      COMMAND ${CMAKE_COMMAND} -E copy ${binNode} ${STAGE_DIR}/node_${ver}/bin
      DEPENDEES install
      )
    set_property(TARGET ${XP_TARGET} PROPERTY FOLDER ${bld_folder})
  endif()
  list(APPEND nodejs_${ver}_DEPS ${XP_TARGET}) # serialize the build
endmacro()
