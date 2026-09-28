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
MODES: ["normal" "braille"]
SIZES: [256 384 512 768]
; `//` IS MODULO IN RED, NOT DIVISION. `h // 12` gives 0-11, and `pick
; MODES 8` is `none` — pick is 1-based and MODES has 2 elements, so any
; index above 2 is none. Measured: mode-text was "none" at hour 8. Use
; `divide` (which returns decimal, so wrap it) and add 1 for the 1-based
; pick. Two modes over 24 hours is a 12-hour split; four sizes is a
; 6-hour split.
mode: pick MODES (to integer! (divide h 12) + 1)
size: pick SIZES (to integer! (divide h 6) + 1)

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
mode-text: form mode
size-text: form size
ready-text: "type a wish and press conjure."
idle-flame: " "
; ── the press. NAMED, so a rite can call the exact path a finger takes.
; The button below is one word long. Synthetic clicks do not reach a
; button's on-click in this build (measured: busy stayed "0" through
; send-event type 'click), so the rite calls this and the human clicks
; it — same words either way. Ends on `out`, never on a conditional.
con-press: func [/local out][
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
                busy-face/text: "1"
                flame-face/text: pick CON-FLAMES 1
                status-face/text: form (con-begin wish-face/text size-face/text)
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
    out
]
win: layout [
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
            #"l" [
                mode-face/text: either (mode-face/text = "normal") ["braille"]["normal"]
            ]
            #"r" [
                mode-face/text: either (mode-face/text = "normal") ["braille"]["normal"]
            ]
            #"u" [
                i: index? find SIZES size
                size-face/text: form pick SIZES either (i = length? SIZES) [1][i + 1]
            ]
            #"d" [
                i: index? find SIZES size
                size-face/text: form pick SIZES either (i = 1) [length? SIZES][i - 1]
            ]
            _left [
                mode-face/text: either (mode-face/text = "normal") ["braille"]["normal"]
            ]
            _right [
                mode-face/text: either (mode-face/text = "normal") ["braille"]["normal"]
            ]
            _up [
                i: index? find SIZES size
                size-face/text: form pick SIZES either (i = length? SIZES) [1][i + 1]
            ]
            _down [
                i: index? find SIZES size
                size-face/text: form pick SIZES either (i = 1) [length? SIZES][i - 1]
            ]
        ]
    ]
    backdrop 18.18.24
    below
    text 320 "wish" font [color: 140.140.160 size: 9]
    wish-face: field 300
    return
    text 320 "mode" font [color: 140.140.160 size: 9]
    mode-face: text 200 mode-text font [color: 210.210.220 size: 12]
    return
    text 320 "size" font [color: 140.140.160 size: 9]
    size-face: text 200 size-text font [color: 210.210.220 size: 12]
    return
    button 120 "conjure" [con-press]
    return
    status-face: text 320 ready-text font [color: 140.140.160 size: 9]
    return
    busy-face: text 10 "0" font [color: 18.18.24 size: 1]
    return
    flame-face: text 320 idle-flame font [color: 220.90.40 size: 14] rate 0:0:0.06 on-time [
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
]
