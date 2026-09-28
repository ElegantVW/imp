Red [Title: "probe-census2"]
; WHAT CAN THIS VESSEL ACTUALLY DO?
;
; The question that decides whether the imp can ever be pure Red: can a
; Red program reach the outside world without a C bridge? We are not
; asking the manual, because the manual has been wrong seven times and
; every one of those was an assumption. We are asking the interpreter,
; and writing the answer down where it can be read.
;
; Each test is isolated in its own `try` and flushed to the witness
; immediately. A death mid-census is still testimony.

do %src/core.red

PROBE: %/dev/shm/imp/probe-census2.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

; ── 1. does `call` exist, and does it actually run something? ──────────
; This is the whole ballgame. If a Red program can execute a command
; and collect what it printed, then the imp needs no FFI, no socket
; binding, and no C bridge: it can ask another program to do the
; fetching and read the answer off disk.
t1: try [mold :call]
mark rejoin ["1a call-word: " either error? t1 ["ERROR"] [to string! t1]]

t1: try [do make block! []]
mark rejoin ["1b call-runs: " either error? t1 ["ERROR"] ["yes"]]

; the real test: a command that writes a file we can read back
t1: try [call "/bin/sh -c {printf CALLED-OK > /dev/shm/imp/probe-call.txt}"]
mark rejoin ["1c call-exec: " either error? t1 ["ERROR " mold t1] [
    either exists? %/dev/shm/imp/probe-call.txt ["wrote-file"] ["silent-no-file"]
]]

; and whether its OUTPUT can be captured rather than only redirected
t1: try [call "/bin/sh -c {printf STDOUT-TEST}"]
mark rejoin ["1d call-stdout: " either error? t1 ["ERROR " mold t1] ["returned-something"]]

; ── 2. can Red load a foreign shared object? ───────────────────────────
; `load/library` on a .so would give us zlib and libc without the FFI
; dialect, which this interpreter does not have (see below).
t1: try [mold words-of :load]
mark rejoin ["2a load-words: " either error? t1 ["ERROR"] [to string! t1]]

; ── 3. the FFI dialect: present or not? ───────────────────────────────
; modules/ in the source tree holds only `view`. Prove it either way.
t1: try [mold ffi]
mark rejoin ["3a ffi-dialect: " either error? t1 ["ABSENT (" mold t1 ")"] [to string! t1]]

t1: try [mold :ffi]
mark rejoin ["3b ffi-word: " either error? t1 ["ERROR"] [to string! t1]]

; ── 4. what did the build enable? ─────────────────────────────────────
; system/options is the closest thing Red has to a build manifest, and
; it sometimes names features that no other query reveals.
t1: try [mold system/options]
mark rejoin ["4a system-options: " either error? t1 ["ERROR " mold t1] [to string! t1]]

; ── 5. the other confirmed absences, re-measured in one place ─────────
; If these have quietly appeared, the grimoire is stale and that itself
; is worth knowing.
t1: try [mold :sleep]
mark rejoin ["5a sleep-word: " either error? t1 ["ERROR"] [to string! t1]]

t1: try [mold :syscall]
mark rejoin ["5b syscall-word: " either error? t1 ["ERROR"] [to string! t1]]

; ── 6. can Red read a BINARY file and address single bytes? ───────────
; This gates where the image resampler lives. If bytes are addressable,
; the whole pixel path can live in Red; if not, something upstream has
; to be C after all.
; build a known 4-byte file: 01 02 03 04
t1: try [write-binary %/dev/shm/imp/probe-bytes.bin to binary! [1 2 3 4]]
mark rejoin ["6a write-binary: " either error? t1 ["ERROR " mold t1] ["ok"]]

t1: try [
    b: read %/dev/shm/imp/probe-bytes.bin
    mold length? b
]
mark rejoin ["6b binary-length: " either error? t1 ["ERROR " mold t1] [to string! t1]]

t1: try [
    b: read %/dev/shm/imp/probe-bytes.bin
    v: pick b 2
    either integer? v [mold v]["not-integer"]
]
mark rejoin ["6c binary-pick: " either error? t1 ["ERROR " mold t1] [to string! t1]]

; ── 7. can Red write bytes back out? ──────────────────────────────────
; A converter that can read pixels but not write them is half a
; converter.
t1: try [
    write-binary %/dev/shm/imp/probe-bytes2.bin to binary! [9 8 7 6]
    either exists? %/dev/shm/imp/probe-bytes2.bin ["wrote"]["no-file"]
]
mark rejoin ["7a write-binary-2: " either error? t1 ["ERROR " mold t1] ["called"]]

; ── 8. stdout: the absence that made bridge.c necessary ───────────────
t1: try [mold :halt]
mark rejoin ["8a halt-word: " either error? t1 ["ERROR"] [to string! t1]]

mark "DONE"
