# boost program_options
set(VER 1.67.0)
string(REGEX REPLACE "([0-9]+)\\.([0-9]+)(\\.[0-9]+)?" "\\1_\\2" VER2_ ${VER}) # 1_67
set(REPO github.com/boostorg/program_options)
set(FORK github.com/smanders/program_options)
set(PRO_BOOSTPROGRAM_OPTIONSHPP${VER2_}
  NAME boostprogram_optionshpp${VER2_}
  SUPERPRO boost
  SUBDIR . # this part of the patch is headers, apply to root of boost, not libs/program_options
  WEB "program_options" http://boost.org/libs/program_options "boost program_options website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "library allows program developers to obtain program options, that is (name, value) pairs from the user, via conventional methods such as command line and config file"
  REPO "repo" https://${REPO} "program_options repo on github"
  VER ${VER}
  GIT_ORIGIN git://${FORK}.git
  GIT_UPSTREAM git://${REPO}.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xphpp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.program_optionshpp.${VER2_}.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/boostorg:
  )
