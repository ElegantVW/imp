Red [Title: "probe-style" Needs: View]
; can a base face be a flat purple button, do word-colors work in VID
; slots, and do font facets (name/color/bold) survive on base, drop-down
; and field? the click flag proves on-click dispatch on a base face.
THEME-TEST: 200.155.224
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
win: layout [
    title "imp - probe-style"
    hit: text 60 "0" font [color: 0.255.0 size: 12]
    bb: base 120x28 THEME-TEST font [name: "DejaVu Sans Mono" color: 26.18.24 size: 11 style: 'bold] "go" on-click [
        hit/text: form (to integer! hit/text) + 1
    ]
    dd: drop-down 100 data ["a" "b"] font [color: 240.228.238]
    ff: field 120 font [name: "DejaVu Sans Mono" color: 240.228.238 size: 12]
]
view/no-wait win
repeat i 5 [do-events/no-wait]
say "A built: " [either win ["SEALED"]["BROKEN"]]
say "   btn-bg: " [(mold bb/color)]
say "   btn-font: " [(mold bb/font/name)]
evt: make event! [type: 'click face: bb]
do-actor bb evt 'click
repeat i 3 [do-events/no-wait]
say "B clicked: " [either ((hit/text) = "1") ["SEALED"]["BROKEN"]]
say "   hits: " [hit/text]
say "C single-write: " ["SEALED - this file is the only product"]
unview/all
write %/dev/shm/imp/probe-style-tmp.txt rejoin led
rename %/dev/shm/imp/probe-style-tmp.txt %/dev/shm/imp/probe-style-witness.txt
