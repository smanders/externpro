# RapidJSON
xpProOption(rapidjson)
set(VER 1.1.0)
set(REPO github.com/miloyip/rapidjson)
set(PRO_RAPIDJSON
  NAME rapidjson
  WEB "RapidJSON" http://miloyip.github.io/rapidjson/ "RapidJSON on githubio"
  LICENSE "open" https://raw.githubusercontent.com/miloyip/rapidjson/master/license.txt "The MIT License - http://opensource.org/licenses/mit-license.php"
  DESC "C++ library for parsing and generating JSON"
  REPO "repo" https://${REPO} "rapidjson repo on github"
  VER ${VER}
  GIT_ORIGIN https://${REPO}.git
  GIT_TAG v${VER}
  DLURL https://${REPO}/archive/v${VER}.tar.gz
  DLMD5 badd12c511e081fec6c89c43a7027bce
  DLNAME rapidjson-${VER}.tar.gz
  )
########################################
function(build_rapidjson)
  if(NOT (XP_DEFAULT OR XP_PRO_RAPIDJSON))
    return()
  endif()
  xpGetArgValue(${PRO_RAPIDJSON} ARG NAME VALUE NAME)
  xpGetArgValue(${PRO_RAPIDJSON} ARG VER VALUE VER)
  set(LIBRARY_HDR xpro::${NAME})
  set(LIBRARY_INCLUDEDIRS include/${NAME}_${VER})
  configure_file(${PRO_DIR}/use/usexp-template-hdr-config.cmake
    ${STAGE_DIR}/share/cmake/usexp-${NAME}-config.cmake
    @ONLY NEWLINE_STYLE LF
    )
  ExternalProject_Get_Property(${NAME} SOURCE_DIR)
  ExternalProject_Add(${NAME}_bld DEPENDS ${NAME}
    DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} CONFIGURE_COMMAND ""
    SOURCE_DIR ${SOURCE_DIR} BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory
      <SOURCE_DIR>/include ${STAGE_DIR}/${LIBRARY_INCLUDEDIRS}
    INSTALL_COMMAND ""
    )
  set_property(TARGET ${NAME}_bld PROPERTY FOLDER ${bld_folder})
  message(STATUS "target ${NAME}_bld")
endfunction()
