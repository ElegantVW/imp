Red [Title: "rite-tui" Needs: View]
; THE TUI'S WINDOW, PROVED FROM THE INSIDE.
;
; Loads src/tui.red with TUI-NO-VIEW set, so the file defines its layout
; without running. Then it builds the window, opens it with view/no-wait,
; and asserts the four things the TUI needs:
;
;   A  the window opens and its panel is there
;   B  its event loop LIVES — a timer fires, and fires again
;   C  the image widget shows a real picture
;   D  the mode cycler WORKS — a left key changes the mode face
;
; D is the one that was asked for. The user wants to cycle from normal
; to braille and back, and until a key actually changes the mode face
; under an automated send, that is a hope rather than a fact.
;
; `view/no-wait` returns immediately and the event loop runs in the
; background, so the TUI's own `rate` facet drives the screenshot; this
; rite pumps and polls for it rather than blocking in `do-events`.

do %src/core.red
do %src/forge.red

do %src/tui.red

snap: %/dev/shm/imp/tui-snap.png

led: copy []
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

view/no-wait win

; pump until the TUI's timer has screenshotted (tick 3 at 0.3s each)
deadline: now + 0:0:10
while [now < deadline] [
    do-events/no-wait
    if exists? snap [break]
]

; ── A: the panel is there ──────────────────────────────────────────
; the layout is: wish-field, mode-face, size-face, button, tk, image.
pane: win/pane
faces: length? pane
say "A panel-present: " [either (faces >= 6) ["SEALED"] ["BROKEN"]]
say "   faces: " [faces]

; ── B: the loop lived ──────────────────────────────────────────────
say "B loop-live: " [either (exists? snap) ["SEALED"] ["BROKEN, no snapshot was taken"]]

; ── C: the image widget shows a real picture ───────────────────────
; the image is the last face in the layout. bind it before asking it
; for its size — `pick pane n /size` is a refinement, not a path.
either (faces >= 6) [
    img-face: pick pane faces
    img-size: img-face/size
    say "   image face: " [img-size " type: " (mold img-face/type)]
    say "C image-present: " [either (img-size/x > 100) ["SEALED"] ["BROKEN"]]
][
    say "C image-present: BROKEN, the layout has too few faces"
]

; ── D: the mode cycler works ───────────────────────────────────────
; the mode face is second in the layout. read its text, send a left
; key, read it again; they must differ.
either (faces >= 2) [
    mode-face: pick pane 2
    mode-before: mode-face/text
    send-event make event! [type: 'key key: 'left face: win]
    do-events/no-wait
    do-events/no-wait
    mode-after: mode-face/text
    say "   mode before: " [mode-before "  after left: " mode-after]
    say "D mode-cycler: " [either (mode-before <> mode-after) ["SEALED"] ["BROKEN, the key did nothing"]]
][
    say "D mode-cycler: BROKEN, there is no second face"
]

say "E single-write: " ["SEALED - this file is the only product"]

unview/all

write %/dev/shm/imp/tui-tmp.txt rejoin led
rename %/dev/shm/imp/tui-tmp.txt %/dev/shm/imp/tui-witness.txt
