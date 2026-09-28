Red [Title: "rite-two"]
; THE LAST WORD IS SPOKEN FIRST. the means crawl after.
;
; Nine seals. Every comparison is BYTE-EXACT against the python
; oracle in tests/vectors/, including the wound it carries.
do %src/core.red

ledger: copy []
say: func [s [string!]][append ledger s  write %verdict.txt rejoin ledger]

esc: to char! 27

v: read %tests/vectors/input_1.txt
a: read %tests/vectors/input_3.txt
b: read %tests/vectors/input_4.txt
c: read %tests/vectors/input_5.txt

say rejoin ["beast " mold 6 * 111]

; 1 — the grid: three lines, every one exactly ten columns
g: reap v 'ascii 10 3
gl: sever g "^/"
ok1: (length? gl) = 3
foreach ln gl [unless (true-span ln) = 10 [ok1: false]]
say rejoin [either ok1 ["SEALED"] ["BROKEN"] " grid " mold (length? gl)]

; 2 — the C0 flay: no control beast survives
z: reap v 'ascii 8 1
ok2: true
if find z to char! 0 [ok2: false]
if find z to char! 7 [ok2: false]
say rejoin [either ok2 ["SEALED"] ["BROKEN"] " c0"]

; 3-5, 8 — byte fidelity, every style
e3: read %tests/vectors/expected_3.txt
e6: read %tests/vectors/expected_6.txt
e7: read %tests/vectors/expected_7.txt
e8: read %tests/vectors/expected_8.txt

say rejoin [either (reap a 'unicode 24 4) = e3 ["SEALED"] ["BROKEN"] " unicode"]
say rejoin [either (reap a 'ansi256 24 4) = e6 ["SEALED"] ["BROKEN"] " ansi256"]
say rejoin [either (reap a 'ansi16 24 4) = e8 ["SEALED"] ["BROKEN"] " ansi16"]
say rejoin [either (reap b 'truecolor 30 3) = e7 ["SEALED"] ["BROKEN"] " truecolor"]

; 4b — PLAIN SGR codes, which the vectors above never exercised. the
; ansi16 allowlist had "is one of" written as AND, which rejected
; everything including 1;31, and nothing noticed. docs/RED.md §16.1.
p9: read %tests/vectors/input_9.txt
e9: read %tests/vectors/expected_9.txt
say rejoin [either (reap p9 'ansi16 30 3) = e9 ["SEALED"] ["BROKEN"] " plain-ansi16"]

p10: read %tests/vectors/input_10.txt
e10: read %tests/vectors/expected_10.txt
say rejoin [either (reap p10 'unicode 30 3) = e10 ["SEALED"] ["BROKEN"] " plain-unicode"]

p11: read %tests/vectors/input_11.txt
e11: read %tests/vectors/expected_11.txt
say rejoin [either (reap p11 'ansi256 30 3) = e11 ["SEALED"] ["BROKEN"] " plain-ansi256"]

p12: read %tests/vectors/input_12.txt
e12: read %tests/vectors/expected_12.txt
say rejoin [either (reap p12 'truecolor 30 3) = e12 ["SEALED"] ["BROKEN"] " plain-truecolor"]

; 6 — the dragon's own tongue
tongue: rejoin [esc "[0mABC" esc "[0m"]
say rejoin [either (bare tongue) = "ABC" ["SEALED"] ["BROKEN"] " bare"]

; 7 — wide glyphs keep their two columns
e5: read %tests/vectors/expected_5.txt
say rejoin [either (reap c 'unicode 10 2) = e5 ["SEALED"] ["BROKEN"] " wide"]

say "DONE"
