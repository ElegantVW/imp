Red [Title: "probe-load"]
; DOES conjure.red LOAD, OR DOES IT DIE AT A TOP-LEVEL STATEMENT?
;
; Both look identical from outside: red-view sits on an error dialog,
; the log is never written, and the launcher waits out its deadline. So
; bracket the call: a marker before, a marker after. If only the first
; appears, the file did not load.
write %/dev/shm/imp/loadtest.txt "MARKER-BEFORE"
do %src/conjure.red
write %/dev/shm/imp/loadtest.txt "MARKER-BEFORE conjure-ran MARKER-AFTER"
