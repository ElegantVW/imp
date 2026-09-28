Red [Title: "probe-reap2"]
; reap the model's actual output, step by step, with a witness at each.
do %src/core.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-reap2.txt rejoin ledger]

say "OPENED"

a: read %imp-art-debug.txt
say rejoin ["len " mold (length? a)]

l: sever a "^/"
say rejoin ["lines " mold (length? l)]

; one line at a time, so a failure names its victim
i: 1
n: length? l
while [i <= n][
    ln: pick l i
    f: flay-line ln 'unicode 40
    say rejoin ["line " mold i " ok len " mold (length? f)]
    i: i + 1
]

g: reap a 'unicode 40 12
say rejoin ["reap len " mold (length? g)]
say "DONE"
