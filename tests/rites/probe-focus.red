Red [Title: "probe-focus" Needs: View]
; can the window tell its own faces apart? the quit guard needs it:
; skip quit when the key came from the wish field.
do %src/tui.red
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
view/no-wait win
repeat i 5 [do-events/no-wait]
r1: try [same? wish-face wish-face]
say "same-self-err? " [(mold (error? r1))]
either error? r1 [
    say "same-missing: " ["YES - same? does not exist"]
][
    say "same-self: " [r1]
    r2: try [same? wish-face mode-face]
    say "same-other: " [r2]
]
say "E single-write: " ["SEALED - this file is the only product"]
unview/all
write %/dev/shm/imp/probe-focus-tmp.txt rejoin led
rename %/dev/shm/imp/probe-focus-tmp.txt %/dev/shm/imp/probe-focus-witness.txt
