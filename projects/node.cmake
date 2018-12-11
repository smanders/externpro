# node
set(NODE_OLDVER v8.12.0)
set(NODE_NEWVER v10.14.1)
####################
function(build_node)
  string(TOUPPER ${NODE_OLDVER} OV)
  string(TOUPPER ${NODE_NEWVER} NV)
  if(NOT (XP_DEFAULT OR XP_PRO_NODE${OV} OR XP_PRO_NODE${NV}))
    return()
  endif()
  if(XP_DEFAULT)
    set(NODE_VERSIONS ${NODE_OLDVER} ${NODE_NEWVER})
  else()
    if(XP_PRO_NODE${OV})
      set(NODE_VERSIONS ${NODE_OLDVER})
    endif()
    if(XP_PRO_NODE${NV})
      list(APPEND NODE_VERSIONS ${NODE_NEWVER})
    endif()
  endif()
  list(REMOVE_DUPLICATES NODE_VERSIONS)
  list(LENGTH NODE_VERSIONS NUM_VER)
  if(NUM_VER EQUAL 1)
    set(USE_SCRIPT_INSERT "set(XP_USE_LATEST_NODE ON) # currently only one version supported")
  else()
    set(USE_SCRIPT_INSERT "#set(XP_USE_LATEST_NODE ON) # currently multiple versions supported")
  endif()
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
  set(node${ver}_DEPS node${ver})
  if(${BUILD_PLATFORM} STREQUAL "64")
    set(destcpu x64)
  elseif(${BUILD_PLATFORM} STREQUAL "32")
    set(destcpu ia32)
  else()
    message(FATAL_ERROR "node.cmake: cpu")
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
    addproject_node(node${ver} ${cfg})
  endforeach() # cfg
  # copy headers to STAGE_DIR
  ExternalProject_Get_Property(node${ver} SOURCE_DIR)
  set(nodeHdrs ${SOURCE_DIR}/src/*.h)
  set(uvDir ${SOURCE_DIR}/deps/uv/include)
  set(v8Hdrs ${SOURCE_DIR}/deps/v8/include/*.h)
  set(XP_TARGET node${ver}_stage)
  if(NOT TARGET ${XP_TARGET})
    ExternalProject_Add(${XP_TARGET} DEPENDS ${node${ver}_DEPS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} BINARY_DIR ${NULL_DIR}
      SOURCE_DIR ${NULL_DIR} INSTALL_DIR ${STAGE_DIR}/include/node${ver}/node
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
      ExternalProject_Add(${XP_TARGET}vcbuild DEPENDS ${node${ver}_DEPS}
        DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
        SOURCE_DIR ${nodeSrcDir} INSTALL_DIR ${NULL_DIR}
        CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
        BUILD_IN_SOURCE 1 # <BINARY_DIR>==<SOURCE_DIR>
        )
      set_property(TARGET ${XP_TARGET}vcbuild PROPERTY FOLDER ${bld_folder})
      list(APPEND node${ver}_DEPS ${XP_TARGET}vcbuild) # serialize the build
      set(binNode <SOURCE_DIR>/${cfg}/node.exe)
      set(libNode <SOURCE_DIR>/${cfg}/node.lib)
      set(XP_CONFIGURE_CMD ${CMAKE_COMMAND} -E echo "Configure MSVC...")
      set(XP_BUILD_CMD ${CMAKE_COMMAND} -E make_directory ${STAGE_DIR}/node${ver}/lib)
      set(XP_INSTALL_CMD ${CMAKE_COMMAND} -E copy ${libNode} ${STAGE_DIR}/node${ver}/lib)
    elseif(UNIX)
      set(binNode <SOURCE_DIR>/out/${cfg}/node)
      set(XP_BUILD_CMD)   # use default
      set(XP_INSTALL_CMD) # use default
    endif()
    ExternalProject_Add(${XP_TARGET} DEPENDS ${node${ver}_DEPS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
      SOURCE_DIR ${nodeSrcDir} INSTALL_DIR ${NULL_DIR}
      CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
      BUILD_COMMAND ${XP_BUILD_CMD}
      BUILD_IN_SOURCE 1 # <BINARY_DIR>==<SOURCE_DIR>
      INSTALL_COMMAND ${XP_INSTALL_CMD}
      )
    ExternalProject_Add_Step(${XP_TARGET} copy_bin
      COMMAND ${CMAKE_COMMAND} -E make_directory ${STAGE_DIR}/node${ver}/bin
      COMMAND ${CMAKE_COMMAND} -E copy ${binNode} ${STAGE_DIR}/node${ver}/bin
      DEPENDEES install
      )
    set_property(TARGET ${XP_TARGET} PROPERTY FOLDER ${bld_folder})
  endif()
  list(APPEND node${ver}_DEPS ${XP_TARGET}) # serialize the build
endmacro()
