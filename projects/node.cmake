# node
set(NODE_OLDVER 10.17.0)
set(NODE_NEWVER 10.17.0)
####################
function(build_node)
  if(NOT (XP_DEFAULT OR XP_PRO_NODE_${NODE_OLDVER} OR XP_PRO_NODE_${NODE_NEWVER}))
    return()
  endif()
  find_package(PythonInterp)
  if(NOT PYTHONINTERP_FOUND)
    message(AUTHOR_WARNING "Unable to build node, required python not found")
    return()
  endif()
  if(WIN32)
    if(NOT (XP_DEFAULT OR XP_PRO_NASM))
      message(STATUS "node.cmake: requires nasm")
      set(XP_PRO_NASM ON CACHE BOOL "include nasm" FORCE)
      xpPatchProject(${PRO_NASM})
    endif()
  endif()
  if(XP_DEFAULT)
    set(NODE_VERSIONS ${NODE_OLDVER} ${NODE_NEWVER})
  else()
    if(XP_PRO_NODE_${NODE_OLDVER})
      set(NODE_VERSIONS ${NODE_OLDVER})
    endif()
    if(XP_PRO_NODE_${NODE_NEWVER})
      list(APPEND NODE_VERSIONS ${NODE_NEWVER})
    endif()
  endif()
  list(REMOVE_DUPLICATES NODE_VERSIONS)
  list(LENGTH NODE_VERSIONS NUM_VER)
  if(NUM_VER EQUAL 1)
    if(NODE_VERSIONS EQUAL NODE_OLDVER)
      set(boolean OFF)
    else() # NODE_VERSIONS EQUAL NODE_NEWVER
      set(boolean ON)
    endif()
    set(ONE_VER "set(XP_USE_LATEST_NODE ${boolean}) # currently only one version supported\n")
  endif()
  set(MOD_OPT "set(VER_MOD)")
  set(USE_SCRIPT_INSERT ${ONE_VER}${MOD_OPT})
  configure_file(${PRO_DIR}/use/usexp-node-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  foreach(ver ${NODE_VERSIONS})
    build_node_ver(${ver})
  endforeach()
endfunction()
####################
function(build_node_ver ver)
  # TODO: support Debug by renaming files going into STAGE_DIR?
  set(BUILD_CONFIGS Release)
  set(node_${ver}_DEPS node_${ver})
  if(${CMAKE_SYSTEM_PROCESSOR} MATCHES "arm")
    if(${BUILD_PLATFORM} STREQUAL "64")
      set(destcpu arm64)
    elseif(${BUILD_PLATFORM} STREQUAL "32")
      set(destcpu arm)
    endif()
  else()
    if(${BUILD_PLATFORM} STREQUAL "64")
      set(destcpu x64)
    elseif(${BUILD_PLATFORM} STREQUAL "32")
      set(destcpu ia32)
    else()
      message(FATAL_ERROR "node.cmake: cpu")
    endif()
  endif()
  if(MSVC)
    set(XP_CONFIGURE_BASE vcbuild nosign)
    set(XP_CONFIGURE_Release ${XP_CONFIGURE_BASE} release ${destcpu})
    set(XP_CONFIGURE_Debug ${XP_CONFIGURE_BASE} debug ${destcpu})
  elseif(UNIX)
    if(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
      set(destos linux)
    elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
      set(destos mac)
    else()
      message(FATAL_ERROR "node.cmake: os")
    endif()
    list(APPEND XP_CONFIGURE_BASE <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --without-etw --without-perfctr --without-dtrace
      # TODO: explore --tag=TAG custom build tag
      # TODO: explore --fully-static
      --dest-cpu=${destcpu} --dest-os=${destos}
      )
    set(XP_CONFIGURE_Release ${XP_CONFIGURE_BASE})
    set(XP_CONFIGURE_Debug ${XP_CONFIGURE_BASE} --debug --gdb)
  else()
    message(FATAL_ERROR "node.cmake: unsupported OS platform")
  endif()
  foreach(cfg ${BUILD_CONFIGS})
    set(XP_CONFIGURE_CMD ${XP_CONFIGURE_${cfg}})
    addproject_node(node_${ver} ${cfg})
  endforeach() # cfg
  # copy headers to STAGE_DIR
  ExternalProject_Get_Property(node_${ver} SOURCE_DIR)
  set(nodeHdrs ${SOURCE_DIR}/src/*.h)
  set(uvDir ${SOURCE_DIR}/deps/uv/include)
  set(v8Hdrs ${SOURCE_DIR}/deps/v8/include/*.h)
  set(XP_TARGET node_${ver}_stage)
  if(NOT TARGET ${XP_TARGET})
    ExternalProject_Add(${XP_TARGET} DEPENDS ${node_${ver}_DEPS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} BINARY_DIR ${NULL_DIR}
      SOURCE_DIR ${NULL_DIR} INSTALL_DIR ${STAGE_DIR}/include/node_${ver}/node
      CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy_directory ${uvDir} <INSTALL_DIR>
      BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${nodeHdrs}
        -Ddst:STRING=<INSTALL_DIR> -P ${MODULES_DIR}/cmscopyfiles.cmake
      INSTALL_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${v8Hdrs}
        -Ddst:STRING=<INSTALL_DIR> -P ${MODULES_DIR}/cmscopyfiles.cmake
      )
    set_property(TARGET ${XP_TARGET} PROPERTY FOLDER ${bld_folder})
  endif()
endfunction()
####################
macro(addproject_node basename cfg)
  set(XP_TARGET ${basename}_${cfg})
  ExternalProject_Get_Property(${basename} SOURCE_DIR)
  set(nodeSrcDir ${SOURCE_DIR})
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
      ExternalProject_Add(${XP_TARGET}vcbuild DEPENDS ${node_${ver}_DEPS}
        DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
        SOURCE_DIR ${nodeSrcDir} INSTALL_DIR ${NULL_DIR}
        CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
        BUILD_IN_SOURCE 1 # <BINARY_DIR>==<SOURCE_DIR>
        )
      set_property(TARGET ${XP_TARGET}vcbuild PROPERTY FOLDER ${bld_folder})
      list(APPEND node_${ver}_DEPS ${XP_TARGET}vcbuild) # serialize the build
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
    ExternalProject_Add(${XP_TARGET} DEPENDS ${node_${ver}_DEPS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
      SOURCE_DIR ${nodeSrcDir} INSTALL_DIR ${NULL_DIR}
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
  list(APPEND node_${ver}_DEPS ${XP_TARGET}) # serialize the build
endmacro()
