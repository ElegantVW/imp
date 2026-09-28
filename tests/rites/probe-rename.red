Red [Title: "probe-rename"]
; III. Can the demon RENAME? the frame relay is worthless without an
; atomic swap — a half-written frame must never reach the bridge.
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-rename.txt rejoin ledger]

say "OPENED"

write %frame-probe.tmp "a partial frame, unfinished"
say "staged"

set [res err] try [rename %frame-probe.tmp %frame-probe.txt]
say rejoin ["rename-err " mold err]
say rejoin ["rename-res " mold res]

set [back e2] try [read %frame-probe.txt]
say rejoin ["final-read " mold back]
say "DONE"
