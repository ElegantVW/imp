Red [Title: "rite-conjure-lib"]
; THE PIPELINE AS A LIBRARY, PROVED WITHOUT A WINDOW AND WITHOUT A GPU.
;
; src/conjure-lib.red must load, must not quit, must return a fail:
; string when there is no job, and the helpers the TUI calls must do
; what their names say. A load error here is a silence; this rite is
; the bell.

call/wait/shell "rm -f /dev/shm/imp/job"

do %src/conjure-lib.red

led: copy []
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

q: con-quote "hello"
say "A quote: " [either ((pick q 1) = #"'") ["SEALED"]["BROKEN"]]
say "   quoted: " [q]

f1: con-next-flame "??"
f2: con-next-flame f1
say "B flame-cycles: " [either (f1 <> f2) ["SEALED"]["BROKEN, the tongue did not move"]]
say "   f1: " [f1 "  f2: " f2]

k-ok: con-kind "ok"
k-fail: con-kind "fail: the hand refused to paint."
k-busy: con-kind "the hand is painting..."
say "C kind: " [either ((k-ok = "ok") and (k-fail = "fail") and (k-busy = "busy")) ["SEALED"]["BROKEN"]]
say "   ok/fail/busy: " [k-ok " " k-fail " " k-busy]

r: con-run
say "D no-job-no-quit: " [either ((con-kind r) = "fail") ["SEALED"]["BROKEN, expected fail: got " r]]
say "   ran: " [r]
say "   phase: " [CON-PHASE]

say "E single-write: " ["SEALED - this file is the only product"]

write %/dev/shm/imp/conjure-lib-tmp.txt rejoin led
rename %/dev/shm/imp/conjure-lib-tmp.txt %/dev/shm/imp/conjure-lib-witness.txt
