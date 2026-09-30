Red [Title: "probe-getenv9"]
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
r: copy get-env "DISPLAY"
say "display: " [r]
say "DONE "
write %/dev/shm/imp/probe-getenv9-tmp.txt rejoin led
rename %/dev/shm/imp/probe-getenv9-tmp.txt %/dev/shm/imp/probe-getenv9-witness.txt
