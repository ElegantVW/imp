Red [Title: "probe-codecs"]
; THE DOOR, AND WHETHER IT LEADS TO A SHORTCUT.
;
; read has /binary — "Preserves contents exactly". That alone solves the
; byte problem, and then the decoder is a library we write.
;
; But `load` has /as with a codec table listing "bmp, gif, jpeg, png,
; redbin, json, csv" and driven by system/codecs. If Red View ships a
; png codec, it already knows how to decode a png and the inflate
; library is a wheel we do not need to build.
;
; Both questions, measured, and the perf question that decides whether
; a decoder is even viable: is `pick` O(1) on a binary, or does it scan?

do %src/core.red

PROBE: %/dev/shm/imp/probe-codecs.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

; ── 1. what codecs exist? ────────────────────────────────────────────
t: try [mold keys-of system/codecs]
mark rejoin ["A1 codec-keys: " either error? t ["threw"] [to string! t]]

; ── 2. the native png decoder, if it exists ──────────────────────────
t: try [
    d: load/as %/dev/shm/imp/probe-src.png 'png
    "len=" mold length? d
]
mark rejoin ["B1 load-as-png: " either error? t ["threw " mold t] [to string! t]]

; ── 3. read/binary, which is the door we know exists ─────────────────
t: try [b: read/binary %/dev/shm/imp/probe-src.png  "len=" mold length? b]
mark rejoin ["C1 read-binary-len: " either error? t ["threw " mold t] [to string! t]]

t: try [b: read/binary %/dev/shm/imp/probe-src.png  either binary? b ["is-binary"]["not-binary"]]
mark rejoin ["C2 read-binary-type: " either error? t ["threw " mold t] [to string! t]]

; a PNG opens 89 50 4E 47 0D 0A 1A 0A
t: try [b: read/binary %/dev/shm/imp/probe-src.png  mold pick b 2]
mark rejoin ["C3 byte2(want 80): " either error? t ["threw " mold t] [to string! t]]

t: try [b: read/binary %/dev/shm/imp/probe-src.png  mold to integer! pick b 1]
mark rejoin ["C4 byte1-int(want 137): " either error? t ["threw " mold t] [to string! t]]

t: try [b: read/binary %/dev/shm/imp/probe-src.png  mold to integer! pick b 3]
mark rejoin ["C5 byte3-int(want 78): " either error? t ["threw " mold t] [to string! t]]

; ── 4. THE PERF QUESTION. 2000 picks spread across 554KB. if pick is
; O(1) this is instant; if it rescans it will crawl. ─────────────────
t: try [
    b: read/binary %/dev/shm/imp/probe-src.png
    n: length? b
    s: 0
    i: 1
    while [i <= 2000][
        s: s + to integer! pick b (n / 2000 * i) + 1
        i: i + 1
    ]
    mold s
]
mark rejoin ["D1 spread-2000-sum: " either error? t ["threw " mold t] [to string! t]]

; sequential, which is what a decoder actually does
t: try [
    b: read/binary %/dev/shm/imp/probe-src.png
    s: 0
    i: 1
    while [i <= 20000][
        s: s + to integer! pick b i
        i: i + 1
    ]
    mold s
]
mark rejoin ["D2 seq-20000-sum: " either error? t ["threw " mold t] [to string! t]]

; ── 5. the cheapest possible full sweep: 100k bytes, sequentially.
; a decoder must move every byte at least once, so this is the floor
; on what any Red implementation can cost. ───────────────────────────
t: try [
    b: read/binary %/dev/shm/imp/probe-src.png
    s: 0
    i: 1
    while [i <= 100000][
        s: s + to integer! pick b i
        i: i + 1
    ]
    mold s
]
mark rejoin ["E1 seq-100k-sum: " either error? t ["threw " mold t] [to string! t]]

; ── 6. can Red BUILD a binary from a block of integers? that is the
; other half: a decoder may need to emit compressed data, and
; write-binary is absent, so the write path matters too. ─────────────
t: try [h: #{01020304}  mold h]
mark rejoin ["F1 hex-lit: " either error? t ["threw"] [to string! t]]

t: try [b: read/binary %/dev/shm/imp/probe-src.png/part 4  mold b]
mark rejoin ["F2 read-binary-part: " either error? t ["threw " mold t] [to string! t]]

mark "DONE"
