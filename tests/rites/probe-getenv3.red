Red [Title: "probe-getenv3"]
r: try [get-env "HOME"]
write %/dev/shm/imp/probe-getenv3-tmp.txt mold either error? r [r] [r]
rename %/dev/shm/imp/probe-getenv3-tmp.txt %/dev/shm/imp/probe-getenv3-witness.txt
