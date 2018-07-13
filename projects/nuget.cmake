# nuget
xpProOption(nuget)
set(VER 2.8.6)
set(PRO_NUGET
  NAME nuget
  WEB "NuGet" https://www.nuget.org "NuGet website"
  LICENSE "MIT" "https://docs.microsoft.com/en-us/nuget/policies/nuget-faq#nuget-command-line" "MIT"
  DESC "pre-built (MSW) the package manager for .NET"
  REPO "repo" https://github.com/NuGet "NuGet on github"
  VER ${VER}
  DLURL https://dist.nuget.org/win-x86-commandline/v${VER}/nuget.exe
  DLMD5 ef16c016d7eb396c8f65888a53b69d78
  )
########################################
function(patch_nuget)
  # do nothing here
  # don't want xpPatchProject(${PRO_NUGET}) called automatically
  # because then an ExternalProject_Add(nuget) will try to extract the executable
  # which doesn't make any sense...
endfunction()
########################################
function(build_nuget)
  if(NOT (XP_DEFAULT OR XP_PRO_NUGET))
    return()
  endif()
  if(NOT MSVC)
    return()
  endif()
  xpGetArgValue(${PRO_NUGET} ARG DLURL VALUE dwnldUrl)
  get_filename_component(fn ${dwnldUrl} NAME)
  if(NOT TARGET download_${fn})
    xpDownloadProject(${PRO_NUGET}) # download_${fn} target
    message(STATUS "target download_${fn}")
  endif()
  set(tgtDep download_${fn})
  if(DEFINED XP_NUGET_COMPLETE_PKG)
    xpGetArgValue(${PRO_NUGET} ARG VER VALUE VER)
    configure_file(${PRO_DIR}/use/usexp-nuget-config.cmake ${STAGE_DIR}/share/cmake/
      @ONLY NEWLINE_STYLE LF
      )
    if(NOT TARGET nuget_bld)
      ExternalProject_Add(nuget_bld DEPENDS ${tgtDep}
        DOWNLOAD_COMMAND "" DOWNLOAD_DIR ${NULL_DIR} CONFIGURE_COMMAND ""
        SOURCE_DIR ${NULL_DIR} BINARY_DIR ${NULL_DIR} INSTALL_DIR ${NULL_DIR}
        BUILD_COMMAND ${CMAKE_COMMAND} -E copy_if_different ${DWNLD_DIR}/${fn} ${STAGE_DIR}/bin/${fn}
        INSTALL_COMMAND ""
        )
      set_property(TARGET nuget_bld PROPERTY FOLDER ${bld_folder})
      message(STATUS "target nuget_bld")
    endif()
    set(tgtDep nuget_bld)
  endif()
  if(ARGN)
    set(${ARGN} ${tgtDep} PARENT_SCOPE)
    set(NUGET_EXE ${DWNLD_DIR}/${fn} PARENT_SCOPE)
  endif()
endfunction()
