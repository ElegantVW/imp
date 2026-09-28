Red [Title: "rite-wide"]
do %src/core.red
; WIDE RITE: the CJK vector, step by step, with a witness at each stage.
raw: read %tests/vectors/input_5.txt
exp: read %tests/vectors/expected_5.txt

out: copy []
append out rejoin ["raw-head=" mold copy/part raw 8]
append out rejoin ["raw-span=" mold true-span raw]
append out rejoin ["exp-span=" mold true-span exp]
o: reap raw 'unicode 10 2
append out rejoin ["out-span=" mold true-span o]
append out rejoin ["eq=" mold (o = exp)]
append out rejoin ["out-len=" mold (length? o) " exp-len=" mold (length? exp)]
; where do they part company?
i: 0
mism: copy []
n: either (length? o) < (length? exp) [(length? o)][(length? exp)]
while [i < n][
    unless (pick o i + 1) = (pick exp i + 1) [
        append mism rejoin ["at " mold (i + 1) " got " mold (pick o i + 1) " want " mold (pick exp i + 1)]
        break
    ]
    i: i + 1
]
append out rejoin ["mismatch=" mold mism]
write %rite-wide.txt rejoin out "^/"
