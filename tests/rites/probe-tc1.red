Red [Title: "probe-tc1" Needs: View]
; minimal: load tui, open, set wish text, close, witness.
do %src/tui.red
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
view/no-wait win
repeat i 5 [do-events/no-wait]
wish-face/text: "a lighthouse in a storm"
repeat i 3 [do-events/no-wait]
say "A wish-set: " [either ((wish-face/text) = "a lighthouse in a storm") ["SEALED"]["BROKEN"]]
say "   text: " [wish-face/text]
say "B single-write: " ["SEALED"]
unview/all
write %/dev/shm/imp/probe-tc1-tmp.txt rejoin led
rename %/dev/shm/imp/probe-tc1-tmp.txt %/dev/shm/imp/probe-tc1-witness.txt
