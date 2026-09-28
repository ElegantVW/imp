Red [Title: "probe-sever2"]
do %src/core.red
do %src/frame.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-sever2.txt rejoin ledger]

say "OPENED"

marks: "Enter conjure - e edit - a animate - r refine^/s save - g gallery - / history - Tab style - c clear - q quit"
say rejoin ["marks-len " mold (length? marks)]

ml: sever marks "^/"
say rejoin ["ml-type " mold type? :ml]
say rejoin ["ml-count " mold (length? ml)]

say rejoin ["e1-type " mold type? pick ml 1]
say rejoin ["e1-len " mold (length? pick ml 1)]
say rejoin ["e1-val " mold pick ml 1]

say rejoin ["e2-type " mold type? pick ml 2]
say rejoin ["e2-len " mold (length? pick ml 2)]
say rejoin ["e2-val " mold pick ml 2]

; and the simple case for contrast
ml2: sever "aa^/bb" "^/"
say rejoin ["ml2-count " mold (length? ml2)]
say rejoin ["ml2-e1 " mold pick ml2 1]
say rejoin ["ml2-e2 " mold pick ml2 2]

say "DONE"
