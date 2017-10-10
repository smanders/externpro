# ffmpeg
xpProOption(ffmpeg)
set(VER 2.6.2.1)
set(REPO https://github.com/smanders/ffmpegBin)
set(PRO_FFMPEG
  NAME ffmpeg
  WEB "ffmpeg" https://www.ffmpeg.org/ "ffmpeg website"
  LICENSE "LGPL" https://www.ffmpeg.org/legal.html "Lesser GPL v2.1"
  DESC "pre-built (MSW-only) complete, cross-platform solution to record, convert and stream audio and video"
  REPO "repo" ${REPO} "ffmpeg binary repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/ffmpegBin.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 467d46c09726933286dff0dc0c48b692
  DLNAME ffmpeg-v${VER}.tar.gz
  PATCH ${PATCH_DIR}/ffmpeg.patch
  DIFF ${REPO}/compare/
  )
########################################
function(build_ffmpeg)
  if(NOT (XP_DEFAULT OR XP_PRO_FFMPEG))
    return()
  endif()
  xpGetArgValue(${PRO_FFMPEG} ARG VER VALUE VER)
  configure_file(${PRO_DIR}/use/usexp-ffmpeg-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpBuildOnlyRelease()
  xpCmakeBuild(ffmpeg "" "-DFFMPEG_VER=${VER}" ffmpegTargets)
  if(ARGN)
    set(${ARGN} "${ffmpegTargets}" PARENT_SCOPE)
  endif()
endfunction()
