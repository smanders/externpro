# ffmpeg
# xpbuild:cmake-scratch
set(VER ${FFMPEG_MSWVER})
xpProOption(ffmpeg_${VER})
set(REPO https://github.com/smanders/ffmpegBin)
set(PRO_FFMPEG_${VER}
  NAME ffmpeg_${VER}
  WEB "ffmpeg" https://www.ffmpeg.org/ "ffmpeg website"
  LICENSE "LGPL" https://www.ffmpeg.org/legal.html "Lesser GPL v2.1"
  DESC "pre-built (MSW-only) complete, cross-platform solution to record, convert and stream audio and video"
  REPO "repo" ${REPO} "ffmpeg binary repo on github"
  VER ${VER}
  GIT_ORIGIN ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL ${REPO}/archive/v${VER}.tar.gz
  DLMD5 467d46c09726933286dff0dc0c48b692
  DLNAME ffmpeg-v${VER}.tar.gz
  PATCH ${PATCH_DIR}/ffmpeg_${VER}.patch
  DIFF ${REPO}/compare/
  )
