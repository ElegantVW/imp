Red [Title: "probe-census5"]
; STRINGS, NOT BLOCKS. and print what you actually got.
;
; Census 4 looked like a wall: call/wait returns real exit codes (0 for
; /bin/true, 1 for /bin/false, 255 for a missing binary) but produced
; no output, no files, nothing.
;
; The mistake was mine, twice over. I passed {blocks} to `call`, whose
; spec says cmd [string! file!] — a block is a type error. And then I
; wrote test arms that printed a HARDCODED "called" instead of the value
; in `t`, so a thrown error and a success printed the same thing. Two
; separate ways of not looking at the result, and I read the silence as
; the substrate's fault.
;
; So: strings only, /shell so the shell does the redirect, and every arm
; prints mold of what it got.

do %src/core.red

PROBE: %/dev/shm/imp/probe-census5.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

; ── 1. the string form, and its return value, printed ────────────────
t: try [call/wait "/bin/echo hi"]
mark rejoin ["A1 plain-str: " either error? t ["ERROR " mold t] ["ok, rc=" mold t]]

; a block, for contrast — to prove what the type error looks like
t: try [call/wait {/bin/echo hi}]
mark rejoin ["A2 block-arg: " either error? t ["threw: " mold t] ["ok, rc=" mold t]]

; ── 2. /output to a FILE, string arg. does the file appear? ─────────
t: try [
    r: call/wait/output out: %/dev/shm/imp/p5-out.txt "/bin/echo hi-from-output"
    either exists? %/dev/shm/imp/p5-out.txt ["file-exists"]["no-file"]
]
mark rejoin ["B1 output-ref: " either error? t ["threw " mold t] [to string! t]]

; ── 3. /shell, letting the SHELL do the redirect. This is the shape
;      that works even if the /output refinement is inert. ────────────
t: try [
    r: call/wait/shell "uname -s > /dev/shm/imp/p5-shell.txt"
    either exists? %/dev/shm/imp/p5-shell.txt ["file-exists"]["no-file"]
]
mark rejoin ["C1 shell-redirect: " either error? t ["threw " mold t] [to string! t]]

t: try [f: read %/dev/shm/imp/p5-shell.txt  to string! f]
mark rejoin ["C2 shell-readback: " either error? t ["threw " mold t] [to string! t]]

; ── 4. /output into a Red STRING, string arg ────────────────────────
cap: copy ""
t: try [
    r: call/wait/output out: cap "/bin/echo hi-into-a-string"
    either length? cap ["len=" mold length? cap]["empty"]
]
mark rejoin ["D1 capture-str: " either error? t ["threw " mold t] [to string! t]]

; ── 5. BYTES. the question that decides where a png decoder lives. ──
; Make a file with an embedded NUL using the shell, because
; write-binary does not exist in this build.
t: try [
    r: call/wait/shell "printf 'A\\000B\\000' > /dev/shm/imp/p5.bin"
    either exists? %/dev/shm/imp/p5.bin ["file-exists"]["no-file"]
]
mark rejoin ["E1 make-bin: " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  length? b]
mark rejoin ["E2 bin-len: " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  either binary? b ["is-binary"][mold type? :v :b]]
mark rejoin ["E3 bin-type: " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  v: pick b 1  mold v]
mark rejoin ["E4 byte1(want 65): " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  v: pick b 2  mold v]
mark rejoin ["E5 byte2(want 0): " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  v: pick b 3  mold v]
mark rejoin ["E6 byte3(want 66): " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  v: pick b 4  mold v]
mark rejoin ["E7 byte4(want 0): " either error? t ["threw " mold t] [to string! t]]

; does `to integer!` accept a byte? that is what a decoder needs
t: try [b: read %/dev/shm/imp/p5.bin  mold to integer! pick b 1]
mark rejoin ["E8 to-integer: " either error? t ["threw " mold t] [to string! t]]

; ── 6. can Red WRITE a file with the bytes it computed? ──────────────
; A converter that can read pixels but not write them is half of one.
; write-binary is absent, so this is the real question.
t: try [
    r: call/wait/shell "echo written-by-shell > /dev/shm/imp/p5-w.txt"
    either exists? %/dev/shm/imp/p5-w.txt ["wrote"]["no-file"]
]
mark rejoin ["F1 shell-write: " either error? t ["threw " mold t] [to string! t]]

; and Red's own `write` of a STRING, which we already know works
t: try [
    write %/dev/shm/imp/p5-red.txt "written-by-red"
    either exists? %/dev/shm/imp/p5-red.txt ["wrote"]["no-file"]
]
mark rejoin ["F2 red-write: " either error? t ["threw " mold t] [to string! t]]

; ── 7. the full round trip a client library would need: ─────────────
;   ask a process for JSON, get a string, pick a field out of it.
t: try [
    call/wait/shell "printf '{\\\"choices\\\":[{\\\"x\\\":42}]}' > /dev/shm/imp/p5.json"
    j: read %/dev/shm/imp/p5.json
    length? j
]
mark rejoin ["G1 roundtrip-len: " either error? t ["threw " mold t] [to string! t]]

t: try [j: read %/dev/shm/imp/p5.json  to string! copy/part j 20]
mark rejoin ["G2 roundtrip-text: " either error? t ["threw " mold t] [to string! t]]

mark "DONE"
