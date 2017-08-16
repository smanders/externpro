# geotranz
# http://packages.debian.org/sid/geotranz
# http://geotranz.sourcearchive.com/
xpProOption(geotranz)
set(GEOTVER 2.4.2)
set(REPO https://github.com/smanders/geotranz)
set(PRO_GEOTRANZ
  NAME geotranz
  WEB "GEOTRANS" http://earth-info.nga.mil/GandG/geotrans/ "GEOTRANS website"
  LICENSE "open" http://earth-info.nga.mil/GandG/geotrans/docs/MSP_GeoTrans_Terms_of_Use.pdf "GEOTRANS Terms of Use (no specific license mentioned)"
  DESC "geographic translator (convert coordinates)"
  REPO "repo" ${REPO} "geotranz repo on github"
  VER ${GEOTVER}
  GIT_ORIGIN git://github.com/smanders/geotranz.git
  GIT_TAG xp${GEOTVER} # what to 'git checkout'
  GIT_REF v${GEOTVER} # create patch from this tag to 'git checkout'
  DLURL http://geotranz.sourcearchive.com/downloads/${GEOTVER}/geotranz_${GEOTVER}.orig.tar.gz
  DLMD5 1d370d5b0daed2a541a9aa14bd3172a8
  PATCH ${PATCH_DIR}/geotranz.patch
  DIFF ${REPO}/compare/
  )
####################
list(APPEND csv README)
list(APPEND md5 48cffaef0651db24c43b8afaee7fbeaf)
list(APPEND csv compd_cs.csv)
list(APPEND md5 8e3cb60e597f9bd36d0639406a4cf40a)
list(APPEND csv ellips_alias.csv)
list(APPEND md5 f93d412cfaef83bf526c8938511d2b41)
list(APPEND csv ellipsoid.csv)
list(APPEND md5 d9b32c58f78c3ed4b1e696987adeaaa5)
list(APPEND csv gdatum_alias.csv)
list(APPEND md5 2bfe9d762e0741e2cc9fbd5753b0d1f7)
list(APPEND csv geod_datum.csv)
list(APPEND md5 459dcb5486257bdf50188e6d959264de)
list(APPEND csv geod_trf.csv)
list(APPEND md5 d941df77cdc93d6585cd710d30f6f5e4)
list(APPEND csv geoparms.csv)
list(APPEND md5 f8c2d94038c51f4de0ccb8342ee7fbb9)
list(APPEND csv horiz_cs.csv)
list(APPEND md5 e0ead4963d4303a64390a178e76799f4)
list(APPEND csv p_meridian.csv)
list(APPEND md5 ba008810fdfbce99094f01b7324bf679)
list(APPEND csv trf_method.csv)
list(APPEND md5 205d5d87f7bd619bad02b6481432ec38)
list(APPEND csv trf_nonpolynomial.csv)
list(APPEND md5 9632881925d1a9d0970249a79bc6df6c)
list(APPEND csv trf_path.csv)
list(APPEND md5 5a5ba3f91cc4b006bcfed7fe87f81cf2)
list(APPEND csv uom_an_alias.csv)
list(APPEND md5 cec548c07383fad7d75856a37b9dd8b7)
list(APPEND csv uom_angle.csv)
list(APPEND md5 bde69d67540b036c05992321170a359c)
list(APPEND csv uom_le_alias.csv)
list(APPEND md5 cd229e95c8014caa459e9dbac4ebb33f)
list(APPEND csv uom_length.csv)
list(APPEND md5 9c7a5b5792acd47a059861dee449e2d8)
list(APPEND csv uom_scale.csv)
list(APPEND md5 b97f0ebfec9099e0292799e9c2b6593f)
list(APPEND csv uom_sc_alias.csv)
list(APPEND md5 73564bdea9c492078daaa25b928582be)
list(APPEND csv vert_cs.csv)
list(APPEND md5 229f41094d6cecd56a38462a64ccdf11)
list(APPEND csv vert_datum.csv)
list(APPEND md5 4e636be19defaf269d3e81bd1d7996a9)
list(APPEND csv vert_offset.csv)
list(APPEND md5 4256444bb7c0bae4f7b94c01b24fddbd)
list(LENGTH csv csvlen)
math(EXPR md5len "${csvlen} - 1")
########################################
function(download_geotranz)
  xpNewDownload(${PRO_GEOTRANZ})
  download_geotiff_tables(ftp://downloads.osgeo.org/pub/geotiff/tables ${DWNLD_DIR}/data)
endfunction()
####################
function(download_geotiff_tables src dst)
  if(NOT EXISTS ${dst})
    execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${dst})
  endif()
  # http://stackoverflow.com/questions/7932205/parallel-iteration-over-lists-in-makefile-or-cmake-file
  foreach(val RANGE ${md5len})
    list(GET csv ${val} csvfile)
    list(GET md5 ${val} md5sum)
    if(${ARGC} EQUAL 2)
      xpDownload(${src}/${csvfile} ${md5sum} ${dst})
    elseif(${ARGC} EQUAL 3)
      if(NOT EXISTS ${src}/${csvfile})
        message(STATUS "will download ${csvfile} from ${ARGV2}...")
        xpDownload(${ARGV2}/${csvfile} ${md5sum} ${dst})
      else()
        xpDownload(file://${src}/${csvfile} ${md5sum} ${dst})
      endif()
    endif()
  endforeach()
endfunction()
########################################
function(build_geotranz)
  if(NOT (XP_DEFAULT OR XP_PRO_GEOTRANZ))
    return()
  endif()
  set(geoVerDir /geotrans_${GEOTVER})
  configure_file(${PRO_DIR}/use/usexp-geotrans-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  xpCmakeBuild(geotranz "" "-DGEOTRANS_VER=${GEOTVER}")
  download_geotiff_tables(${DWNLD_DIR}/data ${STAGE_DIR}/include${geoVerDir}/geotrans/data
                          ftp://downloads.osgeo.org/pub/geotiff/tables)
endfunction()
