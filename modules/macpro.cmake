########################################
# macpro.cmake
#  mac = macros
#  pro = meant for internal use by externpro
# macros should begin with pro prefix

macro(proInit) # NOTE: called by top-level CMakeLists.txt
  include(ExternalProject) # include cmake ExternalProject module
  mark_as_advanced(CMAKE_BUILD_TYPE) # this project doesn't build anything
  mark_as_advanced(CMAKE_INSTALL_PREFIX) # not applicable
  # Set configuration types
  if(CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_CONFIGURATION_TYPES "Release" CACHE STRING
      "Set the configurations to what we need" FORCE
      )
    mark_as_advanced(CMAKE_CONFIGURATION_TYPES)
  endif()
  # Set directory locations
  if(NOT DEFINED DWNLD_DIR)
    set(DWNLD_DIR ${CMAKE_BINARY_DIR}/../_bldpkgs)
  endif()
  if(NOT EXISTS ${DWNLD_DIR})
    execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${DWNLD_DIR})
  endif()
  if(${CMAKE_PROJECT_NAME} STREQUAL externpro)
    set(MODULES_DIR ${CMAKE_SOURCE_DIR}/modules)
  elseif(DEFINED externpro_DIR)
    set(MODULES_DIR ${externpro_DIR}/share/cmake)
  else()
    message(FATAL_ERROR "unable to set MODULES_DIR")
  endif()
  set_property(DIRECTORY PROPERTY "EP_BASE" ${CMAKE_BINARY_DIR}/xpbase) # ExternalProject
  set(NULL_DIR ${CMAKE_BINARY_DIR}/xpbase/tmp/nulldir)
  # the following *_folder for TARGET PROPERTY FOLDER (MSVC organization)
  set(dwnld_folder "download")
  set(src_folder "source")
  set(bld_folder "build")
  set_property(GLOBAL PROPERTY USE_FOLDERS ON) # enables MSVC Solution Folders
  # Find git
  include(FindGit)
  if(NOT GIT_FOUND AND NOT UNIX)
    find_program(GIT_EXECUTABLE
      NAMES git.exe HINTS $ENV{SystemDrive}/cygwin/bin
      DOC "git command line client (cygwin)"
      )
    if(GIT_EXECUTABLE)
      find_package(Git)
    endif()
  endif()
  proSetOpts()
  proInitFunFiles()
endmacro()

macro(proSetOpts) # NOTE: called by proInit
  option(XP_DEFAULT "do the default projects" ON)
  if(NOT XP_STEP) # if not specified, default to "patch"
    set(XP_STEP "patch" CACHE STRING
      "Choose the steps to execute, options are: mkpatch download patch build."
      FORCE
      )
  else()
    set(XP_STEP ${XP_STEP} CACHE STRING
      "Choose the steps to execute, options are: mkpatch download patch build."
      FORCE
      )
  endif()
  message(STATUS "[mkpatch]  execute only task 0: clone, checkout, make patches")
  message(STATUS "[download] execute only step 1: download compressed archives")
  message(STATUS "           (suitable for light transport)")
  message(STATUS "[patch]    execute through step 2: expand and patch")
  message(STATUS "           (suitable for debug, step into source)")
  message(STATUS "[build]    execute through step 3: build the platform-specific binaries")
  set(XP_BUILD_RELEASE ON) # release is *always* built, debug is optional
  option(XP_BUILD_DEBUG "build debug (note: release is *always* built)" ON)
  if(MSVC)
    if((${CMAKE_GENERATOR} MATCHES "Win64$") AND (CMAKE_SIZEOF_VOID_P EQUAL 8))
      set(XP_BUILD_64BIT ON)
      set(XP_BUILD_32BIT OFF)
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
      set(XP_BUILD_64BIT OFF)
      set(XP_BUILD_32BIT ON)
    else()
      proPlatformOpts()
    endif()
    option(XP_BUILD_STATIC "build with static runtime (/MT), OFF: dynamic runtime (/MD)" ON)
  else()
    if((${CMAKE_SYSTEM_NAME} STREQUAL SunOS) OR (CMAKE_SIZEOF_VOID_P EQUAL 8))
      set(XP_BUILD_64BIT ON)
      set(XP_BUILD_32BIT OFF)
    elseif(CMAKE_SIZEOF_VOID_P EQUAL 4)
      set(XP_BUILD_64BIT OFF)
      set(XP_BUILD_32BIT ON)
    else()
      proPlatformOpts()
    endif()
  endif()
  option(XP_BUILD_VERBOSE "show build target details" OFF)
  # hide options if step isn't build...
  if(${XP_STEP} STREQUAL "build" AND MSVC)
    set_property(CACHE XP_BUILD_STATIC PROPERTY TYPE BOOL)
  elseif(MSVC)
    set_property(CACHE XP_BUILD_STATIC PROPERTY TYPE INTERNAL)
  endif()
  if(${XP_STEP} STREQUAL "build")
    set_property(CACHE XP_BUILD_DEBUG PROPERTY TYPE BOOL)
    set_property(CACHE XP_BUILD_VERBOSE PROPERTY TYPE BOOL)
  else()
    set_property(CACHE XP_BUILD_DEBUG PROPERTY TYPE INTERNAL)
    set_property(CACHE XP_BUILD_VERBOSE PROPERTY TYPE INTERNAL)
  endif()
endmacro()

macro(proPlatformOpts)
  option(XP_BUILD_64BIT "build 64-bit" ON)
  option(XP_BUILD_32BIT "build 32-bit" OFF)
  if(${XP_STEP} STREQUAL "build")
    set_property(CACHE XP_BUILD_64BIT PROPERTY TYPE BOOL)
    set_property(CACHE XP_BUILD_32BIT PROPERTY TYPE BOOL)
  else()
    set_property(CACHE XP_BUILD_64BIT PROPERTY TYPE INTERNAL)
    set_property(CACHE XP_BUILD_32BIT PROPERTY TYPE INTERNAL)
  endif()
endmacro()

macro(proInitFunFiles) # NOTE: called by proInit
  # cmake-generate the pro_${XP_STEP}.cmake function files
  set(stepMkpatch ${CMAKE_BINARY_DIR}/pro_mkpatch.cmake)
  set(stepDownload ${CMAKE_BINARY_DIR}/pro_download.cmake)
  set(stepPatch ${CMAKE_BINARY_DIR}/pro_patch.cmake)
  set(stepBuild ${CMAKE_BINARY_DIR}/pro_build.cmake)
  ####
  file(WRITE ${stepMkpatch} "message(STATUS \"XP_STEP: mkpatch\")\n")
  file(WRITE ${stepDownload} "message(STATUS \"XP_STEP: download\")\n")
  ####
  file(WRITE ${stepPatch} "proGetBuildLists()\n")
  file(APPEND ${stepPatch} "message(STATUS \"XP_STEP: patch\")\n")
  ####
  file(WRITE ${stepBuild} "proGetBuildLists()\n")
  file(APPEND ${stepBuild} "message(STATUS \"[build] -- platform: \${BUILD_PLATFORM}-bit\")\n")
  file(APPEND ${stepBuild} "message(STATUS \"[build] -- configurations: \${BUILD_CONFIGS}\")\n")
  file(APPEND ${stepBuild} "message(STATUS \"XP_STEP: build\")\n")
  file(APPEND ${stepBuild} "proSetStageDir()\n")
  ####
  include(${MODULES_DIR}/xpfunmac.cmake)
  file(GLOB srcList ${CMAKE_BINARY_DIR}/pro_*.cmake ${MODULES_DIR}/*.cmake ${MODULES_DIR}/*.in)
  xpSourceListAppend("${srcList}")
endmacro()

macro(proAddProjectDir proDir) # NOTE: called by top-level CMakeLists.txt
  get_filename_component(PRO_DIR ${proDir} ABSOLUTE)
  get_filename_component(PATCH_DIR ${PRO_DIR}/../patches ABSOLUTE)
  xpMarkdownReadmeInit()
  # include the project.cmake and usexp-project-config.cmake files
  file(GLOB projects ${PRO_DIR}/*.cmake)
  file(GLOB useScripts ${PRO_DIR}/use/usexp-*-config.cmake)
  list(SORT projects) # sort list in-place alphabetically
  list(SORT useScripts)
  xpSourceListAppend("${projects}")
  xpSourceListAppend("${useScripts}")
  foreach(proj ${projects})
    include(${proj})
    get_filename_component(pro ${proj} NAME_WE)
    if(COMMAND mkpatch_${pro})
      file(APPEND ${stepMkpatch} "mkpatch_${pro}()\n")
    endif()
    if(COMMAND download_${pro})
      file(APPEND ${stepDownload} "download_${pro}()\n")
    endif()
    if(COMMAND patch_${pro})
      file(APPEND ${stepPatch} "patch_${pro}()\n")
    endif()
    if(COMMAND build_${pro})
      file(APPEND ${stepBuild} "build_${pro}()\n")
    endif()
    xpMarkdownReadmeAppend(${pro})
  endforeach()
  file(GLOB files ${PRO_DIR}/README* ${PROJECT_SOURCE_DIR}/README*)
  xpSourceListAppend("${files}")
endmacro()

macro(proExecuteStep) # NOTE: called by top-level CMakeLists.txt
  if(${XP_STEP} STREQUAL "mkpatch")
    if(NOT GIT_EXECUTABLE)
      message(FATAL_ERROR "mkpatch step requires GIT_EXECUTABLE to be set")
    endif()
    include(${CMAKE_BINARY_DIR}/pro_mkpatch.cmake)
    xpMarkdownReadmeFinalize()
  elseif(${XP_STEP} STREQUAL "download")
    include(${CMAKE_BINARY_DIR}/pro_download.cmake)
    xpMarkdownReadmeFinalize()
  elseif(${XP_STEP} STREQUAL "patch")
    include(${CMAKE_BINARY_DIR}/pro_patch.cmake)
    xpMarkdownReadmeFinalize()
  elseif(${XP_STEP} STREQUAL "build")
    include(${CMAKE_BINARY_DIR}/pro_patch.cmake)
    include(${CMAKE_BINARY_DIR}/pro_build.cmake)
    install(DIRECTORY ${STAGE_DIR}/ DESTINATION . USE_SOURCE_PERMISSIONS)
    proSetCpackOpts()
    include(CPack)
  else()
    message(AUTHOR_WARNING "Invalid XP_STEP specified.")
  endif()
  xpGenerateCscopeDb()
endmacro()

macro(proGetBuildLists) # NOTE: called by cmake-generated pro_[patch|build].cmake files
  # BUILD_PLATFORM
  if(NOT XP_BUILD_64BIT AND NOT XP_BUILD_32BIT) # at least one platform should be set
    message(FATAL_ERROR "neither XP_BUILD_64BIT or XP_BUILD_32BIT are set")
  endif()
  if(XP_BUILD_64BIT AND XP_BUILD_32BIT) # only one platform should be set
    message(FATAL_ERROR "must choose only one: XP_BUILD_64BIT or XP_BUILD_32BIT")
  endif()
  if(XP_BUILD_64BIT)
    set(BUILD_PLATFORM 64)
  elseif(XP_BUILD_32BIT)
    set(BUILD_PLATFORM 32)
  endif()
  # BUILD_CONFIGS
  if(NOT XP_BUILD_RELEASE AND NOT XP_BUILD_DEBUG)
    message(FATAL_ERROR "no build configuration (debug, release) is set")
  endif()
  if(XP_BUILD_RELEASE)
    xpListAppendIfDne(BUILD_CONFIGS Release)
  endif()
  if(XP_BUILD_DEBUG)
    xpListAppendIfDne(BUILD_CONFIGS Debug)
  endif()
endmacro()

macro(proSetStageDir) # NOTE: called by cmake-generated pro_build.cmake file
  if(NOT DEFINED INSTALL_NAME)
    set(INSTALL_NAME ${PROJECT_NAME})
  endif()
  set(STAGE_DIR ${CMAKE_BINARY_DIR}/${INSTALL_NAME})
  if(GIT_FOUND AND EXISTS ${CMAKE_SOURCE_DIR}/.git)
    execute_process(COMMAND ${GIT_EXECUTABLE} describe --tags
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      OUTPUT_VARIABLE GIT_DESCRIBE
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    if(GIT_DESCRIBE)
      # add prefix if git repo is dirty
      execute_process(COMMAND ${GIT_EXECUTABLE} status --porcelain
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE dirty
        )
      if(dirty AND UNIX)
        set(PREFIX "$ENV{USER}-dirtyrepo-")
      elseif(dirty AND WIN32)
        set(PREFIX "$ENV{USERNAME}-dirtyrepo-")
      endif()
      xpGetCompilerPrefix(COMPILER)
      if(NOT XP_DEFAULT)
        set(PARTIAL "-p")
      endif()
      set(GIT_REV ${PREFIX}${GIT_DESCRIBE}${PARTIAL}-${COMPILER}-${BUILD_PLATFORM})
      set(STAGE_DIR ${STAGE_DIR}_${GIT_REV})
      file(WRITE ${STAGE_DIR}/${INSTALL_NAME}_${GIT_REV}.txt "${GIT_REV}\n")
      execute_process(COMMAND uname -a
        OUTPUT_VARIABLE sysinfo
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_VARIABLE unameErr
        )
      if(NOT unameErr)
        file(APPEND ${STAGE_DIR}/${INSTALL_NAME}_${GIT_REV}.txt "${sysinfo}\n")
      endif()
    endif()
  endif()
  # copy modules to stage
  configure_file(${MODULES_DIR}/Findscript.cmake.in
    ${STAGE_DIR}/share/cmake/Find${CMAKE_PROJECT_NAME}.cmake
    @ONLY NEWLINE_STYLE LF
    )
  if(${CMAKE_PROJECT_NAME} STREQUAL externpro)
    configure_file(${MODULES_DIR}/xpopts.cmake.in
      ${STAGE_DIR}/share/cmake/xpopts.cmake
      @ONLY NEWLINE_STYLE LF
      )
    execute_process(COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${MODULES_DIR}/*.cmake
      -Ddst:PATH=${STAGE_DIR}/share/cmake -P ${MODULES_DIR}/cmscopyfiles.cmake
      )
    execute_process(COMMAND ${CMAKE_COMMAND} -Dsrc:STRING=${MODULES_DIR}/*.in
      -Ddst:PATH=${STAGE_DIR}/share/cmake -P ${MODULES_DIR}/cmscopyfiles.cmake
      )
    set(MODULES_DIR ${STAGE_DIR}/share/cmake) # use the out-of-source modules now
  endif()
endmacro()

macro(proSetCpackOpts) # NOTE: called by proExecuteStep
  if(GIT_REV)
    set(CPACK_PACKAGE_VERSION ${GIT_REV})
  else()
    set(CPACK_PACKAGE_VERSION "unknown-version")
  endif()
  set(CPACK_PACKAGE_VENDOR "Space Dynamics Lab")
  if(UNIX AND NOT DEFINED CPACK_GENERATOR)
    set(CPACK_GENERATOR STGZ) # STGZ = Self extracting Tar GZip compression
  endif()
endmacro()
