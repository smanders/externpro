# clangformat
include(${CMAKE_CURRENT_LIST_DIR}/llvm.cmake)
xpGetArgValue(${PRO_LLVM} ARG VER VALUE llvmVer)
set(PRO_CLANGFORMAT
  NAME clangformat
  SUPERPRO clang
  WEB "clang-format" http://clang.llvm.org/docs/ClangFormat.html "ClangFormat documentation"
  LICENSE "open" "http://clang.llvm.org/features.html#license" "LLVM 'Apache 2' License"
  DESC "used to format C/C++/Obj-C code"
  GRAPH GRAPH_SHAPE box BUILD_DEPS clang
  VER ${llvmVer}
  )
########################################
function(build_clangformat)
  if(NOT (XP_DEFAULT OR XP_PRO_LLVM))
    return()
  endif()
  build_llvm(llvmTgt)
  xpGetArgValue(${PRO_CLANGFORMAT} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_LLVM} ARG VER VALUE VER)
  set(TARGETS_FILE share/cmake/xpopts.cmake) # no targets-file, set to harmless .cmake
  set(EXECUTABLE \${XP_ROOTDIR}/bin/clang-format\${CMAKE_EXECUTABLE_SUFFIX})
  configure_file(${PRO_DIR}/use/usexp-template-exe-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  ExternalProject_Get_Property(${llvmTgt} BINARY_DIR)
  ExternalProject_Add(${NAME}_install DEPENDS ${llvmTgt}
    DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
    SOURCE_DIR ${NULL_DIR} CONFIGURE_COMMAND "" BUILD_COMMAND ""
    BINARY_DIR ${BINARY_DIR}/tools/clang/tools/clang-format
    INSTALL_COMMAND ${CMAKE_COMMAND} -P cmake_install.cmake
    INSTALL_DIR ${STAGE_DIR}
    )
  set_property(TARGET ${NAME}_install PROPERTY FOLDER ${bld_folder})
endfunction()
