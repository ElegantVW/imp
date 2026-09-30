Red [Title: "probe-getenv6"]
a: "HOME"
r: try [get-env a]
write %/dev/shm/imp/probe-getenv6-tmp.txt rejoin [(mold (either error? r [r] [r])) " var-now: " (mold a)]
rename %/dev/shm/imp/probe-getenv6-tmp.txt %/dev/shm/imp/probe-getenv6-witness.txt
