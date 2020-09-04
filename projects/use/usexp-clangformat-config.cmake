# CLANGFORMAT_FOUND - clang-format was found
# CLANGFORMAT_VER - clang-format version
# CLANGFORMAT_EXE - the clang-format executable
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
set(CLANGFORMAT_VER "@VER@ [@PROJECT_NAME@]")
set(CLANGFORMAT_EXE ${XP_ROOTDIR}/bin/clang-format${CMAKE_EXECUTABLE_SUFFIX})
set(reqVars CLANGFORMAT_VER CLANGFORMAT_EXE)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(clangformat REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
