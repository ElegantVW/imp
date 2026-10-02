Red [Title: "rite-model-matrix" Needs: View]
; EVERY HAND, TWO STEP COUNTS, ONE WINDOW. Turbo/SDXL/Pony at preset
; and away from it, enhance off (no mouth variance — the hand and the
; steps are the suspects). Each combo reports pass/fail WITH the fail
; string, so "sometimes breaks" becomes named modes, not lore.
;
;   M1  turbo  4sp (preset)
;   M2  turbo  8sp
;   M3  SDXL  20sp (preset)
;   M4  SDXL  10sp
;   M5  Pony  25sp (preset)
;   M6  Pony  15sp
;
; Full GPU pipeline, six conjures. Slow by construction; RITED_WAIT
; 1800. Witness written once, at the end.
write %/dev/shm/imp/imp-env.txt rejoin [
    "sd=/home/evenweaker/.local/lib/sd/sd-cli" "^/"
    "sd-lib=/home/evenweaker/.local/lib/sd" "^/"
    "model=/home/evenweaker/.local/share/pixie/models/sd_turbo-f16.gguf" "^/"
    "sdxl=/home/evenweaker/.local/share/pixie/models/sdxl-base-1.0-Q8_0.gguf" "^/"
    "pony=/home/evenweaker/.local/share/pixie/models/pony-v6-Q8_0.gguf" "^/"
    "w=512" "^/"
    "h=512" "^/"
    "steps=4" "^/"
    "cfg=1" "^/"
    "llm=imp" "^/"
    "llm-url=http://127.0.0.1:8082/v1/chat/completions" "^/"
    "art=/dev/shm/imp/matrix-art" "^/"
    "cache=/dev/shm/imp/matrix-cache" "^/"
]
call/wait/shell "mkdir -p /dev/shm/imp/matrix-art /dev/shm/imp/matrix-cache"

do %src/tui.red

led: copy []
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

view/no-wait win
repeat i 5 [do-events/no-wait]

; one combo: hand HI at PCT percent (= PCT/2 steps), enhance off.
; returns "yes" or the reason it never landed.
run-combo: func [w [string!] hi [integer!] pct [integer!] /local busy-seen stable done n][
    busy-seen: "no"
    stable: 0
    done: "no"
    wish-face/text: w
    enh-btn/text: "enhance: off"
    style-dd/selected: 1
    hand-dd/selected: hi
    step-slider/data: to percent! (pct / 100)
    sync-face/text: rejoin [(form hi) ":" (form pct)]
    con-press
    repeat k 5 [do-events/no-wait]
    if ((busy-face/text) = "1") [busy-seen: "yes"]
    n: 0
    while [(n < 900)][
        n: n + 1
        call/wait/shell "sleep 0.5"
        repeat k 5 [do-events/no-wait]
        if ((busy-face/text) = "0") [
            stable: stable + 1
            if (stable >= 2) [done: "yes" break]
        ]
    ]
    either (busy-seen = "yes") [done]["no press never started"]
]

combo: func [tag [string!] w [string!] hi [integer!] pct [integer!] want [string!] /local r st fr fok][
    r: run-combo w hi pct
    st: status-face/text
    fr: try [read %/dev/shm/imp/frame]
    fok: "no-frame"
    either (error? fr) [fok: "no-frame"][
        either ((find fr want) <> none) [fok: "steps-ok"][fok: "steps-missing"]
    ]
    either ((r = "yes") and ((find st "filed as") <> none)) [
        say (rejoin [tag " pass: "]) [either (fok = "steps-ok") ["SEALED"]["BROKEN"]]
    ][
        say (rejoin [tag " pass: "]) ["BROKEN"]
    ]
    say "   status: " [(rejoin [r " | " st " | " fok])]
]

combo "M1 turbo-4: " "matrix turbo fox at dawn" 1 8 "4sp"
combo "M2 turbo-8: " "matrix turbo owl at dusk" 1 16 "8sp"
combo "M3 sdxl-20: " "matrix sdxl lighthouse in fog" 2 40 "20sp"
combo "M4 sdxl-10: " "matrix sdxl harbor at night" 2 20 "10sp"
combo "M5 pony-25: " "matrix pony dragon over hills" 3 50 "25sp"
combo "M6 pony-15: " "matrix pony castle in snow" 3 30 "15sp"

say "Z single-write: " ["SEALED - this file is the only product"]

unview/all

write %/dev/shm/imp/model-matrix-tmp.txt rejoin led
rename %/dev/shm/imp/model-matrix-tmp.txt %/dev/shm/imp/model-matrix-witness.txt
