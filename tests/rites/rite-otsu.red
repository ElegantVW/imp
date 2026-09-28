Red [Title: "rite-otsu"]
; OTSU — a threshold, and the two things it rests on.
;
; WHY. `forge-otsu` exists because the mean cannot do this job. Measured
; on a 512x512 sd-turbo lighthouse — rendered with the CORRECT sampler,
; 4 steps cfg 1.0, which is itself the fix that killed the older
; "sd-turbo is weak" story — the picture's mean luma was 110 and the
; braille came out mostly empty. The picture is BIMODAL: a dark storm
; sky over most of the frame, a bright tower and bright foam in it. A
; mean lands between the two populations and discards one of them.
;
; The mean threshold is not WRONG, it is a different tool: it fixed the
; case it was written for (a whole picture sitting low in the range,
; mean 42 against a fixed 128) and it is still the fallback. But a mean
; cannot separate two populations, and this picture has two.
;
; Otsu is the standard answer and still costs one pass over the samples
; plus a 256-bin sweep: histogram, then take the t that maximises the
; between-class variance. Global like the mean, so the same price, but
; global OPTIMALLY rather than globally-arbitrarily.
;
; It is not Sauvola, which would be local and would handle a subject on
; a graded background. Sauvola wants a mean and a variance per window
; over a 5x5-cell neighbourhood: about twelve times the work in Red, for
; a case this picture is not. Written so it can be replaced.
;
; 32-BIT ARITHMETIC, asserted below rather than assumed. red-view is a
; 32-bit build. The textbook between-class variance is
; w0*w1*(mu0-mu1)^2, whose maximum here is 1920*1920*255*255 = 2.4e11 —
; an order of magnitude past Integer/32! (2.1e9). Dividing w0*w1 by a
; CONSTANT 256 before the multiply brings the peak to 9.4e8, inside the
; range, and dividing every candidate by the same constant cannot change
; which is largest. The argmax is exact; only the reported score is
; scaled.
;
; This file was rewritten once already. The first draft was correct in
; intent and would not load, and finding out why cost four rounds of
; bisection in which the BISECTION was broken three separate times: a
; `;` comment injected above `mark: func`, a poll watching a path no rite
; wrote, and a captured file literal that still had Red's `%` sigil on
; it, so `rm -f "%/dev/shm/imp/x.txt"` politely removed a file named `%`.
; All three reported a working prelude as broken. The lesson is not "Red
; is hard"; it is that a harness which is not itself tested will invent
; faults. Hence the CONTROL in section 1.

do %src/core.red
do %src/forge.red

PROBE: %/dev/shm/imp/otsu-witness.txt
PART:  %/dev/shm/imp/otsu-tmp.txt
BREADCRUMB: %/dev/shm/imp/otsu-open.txt
led: copy []

; `note` ACCUMULATES and does not write. The first version wrote the whole
; ledger on every line, which is a LOG, and rited treats a non-empty
; witness as the end of the rite: it printed the testimony, exited, and
; pkill'd red-view — killing the rite mid-flight. The result was a rite
; that reported D3 on one run and D4 on the next, which read exactly like
; nondeterminism in the code under test. AGENTS.md says the witness must
; be a single end product written once, and this is the second time this
; session that rule has been the thing I needed.
;
; So: accumulate, then write ONCE at the end and `rename` into place, so
; rited's poll can never catch a half-written file. `rename` takes
; literals (hazard 14) and both of these are.
;
; The breadcrumb is the "open the testimony before anything that can fail"
; half of the same law, sent to a file rited does not watch, so a rite
; that dies still leaves proof it began.
; PROGRESS GOES TO A FILE rited DOES NOT POLL. Writing the witness on
; every line races the harness (see above); writing nothing means a rite
; that dies tells you only that it died. So each line also lands in a
; progress log, stamped with `now`, which nobody waits on.
T0: now
prog: copy []
note: func [k [string!] v][
    append led rejoin [k " " mold v]
    append prog rejoin [k " " mold v "   +" mold difference now T0]
    write %/dev/shm/imp/otsu-progress.txt rejoin prog
]
write BREADCRUMB "OPENED"

; ── 1. the instrument, before the measurement ────────────────────────
; THE HISTOGRAM IS BUILT WITH `poke`, and `poke` exists because
; `replace` is a trap on a BLOCK: it finds the VALUE. Measured:
;
;   replace [1 2 3 2 1 2] 3 99  ->  [1 2 99 2 1 2]   (found the 3)
;   replace [0 0 0 0 0]     4  1  ->  [0 0 0 0 0]     (found no 4, no-op)
;   poke    [0 0 0 0 0]     4  7  ->  7               (positional, and it
;                                                        returns the VALUE)
;
; so the first draft of forge-otsu built its histogram with `replace` and
; silently incremented nothing: A3 bin4 0, A4 BROKEN. A threshold
; computed from an all-zero histogram is not an error, it is a confident
; wrong number, which is worse. This section is the instrument check
; that has to come BEFORE the measurement, for exactly that reason.
blk: [1 2 3 2 1 2]
blk: replace blk 3 99
note "A1 replace-finds-value" blk
note "A2 replace-ok" either (blk = [1 2 99 2 1 2]) ["SEALED"] ["BROKEN"]

h: copy []
i: 1
while [i <= 10][
    append/only h 0
    i: i + 1
]
i: 1
while [i <= 5][
    c: pick h 4
    poke h 4 (c + 1)
    i: i + 1
]
note "A3 bin4" pick h 4
note "A4 hist-ok" either (pick h 4) = 5 ["SEALED"] ["BROKEN"]

; and the OTHER half of the instrument: the threshold must be computed
; from a grid spread over the WHOLE picture. The first draft walked
; `pick img i` for i in 1..sw*sh, which on a 512x512 source is the first
; SEVEN ROWS — so every "picture mean" ever reported (42, then 110) was
; the mean of a strip of storm sky along the top edge, and it looked
; authoritative the whole time.
;
; The test has to be able to tell the two samplers apart, and the first
; version of this test could not: it used a 20x20 picture with a 20x20
; sample grid, so sw*sh == w*h and BOTH samplers read every pixel. A test
; that passes against the bug is worse than no test, because it is a
; promise. So: 40x40 picture, 5x5 grid — 1600 pixels, 25 samples. The top
; two rows are dark, everything else bright.
;
;   grid sampler    sees 25 samples across the picture -> two populations
;                   -> threshold 11, dark excluded
;   strip sampler   sees the first 25 pixels, which is row 1, all dark
;                   -> no second population -> falls back to the mean,
;                      which is 10 -> and `lum >= 10` LIGHTS the darks
;
; so `sp > 10` is the assertion that separates them.
strip: copy []
i: 1
while [i <= 40][
    j: 1
    while [j <= 40][
        either (i < 3) [
            append/only strip 10.10.10.255
        ][
            append/only strip 240.240.240.255
        ]
        j: j + 1
    ]
    i: i + 1
]
sp: try [forge-otsu strip 40 40 5 5]
sp: to integer! either (error? sp) [-1][to integer! sp]
note "A5 dark-top-bright-rest" sp
note "A6 grid-not-a-strip" either (sp > 10) ["SEALED"] ["BROKEN, the threshold is reading the top edge only"]

; ── 2. pictures with a KNOWN answer ─────────────────────────────────
; Otsu is only worth trusting if it is right for a reason, so give it
; two synthetic pictures whose answer is not in doubt. And note that the
; FIRST version of these tests asserted the wrong thing and were wrong in
; a way that looked like the function being wrong.
;
; What the caller needs is: `if (lum >= thr)` must NOT light the dark
; population and MUST light the bright one. That is a property of the
; FOREGROUND threshold, not of Otsu's t.
;
; (a) bimodal: 200 samples at luma 20, 200 at luma 200. Every t in the
;     gap scores identically under Otsu, so the raw argmax is the highest
;     DARK bin — 20 — which would light the entire dark population. So
;     the property to assert is `20 < thr` and `thr <= 200`: the dark
;     population excluded, the bright one included. Asserting "thr is in
;     the middle of the gap" instead would have failed against a correct
;     function, and I would have "fixed" the function to satisfy a test
;     that had the wrong question.
; (b) flat: everything at luma 40. There are no two populations, Otsu
;     has nothing to say, and the raw answer is 0 — which lights
;     everything. The function falls back to the mean, so the answer here
;     must be 40, and the point of the test is that the degenerate case
;     is HANDLED rather than returned raw.
bimodal: copy []
i: 1
while [i <= 200][
    append/only bimodal 20.20.20.255
    append/only bimodal 200.200.200.255
    i: i + 1
]
; ONE-ARMED `either`, hazard 20, and it cost this rite its whole
; debugging session. `either error? try [...] [-1]` reads as "condition,
; true-arm" — so the TRUE arm is `[-1]` and there is NO false arm, which
; is a silent fatal error whose failure point is not where the mistake
; is. It presented as an interpreter that HUNG partway through, at four
; different lines on four different runs, which is the signature of
; hazard 20 and not of a slow loop.
; The fix is the same everywhere: bind the `try` to a word, then ask
; about the word. You cannot call `try` twice, so the value has to be
; kept — and the parentheses matter, because `either error? t [..][..]`
; parses the condition as `error? (t [..][..])` if `t` is a call.
tb: try [forge-otsu bimodal 20 20 20 20]
tb: to integer! either (error? tb) [-1][to integer! tb]
note "B1 bimodal" tb
note "B2 dark-excluded" either (tb > 20) ["SEALED"] ["BROKEN, the dark population would be lit"]
note "B3 bright-included" either (tb <= 200) ["SEALED"] ["BROKEN"]

flat: copy []
i: 1
while [i <= 400][
    append/only flat 40.40.40.255
    i: i + 1
]
tf: try [forge-otsu flat 20 20 20 20]
tf: to integer! either (error? tf) [-1][to integer! tf]
note "B4 flat-falls-back" tf
; 39, NOT 40, and that is not a rounding quibble: luma(40,40,40) is 39
; because the Rec.709 weights in forge-luma sum to about 996, not 1000.
; The first version of this test asserted 40 and reported BROKEN against
; a correct function. A test that asserts a value it computed in its own
; head rather than with the function under test is a test with the
; arithmetic in the wrong place.
note "B5 flat-ok" either (tf = 39) ["SEALED"] ["BROKEN, a flat picture has no split and must not return 0"]

; and the thing that separates Otsu from the mean wearing a hat: on the
; BIMODAL picture the mean is (20+200)/2 = 110 and Otsu returns 21. They
; are not the same function, and this is the measurement that says so.
note "B6 otsu-differs-from-mean" either (tb = 110) ["BROKEN, that is the mean"] ["SEALED, 21 is not 110"]

; ── 3. the 32-bit claim ─────────────────────────────────────────────
pk: 1920 * 1920
sq: 255 * 255
unscaled: pk * sq
scaled: forge-div pk 256
scaled: scaled * sq
; WHAT RED ACTUALLY DOES, measured rather than feared: the unscaled peak
; comes back as 239708160000.0 — a DECIMAL. Red does not wrap and does not
; raise; it promotes. So the honest statement is not "this overflows 32
; bits" (it does not) but "this leaves integer range, and every
; comparison after it would be a comparison between decimal and integer".
; That still works, which is why the bug would have been silent. The
; scaling keeps the whole sweep in integer range for the cost of one
; division by a constant, and dividing every candidate by the same
; constant cannot change which is largest.
note "C1 unscaled-peak" unscaled
note "C1b promoted-to-decimal" either (integer? unscaled) ["no, it stayed integer"] ["YES, Red promoted it"]
note "C2 scaled-peak" scaled
note "C3 over-32bit" either (unscaled > 2147483647) ["CONFIRMED"] ["UNEXPECTED"]
note "C4 scaled-fits" either (scaled <= 2147483647) ["SEALED"] ["BROKEN"]

; ── 4. the real picture, and the two thresholds side by side ─────────
IMG: %/dev/shm/imp/probe-src.png
img: try [load/as IMG 'png]

either error? img [

    note "D load-error" img

][

    note "D0 source" img/size

    ; SIX arguments, not four: img, w, h, sw, sh. The first version passed
    ; four and got an expect-arg, so the mean came back as the -1 of the
    ; error path and the mean-vs-Otsu comparison silently compared -1
    ; against a real number and reported DIFFERENT, which it was.
    mean-l: try [forge-mean-luma img 512 512 80 48]
    mean-l: to integer! either (error? mean-l) [-1][to integer! mean-l]
    otsu-l: try [forge-otsu img 512 512 80 48]
    otsu-l: to integer! either (error? otsu-l) [-1][to integer! otsu-l]
    note "D1 mean" mean-l
    note "D2 otsu" otsu-l
    note "D3 differ" either (mean-l = otsu-l) ["same"] ["DIFFERENT"]

    art: try [forge-braille-otsu img 512 512 236 228 214 24 28 36]
    art: either (error? art) ["threw"][art]
    either error? art [
        note "D4 otsu-braille" "threw"
    ][
        note "D4 otsu-braille-len" length? art
        ; the pattern rate-compare.red uses, which is known to work:
        ; the string "wrote" rides along INSIDE the try so the block has a
        ; value, and the error test comes afterwards on a bound word.
        ; Written as `try [write ... art]` with no trailing expression the
        ; block's value is whatever `write` hands back — a file! — and
        ; `error?` on that is a different question than the one I meant to
        ; ask. Two attempts at this line failed before the shape was
        ; copied from a rite that already worked.
        w2: try [write %/dev/shm/imp/otsu-braille.txt art "wrote"]
        w2s: either (error? w2) ["threw"] [to string! w2]
        note "D5 wrote" w2s
    ]
]

; the progress log, once the ledger is safely on disk, so a slow rite
; is legible rather than merely slow.
write %/dev/shm/imp/otsu-progress.txt rejoin prog
write PART rejoin led
rename %/dev/shm/imp/otsu-tmp.txt %/dev/shm/imp/otsu-witness.txt
