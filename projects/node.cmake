########################################
# node
xpProOption(node)
set(VER 0.12.7)
set(REPO https://github.com/smanders/node)
set(PRO_NODE
  NAME node
  WEB "Node.js" http://nodejs.org "Node.js website"
  LICENSE "open" https://raw.githubusercontent.com/nodejs/node/v${VER}/LICENSE "MIT license"
  DESC "platform to build scalable network applications"
  REPO "repo" ${REPO} "forked node repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/node.git
  GIT_UPSTREAM git://github.com/nodejs/node.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://nodejs.org/dist/v${VER}/node-v${VER}.tar.gz
  DLMD5 5523ec4347d7fe6b0f6dda1d1c7799d5
  PATCH ${PATCH_DIR}/node.patch
  DIFF ${REPO}/compare/nodejs:
  )
########################################
function(mkpatch_node)
  xpRepo(${PRO_NODE})
endfunction()
########################################
function(download_node)
  xpNewDownload(${PRO_NODE})
endfunction()
########################################
function(patch_node)
  xpPatch(${PRO_NODE})
endfunction()
########################################
function(build_node)
  if(NOT (XP_DEFAULT OR XP_PRO_NODE))
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-node-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  # TODO: support Debug by renaming files going into STAGE_DIR
  set(BUILD_CONFIGS Release)
  set(node_DEPS node)
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
    # TODO: can we add flags? -fPIC, etc?
    #list(APPEND removeFlags -std=c++0x -std=c++11 -stdlib=libc++)
    #xpGetConfigureFlags(CXX node_CONFIGURE_FLAGS "${removeFlags}")
    if(${CMAKE_SYSTEM_NAME} STREQUAL "SunOS")
      set(XP_CONFIGURE_BASE CC=gcc)
      set(destos solaris)
      set(dbgopt --with-dtrace)
      # ifaddrs.h not found on Solaris 10
      # https://github.com/nodejs/node-v0.x-archive/issues/3465
      set(addopt --no-ifaddrs)
      # missing libproc.h on Solaris 10
      # https://github.com/nodejs/node-v0.x-archive/issues/6439
      # https://github.com/cgalibern/node/commit/37db35864b8baf88b75c6709d8e9ac750e8ef9b7
      list(APPEND addopt --without-mdb)
      # NOTE: Solaris 10, non-GNU ld not supported
      # https://github.com/nodejs/node-v0.x-archive/issues/5081
    elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
      set(destos linux)
      set(dbgopt --without-dtrace)
    elseif(${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
      set(destos mac)
      set(dbgopt --without-dtrace)
    else()
      message(FATAL_ERROR "node.cmake: os")
    endif()
    list(APPEND XP_CONFIGURE_BASE <SOURCE_DIR>/configure #${node_CONFIGURE_FLAGS}
      --prefix=<INSTALL_DIR>
      --without-etw --without-perfctr
      --dest-cpu=${destcpu} --dest-os=${destos} ${addopt}
      )
    set(XP_CONFIGURE_Release ${XP_CONFIGURE_BASE} --without-dtrace)
    set(XP_CONFIGURE_Debug ${XP_CONFIGURE_BASE} --debug --gdb ${dbgopt})
  else()
    message(FATAL_ERROR "node.cmake: unsupported OS platform")
  endif()
  foreach(cfg ${BUILD_CONFIGS})
    set(XP_CONFIGURE_CMD ${XP_CONFIGURE_${cfg}})
    addproject_node(node ${cfg})
  endforeach() # cfg
  # copy headers to STAGE_DIR
  ExternalProject_Get_Property(node SOURCE_DIR)
  set(nodeHdrs ${SOURCE_DIR}/src/*.h)
  set(uvDir ${SOURCE_DIR}/deps/uv/include)
  set(v8Hdrs ${SOURCE_DIR}/deps/v8/include/*.h)
  set(npmDir ${SOURCE_DIR}/deps/npm)
  set(XP_TARGET node_stage_hdrs)
  if(NOT TARGET ${XP_TARGET})
    ExternalProject_Add(${XP_TARGET} DEPENDS ${node_DEPS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} BINARY_DIR ${NULL_DIR}
      SOURCE_DIR ${NULL_DIR} INSTALL_DIR ${STAGE_DIR}/include/node
      CONFIGURE_COMMAND ${CMAKE_COMMAND} -E copy_directory ${uvDir} <INSTALL_DIR>
      BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${nodeHdrs}
        -Ddst:STRING=<INSTALL_DIR> -P ${MODULES_DIR}/cmscopyfiles.cmake
      INSTALL_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${v8Hdrs}
        -Ddst:STRING=<INSTALL_DIR> -P ${MODULES_DIR}/cmscopyfiles.cmake
      )
    option(XP_PRO_NODE_NPM "copy npm to installer" ON)
    if(XP_PRO_NODE_NPM)
      # copy npm to STAGE_DIR
      ExternalProject_Add_Step(${XP_TARGET} post_${XP_TARGET}
        COMMAND ${CMAKE_COMMAND} -E make_directory ${STAGE_DIR}/node_modules/npm
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${npmDir} ${STAGE_DIR}/node_modules/npm
        DEPENDEES install
        )
    endif()
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
      ExternalProject_Add(${XP_TARGET}vcbuild DEPENDS ${node_DEPS}
        DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
        SOURCE_DIR ${nodeSrcDir} INSTALL_DIR ${NULL_DIR}
        CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
        BUILD_IN_SOURCE 1 # <BINARY_DIR>==<SOURCE_DIR>
        )
      set_property(TARGET ${XP_TARGET}vcbuild PROPERTY FOLDER ${bld_folder})
      set(XP_CONFIGURE_CMD ${CMAKE_COMMAND} -E echo "Configure MSVC...")
      set(binNode <SOURCE_DIR>/${cfg}/node.exe)
      set(libNode <SOURCE_DIR>/${cfg}/node.lib)
      list(APPEND node_DEPS ${XP_TARGET}vcbuild) # serialize the build
      set(XP_BUILD_CMD ${CMAKE_COMMAND} -E echo "Build MSVC...")
      set(XP_INSTALL_CMD ${CMAKE_COMMAND} -E echo "Install MSVC...")
    elseif(UNIX)
      set(binNode <SOURCE_DIR>/out/${cfg}/node)
      set(libNode <SOURCE_DIR>/out/${cfg}/libv8*.a) # TODO: probably don't need any of these libs
      set(XP_BUILD_CMD) # use the default ...
      set(XP_INSTALL_CMD) # use the default ...
    endif()
    ExternalProject_Add(${XP_TARGET} DEPENDS ${node_DEPS}
      DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
      SOURCE_DIR ${nodeSrcDir} INSTALL_DIR ${NULL_DIR}
      CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
      BUILD_COMMAND ${XP_BUILD_CMD}
      BUILD_IN_SOURCE 1 # <BINARY_DIR>==<SOURCE_DIR>
      INSTALL_COMMAND ${XP_INSTALL_CMD}
      )
    ExternalProject_Add_Step(${XP_TARGET} post_${XP_TARGET}
      COMMAND ${CMAKE_COMMAND} -E make_directory ${STAGE_DIR}/bin
      COMMAND ${CMAKE_COMMAND} -E make_directory ${STAGE_DIR}/lib
      COMMAND ${CMAKE_COMMAND} -E copy ${binNode} ${STAGE_DIR}/bin
      COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${libNode}
        -Ddst:STRING=${STAGE_DIR}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
      DEPENDEES install
      )
    set_property(TARGET ${XP_TARGET} PROPERTY FOLDER ${bld_folder})
  endif()
  list(APPEND node_DEPS ${XP_TARGET}) # serialize the build
endmacro()
