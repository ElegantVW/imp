Red [Title: "probe-census4"]
; CALL / WAIT — the correction.
;
; Census 3 returned PIDs, not exit codes, and every captured string came
; back 0 bytes. The spec is explicit: "return: 0 if success, -1 if
; error, or a process ID". `call` is ASYNCHRONOUS unless `/wait` is
; given. I read the bytes as a dead end; they were a race. That is the
; second time in this project I have blamed the substrate for my own
; timing, and the grimoire should say so.
;
; So: wait properly, and re-test everything that the race invalidated.

do %src/core.red

PROBE: %/dev/shm/imp/probe-census4.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

; ── 1. the wait refinement's own signature ───────────────────────────
t: try [mold :call/wait]
mark rejoin ["A1 call/wait: " either error? t ["ERROR"] [to string! t]]

; ── 2. THE ONE THAT MATTERS. stdout captured, after waiting. ─────────
cap: copy ""
t: try [call/wait/output out: cap "/bin/echo hello-from-red"]
mark rejoin ["B1 ok: " either error? t ["ERROR " mold t] ["returned"]]

t: try [length? cap]
mark rejoin ["B2 len: " either error? t ["ERROR"] [to string! t]]

t: try [to string! copy/part cap 30]
mark rejoin ["B3 text: " either error? t ["ERROR"] [to string! t]]

; ── 3. stderr — the error channel Red has never had ──────────────────
; If this works, hazard 10 is no longer "the substrate swallows it",
; because the program can now read the swallow.
errc: copy ""
t: try [call/wait/error err: errc "/bin/sh -c {echo boom >&2}"]
mark rejoin ["C1 ok: " either error? t ["ERROR " mold t] ["returned"]]

t: try [length? errc]
mark rejoin ["C2 len: " either error? t ["ERROR"] [to string! t]]

t: try [to string! copy/part errc 20]
mark rejoin ["C3 text: " either error? t ["ERROR"] [to string! t]]

; ── 4. the exit code. this is what a test suite is made of. ──────────
t: try [call/wait "/bin/true"]
mark rejoin ["D1 true: " either error? t ["ERROR " mold t] [to string! t]]

t: try [call/wait "/bin/false"]
mark rejoin ["D2 false: " either error? t ["ERROR " mold t] [to string! t]]

; a program that does not exist, waited on: -1, or an error?
t: try [call/wait "/definitely/not/here"]
mark rejoin ["D3 missing: " either error? t ["threw " mold t] [to string! t]]

; ── 5. a real program, real output ───────────────────────────────────
cap2: copy ""
t: try [call/wait/output out: cap2 "/usr/bin/uname -s"]
mark rejoin ["E1 uname-len: " either error? t ["ERROR " mold t] [to string! t]]

t: try [to string! copy/part cap2 20]
mark rejoin ["E2 uname-text: " either error? t ["ERROR"] [to string! t]]

; ── 6. output to a FILE rather than a string ────────────────────────
t: try [
    call/wait/output out: %/dev/shm/imp/p4-out.txt "/bin/echo to-a-file"
    either exists? %/dev/shm/imp/p4-out.txt ["wrote"]["no-file"]
]
mark rejoin ["F1 to-file: " either error? t ["ERROR " mold t] ["called"]]

t: try [
    f: read %/dev/shm/imp/p4-out.txt
    length? f
]
mark rejoin ["F2 file-len: " either error? t ["ERROR " mold t] [to string! t]]

; ── 7. bytes. `write-binary` does not exist, so make a binary file the
; only way this interpreter can: by asking a shell to write it. ──────
t: try [
    call/wait "/bin/sh -c {printf '\\001\\002\\003\\004' > /dev/shm/imp/p4.bin}"
    either exists? %/dev/shm/imp/p4.bin ["made"]["no-file"]
]
mark rejoin ["G1 make-binary: " either error? t ["ERROR " mold t] ["called"]]

t: try [b: read %/dev/shm/imp/p4.bin  length? b]
mark rejoin ["G2 len: " either error? t ["ERROR " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p4.bin  either binary? b ["is-binary"][type? :v :b]]
mark rejoin ["G3 is-binary: " either error? t ["ERROR " mold t] ["said-something"]]

; the real question: is byte N addressable, and is it an integer?
t: try [b: read %/dev/shm/imp/p4.bin  v: pick b 2  either integer? v [mold v]["not-int"]]
mark rejoin ["G4 pick1: " either error? t ["ERROR " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p4.bin  v: pick b 3  either integer? v [mold v]["not-int"]]
mark rejoin ["G5 pick2: " either error? t ["ERROR " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p4.bin  v: pick b 4  either integer? v [mold v]["not-int"]]
mark rejoin ["G6 pick3: " either error? t ["ERROR " mold t] [to string! t]]

; ── 8. shell, for the arguments a command actually needs ─────────────
; curl -d needs quoting that only a shell can do properly.
cap3: copy ""
t: try [
    call/wait/shell/output out: cap3 {echo one two three}
    length? cap3
]
mark rejoin ["H1 shell-out: " either error? t ["ERROR " mold t] [to string! t]]

t: try [to string! copy/part cap3 30]
mark rejoin ["H2 shell-text: " either error? t ["ERROR"] [to string! t]]

; ── 9. sleep: absent from the language, present on the machine ───────
t: try [call/wait "/bin/sleep 0"]
mark rejoin ["I1 sleep: " either error? t ["ERROR " mold t] [to string! t]]

mark "DONE"
