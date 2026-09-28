Red [Title: "probe-tc2" Needs: View]
; click the real button, pump briefly, read busy. no waiting for paint.
do %src/tui.red
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
view/no-wait win
repeat i 5 [do-events/no-wait]
btn: none
foreach f win/pane [if (f/type = 'button) [btn: f]]
say "A button-found: " [either btn ["SEALED"]["BROKEN"]]
wish-face/text: "a lighthouse in a storm"
send-event make event! [type: 'click face: btn]
repeat i 10 [do-events/no-wait]
say "B busy: " [busy-face/text]
say "C status: " [status-face/text]
say "D single-write: " ["SEALED"]
unview/all
write %/dev/shm/imp/probe-tc2-tmp.txt rejoin led
rename %/dev/shm/imp/probe-tc2-tmp.txt %/dev/shm/imp/probe-tc2-witness.txt
