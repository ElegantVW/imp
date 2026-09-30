Red [Title: "probe-wait3" Needs: View]
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
win: layout [title "w" tk: text 60 "0"]
view/no-wait win
repeat i 2 [do-events/no-wait]
t0: to integer! now/time
r: try [wait 1]
t1: to integer! now/time
say "slept-secs: " [(t1 - t0)]
say "wait-err? " [(mold (error? r))]
unview/all
say "DONE "
write %/dev/shm/imp/probe-wait3-tmp.txt rejoin led
rename %/dev/shm/imp/probe-wait3-tmp.txt %/dev/shm/imp/probe-wait3-witness.txt
