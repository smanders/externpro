# node-addon-api
xpProOption(node-addon-api)
set(VER 3.0.2)
set(REPO github.com/nodejs/node-addon-api)
set(PRO_NODE-ADDON-API
  NAME node-addon-api
  WEB "node-addon-api" https://${REPO} "node-addon-api on github"
  LICENSE "open" https://${REPO}/blob/${VER}/LICENSE.md "The MIT License - http://opensource.org/licenses/mit-license.php"
  DESC "Module for using N-API from C++"
  REPO "repo" https://${REPO} "node-addon-api repo on github"
  GRAPH BUILD_DEPS node
  VER ${VER}
  GIT_ORIGIN git://${REPO}.git
  GIT_TAG ${VER}
  DLURL https://${REPO}/archive/${VER}.tar.gz
  DLMD5 020c40cbb9af791f7934fa66f87c904c
  DLNAME node-addon-api-${VER}.tar.gz
  )
########################################
function(build_node_addon_api)
  if(NOT (XP_DEFAULT OR XP_PRO_NODE-ADDON-API))
    return()
  endif()
  xpBuildDeps(depTgts ${PRO_NODE-ADDON-API})
  xpGetArgValue(${PRO_NODE-ADDON-API} ARG VER VALUE VER)
  set(verDir /node-addon-api_${VER})
  configure_file(${PRO_DIR}/use/usexp-node-addon-api-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  ExternalProject_Get_Property(node-addon-api SOURCE_DIR)
  set(headers ${SOURCE_DIR}/*.h)
  ExternalProject_Add(node-addon-api_bld DEPENDS ${depTgts} node-addon-api
    DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${DWNLD_DIR} CONFIGURE_COMMAND ""
    SOURCE_DIR ${SOURCE_DIR} BINARY_DIR ${NULL_DIR}
    INSTALL_DIR ${STAGE_DIR}/include${verDir}/node-addon-api
    BUILD_COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${headers}
      -Ddst:STRING=<INSTALL_DIR> -P ${MODULES_DIR}/cmscopyfiles.cmake
    INSTALL_COMMAND ""
    )
  set_property(TARGET node-addon-api_bld PROPERTY FOLDER ${bld_folder})
  message(STATUS "target node-addon-api_bld")
endfunction()
