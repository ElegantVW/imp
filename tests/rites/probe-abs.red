Red [Title: "probe-abs"]
; XI, part two. no try, no set, no error?. just look.
write %probe-abs.txt "OPENED^/"

write %/dev/shm/imp/abs-probe.txt "absolute paths work"

r: read %/dev/shm/imp/abs-probe.txt
write %probe-abs.txt "READ-OK^/"

w: %/dev/shm/imp/abs2.tmp
write w "staged"
write %probe-abs.txt "STAGED-OK^/"

n: rename w %/dev/shm/imp/abs2.txt
write %probe-abs.txt "RENAMED-OK^/"
