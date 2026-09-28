Red [Title: "rite-forge-one"]
; THE FORGE, PROVEN ON A REAL PICTURE.
;
; A lighthouse in a storm, painted in 6.16 seconds by a diffusion model
; on a graphics card that had been switched off for months, decoded by
; a native Red codec, and turned into glyphs by src/forge.red. No C. No
; Python. If this rite witnesses a 12-line frame, the hand works.

do %src/core.red
do %src/forge.red

PROBE: %/dev/shm/imp/forge-witness.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

; the picture, straight from the GPU's work
img: try [load/as %/dev/shm/imp/probe-src.png 'png]
either error? img [
    mark rejoin ["LOAD-ERROR " mold img]
    quit
][
    t: try [mold img/size]
    mark rejoin ["A1 size: " either error? t ["threw"] [to string! t]]

    ; we asked sd-cli for 256x256, so we KNOW the dimensions. the forge
    ; takes them as arguments rather than guessing, and A1 is the
    ; cross-check that the two agree.
    ;
    ; WHY 256 AND NOT 512. The forge area-averages in Red, one `pick` per
    ; source pixel, and every `pick` on an image! allocates a fresh
    ; dot-tuple. At 512 a braille forge needs ~157k of them and blew a
    ; 560 s budget. At 256 it needs ~38k, which fits — and the smaller
    ; image is more graphic anyway: less painterly, harder edges, which
    ; is what a glyph grid can actually show. 3.61 s to paint.
    w: 256
    h: 256

    ; ── 1. does the mean sampler work? one sample, top-left. ────────
    t: try [
        m: forge-mean img w h 0 0 8 8
        mold m
    ]
    mark rejoin ["A2 mean-0-0-8-8: " either error? t ["threw " mold t] [to string! t]]

    ; ── 2. the luma function, which must agree with itself ─────────
    t: try [mold forge-luma 255 255 255]
    mark rejoin ["A3 luma-white: " either error? t ["threw"] [to string! t]]

    t: try [mold forge-luma 0 0 0]
    mark rejoin ["A4 luma-black: " either error? t ["threw"] [to string! t]]

    ; ── 3. THE FORGE. half-blocks first: 40x24, cheaper to verify. ─
    t: try [
        art: forge-block img w h
        "len=" mold length? art
    ]
    mark rejoin ["B1 block-len: " either error? t ["threw " mold t] [to string! t]]

    t: try [
        lanes: sever art "^/"
        "lines=" mold length? lanes
    ]
    mark rejoin ["B2 block-lines: " either error? t ["threw " mold t] [to string! t]]

    t: try [
        lanes: sever art "^/"
        mold true-span first lanes
    ]
    mark rejoin ["B3 block-line1-span(want 40): " either error? t ["threw " mold t] [to string! t]]

    ; keep the art for the frame, and for a human to look at
    t: try [write %/dev/shm/imp/imp-art.txt art  "wrote " mold length? art]
    mark rejoin ["B4 wrote-art: " either error? t ["threw " mold t] [to string! t]]

    ; ── 4. braille, the high-fidelity one: 80x48 samples ───────────
    t: try [
        art2: forge-braille img w h 236 228 214 24 28 36
        "len=" mold length? art2
    ]
    mark rejoin ["C1 braille-len: " either error? t ["threw " mold t] [to string! t]]

    t: try [
        lanes2: sever art2 "^/"
        "lines=" mold length? lanes2
    ]
    mark rejoin ["C2 braille-lines: " either error? t ["threw " mold t] [to string! t]]

    t: try [
        lanes2: sever art2 "^/"
        mold true-span first lanes2
    ]
    mark rejoin ["C3 braille-line1-span(want 40): " either error? t ["threw " mold t] [to string! t]]

    t: try [write %/dev/shm/imp/imp-art-braille.txt art2  "wrote " mold length? art2]
    mark rejoin ["C4 wrote-braille: " either error? t ["threw " mold t] [to string! t]]

    ; ── 5. and the sealed core must still accept it ────────────────
    ; the forge produces 12 lines of 40 columns; reap guarantees it
    ; regardless. run it, because "looks right" is not sealed.
    t: try [
        g: reap art 'unicode 40 12
        gl: sever g "^/"
        "lines=" mold length? gl
    ]
    mark rejoin ["D1 reap-lines: " either error? t ["threw " mold t] [to string! t]]

    ; THE THIRD INVERTED ARM IN THIS REPO, and the second one that also
    ; could only see its LAST iteration:
    ;     foreach ln gl [if (true-span ln) = 40 [ok: false] [ok: true]]
    ; The arms are backwards — a line of exactly 40 sets ok to FALSE —
    ; and `ok` is clobbered on every pass, so the value printed is a
    ; statement about line 12 and about nothing else. It printed "false",
    ; which is what a healthy grid prints, and I read it as a failure
    ; while the real failure was in the witness.
    ;
    ; A check that only remembers its last iteration is not a check. It
    ; accumulates every offender by name instead, so a break is legible.
    t: try [
        g: reap art 'unicode 40 12
        gl: sever g "^/"
        bad: copy []
        k: 1
        while [k <= (length? gl)][
            ln: pick gl k
            if (true-span ln) <> 40 [append/only bad rejoin [k ":" true-span ln " "]]
            k: k + 1
        ]
        either (length? bad) = 0 [
            rejoin ["all " mold length? gl " spans are 40 — SEALED"]
        ][
            rejoin ["BROKEN at " mold bad]
        ]
    ]
    mark rejoin ["D2 all-spans-40: " either error? t ["threw " mold t] [to string! t]]
]

mark "DONE"
