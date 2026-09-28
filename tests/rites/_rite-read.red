Red [Title: "rite-read"]
do %src/core.red
; the narrowest possible question: can we read the wide vector at all?
raw: read %tests/vectors/input_5.txt
write %rite-read.txt rejoin [
    "len=" mold length? raw
    "head=" mold copy/part raw 2
]
