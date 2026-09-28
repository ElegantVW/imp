Red [Title: "probe-read"]
; HOW DOES ONE GET BYTES OUT OF A FILE IN RED?
;
; `read %file.png` fails with id: 'invalid-utf8, arg1: #{89504E47} — the
; PNG signature, preserved by the error as a binary! literal. So the
; language has the type; `read` simply refuses to produce it.
;
; This is the wall between the imp and its own images, so it is worth
; being systematic rather than clever. The ways a file can become data:
;
;   1. read      — refused, measured
;   2. load      — a different code path, may not validate
;   3. a PORT    — open the file, read in chunks; ports are byte-oriented
;   4. compress  — a zip container holds arbitrary bytes inside text
;
:port may be the answer, because a port is a byte stream and the string
; validation may only live in `read`'s convenience path.

do %src/core.red

PROBE: %/dev/shm/imp/probe-read.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

; ── the spec, so we stop guessing at refinement names ────────────────
t: try [mold :read]
mark rejoin ["A1 read-spec: " either error? t ["threw"] [to string! t]]

; ── 1. load, which may not validate utf-8 the same way ───────────────
t: try [d: load %/dev/shm/imp/probe-src.png  "len=" mold length? d]
mark rejoin ["B1 load: " either error? t ["threw " mold t] [to string! t]]

; ── 2. a PORT. open, then read a fixed count of bytes. ───────────────
t: try [p: open %/dev/shm/imp/probe-src.png  "opened"]
mark rejoin ["C1 open: " either error? t ["threw " mold t] [to string! t]]

t: try [p: open %/dev/shm/imp/probe-src.png  d: read p 8  "len=" mold length? d]
mark rejoin ["C2 port-read-8: " either error? t ["threw " mold t] [to string! t]]

t: try [p: open %/dev/shm/imp/probe-src.png  d: read p 8  either binary? d ["is-binary"]["not-binary"]]
mark rejoin ["C3 port-type: " either error? t ["threw " mold t] [to string! t]]

; the bytes themselves. a PNG starts 89 50 4E 47 0D 0A 1A 0A
t: try [p: open %/dev/shm/imp/probe-src.png  d: read p 8  mold d]
mark rejoin ["C4 port-bytes: " either error? t ["threw " mold t] [to string! t]]

t: try [p: open %/dev/shm/imp/probe-src.png  d: read p 8  mold to integer! pick d 2]
mark rejoin ["C5 port-byte2(want 80): " either error? t ["threw " mold t] [to string! t]]

; can a port give us a BIG chunk, which is what a decoder needs?
t: try [p: open %/dev/shm/imp/probe-src.png  d: read p 100000  "len=" mold length? d]
mark rejoin ["C6 port-read-100k: " either error? t ["threw " mold t] [to string! t]]

t: try [p: open %/dev/shm/imp/probe-src.png  d: read p 100000  either binary? d ["is-binary"]["not-binary"]]
mark rejoin ["C7 port-100k-type: " either error? t ["threw " mold t] [to string! t]]

; close it, or we leak a handle per test
t: try [p: open %/dev/shm/imp/probe-src.png  close p  "closed"]
mark rejoin ["C8 close: " either error? t ["threw " mold t] [to string! t]]

; ── 3. an INFO port, which some builds use for raw bytes ─────────────
t: try [p: info %/dev/shm/imp/probe-src.png  "opened-info"]
mark rejoin ["D1 info-port: " either error? t ["threw " mold t] [to string! t]]

; ── 4. a zip container: compress holds arbitrary bytes in text form ──
t: try [b: compress %/dev/shm/imp/probe-src.png  "len=" mold length? b]
mark rejoin ["E1 compress: " either error? t ["threw " mold t] [to string! t]]

; ── 5. what does a read refinement called `lines` want? ─────────────
; and is there a documented way to ask for bytes? read the whole spec.
t: try [to string? none]
mark "F1 spacer"

mark "DONE"
