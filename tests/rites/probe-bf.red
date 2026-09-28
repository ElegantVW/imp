Red [Title: "probe-bf"]
do %src/core.red
do %src/frame.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-bf.txt rejoin ledger]

say "OPENED"

art: reap "abc" 'unicode 20 2
RUNES: ["one rune" "two rune"]

; the pieces
set [t1 e1] try [top-border "Imp" 60]
say rejoin ["top type " mold type? :t1]
say rejoin ["top len " mold (length? t1)]

set [t2 e2] try [divider "Runes" 60]
say rejoin ["div type " mold type? :t2]
say rejoin ["div len " mold (length? t2)]

set [t3 e3] try [row "hello" 60 PINK]
say rejoin ["row type " mold type? :t3]
say rejoin ["row len " mold (length? t3)]
either error? e3 [say rejoin ["row err " mold e3]][
    say "row ok"
]

set [t4 e4] try [bottom-border 60]
say rejoin ["bot type " mold type? :t4]
say rejoin ["bot len " mold (length? t4)]

set [t5 e5] try [build-frame art "a comment" RUNES "> wish" "status" 60 2]
say rejoin ["bf type " mold type? :t5]
either type? :t5 = string! [say rejoin ["bf len " mold (length? t5)]][
    say rejoin ["bf (not a string) len " mold (length? t5)]
]
either error? e5 [say rejoin ["bf err " mold e5]][
    say "bf ok"
]
say "DONE"
