Red [Title: "probe-getenv8"]
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
r: copy get-env "HOME"
say "home: " [r]
say "len: " [(length? r)]
say "DONE "
write %/dev/shm/imp/probe-getenv8-tmp.txt rejoin led
rename %/dev/shm/imp/probe-getenv8-tmp.txt %/dev/shm/imp/probe-getenv8-witness.txt
