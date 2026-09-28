Red [Title: "probe-missing"]
; II. Can the demon READ A FILE THAT DOES NOT EXIST, and live?
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-missing.txt rejoin ledger]

say "OPENED"

set [r1 e1] try [read %dev-null-probe.txt]
say rejoin ["missing-err " mold e1]
say rejoin ["missing-res " mold r1]

; the file appears AFTER the first failure — polling must recover
write %dev-null-probe.txt "it appeared"
set [r2 e2] try [read %dev-null-probe.txt]
say rejoin ["after-err " mold e2]
say rejoin ["after-res " mold r2]
say "DONE"
