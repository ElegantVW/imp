Red [Title: "probe-flamevals" Needs: View]
; tongues counts keep growing past the 6-cycle (14, 25, 39, 54...).
; a count nobody can explain is a broken instrument. cycle the real
; function 20 times and report what distinct values actually appear.
do %src/conjure-lib.red
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
cur: " "
seen: copy []
repeat i 20 [
    cur: con-next-flame cur
    either (find seen cur) [][append seen cur]
]
say "A distinct-in-20: " [(length? seen)]
say "   values: " [(mold seen)]
say "B cycle-stable: " [either ((length? seen) <= 6) ["SEALED"]["BROKEN, the cycle leaks"]]
; and the face path: does face text round-trip identically?
do %src/tui.red
view/no-wait win
repeat i 3 [do-events/no-wait]
flame-face/text: con-next-flame flame-face/text
reread: flame-face/text
say "C face-roundtrip: " [either ((reread = pick CON-FLAMES 1)) ["SEALED"]["BROKEN"]]
say "   read: " [(mold reread)]
; and the face path, 50 times, exactly like the on-time tick does it.
face-seen: copy []
repeat i 50 [
    flame-face/text: con-next-flame flame-face/text
    either (find face-seen flame-face/text) [][append face-seen flame-face/text]
]
say "D face-distinct-50: " [(length? face-seen)]
say "   face-values: " [(mold face-seen)]
say "E single-write: " ["SEALED - this file is the only product"]
unview/all
write %/dev/shm/imp/probe-flamevals-tmp.txt rejoin led
rename %/dev/shm/imp/probe-flamevals-tmp.txt %/dev/shm/imp/probe-flamevals-witness.txt
