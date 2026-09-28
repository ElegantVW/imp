Red [Title: "harvest"]
; HARVEST: the ledger is a BLOCK in memory. file-literal append is a
; lie in this build — it swallows. the ledger is written whole, once,
; and if a seal dies the missing seal is its own confession.
do %src/core.red

ledger: copy ["OPENED"]

; write OVERWRITES and append-to-file is a no-op: so flush the whole
; ledger after every seal. whatever is on disk is what survived.
say: func [s [string!]][append ledger s  write %harvest.txt rejoin ledger]

v: read %tests/vectors/input_1.txt
say rejoin ["read-1 " mold (length? v)]

a: read %tests/vectors/input_3.txt
say rejoin ["read-3 " mold (length? a)]

b: read %tests/vectors/input_4.txt
say rejoin ["read-4 " mold (length? b)]

c: read %tests/vectors/input_5.txt
say rejoin ["read-5 " mold (length? c)]

say rejoin ["beast " mold 6 * 111]

g: reap v 'ascii 10 3
gl: sever g "^/"
say rejoin ["grid-3 " mold (length? gl) "^/"]

g1: pick gl 1
say rejoin ["grid-span-1 " mold (true-span g1) "^/"]

s3: reap a 'unicode 24 4
say rejoin ["ansi-len " mold (length? s3) "^/"]

s4: reap b 'truecolor 30 3
say rejoin ["truecolor-len " mold (length? s4) "^/"]

s5: reap c 'unicode 10 2
say rejoin ["wide-len " mold (length? s5) "^/"]

st: rejoin [to char! 27 "[0mABC" to char! 27 "[0m"]
say rejoin ["bare " mold (bare st) "^/"]

write %harvest.txt rejoin ledger "^/"
