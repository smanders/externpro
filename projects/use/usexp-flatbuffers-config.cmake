# FLATBUFFERS_FOUND - flatbuffers was found
# FLATBUFFERS_VER - flatbuffers version
# FLATBUFFERS_LIBRARIES - the flatbuffers libraries
# FLATBUFFERS_FLATC_EXECUTABLE - the flatbuffers compiler executable
set(prj flatbuffers)
# this file (-config) installed to share/cmake
get_filename_component(XP_ROOTDIR ${CMAKE_CURRENT_LIST_DIR}/../.. ABSOLUTE)
get_filename_component(XP_ROOTDIR ${XP_ROOTDIR} ABSOLUTE) # remove relative parts
string(TOUPPER ${prj} PRJ)
set(${PRJ}_VER "@VER@ [@PROJECT_NAME@]")
# flatbuffers installs a config file which includes all Targets.cmake files
include(${XP_ROOTDIR}/lib/cmake/${prj}_@VER@/FlatbuffersConfig.cmake)
set(${PRJ}_LIBRARIES xpro::flatbuffers)
set(${PRJ}_FLATC_EXECUTABLE xpro::flatc)
include(${XP_ROOTDIR}/lib/cmake/${prj}_@VER@/BuildFlatBuffers.cmake) # build_flatbuffers cmake function
set(reqVars ${PRJ}_VER ${PRJ}_LIBRARIES ${PRJ}_FLATC_EXECUTABLE)
include(FindPackageHandleStandardArgs)
set(FPHSA_NAME_MISMATCHED TRUE) # find_package_handle_standard_args NAME_MISMATCHED (prefix usexp-)
find_package_handle_standard_args(${prj} REQUIRED_VARS ${reqVars})
mark_as_advanced(${reqVars})
function(xpFlatBuffersBuild)
  set(options PUBLIC_INCLUDES)
  set(oneValueArgs TARGET CUSTOM_TARGET_NAME GENERATED_INCLUDES_DIR BINARY_SCHEMAS_DIR COPY_TEXT_SCHEMAS_DIR)
  set(multiValueArgs SCHEMAS SCHEMA_INCLUDE_DIRS ADDITIONAL_DEPS)
  cmake_parse_arguments(P "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  if(NOT P_CUSTOM_TARGET_NAME)
    if(P_TARGET)
      set(P_CUSTOM_TARGET_NAME ${P_TARGET}_fbs)
    else()
      set(P_CUSTOM_TARGET_NAME ${PROJECT_NAME}_fbs)
    endif()
  endif()
  if(NOT P_GENERATED_INCLUDES_DIR)
    set(P_GENERATED_INCLUDES_DIR ${CMAKE_CURRENT_BINARY_DIR}/fbs)
  endif()
  build_flatbuffers("${P_SCHEMAS}" "${P_SCHEMA_INCLUDE_DIRS}" ${P_CUSTOM_TARGET_NAME}
    "${P_ADDITIONAL_DEPS}" "${P_GENERATED_INCLUDES_DIR}"
    "${P_BINARY_SCHEMAS_DIR}" "${P_COPY_TEXT_SCHEMAS_DIR}"
    )
  if(P_TARGET)
    if(P_PUBLIC_INCLUDES)
      set(scope PUBLIC)
    else()
      set(scope PRIVATE)
    endif()
    add_dependencies(${P_TARGET} ${P_CUSTOM_TARGET_NAME})
    target_include_directories(${P_TARGET} ${scope} ${P_GENERATED_INCLUDES_DIR})
  endif()
endfunction()
function(xpFlatBuffersBuildTS)
  set(oneValueArgs OUTPUT_DIR TARGET)
  set(multiValueArgs SCHEMAS)
  cmake_parse_arguments(P "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  xpGetPkgVar(flatbuffers FLATC_EXECUTABLE) # sets FLATBUFFERS_FLATC_EXECUTABLE
  set(cmdFile "${CMAKE_CURRENT_BINARY_DIR}/${P_TARGET}_fbs_ts_cmd")
  add_custom_command(OUTPUT ${cmdFile}
    COMMAND $<TARGET_FILE:${FLATBUFFERS_FLATC_EXECUTABLE}> --ts -o ${P_OUTPUT_DIR} ${P_SCHEMAS}
    COMMAND ${CMAKE_COMMAND} -E touch ${cmdFile}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${P_SCHEMAS}
    )
  set(tgtName ${P_TARGET}_fbs_ts)
  add_custom_target(${tgtName} ALL DEPENDS ${cmdFile})
  set_property(TARGET ${tgtName} PROPERTY FOLDER ${folder})
endfunction()
