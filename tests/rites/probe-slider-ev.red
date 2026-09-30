Red [Title: "probe-slider-ev" Needs: View]
; does a slider fire on-change (live drag), on-click, or nothing at all?
; the count text records every firing; the witness tells which actors exist.
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
win: layout [
    title "imp - probe-slider-ev"
    tk: text 60 "0" font [color: 0.255.0 size: 12]
    sl: slider 150 data 8% on-change [
        tk/text: form (to integer! tk/text) + 1
    ]
]
view/no-wait win
repeat i 5 [do-events/no-wait]
say "A face: " [either sl ["SEALED"]["BROKEN"]]
say "   actors: " [(mold sl/actors)]
sl/data: 40%
repeat i 5 [do-events/no-wait]
sl/data: 60%
repeat i 5 [do-events/no-wait]
say "B ticks-after-sets: " [tk/text]
say "C single-write: " ["SEALED - this file is the only product"]
unview/all
write %/dev/shm/imp/probe-slider-ev-tmp.txt rejoin led
rename %/dev/shm/imp/probe-slider-ev-tmp.txt %/dev/shm/imp/probe-slider-ev-witness.txt
