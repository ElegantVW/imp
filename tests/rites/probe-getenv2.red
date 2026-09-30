Red [Title: "probe-getenv2"]
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
say "home: " [get-env "HOME"]
say "missing: " [(mold (get-env "IMP_NO_SUCH_VAR_XYZ"))]
say "DONE "
write %/dev/shm/imp/probe-getenv2-tmp.txt rejoin led
rename %/dev/shm/imp/probe-getenv2-tmp.txt %/dev/shm/imp/probe-getenv2-witness.txt
