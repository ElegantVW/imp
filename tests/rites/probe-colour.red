Red [Title: "probe-colour"]
do %src/frame.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-colour.txt rejoin ledger]

say "OPENED"

say rejoin ["MARK type " mold type? :MARK]
say rejoin ["esc type " mold type? :esc]
say rejoin ["PINK type " mold type? :PINK]
say rejoin ["OFF type " mold type? :OFF]
say rejoin ["BOLD type " mold type? :BOLD]

either type? :PINK = string! [say rejoin ["PINK len " mold (length? PINK)]][
    say "PINK not a string"
]

; build a colour here instead, and see if the char is the poison
set [built e1] try [rejoin [to char! 27 "[38;5;175m"]]
say rejoin ["rejoin-char err? " mold error? e1]
either type? :built = string! [say rejoin ["built len " mold (length? built)]][
    say "built not a string"
]

set [built2 e2] try [rejoin [to string! to char! 27 "[38;5;175m"]]
say rejoin ["rejoin-str err? " mold error? e2]
either type? :built2 = string! [say rejoin ["built2 len " mold (length? built2)]][
    say "built2 not a string"
]

say "DONE"
