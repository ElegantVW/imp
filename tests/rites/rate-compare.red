Red [Title: "rate-compare"]
; DID THE THRESHOLD COST US THE DARKS?
;
; Four wishes were conjured and the evidence kept: the 256x256 png the
; diffusion model painted, beside the braille the forge made of it.
; Reading them side by side:
;
;   a lighthouse in a storm  -> NIGHT. most samples under 128. the
;     braille was sparse, but the composition survived: the tower is
;     there, the wave band is there.
;   a fox in white flowers   -> BRIGHT and saturated. the braille was
;     dense, and faithful — to a source that was already a smear,
;     because sd-turbo at 256px produced blobs.
;
; So the forge is not losing the picture. It is losing TEXTURE in the
; darks, and the fixed threshold of 128 is why: a diffusion model picks
; its own exposure and is not obliged to sit in the middle of the
; range, while a global 128 quietly assumes it does.
;
; This rite renders ONE picture three ways, all at the same 40-column
; grid, so the comparison is between forge settings and nothing else:
;
;   A  braille, threshold 128      the baseline
;   B  braille, threshold = mean   the cheap fix
;   C  a luma ramp, no threshold   the CONTROL
;
; C is the important one. If C reads as the picture and A does not,
; the braille is losing something and the threshold is where to look.
; If A and C read the same, the braille is innocent and the loss is
; upstream, in a 256px render of a complicated wish.
;
; The lit-pixel COUNT is the number that settles it without an opinion:
; a threshold that lights almost nothing is a threshold eating the
; picture.

do %src/core.red
do %src/forge.red

PROBE: %/dev/shm/imp/rate-compare.txt
led: copy []
mark: func [s [string!]][append led s  write PROBE rejoin led]
mark "OPENED"

IMG: %/dev/shm/imp/probe-src.png
img: try [load/as IMG 'png]
either error? img [
    mark rejoin ["LOAD-ERROR " mold img]
    quit
][
    mark rejoin ["source " mold img/size]
]

W: 256
H: 256
INK:  [236 228 214]
VOID: [ 24  28  36]

; how bright is this picture, really?
ml: try [mold forge-mean-luma img W H 80 48]
mark rejoin ["A0 picture-mean-luma: " either error? ml ["threw"] [to string! ml]]

; ── A: the baseline ──────────────────────────────────────────────────
t: try [a: forge-braille img W H to integer! pick INK 1 to integer! pick INK 2 to integer! pick INK 3 to integer! pick VOID 1 to integer! pick VOID 2 to integer! pick VOID 3  length? a]
mark rejoin ["A baseline-len: " either error? t ["threw " mold t] [to string! t]]

; ── B: the threshold follows the picture ─────────────────────────────
t: try [b: forge-braille-mean img W H to integer! pick INK 1 to integer! pick INK 2 to integer! pick INK 3 to integer! pick VOID 1 to integer! pick VOID 2 to integer! pick VOID 3  length? b]
mark rejoin ["B mean-len: " either error? t ["threw " mold t] [to string! t]]

; ── C: the control, no threshold at all ──────────────────────────────
t: try [c: forge-ramp img W H 40 12  length? c]
mark rejoin ["C ramp-len: " either error? t ["threw " mold t] [to string! t]]

; ── THE NUMBER. count lit cells in each braille variant. if A lights
;    far fewer than B on a night picture, the threshold was the cost. ──
; NO COUNT METRIC. I tried one and it was worse than nothing: a blank
; braille cell is U+2800, not a space, so counting non-space glyphs
; returned 480 — every cell in a 40x12 grid — and "lit pixels: 480"
; looks like a measurement while measuring the grid. A dot count would
; be honest and is easy to get wrong by reading bytes as characters.
; So: no number. Three renderings, and LOOK at them.

t: try [write %/dev/shm/imp/rate-C-ramp.txt c  "wrote"]
mark rejoin ["E wrote-ramp: " either error? t ["threw"] [to string! t]]

t: try [write %/dev/shm/imp/rate-A-braille.txt a  "wrote"]
mark rejoin ["F wrote-baseline: " either error? t ["threw"] [to string! t]]

t: try [write %/dev/shm/imp/rate-B-braille.txt b  "wrote"]
mark rejoin ["G wrote-mean: " either error? t ["threw"] [to string! t]]

mark "DONE"
