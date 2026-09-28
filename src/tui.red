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
; It is STAGED IN THE REPO ROOT by the launcher (`cp src/tui.red
; .cast-tui.red`) and run from there. Both halves of that are load-bearing:
;
;   * IT IS A SINGLE FILE. A wrapper that did `do %src/tui.red` and then
;     `view win` loaded cleanly and built a valid face and then showed
;     NOTHING — `view` after a `do` does not open a window. Measured.
;   * IT USES `%src/core.red`, because `do` resolves a relative path
;     against the CWD, and the CWD is the repo root when the launcher
;     stages it. Run from src/ instead, `%src/core.red` means
;     src/src/core.red and the file dies silently.
;   * IT IS LAUNCHED FROM A BASH SCRIPT THAT STAYS ALIVE. Launched inline
;     — even via `bash -c` — the shell exits, red-view dies with it, and
;     no window ever appears. The launcher is a script and polls, so it
;     lives as long as the window does.
;
; ── STATE LIVES IN FACES ─────────────────────────────────────────────
; Assignment inside a VID actor does not reach the enclosing global, so a
; counter written as `n: n + 1` in an on-time block never reaches its
; threshold and the window never closes. A count kept in a face's text
; works. Every piece of state here is a face.

do %src/core.red
do %src/forge.red

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
mode: pick MODES (h // 12)
size: pick SIZES (h // 6)

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
; `on-key` goes FIRST in the layout block. Every working example in
; red-view-src/tests has it there, and at the end of the block it is a
; syntax error that kills the whole file at load.
win: layout compose/deep [
    title "imp"
    backdrop 18.18.24
    on-key [
        switch event/key [
            left [
                mode-face/text: either (mode-face/text = "normal") ["braille"]["normal"]
            ]
            right [
                mode-face/text: either (mode-face/text = "normal") ["braille"]["normal"]
            ]
            up [
                i: index? find SIZES size
                size-face/text: mold pick SIZES either (i = length? SIZES) [1][i + 1]
            ]
            down [
                i: index? find SIZES size
                size-face/text: mold pick SIZES either (i = 1) [length? SIZES][i - 1]
            ]
        ]
    ]
    below
    text 320 "wish" font [color: 140.140.160 size: 9]
    wish-face: field 300
    return
    text 320 "mode" font [color: 140.140.160 size: 9]
    mode-face: text 200 (mold mode) font [color: 210.210.220 size: 12]
    return
    text 320 "size" font [color: 140.140.160 size: 9]
    size-face: text 200 (mold size) font [color: 210.210.220 size: 12]
    return
    button 120 "conjure" [unview/all]
    return
    image 300x300 pic
]

view win
