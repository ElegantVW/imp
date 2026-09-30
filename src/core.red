Red [Title: "core"]
; THE CORE — vessels only. The rites are spoken elsewhere.

BEAST: 666
LEDGER-P: 0
LEDGER-F: 0

; RED HAS NO `global` FUNCTION. the ledgers are module-level globals, so
; plain assignment is the correct and only way to reach them. (docs/RED.md
; §6.7 — the old `global LEDGER-P: ...` lines were dead code.)
hold-rite: func [name [string!] won [logic!] witness [string!] /local mark][
    mark: either won ["SEALED"]["BROKEN"]
    either won [LEDGER-P: LEDGER-P + 1][LEDGER-F: LEDGER-F + 1]
    rejoin [mark " " name " :: " witness]
]

; weigh-cell, compiler-clean edition. The old spelling was one
; `either any [...]` over seventeen `all` ranges; the Red/System
; backend chokes on boolean trees that size (measured: internal error
; `[ptr/1: ptr/1 + size]`). Seventeen sequential guarded assignments
; over DISJOINT ranges mean exactly the same OR. Uses nothing but
; one-armed `if` and comparisons — every construct already proven to
; compile. Re-sealed by rite-two after the change, as law requires.
weigh-cell: func [ch [char!] /local n w][
    n: to integer! ch
    w: 1
    if (n >= 4352) [if (n <= 4447) [w: 2]]
    if (n >= 9001) [if (n <= 9002) [w: 2]]
    if (n >= 11904) [if (n <= 12351) [w: 2]]
    if (n >= 12352) [if (n <= 13311) [w: 2]]
    if (n >= 13312) [if (n <= 19903) [w: 2]]
    if (n >= 19968) [if (n <= 42191) [w: 2]]
    if (n >= 43360) [if (n <= 43391) [w: 2]]
    if (n >= 44032) [if (n <= 55203) [w: 2]]
    if (n >= 63744) [if (n <= 64255) [w: 2]]
    if (n >= 65040) [if (n <= 65049) [w: 2]]
    if (n >= 65072) [if (n <= 65135) [w: 2]]
    if (n >= 65280) [if (n <= 65376) [w: 2]]
    if (n >= 65504) [if (n <= 65510) [w: 2]]
    if (n >= 127744) [if (n <= 128591) [w: 2]]
    if (n >= 128640) [if (n <= 128767) [w: 2]]
    if (n >= 129024) [if (n <= 129535) [w: 2]]
    if (n >= 131072) [if (n <= 262141) [w: 2]]
    w
]

FALLEN: [
    "─" "-" "━" "-" "┄" "-" "┅" "-" "┈" "-" "┉" "-" "╌" "-" "╍" "-"
    "│" "|" "┃" "|" "┆" "|" "┇" "|" "┊" "|" "┋" "|" "╎" "|" "╏" "|"
    "┌" "+" "┐" "+" "└" "+" "┘" "+" "├" "+" "┤" "+" "┬" "+" "┴" "+" "┼" "+"
    "╭" "+" "╮" "+" "╰" "+" "╯" "+"
    "✦" "*" "✧" "*" "★" "*" "☆" "*" "·" "." "•" "." "…" "."
]

unmake: func [ch [char!] /local found i n last-pair][
    found: " "
    i: 1
    n: length? FALLEN
    last-pair: subtract n 1
    while [i <= last-pair][
        if (pick FALLEN i) = ch [found: pick FALLEN i + 1 break]
        i: i + 2
    ]
    found
]

; proven by rite-naked: index? and copy/part speak CHARS, not bytes.
; length? on a char! is an abomination and an error. the serpent is simple.
sever: func [s [string!] delim [string!] /local out i j n f][
    out: copy []
    i: 1
    n: length? s
    forever [
        if i > n [append out "" break]
        f: find at s i delim
        either f = none [
            append out copy at s i
            break
        ][
            j: index? f
            append out copy/part at s i (subtract j i)
            i: add j (length? delim)
        ]
    ]
    out
]

; find the 'm that ends an escape begun at start index i
; NOTE: an earlier comment here claimed that `return` nested inside a loop
; does not leave the function in this build -- it leaves the loop and the
; demon spins forever. THAT IS FALSE, and it was measured: `return` out of
; a loop returns from the function, in every loop form, and the Red
; sources themselves use it ~95 times. See docs/RED-IDIOMS.md section 0.
;
; The no-`return` rule in this core is therefore STYLE, not necessity. It
; is kept because the core is sealed and byte-exact against an oracle, and
; because carrying an answer out in a variable is legible. But do not read
; this as a language constraint -- do not refuse to write correct code
; because of it.
m-end: func [s [string!] i [integer!] /local j n found][
    n: length? s
    j: i
    found: none
    while [j <= n][
        j: j + 1
        if j > n [break]
        if (pick s j) = #"m" [found: j  break]
    ]
    found
]

well-formed?: func [seq [string!] /local body cut c ok][
    ok: false
    if all [(length? seq) >= 3 (last seq) = #"m"][
        cut: subtract (length? seq) 3
        body: copy/part at seq 3 cut
        either any [body = "" body = "0"][
            ok: true
        ][
            ok: true
            forever [
                c: pick body 1
                unless any [c = #";" all [c >= #"0" c <= #"9"]][ok: false break]
                if (length? body) = 1 [break]
                body: copy at body 2
            ]
        ]
    ]
    ok
]

; no `return` anywhere, and no two-block `if` — `either` only. a
; two-block `if` evaluates BOTH sides, which is how the dragon eats
; style verdicts alive.
beast-allows?: func [seq [string!] style [word!] /local body cut parts i n p v ok mode][
    ok: false
    cut: subtract (length? seq) 3
    body: copy/part at seq 3 cut

    either any [body = "" body = "0"][
        ok: true
    ][
        either style = 'ascii [
            ok: false
        ][
            either style = 'unicode [
                ok: true
            ][
                parts: sever body ";"
                n: length? parts
                i: 1
                mode: style
                ok: true
                either mode = 'ansi16 [
                    while [all [ok (i <= n)]][
                        p: pick parts i
                        v: attempt [to integer! p]
                        ; "is one of" is an OR. written as
                        ; `all [v = 0 v = 1 v = 2 v = 22]` it means "v equals
                        ; ALL FOUR", which is never true, and this silently
                        ; rejected every ansi16 code — including `1;31`,
                        ; which the python original admits. docs/RED.md §16.1
                        ; recorded the anomaly; this was its cause.
                        unless any [
                            v = 0
                            v = 1
                            v = 2
                            v = 22
                            all [v >= 30 v <= 37]
                            all [v >= 90 v <= 97]
                            all [v >= 39 v <= 49]
                        ][ok: false break]
                        i: i + 1
                    ]
                ][
                    either mode = 'ansi256 [
                        while [all [ok (i <= n)]][
                            p: pick parts i
                            either p = "38" [
                                unless all [(i + 2) <= n (pick parts i + 1) = "5"][ok: false break]
                                ; THE WOUND, kept on purpose: the python
                                ; original `continue`s here, which advances
                                ; the index by ONE and lands on the operand
                                ; — which is not 0 or 1, so the sequence is
                                ; rejected and the flesh is stripped.
                                ; advancing by 3 would be too correct.
                                i: i + 1
                            ][
                                v: attempt [to integer! p]
                                unless any [v = 0 v = 1][ok: false break]
                                i: i + 1
                            ]
                        ]
                    ][
                        while [all [ok (i <= n)]][
                            p: pick parts i
                            either p = "38" [
                                unless all [(i + 4) <= n (pick parts i + 1) = "2"][ok: false break]
                                i: i + 1
                            ][
                                v: attempt [to integer! p]
                                unless any [v = 0 v = 1][ok: false break]
                                i: i + 1
                            ]
                        ]
                    ]
                ]
            ]
        ]
    ]
    ok
]

flay-line: func [raw [string!] style [word!] width [integer!] /local out vis i n ch j seq w][
    out: copy ""
    vis: 0
    i: 1
    n: length? raw
    while [i <= n][
        ch: pick raw i
        either ch = #"^(1B)" [
            j: m-end raw i
            if j = none [break]
            ; copy/part must take the WHOLE escape, 'm included, or
            ; well-formed? rightly rejects it and the flesh is stripped
            seq: copy/part at raw i (add (subtract j i) 1)
            if all [well-formed? seq beast-allows? seq style][append out seq]
            i: j + 1
        ][
            either any [ch < #" " ch = #"^(7F)"] [i: i + 1][
                w: weigh-cell ch
                if (vis + w) > width [break]
                append out either all [style = 'ascii (to integer! ch) > 127][unmake ch][ch]
                vis: vis + w
                i: i + 1
            ]
        ]
    ]
    append out "^(1B)[0m"
    if vis < width [append/dup out " " (subtract width vis)]
    out
]

bare: func [s [string!] /local out i n ch j][
    out: copy ""
    i: 1
    n: length? s
    while [i <= n][
        ch: pick s i
        either ch = #"^(1B)" [
            j: m-end s i
            either j = none [i: add n 1][i: j + 1]
        ][
            append out ch
            i: i + 1
        ]
    ]
    out
]

true-span: func [ln [string!] /local out i n ch span][
    out: bare ln
    n: length? out
    span: 0
    i: 1
    while [i <= n][
        ch: pick out i
        span: add span (weigh-cell ch)
        i: i + 1
    ]
    span
]

reap: func [text [string!] style [word!] width [integer!] height [integer!] /local lines out blank i raw n][
    lines: sever text "^/"
    out: copy []
    foreach raw lines [append out flay-line raw style width]
    if (length? out) > height [out: copy/part out height]
    blank: copy ""
    append/dup blank " " width
    while [(length? out) < height][append out blank]
    raw: copy ""
    n: length? out
    i: 0
    foreach ln out [
        i: i + 1
        append raw ln
        if i < n [append raw "^/"]
    ]
    raw
]
