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
  xpGetArgValue(${PRO_RAPIDJSON} ARG VER VALUE VER)
  set(verDir /rapidjson_${VER})
  configure_file(${PRO_DIR}/use/usexp-rapidjson-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  ExternalProject_Get_Property(rapidjson SOURCE_DIR)
  ExternalProject_Add(rapidjson_bld DEPENDS rapidjson
    DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${DWNLD_DIR} CONFIGURE_COMMAND ""
    SOURCE_DIR ${SOURCE_DIR} BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory
      <SOURCE_DIR>/include ${STAGE_DIR}/include${verDir}
    INSTALL_COMMAND ""
    )
  set_property(TARGET rapidjson_bld PROPERTY FOLDER ${bld_folder})
  message(STATUS "target rapidjson_bld")
endfunction()
