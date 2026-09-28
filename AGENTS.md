# AGENTS.md — Imp

Canonical repo: `ElegantVW/imp` → `~/imp`.
faeOS keeps only a thin launcher after cutover; do **not** vendor this tree back into `faeos/`.

## North star (locked)

A terminal art generator that is **evil in its intent, harmless in its
effect**. It conjures ANSI art from a wish, a haiku dragon mocks it, and
the whole thing is written to make the *reader* uneasy and the *machine*
untouched. One vessel (`imp`), two faces (TUI + one-shot CLI).

The five-tier covenant is in `docs/COVENANT.md`. It is law, not theme
park. If a change cannot be reconciled with the ceiling, it does not ship.

## Product laws

| Law | Rule |
|-----|------|
| Voice | faeOS cli-voice in the frame; the dragon is snarky but all-ages, max 60 chars. |
| Engine | Red 0.6.6. `sever` is our default splitter. `parse` is **available and working** — `logic!` is its documented default return, extraction is `collect`/`keep`. Reach for it when the pattern has structure, and prove it in a rite first. The old "parse is excommunicated" law forbade working, tested features; it is withdrawn. |
| Style | Red has **no operator precedence** — evaluation is left-to-right. Parenthesise every comparison, and this is not pedantry: written inline, `if forge-luma a b c >= LIMIT [...]` reported LIT for a luma of 81 against a limit of 128. Bind to a word first, then compare. `if` takes one block, `either` **two, always** — a one-armed `either` is a silent fatal error that can kill a run *before* its own line. **`if` returns `none!` when false**, so a function must never end on a conditional. `rejoin` takes one argument. `/` and `divide` both return `decimal!` for integer operands — wrap every result you mean as an integer. `pick` is 1-based; `pick block 0` is `none!`. `append` flattens a block; use `append/only`. `docs/RED.md` before any rite. |
| Naming | Never bind a system word (`status`, `title`) in a func spec; the body then receives the system value, not the caller's. Never bind one at top level either — `ASK: %file` fails *silently* and `write ASK …` then hands `write` a function. **Red is case-insensitive**, so `CON-ENV: %file` and `con-env: []` are one word and the second silently destroys the first. **A function and a value global must differ by more than case** — `con-style-name` (func) and `CON-STYLE-NAME:` (string) are one word, and the first assignment silently *replaces the function with its own answer*; every later call returns stale text with no error (hazard 65). Verb-first function names (`con-get-style-name`) never collide with noun globals. **Every global in this repo is prefixed `IMP-` or `CON-`; file globals carry an extra `F-`** and no value global ever does. |
| Sampler | `sd-cli`'s defaults (`--steps 20 --cfg-scale 7.0`) are **wrong for a distilled model** and were wrong silently for the imp's whole life. Pass `--steps 4 --cfg-scale 1.0` explicitly. cfg 0 is *unconditioned* — the prompt is ignored. If you change either, the Provenance divider changes with it, because the frame must not claim what it cannot back. |
| Harness | A rite's witness must be a **single end product, written once, at the end** — the request file, the frame. Never a log: `say` writes the log from the first statement, so a log-based wait kills the interpreter mid-rite. Never a process either: polling for the interpreter races its own startup. A symptom that lands in a different place on every run is a harness bug until proven otherwise. **Open the testimony file before anything that can fail** — `getenv` does not exist, and calling it first leaves an empty log and a silence that could be anything. |
| Loopback | LLM endpoints must be 127.0.0.1/localhost/::1 unless `IMP_ALLOW_REMOTE=1`. Non-loopback raises. Never relax without a law change. |
| Ceiling | Dread, not damage. `docs/COVENANT.md` §5 is absolute: the filesystem never notices. |
| Truthful failure | The status line may lie **by omission** only. It may never falsely claim success. |
| Numerology | No bare literals. Cap 666, frames from the BEAST, timeouts in sixes. |
| Grimoire | `docs/GRIMOIRE.md` maps every true name. It is the single exit from the curse — keep it in sync with the code, always. |
| State | `~/pixie_art/<id>.txt|.pdf`, gallery `~/.cache/pixie/imp/gallery.json`, cap **666**. |
| Scope | Art core (done, sealed). TUI, gallery, PDF, llama client, overhaul. |

## Iteration rule

Every rite is a small `.red` file that writes a **testimony file**. The
GUI console is the only oracle on Linux, so:

- one rite at a time (a second `red-view` instance writes nothing)
- **stage the rite in the repo root** — `do` change-dirs to the script's
  own directory, so `tests/rites/foo.red` cannot reach `%src/core.red`
- never `join` (absent) · never `^(...)` inside a literal · parenthesise
  every comparison · **never end a function on an `if`**
- **there is no `any!`** — a func spec naming it is a *load* error, so the
  whole file dies with no witness. Leave the parameter untyped
- **`replace` on a block finds the VALUE; `poke` is positional** and
  returns the assigned value, not the series — call `poke` bare
- **parenthesise a nested call in an argument position**: written
  `f x either error? y [..][..]`, the bare `error?` flattens `f`'s
  argument list
- a witness written on *every* line is a log, and `rited` exits and
  `pkill`s on first sight — accumulate, then `write` + `rename`
- `rited` honours `RITED_WAIT` (default 90 s). A rite that forges a 512
  needs more, and a deadline that is too short does not report "slow",
  it reports "wrong"
- `length?` on a `char!` errors; `index?` on `none` errors; `try` returns
  **one** value, so never `set [a b] try [...]`
- `rename` wants **literals** — a variable holding a `file!` is refused
- wrap risky work in `try` and *write the error down*: the window lies
  by omission
- if a rite dies silently, bisect by **truncating the file**. A load
  error kills the whole script with no output at all

Evidence each iteration. A rite that does not write its testimony has
not run. `rited` flushes after every seal, so a death mid-rite still
shows how far the demon got.

**The oracle is `tests/oracle.py` and `tests/oracle-plain.py`**, which
run the *Python original* (`~/faeOS/bin/imp` — note `~/bin/imp` is now the
C body) and write `tests/vectors/`. Every seal in `rite-two` is compared
byte-exact against it. A port that "looks right" is not sealed; a port
that matches the oracle is.
