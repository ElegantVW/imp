Red [Title: "gates"]
do %src/core.red
ledger: copy []
say: func [s [string!]][append ledger s  write %gates.txt rejoin ledger]

esc: to char! 27
seq: rejoin [esc "[38;5;175m"]

; the exact expression flay-line uses
k1: all [well-formed? seq beast-allows? seq 'unicode]
say rejoin ["all-both " mold k1]

k2: well-formed? seq
say rejoin ["wf " mold k2]

k3: beast-allows? seq 'unicode
say rejoin ["ba " mold k3]

; and with a bound word instead of a literal
st: 'unicode
k4: all [well-formed? seq beast-allows? seq st]
say rejoin ["all-word " mold k4]

; the copy/part that builds seq from a line
line: rejoin [seq "X"]
j: m-end line 1
say rejoin ["j " mold j]
built: copy/part at line 1 (add (subtract j 1) 1)
say rejoin ["built-len " mold (length? built)]
say rejoin ["built-is-seq " mold (built = seq)]

say "DONE"
