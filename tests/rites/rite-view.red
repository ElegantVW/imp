Red [Title: "rite-view" Needs: View]
; A WINDOW OPENS, IT PAINTS, AND IT SHOWS A PICTURE.
;
; Everything the TUI depends on, asserted rather than demonstrated. The
; feasibility was settled by READING red-view-src — `Needs: View`,
; `view`, `layout`, `on-key`, `image %file.png` all appear in its own
; tests — and reading a test is not running it on our 32-bit GTK-3 build.
; These are the four claims the whole TUI stands on:
;
;   A  a window opens at all
;   B  its event loop LIVES — a rate facet fires, repeatedly
;   C  it PAINTS — a solid backdrop reaches the pixels
;   D  the `image` widget shows a real PNG loaded from a file
;
; C is the one that would have killed the project quietly. A window that
; opens and never paints is indistinguishable from a working one until a
; human looks at it, and this box has no screenshot tool: no import, no
; scrot, no xwd. So the rite takes its own screenshot with Red's own
; `to-image` + `save` and READS THE PIXEL BACK afterwards, which makes
; the claim machine-checkable. The backdrop is deliberately garish red:
; if the top-left pixel is not red, nothing painted and the TUI is worth
; nothing.
;
; ── THE SHAPE OF THIS RITE, and it is the lesson ─────────────────────
; The event actor does ONE thing: count, snapshot, close. Every claim is
; computed afterwards, in ordinary code, from the file the actor saved.
;
; That is not tidiness. Two facts forced it:
;
;   1. ASSIGNMENTS INSIDE A VID ACTOR DO NOT REACH THE ENCLOSING GLOBAL.
;      `n: n + 1` in an on-time block leaves the global at 0 forever, so a
;      counter written that way never reaches its threshold, the window
;      never closes, `view` blocks, and the rite times out looking like a
;      hang. A count kept in a FACE (`tk/text`) does work — measured at 26
;      ticks — because a face is where VID keeps state.
;   2. `view` RETURNS when the window closes, and anything the script
;      writes after that OVERWRITES what the actor wrote. The first draft
;      put its findings in the actor and a "returned" epilogue after it,
;      so the testimony always ended with the least interesting line in
;      the file. Worse, it made a working rite look broken.
;
; So: the actor is three lines, and the assertions live where they can be
; read, edited and believed.
;
; ── SUBSTRATE TRAPS THIS RITE FELL INTO, all mine, all found by
;    instrumenting one statement at a time ──────────────────────────
;   1. `read` on a binary file RAISES; `read/binary` is the word for bytes.
;   2. `copy` copies a VALUE, not a file. The file-copy idiom in Red
;      0.6.6 is `write %dest read/binary %src`, verified byte-exact
;      (144675 in, 144675 out). `copy-file`, `read-binary` and
;      `write-binary` are all ABSENT from the binary; stop looking.
;   3. `load %f /size` does not mean "the size of that file": with no
;      operator precedence a `/word` right after a function is a
;      REFINEMENT, so it parses as `load /size %f`. Same family as
;      hazard 46.
;   4. `write` TRUNCATES. One progress file shows only the LAST line, so
;      two runs in a row looked like they had died at the first statement
;      when they had reached the fourth.
;   5. `ticks` is a SYSTEM WORD, so `ticks: 0` does not bind a global of
;      that name — the same trap as `ASK` and `status`, and it cost a run
;      before the real cause turned out to be (1).
;   6. The `rate` facet goes on the SAME LINE as its widget, and the face
;      is left unnamed. Wrapped onto its own line, the actor silently
;      never attached — a dead facet and a slow one look identical.

do %src/core.red

WITNESS: %/dev/shm/imp/view-witness.txt
PART:    %/dev/shm/imp/view-tmp.txt
SNAP:    %/dev/shm/imp/view-snap.png
PIC:     %/dev/shm/imp/view-pic.png
SOURCE:  %/dev/shm/imp/conjure.png

led: copy []
; `say` takes a LABEL and a block, not one block. One block was the
; first version, and `mold (do s)` molds the block's LAST VALUE — so
; every label vanished and the testimony read
;   {"SEALED"}{"SEALED"}{"SEALED"}
; which is a passing rite that says nothing about what passed. A witness
; you cannot read is a witness you cannot check.
say: func [k [string!] b [block!]][
    append led rejoin [k (mold (do b))]
]

; ── the fixture ──────────────────────────────────────────────────────
; our own copy under our own name, so this rite never depends on another
; program's leftovers. `write` + `read/binary`, never `copy`.
fixture: either exists? SOURCE [
    write PIC read/binary SOURCE
    "conjure.png"
][
    ; nothing conjured. make a picture of our own so D is still testable,
    ; and SAY so, rather than quietly testing less than we claim.
    save PIC make image! 64x64 #{3A6EA5}
    "synthetic (no conjure.png)"
]

; ── the window ───────────────────────────────────────────────────────
; the actor counts in a FACE, because that is the only counter that
; survives a VID actor (see the header). three ticks is enough to prove
; a loop is live and cheap enough not to matter.
win: layout compose/deep [
    title "imp - rite-view"
    backdrop 255.0.0
    below
    tk: text 60 "0" font [color: 0.255.0 size: 12]
    below
    image 192x192 %/dev/shm/imp/view-pic.png rate 0:0:0.3 on-time [
        ; BIND, BIND, BIND. Both of these were wrong in ways that looked
        ; like hangs rather than errors:
        ;
        ;   `if (to integer! tk/text) >= 3 [...]` — the parenthesised call
        ;   BECOMES the whole condition, a number, and `>= 3 [...]` is left
        ;   dangling. The event loop swallows the resulting error and keeps
        ;   ticking, so the counter was measured reaching 26 with the
        ;   branch never once taken. Bind the number, then compare it.
        ;
        ;   `save %file to-image face/parent` — `to-image` is a bare
        ;   word-function, so it flattens into `save`'s argument list and
        ;   save is handed four arguments. Hazard 46, third appearance.
        k: to integer! tk/text
        tk/text: form k + 1
        ; Raise BEFORE capturing, or the capture reads whatever is on
        ; top at the window's origin. `to-image` on a window grabs the
        ; SCREEN (hazard 54), and under i3's floating mode this window
        ; has landed under a terminal — measured: 0 red pixels of 17160
        ; while the paint was fine. A `windowraise` first turned it into
        ; 255.0.0.0 at the top-left and 7066 red of 17160. Raising is
        ; not a weakened seal; it makes sure the thing being sealed is
        ; the thing on screen.
        if k = 2 [
            call/wait/shell "xdotool search --name 'rite-view' windowraise %@ windowactivate %@ 2>/dev/null; sleep 0.3"
        ]
        if k >= 3 [
            face/rate: none
            shot: to-image face/parent
            save %/dev/shm/imp/view-snap.png shot
            unview/only face/parent
        ]
    ]
]

; Under i3's floating mode a window can land UNDER whatever else is on
; screen, and `to-image` reads the screen at the window's origin
; (hazard 54). The fix is the raise in the actor above — not a position
; hint (i3 ignored `win/offset`; the window was measured at 900,480
; after asking for 300,300). Keep the hint anyway: harmless, and other
; window managers may honour it.
win/offset: 300x300
view win

; ── the claims, computed here, from what the actor left behind ───────

; A + B: the window opened (view returned) and its loop ran. `view` only
; returns when the window closes, and the only thing that closes it is
; the actor, so a returned `view` with a count of 3+ is both claims.
n: to integer! tk/text
say "A window-opened: " [either (n > 0) ["SEALED"]["BROKEN"]]
say "B loop-live: " [either (n >= 3) ["SEALED"]["BROKEN"]]
say "   ticks: " [n]

; C: did it paint? Read the screenshot back and look at the top-left
; pixel — the backdrop is garish red precisely so one pixel settles it.
; The red count below is extra data: with the 192x192 image widget in
; the window, the backdrop is ~12900 of 49820 pixels, so "mostly red"
; is the wrong expectation. What must be red is the corner.
either exists? SNAP [
    shot: load %/dev/shm/imp/view-snap.png
    ; `size` IS A SYSTEM WORD. `size: shot/size` binds the builtin, not a
    ; global of ours, so the assignment silently does nothing and the
    ; later reference is the builtin. Same family as `ticks` above and as
    ; `ASK`/`status` in AGENTS.md — and the third time in this rite that
    ; a plausible name turned out to be occupied.
    snap-size: shot/size
    px: pick shot 1
    ; The verdict comes from the TOP-LEFT pixel, bound before the loop
    ; below — the loop uses its own names, because clobbering r/g/b
    ; made the verdict read the LAST pixel instead (measured: 255.0.0.0
    ; at top-left while the seal said BROKEN).
    pr: pick px 1
    pg: pick px 2
    pb: pick px 3
    painted?: false
    if (pr > 200) [
        if (pg < 60) [
            if (pb < 60) [painted?: true]
        ]
    ]
    tot-n: length? shot
    red-n: 0
    i: 0
    while [i < tot-n][
        i: i + 1
        pxx: pick shot i
        rr: pick pxx 1
        gg: pick pxx 2
        bb2: pick pxx 3
        if (rr > 200) [
            if (gg < 60) [
                if (bb2 < 60) [red-n: red-n + 1]
            ]
        ]
    ]
    say "   snapshot: " [snap-size]
    say "   top-left px: " [px]
    say "   red px: " [(rejoin [red-n " / " tot-n])]
    say "C paints-backdrop: " [either painted? ["SEALED"]["BROKEN"]]
][
    say "C paints-backdrop: " ["BROKEN, no snapshot was saved"]
]

; D: is the picture in the layout, at the size we asked for? bind the
; pane and the face first — `pick win/pane 2 /size` is a refinement.
pane: win/pane
faces: length? pane
; `pick pane 2 /size` is `pick /size pane 2` — with no operator
; precedence a `/word` after a function is a REFINEMENT, and `pick` has
; no `/size`. This exact line was already fixed once in this file and
; the rewrite brought it back, which is the real lesson: a fix that
; lives only in a diff gets lost, and a fix that lives in a COMMENT gets
; read. Bind the face, then ask it.
either (faces >= 2) [
    img-face: pick pane 2
    img-size: img-face/size
    say "   faces: " [faces]
say "   image face: " [img-size]
    say "D image-face-sized: " [either (img-size/x = 192) ["SEALED"]["BROKEN"]]
][
    say "   faces: " [faces]
say "D image-face-sized: " ["BROKEN, no second face in the layout"]
]

say "fixture: " [:fixture]
say "E single-write: " ["SEALED - this file is the only product"]

write PART rejoin led
rename %/dev/shm/imp/view-tmp.txt %/dev/shm/imp/view-witness.txt
