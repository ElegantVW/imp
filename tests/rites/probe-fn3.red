Red [Title: "probe-fn3"]
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-fn3.txt rejoin ledger]

say "OPENED"

; what does `copy []` actually make, at top level?
top-empty: copy []
say rejoin ["top-empty type " mold type? :top-empty]
top-empty2: []
say rejoin ["literal-[] type " mold type? :top-empty2]

; h1: single /local
h1: func [/local a][
    a: copy []
    type? :a
]
set [r1 e1] try [h1]
say rejoin ["h1 type " mold type? :r1 " err? " mold error? e1]

; h2: two /locals
h2: func [/local a b][
    a: copy []
    b: 0
    type? :a
]
set [r2 e2] try [h2]
say rejoin ["h2 type " mold type? :r2 " err? " mold error? e2]

; h3: NO /local — a is global
h3: func [
    gacc: copy []
    type? :gacc
]
set [r3 e3] try [h3]
say rejoin ["h3 type " mold type? :r3 " err? " mold error? e3]

; h4: append then type, with single /local
h4: func [/local a][
    a: copy []
    append a "x"
    type? :a
]
set [r4 e4] try [h4]
say rejoin ["h4 type " mold type? :r4 " err? " mold error? e4]
say rejoin ["h4 len " mold (length? r4)]

; h5: the accumulator as a STRING, joined by hand
h5: func [/local s][
    s: copy ""
    append s "one"
    append s "^/"
    append s "two"
    s
]
set [r5 e5] try [h5]
say rejoin ["h5 type " mold type? :r5 " len " mold (length? r5)]
either type? :r5 = string! [say rejoin ["h5 val " mold r5]][
    say "h5 not a string"
]

; h6: string accumulator, many lines, the shape build-frame needs
h6: func [n [integer!] /local s k][
    s: copy ""
    k: 0
    while [k < n][
        append s "line"
        append s "^/"
        k: k + 1
    ]
    s
]
set [r6 e6] try [h6 4]
say rejoin ["h6 len " mold (length? r6)]

say "DONE"
