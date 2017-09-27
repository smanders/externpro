# FFTW_FOUND - fftw was found
# FFTW_INCLUDE_DIR - the fftw include directory
# FFTW_LIBRARIES - the fftw libraries
set(prj fftw)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(ver _@VER@)
set(verDir /${prj}${ver})
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR fftw3/fftw3.h PATHS ${XP_ROOTDIR}/include${verDir} NO_DEFAULT_PATH)
if(EXISTS ${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake) # built via cmake (MSW)
  # targets file (-targets) installed to lib/cmake
  include(${XP_ROOTDIR}/lib/cmake/${prj}${ver}-targets.cmake)
  set(${PRJ}_LIBRARIES libfftw3-3 libfftw3f-3 libfftw3l-3)
else() # built via configure/make (UNIX)
  set(${PRJ}_LIBRARIES
    optimized fftw3${ver}  debug fftw3${ver}-d  # double precision FFTW
    optimized fftw3f${ver} debug fftw3f${ver}-d # single precision FFTW
    )
endif()
set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
