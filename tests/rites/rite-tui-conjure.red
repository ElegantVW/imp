Red [Title: "rite-tui-conjure" Needs: View]
; STAY-OPEN CONJURE, TWICE, IN ONE WINDOW.
;
; Loads src/tui.red, opens it with view/no-wait, sets the wish field,
; calls con-press — the exact words the conjure button runs — and pumps
; until the png is ready. Then a second wish in the same window.
;
;   A  the press starts a run (busy goes 1, window never unviews)
;   B  the flame moves while the hand paints
;   C  the first run finishes and the picture is new (enhance ON)
;   D  the window is still open afterwards
;   E  a second wish runs to completion in the same window (enhance OFF)
;   E2 the off-path prompt is mortal words + style suffix, no mouth
;   H2 the frame names the SDXL hand and its 20 steps
;   F  the window is open after that too
;
; Full GPU pipeline both times. Slow (minutes per run under load) and
; honest. RITED_WAIT 1000. Witness written once, at the end.
;
; ── the rite owns its env. The library reads imp-env.txt once, at
; load, and the launcher's copy is history-dependent (old format has
; no sdxl line at all). Write the full modern contract here, with the
; real hand files, so hand resolution is hermetic, not archaeological.
write %/dev/shm/imp/imp-env.txt rejoin [
    "sd=/home/evenweaker/.local/lib/sd/sd-cli" "^/"
    "sd-lib=/home/evenweaker/.local/lib/sd" "^/"
    "model=/home/evenweaker/.local/share/pixie/models/sd_turbo-f16.gguf" "^/"
    "sdxl=/home/evenweaker/.local/share/pixie/models/sdxl-base-1.0-Q8_0.gguf" "^/"
    "pony=/home/evenweaker/.local/share/pixie/models/pony-v6-Q8_0.gguf" "^/"
    "w=512" "^/"
    "h=512" "^/"
    "steps=4" "^/"
    "cfg=1" "^/"
    "llm=imp" "^/"
    "llm-url=http://127.0.0.1:8082/v1/chat/completions" "^/"
]

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
; accumulate in FL. busy must read 1 right after the press. ENH is
; "on"/"off" for the enhance button, SI the style preset index, HI
; the hand: 1 turbo, 2 SDXL.
run-wish: func [w [string!] fl [block!] enh [string!] si [integer!] hi [integer!] /local busy-seen stable done n][
    busy-seen: "no"
    stable: 0
    done: "no"
    wish-face/text: w
    enh-btn/text: either (enh = "off") ["enhance: off"]["enhance: on"]
    style-dd/selected: si
    hand-dd/selected: hi
    con-press
    repeat k 5 [do-events/no-wait]
    if ((busy-face/text) = "1") [busy-seen: "yes"]
    n: 0
    while [(n < 800)][
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
r1: run-wish "a lighthouse in a storm" fl1 "on" 1 1
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
r2: run-wish "a fox asleep in a field of white flowers" fl2 "off" 3 2
say "E second-finished: " [either (r2 = "yes") ["SEALED"]["BROKEN"]]
say "   run2: " [r2 "  status: " status-face/text]

; what con-begin actually recorded, before any file is read.
say "H0 globals: " [either ((CON-HAND-NAME = "SDXL") and (CON-STYLE-NAME = "Mignola") and (CON-HAND = 2) and (CON-STYLE = 3) and (CON-ENH = "off")) ["SEALED"]["BROKEN"]]
say "   globals: " [(rejoin [CON-HAND-NAME "/" CON-STYLE-NAME " " CON-HAND "/" CON-STYLE " " CON-ENH])]

; the off-path prompt is the mortal's words plus the Mignola suffix —
; no mouth anywhere in it. read the file the hand actually ran.
pr2: try [read %/dev/shm/imp/conjure-prompt.txt]
either error? pr2 [
    say "E2 prompt-styled: BROKEN, no prompt file"
][
    say "E2 prompt-styled: " [either (((find pr2 "mignola") <> none) and ((find pr2 "a fox asleep") <> none)) ["SEALED"]["BROKEN"]]
    say "   prompt: " [pr2]
]

; the frame names the hand that painted and the steps it took.
fr: try [read %/dev/shm/imp/frame]
either error? fr [
    say "H2 frame-hand: BROKEN, no frame"
][
    say "H2 frame-hand: " [either (((find fr "SDXL") <> none) and ((find fr "20sp") <> none)) ["SEALED"]["BROKEN"]]
]

screen2: system/view/screens/1
open2?: "no"
if screen2/pane [open2?: "yes"]
say "F still-open: " [either (open2? = "yes") ["SEALED"]["BROKEN"]]

say "G single-write: " ["SEALED - this file is the only product"]

unview/all

write %/dev/shm/imp/tui-conjure-tmp.txt rejoin led
rename %/dev/shm/imp/tui-conjure-tmp.txt %/dev/shm/imp/tui-conjure-witness.txt
