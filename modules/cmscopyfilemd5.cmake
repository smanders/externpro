# @param[in] src : source
# @param[in] dst : destination
# @param[in] md5 : MD5 hash (or checksum)
# @param[in] wg : workgroup
get_filename_component(fn ${src} NAME)
string(REGEX MATCH "^//" uncpath ${src})
if((NOT WIN32) AND (NOT ${uncpath} STREQUAL ""))
  if(NOT EXISTS ${dst})
    execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${dst})
  endif()
  if(NOT EXISTS ${dst}/${fn})
    # smbget - wget-like utility for download files over SMB
    set(smbget_cmd smbget --dots --keep-permissions --quiet
      --username=$ENV{USER} --workgroup=${wg} #--password=
      )
    execute_process(COMMAND ${smbget_cmd} smb:${src} WORKING_DIRECTORY ${dst})
    #execute_process(COMMAND ${CMAKE_COMMAND} -E chdir ${dst} ${smbget_cmd})
  endif()
else()
  file(COPY ${src} DESTINATION ${dst} USE_SOURCE_PERMISSIONS)
endif()
file(MD5 ${dst}/${fn} md5sum)
#execute_process(COMMAND ${CMAKE_COMMAND} -E md5sum ${dst}/${fn})
if(NOT ${md5sum} STREQUAL ${md5})
  message(FATAL_ERROR
    "* MD5 mismatch: ${fn}\n"
    "  MD5 expected: ${md5}\n"
    "  MD5 computed: ${md5sum}"
    )
endif()
