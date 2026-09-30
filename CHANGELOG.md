# Imp changelog

## v0.15.0 (2026-09-30) — the mouth learns hands, busy is unmistakable

**Hand-aware enhance.** The rewriter used to write one kind of text
for all three hands — atmosphere captions that starve Pony (which
reads score tags, not sentences) and underserve SDXL. Now each hand
carries its own brief (turbo: punchy nouns; SDXL: full scene
sentence; Pony: Danbooru tags), the rewrite orders include it, and
the prompt gets the hand's prefix (`score_9, ...` for Pony) plus the
style suffix in *both* paths. Mignola's suffix gained hollow blacks
and paper negative space. Composition stays pure and sealed; the
mouth (8B, back up after the outage) writes directly for the hand.

**Busy is unmistakable.** Phase dots cycle on the status line while
anything is out (`···` moving = alive; frozen + frozen flame =
broke, and the deadline says so). The flame grows to 20pt during
runs. The wish boxes lock while busy and reopen after — probed
`enabled?` both ways first.

**Pony paints.** Converted locally, test-painted 63s, valid PNG. The
third hand is live in the drop-down.

**Process note.** A nested-`and` paren slip in a new seal killed the
whole rite file silently (load error, no witness — it *looked* like
a hang, then a segfault). Found by loading the file under `try` and
molding the error (hazard 10's method, now standard). Conditions stay
flat from here on.

Clicking enhance with it off now rewrites the wish in the chosen
style, right there in the box, while the flame burns: same async
door as a conjure (one rc file, one flight — conjure waits while a
rewrite is out and vice versa), same 666s deadline naming the silent
mouth. Clicking with it on just switches off; the box keeps whatever
it holds. Conjure paints exactly what the box says — visible and
editable first.

The slow proof runs the integrated loop: rewrite ("...moonlight
casting long shadows across the grass", enhance on), then off-paint
of the rewritten box plus suffix, no second mouth. The prompt file
the hand ran is the receipt. A dead mouth mid-proof gave
"fail: the mouth refused." instead of a hang — the truthful-failure
design validating itself by accident.

## v0.13.0 (2026-09-30) — the house theme, counted steps, a pulse

The window wears SIGIL now: backdrop `#1A1218`, text `#F0E4EE`,
muted `#6B6FA8`, imp purple `#C89BE0`, pixie-pink flame `#E8A0B4` —
one source of truth in `tui.red`, sealed face by face. DejaVu Sans
Mono throughout, labels small and muted, values mid-weight. Buttons
stay native with themed type (see below): conjure dark, quit muted,
enhance purple state text. The printed frame keeps its oracle-pinned
SGRs — the window and the terminal match in spirit, byte-exactness
wins over hue.

**Buttons, honestly told.** The theme pass briefly made all three
buttons flat base faces. Then a real quit-click did nothing — twice —
and back it went. Caveat, because the first conclusion was wrong: a
coordinate sweep later closed the window at x=440; my clicks had
missed at 390. So base-face real-click delivery is *unproven*, not
broken — and native delivery is proven twice (weeks of conjure
clicks, plus the sweep). Native it is.

**Steps counted.** A purple number beside the fader, live: slider
`on-change` fires on drags *and* programmatic sets (hazard 66), so
the preset sync moves the number for free and a rite calls the same
named words. `steps [slider] 20`, always truthful.

**Pulse.** The status brightens and the flame grows a size while a
run is out, and dims back when it lands — `con-flare`/`con-calm`,
named and sealed without a GPU, in the vendor's own facet pattern.

## v0.12.1 (2026-09-29) — audit: the flame's missing tongues, stale words

An audit morning. The suite is green, the docs number clean (65/65),
no stuck processes — but two things were off and one count lied.

**The flame only burned four tongues.** Two of the six entries in
`CON-FLAMES` were byte-identical, and `find` returns the first match,
so the cycle 4→(finds 2)→3 could never reach 5 and 6. The "tongues"
counts in old testimonies (14, 25, 39…) were never a real metric —
through real faces, trailing-space normalization collapses them
further. Entry four now leans the other way; the probe walks all six
through the function *and* through a live face. The movement seals
always held; now the count means something too.

**Stale words.** `build.sh tui` still described the mode cycler two
releases after braille left, and rite-tui's panel comment named faces
that no longer exist. Both now say what is there.

## v0.12.0 (2026-09-28) — three hands, a steps fader, and the clobber

**Hands.** A drop-down: turbo (4 steps, ~5s), SDXL (20 steps, ~51s),
Pony (25 steps, ~63s — paints, valid PNG). Each hand brings its own
sampler contract; the switch sets steps/cfg automatically, and the
frame's hand row names whoever painted. Pony was converted locally
with our own binary after every remote GGUF failed to load (this
build only reads OpenAI-style tensor names — ComfyUI dialect never
loads, any quant, either flag).

**Steps fader.** A slider, 1–50. New hand → its preset moves the
slider, visibly. Same hand → your grabbed value runs. No widget
actors anywhere: the sync lives in `con-sync-steps`, where a rite
calls it. A custom size that isn't a number is still refused before
anything spawns.

**The clobber (hazard 65).** The slow proof failed with surgical
madness: indices right, steps right, suffix right — only the two
name labels stale. `con-style-name` (func) and `CON-STYLE-NAME:`
(string) are one word to case-insensitive Red; the first assignment
replaced the function with its own answer, and every later call
returned stale text with no error. Single-call rites all passed —
only the second distinct value in one process failed. Fix:
verb-first `con-get-style-name` / `con-get-hand-name`. Regression
seals call twice. The naming law in AGENTS.md now forbids func/value
pairs that differ by case only.

```
H0 globals: "SEALED"   globals: "SDXL/Mignola 2/3 off"
H2 frame-hand: "SEALED"
```

## v0.11.0 (2026-09-28) — mode leaves, seeds roll, styles hold both paths, bigger mouth

**Mode is gone.** One mode is not a choice, it is a label. The face
and its heading left the layout; row two is size only. Styles are
the options now.

**Variety.** Same prompt painted the same picture every time — not
the model, the default: sd-cli seeds 42 unless told otherwise.
`--seed -1` in `con-hand-cmd`. Every wish rolls fresh now.

**The style holds in both paths.** This was a real bug in the last
release: enhance on wrote the mouth's sentence and quietly dropped
the suffix, so choosing Mignola with enhance on painted plain turbo.
Now the suffix appends to the mouth's sentence too. Enhance chooses
*who writes* (mouth vs you), never *whether the style applies*. The
mouth's fallback also composes instead of hardcoding, so a silent
mouth still paints in-style.

**Bigger mouth.** The 0.6B is retired from port 8082; Qwen3-8B
abliterated serves now (same flags, built-in template — the custom
`--chat-template` broke the new server's parser, so it was dropped).
Two things it needed: `/no_think` on both standing orders (without
it, 160 tokens of thought hit `length` and every call fell back) and
the strip already in place for the empty shell it leaves behind. The
dragon spoke on the first 8B run: *A mortal's sketch is but a
whisper—my scales hold the storm.* The full slow rite re-sealed
against the new mouth, both paths.

## v0.10.0 (2026-09-28) — seven styles, an honest mouth, a deadline, a resizable window

Four things at once, because the day demanded all four.

**Styles.** A drop-down with seven: Photography, Pixel art, Mignola,
3D animation, Hentai, Anime, Vintage anime. With enhance on (the
default), the style rides into the mouth's orders and the sentence
comes back already dressed. With enhance off, your words go out raw
with the style as an SD suffix and the mouth is never consulted:

```
prompt: {a fox asleep in a field of white flowers, mike mignola style,
heavy black shadows, woodcut ink, stark contrast}
```

That line is the file the hand actually ran, read back by the rite.
The frame's Provenance says `style:` and `enhance:` too, because the
frame must not claim what it cannot back. An `enhance: on/off`
button flips the path; one-shot keeps photography + mouth, exactly
as before.

**The mouth thinks out loud, and now it does so alone.** Qwen3
reasons in `<think>` tags, and a Citroen got painted from
chain-of-thought — the log's `prompt` line caught it red-handed.
Replies are stripped of every thinking pair before anything reads
them; an emptied answer falls through to the honest fallbacks (plain
prompt, silent dragon) instead of painting static.

**A silence has a deadline.** The hung Citroen run polled a file
that would never appear: sd-cli was gone, no rc written, flame
burning forever. Now every spawn stamps the time, and after 666
seconds of nothing the window says which voice fell silent — mouth,
hand, or dragon — instead of burning on. The deadline itself is
sealed pure (fresh repels 100, outlives 667).

**The window resizes.** `layout/flags [resize]` — without it the
backend marks the window fixed and i3 will only move it. Proven
live: 470×483 → 600×700 on request. Resize shows backdrop, not more
picture; the image stays 300×300.

## v0.9.0 (2026-09-28) — braille leaves, sizes open up

Braille is out, by request, and the size story is finished properly:
presets you can click, a custom box you can type in, and the u/d keys
still walking the presets for fingers that know them.

**Mode says `normal`, and that is the whole list.** `MODES` is one
word now; the l/r cycler went with braille. The face stays — the new
styles will plug into exactly that spot when their design arrives.

**Sizes: drop-down, custom field, keys.** Seven presets
(128–1024) in a native `drop-down` — probed first, because assuming
a widget exists in this 32-bit build is how you lose an evening. It
builds, it holds seven items, `selected` sets and reads. Custom wins
when it says anything, else the drop-down, else 512: what runs is
always visible. A custom size that is not a number is refused before
anything spawns (`that size is not a number.`, busy stays 0 — sealed,
no GPU spent). Cycling presets clears the custom box, for the same
reason: the visible state and the running state must never disagree.
The opening preset still comes from the hour (`h // 7 + 1` — modulo
is finally the tool, not the trap) and is never explained in-product.

The full pipeline re-proved itself through the new path: two wishes,
one window, picture 768×768 — the drop-down does not just display,
it drives the hand.

```
D mode-single: "SEALED"   preset: "6 -> 7 custom="
L presets: "SEALED"   presets: 7
M custom-refused: "SEALED"   refused: "that size is not a number. busy=0"
```

## v0.8.0 (2026-09-28) — the window learns manners, and a way out

Two complaints, both fair: the window was absurdly wide and tall for
what it holds, and there was no way to leave it except killing the
process. Both fixed, nothing else touched — the picture stays 300×300.

**Three rows instead of ten.** The controls were stacked one per row:
label, field, label, value, label, value, button, status, flame. Now
they share rows (`across`): wish + conjure + quit on one line, mode +
size on the next, status + flame on the last. The window went from
2120×320 to 470×428 — shorter, narrower, and no longer wider than the
desktop it opens on. The busy face is still there, a 10px sliver the
colour of the backdrop: state lives in faces, but it does not have to
be seen.

**Quit, two ways.** A quit button beside conjure, and `q`. The key
took three attempts to exist: `#"q"` in `on-key` matches synthetic
events only (hazard 62 — real letters arrive as `none` there), so the
key lives on `on-key-down`, where real and synthetic both arrive as
chars. And the first live typing test closed the window: key-downs
bubble field→window, so a q typed inside a wish would have been the
most destructive letter on the keyboard. The guard is `same?`
`event/face` against the wish field. Typing is safe and window-focus
q quits — both verified with real keypresses through xdotool, not
just synthetic ones.

```
F buttons: "SEALED"   buttons: 2   G image-last: "SEALED"   last width: 300
K field-q-safe: "SEALED"   I quit-dispatch: "SEALED"
H quit-key: "SEALED"   J quit-keydown: "SEALED"
```

## v0.7.0 (2026-09-28) — the window stays open, and a flame while it thinks

Conjure used to close the only door it came through. The button was
`[unview/all]`: one wish, then darkness, then the user opening the
window again like knocking twice. Now the window does not close. A
second wish is the same button again, and the picture changes under
your hand.

**The pipeline moved into a library.** `src/conjure.red` was 557 lines
that `quit` on every error, and `quit` kills a window. So the whole
rite lives in `src/conjure-lib.red` now, which never quits and never
views: it returns `"ok"` or a `fail:` string. Two doors, same words —
`con-run` blocks for `imp "a wish"`, `con-begin`/`con-tick` go
asynchronous for the window. `src/conjure.red` is nineteen lines of
wrapper. The one-shot was re-proved after the move: 19454 bytes of
lighthouse, exit 0, untouched behaviour.

**The flame is not decoration.** `call/wait` freezes the event loop
for the whole of sd-cli, and a four-second freeze with no movement
reads as a hang to anyone who has ever lost work to one. So the long
commands run without `/wait` (hazard 23: without it you get a PID),
the shell drops its exit code in a file, and a `rate 0:0:0.06` facet
cycles six tongues of fire while it polls. Sealed by
`tests/rites/rite-flame.red`: 18 ticks during a one-second sleep,
sentinel `0`.

**Two wishes, one window, all sealed.** The press lives in a named
word — `con-press` — because a synthetic click never reaches a
button's `on-click` (hazard 61: busy stayed `"0"` through ten pumps;
the button is one word long and the rite calls the same words a
finger runs). `tests/rites/rite-tui-conjure.red` runs the full GPU
pipeline twice in one window:

```
button-found: "SEALED"   A first-finished: "SEALED"   run1: "ready. wish again."
B flame-moved: "SEALED"   tongues: 14   C picture-new: "SEALED"   pic: "512x512"
D window-open: "SEALED"   E second-finished: "SEALED"   run2: "ready. wish again."
F still-open: "SEALED"   G single-write: "SEALED - this file is the only product"
```

It is slow (two paintings, minutes) so it has its own door —
`./build.sh tui-conjure` — and `all` stays fast. The first draft of
that rite segfaulted the console once; bisection found the click that
did nothing and the guards that were missing, and the rewrite has run
clean. That crash is on the record because an unisolated crash does
not become harmless by being followed by a seal. (`build.sh all` went
green at the end, with one honest scare along the way: rite-view read
a dark pixel twice on the live desktop — a screen-capture artifact,
green before and after, see hazard 54.)

## v0.6.0 (2026-09-28) — the TUI, and the install that was never done

Bare `imp` opens a window. That is the whole feature, and it took longer
than it should have because the window was never the problem.

**`~/bin/imp` was a stale copy.** `imp` on PATH was a 4808-byte launcher
from before the TUI work — no `[[ -t 0 ]]` gate, no TUI branch, and the
old 256px sampler with sd-cli's wrong 20-step/cfg-7.0 defaults. The repo's
`scripts/imp` was 8064 bytes with all of it. `build.sh install` did
`install -m 0755`, a copy, and the copy was never refreshed after the TUI
was committed. So every `imp` the user ran went to the wish prompt, and
the TUI was never once executed. It is now a symlink — `~/bin/imp` →
`~/imp/scripts/imp` — and `build.sh install` makes the link and checks
it resolves. A symlink cannot drift.

**`src/tui.red` is a library.** It builds `win` and never views it,
because a file that views itself is a file no rite can load. The
launcher stages a three-line wrapper — `Red [...]` header, `do
%src/tui.red`, `view win` — in the repo root. The rite loads the real
file and asserts the window, the panel, the picture, and the cycler.

**The evil opening posture.** The window does not remember anything and
does not open the same way twice. Mode and resolution come from the hour
by a rule that looks arbitrary, is deterministic, and is never explained
in-product. `h: forge-div (to integer! now/time) 3600`, then
`pick MODES (to integer! (divide h 12) + 1)`.

**Six VID traps, all found by the rite, all in `docs/GRIMOIRE.md`:**

| # | trap |
|---|---|
| 55 | `layout compose/deep` + `on-key` is `vid-invalid-syntax` — use a plain `layout` |
| 56 | VID takes a literal, not an expression — `text 200 (mold mode)` is a syntax error |
| 57 | `mold` of a string gives a curly-brace string — `{"normal"}`, not `"normal"`; use `form` |
| 58 | `//` is modulo, not division — `pick MODES (h // 12)` is `none` for h≥2 |
| 59 | a synthetic event's key is a char, a real arrow key is a word — switch on both |
| 60 | `on-key` goes first in the layout — last, and `win/actors` is `none` |

**The mode cycler is sealed.** `tests/rites/rite-tui.red`, wired into
`./build.sh` as `imp: tui`:

```
A panel-present: "SEALED"   faces: 8
B loop-live: "SEALED"
C image-present: "SEALED"
D mode-cycler: "SEALED"   mode before: "braille"
E single-write: "SEALED - this file is the only product"
```

D is the one that was asked for. A left key flips `normal` to `braille`,
and it is now a fact under an automated `send-event`, not a hope.

## v0.5.0 (2026-09-28) — the window opens, and it paints

`imp` is going to grow a TUI. Before anything is built on it, the thing
it stands on has to be true on **our** binary, and it is now a seal.

**Red cannot read a terminal, so the TUI had to be a window.** `stdin` and
`termios` appear nowhere in the runtime source, and `view`'s `on-key`
fires on window events only. There *is* a terminal backend — 20 files,
`tty.reds`, `screen.reds`, a `widgets/` tree — and it is 82% stubbed:
34 of 41 `OS-draw-*` routines are empty, `OS-draw-image` literally
`return 0`, and its widget set has no image at all. Our binary links
GTK-3, X11 and Wayland. So the window backend is the only option, which
is fortunate, because it is also what was wanted.

`tests/rites/rite-view.red` asserts four claims, wired into
`./build.sh` as `imp: window`:

```
A window-opened: "SEALED"
B loop-live: "SEALED"   ticks: 3
   snapshot: 212x235   top-left px: 255.0.0.0
C paints-backdrop: "SEALED"
   faces: 2   image face: 192x192
D image-face-sized: "SEALED"
```

**C is the one that matters.** A window can open and never paint, and
that is indistinguishable from a working one until a human looks at it.
This box has no screenshot tool — no `import`, no `scrot`, no `xwd` — so
the rite takes its own with Red's `to-image` and `save`, and reads a
pixel back. The backdrop is deliberately garash red so that "did it
paint" is answerable from one number: `top-left px: 255.0.0.0`. The
`image` widget loads a real PNG from disk and displays it, which is
exactly what the `normal` mode needs.

**Eleven ways this rite failed first, all of them mine, and the two
general ones are worth more than the feature:**

- **Assignment inside a VID actor does not reach the enclosing global.**
  `n: n + 1` in an `on-time` block leaves the global at 0 forever, so a
  counter written that way never reaches its threshold, the window never
  closes, `view` blocks, and the rite times out looking like a hang. A
  count kept in a **face** works. That is why the actor here is three
  lines and every claim is computed afterwards, in ordinary code, from
  the file the actor saved.
- **The `rate` facet goes on the same line as its widget.** Wrapped onto
  its own line with the face named, the actor silently never attached.
  A dead facet and a slow one look identical.

Plus: `read` raises on a binary file and wants `/binary`; `copy` copies a
*value*, so the file-copy idiom is `write %dest read/binary %src`
(byte-exact, 144675 in and out) and `copy-file`/`read-binary`/
`write-binary` are all absent from the binary; `load %f /size` parses as
`load /size %f` because a `/word` after a function is a refinement;
`write` truncates, so one progress file shows only the last line and two
runs looked like they had died at the first statement; and `ticks` and
`size` are **system words**, so binding them silently does nothing — the
same trap as `ASK` and `status`, and the reason this rite names every
intermediate after something boring.

Still true and re-verified: 12 byte-exact seals, the frame's width
contract, the Otsu threshold, `sd-turbo 512x512 4sp cfg1`, pure Red, no
C. The TUI itself is not written yet — this is the ground it stands on.

## v0.4.0 (2026-09-28) — the hand was never weak, the sampler was

The north star asks for art that matches the wish. For a full session the
imp blamed the diffusion model. It was the command line.

**`sd-cli` was running at its defaults: 20 steps, cfg 7.0.** SD-Turbo is
distilled and guidance-free — it wants a handful of steps and no
classifier-free guidance. Measured on one wish, same seed, 256×256:

| | result | wall |
|---|---|---|
| 20 steps / cfg 7.0 | flat cartoon, hard outlines, orange lighthouse | 4.3 s |
| **4 steps / cfg 1.0** | **a photograph** — cliff, real waves, branching lightning | **1.6 s** |

Better and faster. Every "coloured blob" from the last two days was the
sampler. The model was excellent the whole time. Both values are now
passed explicitly, and the Provenance divider says so —
`hand: sd-turbo 512x512 4sp cfg1` — because it used to claim `256x256`
while the sampler silently ran at something else, which is a claim
incomplete in the one direction that mattered. cfg is **1.0, not 0.0**:
cfg 0 is *unconditioned* mode and the prompt is ignored, and sd-cli says
so in a warning we should have read three sessions ago.

**512×512, because it is free.** 2.8 s at 4 steps, against 1.6 s at 256.
The forge costs the same either way — the braille samples a fixed 80×48
grid, so a bigger source means more detail per cell, not more time. The
old "512 blew a 560 s budget" fear was measured at 20 steps and is dead.

**The threshold is now Otsu.** A chain of three wrong models:
`FORGE-LUMA-MID: 128` assumes the picture sits mid-range and sd-turbo
picks its own exposure; the picture's *mean* follows the exposure but is a
global statistic and cannot separate two populations, so on a dark sky
with a bright subject it lands between them and discards the sky; Otsu is
also global but is global *optimally*. Same cost as the mean, one
histogram and a 256-bin sweep. On the 512 lighthouse it lands at 112
where the mean says 105. `forge-braille` and `forge-braille-mean` both
stay, as the baselines the claims were measured against.

**Two bugs in the new code, caught by the rite that tests it.** `replace`
on a block finds the **value**, not the position, so the histogram
incremented nothing and Otsu was about to return a confident wrong
number — `poke` is the positional one, and it returns the assigned value
rather than the series. And the sampling loop walked `pick img 1..n`,
which on a 512×512 source is the **top seven rows**: every "picture mean"
ever reported was a strip of storm sky along the top edge. It surfaced
only because Otsu and the mean appeared to disagree wildly while *both*
reporting 110 — the mean's file on disk was stale, left by an earlier run
whose mean variant had thrown.

**The debugging cost more than the feature, and that is the finding.** The
rite would not load, and four rounds of bisection found three broken
instruments and then a one-character bug: `any!` is not a word in Red
0.6.6, and a func spec naming it is a *load* error, so the file died with
no output and no witness. The instruments were (1) a `;` comment injected
above `mark: func`, (2) a poll watching a path no rite wrote, (3) a
captured file literal that still had Red's `%` sigil on it, so `rm -f
"%/dev/shm/imp/x.txt"` politely removed a file named `%` — each of which
reported a working prelude as broken. **A harness which is not itself
tested will invent faults.** The new rite therefore opens with a control
that must load, and `rited` now honours `RITED_WAIT` because a deadline
that is too short does not report "slow", it reports "wrong".

Also: a witness written on every line is a log, and `rited` exits and
`pkill`s on first sight — which is why that rite reported `D3` on one run
and `D4` on the next. It now accumulates and `rename`s into place. The
frame seal from v0.3.0 still passes, every line of every frame is still
exactly 60 columns, and the 12 byte-exact seals are untouched. Hazards
42–46 added to `docs/GRIMOIRE.md`.

## v0.3.0 (2026-09-27) — the frame keeps its width, and the darks come back

Two changes, both found by looking at the evidence rather than at the
code, and one honest note about a seal that could not be built the way
the others were.

**The frame's width contract, sealed.** `pad-to` only ever pads, so a
66-character mockery went into a 56-column body and came straight
through: the shipped frame measured **81 columns inside a 60-column
frame**, and every border and labelled divider measured 61. `row` now
clamps — `clamp-to` cuts at the last space that fits and marks the cut
with `…`, so a too-long line reads as deliberately short rather than as
a word torn in half. The border arithmetic was `w - 2` where it needed
`w - 3`, and the labelled and empty divider branches need *different*
widths (3 fixed glyphs versus 2).

`tests/rites/rite-frame.red` asserts every line of every kind is exactly
60 visible columns, fed an empty string, an exact fit, and 200
characters of `x`. It is wired into `./build.sh` and fails the build.

There is **no oracle for this one, and the reason matters**: the Python
original's frame has the same defect, so a byte-exact seal would have
blessed the 61-column border as correct. This asserts the property the
frame *claims*. It is a different kind of claim from `rite-two`'s and it
is labelled as such in `build.sh` rather than dressed up as the same
thing.

**The threshold was a wrong model, not a tuning miss.** `FORGE-LUMA-MID:
128` assumed the picture sits in the middle of the range. Measured on a
night scene: **the picture's mean luma was 42.** The threshold was three
times the average, so two thirds of the image was below the line and the
darks came out empty. `forge-braille-mean` thresholds at the picture's
own mean instead — one extra pass, no tuning, and it follows the exposure
the diffusion model chose. `forge-braille` stays as the baseline it was
measured against, and `forge-braille-at` takes the threshold as an
argument so a real local threshold (Sauvola, ~12× the cost in Red) can
replace it without a rewrite.

Verified by looking, not by counting: the wave band in
`a lighthouse in a storm` went from a scattered line of dots to a solid
mass. `tests/rites/rate-compare.red` renders one picture three ways —
fixed threshold, mean threshold, and a luma ramp with no threshold at
all as a control — and the reader compares them by eye. It has **no
count metric on purpose**: the first version counted non-space glyphs and
returned 480, which is every cell in a 40×12 grid, because a blank
braille cell is `U+2800` and not a space.

**Also:** the mockery is capped at source (45 characters asked, 40 tokens
allowed, 56-column panel) so the clamp stays a safety net rather than the
normal path. `scripts/imp-eval.sh` keeps wish, prompt, source png, braille
and frame per run — it is a development tool, and the program still writes
nothing outside `/dev/shm/imp`. Three rites had inverted `either` arms
where a true value was wired to the failure branch; all three are fixed
and the pattern is hazard 40. Hazards 39–41 added to `docs/GRIMOIRE.md`.

**What did not change, and is not the forge's fault:** a complicated wish
at 256 px comes back from sd-turbo as coloured blobs, and the braille is
faithfully a picture of blobs. The upstream render is the weak link.

## v0.2.1 (2026-09-27) — the imp grows a mouth

The north star asks for two things: *conjures ANSI art from a wish, a
haiku dragon mocks it.* Only the first existed. Now both do, in pure
Red, and the LLM does the job it is actually good at.

**The mouth writes the prompt.** The hardcoded suffix
`", dramatic lighting, high contrast, centred composition"` is gone.
For `a lighthouse in a storm` the 4B now writes:

> A lone lighthouse stands defiant on a rocky cliffside, battered by
> relentless thunderstorms, its white walls glistening with rain and the
> wind howling through jagged sea spray, casting a cold, flickering green
> glow into the pitch-black night, evoking a sense of isolation and
> enduring hope.

That is the single largest quality jump in the project, and it cost about
forty lines. A language model is a prompt writer, not a painter.

**And the dragon mocks it.** A second call, after the art exists:

> Oh, how quaint. A flicker in the dark? I've seen storms that made stone
> weep.

Two calls, not one, so each can fail alone: if the mockery fails the frame
prints *"the dragon declined to comment"* rather than a blank line that
would be a lie by omission.

**Reading json is native; writing it is not.** `load/as %f 'json` returns
a `map!` with nested maps and direct path indexing — excellent. But
`to-json` **serialises word NAMES, not values**: a variable becomes its
own name in the output, on both blocks and maps. So the request is
hand-built, and `curl -d @file` means the wish never touches a command
line. Grimoire hazards 35–37.

**`red-view` cannot compile `\"` — anywhere.** One escaped double quote
kills the whole load, silently, and the symptom is indistinguishable
from a hang. Measured, then found by mechanical bisection. Every quote
in the request is now built as a value: `to string! to char! 34`.

Worst hour of the project, and the grimoire now says so.

### Also in this version

- **The C is gone, for real.** `bridge.c`, `forge.c`, `forge.h`,
  `pngread.c/.h` and `forge-main.c` moved to `.retired/`. v0.2.0's
  changelog claimed they were deleted when they were not — the exact
  sin this project forbids, in its own documentation.
- `build.sh` no longer needs a C compiler. `install` is a copy. It
  checks the substrate, the four Red sources, the twelve seals, and
  prints **NOT** on the forge section, because `forge.red` has no
  oracle and `GRIMOIRE.md` now says so at length.
- The substrate check stopped asserting that `/lib/ld-linux.so.2`
  exists. It is a dangling symlink on Arch and it was reporting a
  missing loader for an interpreter that demonstrably runs. It asks
  `ldd` now.
- A 256×256 conjuring takes **17 s** warm, or about 5 s without the
  mouth.

## v0.2.0 (2026-09-27) — the C bridge is deleted

**The program is pure Red.** Not "mostly Red", not "Red with a helper".
One file, `src/conjure.red`, takes a wish and publishes a frame, and
nothing in the art path is written in C or Python.

```
wish ─▶ sd-cli (GPU, ~4s) ─▶ a png
     ─▶ load/as 'png      ─▶ image!,  pick n ─▶ r.g.b.a
     ─▶ src/forge.red     ─▶ braille in truecolour
     ─▶ src/core.red reap ─▶ 12 lines of exactly 40 columns
     ─▶ frame, by rename
```

`~/bin/imp` is now a small bash *launcher*, not a program. It exists only
because Red has no `sleep` and the Red Console has no stdout, so
something has to hold the tty while the interpreter thinks. That is the
same relationship `rited` has always had.

### How Red talks to the world, since it cannot

`call/wait/shell` runs a command, returns a real exit code (`0` for
`/bin/true`, `1` for `/bin/false`, `255` for a missing binary), and the
shell can redirect that command's output to a file which Red then reads.
That is the entire I/O story: no sockets, no FFI, no rebuilt interpreter.

**And `/output` and `/error` are documented in the spec and completely
inert in this GUI build.** `/output out: %file "/bin/echo hi"` creates
nothing. Give the *shell* the redirect instead. Grimoire hazard 22.

### The image decoder I did not have to write

I was about to write DEFLATE in Red — 300 lines, the honest answer to
"what can Red not do". Then `load/as %f 'png` turned out to return a
native `image!` with an RGB pixel per position: `pick img n` → `r.g.b.a`,
`img/size` → `512x512`. Red 0.6.6 ships a full codec set,
`[png jpeg bmp gif redbin json csv]`, and `image/encode` goes the other
way too.

**Measure the language's inventory before planning around its gaps.**
Grimoire hazards 24 and 25 were both written before this was found, and
both are now wrong in the imp's favour.

### Half-blocks and braille, because 40×12 is not enough

A 512×512 image squeezed into 40×12 cells throws away 97% of itself. Two
escapes, both using glyphs the terminal already has:

- **half-block `▀`** — one cell carries two stacked pixels, fg top and bg
  bottom → **40×24**, in truecolour
- **braille `U+2800`** — one cell carries a 2×4 dot matrix → **80×48**

The picture supplies structure (which dots are lit); the palette supplies
colour. That is not a compromise forced by the decode — it is how
terminal art has always worked, and a palette the imp picks beats one
sampled out of a photograph.

### The GPU was on the whole time

`llama-server` had been logging `no usable GPU found, --gpu-layers option
will be ignored` since long before anyone read it. A Radeon RX 5700 XT,
7.75 GiB, RADV on Mesa 26.2.3 — and I had run `nvidia-smi`, got nothing,
and concluded there was no accelerator. **A negative result is only
evidence about the thing you measured.** SD-Turbo paints in 6.16 s at
512×512 and 3.61 s at 256×256. We generate at 256 because that is what a
40×24 glyph grid can actually show, not to save time.

### Red behaviours this cost, all now in the grimoire

- `/` **and** `divide` both return a `decimal!` for integer operands.
  There is no operator that quietly yields an integer.
- `copy` refuses a `char!` (same family as `length?` on a `char!`).
- `^` is not an operator; it parses as a word and yields `none!`.
- `pick` is 1-based, and `pick block 0` is `none!`.
- An **unparenthesised comparison is not what it looks like**: written
  inline, `if forge-luma a b c >= LIMIT [...]` reported LIT for a luma of
  81 against a limit of 128. The law in `AGENTS.md` said parenthesise
  every comparison. The law was right.

## v0.1.3 (2026-09-27) — the imp has a mouth

Real conjuring replaces the sample art. The chain is now:

```
wish ──▶ ask.red   writes /dev/shm/imp/imp-ask.txt  (key=value, one line each)
     ──▶ bridge.c  POSTs to 127.0.0.1:8082, parses the JSON, cures the reply
     ──▶ render.red reads imp-art.txt, reaps it to the grid, renames the frame
```

**The model is `qwen3-4b-instruct-q4_k_m`.** Chosen over the 8B
(`Huihui-Qwen3-8B-abliterated-v2`) on measured evidence: it is a *reasoning*
model, and its `<think>` block ate 2300 of 2483 characters counting the
widths of its own box-drawing characters. `enable_thinking: false` is sent in
`chat_template_kwargs` and **ignored by this llama-server build** — verified,
not assumed. With the 4B: no reasoning, 34 s, 10/10 lines inked, contract
satisfied. The 3B coder produced one 3000-character line of `▀`.

**The cure is deterministic and none of it is a lie.** Literal `ESC[` /
`\033[` / `\x1b[` / `\e[` become real 0x1B bytes; `<think>` is stripped;
fences and trailing blanks go. The model writes our notation instead of the
byte, and the imp corrects incompetent flesh. It does not pretend the flesh
was never incompetent.

**The grid is not negotiable.** The model can emit anything; `reap` is sealed
against the Python oracle and guarantees 12 lines of exactly 40 columns. The
art is the model's. The frame is ours. That is the whole design.

Three substrate findings, recorded in the grimoire as hazards 19–21:

- **`ASK` is a builtin.** `ASK: %file` fails silently; `write ASK …` then
  hands `write` a function and the file is never created. Every global is now
  prefixed `IMP-`.
- **A one-armed `either` is a silent fatal error** — and one sitting further
  down a file killed a run four lines *earlier*, so its failure point cannot
  be trusted.
- **The flakiness was mine.** `run_rite()` waited for the rite's *log file* to
  appear; `say` writes that log from the first statement, so the bridge
  SIGTERMed Red mid-rite and the demon died somewhere new every run. Rites
  passed under `rited` the whole time. The witness must be a single end
  product: the request file, or the frame itself via atomic `rename`.

`IMP_DEBUG_ART=1` keeps a copy of the cured art for diagnosis. It is **off by
default** — writing into the repo would be the filesystem noticing, and the
ceiling is absolute.

## v0.1.2 (2026-09-27) — the law amended, a real bug found

Docs rewritten against `docs/RED.md` and `docs/RED-PROJECTS.md`, the
research manuals kept locally. Two substantive outcomes.

**A real bug in the port, found via the manual's unexplained anomaly.**
`docs/RED.md` §16.1 recorded that `beast-allows?` rejected `1;31` under
`ansi16` although the source said it should pass. The cause was mine: the
allowlist read `all [v = 0 v = 1 v = 2 v = 22]`, which means *v equals all
four* and is therefore never true. The python original's
`x not in (0, 1, 2, 22)` is an **OR**. The port silently rejected every
`ansi16` code.

Fixed, and sealed by four new vectors (9–12) exercising plain SGR codes
under every style — the case the original vectors never covered. `rite-two`
now runs **twelve seals, all byte-exact**.

**The `parse` law is withdrawn.** `AGENTS.md` said *"the PEG `parse` is
excommunicated — never reintroduce it."* `parse` works: `logic!` is its
documented default return, `collect`/`keep` make it a full extractor. The
law was forbidding working, tested features. It now reads: `sever` is our
default splitter, `parse` is available for structured patterns, and
anything new goes through a rite first.

Also corrected: `split` is a builtin and was available all along; `none?`
exists; `make map!` works; `return` in a loop does leave the function. The
grimoire's hazard list is now numbered 1–18 and separates genuine
substrate behaviour from beliefs that were simply wrong.

## v0.1.1 (2026-09-27) — the demon breathes

**The delivery works end to end.** `imp "a wish"` and the interactive TUI
both paint a real frame.

- `src/bridge.c` — the body imp borrows. Owns the terminal (raw termios),
  the input loop, the spinner and every wait. Writes the wish to
  `/dev/shm/imp/job`, stages the rite in the Imp root, invokes `red-view`,
  waits for the atomic frame, paints it. One path: a scripted wish is
  summoned too, and **exit 0 means the vessel accepted the wish, not that
  art exists.**
- `src/frame.red` — leaf renderers (`top-border`, `divider`,
  `bottom-border`, `row`, `pad-to`, `repeat-chars`), the faeOS pink.
- `src/render.red` — reads the job, reaps the grid, assembles the frame at
  top level, writes `frame.tmp`, `rename`s it to `frame`. No loop: `sleep`
  does not exist and a demon that waits is a hung serpent.
- Both channels live in `/dev/shm`. The filesystem never notices.

Rite III answered five questions and closed the architecture: no `sleep`,
no FIFO, no stdout, `rename` works, one invocation costs **0.12s**. Hence
RPC-per-invocation — Red is a pure function, one process per action.

Two new hazards, one of them the hardest bug in the project:
- **`if` returns `none!` when false.** `pad-to` ended on a conditional, so
  every row needing padding rendered as the literal `none`. Four probes
  misread this as a parameter-binding fault. Hazard 15.
- **Comparisons need parentheses** in `if` (no precedence). Hazard 16.

`docs/GRIMOIRE.md` rewritten: the folklore is now corrected against
`docs/RED.md`, which found **seven claims false** — most consequentially
that `parse` is dead. It is not; it returns `logic!` by design and
extracts with `collect`/`keep`. The `parse` law in `AGENTS.md` needs a
human decision (§21 of the manual).

## v0.1.0 (2026-09-26) — the first descent

- Red 0.6.6 substrate adopted. The PEG `parse` is excommunicated in this
  build (returns `logic` for block rules); `sever` replaces it via `find`
  + `copy/part`.
- Art core **sealed**: `weigh-cell`, `unmake`, `sever`, `m-end`,
  `well-formed?`, `beast-allows?`, `flay-line`, `bare`, `true-span`,
  `reap`.
- Evidence: `./rited tests/rites/rite-two.red verdict.txt` — eight seals,
  every one **byte-exact** against the Python original across `unicode`,
  `ansi16`, `ansi256`, `truecolor` and `ascii`, plus CJK wide-cell
  parity and ANSI stripping.
- The wound kept on purpose: `ansi256`/`truecolor` strip `38;5;N` /
  `38;2;R;G;B`, because the allowlist advances the index by one and
  lands on an operand. Reproduced faithfully in `beast-allows?`;
  advancing by three would be *too correct*. `tests/oracle.py` proves
  the original behaves this way.
- Harness: `rited` (stages a rite in the repo root, casts it, prints the
  testimony), `build.sh`, `forge-redc` (compiler forge, **failed** —
  Red's build requires the proprietary `enpro` SDK binary; kept as a
  relic, see `docs/ORIGIN.md` §IV).
- Ten substrate horrors documented in `docs/GRIMOIRE.md` so the next
  hand does not bleed on them. The worst: the console loads scripts from
  its own cwd only, file-literal `append` is a silent no-op, `return`
  inside a loop does not leave the function, `if cond [a][b]` runs both
  sides, and a load error kills the whole script silently.
- Docs: `ORIGIN.md` (why it turned evil), `COVENANT.md` (the five tiers
  and the ceiling), `GRIMOIRE.md` (true names, wounds, and the exit).

## Holes

- TUI, gallery browser, PDF writer, llama-server client: not started.
- The GUI console accepts one instance and reports errors only in-window.
  Every rite must write its own testimony.
