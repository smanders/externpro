# WXINCLUDE_FOUND - wxinclude was found
# WXINCLUDE_VER - wxinclude version
# WXINCLUDE_EXE - the wxinclude executable
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
# targets file (-targets) installed to bin/cmake
include(${XP_ROOTDIR}/bin/cmake/wxinclude-targets.cmake)
set(WXINCLUDE_VER "@VER@ [@PROJECT_NAME@]")
set(WXINCLUDE_EXE wxInclude)
set(reqVars WXINCLUDE_VER WXINCLUDE_EXE)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(wxinclude REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
