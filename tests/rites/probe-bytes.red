Red [Title: "probe-bytes"]
; CAN RED WALK A 500KB FILE OF ARBITRARY BYTES, AND HOW FAST?
;
; The imp's decoder is now certain to be necessary: sd-cli forces .png
; regardless of the extension given, there is no write-binary, no
; load/library and no ffi. So inflate gets written in Red. But before
; 300 lines of that, one question decides the design:
;
;   is `pick` on a large byte-string O(1), or does it scan?
;
; `length?` and `pick` count CHARACTERS while `find` and `index?` count
; BYTES (hazard 4). Arbitrary bytes above 127 are not valid UTF-8, so
; Red may well hold this file as a unicode string where every `pick` is
; a rescan from the front. If that is true, decoding 786KB is hopeless
; and the whole approach must change. If `pick` is O(1), it is fine.
;
; Measured, not assumed. Every assumption in this project so far has
; cost an hour.

do %src/core.red

PROBE: %/dev/shm/imp/probe-bytes.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

data: try [read %/dev/shm/imp/probe-src.png]
either error? data [
    mark rejoin ["READ-ERROR " mold data]
][
    mark rejoin ["len: " mold length? data]

    ; does Red see a byte count or a character count? `head` of the file
    ; is the PNG signature: 137 80 78 71 13 10 26 10. If `length?` counts
    ; characters and this file is utf-8-ish, the first char is a
    ; two-byte sequence and byte 2 is NOT reachable at index 2.
    t: try [mold pick data 1]
    mark rejoin ["byte1: " either error? t ["threw"] [to string! t]]

    t: try [mold pick data 2]
    mark rejoin ["byte2(want 80): " either error? t ["threw"] [to string! t]]

    t: try [mold pick data 3]
    mark rejoin ["byte3(want 78): " either error? t ["threw"] [to string! t]]

    t: try [to integer! pick data 1]
    mark rejoin ["byte1-as-int: " either error? t ["threw"] [to string! t]]

    ; the timing question. 200 picks spread across the file. If pick
    ; rescans, these get steadily slower and the tail picks are the
    ; expensive ones.
    t: try [
        s: 0
        i: 1
        while [i <= 200][
            s: s + to integer! pick data ((length? data / 200) * i) + 1
            i: i + 1
        ]
        mold s
    ]
    mark rejoin ["spread-sum: " either error? t ["threw " mold t] [to string! t]]

    ; sequential picks from the front, which is the pattern a decoder
    ; actually uses. If this is slow, nothing else matters.
    t: try [
        s: 0
        i: 1
        while [i <= 2000][
            s: s + to integer! pick data i
            i: i + 1
        ]
        mold s
    ]
    mark rejoin ["seq-2000-sum: " either error? t ["threw " mold t] [to string! t]]

    ; a chunk read, which is the escape if pick is O(n): copy/part once
    ; and work on a small slice.
    t: try [
        c: copy/part data 4000
        either length? c ["chunk-len=" mold length? c]["empty"]
    ]
    mark rejoin ["chunk: " either error? t ["threw " mold t] [to string! t]]

    ; to integer! on a char! is what a decoder needs per byte
    t: try [mold to integer! pick data 10]
    mark rejoin ["char10-int: " either error? t ["threw"] [to string! t]]
]

mark "DONE"
