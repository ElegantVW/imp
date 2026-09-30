Red [Title: "probe-wait"]
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
say "word: " [(mold type? :wait)]
t0: to integer! now/time
r: try [wait 1]
t1: to integer! now/time
say "slept-secs: " [(t1 - t0)]
say "wait-err? " [(mold (error? r))]
say "DONE "
write %/dev/shm/imp/probe-wait-tmp.txt rejoin led
rename %/dev/shm/imp/probe-wait-tmp.txt %/dev/shm/imp/probe-wait-witness.txt
