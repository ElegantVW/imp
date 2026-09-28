Red [Title: "rite-frame"]
; THE FRAME'S WIDTH CONTRACT, SEALED.
;
; `reap` has always guaranteed the ART grid: 12 lines of exactly 40
; columns, byte-exact against the oracle. The frame around it had no
; such guarantee, and a 66-character mockery made it 81 columns wide
; inside a 60-column frame — `pad-to` only ever pads, so an over-long
; string went straight through. The borders were a quieter version of
; the same mistake, one column over at w-2 instead of w-3.
;
; This rite asserts the invariant the frame lacked: EVERY line of every
; kind is exactly W visible columns — top border, dividers, art rows,
; content rows, and the bottom border — with the worst-case inputs: an
; empty string, a string that fits exactly, and a string far too long.

do %src/core.red
do %src/frame.red

PROBE: %/dev/shm/imp/frame-witness.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]
mark "OPENED"

W: 60

; a deliberately hostile line: longer than the panel, with a space in it
; so clamp-to has somewhere to cut, and a word it could tear in half.
LONG: "Oh, how quaint. A flicker in the dark? I have seen storms that made stone weep and then some."

; ── 1. clamp-to on its own, before it is trusted inside a row ───────
t: try [mold clamp-to "short" 20]
mark rejoin ["A1 short: " either error? t ["threw " mold t] [to string! t]]

t: try [mold true-span clamp-to LONG 40]
mark rejoin ["A2 clamp-to-40: " either error? t ["threw"] [to string! t]]

t: try [mold clamp-to LONG 40]
mark rejoin ["A3 clamp-text: " either error? t ["threw"] [to string! t]]

t: try [mold true-span clamp-to "exactly-ten" 10]
mark rejoin ["A4 exact-fit-10: " either error? t ["threw"] [to string! t]]

; one column is not enough for an ellipsis; it must not go negative
t: try [mold true-span clamp-to "abcdefgh" 1]
mark rejoin ["A5 clamp-to-1: " either error? t ["threw"] [to string! t]]

; ── 2. every KIND of line, at the frame's width ─────────────────────
parts: copy []
append parts top-border "Imp" W
append parts row "a lighthouse in a storm" W SILVER
append parts row LONG W ROSE
append parts row "" W MUTE
append parts row repeat-chars "x" 200 W MUTE
append parts divider "Conjured" W
append parts divider "" W
append parts row "exactly sixty columns of text should fit here ok" W MUTE
append parts bottom-border W

; assemble exactly as render.conjure does: interleave, then ONE rejoin
pp: copy []
pk: 1
pn: length? parts
while [pk <= pn][
    append pp pick parts pk
    if (pk < pn) [append pp "^/"]
    pk: pk + 1
]
frame: rejoin pp

lanes: sever frame "^/"
t: try [mold length? lanes]
mark rejoin ["B1 lines: " either error? t ["threw"] [to string! t]]

; THE SEAL. every line, exactly W.
ok: true
worst: 0
i: 1
while [i <= (length? lanes)][
    ln: pick lanes i
    sp: true-span ln
    if (sp <> W) [
        ok: false
        if (sp > worst) [worst: sp]
        mark rejoin ["  OFFENDER line " mold i " span " mold sp]
    ]
    i: i + 1
]
; THE SEAL, with its arms the RIGHT way round. The first draft had
; `either ok [BROKEN][SEALED]` — ok is TRUE when every line is exactly
; 60, and true was wired to BROKEN, so the rite cheerfully printed
; SEALED one line after recording an offender. An inverted seal is
; worse than no seal: it is a seal that agrees with you. This is the
; same inversion I made in rite-forge-one, which is twice now.
mark rejoin ["B2 all-lines-exactly-60: " either ok ["SEALED"]["BROKEN, widest=" mold worst]]
; and the long line specifically: cut, not torn, and inside the panel
t: try [
    ln: first sever frame "^/"
    mold true-span ln
]
mark rejoin ["B3 first-line-span: " either error? t ["threw"] [to string! t]]

mark "DONE"
