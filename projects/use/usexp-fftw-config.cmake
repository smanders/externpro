# FFTW_FOUND - fftw was found
# FFTW_VER - fftw version
# FFTW_INCLUDE_DIR - the fftw include directory
# FFTW_LIBRARIES - the fftw libraries
set(prj fftw)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR fftw3/fftw3.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
if(EXISTS ${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake) # built via cmake (MSW)
  # targets file (-targets) installed to lib/cmake
  include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
else() # built via configure/make (UNIX)
  foreach(lib libfftw3 libfftw3f libfftw3l)
    add_library(${lib}-3 STATIC IMPORTED)
    set(${lib}_RELEASE ${XP_ROOTDIR}/lib/${lib}${ver}.a)
    set(${lib}_DEBUG ${XP_ROOTDIR}/lib/${lib}${ver}-d.a)
    foreach(cfg RELEASE DEBUG)
      if(EXISTS "${${lib}_${cfg}}")
        set_property(TARGET ${lib}-3 APPEND PROPERTY IMPORTED_CONFIGURATIONS ${cfg})
        set_target_properties(${lib}-3 PROPERTIES
          IMPORTED_LINK_INTERFACE_LANGUAGES_${cfg} "C"
          IMPORTED_LOCATION_${cfg} "${${lib}_${cfg}}"
          )
      endif()
    endforeach()
  endforeach()
endif()
set(${PRJ}_LIBRARIES libfftw3-3 libfftw3f-3 libfftw3l-3)
set(reqVars ${PRJ}_VER ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
