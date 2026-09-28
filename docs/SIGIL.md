# SIGIL — the house mark system

Every project in the house carries a mark: a small ASCII pictogram, rendered
into a 720×360 hero SVG, used on the README and on the Grove front page. This
file is the whole specification, so that a new project gets a mark that
belongs without anyone rediscovering the rules.

Canonical examples: `grove/assets/hero/` (ten of them), the `.txt` sources in
each repo's `assets/sigils/`.

---

## 1. The rules

| rule | value |
|------|-------|
| width | **max 7 columns** |
| height | 3–7 lines |
| alphabet | plain ASCII, no box-drawing, no Unicode |
| subject | one pictogram per project — a creature or an object |
| centring | each line centred independently, so the mark tapers |

A mark is an **object**, not a scene. The house has a wall, a lantern, a wave,
a hillfort, a face, a figure, a creature. None of them is a scene, and none
has a background.

## 2. The layout formula

The heroes are generated, not hand-placed. Every one obeys this, verified
across 3-, 4-, 5- and 7-line sigils:

```
sigil line i (0-indexed):  y = 161 + (i - (N-1)/2) × 30
name baseline:            y = y(N-1) + 86
tagline baseline:         y = name    + 30
```

The sigil block is therefore always **centred on y=161**, and the name sits a
**constant 86px** below the last sigil line. A 4-line mark lands on
`116, 146, 176, 206` with the name at `292` — which is exactly where
`mourama` and now `imp` sit.

## 3. The palette

Three values are fixed across every hero; the fourth is per project.

```
background   #1A1218      all ten heroes, no exceptions
name         #F0E4EE      30px, bold
tagline      #6B6FA8      16px
sigil        per project
```

Per-project accents in use:

| project | accent | | project | accent |
|---|---|---|---|---|
| bulwark | `#F0D8A0` | | fairy | `#E8C070` |
| kindling | `#D4B4E8` | | goblin | `#8FBF9A` |
| faeos | `#B08CC8` | | siren | `#8EC4C8` |
| grove | `#B08CC8` | | mourama | `#6B6FA8` |
| kur | `#FFF8FC` | | pixie | `#E8A0B4` |
| imp | `#C89BE0` | | | |

Taglines are lowercase, 3–6 words, and describe the thing rather than the
feeling: *haiku dragon, hatched* · *TLS-only mail spirit* · *five-seat Iberian
hillfort* · *a red port, sealed*.

## 4. The character budget — read this before drawing

**A house mark uses 1–5 distinct characters.** Measured:

| mark | lines | distinct chars |
|---|---|---|
| kur | 3 | **1** |
| siren | 5 | **1** |
| house | 5 | **2** |
| fairy | 6 | 5 |
| pixie | 7 | 5 |

`kur` is three rows of dashes. It is the floor of the house, and it is
trusted to work.

The first attempt at imp's mark used **seven** distinct characters — `( o ) \
^ _ /` — spread over a face, a body, a tail and a pitchfork. It read as
clutter, and no amount of redrawing fixed it, because the problem was not the
drawing. It was the budget.

**If your mark needs more than five distinct characters, you are drawing a
picture, not a mark.** Cut features, not detail. Two features maximum.

## 5. How to iterate

The method that produced the accepted imp mark, after two rejected rounds:

1. **Establish the budget first.** Count distinct characters before drawing.
2. **Work in the house's grammar.** `kur` is one character patterned; `siren`
   is one character patterned. Start there and add at most one more.
3. **Make every mark do two jobs.** A glyph that carries both a visual meaning
   and a semantic one is why the house's marks are worth having.
4. **Render it at 26px before accepting it.** Anything that dies at the real
   size was not a mark.
5. **Reject on principle, not taste.** "It does not belong to the set" is a
   usable reason. "I like it" is not a reason to override the set.

## 6. Research notes — what was consulted for imp

Recorded so the next agent does not repeat the search, and so attributions
travel with the ideas.

**Small devil ASCII** — Christopher Johnson's collection and asciiart.eu.
Recurring motifs at small sizes, all of them worth knowing:

| motif | note |
|---|---|
| `,` as horn tips | present in nearly every small devil; reads as horns at 7 columns |
| `^  ^/` | the fang/menace row — highest signal per character found |
| `\_\|_/` | a complete pitchfork in 5 columns |
| `\|0   0|/` | round eyes in a skull; better than `( o o )` |
| `( o o )` · `(OO)` · `3-n-` · `-+- -+-` | four weights of eye |
| `<\(__)>` | side horns without spending a row |

The general lesson from that corpus: **everything good in it is two features
maximum.** Detail dies at small size; negative space survives.

**Occult sigil grammar** — a sigil is not a portrait of a thing, it is a
compressed *name*. Ceremonial sigils were "the pictorial equivalent of a
being's true name." Three consequences:

- **The Sigil of Satan (Sigillum Diaboli)** is two vertical strokes with
  hooks, from the high priest's breastplate in Exodus 28. Two characters.
- **The Sigil of Lucifer** (Grimoire of Truth, 16th c.) is three elements and
  **two characters**: an `X` above for the physical plane, an inverted
  triangle for water, and a `V` at the bottom for **duality** — dark and
  light, male and female, converging.
- **Sigil casting** reduces an intention before drawing it: strip the vowels,
  drop repeated letters, then trace what remains into **one closed angular
  glyph**. The mark always closes, because a sigil is a seal.

**The consequence that changed imp's mark:** a sigil should close, and every
mark should carry meaning rather than depict. `imp` reduces to `mp` — two
letterforms — which is why the accepted mark is small enough to have been
derived rather than illustrated.

The accepted imp mark:

```
,   ,
 \ /
  X
 \|/
```

Five characters, four lines, five columns. `,`-horns, a descent, Lucifer's
`X` for the physical plane, and a three-column trident whose `V` still carries
duality — so the pitchfork is also the sigil element, doing two jobs.

## 7. Adding a project

1. `assets/sigils/<name>.txt` — the ASCII source of truth, in that repo.
2. Generate the hero with the formula in §2. Do not hand-place baselines.
3. Copy the hero into `grove/assets/hero/`.
4. Add an `<article class="app">` to `grove/index.html` **only once the repo
   is actually public** — an entry whose repo link 404s is worse than no
   entry.
5. Reference it from the README as `![Name hero](assets/hero/<name>.svg)`.
   Check the file exists. `imp`'s README referenced its hero for a week
   before the file was ever made.
