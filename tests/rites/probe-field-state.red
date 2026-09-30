Red [Title: "probe-field-state" Needs: View]
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
win: layout [
    title "imp - probe-field-state"
    ff: field 150 "hello"
    tt: text 300 "short" font [color: 0.255.0 size: 10]
]
view/no-wait win
repeat i 5 [do-events/no-wait]
r1: try [ff/enabled?: no]
say "A disable-err? " [(mold (error? r1))]
either error? r1 [][
    say "   state: " [(mold ff/enabled?)]
    r2: try [ff/enabled?: yes]
    say "   reenab: " [(mold ff/enabled?)]
]
tt/text: "THE HAND IS PAINTING ...................."
repeat i 3 [do-events/no-wait]
say "B long-text: " [either ((length? tt/text) > 20) ["SEALED"]["BROKEN"]]
say "C single-write: " ["SEALED - this file is the only product"]
unview/all
write %/dev/shm/imp/probe-field-state-tmp.txt rejoin led
rename %/dev/shm/imp/probe-field-state-tmp.txt %/dev/shm/imp/probe-field-state-witness.txt
