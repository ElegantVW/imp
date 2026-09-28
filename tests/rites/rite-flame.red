Red [Title: "rite-flame" Needs: View]
; A RATE FACET KEEPS TICKING WHILE A SHELL COMMAND RUNS WITHOUT /WAIT.
;
; The TUI has to animate a flame while sd-cli thinks (~4s). `call/wait`
; freezes the VID event loop, so the freeze looks like a hang. Hazard 23:
; `call` without `/wait` returns a PID and the command runs in the
; background. This rite asserts the three things that claim stands on:
;
;   A  the event loop LIVES while the command is out — ticks accumulate
;   B  a face's text CHANGES across those ticks (the flame can cycle)
;   C  the background command actually FINISHES — a sentinel file appears
;
; The command is `sleep 1`, not sd-cli. We are proving the door, not the
; hand. If A is BROKEN the window froze; if C is BROKEN the spawn never
; ran; if B is BROKEN we have a loop that does not paint.
;
; ── STATE LIVES IN FACES ─────────────────────────────────────────────
; Assignments inside a VID actor do not reach the enclosing global
; (rite-view, measured). The tick count and the flame glyph are faces.
; The actor is allowed to SET those, and to spawn, and to close. Every
; claim is computed AFTER `view` returns, from what the actor left.
;
; ── THE RATE FACET GOES ON THE SAME LINE AS ITS WIDGET ───────────────
; Wrapped onto its own line, the actor silently never attached. Same
; trap as rite-view. `rate 0:0:0.06` is six hundredths, because the
; covenant counts in sixes.

led: copy []
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

call/wait/shell "rm -f /dev/shm/imp/flame-rc.txt"

win: layout [
    title "imp - rite-flame"
    backdrop 18.18.24
    below
    tk: text 60 "0" font [color: 0.255.0 size: 12]
    fl: text 80 "a" font [color: 220.90.40 size: 14] rate 0:0:0.06 on-time [
        k: to integer! tk/text
        tk/text: form k + 1
        either (fl/text = "a") [fl/text: "b"][fl/text: "a"]
        either (k = 0) [
            call/shell "(sleep 1); echo $? > /dev/shm/imp/flame-rc.txt"
        ][
            either exists? %/dev/shm/imp/flame-rc.txt [
                either (k >= 6) [
                    face/rate: none
                    unview/only face/parent
                ][
                ]
            ][
            ]
        ]
    ]
]

view win

n: to integer! tk/text
say "A loop-lived: " [either (n >= 6) ["SEALED"]["BROKEN, the loop froze or never ticked"]]
say "   ticks: " [n]
say "B flame-moved: " [either ((fl/text = "a") or (fl/text = "b")) ["SEALED"]["BROKEN"]]
say "   flame: " [fl/text]
either exists? %/dev/shm/imp/flame-rc.txt [
    raw: read %/dev/shm/imp/flame-rc.txt
    say "C async-call: " [either find raw "0" ["SEALED"]["BROKEN, the sentinel was not zero"]]
    say "   rc-file: " [raw]
][
    say "C async-call: " ["BROKEN, no sentinel — call/shell did not run"]
]
say "D single-write: " ["SEALED - this file is the only product"]

write %/dev/shm/imp/flame-tmp.txt rejoin led
rename %/dev/shm/imp/flame-tmp.txt %/dev/shm/imp/flame-witness.txt
