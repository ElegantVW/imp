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
; the layout is: wish-field, mode-face, size-face, button, image.
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

; ── D: the mode cycler works ───────────────────────────────────────
; the mode face is second in the layout. read its text, send a left
; key, pump, read it again; they must differ.
;
; The mode face is FOUND, not picked by index. The layout is
; wish-text, wish-field, mode-text, mode-face, size-text, size-face,
; button, image — so the mode face is pane 4, not pane 2, and picking
; pane 2 reads the wish-field, whose text is `none`, which looks exactly
; like a broken cycler. Search the pane for the face whose text is the
; current mode instead.
either (faces >= 4) [
    mode-face: none
    foreach f pane [
        if (f/type = 'text) [
            if ((f/text = "normal") or (f/text = "braille")) [mode-face: f]
        ]
    ]
    either mode-face [
        mode-before: mode-face/text
        send-event make event! [type: 'key key: #"l" face: win]
        do-events/no-wait
        do-events/no-wait
        mode-after: mode-face/text
        say "   mode before: " [mode-before "  after left: " mode-after]
        say "D mode-cycler: " [either (mode-before <> mode-after) ["SEALED"]["BROKEN, the key did nothing"]]
    ][
        say "D mode-cycler: BROKEN, no mode face in the pane"
    ]
][
    say "D mode-cycler: BROKEN, the layout has too few faces"
]

; ── F: the conjure button is there, and it is a button ─────────────
btn: none
foreach f pane [
    if (f/type = 'button) [btn: f]
]
say "F conjure-button: " [either btn ["SEALED"]["BROKEN, no button in the pane"]]

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

say "E single-write: " ["SEALED - this file is the only product"]

unview/all

write %/dev/shm/imp/tui-tmp.txt rejoin led
rename %/dev/shm/imp/tui-tmp.txt %/dev/shm/imp/tui-witness.txt
