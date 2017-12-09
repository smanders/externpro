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
  )
########################################
function(build_openh264)
  if(NOT (XP_DEFAULT OR XP_PRO_OPENH264))
    return()
  endif()
  xpGetArgValue(${PRO_OPENH264} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-openh264-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(openh264 "" "-DOPENH264_VER=${VER}" openh264Targets)
  if(ARGN)
    set(${ARGN} "${openh264Targets}" PARENT_SCOPE)
  endif()
endfunction()
