# FLATBUFFERS_FOUND - flatbuffers was found
# FLATBUFFERS_VER - flatbuffers version
# FLATBUFFERS_LIBRARIES - the flatbuffers libraries
# FLATBUFFERS_FLATC - the flatbuffers compiler executable
set(prj flatbuffers)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
# flatbuffers installs a config file which includes all Targets.cmake files
include(${XP_ROOTDIR}/lib/cmake/${prj}_@VER@/FlatbuffersConfig.cmake)
set(${PRJ}_LIBRARIES xpro::flatbuffers)
set(${PRJ}_FLATC xpro::flatc)
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES ${PRJ}_FLATC)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
