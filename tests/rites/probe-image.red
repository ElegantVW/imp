Red [Title: "probe-image"]
; AN image! IS A 512x512 GREYSCALE BINARY.
;
;   B1 type: image!
;   B4 first-type: make image! [512x512 #{88807E83…}]
;
; One byte per pixel, so the decoded form is LUMA, not colour. That is a
; constraint, and the honest response is to use it: a luma ramp is what
; terminal art has always been, braille was invented for exactly this,
; and a palette can be chosen by the imp rather than sampled from the
; image. The diffusion model supplies structure; the imp supplies colour.
; That is a better division of labour than copying pixels anyway.
;
; What is left to learn is how to ADDRESS an image!, and how to write
; one back out — because `image/encode` means Red can create images too,
; and a library that can do both is worth having.

do %src/core.red

PROBE: %/dev/shm/imp/probe-image.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

d: try [load/as %/dev/shm/imp/probe-src.png 'png]
either error? d [
    mark rejoin ["LOAD-ERROR " mold d]
][
    ; ── 1. addressing. pick 1 is the first PIXEL or the first BYTE? ──
    t: try [mold pick d 1]
    mark rejoin ["A1 pick1: " either error? t ["threw " mold t] [to string! t]]

    t: try [mold type? :pick d 1]
    mark rejoin ["A2 pick1-type: " either error? t ["threw"] [to string! t]]

    ; ── 2. the dimensions, which `size?` refused to give ────────────
    t: try [mold d/size]
    mark rejoin ["B1 img/size: " either error? t ["threw " mold t] [to string! t]]

    t: try [mold size? d]
    mark rejoin ["B2 size?: " either error? t ["threw " mold t] [to string! t]]

    ; ── 3. the pixel payload as a series we can index directly. this
    ;       is the one that matters: a forge wants `pick bytes n`. ───
    t: try [b: d/data  "len=" mold length? b]
    mark rejoin ["C1 img/data: " either error? t ["threw " mold t] [to string! t]]

    t: try [b: d/data  either binary? b ["is-binary"]["not-binary"]]
    mark rejoin ["C2 data-type: " either error? t ["threw " mold t] [to string! t]]

    t: try [b: d/data  mold to integer! pick b 1]
    mark rejoin ["C3 data-byte1: " either error? t ["threw " mold t] [to string! t]]

    t: try [b: d/data  mold to integer! pick b 2]
    mark rejoin ["C4 data-byte2: " either error? t ["threw " mold t] [to string! t]]

    ; the payload as a plain word list would let the forge index it
    ; without a binary conversion, so ask if that view exists
    t: try [mold words-of :d]
    mark rejoin ["D1 img-words: " either error? t ["threw"] [to string! t]]

    ; ── 4. can Red BUILD an image and encode it? if so, the imp can
    ;       draw, not only read — and that is a real library. ────────
    t: try [
        im: make image! reduce [40 12 binary]
        "made " mold length? im
    ]
    mark rejoin ["E1 make-image: " either error? t ["threw " mold t] [to string! t]]

    ; ── 5. the luma of a few known spots, to sanity-check that the
    ;       decode is not upside down. the top-left of our lighthouse
    ;       png is dark storm sky, so it should be dark. ─────────────
    t: try [
        b: d/data
        s: 0
        i: 1
        while [i <= 64][
            s: s + to integer! pick b i
            i: i + 1
        ]
        mold divide s 64
    ]
    mark rejoin ["F1 topleft-mean-luma: " either error? t ["threw " mold t] [to string! t]]
]

mark "DONE"
