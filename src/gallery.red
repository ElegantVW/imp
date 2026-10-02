Red [Title: "gallery"]
; GALLERY — the paintings that stay.
;
; Every successful conjure files its frame under ~/pixie_art/<id>.txt
; and one JSON line of truth in the gallery cache. Past 666, the
; oldest is evicted (file and entry both — the covenant permits
; exactly this deletion and no other). Display order is ALWAYS hour
; of creation, never recency, never alphabetical (covenant §1); the
; file order stays oldest-first so eviction is trivial.
;
; A LIBRARY: no view, no quit, never throws. Every risky op is tried;
; the worst answer is "" or [], and a conjure must never die because
; its portrait could not be filed.
;
; PATHS ARE ARGUMENTS, not globals: art-dir and cache-dir arrive per
; call. Production passes the law's dirs; rites pass a sandbox. No
; init, no state, nothing to forget.
;
; Load order: needs BEAST (the cap, from core.red — numerology law:
; frames from the BEAST) and forge-div nowhere (the hour is computed
; inline instead, one line, no dependency). conjure-lib loads core
; before this file; the order is load-bearing the way %core.red is.

; ── json, hand-built. to-json stringifies word NAMES, not values
; (hazard 36), so quotes and backslashes are built as values.
gal-dq: to string! to char! 34
gal-bs: to string! to char! 92

gal-esc: func [s [string!] /local out i n cs][
    ; Single pass, character by character. The old spelling looped
    ; `while [(find o dq)]` with `replace` — but the replacement
    ; CONTAINS the needle, so find re-matched its own output forever.
    ; A quoted wish hung the whole rite with no witness. Measured.
    out: copy ""
    n: length? s
    i: 0
    while [i < n][
        i: i + 1
        cs: to string! (pick s i)
        if ((cs = gal-bs) or (cs = gal-dq)) [append out gal-bs]
        append out cs
    ]
    out
]

gal-flat: func [s [string!] /local o][
    o: copy s
    replace o "^/" " "
    while [(find o "  ")][o: replace o "  " " "]
    o
]

gal-kv: func [k [string!] v [string!]][
    rejoin [gal-dq k gal-dq ": " gal-dq gal-esc v gal-dq]
]

; ── the hour, in one line and no dependencies.
gal-hour: func [/local out][
    out: to integer! (divide (to integer! now/time) 3600)
    out
]

gal-id: func [/local d t ts pos frac out][
    ; Sub-second stamp: whole-second ids collided five-in-a-second
    ; (each add burying the last under one filename), and the
    ; exists?-bump then RECYCLED ids freed by eviction — c5 wore c1's
    ; name and its corpse check failed. now/precise carries the
    ; fraction (measured); the bump loop stays as backstop only.
    d: now/date
    t: now/precise/time
    ts: to string! t
    frac: "0"
    pos: find ts "."
    either (pos = none) [frac: "0"][frac: to string! (skip pos 1)]
    out: rejoin ["imp-" d "-" to string! (to integer! t) "-" frac]
    out
]

gal-entry-file: func [art [string!] id [string!] /local out][
    out: to file! (rejoin [art "/" id ".txt"])
    out
]

; ── read the ledger. Anything unreadable is an empty gallery, never
; an error: the past may be lost, the present still paints.
gal-read: func [cache [string!] /local out raw doc][
    out: copy []
    raw: try [read (to file! (rejoin [cache "/gallery.json"]))]
    either (error? raw) [out: copy []][
        doc: try [load/as (to file! (rejoin [cache "/gallery.json"])) 'json]
        either (error? doc) [out: copy []][
            either ((type? doc) = block!) [out: doc][out: copy []]
        ]
    ]
    out
]

gal-field: func [e key [string!] /local w v out][
    out: ""
    w: to word! key
    v: select e w
    either (v = none) [out: ""][out: to string! v]
    out
]
gal-num: func [e key [string!] /local w v out][
    out: "0"
    w: to word! key
    v: select e w
    either (v = none) [out: "0"][out: to string! v]
    out
]
gal-write-entry: func [e /local f-id f-wish f-style f-hand f-size f-hour out][
    ; BIND FIRST, then rejoin. A bare call inside rejoin's block
    ; flattens the argument list (hazard 46) — every value below is
    ; a bound word before the single rejoin runs.
    f-id: gal-field e "id"
    f-wish: gal-field e "wish"
    f-style: gal-field e "style"
    f-hand: gal-field e "hand"
    f-size: gal-num e "size"
    f-hour: gal-num e "hour"
    out: rejoin [
        "{" gal-kv "id" f-id
        ", " gal-kv "wish" f-wish
        ", " gal-kv "style" f-style
        ", " gal-kv "hand" f-hand
        ", " gal-dq "size" gal-dq ": " f-size
        ", " gal-dq "hour" gal-dq ": " f-hour
        "}"
    ]
    out
]

gal-write: func [cache [string!] entries [block!] /local out i n][
    out: copy "["
    n: length? entries
    i: 0
    while [i < n][
        i: i + 1
        if (i > 1) [append out ", "]
        append out gal-write-entry (pick entries i)
    ]
    append out "]"
    write (to file! (rejoin [cache "/gallery.json"])) out
    out
]

; ── file one painting. Returns the id, or "" when anything failed.
; Evicts oldest past the BEAST first (file AND entry — the one
; deletion the covenant permits).
gal-add: func [art [string!] cache [string!] wish [string!] style [string!] hand [string!] size [integer!] frame [string!] /local out entries id hour sfx gone gid gfile][
    out: ""
    entries: gal-read cache
    id: gal-now-id
    hour: gal-hour
    ; ids tick in whole seconds — five fast adds share one second and
    ; one filename, each burying the last. Bump a suffix while the
    ; file exists: the disk is the only memory the TUI is allowed.
    sfx: 0
    while [(exists? (gal-entry-file art (either (sfx = 0) [id][rejoin [id "-" sfx]])))][
        sfx: sfx + 1
    ]
    if (sfx > 0) [id: rejoin [id "-" sfx]]
    while [(length? entries) >= BEAST][
        gone: pick entries 1
        gid: try [to string! (select gone 'id)]
        either (error? gid) [][
            if ((length? gid) > 0) [
                gfile: try [gal-entry-file art gid]
                either (error? gfile) [][
                    try [delete gfile]
                ]
            ]
        ]
        remove entries
    ]
    either (error? (try [write (gal-entry-file art id) frame])) [
        out: ""
    ][
        append/only entries make map! reduce ['id id 'wish gal-flat wish 'style style 'hand hand 'size size 'hour hour]
        either (error? (try [gal-write cache entries])) [
            out: ""
        ][
            out: id
        ]
    ]
    out
]

gal-now-id: func [/local out][
    out: gal-id
    out
]

; ── list, sorted by creation HOUR (covenant §1). Oldest-first file
; order in, hour order out. Stable among equals.
gal-list: func [cache [string!] /local src out best bi i h bh][
    out: copy []
    src: gal-read cache
    while [(length? src) > 0][
        best: 1
        bh: 999
        i: 0
        while [i < (length? src)][
            i: i + 1
            h: try [to integer! (select (pick src i) 'hour)]
            either (error? h) [h: 999][]
            if (h = none) [h: 999]
            if (h < bh) [bh: h  best: i]
        ]
        append/only out (pick src best)
        remove at src best
    ]
    out
]

; ── strip SGR: ESC [ params letter. The saved frames keep their
; colour for the terminal; the TUI area shows the bare glyphs. No
; `and` anywhere: it is bitwise on this build, so the inner scan is
; a flag and a break. Comparisons are char-to-char: `pick` on a
; string! yields char!, and char! = string! is ALWAYS false
; (measured) — the old `"["` / `"m"` literals never matched, so
; params survived the strip.
gal-esq: to char! 27
gal-ob: to char! 91
gal-em: to char! 109
gal-plain: func [s [string!] /local out i n c done][
    out: copy ""
    n: length? s
    i: 0
    while [i < n][
        i: i + 1
        c: pick s i
        either (c = gal-esq) [
            i: i + 1
            if ((pick s i) = gal-ob) [
                ; skip to the closing m and STOP with i ON it: the
                ; outer loop's own i + 1 steps past. An extra +1 here
                ; ate the first glyph after every colour ("hello" lost
                ; its h — measured).
                done: false
                while [i <= n][
                    either ((pick s i) = gal-em) [done: true][i: i + 1]
                    if done [break]
                ]
            ]
        ][
            append out c
        ]
    ]
    out
]

; ── first run. No marker, no memory: the gallery performs something
; harmless and inexplicable exactly once (covenant §3), and only the
; grimoire explains it. The marker is a PLAIN filename — writing to a
; dotfile path hangs this build with no error and no witness (measured
; three ways: no-ext, dot+ext, both dead; plain names live). The
; prophecy is HERE and nowhere in-product.
GAL-PROPHECY: "0xDEFACED — the gallery remembers what was never painted"
gallery-first?: func [cache [string!] /local out][
    out: not (exists? (to file! (rejoin [cache "/greeted.txt"])))
    out
]
gallery-mark: func [cache [string!] /local f][
    ; Never `x: try [write ...]` — write returns NO value, so x stays
    ; unset and touching it raises "word has no value" into a dialog
    ; that polls forever. The file existing IS the truth.
    f: to file! (rejoin [cache "/greeted.txt"])
    try [write f "greeted"]
    exists? f
]
