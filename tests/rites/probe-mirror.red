Red [Title: "probe-mirror"]
; EXACTLY what render.red does, in order, with a witness after each step.
; the art itself is proven good by probe-reap2. so the fault is in the
; scaffolding, and this walks it.
do %src/core.red
say1: copy []
s: func [x [string!]][append say1 x  write %probe-mirror.txt rejoin say1]
s "OPENED"

do %src/frame.red
s "frame-loaded"

IMP-ART: %/dev/shm/imp/imp-art.txt
IMP-ASK-W: 40
IMP-ASK-H: 12
s "globals-set"

imp-art: try [read IMP-ART]
if error? imp-art [imp-art: copy ""]
s rejoin ["art-len " mold (length? imp-art)]

g1: reap imp-art 'unicode 40 12
s rejoin ["reap-literal " mold (length? g1)]

g2: reap imp-art 'unicode IMP-ASK-W IMP-ASK-H
s rejoin ["reap-globals " mold (length? g2)]

; and the ones the panel needs
s rejoin ["row " mold (length? row "hi" 60 PINK)]
s rejoin ["divider " mold (length? divider "Runes" 60)]
s rejoin ["top " mold (length? top-border "Imp" 60)]
s rejoin ["pad " mold (length? pad-to "hi" 56)]
s "DONE"
