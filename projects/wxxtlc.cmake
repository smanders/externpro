# wxxtlc
# repo http://wxcode.svn.sourceforge.net/viewvc/wxcode/trunk/wxCode/components/treelistctrl/
# dwnl http://sourceforge.net/projects/wxcode/files/Components/treelistctrl/
set(VER 1208)
set(REPO https://github.com/externpro/wxTLC)
set(PRO_WXXTLC
  NAME wxxtlc
  SUPERPRO wxx
  SUBDIR wxTLC
  WEB "wxTLC" http://wxcode.sourceforge.net/components/treelistctrl/ "wxTLC (treelistctrl) on sourceforge"
  DESC "a multi column tree control"
  REPO "repo" ${REPO} "wxTLC repo on github"
  VER ${VER}
  GIT_ORIGIN ${REPO}
  GIT_TAG xp${VER}
  GIT_REF v${VER}
  DLURL http://downloads.sourceforge.net/project/wxcode/Components/treelistctrl/treelistctrl_${VER}.zip
  DLMD5 49252811c837c74b6b627cc36468c2fc
  PATCH ${PATCH_DIR}/wxx.tlc.patch
  DIFF ${REPO}/compare/
  )
