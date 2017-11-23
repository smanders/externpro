# openh264
xpProOption(openh264)
set(VER 1.4.0)
set(REPO https://github.com/cisco/openh264)
set(FORK https://github.com/smanders/openh264)
set(DLBIN ${REPO}/releases/download/v${VER})
set(PRO_OPENH264
  NAME openh264
  WEB "OpenH264" http://www.openh264.org/ "OpenH264 website"
  LICENSE "open" http://www.openh264.org/faq.html "Two-Clause BSD license"
  DESC "a codec library which supports H.264 encoding and decoding"
  REPO "repo" ${REPO} "openh264 repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/openh264.git
  GIT_UPSTREAM git://github.com/cisco/openh264.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/openh264_${VER}.patch
  DIFF ${FORK}/compare/cisco:
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 ca77b91a7a33efb4c5e7c56a5c0f599f
  DLNAME openh264-${VER}.tar.gz
  DLMD5_lnx32 951bf2c8f44a4e899c86a1b7134df48e DLURL_lnx32 ${DLBIN}/libopenh264-${VER}-linux32.so.bz2
  DLMD5_lnx64 905aefdd86c3313fdcdad653597cb8fa DLURL_lnx64 ${DLBIN}/libopenh264-${VER}-linux64.so.bz2
  DLMD5_win32 1537a61c58b4e54bce7c120a23194ea2 DLURL_win32 ${DLBIN}/openh264-${VER}-win32msvc.dll.bz2
  DLMD5_win64 697c72facafc6da42e50316edc52e185 DLURL_win64 ${DLBIN}/openh264-${VER}-win64msvc.dll.bz2
  DLADD _lnx32 _lnx64 _win32 _win64
  )
########################################
macro(getOs3la)
  if(WIN32 AND ${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    set(OS win)
  elseif(UNIX AND ${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
    set(OS lnx)
  else()
    message(FATAL_ERROR "openh264.cmake: OS support lacking")
  endif()
endmacro()
########################################
function(build_openh264)
  if(NOT (XP_DEFAULT OR XP_PRO_OPENH264))
    return()
  endif()
  if(NOT (XP_DEFAULT OR XP_PRO_BZIP2))
    message(STATUS "openh264.cmake: requires bzip2")
    set(XP_PRO_BZIP2 ON CACHE BOOL "include bzip2" FORCE)
    xpPatchProject(${PRO_BZIP2})
  endif()
  build_bzip2(bzip2Tgts)
  getOs3la()
  set(pf ${BUILD_PLATFORM})
  ExternalProject_Get_Property(openh264 SOURCE_DIR)
  xpGetArgValue(${PRO_OPENH264} ARG VER VALUE VER)
  set(verDir /openh264_${VER})
  xpGetArgValue(${PRO_OPENH264} ARG DLURL_${OS}${pf} VALUE dwnldUrl)
  xpGetArgValue(${PRO_OPENH264} ARG DLMD5_${OS}${pf} VALUE dwnldMd5)
  xpGetArgValue(${PRO_BZIP2} ARG VER VALUE bzip2Ver)
  if(WIN32)
    set(ext ".exe")
  endif()
  get_filename_component(fn ${dwnldUrl} NAME)
  string(REPLACE ".bz2" "" sharedObj ${fn})
  string(REPLACE "libopenh264" "" verSuffix ${sharedObj})
  string(REPLACE ".so" "" verSuffix ${verSuffix})
  configure_file(${PRO_DIR}/use/usexp-openh264-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  if(NOT TARGET openh264_${OS}${pf})
    ExternalProject_Add(openh264_${OS}${pf} DEPENDS openh264 ${bzip2Tgts}
      URL ${dwnldUrl} URL_MD5 ${dwnldMd5} DOWNLOAD_DIR ${DWNLD_DIR}
      DOWNLOAD_NO_EXTRACT 1 # cmake can't extract bz2 https://github.com/smanders/externpro/issues/152
      UPDATE_COMMAND ${CMAKE_COMMAND} -E copy_if_different <DOWNLOADED_FILE> <SOURCE_DIR>
      CONFIGURE_COMMAND ${STAGE_DIR}/bin/bunzip2_${bzip2Ver}${ext} -f -k <SOURCE_DIR>/${fn}
      BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${SOURCE_DIR}/codec/api/svc/codec_*.h
        -Ddst:STRING=${STAGE_DIR}/include${verDir}/wels/ -P ${MODULES_DIR}/cmscopyfiles.cmake
      INSTALL_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=<SOURCE_DIR>/${sharedObj}
        -Ddst:STRING=${STAGE_DIR}/lib -P ${MODULES_DIR}/cmscopyfiles.cmake
      BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
      )
    ExternalProject_Add_Step(openh264_${OS}${pf} pkgconfig
      COMMAND ${CMAKE_COMMAND} -Dinput:STRING=${SOURCE_DIR}/openh264.pc.in
        -Doutput:STRING=${STAGE_DIR}/share/cmake/openh264.pc
        -Dprefix:STRING=${STAGE_DIR} -DverDir=${verDir} -DVERSION=${VER} -DSUFFIX=${verSuffix}
        -P ${MODULES_DIR}/cmsconfigurefile.cmake
      DEPENDEES install
      )
    set_property(TARGET openh264_${OS}${pf} PROPERTY FOLDER ${bld_folder})
    message(STATUS "target openh264_${OS}${pf}")
  endif()
  if(ARGN)
    set(${ARGN} openh264_${OS}${pf} PARENT_SCOPE)
  endif()
endfunction()
