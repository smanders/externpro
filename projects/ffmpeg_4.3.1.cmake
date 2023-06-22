# ffmpeg
set(VER ${FFMPEG_NEWVER})
xpProOption(ffmpeg_${VER})
set(REPO https://github.com/FFmpeg/FFmpeg)
set(FORK https://github.com/smanders/FFmpeg)
# https://github.com/ndrasmussen/FFmpeg/tree/xp4.3.1
set(PRO_FFMPEG_${VER}
  NAME ffmpeg_${VER}
  WEB "ffmpeg" https://www.ffmpeg.org/ "ffmpeg website"
  LICENSE "LGPL" https://www.ffmpeg.org/legal.html "LGPL v2.1"
  DESC "complete, cross-platform solution to record, convert and stream audio and video"
  REPO "repo" ${REPO} "ffmpeg repo on github"
  #GRAPH GRAPH_NODE ffmpeg
  BUILD_DEPS openh264 yasm
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF n${VER} # create patch from this tag to 'git checkout'
  DLURL http://ffmpeg.org/releases/ffmpeg-${VER}.tar.bz2
  DLMD5 804707549590e90880e8ecd4e5244fd8
  PATCH ${PATCH_DIR}/ffmpeg_${VER}.patch
  DIFF ${FORK}/compare/FFmpeg:
  )
