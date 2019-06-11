# nasm
xpProOption(nasm)
set(VER 2.14.02)
set(URL https://www.nasm.us/)
set(PRO_NASM
  NAME nasm
  WEB "nasm" ${URL} "nasm website"
  LICENSE "BSD" ${URL} "Simplified (2-clause) BSD license"
  DESC "The Netwide Assembler - an 80x86 and x86-64 assembler"
  VER ${VER}
  DLURL ${URL}/pub/nasm/releasebuilds/${VER}/win64/nasm-${VER}-installer-x64.exe
  DLMD5 e871a6d2651e81ce8674ae2d31fe33b0
  )
########################################
function(patch_nasm)
  # don't want xpPatch(${PRO_NASM}) called automatically
  # because then an ExternalProject_Add(nasm) will try to extract the executable
  # which doesn't make any sense, since this executable is an installer
endfunction()
########################################
function(find_nasm)
  find_program(NASM_EXECUTABLE)
  if(NASM_EXECUTABLE)
    execute_process(COMMAND ${NASM_EXECUTABLE} -version
      OUTPUT_VARIABLE nasmVersion
      ERROR_QUIET
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    if(nasmVersion MATCHES "^NASM version ([0-9\\.]*)")
      set(NASM_VERSION_STRING "${CMAKE_MATCH_1}")
    endif()
    unset(nasmVersion)
  endif()
  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(nasm
    REQUIRED_VARS NASM_EXECUTABLE
    VERSION_VAR NASM_VERSION_STRING
    )
endfunction()
