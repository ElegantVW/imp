Red [Title: "forge"]
; FORGE — the imp's hand. pixels in, glyphs out. pure red.
;
; The first thing this project wanted that Red could not do was an image
; decoder. I was about to write DEFLATE in Red when `load/as %f 'png`
; turned out to return a native image! with an RGB pixel per position:
; `pick img n` -> `r.g.b.a`, `img/size` -> `512x512`. Measure the
; language's inventory before planning around its gaps.
;
;     sd-cli (GPU)   ->  a png on disk
;     load/as 'png   ->  image!, pick n -> r.g.b.a
;     this file      ->  braille or half-blocks, truecolour
;     reap (sealed)  ->  exactly 12 lines of exactly 40 columns
;
; WHY HALF-BLOCKS AND BRAILLE. 40x12 cells is a brutally small grid; a
; 512x512 image squeezed into it throws away 97% of itself and arrives
; as mud. Two escapes, both using glyphs the terminal already has:
;
;   half-block  U+2580  one cell carries TWO stacked pixels, fg top and
;                       bg bottom                      ->  40 x 24
;   braille     U+2800  one cell carries a 2x4 dot matrix ->  80 x 48
;
; ARITHMETIC LAW, learned the hard way and worth its own line: in Red
; BOTH `/` and `divide` return a decimal when given integers. There is
; no operator that quietly yields an integer. Every boundary and every
; mean below goes through forge-div or an explicit `to integer!`,
; because a `float!` arriving at a typed parameter is `expect-arg` and
; the substrate will not tell you which value was wrong.

; ── the lattice. numerology: nothing here is a bare literal. ──────────
FORGE-COLS: 40
FORGE-ROWS: 12

; luma at or above this is a lit dot. 128 is the midpoint of a byte.
; it is not a tuned constant and tuning it would be dishonest.
FORGE-LUMA-MID: 128

; Rec.709 luma weights in parts-per-thousand, so the arithmetic is
; reproducible and two implementations cannot disagree about rounding.
FORGE-LUMA-R: 212
FORGE-LUMA-G: 715
FORGE-LUMA-B: 72

; the braille dot map. (x,y) -> bit, x is 0 or 1, y is 0..3:
;     0 3
;     1 4
;     2 5
;     6 7
FORGE-BITS: [[0 3] [1 4] [2 5] [6 7]]
; the bit weights, because `^` is not an operator here — it
; parses as a word and yields none!.
FORGE-POWERS: [1 2 4 8 16 32 64 128]
FORGE-BRAILLE-BASE: 10240          ; 0x2800
FORGE-HALF-BLOCK: 9600            ; 0x2580

forge-esc: to char! 27
FORGE-OFF: rejoin [forge-esc "[0m"]

; ── integer division, rounded half up, in one place. ─────────────────
; Everything geometric in this file goes through here so that there is
; exactly one rounding rule to reason about.
forge-div: func [a [integer!] b [integer!]][
    to integer! divide (a + divide b 2) b
]

; ── Rec.709 luma, 0..255, as an integer. ─────────────────────────────
forge-luma: func [r [integer!] g [integer!] b [integer!]][
    to integer! divide ((r * FORGE-LUMA-R) + (g * FORGE-LUMA-G) + (b * FORGE-LUMA-B)) 1000
]

; ── one truecolour SGR for a foreground and a background. ───────────
forge-sgr24: func [fr [integer!] fg [integer!] fb [integer!]
                    br [integer!] bg [integer!] bb [integer!]][
    ; `copy` REFUSES a char! — same family as `length?` on a char!.
    ; to string! first, then copy if a real string is wanted.
    s: to string! forge-esc
    append s "[38;2;"
    append s to string! fr
    append s ";"
    append s to string! fg
    append s ";"
    append s to string! fb
    append s ";48;2;"
    append s to string! br
    append s ";"
    append s to string! bg
    append s ";"
    append s to string! bb
    append s "m"
    s
]

; ── area-average one rectangle of the image. returns [r g b]. ───────
; Box average, not nearest. Nearest on a 512 -> 80 reduction aliases
; badly and discards exactly the detail the picture is made of.
forge-mean: func [img [image!] w [integer!] h [integer!]
                  x0 [integer!] y0 [integer!] x1 [integer!] y1 [integer!]][
    sr: 0  sg: 0  sb: 0  n: 0
    yy: y0
    while [yy < y1][
        xx: x0
        while [xx < x1][
            p: pick img ((yy * w) + xx + 1)
            sr: sr + to integer! pick p 1
            sg: sg + to integer! pick p 2
            sb: sb + to integer! pick p 3
            n: n + 1
            xx: xx + 1
        ]
        yy: yy + 1
    ]
    either (n = 0) [
        reduce [0 0 0]
    ][
        ; forge-div adds the half itself, so hand it the raw sums.
        ; writing `forge-div (sr + divide n 2) n` looks right and is not:
        ; `divide n 2` is a decimal, the sum is a decimal, and a typed
        ; parameter rejects it with expect-arg and no hint which value.
        reduce [forge-div sr n
                forge-div sg n
                forge-div sb n]
    ]
]

; ── THE FORGE. braille, 2x4 samples per cell, 80x48, truecolour. ─────
;
; The picture supplies structure — which dots are lit — and luma supplies
; colour: a lit sample takes the palette's high colour, an unlit one the
; palette's low colour. That is not a compromise forced by the decode; it
; is how terminal art has always worked, and a palette the imp chooses
; beats one sampled out of a photograph.
forge-braille: func [img [image!] w [integer!] h [integer!]
                     fr [integer!] fg [integer!] fb [integer!]
                     br [integer!] bg [integer!] bb [integer!]][
    ; the fixed threshold. kept because it is the BASELINE the
    ; experiment is measured against, not because it is best.
    forge-braille-at img w h fr fg fb br bg bb FORGE-LUMA-MID
]

; the same, with the threshold supplied. this is the form the eval
; harness varies, so that "did the threshold cost us the darks?" is a
; question with two measurements rather than an opinion.
forge-braille-at: func [img [image!] w [integer!] h [integer!]
                     fr [integer!] fg [integer!] fb [integer!]
                     br [integer!] bg [integer!] bb [integer!] thr [integer!]][
    cols: FORGE-COLS
    rows: FORGE-ROWS
    sw: 2
    sh: 4
    sample-w: cols * sw
    sample-h: rows * sh
    out: copy []
    ry: 0
    while [ry < rows][
        line: copy []
        cx: 0
        while [cx < cols][
            bits: 0
            on-r: 0  on-g: 0  on-b: 0  on-n: 0
            off-r: 0  off-g: 0  off-b: 0  off-n: 0
            dy: 0
            while [dy < sh][
                dx: 0
                while [dx < sw][
                    x0: forge-div ((cx * sw) + dx) * w sample-w
                    x1: forge-div (((cx * sw) + dx) + 1) * w sample-w
                    y0: forge-div ((ry * sh) + dy) * h sample-h
                    y1: forge-div (((ry * sh) + dy) + 1) * h sample-h
                    if (x1 <= x0) [x1: x0 + 1]
                    if (y1 <= y0) [y1: y0 + 1]
                    m: forge-mean img w h x0 y0 x1 y1
                    ; BIND FIRST, THEN COMPARE IN PARENTHESES. Written
                    ; inline as `if forge-luma a b c >= LIMIT [...]` this
                    ; does NOT mean what it looks like: measured, a luma
                    ; of 81 against a limit of 128 came back LIT. Red has
                    ; no operator precedence, so every comparison in
                    ; this file is parenthesised. The law was in
                    ; AGENTS.md the whole time and I ignored it.
                    lum: forge-luma to integer! pick m 1 to integer! pick m 2 to integer! pick m 3
                    if (lum >= thr) [
                        bits: bits + pick FORGE-POWERS (pick (pick FORGE-BITS (dy + 1)) (dx + 1)) + 1
                        on-r: on-r + to integer! pick m 1
                        on-g: on-g + to integer! pick m 2
                        on-b: on-b + to integer! pick m 3
                        on-n: on-n + 1
                    ][
                        off-r: off-r + to integer! pick m 1
                        off-g: off-g + to integer! pick m 2
                        off-b: off-b + to integer! pick m 3
                        off-n: off-n + 1
                    ]
                    dx: dx + 1
                ]
                dy: dy + 1
            ]
            either (on-n = 0) [
                cr: fr  cg: fg  cb: fb
            ][
                cr: forge-div on-r on-n
                cg: forge-div on-g on-n
                cb: forge-div on-b on-n
            ]
            either (off-n = 0) [
                dr: br  dg: bg  db: bb
            ][
                dr: forge-div off-r off-n
                dg: forge-div off-g off-n
                db: forge-div off-b off-n
            ]
            append line forge-sgr24 cr cg cb dr dg db
            append line to string! to char! (FORGE-BRAILLE-BASE + bits)
            cx: cx + 1
        ]
        append line FORGE-OFF
        append out line
        ; HAZARD 11, twice bitten. `rejoin out` joins with NOTHING, so
        ; twelve lines became one 480-column line. Interleave the
        ; newlines, then rejoin once.
        if (ry < subtract rows 1) [append out "^/"]
        ry: ry + 1
    ]
    rejoin out
]

; ── the luma of the WHOLE picture, as a threshold ──────────────────
; WHY THIS EXISTS, and it is a measured thing rather than a theory.
;
; A first look at the braille said "the art is too faint, the fixed
; threshold of 128 must be wrong". Half of that was wrong. Four wishes
; were rendered and the source pngs kept beside the braille:
;
;   a lighthouse in a storm   -> dark, night, most samples UNDER 128.
;                                 the braille was sparse but the
;                                 composition survived: the tower is
;                                 there, the wave band is there.
;   a fox in white flowers    -> bright, saturated. the braille was
;                                 dense, and faithful — to a source
;                                 that was ALREADY a smear, because
;                                 sd-turbo at 256px made blobs.
;
; So the forge is not losing the picture; it is losing TEXTURE in the
; darks. A global 128 is the wrong rule for an image whose exposure
; was chosen by a diffusion model and is not obliged to sit in the
; middle of the range. The mean of the picture's own lumas is a
; threshold that follows the exposure, costs one pass over the samples,
; and cannot be tuned per image.
;
; It is not Sauvola. A real local threshold would be better still, and
; costs about twelve times as much in Red. This is the cheap honest
; version, and it is written so the expensive one can replace it.
forge-mean-luma: func [img w [integer!] h [integer!] sw [integer!] sh [integer!] /local
                        cx cy px py idx lum n s][
    ; A GRID ACROSS THE PICTURE, and this is a real bug that was live for
    ; an hour. The first draft walked `pick img i` for i in 1..sw*sh,
    ; which on a 512x512 source is pixels 1 to 3840 — the first SEVEN
    ; ROWS. Every "picture mean" it reported (42 for a 256 storm scene,
    ; 110 for a 512 one) was the mean of a strip along the top edge, and
    ; on a picture whose top is storm sky that strip says nothing about
    ; the picture. It is also why Otsu and the mean appeared to disagree
    ; wildly while both reporting 110: the mean file on disk was STALE,
    ; left over from an earlier run whose mean variant had thrown.
    ;
    ; So: sample on a sw x sh grid spread over the WHOLE image, the same
    ; distribution the eye reads. `forge-div` and no operator precedence.
    s: 0
    n: 0
    cx: 0
    while [cx < sw][
        px: forge-div (cx * w) sw
        cy: 0
        while [cy < sh][
            py: forge-div (cy * h) sh
            ; raster order, and +1 because `pick` is 1-BASED
            idx: (py * w) + px + 1
            lum: forge-luma to integer! pick pick img idx 1 to integer! pick pick img idx 2 to integer! pick pick img idx 3
            s: s + lum
            n: n + 1
            cy: cy + 1
        ]
        cx: cx + 1
    ]
    either (n = 0) [0][forge-div s n]
]

; braille with the threshold taken from the picture's own mean luma.
; one extra pass over the samples; no tuning; follows the exposure the
; diffusion model chose. measured against forge-braille in
; tests/rites/rate-compare.red.
forge-braille-mean: func [img [image!] w [integer!] h [integer!]
                           fr [integer!] fg [integer!] fb [integer!]
                           br [integer!] bg [integer!] bb [integer!]][
    cols: FORGE-COLS
    rows: FORGE-ROWS
    forge-braille-at img w h fr fg fb br bg bb forge-mean-luma img w h (cols * 2) (rows * 4)
]

; ── OTSU. the threshold the mean is unable to give. ──────────────────
;
; MEASURED, on a 512x512 sd-turbo picture of a lighthouse in a storm
; rendered with the CORRECT sampler (4 steps, cfg 1.0 — see the note at
; the hand's call site in conjure.red, because until that fix the whole
; diagnosis of "sd-turbo is weak" was wrong):
;
;   picture mean luma: 110
;
; and the braille that came out was mostly empty. Why: the picture is
; BIMODAL. A storm sky occupies most of the frame and is dark; the
; lighthouse and the foam are bright. The mean of the two populations
; lands in the empty space between them, so a global-mean threshold
; discards the entire sky and keeps only the subject.
;
; The mean threshold is not wrong, it is a DIFFERENT tool: it fixed the
; case it was written for (a whole picture sitting low in the range,
; mean 42 against a fixed 128) and it is still the fallback. But a mean
; cannot separate two populations, and this picture has two.
;
; Otsu is the standard answer and it is still only ONE pass over the
; samples plus a 256-bin sweep: build a histogram, then pick the t that
; maximises the between-class variance. It is global like the mean, so it
; costs the same, but it is global *optimally* rather than
; globally-arbitrarily.
;
; IT IS NOT SAUVOLA, which would be local and would handle a subject on
; a graded background. Sauvola needs a mean and a variance per window
; over a 5x5-cell neighbourhood: about twelve times the work in Red, for
; a case this picture is not. Written so it can be replaced.
;
; ARITHMETIC NOTE, and it is not pedantry. red-view is a 32-bit build.
; The textbook between-class variance is w0*w1*(mu0-mu1)^2, whose
; maximum here is 1920*1920*255*255 = 2.4e11 — an order of magnitude past
; Integer/32!. Dividing w0*w1 by a CONSTANT 256 before the multiply
; brings the maximum to 9.4e8, inside the range, and dividing every
; candidate by the same constant cannot change which one is largest.
; The argmax is exact; only the reported score is scaled.
; `img` is DELIBERATELY UNTYPED. It was `[image!]`, which is honest about
; the production call and fatal for testing: with a typed spec, a block of
; synthetic r.g.b.a tuples is refused with id 'expect-arg, so the only
; way to exercise this function is to find a photograph with a known
; answer, and no such photograph exists. A threshold you cannot unit-test
; is a threshold you cannot trust — the bug it hid (see the histogram
; note below) sat behind exactly that wall. It wants anything `pick`
; reaches two deep: a PNG, or a block of tuples built by hand.
forge-otsu: func [img w [integer!] h [integer!] sw [integer!] sh [integer!] /local
                    hist cx cy px py idx lum n sum t best b w0 s0 w1 s1 m0 m1 dm sc q cnt][
    ; 1. a 256-bin histogram, because a luma IS 0..255.
    hist: copy []
    i: 1
    while [i <= 256][
        append/only hist 0
        i: i + 1
    ]

    ; THE SAME GRID AS forge-mean-luma, for the same reason and the same
    ; bug: a histogram of the first sw*sh pixels is a histogram of the
    ; top edge of the picture. A threshold computed from a strip of sky is
    ; a threshold for the sky.
    n: 0
    sum: 0
    cx: 0
    while [cx < sw][
        px: forge-div (cx * w) sw
        cy: 0
        while [cy < sh][
            py: forge-div (cy * h) sh
            idx: (py * w) + px + 1
            lum: forge-luma to integer! pick pick img idx 1 to integer! pick pick img idx 2 to integer! pick pick img idx 3
            either (lum < 0) [lum: 0][
                either (lum > 255) [lum: 255][lum: lum]
            ]
            ; `poke`, NOT `replace`, and the reason is worth the four rounds
            ; of bisection it cost. On a BLOCK, `replace` FINDS THE VALUE:
            ;   replace [1 2 3 2 1 2] 3 99  ->  [1 2 99 2 1 2]
            ; and it mutates in place as well as returning the block. Which
            ; sounds positional and is not: against a histogram of zeros,
            ;   replace hist 4 (c + 1)
            ; looks for the VALUE 4, finds none, and changes NOTHING — with no
            ; error and no complaint. The first draft of this function used it,
            ; so the histogram stayed all zeros, so Otsu was being fed a
            ; degenerate input and would have returned a confident wrong
            ; threshold. tests/rites/rite-otsu.red caught it (A3 bin4 0,
            ; A4 BROKEN) before it ever reached a frame.
            ;
            ; `poke` IS positional, and it returns THE ASSIGNED VALUE, not the
            ; series — so `hist: poke hist k v` would rebind the histogram to
            ; a number and destroy it. Call it bare.
            ;
            ; Neither `poke/only` nor `replace/only` exists in Red 0.6.6
            ; (measured: id 'no-refine on both).
            cnt: pick hist (lum + 1)
            poke hist (lum + 1) (cnt + 1)
            n: n + 1
            sum: sum + lum
            cy: cy + 1
        ]
        cx: cx + 1
    ]

    ; 2. sweep every candidate t, keeping the best separation.
    ;    `and` is a bitwise op! on this build, never a logical one, so
    ;    the guard is nested ifs. (It is documented in AGENTS.md and I
    ;    still nearly wrote it.)
    best: 0
    b: 0
    w0: 0
    s0: 0
    t: 0
    while [t < 256][
        w0: w0 + pick hist (t + 1)
        s0: s0 + (t * pick hist (t + 1))
        t: t + 1
        w1: n - w0
        s1: sum - s0
        if (w0 > 0) [
            if (w1 > 0) [
                m0: forge-div s0 w0
                m1: forge-div s1 w1
                dm: m0 - m1
                ; two statements, not one expression: red has no
                ; precedence, so `a * b * c` is `((a * b) * c)` and the
                ; scaling has to land on the first factor deliberately.
                q: forge-div (w0 * w1) 256
                sc: q * (dm * dm)
                if (sc > b) [
                    b: sc
                    best: t
                ]
            ]
        ]
    ]

    ; TWO HONEST CORRECTIONS, both found by running it rather than
    ; reading it. A synthetic picture of 200 samples at luma 20 and 200
    ; at luma 200 returns 20.
    ;
    ; That is not wrong, it is the CONVENTION. Otsu's t is the last
    ; BACKGROUND bin: everything at or below t is class 0. Between two
    ; well-separated populations every t in the gap scores identically, so
    ; the first maximum is the highest dark bin — 20. As a classifier it
    ; is perfect. As a THRESHOLD for `if (lum >= thr)` it is the opposite
    ; of what we want, because it would light the entire dark population.
    ; So return the first FOREGROUND bin, which is one higher, and the
    ; caller's existing comparison lights exactly the foreground and
    ; needs no change of its own.
    ;
    ; Second: a picture with NO two populations — measured: 400 samples
    ; all at luma 40 — produces no candidate at all, because w0 or w1 is
    ; zero for every t, b never leaves 0, and the raw answer is 0. That
    ; lights the whole picture, which is the loudest possible wrong
    ; answer. Otsu has genuinely nothing to say here, so fall back to the
    ; mean, which for a flat picture renders it at its own average tone.
    ; A flat picture is the one input where any threshold is arbitrary;
    ; saying so in a comment is the honest move and picking 0 silently is
    ; not.
    either (b = 0) [
        either (n = 0) [0][forge-div sum n]
    ][
        best + 1
    ]
]

; braille whose threshold is Otsu's. the shipped default.
forge-braille-otsu: func [img [image!] w [integer!] h [integer!]
                          fr [integer!] fg [integer!] fb [integer!]
                          br [integer!] bg [integer!] bb [integer!]][
    forge-braille-at img w h fr fg fb br bg bb forge-otsu img w h (FORGE-COLS * 2) (FORGE-ROWS * 4)
]

; ── a luma ramp, for looking AT the picture instead of guessing ──────
; This renders grey levels as a ramp of characters with no threshold at
; all. It is the control in the experiment: if the ramp reads as the
; picture and the braille does not, the braille is losing something
; and the threshold is where to look. If they read the same, the
; braille is innocent and the loss is upstream in the 256px render.
forge-ramp: func [img [image!] w [integer!] h [integer!] cols [integer!] rows [integer!] /local ramp out ry cx m lum n][
    ramp: " .,:;irsXA253hMHGS#9B&@"
    out: copy []
    ry: 0
    while [ry < rows][
        line: copy []
        cx: 0
        while [cx < cols][
            ; PARENTHESES. Red has no operator precedence, so
            ; `forge-div cx * w cols` is forge-div(cx) * w * cols.
            m: forge-mean img w h forge-div (cx * w) cols forge-div (ry * h) rows forge-div ((cx + 1) * w) cols forge-div ((ry + 1) * h) rows
            lum: forge-luma to integer! pick m 1 to integer! pick m 2 to integer! pick m 3
            ; forge-div, not `/`. in Red `/` is float division, so n came
            ; out a DECIMAL and every pick returned none! — a control that
            ; measured my bug instead of the threshold.
            n: forge-div (lum * (length? ramp)) 255
            if n > (subtract length? ramp 1) [n: subtract length? ramp 1]
            if n < 0 [n: 0]
            append line pick ramp (n + 1)
            cx: cx + 1
        ]
        append out line
        if (ry < (subtract rows 1)) [append out "^/"]
        ry: ry + 1
    ]
    rejoin out
]

; ── THE FORGE. half-blocks, 2x2 samples per cell, 40x24, truecolour. ─
; The two vertical samples become literal foreground and background, so
; a single cell is two pixels of the picture rather than one.
forge-block: func [img [image!] w [integer!] h [integer!]][
    cols: FORGE-COLS
    rows: FORGE-ROWS
    sw: 2
    sh: 2
    sample-w: cols * sw
    sample-h: rows * sh
    out: copy []
    ry: 0
    while [ry < rows][
        line: copy []
        cx: 0
        while [cx < cols][
            xa: forge-div (cx * sw) * w sample-w
            xb: forge-div ((cx * sw) + 1) * w sample-w
            xc: forge-div ((cx * sw) + 2) * w sample-w
            ya: forge-div (ry * sh) * h sample-h
            yb: forge-div ((ry * sh) + 1) * h sample-h
            yc: forge-div ((ry * sh) + 2) * h sample-h
            if (xb <= xa) [xb: xa + 1]
            if (xc <= xb) [xc: xb + 1]
            if (yb <= ya) [yb: ya + 1]
            if (yc <= yb) [yc: yb + 1]
            top: forge-mean img w h xa ya xb yb
            bot: forge-mean img w h xb yb xc yc
            append line forge-sgr24 to integer! pick top 1 to integer! pick top 2 to integer! pick top 3 to integer! pick bot 1 to integer! pick bot 2 to integer! pick bot 3
            append line to string! to char! FORGE-HALF-BLOCK
            cx: cx + 1
        ]
        append line FORGE-OFF
        append out line
        ; HAZARD 11, twice bitten. `rejoin out` joins with NOTHING, so
        ; twelve lines became one 480-column line. Interleave the
        ; newlines, then rejoin once.
        if (ry < subtract rows 1) [append out "^/"]
        ry: ry + 1
    ]
    rejoin out
]
