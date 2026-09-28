Red [Title: "probe-sleep"]
; I. Can the demon WAIT? if he cannot, every loop we write is a hung
; serpent. this is the question the whole bridge rests on.
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-sleep.txt rejoin ledger]

say "OPENED"
set [res err] try [sleep 0.05]
say rejoin ["sleep-err " mold err]
say rejoin ["sleep-res " mold res]

; and a second call, to be sure it is not a one-shot
set [res2 err2] try [sleep 0.01]
say rejoin ["sleep2-err " mold err2]
say "DONE"
