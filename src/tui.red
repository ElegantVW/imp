Red [Title: "imp" Needs: View]
; the imp's window. pure Red, no C, no python.
;
;   imp              opens this window
;   imp "a wish"     one conjuring in the terminal, exactly as before
;
; Red cannot read a terminal — `stdin` and `termios` appear nowhere in the
; runtime source — so the window is the only door there is.
;
; ── HOW THIS FILE IS RUN ────────────────────────────────────────────
; It is a LIBRARY. It builds `win` and nothing else; it never views it.
;
; The launcher stages a three-line wrapper in the repo root —
; `.cast-tui.red` — that does `do %src/tui.red` and then `view win`. Both
; halves of that are load-bearing:
;
;   * THE WRAPPER NEEDS A `Red [...]` HEADER. Without it the script dies on
;     its first line, silently, and no window ever opens. Measured.
;   * THE WRAPPER IS STAGED IN THE ROOT, because `do` resolves a relative
;     path against the CWD, and `%src/core.red` only means something when
;     the CWD is the root. Run from src/ it means src/src/core.red.
;   * IT IS LAUNCHED FROM A SCRIPT THAT STAYS ALIVE. Launched inline — even
;     via `bash -c` — the shell exits and red-view dies with it. The
;     launcher is a script and polls, so it lives as long as the window.
;
; This file cannot `view` itself: a file that views itself is a file no rite
; can load, and the rite is the only way to test the window without a human
; at the keyboard. See tests/rites/rite-tui.red.
;
; ── STATE LIVES IN FACES ─────────────────────────────────────────────
; Assignment inside a VID actor does not reach the enclosing global, so a
; counter written as `n: n + 1` in an on-time block never reaches its
; threshold and the window never closes. A count kept in a face's text
; works. Every piece of state here is a face.
;
; ── CONJURE STAYS IN THE WINDOW ──────────────────────────────────────
; The button used to `unview/all`. That closed the only door. It now
; runs `con-press`, and a rate facet on the flame face polls `con-tick`
; until the png is ready. The window does not close. A second wish is
; the same button again.
;
; `call/wait` would freeze the event loop for the whole of sd-cli.
; The flame is not decoration: it is how a day-to-day user knows the
; freeze is a painting, not a hang. Hazard 23, sealed by rite-flame.

do %conjure-lib.red

; ── the evil opening posture ────────────────────────────────────────
; The window does not remember anything, and it does not open the same way
; twice. Mode and resolution are derived from the hour by a rule that looks
; arbitrary, is fully deterministic, and is never explained in-product.
; Covenant §1 sets the precedent — the gallery sorts by the hour, "because
; an hour is a number and numbers are not reasons".
;
; THE HOUR, and it takes three attempts to get. Measured:
;   now                  -> 28-Sep-2026/2:48:26+01:00
;   now/hour             -> raises   (no such refinement)
;   now/time/hour        -> raises   (time! has no /hour either)
;   to integer! now/time -> 10271   (seconds since midnight)
; so the hour is the seconds divided by 3600.
h: forge-div (to integer! now/time) 3600
; Seven presets, as STRINGS: the drop-down's data is text, and the u/d
; keys move an index, never arithmetic on the values. `//` is modulo
; (hazard 58) — and here that is finally the tool, not the trap: the
; opening preset is `(h // 7) + 1`, deterministic, 1-based, always in
; range, never explained in-product. Covenant §1.
SIZES: ["128" "192" "256" "384" "512" "768" "1024"]

; ── the picture ─────────────────────────────────────────────────────
; The last conjured png, or a placeholder of our own making. `compose/deep`
; splices the file! literal into the layout, which is how the image widget
; gets a path decided at runtime — `pre-load` does `load value`, so a
; string would be parsed as code and a file! is what it wants.
pic: %/dev/shm/imp/conjure.png
either exists? pic [
    ; the last conjuring is still on disk. use it.
][
    save %/dev/shm/imp/tui-placeholder.png make image! 64x64 #{3A6EA5}
    pic: %/dev/shm/imp/tui-placeholder.png
]

; ── the window ──────────────────────────────────────────────────────
; A PLAIN `layout`, NOT `layout compose/deep`. The two together are a
; syntax error — `vid-invalid-syntax` — and it is silent, so the window
; never opens. Measured: `compose/deep` alone works, `on-key` alone works,
; and a plain `layout` with both works. Only the combination fails.
; `compose/deep` was there to splice the `pic` global into the image, but
; a plain `layout` splices a global file! just as well.
;
; THE CONTROLS SHARE ROWS (`across`), five of them, so the window is
; short: wish + both buttons, size + custom, hand + steps, style +
; enhance, status + flame. The picture keeps its 300x300. `busy-face`
; and `sync-face` are 10px faces, text the colour of the backdrop —
; state has to live in faces, and it does not have to be seen.
;
; THE WINDOW IS RESIZABLE (`layout/flags [resize]`). Without the flag
; the backend marks it fixed and i3 will only ever move it. Resize
; shows backdrop, not more picture — the image stays 300x300.
;
; THE FACE TEXTS ARE BOUND OUTSIDE THE LAYOUT, WITH `form`, NOT `mold`.
; Two VID traps here:
;
;   * VID takes a literal string as a widget's text, not an expression:
;     `text 200 (mold mode)` is `vid-invalid-syntax`. Bind the value to a
;     word first, then use the word.
;   * `mold` of a string gives a CURLY-BRACE string — `mold "normal"` is
;     `{"normal"}`, not `"normal"` — and that is what lands in the face.
;     Measured: mode-face/text was `{"normal"}`, so a rite searching for
;     `"normal"` never matched and reported the cycler BROKEN. `form` gives
;     the plain string: `form "normal"` is `normal`.
ready-text: "type a wish and press conjure."
idle-flame: " "
; ── the press. NAMED, so a rite can call the exact path a finger takes.
; The button below is one word long. Synthetic clicks do not reach a
; button's on-click in this build (measured: busy stayed "0" through
; send-event type 'click), so the rite calls this and the human clicks
; it — same words either way. Ends on `out`, never on a conditional.
con-press: func [/local out sz-text n enh hi][
    out: "already painting."
    either (busy-face/text = "1") [
        status-face/text: "already painting."
        out: "already painting."
    ][
        either (wish-face/text = none) [
            status-face/text: "speak a wish first."
            out: "speak a wish first."
        ][
            either ((length? wish-face/text) = 0) [
                status-face/text: "speak a wish first."
                out: "speak a wish first."
            ][
                ; custom wins when it says anything; else the drop-down;
                ; else the standing default. What runs is always visible.
                sz-text: "512"
                either (size-dd/text = none) [
                ][
                    sz-text: form size-dd/text
                ]
                either (size-custom/text = none) [
                ][
                    either ((length? size-custom/text) = 0) [
                    ][
                        sz-text: size-custom/text
                    ]
                ]
                n: try [to integer! sz-text]
                either error? n [
                    status-face/text: "that size is not a number."
                    out: "that size is not a number."
                ][
                    either (n <= 0) [
                        status-face/text: "that size is not a number."
                        out: "that size is not a number."
                    ][
                        hi: hand-dd/selected
                        either (hi = none) [hi: 1][
                            either ((hi < 1) or (hi > length? CON-HANDS)) [hi: 1][]
                        ]
                        con-sync-steps hi
                        busy-face/text: "1"
                        flame-face/text: pick CON-FLAMES 1
                        enh: either ((enh-btn/text) = "enhance: off") ["off"]["on"]
                        status-face/text: form (con-begin wish-face/text sz-text style-dd/selected enh hi)
                        out: status-face/text
                        either ((con-kind status-face/text) = "fail") [
                            busy-face/text: "0"
                            flame-face/text: idle-flame
                            out: status-face/text
                        ][
                        ]
                    ]
                ]
            ]
        ]
    ]
    out
]
; ── the way out. NAMED, like the press, so a rite can walk it.
con-quit: func [/local out][
    unview/all
    out: "closed"
    out
]
; ── the enhance switch. One face: the button text IS the state.
con-flip: func [/local out][
    out: "enhance: on"
    either ((enh-btn/text) = "enhance: off") [
        enh-btn/text: "enhance: on"
        out: "enhance: on"
    ][
        enh-btn/text: "enhance: off"
        out: "enhance: off"
    ]
    out
]
; ── steps sync. The slider shows percent (8% means 4 steps); the sync
; face remembers "hand:pct" from the last press. New hand → the hand's
; own preset moves the slider, visibly. Same hand → the grabbed value
; runs. No widget actors: all of it here, where a rite can call it.
con-sync-steps: func [hi [integer!] /local pct parts sh sh-try steps out][
    out: 4
    pct: to integer! (step-slider/data * 100)
    parts: sever sync-face/text ":"
    sh: 0
    sh-try: try [to integer! pick parts 1]
    either error? sh-try [sh: 0][sh: sh-try]
    either (hi <> sh) [
        steps: con-hand-steps hi
        step-slider/data: to percent! ((steps * 2) / 100)
        sync-face/text: rejoin [(form hi) ":" (form (to integer! (step-slider/data * 100)))]
        CON-STEPS: steps
    ][
        CON-STEPS: either (pct < 2) [1][to integer! (pct / 2)]
        sync-face/text: rejoin [(form hi) ":" (form pct)]
    ]
    CON-CFG: con-hand-cfg hi
    out: CON-STEPS
    out
]
win: layout/flags [
    title "imp"
    on-key [
        ; TWO KEY SHAPES, because `event/key` is a char for a synthetic
        ; event and a word for a real one. A synthetic event reads its key
        ; from the low 16 bits of `flags` as a char (event.reds line 63),
        ; so `key: #"l"` arrives as `#"l"`. A real arrow key is translated
        ; by the GTK backend into a word — `_left`, `_right`, `_up`, `_down`
        ; (gtk3/events.reds, get-event-key). A switch on `left` matches
        ; neither, so the cycler did nothing. Measured: event/key was
        ; `#"^@"` for `key: 'left`, `#"l"` for `key: #"l"`, and the actor
        ; never fired.
        switch event/key [
            #"u" [
                i: size-dd/selected
                if (i = none) [i: 1]
                size-dd/selected: either (i = length? SIZES) [1][i + 1]
                size-custom/text: ""
            ]
            #"d" [
                i: size-dd/selected
                if (i = none) [i: 1]
                size-dd/selected: either (i = 1) [length? SIZES][i - 1]
                size-custom/text: ""
            ]
            _up [
                i: size-dd/selected
                if (i = none) [i: 1]
                size-dd/selected: either (i = length? SIZES) [1][i + 1]
                size-custom/text: ""
            ]
            _down [
                i: size-dd/selected
                if (i = none) [i: 1]
                size-dd/selected: either (i = 1) [length? SIZES][i - 1]
                size-custom/text: ""
            ]
            #"q" [
                con-quit
            ]
            #"Q" [
                con-quit
            ]
        ]
    ]
    on-key-down [
        ; REAL letters never reach on-key: on a key PRESS the GTK
        ; backend yields none for anything but specials (hazard 62).
        ; The chars arrive here instead, on key-down. Synthetic
        ; key-downs arrive as chars too, so the rite walks this path.
        ;
        ; THE FIELD IS EXEMPT. Key-downs bubble from the focused face
        ; to the window, so without this a q typed inside a wish would
        ; close the only door (measured live). same? tells faces apart.
        switch event/key [
            #"q" [
                either (same? event/face wish-face) [
                ][
                    con-quit
                ]
            ]
            #"Q" [
                either (same? event/face wish-face) [
                ][
                    con-quit
                ]
            ]
        ]
    ]
    backdrop 18.18.24
    across
    text 40 "wish" font [color: 140.140.160 size: 9]
    wish-face: field 200
    button 120 "conjure" [con-press]
    button 60 "quit" [con-quit]
    return
    text 40 "size" font [color: 140.140.160 size: 9]
    size-dd: drop-down 100 data SIZES
    size-custom: field 80
    busy-face: text 10 "0" font [color: 18.18.24 size: 1]
    return
    text 40 "hand" font [color: 140.140.160 size: 9]
    hand-dd: drop-down 100 data CON-HAND-NAMES
    text 40 "steps" font [color: 140.140.160 size: 9]
    step-slider: slider 120 data 8%
    sync-face: text 10 "1:8" font [color: 18.18.24 size: 1]
    return
    text 40 "style" font [color: 140.140.160 size: 9]
    style-dd: drop-down 150 data CON-STYLE-NAMES
    enh-btn: button 120 "enhance: on" [con-flip]
    return
    status-face: text 300 ready-text font [color: 140.140.160 size: 9]
    flame-face: text 110 idle-flame font [color: 220.90.40 size: 14] rate 0:0:0.06 on-time [
        either (busy-face/text = "1") [
            flame-face/text: con-next-flame flame-face/text
            status-face/text: form con-tick
            either ((con-kind status-face/text) = "ok") [
                busy-face/text: "0"
                pic-face/image: CON-PIC
                status-face/text: "ready. wish again."
                flame-face/text: idle-flame
            ][
                either ((con-kind status-face/text) = "fail") [
                    busy-face/text: "0"
                    flame-face/text: idle-flame
                ][
                ]
            ]
        ][
        ]
    ]
    return
    pic-face: image 300x300 pic
] [resize]
; ── the opening preset. Ordinary code, after the layout: the faces
; exist by now. Deterministic from the hour, unexplained in-product.
size-dd/selected: to integer! ((h // 7) + 1)
; Photography opens. Style is a choice, not a posture.
style-dd/selected: 1
; Turbo opens: the standing hand, and the slider agrees with it.
hand-dd/selected: 1
