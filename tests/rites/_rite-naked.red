Red [Title: "rite-naked"]
; NAKED RITE: bare questions, correctly asked this time.
; length? refuses char! — as it should. wide-glyph byte length comes
; from the string, not the char.

s: "樯漢"
w: "x"

q1: to integer! pick s 1
q2: length? s
q3: index? find s "漢"
q4: mold pick s 2
q5: 6 * 111
q6: mold at s 1
q7: length? at s 1
q8: mold copy/part s 1 1

out: copy ""
foreach pair reduce [
    "code-point" mold q1
    "len-string" mold q2
    "find-index" mold q3
    "pick2" q4
    "core-exists" mold q5
    "at1" q6
    "len-at1" mold q7
    "part-1-1" q8
][append out rejoin [pair "^/"]]
write %rite-naked.txt out
