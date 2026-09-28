Red [Title: "probe-tc3" Needs: View]
; click + 10s sleep-pump. no funcs, no break, no pic touch.
do %src/tui.red
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
view/no-wait win
repeat i 5 [do-events/no-wait]
btn: none
foreach f win/pane [if (f/type = 'button) [btn: f]]
wish-face/text: "a lighthouse in a storm"
send-event make event! [type: 'click face: btn]
repeat i 20 [
    call/wait/shell "sleep 0.5"
    repeat k 5 [do-events/no-wait]
]
say "A busy: " [busy-face/text]
say "B status: " [status-face/text]
say "C flame: " [flame-face/text]
say "D single-write: " ["SEALED"]
unview/all
write %/dev/shm/imp/probe-tc3-tmp.txt rejoin led
rename %/dev/shm/imp/probe-tc3-tmp.txt %/dev/shm/imp/probe-tc3-witness.txt
