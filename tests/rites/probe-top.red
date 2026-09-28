Red [Title: "probe-top"]
do %src/core.red
do %src/frame.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-top.txt rejoin ledger]

say "OPENED"

title: "Imp"
w: 40

label: rejoin [" " MARK " " title " " MARK " "]
say rejoin ["label ok " mold (length? label)]

inner: subtract w 2
say rejoin ["inner " mold inner]

sp: true-span label
say rejoin ["span " mold sp]

fill: subtract inner sp
say rejoin ["fill " mold fill]

either fill < 1 [fill: 1]
say rejoin ["fill-guarded " mold fill]

part1: rejoin [PINK "x" OFF]
say rejoin ["pink-off ok " mold (length? part1)]

part2: rejoin [BOLD ROSE]
say rejoin ["bold-rose ok " mold (length? part2)]

part3: repeat-chars "-" 5
say rejoin ["rc ok " mold (length? part3)]

whole: rejoin [PINK "y" OFF BOLD ROSE label OFF PINK repeat-chars "-" fill "z" OFF]
say rejoin ["WHOLE ok " mold (length? whole)]
say "DONE"
