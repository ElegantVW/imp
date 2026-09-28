Red [Title: "probe-env"]
; two functions conjure.red uses and I never measured.
do %src/core.red
P: %/dev/shm/imp/probe-env.txt
led: copy []
mark: func [s [string!]][append led s  write P rejoin led]
mark "OPENED"
t: try [mold :getenv]
mark rejoin ["A1 getenv-word: " either error? t ["absent"] [to string! t]]
t: try [mold getenv "HOME"]
mark rejoin ["A2 getenv-call: " either error? t ["threw " mold t] [to string! t]]
t: try [mold :quit]
mark rejoin ["A3 quit-word: " either error? t ["absent"] [to string! t]]
t: try [mold :replace]
mark rejoin ["A4 replace-word: " either error? t ["absent"] [to string! t]]
t: try [mold replace "a'b" "'" "X"]
mark rejoin ["A5 replace-call: " either error? t ["threw " mold t] [to string! t]]
t: try [mold :load/as]
mark rejoin ["A6 load/as-word: " either error? t ["absent"] [to string! t]]
t: try [mold :image!]
mark rejoin ["A7 image!-word: " either error? t ["absent"] [to string! t]]
mark "DONE"
