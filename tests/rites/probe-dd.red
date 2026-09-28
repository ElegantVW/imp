Red [Title: "probe-dd" Needs: View]
; is drop-down real in this build? open one, read it back.
sizes: ["128" "192" "256" "384" "512" "768" "1024"]
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
win: layout [
    title "imp - probe-dd"
    dd: drop-down 100 data sizes
]
view/no-wait win
repeat i 5 [do-events/no-wait]
say "A face: " [either dd ["SEALED"]["BROKEN"]]
say "   type: " [(mold dd/type)]
say "B data-len: " [(length? dd/data)]
say "   text: " [(mold dd/text)]
sel: try [dd/selected: 3]
say "C select-err? " [(mold (error? sel))]
repeat i 3 [do-events/no-wait]
say "   text-now: " [(mold dd/text)]
say "D single-write: " ["SEALED - this file is the only product"]
unview/all
write %/dev/shm/imp/probe-dd-tmp.txt rejoin led
rename %/dev/shm/imp/probe-dd-tmp.txt %/dev/shm/imp/probe-dd-witness.txt
