Red [Title: "probe-fn2"]
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-fn2.txt rejoin ledger]

say "OPENED"

; g1: return the block itself
g1: func [/local a][
    a: copy []
    append a "hello"
    a
]
set [r1 e1] try [g1]
say rejoin ["g1 err? " mold error? e1 " type " mold type? :r1]
either type? :r1 = block! [say rejoin ["g1 len " mold (length? r1)]][
    say "g1 not a block"
]

; g2: two elements, rejoined
g2: func [/local a][
    a: copy []
    append a "hello"
    append a "bye"
    rejoin a "^/"
]
set [r2 e2] try [g2]
say rejoin ["g2 err? " mold error? e2 " type " mold type? :r2 " len " mold (length? r2)]

; g3: rejoin a LITERAL block (no variable)
g3: func [/local n][
    n: 0
    rejoin ["one" "two"]
]
set [r3 e3] try [g3]
say rejoin ["g3 err? " mold error? e3 " len " mold (length? r3)]

; g4: rejoin with a 2-arg call to a literal block
g4: func [/local n][
    n: 0
    rejoin reduce ["a" "b"] "^/"
]
set [r4 e4] try [g4]
say rejoin ["g4 err? " mold error? e4 " len " mold (length? r4)]

; g5: the same code at top level, for contrast
top: copy []
append top "hello"
append top "bye"
t5: rejoin top "^/"
say rejoin ["t5 len " mold (length? t5)]

; g6: inside a func, build then rejoin in separate statements
g6: func [/local a j][
    a: copy []
    append a "hello"
    append a "bye"
    j: rejoin a "^/"
    j
]
set [r6 e6] try [g6]
say rejoin ["g6 err? " mold error? e6 " len " mold (length? r6)]

say "DONE"
