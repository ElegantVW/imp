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

; ── the mouth thinks out loud; the hand must never hear it ─────────
t1: con-think-strip "<think>hmm, a car</think>a lighthouse in a storm"
t2: con-think-strip "all thinking <think>draft one</think> middle <think>draft two</think> end"
t3: con-think-strip "<think>endless"
t4: con-think-strip "a plain sentence"
say "F think: " [either (((t1 = "a lighthouse in a storm") and (t2 = "all thinking  middle  end")) and ((t3 = "") and (t4 = "a plain sentence"))) ["SEALED"]["BROKEN"]]
say "   stripped: " [(rejoin [t1 " | " t2 " | " t3 " | " t4])]

; ── a silence has a deadline, and the deadline is pure ──────────────
CON-T0: 0
say "G timeout: " [either ((con-timed-out? 667) and (not (con-timed-out? 100))) ["SEALED"]["BROKEN"]]

say "E single-write: " ["SEALED - this file is the only product"]

write %/dev/shm/imp/conjure-lib-tmp.txt rejoin led
rename %/dev/shm/imp/conjure-lib-tmp.txt %/dev/shm/imp/conjure-lib-witness.txt
