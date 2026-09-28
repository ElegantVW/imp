Red [Title: "probe-row"]
do %src/core.red
do %src/frame.red
ledger: copy []
say: func [s [string!]][append ledger s  write %probe-row.txt rejoin ledger]

say "OPENED"

; a literal, exactly as build-frame calls the comment
r1: row "a literal comment" 60 ROSE
say rejoin ["literal len " mold (length? r1)]

; a variable holding a string
v: rejoin ["> " "a wish"]
say rejoin ["var-type " mold type? :v]
r2: row v 60 SILVER
say rejoin ["variable len " mold (length? r2)]

; a variable declared in the same line as the call
r3: row rejoin ["a" "b"] 60 MUTE
say rejoin ["inline-rejoin len " mold (length? r3)]

; does the THIRD argument matter?
r4: row "x" 60 MUTE
say rejoin ["muted len " mold (length? r4)]

; a param named note, passed positionally
probe-note: func [note [string!] /local s][s: row note 60 MUTE  s]
r5: probe-note "the inkwell is dry"
say rejoin ["note-param len " mold (length? r5)]

; a param named wish-line
probe-wish: func [wish-line [string!] /local s][s: row wish-line 60 SILVER  s]
r6: probe-wish "> a wish"
say rejoin ["wish-param len " mold (length? r6)]

; two params like build-frame has
probe-two: func [wish-line [string!] note [string!] /local s][
    s: rejoin [row wish-line 60 SILVER "^/" row note 60 MUTE]
    s
]
r7: probe-two "> a wish" "the inkwell is dry"
say rejoin ["two-param len " mold (length? r7)]

say "DONE"
