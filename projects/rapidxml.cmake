# RapidXml
# xpbuild:cmake-scratch
# http://sourceforge.net/projects/rapidxml/files/rapidxml/
xpProOption(rapidxml)
set(VER 1.13)
set(REPO https://github.com/externpro/rapidxml)
set(PRO_RAPIDXML
  NAME rapidxml
  WEB "RapidXml" http://rapidxml.sourceforge.net/ "RapidXml on sourceforge"
  LICENSE "open" http://rapidxml.sourceforge.net/license.txt "Boost Software License -or- The MIT License"
  DESC "fast XML parser"
  REPO "repo" ${REPO} "rapidxml repo on github"
  VER ${VER}
  GIT_ORIGIN ${REPO}
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  DLURL http://downloads.sourceforge.net/project/rapidxml/rapidxml/rapidxml%20${VER}/rapidxml-${VER}.zip
  DLMD5 7b4b42c9331c90aded23bb55dc725d6a
  PATCH ${PATCH_DIR}/rapidxml.patch
  DIFF ${REPO}/compare/
  )
########################################
function(build_rapidxml)
  if(NOT (XP_DEFAULT OR XP_PRO_RAPIDXML))
    return()
  endif()
  xpGetArgValue(${PRO_RAPIDXML} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_RAPIDXML} ARG VER VALUE VER)
  set(XP_CONFIGURE
    -DCMAKE_INSTALL_INCLUDEDIR=include/${NAME}_${VER}
    -DXP_INSTALL_CMAKEDIR=share/cmake/tgt-${NAME}
    -DXP_NAMESPACE:STRING=xpro
    )
  set(TARGETS_FILE tgt-${NAME}/${NAME}-targets.cmake)
  string(TOUPPER ${NAME} PRJ)
  set(USE_VARS "set(${PRJ}_LIBRARIES xpro::${NAME})\n")
  set(USE_VARS "${USE_VARS}list(APPEND reqVars ${PRJ}_LIBRARIES)\n")
  configure_file(${MODULES_DIR}/usexp.cmake.in
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  set(BUILD_CONFIGS Release) # this project is only copying headers
  xpCmakeBuild(${NAME} "" "${XP_CONFIGURE}")
endfunction()
