# ffmpeg
set(VER ${FFMPEG_CFGVER})
xpProOption(ffmpeg_${VER})
set(REPO github.com/FFmpeg/FFmpeg)
set(FORK github.com/ndrasmussen/FFmpeg)
set(PRO_FFMPEG_${VER}
  NAME ffmpeg_${VER}
  WEB "ffmpeg" https://www.ffmpeg.org/ "ffmpeg website"
  LICENSE "LGPL" https://www.ffmpeg.org/legal.html "Lesser GPL v2.1"
  DESC "complete, cross-platform solution to record, convert and stream audio and video"
  REPO "repo" https://${REPO} "ffmpeg repo on github"
  GRAPH GRAPH_NODE ffmpeg BUILD_DEPS openh264 yasm
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF n${VER} # create patch from this tag to 'git checkout'
  DLURL http://ffmpeg.org/releases/ffmpeg-${VER}.tar.bz2
  DLMD5 e75d598921285d6775f20164a91936ac
  PATCH ${PATCH_DIR}/ffmpeg_${VER}.patch
  DIFF https://${FORK}/compare/FFmpeg:
  )
