# boost graph
set(VER 1.76.0)
set(REPO github.com/boostorg/graph)
set(FORK github.com/smanders/graph)
set(PRO_BOOSTGRAPH
  NAME boostgraph
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/graph
  WEB "graph" http://boost.org/libs/graph "boost graph website"
  LICENSE "open" http://www.boost.org/users/license.html "Boost Software License"
  DESC "a generic interface for traversing graphs, using C++ templates"
  REPO "repo" https://${REPO} "graph repo on github"
  VER ${VER}
  GIT_ORIGIN https://${FORK}.git
  GIT_UPSTREAM https://${REPO}.git
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.graph.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF https://${FORK}/compare/boostorg:
  )
