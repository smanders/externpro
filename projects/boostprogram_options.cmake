# boost program_options
set(VER 1.76.0)
set(REPO https://github.com/boostorg/program_options)
set(FORK https://github.com/smanders/program_options)
set(PRO_BOOSTPROGRAM_OPTIONS
  NAME boostprogram_options
  SUPERPRO boost
  SUBDIR ./libs/program_options/
  WEB "program_options" http://boost.org/libs/program_options "boost program_options website"
  DESC "library allows program developers to obtain program options, that is (name, value) pairs from the user, via conventional methods such as command line and config file"
  REPO "repo" ${REPO} "program_options repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.program_options.patch
  PATCH_STRIP 1 # Strip NUM leading components from file names (defaults to 1)
  DIFF ${FORK}/compare/boostorg:
  )
