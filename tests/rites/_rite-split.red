Red [Title: "rite-split"]
; RITE SPLIT: sever a string into lines without the forbidden parse.
; the serpent severs by FIND, not by PARSE — PARSE is excommunicated here

sever: func [s [string!] delim [string!] /local out i j n nd][
    out: copy []
    i: 1
    n: length? s
    nd: length? delim
    forever [
        j: find at s i delim
        either j = none [
            append out copy at s i
            break
        ][
            append out copy/part at s i (subtract (index? j) i)
            i: add (index? j) nd
            if i > n [append out "" break]
        ]
    ]
    out
]

; three proofs
a: sever "one^/two^/three" "^/"
b: sever "solo" "^/"
c: sever "" "^/"
out: copy ""
foreach row reduce [
    "three" mold a
    "len-a" mold length? a
    "solo" mold b
    "len-b" mold length? b
    "empty" mold c
    "len-c" mold length? c
    "join-check" mold rejoin a "|"
][append out rejoin [row "^/"]]
write %rite-split.txt out
