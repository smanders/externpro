set(prj boost)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(XP_USE_LATEST_BOOST ON)
if(NOT DEFINED XP_USE_LATEST_BOOST)
  option(XP_USE_LATEST_BOOST "build with boost @BOOST_NEWVER@ instead of @BOOST_OLDVER@" OFF)
endif()
if(XP_USE_LATEST_BOOST)
  set(BOOST_VER @BOOST_NEWVER@)
else()
  set(BOOST_VER @BOOST_OLDVER@)
endif()
set(BOOST_VERSION "${BOOST_VER} [@PROJECT_NAME@]")
if(NOT DEFINED Boost_LIBS)
  set(Boost_LIBS # dependency order
    log_setup # depends on log, regex, filesystem, thread, system (m, pthread)
    ######
    coroutine # depends on thread, context (m)
    log # depends on filesystem, thread, system (rt, pthread, m)
    timer # depends on chrono (m)
    #type_erasure # depends on thread, system (pthread, m) NEW with @BOOST_NEWVER@
    #wave # depends on thread, system (pthread, m) # NOTE: not a default
    ######
    chrono # depends on system (rt, pthread, m)
    #fiber # depends on context (pthread, m) NEW with @BOOST_NEWVER@
    filesystem # depends on system (pthread, m)
    graph # depends on regex (m)
    random # depends on system (pthread, m)
    thread # depends on system (rt, pthread, m)
    wserialization # depends on serialization (m)
    ######
    atomic
    container # depends on (pthread, m)
    context # depends on (pthread, m)
    date_time # depends on (pthread, m)
    exception
    iostreams # depends on (z, bz2, pthread, m)
    #math_c99 # depends on (pthread, m) # NOTE: not a default
    #math_c99f # depends on (pthread, m) # NOTE: not a default
    #math_c99l # depends on (pthread, m) # NOTE: not a default
    #math_tr1 # depends on (pthread, m) # NOTE: not a default
    #math_tr1f # depends on (pthread, m) # NOTE: not a default
    #math_tr1l # depends on (pthread, m) # NOTE: not a default
    #prg_exec_monitor # depends on (pthread, m) # NOTE: not a default
    program_options # depends on (pthread, m)
    python # depends on (pthread, m)
    regex # depends on (pthread, m)
    serialization # depends on (pthread, m)
    signals # depends on (pthread, m)
    system # depends on (pthread, m)
    test_exec_monitor
    unit_test_framework # depends on (pthread, m)
    )
  # NOTE: determined boost library dependency order by building boost on linux
  # with link=shared and runtime-link=shared and using ldd
endif()
list(FIND Boost_LIBS iostreams idx)
if(NOT ${idx} EQUAL -1)
  xpGetPkgVar(zlib LIBRARIES) # sets ZLIB_LIBRARIES
  xpGetPkgVar(bzip2 LIBRARIES) # sets BZIP2_LIBRARIES
endif()
unset(Boost_INCLUDE_DIR CACHE)
unset(Boost_LIBRARY_DIR CACHE)
foreach(lib ${Boost_LIBS})
  string(TOUPPER ${lib} UPPERLIB)
  unset(Boost_${UPPERLIB}_LIBRARY_DEBUG CACHE)
  unset(Boost_${UPPERLIB}_LIBRARY_RELEASE CACHE)
endforeach()
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1.\\2" BOOST_VER2 ${BOOST_VER})
set(Boost_ADDITIONAL_VERSIONS ${BOOST_VER} ${BOOST_VER2})
if(UNIX)
  if(DEFINED ZLIB_LIBRARIES AND DEFINED BZIP2_LIBRARIES)
    set(syslibs $<TARGET_FILE:${ZLIB_LIBRARIES}> $<TARGET_FILE:${BZIP2_LIBRARIES}>)
  endif()
  include(CheckLibraryExists)
  function(checkLibraryConcat lib symbol liblist)
    string(TOUPPER ${lib} LIB)
    check_library_exists("${lib}" "${symbol}" "" XP_BOOST_HAS_${LIB})
    if(XP_BOOST_HAS_${LIB})
      list(APPEND ${liblist} ${lib})
      set(${liblist} ${${liblist}} PARENT_SCOPE)
    endif()
  endfunction()
  checkLibraryConcat(m pow syslibs)
  checkLibraryConcat(pthread pthread_create syslibs)
  checkLibraryConcat(rt shm_open syslibs)
  # see FindBoost.cmake for details on the following variables
  set(Boost_FIND_QUIETLY TRUE)
  set(Boost_NO_SYSTEM_PATHS TRUE)
  set(Boost_USE_STATIC_LIBS ON)
  set(Boost_USE_MULTITHREADED ON)
  set(Boost_USE_STATIC_RUNTIME ON)
  #set(Boost_DEBUG TRUE) # enable debugging output of FindBoost.cmake
  #set(Boost_DETAILED_FAILURE_MSG) # output detailed information
  set(BOOST_ROOT ${XP_ROOTDIR})
  # TODO: remove the following once FindBoost.cmake: uses -dumpfullversion, detects clang
  if(TRUE) #"${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")
    include(${CMAKE_CURRENT_LIST_DIR}/xpfunmac.cmake)
    xpGetCompilerPrefix(Boost_COMPILER GCC_TWO_VER)
    set(Boost_COMPILER "-${Boost_COMPILER}")
  endif()
  find_package(Boost ${BOOST_VER} REQUIRED COMPONENTS ${Boost_LIBS})
  set(${PRJ}_FOUND ${Boost_FOUND})
  set(${PRJ}_INCLUDE_DIR ${Boost_INCLUDE_DIRS})
  function(listPrependToAll var prefix)
    set(listVar)
    foreach(f ${ARGN})
      list(APPEND listVar "${prefix}${f}")
    endforeach()
    set(${var} "${listVar}" PARENT_SCOPE)
  endfunction()
  listPrependToAll(boostLibs "Boost::" ${Boost_LIBS})
  # TRICKY: Boost_LIBRARIES returned from find_package() introduces hard-coded absolute
  # paths and wrecks havoc on cmake-generated targets files, hence boostLibs
  set(${PRJ}_LIBRARIES ${boostLibs} ${syslibs})
  set(reqVars ${PRJ}_VERSION ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
else()
  string(REPLACE "." "_" VER_ ${BOOST_VER2})
  set(${PRJ}_INCLUDE_DIR ${XP_ROOTDIR}/include/boost-${VER_})
  if(EXISTS ${${PRJ}_INCLUDE_DIR} AND IS_DIRECTORY ${${PRJ}_INCLUDE_DIR})
    set(${PRJ}_FOUND TRUE)
  else()
    set(${PRJ}_FOUND FALSE)
  endif()
  link_directories(${XP_ROOTDIR}/lib)
  set(reqVars ${PRJ}_VERSION ${PRJ}_INCLUDE_DIR)
  if(DEFINED ZLIB_LIBRARIES AND DEFINED BZIP2_LIBRARIES)
    set(${PRJ}_DEFINITIONS
      -DBOOST_ZLIB_BINARY=$<TARGET_FILE:${ZLIB_LIBRARIES}>
      -DBOOST_BZIP2_BINARY=$<TARGET_FILE:${BZIP2_LIBRARIES}>
      )
    list(APPEND reqVars ${PRJ}_DEFINITIONS)
  endif()
endif()
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
