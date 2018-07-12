# NUGET_FOUND - nuget was found
# NUGET_VER - nuget version
# NUGET_EXE - the nuget executable (MSVC on Windows only)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
set(NUGET_VER "@VER@ [@PROJECT_NAME@]")
set(reqVars NUGET_VER)
if(MSVC)
  set(NUGET_EXE ${XP_ROOTDIR}/bin/nuget.exe)
  list(APPEND reqVars NUGET_EXE)
endif()
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(nuget REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
