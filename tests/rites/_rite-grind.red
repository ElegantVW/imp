Red [Title: "rite-grind"]
do %src/core.red
; GRIND RITE: which vessel is slow? time each in isolation.
s: read %tests/vectors/input_1.txt

t0: now/precise
a: sever s "^/"
t1: now/precise
n: length? a
foreach ln a [weigh-cell #"x"]
t2: now/precise
b: true-span "abcd"
t3: now/precise
c: reap s 'ascii 10 3
t4: now/precise
d: reap s 'ascii 10 3
t5: now/precise

out: copy ""
foreach pair reduce [
    "lines" mold n
    "sever-sec" mold to integer! round (t1 - t0)
    "weigh-sec" mold to integer! round (t2 - t1)
    "span-sec" mold to integer! round (t3 - t2)
    "reap1-sec" mold to integer! round (t4 - t3)
    "reap2-sec" mold to integer! round (t5 - t4)
    "reap-steady" mold (c = d)
    "reap-head" mold copy/part c 12
][append out rejoin [pair "^/"]]
write %rite-grind.txt out
