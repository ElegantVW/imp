Red [Title: "probe-paint" Needs: View]
; is rite-view's dark pixel slow paint or never paint? same layout,
; three snapshots: ~0.9s, ~2.7s, ~5.1s. witness reports all three.
do %src/core.red
SNAP1: %/dev/shm/imp/paint-1.png
SNAP2: %/dev/shm/imp/paint-2.png
SNAP3: %/dev/shm/imp/paint-3.png
PIC: %/dev/shm/imp/view-pic.png
SOURCE: %/dev/shm/imp/conjure.png
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
either exists? SOURCE [write PIC read/binary SOURCE][save PIC make image! 64x64 #{3A6EA5}]
win: layout compose/deep [
    title "imp - probe-paint"
    backdrop 255.0.0
    below
    tk: text 60 "0" font [color: 0.255.0 size: 12]
    below
    image 192x192 %/dev/shm/imp/view-pic.png rate 0:0:0.3 on-time [
        k: to integer! tk/text
        tk/text: form k + 1
        if k >= 2 [
            shot: to-image face/parent
            save %/dev/shm/imp/paint-1.png shot
        ]
        if k >= 8 [
            shot: to-image face/parent
            save %/dev/shm/imp/paint-2.png shot
        ]
        if k >= 16 [
            face/rate: none
            shot: to-image face/parent
            save %/dev/shm/imp/paint-3.png shot
            unview/only face/parent
        ]
    ]
]
view win
n: to integer! tk/text
say "ticks: " [n]
foreach s ["1" "2" "3"] [
    f: to file! rejoin [%/dev/shm/imp/paint- s ".png"]
    either exists? f [
        shot: load f
        px: pick shot 1
        say rejoin ["snap" s ": "] [px]
    ][
        say rejoin ["snap" s ": "] ["MISSING"]
    ]
]
say "E single-write: " ["SEALED - this file is the only product"]
write %/dev/shm/imp/probe-paint-tmp.txt rejoin led
rename %/dev/shm/imp/probe-paint-tmp.txt %/dev/shm/imp/probe-paint-witness.txt
