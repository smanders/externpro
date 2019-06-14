# nasm
xpProOption(nasm)
set(VER 2.14.02)
set(URL https://www.nasm.us/)
set(PRO_NASM
  NAME nasm
  WEB "nasm" ${URL} "nasm website"
  LICENSE "BSD" ${URL} "Simplified (2-clause) BSD license"
  DESC "The Netwide Assembler - an 80x86 and x86-64 assembler"
  GRAPH GRAPH_SHAPE box
  VER ${VER}
  DLURL ${URL}/pub/nasm/releasebuilds/${VER}/win64/nasm-${VER}-win64.zip
  DLMD5 bce3b7e205bab546ead85db761df89db
  )
