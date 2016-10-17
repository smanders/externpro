# node
set(NODE_VERSIONS v5 v6)
set(NODE_OLDVER v5)
set(NODE_NEWVER v6)
####################
function(build_node)
  configure_file(${PRO_DIR}/use/usexp-node-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  foreach(ver ${NODE_VERSIONS})
    build_node_ver(${ver})
  endforeach()
endfunction()
####################
function(build_node_ver ver)
  string(TOUPPER ${ver} VER)
  if(NOT (XP_DEFAULT OR XP_PRO_NODE${VER}))
    return()
  endif()
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
      --dest-cpu=${destcpu} --dest-os=${destos} ${addopt}
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
  # copy headers and npm to STAGE_DIR
  ExternalProject_Get_Property(node${ver} SOURCE_DIR)
  set(nodeHdrs ${SOURCE_DIR}/src/*.h)
  set(uvDir ${SOURCE_DIR}/deps/uv/include)
  set(v8Hdrs ${SOURCE_DIR}/deps/v8/include/*.h)
  set(nm node_modules)
  set(npmSrc ${SOURCE_DIR}/deps/npm)
  set(npmDst ${STAGE_DIR}/node${ver}/npm)
  set(npmExe ${STAGE_DIR}/node${ver}/bin/node ${npmDst}/bin/npm-cli.js)
  set(XP_TARGET node${ver}_stage_hdrs)
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
    xpStringAppend(rmdirs test)
    xpStringAppend(rmdirs example)
    if(MSVC) # we only need to flatten these directories on Windows (installer issue)
      if(${ver} STREQUAL v5)
        xpStringAppend(flatten ${npmDst}/${nm}/init-package-json/${nm}/glob/${nm})
        xpStringAppend(flatten ${npmDst}/${nm}/node-gyp/${nm}/glob/${nm})
        xpStringAppend(flatten ${npmDst}/${nm}/read-package-json/${nm}/glob/${nm})
      endif()
    endif()
    # copy npm to STAGE_DIR
    ExternalProject_Add_Step(${XP_TARGET} post_${XP_TARGET}
      COMMAND ${CMAKE_COMMAND} -E remove_directory ${npmDst} # for testing (start clean)
      COMMAND ${CMAKE_COMMAND} -E make_directory ${npmDst}
      COMMAND ${CMAKE_COMMAND} -E copy_directory ${npmSrc} ${npmDst}
      DEPENDEES install
      )
    # dedupe
    ExternalProject_Add_Step(${XP_TARGET} postpost_${XP_TARGET}
      COMMAND ${npmExe} dedupe
      COMMAND ${CMAKE_COMMAND} -Drmroot:STRING=${npmDst} -Drmdirs:STRING=${rmdirs}
        -Ddirs:STRING=${flatten} -P ${MODULES_DIR}/cmsflatnode.cmake
      WORKING_DIRECTORY ${npmDst}
      DEPENDEES post_${XP_TARGET}
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
      ExternalProject_Add(${XP_TARGET}vcbuild DEPENDS ${node${ver}_DEPS}
        DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
        SOURCE_DIR ${nodeSrcDir} INSTALL_DIR ${NULL_DIR}
        CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
        BUILD_IN_SOURCE 1 # <BINARY_DIR>==<SOURCE_DIR>
        )
      set_property(TARGET ${XP_TARGET}vcbuild PROPERTY FOLDER ${bld_folder})
      set(XP_CONFIGURE_CMD ${CMAKE_COMMAND} -E echo "Configure MSVC...")
      set(binNode <SOURCE_DIR>/${cfg}/node.exe)
      set(libNode <SOURCE_DIR>/${cfg}/node.lib)
      list(APPEND node${ver}_DEPS ${XP_TARGET}vcbuild) # serialize the build
      set(XP_BUILD_CMD ${CMAKE_COMMAND} -E echo "Build MSVC...")
      set(XP_INSTALL_CMD ${CMAKE_COMMAND} -E echo "Install MSVC...")
    elseif(UNIX)
      set(binNode <SOURCE_DIR>/out/${cfg}/node)
      set(XP_BUILD_CMD) # use the default ...
      set(XP_INSTALL_CMD) # use the default ...
    endif()
    ExternalProject_Add(${XP_TARGET} DEPENDS ${node${ver}_DEPS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
      SOURCE_DIR ${nodeSrcDir} INSTALL_DIR ${NULL_DIR}
      CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
      BUILD_COMMAND ${XP_BUILD_CMD}
      BUILD_IN_SOURCE 1 # <BINARY_DIR>==<SOURCE_DIR>
      INSTALL_COMMAND ${XP_INSTALL_CMD}
      )
    ExternalProject_Add_Step(${XP_TARGET} post_${XP_TARGET}
      COMMAND ${CMAKE_COMMAND} -E make_directory ${STAGE_DIR}/node${ver}/bin
      COMMAND ${CMAKE_COMMAND} -E copy ${binNode} ${STAGE_DIR}/node${ver}/bin
      COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${libNode}
        -Ddst:STRING=${STAGE_DIR}/node${ver}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
      DEPENDEES install
      )
    set_property(TARGET ${XP_TARGET} PROPERTY FOLDER ${bld_folder})
  endif()
  list(APPEND node${ver}_DEPS ${XP_TARGET}) # serialize the build
endmacro()
