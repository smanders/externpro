# CLANGTIDY_FOUND - clang-tidy was found
# CLANGTIDY_EXE - the clang-tidy executable
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
set(CLANGTIDY_EXE ${XP_ROOTDIR}/bin/clang-tidy${CMAKE_EXECUTABLE_SUFFIX})
set(reqVars CLANGTIDY_EXE)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(clangtidy REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
