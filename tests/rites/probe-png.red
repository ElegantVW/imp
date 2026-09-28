Red [Title: "probe-png"]
; WHAT SHAPE IS A DECODED PNG?
;
; `load/as %f 'png` returned 262144 for a 512x512 image — one value per
; pixel. So Red can decode the imp's images natively and no inflate
; library is required. I was about to write 300 lines of DEFLATE in Red
; and the language already had it. Worth remembering as a rule: measure
; the language's inventory before planning around its gaps.
;
; Now: is 262144 a binary of greys, a block of integers, an image! of
; one element, or a block of [r g b] triples? The forge needs RGB, or
; luma if that is what it is given. And how wide is the sample?

do %src/core.red

PROBE: %/dev/shm/imp/probe-png.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

; ── 1. the codec's own spec. authoritative, and it may name the
;       datatype and any refinement for width or channels. ────────────
t: try [mold system/codecs/png]
mark rejoin ["A1 png-codec: " either error? t ["threw"] [to string! t]]

; ── 2. the shape ─────────────────────────────────────────────────────
d: try [load/as %/dev/shm/imp/probe-src.png 'png]
either error? d [
    mark rejoin ["LOAD-ERROR " mold d]
][
    t: try [mold type? :d]
    mark rejoin ["B1 type: " either error? t ["threw"] [to string! t]]

    t: try [mold length? d]
    mark rejoin ["B2 length: " either error? t ["threw"] [to string! t]]

    t: try [mold size? :d]
    mark rejoin ["B3 size: " either error? t ["threw"] [to string! t]]

    t: try [mold type? :first d]
    mark rejoin ["B4 first-type: " either error? t ["threw"] [to string! t]]

    t: try [mold first d]
    mark rejoin ["B5 first-value: " either error? t ["threw"] [to string! t]]

    t: try [mold pick d 2]
    mark rejoin ["B6 second-value: " either error? t ["threw"] [to string! t]]

    t: try [mold pick d 4]
    mark rejoin ["B7 fourth-value: " either error? t ["threw"] [to string! t]]

    ; if it is a block of triples, the first three values are one pixel
    t: try [
        either all [(integer? pick d 1) (integer? pick d 2) (integer? pick d 3)] ["all-int"]["not-all-int"]
    ]
    mark rejoin ["B8 first3: " either error? t ["threw"] [to string! t]]
]

; ── 3. does it take a size hint? a small decode is what the forge
;       actually wants, since 40x24 cells is all the frame can show. ──
t: try [mold :load]
mark rejoin ["C1 load-has-as: " either error? t ["threw"] [to string! t]]

; ── 4. the other codecs, for the record ─────────────────────────────
t: try [mold keys-of system/codecs]
mark rejoin ["D1 codecs: " either error? t ["threw"] [to string! t]]

; ── 5. jpeg/bmp, because if png is the only one that works that is a
;       constraint worth writing down rather than discovering later ──
t: try [g: load/as %/dev/shm/imp/probe-src.png 'bmp  "len=" mold length? g]
mark rejoin ["E1 as-bmp: " either error? t ["threw " mold t] [to string! t]]

; ── 6. THE BIG ONE: is there a native image type with r,g,b? red-view
;       displays images, so an image! datatype may exist and may carry
;       real channels. if it does, the forge gets colour for free. ───
t: try [mold words-of :system]
mark rejoin ["F1 system-words: " either error? t ["threw"] [to string! t]]

mark "DONE"
