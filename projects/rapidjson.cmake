########################################
# RapidJSON
xpProOption(rapidjson)
set(VER 20140907) # date downloaded, no official releases or tags yet
set(TAG d0f98d2da1e2e6345831dc1ab2c30950417e6490)
set(REPO https://github.com/miloyip/rapidjson)
set(PRO_RAPIDJSON
  NAME rapidjson
  WEB "RapidJSON" http://miloyip.github.io/rapidjson/ "RapidJSON on githubio"
  LICENSE "open" https://raw.githubusercontent.com/miloyip/rapidjson/master/license.txt "The MIT License - http://opensource.org/licenses/mit-license.php"
  DESC "C++ library for parsing and generating JSON"
  REPO "repo" ${REPO} "rapidjson repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/miloyip/rapidjson.git
  GIT_TAG ${TAG}
  DLURL ${REPO}/archive/${TAG}.zip
  DLMD5 e2c2f352a2de67f67bf74e4a8112d369
  DLNAME rapidjson-${VER}.zip
  )
########################################
function(mkpatch_rapidjson)
  xpRepo(${PRO_RAPIDJSON})
endfunction()
########################################
function(download_rapidjson)
  xpNewDownload(${PRO_RAPIDJSON})
endfunction()
########################################
function(patch_rapidjson)
  xpPatch(${PRO_RAPIDJSON})
endfunction()
########################################
function(build_rapidjson)
  if(NOT (XP_DEFAULT OR XP_PRO_RAPIDJSON))
    return()
  endif()
  ExternalProject_Get_Property(rapidjson SOURCE_DIR)
  ExternalProject_Add(rapidjson_bld DEPENDS rapidjson
    DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${DWNLD_DIR} CONFIGURE_COMMAND ""
    SOURCE_DIR ${SOURCE_DIR} BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
    BUILD_COMMAND ${CMAKE_COMMAND} -E copy_directory
      <SOURCE_DIR>/include ${STAGE_DIR}/include
    INSTALL_COMMAND ""
    )
  set_property(TARGET rapidjson_bld PROPERTY FOLDER ${bld_folder})
  message(STATUS "target rapidjson_bld")
endfunction()
