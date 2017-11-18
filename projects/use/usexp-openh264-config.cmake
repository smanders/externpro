# OPENH264_FOUND - OpenH264 was found
# OPENH264_INCLUDE_DIR - the OpenH264 include directory
# OPENH264_DLLS - the OpenH264 shared object (dll, so)
set(prj openh264)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
unset(${PRJ}_INCLUDE_DIR CACHE)
find_path(${PRJ}_INCLUDE_DIR openh264/codec_api.h PATHS ${XP_ROOTDIR}/include@verDir@ NO_DEFAULT_PATH)
set(${PRJ}_DLLS ${XP_ROOTDIR}/lib/@sharedObj@)
list(APPEND reqVars ${PRJ}_INCLUDE_DIR ${PRJ}_DLLS)
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
