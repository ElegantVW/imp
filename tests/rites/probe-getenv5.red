Red [Title: "probe-getenv5"]
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
say "home: " [get-env "HOME"]
say "DONE "
write %/dev/shm/imp/probe-getenv5-tmp.txt rejoin led
rename %/dev/shm/imp/probe-getenv5-tmp.txt %/dev/shm/imp/probe-getenv5-witness.txt
