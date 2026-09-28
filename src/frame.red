Red [Title: "frame"]
; THE FRAME — the imp's body of language.
;
; LEAF FUNCTIONS ONLY. The frame is assembled at top level, in
; render.red, and that is not a style choice: it is a measurement.
;
; In this build, series accumulation behaves differently inside a
; function body than at top level. The identical sequence —
;     panel: copy []   append panel x   rejoin panel "^/"
; — yields a correct 674-character frame at top level, and a
; one-character corpse inside `build-frame`. The leaf functions below
; are all measured correct when called (row 52/53, sever exact, borders
; 110/75), so they stay functions; the loop that assembles them does not.
;
; Every construct here is one the substrate has already proven.
; no `parse`. no `return`. no two-block `if`. no `join`. no `none?`.
; `rejoin` takes ONE argument. `^(...)` does not work inside a literal.

MARK: "✦"

esc: to char! 27
PINK: rejoin [esc "[38;5;175m"]
ROSE: rejoin [esc "[38;5;211m"]
DIM: rejoin [esc "[38;5;95m"]
MUTE: rejoin [esc "[38;5;60m"]
SILVER: rejoin [esc "[38;5;250m"]
BOLD: rejoin [esc "[1m"]
OFF: rejoin [esc "[0m"]

; a line of `n` copies of `c`
repeat-chars: func [c [string!] n [integer!] /local s][
    s: copy ""
    append/dup s c n
    s
]

; pad a string to `n` columns with spaces
; TWO RULES, BOTH LEARNED THE HARD WAY:
; 1. No operator precedence (docs/RED.md §2) — parenthesise comparisons.
; 2. `if` RETURNS none! when its condition is false. so a function must
;    never END on a conditional. assign inside the branch, return the
;    variable unconditionally. ending on `if (d <= 0) [copy s]` made
;    every row that needed padding render as the literal "none".
pad-to: func [s [string!] n [integer!] /local w d out][
    w: true-span s
    d: subtract n w
    out: copy s
    if (d > 0) [out: rejoin [s repeat-chars " " d]]
    out
]

; ── fit a string into n columns, cutting at a WORD boundary ─────────
; The frame's width is a CONTRACT, not a hope. It used to be a hope: a
; 66-character mockery went into a 56-column row, `pad-to` only ever
; pads, and the frame came out 81 columns wide inside a 60-column
; frame. Measured, not assumed.
;
; So over-long content is cut at the last space that fits and marked with
; an ellipsis. A line that was too long then reads as deliberately
; short, instead of as a word torn in half.
;
; IT DOES NOT END ON A CONDITIONAL. The first draft did — the
; `either (cut < 1) [cut: 1][…]` arm returned none! for n=1, which is
; hazard 15 wearing a disguise for the second time in this file, and
; `pad-to` swallows it into a literal "none" in the row. Assign inside
; the branch, return the variable.
clamp-to: func [s [string!] n [integer!] /local cut head i lastsp out][
    out: copy s
    if (true-span s) > n [
        cut: subtract n 1                      ; one column for the ellipsis
        if (cut < 1) [cut: 1]
        head: copy/part s cut
        lastsp: 0
        i: 1
        while [i <= (length? head)][
            if (pick head i) = " " [lastsp: i]
            i: i + 1
        ]
        either (lastsp > 0) [
            out: rejoin [copy/part head subtract lastsp 1 "…"]
        ][
            ; no space to cut on — cut hard rather than overflow
            out: rejoin [head "…"]
        ]
    ]
    out
]

top-border: func [name [string!] w [integer!] /local label inner fill][
    label: rejoin [" " MARK " " name " " MARK " "]
    ; this border is two glyphs, the label, the fill and one glyph:
    ; 3 + label + fill must equal w. at w-2 every border came out one
    ; column too wide (measured: 61 in a 60-column frame).
    inner: subtract w 3
    fill: subtract inner (true-span label)
    if (fill < 1) [fill: 1]
    rejoin [PINK "╭─" OFF BOLD ROSE label OFF PINK repeat-chars "─" fill "╮" OFF]
]

divider: func [name [string!] w [integer!] /local label inner fill][
    ; THE TWO BRANCHES NEED DIFFERENT WIDTHS, and that is not a typo.
    ;   labelled: two glyphs + label + fill + one glyph -> inner = w-3
    ;   empty:    one glyph  + inner + one glyph        -> inner = w-2
    ; using w-3 for both left the empty divider at 59 columns in a
    ; 60-column frame, which the rite caught immediately.
    either name = "" [
        rejoin [PINK repeat-chars "├" 1 repeat-chars "─" subtract w 2 "┤" OFF]
    ][
        label: rejoin [" " MARK " " name " "]
        inner: subtract w 3
        fill: subtract inner (true-span label)
        if (fill < 1) [fill: 1]
        rejoin [PINK "├─" OFF BOLD ROSE label OFF PINK repeat-chars "─" fill "┤" OFF]
    ]
]

bottom-border: func [w [integer!] /local inner][
    inner: subtract w 2
    rejoin [PINK repeat-chars "╰" 1 repeat-chars "─" inner "╯" OFF]
]

; one framed content row. The width is enforced HERE, at the point of
; rendering, for the same reason reap enforces the art grid: a contract
; checked where it is produced is a contract; one trusted from upstream
; is a hope. and this one was a hope, and it broke.
row: func [content [string!] w [integer!] colour [string!] /local body][
    body: subtract w 4
    rejoin [PINK "│" OFF " " colour pad-to clamp-to content body body OFF " " PINK "│" OFF]
]
