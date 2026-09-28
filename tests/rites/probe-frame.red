Red [Title: "probe-frame"]
do %src/core.red
do %src/frame.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-frame.txt rejoin ledger]

say "OPENED"

set [a e1] try [repeat-chars "x" 5]
say rejoin ["repeat-chars err? " mold error? e1]
say rejoin ["  val-type " mold type? :a]
either type? :a = string! [say rejoin ["  val " mold a]][
    say "  val (not a string)"
]

set [b e2] try [pad-to "hi" 8]
say rejoin ["pad-to err? " mold error? e2]
either type? :b = string! [say rejoin ["  val " mold b]][
    say "  val (not a string)"
]

set [c e3] try [top-border "Imp" 40]
say rejoin ["top-border err? " mold error? e3]
either type? :c = string! [say rejoin ["  len " mold (length? c)]][
    say "  (not a string)"
]

set [d e4] try [divider "Runes" 40]
say rejoin ["divider err? " mold error? e4]
either type? :d = string! [say rejoin ["  len " mold (length? d)]][
    say "  (not a string)"
]

set [f e5] try [row "hello" 40 PINK]
say rejoin ["row err? " mold error? e5]
either type? :f = string! [say rejoin ["  len " mold (length? f)]][
    say "  (not a string)"
]

set [g e6] try [bottom-border 40]
say rejoin ["bottom err? " mold error? e6]

say "DONE"
