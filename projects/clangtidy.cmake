# clangtidy
include(${CMAKE_CURRENT_LIST_DIR}/llvm.cmake)
xpGetArgValue(${PRO_LLVM} ARG VER VALUE llvmVer)
set(PRO_CLANGTIDY
  NAME clangtidy
  SUPERPRO clangtoolsextra
  WEB "clang-tidy" http://clang.llvm.org/extra/clang-tidy/ "Clang-Tidy documentation"
  LICENSE "open" "http://clang.llvm.org/features.html#license" "LLVM 'BSD' License"
  DESC "clang-based C++ 'linter' tool for diagnosing and fixing typical programming errors via static analysis"
  VER ${llvmVer}
  )
########################################
function(build_clangtidy)
  if(NOT (XP_DEFAULT OR XP_PRO_LLVM))
    return()
  endif()
  build_llvm(llvmTgt)
  if(NOT XP_BUILD_CLANGTIDY)
    return()
  endif()
  configure_file(${PRO_DIR}/use/usexp-clangtidy-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  ExternalProject_Get_Property(${llvmTgt} BINARY_DIR)
  ExternalProject_Add(clangtidy_install DEPENDS ${llvmTgt}
    DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
    SOURCE_DIR ${NULL_DIR} CONFIGURE_COMMAND "" BUILD_COMMAND ""
    BINARY_DIR ${BINARY_DIR}/tools/clang/tools/extra/clang-tidy/tool
    INSTALL_COMMAND ${CMAKE_COMMAND} -P cmake_install.cmake
    INSTALL_DIR ${STAGE_DIR}
    )
  set_property(TARGET clangtidy_install PROPERTY FOLDER ${bld_folder})
endfunction()
