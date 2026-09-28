Red [Title: "rite-span"]
do %src/core.red
; true-span on a WIDE char only — one glyph, no loop
one: true-span "樯"
two: true-span "樯漢"
asc: true-span "ab"
out: copy ""
foreach pair reduce [
    "span-one-wide" mold one
    "span-two-wide" mold two
    "span-ascii" mold asc
][append out rejoin [pair "^/"]]
write %rite-span.txt out
