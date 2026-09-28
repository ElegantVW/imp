Red [Title: "probe-open"]
; V. Can the demon OPEN a named pipe and BLOCK on it?
; this is now the load-bearing question: `sleep` does not exist, so
; without a blocking read the bridge must poll, and polling without
; sleep is a hung serpent wearing a hairpiece.
;
; the driver feeds the pipe before we arrive, so a blocking read here
; proves the pipe, not our patience.
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-open.txt rejoin ledger]

say "OPENED"

set [ex e1] try [exists? %keys-probe.fifo]
say rejoin ["fifo-exists " mold ex]

set [p e2] try [open %keys-probe.fifo]
say rejoin ["open-err " mold e2]
say rejoin ["open-res " mold p]

; if we are holding a port, read from it — this is the block
set [dat e3] try [read %keys-probe.fifo]
say rejoin ["read-err " mold e3]
say rejoin ["read-res " mold dat]

say "DONE"
