Red [Title: "probe-rejoin"]
do %src/core.red
do %src/frame.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-rejoin.txt rejoin ledger]

say "OPENED"

set [p1 e1] try [rejoin [PINK "x" OFF]]
say rejoin ["A err? " mold error? e1]
either error? e1 [say rejoin ["A err " mold e1]][
    either type? :p1 = string! [say rejoin ["A ok len " mold (length? p1)]][
        say "A (not a string)"
    ]
]

set [p2 e2] try [rejoin [PINK "x"]]
say rejoin ["B err? " mold error? e2]
either error? e2 [say rejoin ["B err " mold e2]][
    say rejoin ["B ok len " mold (length? p2)]
]

set [p3 e3] try [rejoin [BOLD ROSE]]
say rejoin ["C err? " mold error? e3]
either error? e3 [say rejoin ["C err " mold e3]][
    say rejoin ["C ok len " mold (length? p3)]
]

set [p4 e4] try [rejoin [PINK "y" OFF BOLD ROSE "z" OFF]]
say rejoin ["D err? " mold error? e4]
either error? e4 [say rejoin ["D err " mold e4]][
    say rejoin ["D ok len " mold (length? p4)]
]

say "DONE"
