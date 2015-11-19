# CLANGFORMAT_FOUND - clang-format was found
# CLANGFORMAT_EXE - the clang-format executable
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
# targets file (-targets) installed to bin/cmake
include(${XP_ROOTDIR}/bin/cmake/clang-format-targets.cmake)
set(CLANGFORMAT_EXE clang-format)
set(reqVars CLANGFORMAT_EXE)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(clangformat REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
