Red [Title: "probe-dot"]
; WHY IS EVERY BRAILLE DOT LIT?
;
; The forge emits U+2800|bits. Every cell came out as U+28FF, all eight
; dots, even for samples whose luma is 50. So either the luma test is
; always true, or the bit weight is always 128. Both are arithmetic
; precedence questions, and both have already cost me an hour today.
;
; I have been wrong about how Red parses an expression seven times in
; this project. So: print the intermediate values. Do not reason about
; the parse; measure it.

do %src/core.red
do %src/forge.red

PROBE: %/dev/shm/imp/probe-dot.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

; ── 1. the bit weight table, as the interpreter sees it ──────────────
t: try [mold FORGE-BITS]
mark rejoin ["A1 bits-table: " either error? t ["threw"] [to string! t]]

t: try [mold FORGE-POWERS]
mark rejoin ["A2 powers-table: " either error? t ["threw"] [to string! t]]

; ── 2. the nested lookup, one cell at a time. (dy,dx) -> bit ─────────
; dy is 0..3 and dx is 0..1, and `pick` is 1-based, so +1 on both.
dy: 0
while [dy < 4][
    dx: 0
    while [dx < 2][
        t: try [pick (pick FORGE-BITS (dy + 1)) (dx + 1)]
        mark rejoin ["B" to string! dy to string! dx " bit: " either error? t ["threw"] [mold t]]
        dx: dx + 1
    ]
    dy: dy + 1
]

; ── 3. the weight, exactly as the forge asks for it. if the parse is
;       `pick POWERS (bit) + 1` rather than `pick POWERS (bit + 1)`,
;       this shows it: bit 0 should give 1, and if it gives none! or 2,
;       that is the bug. ──────────────────────────────────────────────
b0: pick (pick FORGE-BITS 1) 1
t: try [mold pick FORGE-POWERS (b0 + 1)]
mark rejoin ["C1 weight-for-bit0(want 1): " either error? t ["threw"] [to string! t]]

t: try [mold pick FORGE-POWERS (pick (pick FORGE-BITS 1) 1) + 1]
mark rejoin ["C2 inline-weight0: " either error? t ["threw"] [to string! t]]

t: try [mold pick FORGE-POWERS (pick (pick FORGE-BITS 4) 2) + 1]
mark rejoin ["C3 inline-weight7(want 128): " either error? t ["threw"] [to string! t]]

; ── 4. THE LUMA TEST. this is the other suspect. take a KNOWN dark
;       sample from the real picture and evaluate the condition the
;       forge uses, character for character. ────────────────────────
img: try [load/as %/dev/shm/imp/probe-src.png 'png]
either error? img [
    mark rejoin ["LOAD-ERROR " mold img]
][
    ; row 9 of 256 is mostly the dark tower body
    m: forge-mean img 256 256 120 220 128 228
    t: try [mold m]
    mark rejoin ["D1 dark-sample: " either error? t ["threw"] [to string! t]]

    t: try [mold forge-luma to integer! pick m 1 to integer! pick m 2 to integer! pick m 3]
    mark rejoin ["D2 its-luma: " either error? t ["threw"] [to string! t]]

    ; and the condition, written exactly as the forge writes it
    t: try [
        either forge-luma to integer! pick m 1 to integer! pick m 2 to integer! pick m 3 >= FORGE-LUMA-MID ["LIT"]["dark"]
    ]
    mark rejoin ["D3 condition: " either error? t ["threw " mold t] [to string! t]]

    ; a bright sample for contrast — the white foam near the top
    m2: forge-mean img 256 256 8 8 24 24
    t: try [mold m2]
    mark rejoin ["D4 bright-sample: " either error? t ["threw"] [to string! t]]

    t: try [mold forge-luma to integer! pick m2 1 to integer! pick m2 2 to integer! pick m2 3]
    mark rejoin ["D5 its-luma: " either error? t ["threw"] [to string! t]]

    t: try [
        either forge-luma to integer! pick m2 1 to integer! pick m2 2 to integer! pick m2 3 >= FORGE-LUMA-MID ["LIT"]["dark"]
    ]
    mark rejoin ["D6 condition: " either error? t ["threw " mold t] [to string! t]]
]

mark "DONE"
