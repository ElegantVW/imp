Red [Title: "probe-read-a"]
; BISECTED. the previous census died at load, which in this substrate
; looks exactly like silence. so: one question at a time, smallest first.
;
; Q1: what does the read spec actually offer?

do %src/core.red

PROBE: %/dev/shm/imp/probe-read-a.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]

mark "OPENED"

t: try [mold :read]
mark rejoin ["A1 read-spec: " either error? t ["threw"] [to string! t]]

t: try [mold :load]
mark rejoin ["A2 load-spec: " either error? t ["threw"] [to string! t]]

mark "DONE"
