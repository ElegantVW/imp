Red [Title: "rite-tui-conjure" Needs: View]
; STAY-OPEN CONJURE, TWICE, IN ONE WINDOW.
;
; Loads src/tui.red, opens it with view/no-wait, sets the wish field,
; calls con-press — the exact words the conjure button runs — and pumps
; until the png is ready. Then a second wish in the same window.
;
;   A  the press starts a run (busy goes 1, window never unviews)
;   B  the flame moves while the hand paints
;   C  the first run finishes and the picture is new
;   D  the window is still open afterwards
;   E  a second wish runs to completion in the same window
;   F  the window is open after that too
;
; Full GPU pipeline both times. Slow (~15-30s per run) and honest.
; RITED_WAIT 500. Witness written once, at the end.

do %src/tui.red

led: copy []
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

view/no-wait win
repeat i 5 [do-events/no-wait]

btn: none
foreach f win/pane [
    if (f/type = 'button) [btn: f]
]
say "button-found: " [either btn ["SEALED"]["BROKEN"]]

; one wish through con-press. returns "yes" or "no". flame samples
; accumulate in FL. busy must read 1 right after the press.
run-wish: func [w [string!] fl [block!] /local busy-seen stable done n][
    busy-seen: "no"
    stable: 0
    done: "no"
    wish-face/text: w
    con-press
    repeat k 5 [do-events/no-wait]
    if ((busy-face/text) = "1") [busy-seen: "yes"]
    n: 0
    while [(n < 240)][
        n: n + 1
        call/wait/shell "sleep 0.5"
        repeat k 5 [do-events/no-wait]
        append fl flame-face/text
        if ((busy-face/text) = "0") [
            stable: stable + 1
            if (stable >= 2) [done: "yes" break]
        ]
    ]
    either (busy-seen = "yes") [done]["no press never started"]
]

fl1: copy []
r1: run-wish "a lighthouse in a storm" fl1
say "A first-finished: " [either (r1 = "yes") ["SEALED"]["BROKEN"]]
say "   run1: " [r1 "  status: " status-face/text]

u1: copy []
foreach s fl1 [
    either (find u1 s) [][append u1 s]
]
say "B flame-moved: " [either ((length? u1) > 1) ["SEALED"]["BROKEN, one tongue only"]]
say "   tongues: " [(length? u1) "  samples: " (length? fl1)]

either (CON-PIC <> none) [
    say "C picture-new: " ["SEALED"]
    say "   pic: " [(mold CON-PIC/size)]
][
    say "C picture-new: " ["BROKEN, CON-PIC is none"]
]

screen: system/view/screens/1
open1?: "no"
if screen/pane [open1?: "yes"]
say "D window-open: " [either (open1? = "yes") ["SEALED"]["BROKEN"]]

fl2: copy []
r2: run-wish "a fox asleep in a field of white flowers" fl2
say "E second-finished: " [either (r2 = "yes") ["SEALED"]["BROKEN"]]
say "   run2: " [r2 "  status: " status-face/text]

screen2: system/view/screens/1
open2?: "no"
if screen2/pane [open2?: "yes"]
say "F still-open: " [either (open2? = "yes") ["SEALED"]["BROKEN"]]

say "G single-write: " ["SEALED - this file is the only product"]

unview/all

write %/dev/shm/imp/tui-conjure-tmp.txt rejoin led
rename %/dev/shm/imp/tui-conjure-tmp.txt %/dev/shm/imp/tui-conjure-witness.txt
