Red [Title: "probe-getenv7"]
r: try [do [get-env "HOME"]]
write %/dev/shm/imp/probe-getenv7-tmp.txt mold either error? r [r] [r]
rename %/dev/shm/imp/probe-getenv7-tmp.txt %/dev/shm/imp/probe-getenv7-witness.txt
