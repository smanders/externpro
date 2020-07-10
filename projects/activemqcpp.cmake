# activemqcpp
set(AMQ_OLDVER 3.9.5)
set(AMQ_NEWVER 3.9.5)
########################################
function(build_activemqcpp)
  if(NOT (XP_DEFAULT OR XP_PRO_ACTIVEMQCPP_${AMQ_OLDVER} OR XP_PRO_ACTIVEMQCPP_${AMQ_NEWVER}))
    return()
  endif()
  if(XP_DEFAULT)
    set(AMQ_VERSIONS ${AMQ_OLDVER} ${AMQ_NEWVER})
  else()
    if(XP_PRO_ACTIVEMQCPP_${AMQ_OLDVER})
      set(AMQ_VERSIONS ${AMQ_OLDVER})
    endif()
    if(XP_PRO_ACTIVEMQCPP_${AMQ_NEWVER})
      list(APPEND AMQ_VERSIONS ${AMQ_NEWVER})
    endif()
  endif()
  list(REMOVE_DUPLICATES AMQ_VERSIONS)
  list(LENGTH AMQ_VERSIONS NUM_VER)
  if(NUM_VER EQUAL 1)
    if(AMQ_VERSIONS VERSION_EQUAL AMQ_OLDVER)
      set(boolean OFF)
    else() # AMQ_VERSIONS VERSION_EQUAL AMQ_NEWVER
      set(boolean ON)
    endif()
    set(ONE_VER "set(XP_USE_LATEST_ACTIVEMQCPP ${boolean}) # currently only one version supported\n")
  endif()
  set(MOD_OPT "set(VER_MOD)")
  set(USE_SCRIPT_INSERT ${ONE_VER}${MOD_OPT})
  configure_file(${PRO_DIR}/use/usexp-activemqcpp-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE_${AMQ_OLDVER}
    )
  set(XP_CONFIGURE_${AMQ_NEWVER}
    )
  foreach(ver ${AMQ_VERSIONS})
    xpBuildDeps(depTgts ${PRO_ACTIVEMQCPP_${ver}})
    set(XP_CONFIGURE
      -DFIND_APR_MODULE_PATH=ON
      -DFIND_OPENSSL_MODULE_PATH=ON
      -DACTIVEMQCPP_VER=${ver}
      -DFPHSA_NAME_MISMATCHED:BOOL=TRUE # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
      ${XP_CONFIGURE_${ver}}
      )
    xpCmakeBuild(activemqcpp_${ver} "${depTgts}" "${XP_CONFIGURE}")
  endforeach()
endfunction()
