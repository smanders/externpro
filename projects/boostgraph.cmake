# boost graph
set(VER 1.76.0)
set(REPO https://github.com/boostorg/graph)
set(FORK https://github.com/externpro/graph)
set(PRO_BOOSTGRAPH
  NAME boostgraph
  SUPERPRO boost
  SUBDIR . # since the patch is all headers, apply to root of boost, not libs/graph
  WEB "graph" http://boost.org/libs/graph "boost graph website"
  DESC "a generic interface for traversing graphs, using C++ templates"
  REPO "repo" ${REPO} "graph repo on github"
  VER ${VER}
  GIT_ORIGIN ${FORK}
  GIT_UPSTREAM ${REPO}
  GIT_TRACKING_BRANCH develop
  GIT_TAG xp${VER}
  GIT_REF boost-${VER}
  PATCH ${PATCH_DIR}/boost.graph.patch
  PATCH_STRIP 2 # Strip NUM leading components from file names (defaults to 1)
  DIFF ${FORK}/compare/boostorg:
  )
