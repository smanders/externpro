# GLEW_FOUND - GLEW was found
# GLEW_INCLUDE_DIR - the GLEW include directory
# GLEW_LIBRARIES - the GLEW libraries
# GLEW_DLLS - the GLEW DLLs
set(prj glew)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
if(MSVC)
  unset(${PRJ}_INCLUDE_DIR CACHE)
  find_path(${PRJ}_INCLUDE_DIR GL/glew.h PATHS ${XP_ROOTDIR}/include@verDir@ NO_DEFAULT_PATH)
  set(${PRJ}_LIBRARIES glew32)
  set(${PRJ}_DLLS
    ${XP_ROOTDIR}/lib/glew32.dll
    ${XP_ROOTDIR}/lib/glew32mx.dll # TODO determine if this is needed
    )
  set(reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_LIBRARIES ${PRJ}_DLLS)
else()
  set(reqVars CMAKE_CURRENT_LIST_FILE)
endif()
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
