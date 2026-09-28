Red [Title: "probe-bf2"]
do %src/core.red
do %src/frame.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-bf2.txt rejoin ledger]

; build-frame's body, opened up, with a witness after every append
art: reap "abc" 'unicode 20 2
runes: ["one rune" "two rune"]
w: 60
ah: 2
body: subtract w 4
lines: copy []
say rejoin ["0 lines-type " mold type? :lines " len " mold (length? lines)]

append lines top-border "Imp" w
say rejoin ["1 after-top len " mold (length? lines)]

rows: sever art "^/"
say rejoin ["2 rows " mold (length? rows)]

blank: repeat-chars " " body
while [(length? rows) < ah][append rows blank]
say rejoin ["3 padded rows " mold (length? rows)]

either (length? rows) > ah [rows: copy/part rows ah][
    i: 0
    foreach r rows [
        i: i + 1
        append lines rejoin [PINK "|" OFF " " r " " PINK "|" OFF]
    ]
]
say rejoin ["4 after-art rows len " mold (length? lines) " rows " mold (length? rows)]

append lines divider "Imp's Comment" w
say rejoin ["5 after-divider len " mold (length? lines)]

append lines row "a comment" w ROSE
say rejoin ["6 after-comment len " mold (length? lines)]

append lines divider "Runes" w
say rejoin ["7 after-runes-div len " mold (length? lines)]

foreach r runes [append lines row r w MUTE]
say rejoin ["8 after-runes len " mold (length? lines)]

append lines bottom-border w
say rejoin ["9 after-bottom len " mold (length? lines)]

out: rejoin lines "^/"
say rejoin ["10 out-type " mold type? :out " len " mold (length? out)]
say "DONE"
