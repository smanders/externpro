# FFMPEG_FOUND - FFmpeg was found
# FFMPEG_VER - FFmpeg version
# FFMPEG_LIBRARIES - the FFmpeg libraries
# FFMPEG_DLLNAMES - the FFmpeg shared object names (dll, so)
# FFMPEG_DLLS - the full path to FFmpeg shared objects (dll, so)
set(prj ffmpeg)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
set(ver _@VER@)
set(verDir /${prj}${ver})
set(includeDirs ${XP_ROOTDIR}/include${verDir} ${XP_ROOTDIR}/include${verDir}/ffmpeg)
# libraries, in linking order
# https://github.com/FFmpeg/FFmpeg/blob/n2.6.2/configure#L2667-L2675
set(ffmpeg_all_libs avdevice avfilter avformat avcodec swresample swscale avutil)
if(NOT DEFINED ffmpeg_libs)
  set(ffmpeg_libs ${ffmpeg_all_libs})
endif()
include(CheckLibraryExists)
function(checkLibraryConcat lib symbol liblist)
  string(TOUPPER ${lib} LIB)
  check_library_exists("${lib}" "${symbol}" "" XP_FFMPEG_HAS_${LIB})
  if(XP_FFMPEG_HAS_${LIB})
    list(APPEND ${liblist} ${lib})
    set(${liblist} ${${liblist}} PARENT_SCOPE)
  endif()
endfunction()
# _ffmpeg_*_libs
checkLibraryConcat(asound snd_strerror _ffmpeg_avdevice_libs)
checkLibraryConcat(Xext XShmDetach _ffmpeg_avdevice_libs)
xpFindPkg(PKGS openh264)
xpGetPkgVar(openh264 LIBRARIES) # sets OPENH264_LIBRARIES
set(_ffmpeg_avcodec_libs ${OPENH264_LIBRARIES})
# _ffmpeg_*_deps
set(_ffmpeg_avdevice_deps avfilter avformat)
set(_ffmpeg_avfilter_deps avcodec swresample swscale) # libavfilter code calls swr_*, sws_* functions
set(_ffmpeg_avformat_deps avcodec)
set(_ffmpeg_avcodec_deps swresample) # libavcodec code calls swr_* functions
set(_ffmpeg_swresample_deps avutil)
set(_ffmpeg_swscale_deps avutil)
set(_ffmpeg_avutil_deps)
foreach(lib ${ffmpeg_all_libs})
  if(NOT TARGET ffmpeg::${lib})
    add_library(ffmpeg::${lib} STATIC IMPORTED)
    set(${lib}_RELEASE ${XP_ROOTDIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${lib}${ver}${CMAKE_STATIC_LIBRARY_SUFFIX})
    if(EXISTS "${${lib}_RELEASE}")
      set_property(TARGET ffmpeg::${lib} APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
      set_target_properties(ffmpeg::${lib} PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE "ASM_NASM;C;CXX"
        IMPORTED_LOCATION_RELEASE "${${lib}_RELEASE}"
        )
      set_target_properties(ffmpeg::${lib} PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES "${includeDirs}"
        )
      if(_ffmpeg_${lib}_deps OR _ffmpeg_${lib}_libs)
        unset(linkLibs)
        foreach(dep ${_ffmpeg_${lib}_deps})
          list(APPEND linkLibs \$<LINK_ONLY:ffmpeg::${dep}>)
        endforeach()
        foreach(dep ${_ffmpeg_${lib}_libs})
          list(APPEND linkLibs \$<LINK_ONLY:${dep}>)
        endforeach()
        set_target_properties(ffmpeg::${lib} PROPERTIES
          INTERFACE_LINK_LIBRARIES "${linkLibs}"
          )
      endif()
    endif()
  endif()
endforeach()
unset(ffmpegLibs)
foreach(lib ${ffmpeg_libs})
  list(APPEND ffmpegLibs "ffmpeg::${lib}") # prepend NAMESPACE
endforeach()
set(${PRJ}_LIBRARIES ${ffmpegLibs})
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES)
if(WIN32)
  set(${PRJ}_DLLNAMES
    avcodec-56.dll
    avdevice-56.dll
    avfilter-5.dll
    avformat-56.dll
    avutil-54.dll
    swresample-1.dll
    swscale-3.dll
    )
  set(${PRJ}_DLLS ${${PRJ}_DLLNAMES})
  list(TRANSFORM ${PRJ}_DLLS PREPEND ${XP_ROOTDIR}/bin${verDir}/)
  list(APPEND reqVars ${PRJ}_DLLNAMES ${PRJ}_DLLS)
endif()
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
