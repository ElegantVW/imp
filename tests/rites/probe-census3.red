Red [Title: "probe-census3"]
; THE I/O QUESTION, ANSWERED.
;
; Census 2 found `call` and then died on a junk placeholder of mine.
; What matters now is not whether `call` exists — it does, and its spec
; promises /output, /error and an integer return — but whether it WORKS
; in a GUI red-view, because `/console` is annotated "CLI console only
; at present" and that annotation is the one thing that could make this
; a mirage.
;
; If any single test below writes a file or captures a string, the
; bridge is redundant and the imp can be pure Red.

do %src/core.red

PROBE: %/dev/shm/imp/probe-census3.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]
say-it: does []

mark "OPENED"

; ── the refinement signatures, which teach us the calling syntax ──────
t: try [mold :call/output]
mark rejoin ["A1 call/output-spec: " either error? t ["ERROR"] [to string! t]]

t: try [mold :call/error]
mark rejoin ["A2 call/error-spec: " either error? t ["ERROR"] [to string! t]]

; ── THE TEST. stdout captured into a Red string. ──────────────────────
; This is the whole design in one line: if a Red string can hold another
; program's output, then the imp does not need a socket, does not need
; FFI, and does not need C. It needs `call`.
cap: copy ""
t: try [call/output out: cap "/bin/echo hello-from-red"]
mark rejoin ["B1 call-out-str: " either error? t ["ERROR " mold t] ["returned-ok"]]

t: try [length? cap]
mark rejoin ["B2 captured-len: " either error? t ["ERROR"] [to string! t]]

t: try [copy/part cap 15]
mark rejoin ["B3 captured-text: " either error? t ["ERROR"] [to string! t]]

; ── stderr captured too: this is the missing error channel ───────────
; Without this, a rite that dies tells us nothing — hazard 10, the most
; expensive one in the grimoire.
errc: copy ""
t: try [call/error err: errc "/bin/sh -c {echo to-stderr >&2}"]
mark rejoin ["C1 call-err-str: " either error? t ["ERROR " mold t] ["returned-ok"]]

t: try [length? errc]
mark rejoin ["C2 err-captured-len: " either error? t ["ERROR"] [to string! t]]

; ── the exit code, which is what a test suite is made of ─────────────
t: try [call "/bin/true"]
mark rejoin ["D1 rc-true: " either error? t ["ERROR " mold t] [to string! t]]

t: try [call "/bin/false"]
mark rejoin ["D2 rc-false: " either error? t ["ERROR " mold t] [to string! t]]

; ── a real program with real output, not just /bin/echo ──────────────
; `uname` proves this is process execution and not a special case.
cap2: copy ""
t: try [call/output out: cap2 "/usr/bin/uname -s"]
mark rejoin ["E1 uname-len: " either error? t ["ERROR " mold t] [to string! t]]

t: try [copy/part cap2 12]
mark rejoin ["E2 uname-text: " either error? t ["ERROR"] [to string! t]]

; ── does a program that does not exist return -1 rather than dying? ──
; If `call` throws on a missing binary we must wrap every use in try.
t: try [call "/definitely/not/here/at/all"]
mark rejoin ["F1 missing-prog: " either error? t ["threw " mold t] ["returned-ok"]]

; ── sleep, the absence that cost us a polling loop ───────────────────
; If `call "sleep 1"` works, `sleep` is not missing, it is merely
; absent from the language and present on the machine. Worth knowing
; which of those we are actually dealing with.
t: try [call "/bin/sleep 0"]
mark rejoin ["G1 sleep-via-call: " either error? t ["ERROR " mold t] ["ok"]]

; ── binary bytes: can Red address and write them? ────────────────────
; This decides where an image decoder lives. If bytes are first-class,
; a pure-Red inflate is a library project rather than an impossibility.
t: try [write-binary %/dev/shm/imp/p3.bin to binary! [1 2 3 4]]
mark rejoin ["H1 write-binary: " either error? t ["ERROR " mold t] ["ok"]]

t: try [b: read %/dev/shm/imp/p3.bin  length? b]
mark rejoin ["H2 binary-len: " either error? t ["ERROR " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p3.bin  v: pick b 2  either integer? v [mold v]["not-int"]]
mark rejoin ["H3 binary-pick: " either error? t ["ERROR " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p3.bin  v: pick b 3  either integer? v [mold v]["not-int"]]
mark rejoin ["H4 binary-pick3: " either error? t ["ERROR " mold t] [to string! t]]

; ── the confirmed absences, in one place, freshly measured ───────────
t: try [mold :load/library]
mark rejoin ["I1 load-library: " either error? t ["ERROR " mold t] [to string! t]]

t: try [mold :sleep]
mark rejoin ["I2 sleep-word: " either error? t ["ERROR"] [to string! t]]

t: try [mold ffi]
mark rejoin ["I3 ffi: " either error? t ["ABSENT"] [to string! t]]

t: try [mold system/options]
mark rejoin ["I4 options: " either error? t ["ERROR"] [to string! t]]

mark "DONE"
