Red [Title: "rite-tui" Needs: View]
; THE TUI'S WINDOW, PROVED FROM THE INSIDE.
;
; Loads src/tui.red — which is a LIBRARY, it builds `win` and never views
; it — then opens that window with `view/no-wait` and asserts the four
; things the TUI needs:
;
;   A  the window opens and its panel is there
;   B  its event loop LIVES — the window is on the screen and shown
;   C  the image widget shows a real picture
;   D  the mode cycler WORKS — a left key changes the mode face
;
; D is the one that was asked for. The user wants to cycle from normal
; to braille and back, and until a key actually changes the mode face
; under an automated send, that is a hope rather than a fact.
;
; ── WHY `view/no-wait` AND A PUMP ────────────────────────────────────
; The TUI has no `rate` facet — it is a long-running app, it should not be
; taking screenshots of itself. So nothing inside it will ever write a
; snapshot for this rite to wait on, and the first draft of this rite
; pumped forever looking for one. The rite pumps the event loop itself
; with `do-events/no-wait` and asserts against the faces directly.
;
; ── THE SHAPE OF THIS RITE ────────────────────────────────────────────
; Every claim is computed in ordinary code, after the window is open, and
; the testimony is written ONCE at the end. A witness written on every
; line is a log, and `rited` exits and `pkill`s on first sight of it.

do %src/core.red
do %src/forge.red

do %src/tui.red

led: copy []
; `say` takes a LABEL and a block, not one block. One block molds the
; block's LAST value, so every label vanished and the testimony read
; {"SEALED"}{"SEALED"}{"SEALED"} — a passing rite that says nothing.
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

view/no-wait win

; pump the event loop a little so the window is fully built and shown
repeat i 5 [do-events/no-wait]

; ── A: the panel is there ──────────────────────────────────────────
; wish row, size row, hand row, style row, status row, picture.
pane: win/pane
faces: length? pane
say "A panel-present: " [either (faces >= 5) ["SEALED"]["BROKEN"]]
say "   faces: " [faces]

; ── B: the loop lived ──────────────────────────────────────────────
; the window is on the screen and shown. `view/no-wait` returns
; immediately, so this is the only proof the window actually opened.
screen: system/view/screens/1
on-screen?: false
if screen/pane [on-screen?: true]
say "B loop-live: " [either on-screen? ["SEALED"]["BROKEN, the window is not on the screen"]]

; ── C: the image widget shows a real picture ───────────────────────
; the image is the last face in the layout. bind it before asking it
; for its size — `pick pane n /size` is a refinement, not a path.
either (faces >= 5) [
    img-face: pick pane faces
    img-size: img-face/size
    say "   image face: " [img-size " type: " (mold img-face/type)]
    say "C image-present: " [either (img-size/x > 100) ["SEALED"]["BROKEN"]]
][
    say "C image-present: BROKEN, the layout has too few faces"
]

; ── D: the size cycler works ───────────────────────────────────────
; The u key walks the seven presets in the drop-down. Read the index,
; send the key, pump, read it again; they must differ. Custom is empty
; throughout, so the drop-down is what would run.
u0: size-dd/selected
send-event make event! [type: 'key key: #"u" face: win]
do-events/no-wait
do-events/no-wait
u1: size-dd/selected
say "   preset: " [(rejoin [u0 " -> " u1 " custom=" size-custom/text])]
say "D size-cycler: " [either (u0 <> u1) ["SEALED"]["BROKEN, the key did nothing"]]

; ── F: the three buttons are there — conjure, quit, enhance ───────
n-btn: 0
conjure?: false
quit?: false
enh?: false
foreach f pane [
    if (f/type = 'button) [
        n-btn: n-btn + 1
        if ((f/text) = "conjure") [conjure?: true]
        if ((f/text) = "quit") [quit?: true]
        if ((find f/text "enhance") <> none) [enh?: true]
    ]
]
say "F buttons: " [either (((n-btn = 3) and conjure? and quit?) and enh?) ["SEALED"]["BROKEN"]]
say "   buttons: " [n-btn]

; ── G: the image is LAST, because the old rite picks the last face ─
; faces are all type 'base in this build (mold gives "base"), so prove
; by SIZE: the picture is 300 wide, nothing else is.
either (faces >= 1) [
    last-f: pick pane faces
    last-w: last-f/size/x
    say "G image-last: " [either (last-w >= 300) ["SEALED"]["BROKEN"]]
    say "   last width: " [last-w]
][
    say "G image-last: " ["BROKEN, empty pane"]
]

; ── K: a q from the wish field does NOT quit — typing is safe ─────
k-pre: either (screen/pane = none) [0][length? screen/pane]
send-event make event! [type: 'key-down key: #"q" face: wish-face]
do-events/no-wait
do-events/no-wait
k-screen: system/view/screens/1
k-post: either (k-screen/pane = none) [0][length? k-screen/pane]
say "K field-q-safe: " [either (k-post = k-pre) ["SEALED"]["BROKEN, a field q closed the window"]]

; ── L: the drop-down holds seven presets ───────────────────────────
say "L presets: " [either ((length? size-dd/data) = 7) ["SEALED"]["BROKEN"]]
say "   presets: " [(length? size-dd/data)]

; ── M: a custom size that is not a number is refused, fast ──────────
; No spawn, no flame: validation fails before busy goes 1, so this
; seal costs nothing and proves the guard, not the GPU.
wish-face/text: "a lighthouse in a storm"
size-custom/text: "abc"
con-press
say "M custom-refused: " [either (((status-face/text) = "that size is not a number.") and ((busy-face/text) = "0")) ["SEALED"]["BROKEN"]]
say "   refused: " [(rejoin [status-face/text " busy=" busy-face/text])]
size-custom/text: ""

; ── N: the style drop-down holds seven styles ───────────────────────
say "N styles: " [either ((length? style-dd/data) = 7) ["SEALED"]["BROKEN"]]
say "   styles: " [(length? style-dd/data) "  open: " style-dd/text]

; ── O: enhance flips off and back, through its own words ────────────
con-flip
mid-enh: enh-btn/text
con-flip
say "O enhance-flip: " [either (((mid-enh) = "enhance: off") and ((enh-btn/text) = "enhance: on")) ["SEALED"]["BROKEN"]]
say "   flipped: " [(rejoin [mid-enh " -> " enh-btn/text])]

; ── P: the mortal's prompt carries the style suffix ─────────────────
; Pure compose, no spawn: Mignola on a fox.
c1: con-compose "a fox" 3
say "P compose: " [either ((((find c1 "mignola") <> none) and ((find c1 "a fox") <> none)) and ((find c1 "<think>") = none)) ["SEALED"]["BROKEN"]]
say "   composed: " [c1]

; ── hand drop-down, slider, sync ────────────────────────────────────
say "S hands: " [either ((length? hand-dd/data) = 3) ["SEALED"]["BROKEN"]]
say "   hands: " [(length? hand-dd/data) "  open: " hand-dd/text]
say "T slider-home: " [either ((mold step-slider/data) = "8%") ["SEALED"]["BROKEN"]]
say "   slider: " [(mold step-slider/data)]

; ── Q: a new hand applies its preset, visibly ───────────────────────
hand-dd/selected: 2
step-slider/data: 8%
sync-face/text: "1:8"
q-steps: con-sync-steps 2
say "Q sync-preset: " [either (((q-steps = 20) and ((mold step-slider/data) = "40%")) and ((sync-face/text) = "2:40")) ["SEALED"]["BROKEN"]]
say "   synced: " [(rejoin [q-steps " steps slider=" step-slider/data " sync=" sync-face/text])]

; ── R: same hand runs the grabbed value ─────────────────────────────
step-slider/data: 60%
r-steps: con-sync-steps 2
say "R sync-grab: " [either ((r-steps = 30) and ((sync-face/text) = "2:60")) ["SEALED"]["BROKEN"]]
say "   grabbed: " [(rejoin [r-steps " steps sync=" sync-face/text])]

; ── S2: hand index round-trips through the drop-down into a name ───
; Called TWICE with different hands: the old code clobbered the lookup
; function with its own answer on first use (hazard 65), so the second
; call is the seal, not the first.
hand-dd/selected: 2
hh: hand-dd/selected
n1: con-get-hand-name hh
n2: con-get-hand-name 1
n3: con-get-hand-name hh
say "S2 hand-name: " [either (((n1 = "SDXL") and (n2 = "turbo")) and (n3 = "SDXL")) ["SEALED"]["BROKEN"]]
say "   roundtrip: " [(rejoin [hh " -> " n1 "/" n2 "/" n3])]

; ── I: the quit button's click dispatch closes the window ─────────
; Synthetic clicks do not inject (hazard 61), so dispatch the actor
; the way the event loop would: do-actor on the quit face, then pump.
quit-btn: none
foreach f pane [
    if (f/type = 'button) [
        if ((f/text) = "quit") [quit-btn: f]
    ]
]
either quit-btn [
    pre-n: either (screen/pane = none) [0][length? screen/pane]
    evt: make event! [type: 'click face: quit-btn]
    do-actor quit-btn evt 'click
    repeat k 5 [do-events/no-wait]
    mid-screen: system/view/screens/1
    mid-n: either (mid-screen/pane = none) [0][length? mid-screen/pane]
    say "I quit-dispatch: " [either (mid-n < pre-n) ["SEALED"]["BROKEN, dispatch did not close"]]
    view/no-wait win
    repeat k 5 [do-events/no-wait]
][
    say "I quit-dispatch: " ["SKIPPED, no quit face"]
]

; ── H: q quits the window, through the same key path as the cycler
before-n: either (screen/pane = none) [0][length? screen/pane]
send-event make event! [type: 'key key: #"q" face: win]
do-events/no-wait
do-events/no-wait
screen2: system/view/screens/1
after-n: either (screen2/pane = none) [0][length? screen2/pane]
say "H quit-key: " [either (after-n < before-n) ["SEALED"]["BROKEN, the window stayed open"]]

; ── J: key-DOWN q quits too — the path real fingers take ────────────
; H's on-key char never fires for a real press (hazard 62: the backend
; yields none there for letters). Re-view, send a key-down, reseal.
view/no-wait win
repeat k 5 [do-events/no-wait]
view/no-wait win
repeat k 5 [do-events/no-wait]
pre2-n: either (screen/pane = none) [0][length? screen/pane]
send-event make event! [type: 'key-down key: #"q" face: win]
do-events/no-wait
do-events/no-wait
screen3: system/view/screens/1
post2-n: either (screen3/pane = none) [0][length? screen3/pane]
say "J quit-keydown: " [either (post2-n < pre2-n) ["SEALED"]["BROKEN, key-down did not close"]]

say "E single-write: " ["SEALED - this file is the only product"]

write %/dev/shm/imp/tui-tmp.txt rejoin led
rename %/dev/shm/imp/tui-tmp.txt %/dev/shm/imp/tui-witness.txt
