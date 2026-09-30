Red [Title: "probe-getenv4"]
r: try [get-env "IMP_NO_SUCH_VAR_XYZ"]
write %/dev/shm/imp/probe-getenv4-tmp.txt mold either error? r [r] [r]
rename %/dev/shm/imp/probe-getenv4-tmp.txt %/dev/shm/imp/probe-getenv4-witness.txt
