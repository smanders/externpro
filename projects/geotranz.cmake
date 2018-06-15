# geotranz
# http://packages.debian.org/sid/geotranz
# http://geotranz.sourcearchive.com/
xpProOption(geotranz)
set(VER 2.4.2)
set(REPO https://github.com/smanders/geotranz)
set(DLCSV https://download.osgeo.org/geotiff/tables)
set(DLDIR data)
set(PRO_GEOTRANZ
  NAME geotranz
  WEB "GEOTRANS" http://earth-info.nga.mil/GandG/geotrans/ "GEOTRANS website"
  LICENSE "open" http://earth-info.nga.mil/GandG/geotrans/docs/MSP_GeoTrans_Terms_of_Use.pdf "GEOTRANS Terms of Use (no specific license mentioned)"
  DESC "geographic translator (convert coordinates)"
  REPO "repo" ${REPO} "geotranz repo on github"
  VER ${VER}
  GIT_ORIGIN git://github.com/smanders/geotranz.git
  GIT_TAG xp${VER} # what to 'git checkout'
  GIT_REF v${VER} # create patch from this tag to 'git checkout'
  PATCH ${PATCH_DIR}/geotranz.patch
  DIFF ${REPO}/compare/
  DLURL https://github.com/smanders/externpro/releases/download/18.04.1/geotranz_${VER}.orig.tar.gz
  DLMD5 1d370d5b0daed2a541a9aa14bd3172a8
  DLMD5_01 48cffaef0651db24c43b8afaee7fbeaf DLDIR_01 ${DLDIR} DLURL_01 ${DLCSV}/README
  DLMD5_02 8e3cb60e597f9bd36d0639406a4cf40a DLDIR_02 ${DLDIR} DLURL_02 ${DLCSV}/compd_cs.csv
  DLMD5_03 f93d412cfaef83bf526c8938511d2b41 DLDIR_03 ${DLDIR} DLURL_03 ${DLCSV}/ellips_alias.csv
  DLMD5_04 d9b32c58f78c3ed4b1e696987adeaaa5 DLDIR_04 ${DLDIR} DLURL_04 ${DLCSV}/ellipsoid.csv
  DLMD5_05 2bfe9d762e0741e2cc9fbd5753b0d1f7 DLDIR_05 ${DLDIR} DLURL_05 ${DLCSV}/gdatum_alias.csv
  DLMD5_06 459dcb5486257bdf50188e6d959264de DLDIR_06 ${DLDIR} DLURL_06 ${DLCSV}/geod_datum.csv
  DLMD5_07 d941df77cdc93d6585cd710d30f6f5e4 DLDIR_07 ${DLDIR} DLURL_07 ${DLCSV}/geod_trf.csv
  DLMD5_08 f8c2d94038c51f4de0ccb8342ee7fbb9 DLDIR_08 ${DLDIR} DLURL_08 ${DLCSV}/geoparms.csv
  DLMD5_09 e0ead4963d4303a64390a178e76799f4 DLDIR_09 ${DLDIR} DLURL_09 ${DLCSV}/horiz_cs.csv
  DLMD5_10 ba008810fdfbce99094f01b7324bf679 DLDIR_10 ${DLDIR} DLURL_10 ${DLCSV}/p_meridian.csv
  DLMD5_11 205d5d87f7bd619bad02b6481432ec38 DLDIR_11 ${DLDIR} DLURL_11 ${DLCSV}/trf_method.csv
  DLMD5_12 9632881925d1a9d0970249a79bc6df6c DLDIR_12 ${DLDIR} DLURL_12 ${DLCSV}/trf_nonpolynomial.csv
  DLMD5_13 5a5ba3f91cc4b006bcfed7fe87f81cf2 DLDIR_13 ${DLDIR} DLURL_13 ${DLCSV}/trf_path.csv
  DLMD5_14 cec548c07383fad7d75856a37b9dd8b7 DLDIR_14 ${DLDIR} DLURL_14 ${DLCSV}/uom_an_alias.csv
  DLMD5_15 bde69d67540b036c05992321170a359c DLDIR_15 ${DLDIR} DLURL_15 ${DLCSV}/uom_angle.csv
  DLMD5_16 cd229e95c8014caa459e9dbac4ebb33f DLDIR_16 ${DLDIR} DLURL_16 ${DLCSV}/uom_le_alias.csv
  DLMD5_17 9c7a5b5792acd47a059861dee449e2d8 DLDIR_17 ${DLDIR} DLURL_17 ${DLCSV}/uom_length.csv
  DLMD5_18 b97f0ebfec9099e0292799e9c2b6593f DLDIR_18 ${DLDIR} DLURL_18 ${DLCSV}/uom_scale.csv
  DLMD5_19 73564bdea9c492078daaa25b928582be DLDIR_19 ${DLDIR} DLURL_19 ${DLCSV}/uom_sc_alias.csv
  DLMD5_20 229f41094d6cecd56a38462a64ccdf11 DLDIR_20 ${DLDIR} DLURL_20 ${DLCSV}/vert_cs.csv
  DLMD5_21 4e636be19defaf269d3e81bd1d7996a9 DLDIR_21 ${DLDIR} DLURL_21 ${DLCSV}/vert_datum.csv
  DLMD5_22 4256444bb7c0bae4f7b94c01b24fddbd DLDIR_22 ${DLDIR} DLURL_22 ${DLCSV}/vert_offset.csv
  DLADD _01 _02 _03 _04 _05 _06 _07 _08 _09 _10 _11 _12 _13 _14 _15 _16 _17 _18 _19 _20 _21 _22
  )
########################################
function(build_geotranz)
  if(NOT (XP_DEFAULT OR XP_PRO_GEOTRANZ))
    return()
  endif()
  xpGetArgValue(${PRO_GEOTRANZ} ARG VER VALUE VER)
  set(verDir /geotrans_${VER})
  configure_file(${PRO_DIR}/use/usexp-geotrans-config.cmake ${STAGE_DIR}/share/cmake/
    @ONLY NEWLINE_STYLE LF
    )
  set(XP_CONFIGURE -DGEOTRANS_VER=${VER} -DCSV_DIR=${DWNLD_DIR}/data)
  xpCmakeBuild(geotranz "" "${XP_CONFIGURE}")
endfunction()
