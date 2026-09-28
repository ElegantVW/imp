Red [Title: "probe-slider" Needs: View]
; is slider real, what does data hold, does programmatic set stick?
led: copy []
say: func [k [string!] b [block!]][append led rejoin [k (mold (do b))]]
win: layout [
    title "imp - probe-slider"
    sl: slider 150 data 8%
]
view/no-wait win
repeat i 5 [do-events/no-wait]
say "A face: " [either sl ["SEALED"]["BROKEN"]]
say "   type: " [(mold sl/type)]
say "B data: " [(mold sl/data)]
set-res: try [sl/data: 40%]
say "C set-err? " [(mold (error? set-res))]
repeat i 3 [do-events/no-wait]
say "   data-now: " [(mold sl/data)]
r1: try [to integer! sl/data]
say "E pct-to-int: " [either ((r1 = 40)) ["SEALED"]["BROKEN"]]
r2: try [to percent! 60]
say "F int-to-pct: " [either error? r2 ["BROKEN, no percent construction"][(mold r2)]]
either error? r2 [][
    sl/data: r2
    repeat i 2 [do-events/no-wait]
    say "   roundtrip: " [(mold sl/data)]
]
sl/data: 40%
repeat i 2 [do-events/no-wait]
g1: try [to integer! (sl/data * 100)]
say "G pct100-to-int: " [either ((g1 = 40)) ["SEALED"]["BROKEN"]]
h-set: try [to percent! 0.6]
either error? h-set [
    say "H dec-to-pct: BROKEN, no construction"
][
    sl/data: h-set
    repeat i 2 [do-events/no-wait]
    say "H dec-to-pct: " [either ((mold sl/data) = "60%") ["SEALED"]["BROKEN"]]
    say "   got: " [(mold sl/data)]
]
say "D single-write: " ["SEALED - this file is the only product"]
unview/all
write %/dev/shm/imp/probe-slider-tmp.txt rejoin led
rename %/dev/shm/imp/probe-slider-tmp.txt %/dev/shm/imp/probe-slider-witness.txt
