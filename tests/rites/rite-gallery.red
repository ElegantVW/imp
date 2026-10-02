Red [Title: "rite-gallery" Needs: View]
; THE GALLERY, PROVED IN A SANDBOX. No GPU, no window needed beyond
; the header (rites run under red-view regardless): pure file ops in
; /dev/shm/imp/gal-test. Production passes the law's dirs; the shape
; is identical.
;
;   A  add files one painting (txt + json entry, id back)
;   B  hour order is creation hour, never insertion (seeded file)
;   C  past the cap the oldest is evicted, file and entry (BEAST: 3)
;   D  plain strips SGR and keeps glyphs
;   E  first-run marker lifecycle
;   F  a wish with quotes round-trips through the hand-built json

do %src/core.red
do %src/gallery.red

led: copy []
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

ART: "/dev/shm/imp/gal-test/art"
CACHE: "/dev/shm/imp/gal-test/cache"
call/wait/shell "rm -rf /dev/shm/imp/gal-test; mkdir -p /dev/shm/imp/gal-test/art /dev/shm/imp/gal-test/cache"

esc: to string! (to char! 27)
SAMPLE: rejoin [esc "[38;5;175mhello" esc "[0m " esc "[38;5;211mfox" esc "[0m"]

; ── A: one painting filed ──────────────────────────────────────────
id1: gal-add ART CACHE {say "hi" now} "Mignola" "SDXL" 512 SAMPLE
say "A add-id: " [either ((length? id1) > 0) ["SEALED"]["BROKEN, no id"]]
say "   id: " [id1]
t1: try [read (to file! (rejoin [ART "/" id1 ".txt"]))]
say "A2 txt-kept: " [either (error? t1) ["BROKEN, no txt"][either ((find t1 "hello") = none) ["BROKEN, wrong txt"]["SEALED"]]]

; ── B: hour order from a seeded ledger ─────────────────────────────
dq: to string! (to char! 34)
seed: rejoin [
    "[{" dq "id" dq ": " dq "a" dq ", " dq "wish" dq ": " dq "w-a" dq ", " dq "style" dq ": " dq "s" dq ", " dq "hand" dq ": " dq "h" dq ", " dq "size" dq ": 512, " dq "hour" dq ": 22}"
    ", {" dq "id" dq ": " dq "b" dq ", " dq "wish" dq ": " dq "w-b" dq ", " dq "style" dq ": " dq "s" dq ", " dq "hand" dq ": " dq "h" dq ", " dq "size" dq ": 512, " dq "hour" dq ": 3}"
    ", {" dq "id" dq ": " dq "c" dq ", " dq "wish" dq ": " dq "w-c" dq ", " dq "style" dq ": " dq "s" dq ", " dq "hand" dq ": " dq "h" dq ", " dq "size" dq ": 512, " dq "hour" dq ": 14}]"
]
write (to file! (rejoin [CACHE "/gallery.json"])) seed
listed: gal-list CACHE
o1: to string! (select (pick listed 1) 'id)
o2: to string! (select (pick listed 2) 'id)
o3: to string! (select (pick listed 3) 'id)
say "B hour-order: " [either (((o1 = "b") and (o2 = "c")) and (o3 = "a")) ["SEALED"]["BROKEN"]]
say "   order: " [(rejoin [o1 o2 o3])]

; ── F: quotes survive the hand-built json ───────────────────────────
; (before C wipes the ledger with its own adds)
fw: to string! (select (pick listed 1) 'wish)
say "F quote-roundtrip: " [either (fw = "w-b") ["SEALED"]["BROKEN"]]
fq: gal-add ART CACHE {say "hi" now} "Photo" "turbo" 256 "plain"
fl: gal-list CACHE
ff: ""
foreach e fl [
    if ((to string! (select e 'id)) = fq) [ff: to string! (select e 'wish)]
]
say "F2 quote-kept: " [either ((find ff {say "hi" now}) <> none) ["SEALED"]["BROKEN"]]
say "   wish: " [ff]

; ── C: the cap evicts the oldest, file and entry ────────────────────
; BEAST rebound sandbox-small: the real eviction path, five adds.
BEAST: 3
call/wait/shell "rm -rf /dev/shm/imp/gal-test/art /dev/shm/imp/gal-test/cache; mkdir -p /dev/shm/imp/gal-test/art /dev/shm/imp/gal-test/cache"
c1: gal-add ART CACHE "w-one" "s" "h" 128 "f1"
c2: gal-add ART CACHE "w-two" "s" "h" 128 "f2"
c3: gal-add ART CACHE "w-three" "s" "h" 128 "f3"
c4: gal-add ART CACHE "w-four" "s" "h" 128 "f4"
c5: gal-add ART CACHE "w-five" "s" "h" 128 "f5"
kept: gal-list CACHE
say "C cap-count: " [either ((length? kept) = 3) ["SEALED"]["BROKEN"]]
say "   kept: " [(length? kept)]
k1: to string! (select (pick kept 1) 'wish)
say "C2 oldest-first-out: " [either ((k1 = "w-three")) ["SEALED"]["BROKEN"]]
say "   head: " [k1]
buried1: exists? (to file! (rejoin [ART "/" c1 ".txt"]))
buried2: exists? (to file! (rejoin [ART "/" c2 ".txt"]))
say "C3 txt-buried: " [either buried1 ["BROKEN, corpse on disk"][either buried2 ["BROKEN, corpse on disk"]["SEALED"]]]
say "C4 txt-kept: " [either (exists? (to file! (rejoin [ART "/" c5 ".txt"]))) ["SEALED"]["BROKEN, newest missing"]]

; ── D: plain strips colour, keeps glyphs ────────────────────────────
pl: gal-plain SAMPLE
say "D plain: " [either (((find pl "hello") <> none) and ((find pl "fox") <> none)) ["SEALED"]["BROKEN"]]
say "   plain: " [pl]
noesc: true
i: 0
while [i < (length? pl)][
    i: i + 1
    if ((pick pl i) = (to char! 27)) [noesc: false]
]
say "D2 no-esc: " [either noesc ["SEALED"]["BROKEN, esc survived"]]

; ── E: first run happens once ───────────────────────────────────────
say "E first-fresh: " [either (gallery-first? CACHE) ["SEALED"]["BROKEN, marker preexists"]]
gallery-mark CACHE
say "E2 marked: " [either (gallery-first? CACHE) ["BROKEN, still fresh"]["SEALED"]]

say "F single-write: " ["SEALED - this file is the only product"]

write %/dev/shm/imp/gallery-tmp.txt rejoin led
rename %/dev/shm/imp/gallery-tmp.txt %/dev/shm/imp/gallery-witness.txt
