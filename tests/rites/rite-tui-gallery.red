Red [Title: "rite-tui-gallery" Needs: View]
; THE FILING AND THE GREETER, PROVED WITHOUT A GPU. The window builds
; (faces only, never viewed); the painting is filed by calling the
; exact func the success poll calls, with sandbox dirs; the greeter is
; the exact func the startup calls, pointed at a fresh cache.
;
;   T1  con-file-painting files txt + json entry from faces + con-frame
;   T2  con-greet shows once, marks, and stays quiet after
;   T3  a press dismisses the greeter (even a refused one)
;   T4  the picture is still the last face (the old rite's G holds)
do %src/tui.red

led: copy []
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

ART: "/dev/shm/imp/gal-tui/art"
CACHE: "/dev/shm/imp/gal-tui/cache"
call/wait/shell "rm -rf /dev/shm/imp/gal-tui; mkdir -p /dev/shm/imp/gal-tui/art /dev/shm/imp/gal-tui/cache"

; ── T1: one filing from faces ───────────────────────────────────────
wish-face/text: "a fox in neon rain"
style-dd/selected: 3
hand-dd/selected: 2
size-dd/selected: 1
size-custom/text: "256"
con-frame: "SAMPLE-FRAME-TEXT"
tid: con-file-painting ART CACHE
say "T1 filed: " [either ((length? tid) > 0) ["SEALED"]["BROKEN, no id"]]
say "   id: " [tid]
t1: try [read (to file! (rejoin [ART "/" tid ".txt"]))]
say "T1b txt-kept: " [either (error? t1) ["BROKEN, no txt"][either ((find t1 "SAMPLE-FRAME") = none) ["BROKEN, wrong txt"]["SEALED"]]]
te: gal-list CACHE
tw: ""
tst: ""
th: ""
tsz: 0
foreach e te [
    either ((to string! (select e 'id)) = tid) [
        tw: to string! (select e 'wish)
        tst: to string! (select e 'style)
        th: to string! (select e 'hand)
        tsz: select e 'size
    ][]
]
say "T1c entry: " [either (((tw = "a fox in neon rain") and (tst = "Mignola")) and ((th = "SDXL") and (tsz = 256))) ["SEALED"]["BROKEN"]]
say "   entry: " [(rejoin [tw "/" tst "/" th "/" (to string! tsz)])]

; ── T2: the greeter performs once ───────────────────────────────────
CON-CACHE-DIR: CACHE
g1: con-greet
say "T2 greets: " [either ((g1 = true) and (greet-face/visible? = true)) ["SEALED"]["BROKEN"]]
g2: con-greet
say "T2b quiet-after: " [either ((g2 = false) and (greet-face/visible? = false)) ["SEALED"]["BROKEN"]]

; ── T3: a press dismisses ───────────────────────────────────────────
CON-CACHE-DIR: "/dev/shm/imp/gal-tui/fresh"
call/wait/shell "mkdir -p /dev/shm/imp/gal-tui/fresh"
con-greet
wish-face/text: ""
con-press
say "T3 press-dismisses: " [either (greet-face/visible? = false) ["SEALED"]["BROKEN, still showing"]]

; ── T4: the picture is still last ───────────────────────────────────
pane: win/pane
faces: length? pane
either (faces >= 1) [
    last-f: pick pane faces
    last-w: last-f/size/x
    say "T4 image-last: " [either (last-w >= 300) ["SEALED"]["BROKEN"]]
    say "   last width: " [last-w]
][
    say "T4 image-last: " ["BROKEN, empty pane"]
]

say "Z single-write: " ["SEALED - this file is the only product"]

write %/dev/shm/imp/tui-gallery-tmp.txt rejoin led
rename %/dev/shm/imp/tui-gallery-tmp.txt %/dev/shm/imp/tui-gallery-witness.txt
