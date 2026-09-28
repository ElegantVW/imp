Red [Title: "probe-binary"]
; IV. Can the demon write BYTES? the PDF writer is a byte assembler.
; if write/binary is absent, the blood-rite is impossible here.
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-binary.txt rejoin ledger]

say "OPENED"

set [r1 e1] try [write/binary %bytes-probe.bin [#"%" 1 2 255]]
say rejoin ["write-err " mold e1]

set [r2 e2] try [read/binary %bytes-probe.bin]
say rejoin ["read-err " mold e2]
say rejoin ["read-res " mold r2]
say rejoin ["read-len " mold length? r2]

set [r3 e3] try [write %text-probe.txt "plain"]
say rejoin ["text-err " mold e3]
set [r4 e4] try [read %text-probe.txt]
say rejoin ["text-res " mold r4]
say "DONE"
