# fftw
# http://packages.debian.org/sid/libfftw3-3
# http://fftw3.sourcearchive.com/
xpProOption(fftw)
set(VER 3.3.3)
set(PRO_FFTW
  NAME FFTW
  WEB "FFTW" http://www.fftw.org/ "FFTW website"
  LICENSE "GPL" "http://www.fftw.org/faq/section1.html#isfftwfree" "GPL, can purchase an unlimited-use license from MIT"
  DESC "Fastest Fourier Transform in the West"
  VER ${VER}
  DLURL http://www.fftw.org/fftw-${VER}.tar.gz
  DLMD5 0a05ca9c7b3bfddc8278e7c40791a1c2
  SUBPRO fftwcmake
  )
########################################
function(build_fftw)
  if(NOT (XP_DEFAULT OR XP_PRO_FFTW))
    return()
  endif()
  xpGetArgValue(${PRO_FFTW} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-fftw-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  if(MSVC)
    xpCmakeBuild(fftw fftw_fftwcmake "-DFFTW_VER=${VER}")
  else()
    list(APPEND removeFlags -std=c++0x -std=c++11 -std=c++14 -stdlib=libc++)
    xpGetConfigureFlags(CPP fftw_CONFIGURE_FLAGS "${removeFlags}")
    set(precisions double float long-double)
    # NOTE: double won't be recognized as a configure option, but default will be double
    foreach(prec ${precisions})
      set(XP_CONFIGURE_BASE <SOURCE_DIR>/configure ${fftw_CONFIGURE_FLAGS}
        --prefix=<INSTALL_DIR> --enable-${prec} --disable-fortran --disable-shared
        --enable-static --enable-threads --with-combined-threads
        )
      set(XP_CONFIGURE_Debug ${XP_CONFIGURE_BASE} --enable-debug --disable-debug-malloc --program-suffix=-d)
      set(XP_CONFIGURE_Release ${XP_CONFIGURE_BASE})
      if(${prec} STREQUAL "float") # sse, sse2, avx
        list(APPEND XP_CONFIGURE_Release --enable-sse --enable-sse2)
        if(NOT ${CMAKE_SYSTEM_NAME} STREQUAL "SunOS" AND NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
          list(APPEND XP_CONFIGURE_Release --enable-avx)
        endif()
      elseif(${prec} STREQUAL "long-double")
        # SSE requires single precision, SSE2 requires single or double precision
        # AVX requires single or double precision
        # (configure error if --enable-sse, --enable-sse2, or --enable-avx)
      elseif(${prec} STREQUAL "double")
        # SSE requires single precision (configure error if --enable-sse)
        list(APPEND XP_CONFIGURE_Release --enable-sse2)
        if(NOT ${CMAKE_SYSTEM_NAME} STREQUAL "SunOS" AND NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
          list(APPEND XP_CONFIGURE_Release --enable-avx)
        endif()
      endif()
      foreach(cfg ${BUILD_CONFIGS})
        set(XP_CONFIGURE_CMD ${XP_CONFIGURE_${cfg}})
        set(FFTW_TARGET fftw_${cfg}_${prec})
        addproject_fftw(${FFTW_TARGET})
        # add suffix to Debug libraries
        if(${cfg} STREQUAL "Debug")
          set(appendSuffix ${CMAKE_COMMAND} -Dsrc:STRING=<BINARY_DIR>/lib/libfftw*.*a
            -Dsuffix:STRING=_${VER}-d -P ${MODULES_DIR}/cmsappendsuffix.cmake)
        else() # not Debug
          set(appendSuffix ${CMAKE_COMMAND} -Dsrc:STRING=<BINARY_DIR>/lib/libfftw*.*a
            -Dsuffix:STRING=_${VER} -P ${MODULES_DIR}/cmsappendsuffix.cmake)
        endif()
        ExternalProject_Get_Property(fftw SOURCE_DIR)
        ExternalProject_Get_Property(${FFTW_TARGET} INSTALL_DIR)
        # copy libs and headers to stage directory
        set(verDir /fftw_${VER})
        ExternalProject_Add(${FFTW_TARGET}_stage DEPENDS ${FFTW_TARGET}
          DOWNLOAD_DIR ${NULL_DIR} DOWNLOAD_COMMAND ""
          SOURCE_DIR ${SOURCE_DIR} BINARY_DIR ${INSTALL_DIR}
          CONFIGURE_COMMAND ${appendSuffix}
          BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<BINARY_DIR>/lib/libfftw*.a
            -Ddst:STRING=${STAGE_DIR}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
          INSTALL_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<BINARY_DIR>/include/*.h
            -Ddst:STRING=${STAGE_DIR}/include${verDir}/fftw3 -P ${MODULES_DIR}/cmscopyfiles.cmake
          INSTALL_DIR ${NULL_DIR}
          )
        set_property(TARGET ${FFTW_TARGET}_stage PROPERTY FOLDER ${bld_folder})
      endforeach() # cfg
    endforeach() # prec
  endif() # UNIX
endfunction()
####################
macro(addproject_fftw XP_TARGET)
  if(XP_BUILD_VERBOSE)
    message(STATUS "target ${XP_TARGET}")
    xpVerboseListing("[CONFIGURE]" "${XP_CONFIGURE_CMD}")
  else()
    message(STATUS "target ${XP_TARGET}")
  endif()
  ExternalProject_Get_Property(fftw SOURCE_DIR)
  ExternalProject_Add(${XP_TARGET}  DEPENDS fftw
    DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR}
    SOURCE_DIR ${SOURCE_DIR}
    CONFIGURE_COMMAND ${XP_CONFIGURE_CMD}
    BUILD_COMMAND   # use default
    INSTALL_COMMAND # use default
    )
  set_property(TARGET ${XP_TARGET} PROPERTY FOLDER ${bld_folder})
endmacro()
