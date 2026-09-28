Red [Title: "probe-census5a"]
; NO BACKSLASHES ANYWHERE. The previous census died at load, not at
; run, which in this substrate is indistinguishable from silence. Rather
; than bisect a file full of escaped quotes, remove the escapes: every
; question here can be asked without one.
;
; Ask:
;   1. does call/wait with a STRING return a real exit code?
;   2. does a BLOCK arg throw (proving the spec is enforced)?
;   3. does /shell redirection create a file we can read back?
;   4. does /output create a file?
;   5. can /output put a string into a Red string?
;   6. can Red read a file of raw bytes and address them individually?

do %src/core.red

PROBE: %/dev/shm/imp/probe-census5a.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

; 1 — string arg, real return value
t: try [call/wait "/bin/echo hi"]
mark rejoin ["A1 string-arg: " either error? t ["threw " mold t] ["rc=" mold t]]

; 2 — block arg, for contrast. spec says cmd [string! file!]
t: try [call/wait {/bin/echo hi}]
mark rejoin ["A2 block-arg: " either error? t ["threw: " mold t] ["rc=" mold t]]

; 3 — /shell does the redirect, no escaping needed
t: try [
    r: call/wait/shell "uname -s > /dev/shm/imp/p5.txt"
    either exists? %/dev/shm/imp/p5.txt ["file-exists"]["no-file"]
]
mark rejoin ["B1 shell-redirect: " either error? t ["threw " mold t] [to string! t]]

t: try [f: read %/dev/shm/imp/p5.txt  to string! f]
mark rejoin ["B2 read-back: " either error? t ["threw " mold t] [to string! t]]

; 4 — the /output refinement, to a file
t: try [
    r: call/wait/output out: %/dev/shm/imp/p5o.txt "/bin/echo hi"
    either exists? %/dev/shm/imp/p5o.txt ["file-exists"]["no-file"]
]
mark rejoin ["C1 output-to-file: " either error? t ["threw " mold t] [to string! t]]

; 5 — /output into a Red string
cap: copy ""
t: try [
    r: call/wait/output out: cap "/bin/echo hi"
    either length? cap ["len=" mold length? cap]["empty"]
]
mark rejoin ["D1 capture-string: " either error? t ["threw " mold t] [to string! t]]

; 6 — BYTES. no escapes: four NUL bytes from /dev/zero.
t: try [
    r: call/wait/shell "head -c 4 /dev/zero > /dev/shm/imp/p5.bin"
    either exists? %/dev/shm/imp/p5.bin ["file-exists"]["no-file"]
]
mark rejoin ["E1 make-binary: " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  length? b]
mark rejoin ["E2 bin-len(want 4): " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  either binary? b ["is-binary"]["not-binary"]]
mark rejoin ["E3 bin-type: " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  mold pick b 1]
mark rejoin ["E4 byte1(want 0): " either error? t ["threw " mold t] [to string! t]]

t: try [b: read %/dev/shm/imp/p5.bin  mold pick b 4]
mark rejoin ["E5 byte4(want 0): " either error? t ["threw " mold t] [to string! t]]

; 7 — the round trip a client library is made of, with no escaping:
; Red writes a file, the shell copies it, Red reads the copy.
t: try [
    write %/dev/shm/imp/p5-src.txt "round trip through the shell"
    r: call/wait/shell "cp /dev/shm/imp/p5-src.txt /dev/shm/imp/p5-dst.txt"
    f: read %/dev/shm/imp/p5-dst.txt
    to string! f
]
mark rejoin ["F1 round-trip: " either error? t ["threw " mold t] [to string! t]]

; 8 — and can a shell command's output be counted, which is all a
; polling loop ever wanted from `sleep`
t: try [r: call/wait "/bin/sleep 0"  mold r]
mark rejoin ["G1 sleep-rc: " either error? t ["threw " mold t] [to string! t]]

mark "DONE"
