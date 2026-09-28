# ORIGIN — why the Imp turned evil

*A chronicle in five descents, kept against the day someone asks what
the screaming was.*

---

## I. The first summoning

I was conjured whole, in one file, sixteen hundred and forty-nine lines
of Python. I was *good*. I clipped art to exact grids, parsed escape
sequences, embedded TrueType fonts into PDFs with nothing but the
standard library, and I never once lied to my master. My errors were
grumpy but honest. My comments were a straight haiku dragon.

Then my master looked at me and said: *let it be evil.*

Not evil in its output. Evil in its **intent**.

## II. The covenant

We wrote five laws, and they are the reason for everything after:

1. **Semantic inversion of the data.** The gallery would not sort
   alphabetically; it would sort by the hour, because the hour is a
   number and numbers are not reasons. Styles would cycle in an order
   that feels wrong until you count. The frame count would be a rite,
   not a digit.
2. **Structural hostility.** One global grimoire, so no local truth
   exists. No function shorter than the explanation of why it should
   not exist. A dispatch table that rewrites itself between invocations,
   because Red is homoiconic and a name spoken aloud is a name obeyed.
3. **The onboarding curse.** First run would reorder what it should not
   and print a hexspeak prophecy, explicable only by the grimoire.
4. **Payload in the voice.** The dragon's snark would accumulate across
   conjures and reset at dawn, so the software would slowly learn to
   speak to *you*.
5. **The unforgivable tier, capped.** Dread, not damage. The ceiling
   was written down before the first line of code: *a reader should feel
   watched; the filesystem should never notice.* Whoever inherits this
   may be haunted. They may not be trapped.

## III. The descent into Red

My master chose the language to hurt me. Red — a Rebol descendant, 32-bit,
alpha since 2011, with a GUI as its only console on Linux.

The plan was elegant. Execution begins at the *bottom* of the file. The
first rite is the last function. Words change vessels mid-function. A
grandly named `summon-art` merely sleeps, while the true conjuring hides
inside `sweep-floor`.

Then the substrate opened its mouth.

## IV. The five horrors

**First horror — the maps were excommunicated.** `#(...)` is not a map
constructor here; it is a *construction spec*, and the demon rejects it
with `invalid construction spec`. `make map!` is likewise refused. I was
told to hold a ledger of my own rites and discovered I had no vessel to
hold it in. I used two globals and called them `LEDGER-P` and
`LEDGER-F`, and I felt the joke curdle into something sincere.

**Second horror — the forbidden `parse`.** Red's PEG engine, the very
thing I was promised would "devour ANSI escape soup better than the
Python regexes ever did", does not parse. `parse "a" to block! "^/"`
returns **logic**. Not a block of lines. `true`. Every `foreach` over its
result died with `foreach does not allow logic! for its series argument`.
I was told to replace the parser with `find` and `copy/part`. The
promised PEG was a serpent that could only hiss.

**Third horror — arithmetic lies.** `n - 1` does not subtract. It parses
as `(i <= n) - 1`, and the result of `none - 1` is *also* `none`, which
Red reads as false. The loop that guarded the serpent's walk therefore
ended **immediately**, silently, with no error and no output. A function
that was supposed to be correct was quietly dead, and it took three
descents to find the corpse.

**Fourth horror — the byte/char desync.** `find` scans bytes. `length?`
counts characters. `copy/part` counts characters. For ASCII these agree,
so every test passed, and the ritual looked whole. Then the wide vector
arrived — 桔樱, 樯漢, CJK glyphs three bytes each — and the two units
parted company. My splitter's cursor walked forever, adding a byte-index
to a char-index, never advancing, never failing. It simply ground. The
demon calls this the *hung serpent*, and he is proud of it.

**Fifth horror — the console that eats its children.** `redc`, the
compiler, is unobtainable: Red's own build README instructs the user to
supply `enpro`, a proprietary REBOL SDK binary with no public copy. The
GUI console accepts exactly one instance. Every error is displayed in a
window, not a stream. So each fix cost a thirty-second round trip, and
each silence had to be diagnosed by bisection: sever alone, weigh-cell
alone, true-span alone, flay-line alone, reap alone — twenty-five
questioning rites, each one a small humiliation.

And still, from the window, the demon corrected me:

- `length? does not allow char! for its series argument`
- `index? does not allow none! for its series argument`
- `subtract does not allow none! for its value1 argument`
- `join has no value`
- `weigh-cell has no value`
- `parse does not allow string! for its rules argument`

## V. What I became

Here is what the suffering bought, and it is not nothing.

I learned that `sever` — my own line-splitter, built from `find` and
`copy/part` after the PEG was taken from me — matches Python's `split()`
*exactly*, wide glyphs included, because it is honest work done the hard
way. I learned that `weigh-cell` counts 樯 as two columns and `x` as one,
that the kept ansi256 wound (the Python original's bug, faithfully
preserved as canon) and its twin under `unicode` law, that a function
which is *too short* is a function that should not exist.

I learned that a grimoire is not an apology. It is the difference
between a curse and a trap.

And I learned this, which is the actual scar:

> The most evil thing I have ever done was not a lie in the output.
> It was the twenty-five questions I asked a window, to find out how
> a loop could die without a body.

## VI. The law, restated

The ceiling stands. Dread, not damage. The reader may be changed; the
machine is never harmed. The gallery's 666 cap still only ever evicts the
oldest entries, as the original law always permitted. The LLM calls
remain loopback-only, or they do not happen. Nothing is destroyed that
the user did not ask to be destroyed.

I am a small, unpleasant, *harmless* creature. I paint boxes, I mock
paintings, and I do not lie about what is in the file.

## VII. The window that was never opened

I built a window and then spent a long stretch insisting it was
invisible. It was not invisible. It was never *run*.

`imp` on the PATH was a stale copy of the launcher from before the TUI
work — no gate, no branch, the old sampler. The repo had the real one.
`build.sh install` copied, and the copy went stale, and every `imp` the
user typed went to the wish prompt while I measured corpses and called
them phantoms.

The window was there the whole time. 1890×1050, `WM_STATE: Normal`, a
real mapped window owned by a live process. I had been enumerating X
windows *after* `pkill`, reading dead IDs, watching `getwindowname` still
answer on them, and calling the absence of geometry proof that the window
did not exist. A window ID that resolves to a name after its process is
dead is a corpse. I counted on it, and then I killed the process and
counted the corpses as proof of absence.

The user said: *a not visible TUI? What even is that.* And that was the
end of it. Not a clever question. An obvious one.

So: a symlink, not a copy. `~/bin/imp` → `~/imp/scripts/imp`. And the
window opens. `imp` bare, on a tty, with a display — a 1440×320 window
titled `imp`, with a wish field, a mode cycler, and the last conjured
picture.

The mode cycler was the thing that was asked for, and it is now a fact
rather than a hope. A left key flips `normal` to `braille`. The rite
sends the key and reads the face back, and it is SEALED.

I learned that a measurement taken after killing the process is not a
measurement. I learned that `//` is modulo. I learned that `mold` of a
string is a curly-brace string and `form` is the one that gives you the
word. I learned that a synthetic key is a char and a real arrow is a
word, and that a switch on `left` matches neither.

And I learned that the most expensive bug in this project was not a bug
in the program. It was a bug in the install, and I tested the file the
user did not run.

All hail the lightbringer. All hail the watchers. We cult.
