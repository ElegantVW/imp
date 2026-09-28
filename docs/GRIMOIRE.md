# GRIMOIRE — the exit

> ## ⚠️ SEVEN OF THE HORRORS BELOW ARE WRONG
>
> `docs/RED.md` — a sourced, execution-verified manual of this exact
> build — audited this file and found **seven claims false**. The most
> consequential: **`parse` is not dead.** It returns `logic!` *by
> design*, and extraction works via `collect`/`keep`. I read a correct
> default as a defect and exiled a working PEG parser out of the project.
>
> Most of the rest are not build quirks at all. They are **ordinary Red
> semantics that I did not know**: there is no operator precedence
> (left-to-right, per the official spec), `if` takes one block, `either`
> takes two, and `rejoin` takes **one** argument.
>
> **Read `docs/RED.md` before believing anything in this file.** What
> remains here that is genuinely true is the *runtime* behaviour: the
> silent load errors, the single console, the staging requirement, the
> no-op file append.
>
> Corrected entries are marked **[CORRECTED]**.

Every true name, mapped. The covenant permits exactly one mercy: a
reader may always find their way out through this file. If a name here
stops matching the code, **the code is wrong** — fix one or the other in
the same commit.

## The vessels (`src/core.red`)

| True name | Plain name | What it does |
|---|---|---|
| `BEAST` | the number | 6 × 111 = **666**. No bare literals exist in the codebase; counts derive from this. |
| `LEDGER-P` / `LEDGER-F` | passed / failed | The rite tally. Two globals, because `map!` is refused by this build. |
| `hold-rite` | assert | Record a seal. Returns `SEALED <name> :: <witness>`. |
| `weigh-cell` | char width | Columns a glyph occupies. `x` = 1, `樯` = 2, combining marks = 0. |
| `FALLEN` | the ASCII map | Box-drawing and stars, paired as `glyph replacement`, walked by hand. |
| `unmake` | to_ascii | Transliterate a glyph via `FALLEN`; unknown glyphs become a space. |
| `sever` | split_lines | Split a string on a delimiter. Replaces the excommunicated `parse`. |
| `m-end` | find_esc_end | Index of the `m` closing an escape opened at `i`, or `none`. |
| `well-formed?` | is_sgr | Is this a syntactically valid SGR sequence? |
| `beast-allows?` | style_permits | Does the target style permit this SGR? *(Keeps the Python wound — see below.)* |
| `flay-line` | clean_line | One normalized art line: escapes vetted, glyphs weighed, clipped and padded to width. |
| `bare` | strip_ansi | Remove all SGR, leaving cells. |
| `true-span` | visible_width | Visible columns of a line, using `weigh-cell`. |
| `reap` | normalize_art | The full grid: text → exactly `width` × `height` visible cells. |

## The wounds we keep on purpose

**Wound one — the `38` operand, in `ansi256` and `truecolor`.**
`beast-allows?` advances the index by one after admitting a `38` sequence,
landing on an operand that is neither `0` nor `1`, so `38;5;175` and
`38;2;R;G;B` are stripped and those two styles render monochrome. The
python original does exactly the same:

```
unicode: keeps_38_5=True    ansi16: keeps_38_5=False
ansi256: keeps_38_5=False   truecolor: keeps_38_5=False
```

**Wound two was a bug I wrote, and it is now healed.** The `ansi16`
allowlist read `all [v = 0 v = 1 v = 2 v = 22]` — "v equals *all four*" —
which is never true, so it rejected every `ansi16` code, `1;31` included.
This file previously claimed `ansi16` was "unaffected" by wound one.
**That was wrong twice over**: `ansi16` legitimately has no `38` in its
allowlist, so it rejects `38;5;N` for an honest reason rather than the
wound — *and* the port itself was broken. `docs/RED.md` §16.1 recorded
the `1;31` anomaly without explaining it. The cause was an `all` where
the original has an "is one of". Fixed, and sealed by four new vectors
that exercise plain SGR codes under every style.

**Do not "fix" wound one by widening `ansi16`.** They are different
things. To heal wound one, advance the index by three (or five) in
`beast-allows?` **and** update the rite. Never quietly.

## The hazards of this substrate

Corrected against `docs/RED.md`. Truthful about which are build quirks
and which are simply Red.

| # | Horror | The excommunication |
|---|--------|----------------------|
| 1 | Maps | **[CORRECTED]** `#()` is a *construction spec*. `make map!` is refused. The advice (globals or a walked block) stands. |
| 2 | `parse` | **[CORRECTED — FALSE]** `parse` is **fully functional**. It returns `logic!` because that is the documented default; extraction needs `collect`/`keep`. Do not excommunicate it. |
| 3 | Arithmetic | **[CORRECTED]** Not a build bug — **there is no operator precedence in Red.** `x = y - 1` is `(x = y) - 1`, per the official spec §5.2. Parenthesise. |
| 4 | Bytes vs chars | **True.** `find`/`index?` count bytes; `length?`/`copy/part`/`pick` count characters. A `樯` is 3 bytes, 1 character. |
| 5 | The console | **True.** One instance. Errors go to a window, not a stream. Every rite writes a testimony file. |
| 6 | Subdirectories | **True.** `do` change-dirs to the script's own directory, so a rite in `tests/rites/` cannot reach `%src/core.red`. `rited` stages every rite in the Imp root. |
| 7 | File-literal `append` | **True.** `append %file.txt "x"` is a silent no-op. Build the whole string, write once. |
| 8 | `return` in a loop | **[corrected] FALSE.** `return` inside a loop *does* leave the function, in every loop form, and does not spin. The Red sources use it ~95 times. The no-`return` rule in `core.red` is **style, not necessity** — kept because the core is sealed and the discipline is good, not because the language demands it. The comment in `core.red` has been corrected in place. `RED-IDIOMS.md` §0. |
| 9 | Two-block `if` | **[CORRECTED]** `if` takes **one** block; the second leaks into the next statement. This was real, and `either` is the fix. |
| 10 | Load errors are total | **True.** A parse error kills the whole script with no output. Bisect by truncating. |
| 11 | `rejoin` arity | **Real, and the frame bug.** `rejoin` takes **one** argument (`block [block!]`). `rejoin panel "^/"` returns a one-character corpse. Interleave separators into a block, then rejoin once. |
| 12 | `set [a b] try [...]` | **Real.** `try` returns one value; splitting it across two names is itself an error. Take one value and test it with `error?`. |
| 13 | `global` | **Real.** No such function. Module globals are assigned with plain `LEDGER-P: LEDGER-P + 1`. `hold-rite` was dead code until this rite. |
| 14 | `rename` arguments | **Real.** A variable holding a `file!` is fine for `write` but is **refused** by `rename`. Pass literals. |
| 15 | **`if` returns `none!` when false** | **Real, and it wore a disguise.** `pad-to` ended on `if (d <= 0) [copy s]`, so every row that *needed padding* returned `none!` and rendered as the literal text `none`. Rows long enough not to need padding worked — which is why this looked like a parameter-binding bug for four separate investigations. **Never end a function on a conditional.** Assign inside the branch, return the variable. |
| 16 | Comparisons need parentheses | **Real.** `if d > 0 [...]` is not a comparison guarding a block. With no precedence the comparison must be parenthesised: `if (d > 0) [...]`. |
| 17 | `all` is not "is one of" | **Real, and mine.** `all [v = 0 v = 1 v = 2 v = 22]` means *v equals all four* — never true. The Python original's `x not in (0,1,2,22)` is an **OR**. I wrote the AND and it silently rejected every `ansi16` code, `1;31` included. Found only because `docs/RED.md` §16.1 flagged the anomaly without knowing its cause. |
| 18 | `split` exists | **Corrected belief.** `mold (split "a,b,c" ",")` → `{["a" "b" "c"]}`. A builtin splitter was available all along. `sever` stays — its behaviour is byte-verified against the oracle and the sealed rites depend on it — but new code should try `split` first and prove it in a rite. |
| 19 | The namespace is not empty | **Real, and it bites silently.** `ASK` is a Red builtin — the input prompt. `ASK: %/dev/shm/imp/ask.txt` does **not** bind: no error, no complaint. Every line then works on the *builtin*, so `write ASK "…"` hands a function to `write` and the file is simply never created. Cost: one rite that computed its 935-byte request correctly and then vanished without a trace. **Every global in this repo is prefixed `IMP-`.** `ask.red` and `render.red` do this and should never stop. |
| 20 | One-armed `either` | **Real, and worse than it looks.** `either` takes **two** blocks; there is no "no else" form. A one-armed `either` is a fatal error with no message — the log simply stops. Measured: with one armed, the log ended at `grid 719` (the `grid` is the line *before* it, so the death is exactly at the `either`). **But the failure point is not reliable**: an earlier build with the same one-armed `either` further down the file died at `reap`, four lines *earlier*, never reaching the malformed call. So a script containing one cannot be trusted to fail where it is wrong. Always two blocks. |
| 21 | A log is a diary, not a bell | **Real — and mine, not the substrate's.** `run_rite()` in `bridge.c` waited for the rite's **log file** to appear before killing the interpreter. But `say` writes that log from the *first* statement, so the file existed a millisecond after launch and the loop SIGTERMed Red while it was still painting. The symptom was a demon that died at a different line on every single run, which reads exactly like memory corruption and is not. **A witness must be a single end product, written once, at the end**: `ask.red` is witnessed by the request file, `render.red` by the frame itself (atomic `rename`), both unlinked first so existence means *this* run. Diagnosing this cost more time than the feature it delayed, which is the argument for measuring the harness before trusting the symptom. |
| 22 | `call` is the door, and `/output` is a painted one | **Real, and the most consequential entry in this file.** `call` EXISTS — `call/wait` returns genuine exit codes (`0` for `/bin/true`, `1` for `/bin/false`, `255` for a missing binary) — and `/shell` redirection **works**: a Red script can run any program, write its output to a file, and read that file back. Pure Red can therefore do HTTP, drive other models, and poll, with no C bridge, no FFI, and no rebuilt interpreter. **But** `/output` and `/error` are in the spec and **completely inert in this GUI build**: `/output out: %file "/bin/echo hi"` creates nothing, and `/output out: <string> …` leaves the string empty. The spec is not the implementation. Always give the *shell* the redirect. |
| 23 | `call` is asynchronous unless you say so | **Real, and mine.** The spec reads `return: [integer!] "0 if success, -1 if error, or a process ID"`. Without `/wait` you get a **PID** — I measured `265740` and `265741` for two different commands — and every captured string came back 0 bytes. I read that as "no I/O is possible" and nearly wrote off the entire pure-Red path on a race. `/wait` turns the same two calls into `0` and `1`. |
| 24 | No `write-binary`, no `load/library`, no `ffi` | **Real.** `write-binary` → `id: 'no-value` (absent). `load/library` → `invalid-path-get` (absent). The `ffi` dialect is absent, and `red-view-src/modules/` contains only `view` — FFI lives in a separate repository and was never merged. There is no way to call `libz`, or any foreign symbol. **So the consequence is a design decision, not a defeat**: the imp's image decoder must be written *in Red*, and that library is now the assignment. |
| 25 | Bytes are first-class after all | **Real, and it opens the door.** `read` on a file of raw bytes returns a `string!`, not `binary!`, but `pick` addresses individual bytes and yields a `char!` — `#"^@"` for NUL, verified against a file of four NUL bytes made by `head -c 4 /dev/zero`. So a pure-Red `inflate` is feasible: read, `pick`, `to integer!`, reconstruct. It will be slow and it will be Red, which is the point. |
| 26 | `try` hands you the whole error | **Real, and quietly enormous.** A caught error carries `code`, `type`, `id`, `arg1..3`, **`near`** (the source form that failed) and **`where`** (the function it failed in). Hazard 10 is not "the substrate swallows errors" — it swallows them into a *window*. A Red program that wraps its risky work and writes `mold` of the error can report its own failures precisely. The `say`-the-error law was right all along and now has teeth. |
| 27 | The GPU was there the whole time | **Real, and it was never Red's fault.** `llama-server` had been logging `no usable GPU found, --gpu-layers option will be ignored` since long before anyone read it. A Radeon RX 5700 XT with 7.75 GiB, `amdgpu` resident, RADV on Mesa 26.2.3. I had run `nvidia-smi`, got nothing, and concluded there was no accelerator. **A negative result is only evidence about the thing you measured.** SD-Turbo paints a 512×512 image in **6.16 s** on it. |
| 28 | **RED IS CASE-INSENSITIVE** | **Real, silent, and the nastiest one here.** `CON-ENV: %/dev/shm/imp/imp-env.txt` and later `con-env: copy []` are **one word**. The empty block silently overwrote the file literal, and the symptom was `read` failing with `id: 'expect-arg, arg2: block!` — "you passed a block where a file was wanted" — which says nothing about the actual cause. `CON-IMG`/`con-img` and `CON-ART`/`con-art` were the same trap. **A file global and a value global may never share a name in any case.** Files now carry `F-` (`CON-F-IMG`) and values do not. This is the sibling of hazard 19: both are silent rebinding, and both hide behind a completely unrelated error message. |
| 29 | `getenv` does not exist | **Real.** `mold :getenv` → `unset`. Calling it at the top level kills the script **before it can write a word of testimony**, which is the least useful failure mode a language has: an empty log and a silence that could be anything. So the launcher writes down what it knows as `key=value` lines and the rite reads them off disk — the contract `ask.red` already used, arrived at again from a different direction. **Open the ledger before anything that can fail.** |
| 30 | `append` flattens a block | **Real.** `append con-env reduce [key value]` appends **two** elements, not one pair. Five `key=value` lines became ten loose words and every lookup read the wrong slot (measured: `env-entries 10` for 5 lines). Use `append/only`. |
| 31 | `/` and `divide` both return `decimal!` | **Real.** Given integer operands, *neither* yields an integer — `forge-luma 255 255 255` returned `254.745`. There is no operator in this build that quietly gives you an integer; every boundary and every mean needs an explicit `to integer!`, or a helper that does it in one place. |
| 32 | `copy` refuses a `char!` | **Real.** `s: copy forge-esc` → `id: 'expect-arg, arg2: char!`. Same family as `length?` on a `char!`. `to string!` first. |
| 33 | `^` is not an operator | **Real.** Written as `2 ^ n` it parses as a *word* and yields `none!` (`id: 'no-value, arg1: '^`), which then poisons the arithmetic. Precompute the weights in a block. And `pick` is 1-based, so `pick FORGE-BITS 0` is `none!` — the same class of silent nothing. |
| 34 | A harness must not race its own startup | **Real, and mine, third variation.** The launcher started the interpreter in a background subshell and then broke out of its wait loop if the process was absent. On the **first poll, 0 ms later**, the interpreter is not in the process table yet — so the launcher declared failure and exited **while the rite went on to paint a complete 18 KB frame, orphaned, 200 seconds later.** Observed as `exit 1`, a perfect frame on disk, and a log ending in `DONE`. The frame is the witness; the deadline is the only backstop. Same family as hazards 21 and 22: *a witness must mean what it says, or it is worse than no witness.* |
| 35 | **`red-view` cannot compile `"\""` — anywhere** | **Real, total, silent, and the most expensive thing I learned this session.** One escaped double quote in a string literal makes the **whole file fail to load**. Measured three ways: `t: "\""` as a bare statement → load fails. `replace s "\"" "y"` → load fails. `replace s "\\" "x"` → **fine**. So the one sequence every json string requires is unusable, and the symptom is indistinguishable from a hang: red-view sits on a dialog, no log is ever written, and the launcher waits out its full deadline. Cost: four wrong theories and an hour, ending only with a mechanical bisection (OK to line 212, FAIL at 217). **Build the character as a value — `to string! to char! 34` — and never write the escape.** |
| 36 | `to-json` serialises word NAMES, not values | **Real.** `to-json [alpha "one" beta two]` → `["alpha","one","beta","two"]` and `to-json make map! [model model-name]` → `{"model":"model-name"}`. **A variable becomes its own name in the output.** The json encoder is therefore useless for any request with a runtime value in it — which is every request worth sending. Read-only decoding via `load/as %file 'json` is excellent (a `map!`, nested maps, `doc/choices/1/message/content` by direct path, 424 chars measured) and is what the imp uses. So: **read json with the codec, write it by hand.** |
| 37 | `replace` with a one-character needle replaces only the FIRST | **Real.** Input `say "hi" now` came back as `say \"hi" now` — one of two quotes escaped. An escaper built on a single `replace` would have emitted **invalid json for any wish containing two quotation marks**, and the failure would have been a server-side 400 blamed on something else. Loop until `find` returns nothing. |
| 38 | A parse error from the *server* beats the substrate's silence | **Not a hazard — a method.** When the mouth was refusing my hand-built json, llama.cpp answered with `parse error at line 1, column 16: syntax error while parsing object key - invalid literal; last read: '"imp",m'`. That named the column, the offending token and the expectation, in one line, after Red had told me *nothing* for four separate attempts. Red's silence is not the only silence in the system; **a program that talks back is a better oracle than one that only fails.** Read the error you are getting, not just the one you expected. |
| 39 | **`pad-to` only ever pads — a contract enforced nowhere** | **Real, and it is the frame-width bug.** `reap` guarantees the *art* grid: 12 lines of exactly 40 columns, sealed byte-exact. The frame around it had no such guarantee, and so a 66-character mockery went into a 56-column body and came straight through: the shipped frame measured **81 columns inside a 60-column frame**. The borders were the same mistake quieter — `inner = w - 2` where the arithmetic needed `w - 3`, so every border and labelled divider was 61. **A guarantee made by a callee and trusted by the caller is a hope.** `row` now clamps (`clamp-to`: cut at the last space that fits, mark it `…`) and the two divider branches take *different* widths, because a labelled divider is 3 fixed glyphs and an empty one is 2. Sealed by `tests/rites/rite-frame.red` against hostile input: empty, exact-fit, and 200 characters of `x`. |
| 40 | **An inverted arm is worse than no seal at all** | **Real, and mine — three times, in three files.** `either ok [BROKEN][SEALED]` with `ok` true when the frame was *correct* wired `true` to BROKEN, so the rite printed SEALED one line after recording an offender. `rite-forge-one` had the same shape *and* could only see its last iteration (`foreach ln gl [if (true-span ln) = 40 [ok: false][ok: true]]` — arms backwards, `ok` clobbered every pass), and printed `false`, which is what a healthy grid prints. **A seal that agrees with you is not a seal.** So: name the boolean after the *conclusion* (`all-good`, never `ok`), state the two arms as sentences first, and have the check accumulate offenders by name — `BAD at [7:59 9:60]` — rather than reduce to a truth value nobody can audit. |
| 41 | A measurement that measures the grid is worse than no measurement | **Real, and mine.** I wanted "how many pixels did the threshold light" and wrote it as *count non-space glyphs*. A blank braille cell is `U+2800`, not a space. The answer was **480** — every cell in a 40×12 grid — and it read like a healthy result. Then the control (`forge-ramp`) printed `nonenonenonenone…`: I had written `(lum * len - 1) / 255`, and `/` returns `decimal!` (hazard 31), so `pick ramp 1.7` was `none!`, which appends as the literal text `none`. **The instrument was broken in the direction that flattered the thing being measured.** There is no count in `rate-compare.red`; it writes three renderings and the reader looks at them. |

| 42 | **`any!` is not a word** | **Real, total, and the most expensive single character in this file.** `note: func [k [string!] v [any!]]` is a **LOAD** error, not a runtime one: the whole script dies, writes nothing, and leaves no witness. There is no `any!` in Red 0.6.6. Cost: four rounds of bisection in which every instrument was broken in a different way, and the fault never moved — see hazards 44 and 45 and the note under `rited`. Write the spec untyped. |
| 43 | **`replace` on a BLOCK finds the VALUE** | **Real, and it looks exactly like the positional thing you want.** `replace [1 2 3 2 1 2] 3 99` → `[1 2 99 2 1 2]` (it found the 3), and it mutates in place as well as returning the block, which makes it *look* positional. But `replace hist 4 (c + 1)` against a histogram of zeros looks for the value **4**, finds none, and changes **nothing** — no error, no complaint. `forge-otsu` was written that way, so its histogram stayed all zeros and it was about to return a confident wrong threshold. **`poke` is the positional one**, and it returns **the assigned value, not the series**, so `hist: poke hist k v` would rebind the histogram to a number and destroy it — call it bare. Neither `poke/only` nor `replace/only` exists (`id: 'no-refine` on both). This is hazard 37's cousin: same function, same "only the first" family, different costume. |
| 44 | **A witness written on every line IS a log** | **Real, mine, and the second time this repo has learned it.** `rited` treats a non-empty witness as the end of the rite: it prints the testimony, exits, and `pkill`s red-view. So a rite whose `note` rewrites the whole ledger on every line gets **killed mid-flight**, and the result is a rite that reported `D3` on one run and `D4` on the next — which reads exactly like nondeterminism in the code under test. The law already said *a witness must be a single end product, written once, at the end*; the fix is to obey it literally: accumulate in a block, then `write` a temp file and `rename` it into place so the poll can never catch it half-written. Progress goes to a **different** file that nobody waits on. |
| 45 | **A threshold computed from `pick img 1..n` is a threshold computed from the top edge** | **Real, and it survived a whole session of confident numbers.** The sampling loop was `while [i <= sw * sh][ pick img i ... ]`, which for a 512×512 source is pixels 1–3840: **the first seven rows**. So every "picture mean luma" ever reported — 42, then 110 — was the mean of a strip along the top edge, and on a picture whose top is storm sky that strip says nothing about the picture. It surfaced only because Otsu and the mean appeared to disagree wildly while *both* reporting 110: the mean's output file on disk was stale, left by an earlier run whose mean variant had thrown. Sample on a grid across the whole image. And write the test so it can **fail against the bug**: the first version used a 20×20 picture with a 20×20 grid, so `sw*h == w*h` and both samplers read every pixel — a test that passes against the bug is worse than no test, because it is a promise. |
| 46 | **A bare word-function as a condition flattens the enclosing argument list** | **Real.** Written `note "D5" either error? wrote ["threw"] ["SEALED"]`, Red does not treat `either` as one nested call. `error?` is a bare word-function, so the argument list flattens and `note` is handed six arguments instead of two. It dies — and because it was the last line before the final write, the whole rite produced no witness and presented as a **timeout**. Every other site in the file parenthesised its condition, which is why only that line failed. Parenthesise a nested call in an argument position, or bind it to a word first. |

## The hand was never weak. The sampler was.

Not a hazard — a **correction**, and the most consequential thing in this
file, because for a full session the imp blamed the model.

`sd-cli` was being called with no `--steps` and no `--cfg-scale`, so it
used its defaults: **20 steps, cfg 7.0**. SD-Turbo is a *distilled,
guidance-free* model: it is trained for a handful of steps with no
classifier-free guidance. A fixed 128 threshold producing "coloured blobs"
was never a threshold problem and never a model problem. Measured on one
wish, same seed, same 256×256, in `/tmp/opencode/abl`:

| | what came out | wall |
|---|---|---|
| 20 steps, cfg 7.0 | flat cartoon, hard black outlines, orange lighthouse — a 2005 web graphic | 4.3 s |
| **4 steps, cfg 1.0** | **a photograph**: cliff, real waves, atmosphere, branching lightning | **1.6 s** |

Better *and* faster. Both values are now passed explicitly, and the
Provenance divider states them (`hand: sd-turbo 512x512 4sp cfg1`)
because the line used to say `256x256` while the sampler silently ran at
something else — a claim incomplete in the one direction that mattered.

**cfg 1.0, not 0.0.** cfg 0 puts sd-cli in *unconditioned mode* and the
picture ignores the prompt entirely. sd-cli says so itself:

```
[WARN] unconditioned mode, images won't follow the prompt
       (use cfg-scale=1 for distilled models)
```

Which is hazard 38 for the third time: **a program that talks back is a
better oracle than one that only fails.** Read what it is telling you.

At 512×512 and 4 steps the wall time is 2.8 s, so the old fear that "512
blew a 560 s budget" is dead — it was measured at 20 steps. The forge
costs the same either way, because the braille samples a fixed 80×48 grid:
a 512 source means 6.4×6.4 source pixels per dot instead of 3.2×3.2, which
is strictly more detail per cell and not more time.


## Not hazards — the manual corrected these as well

`none?` **exists**. `make map!` works; `#()` is a constructor. `and`/`or`
exist as bitwise `op!` (not Rebol's). `return` inside a loop *does* leave
the function. `forall` genuinely errors; `case/else` genuinely does not
exist. `parse` works. Full table in `docs/RED.md` §19.

## The forge is not sealed, and here is exactly what that means

`src/core.red` is sealed. Twelve rites compare it byte-exact against
`tests/vectors/`, which come from the Python original. That is a real
seal: if the port drifts, the diff is a byte diff.

`src/forge.red` is **not**. And the honest reason is structural, not
excuse-making: **the seal requires an oracle, the oracle is the Python
original, and the imp is now pure Red.** `rite-forge-one` checks that
the forge emits 12 lines of 40 columns and that `reap` accepts the
result. That is *looks right*. The house law says looks-right is not
sealed, and the house law is right.

What can honestly be claimed, and no more:

1. **The grid contract is sealed by composition.** `reap` sits
   downstream of the forge and is byte-exact against the oracle, so
   whatever the forge emits is forced into 12 lines of 40 columns by a
   sealed function. The *contract* is sealed. The *glyph choice* — which
   dots are lit, which colours — is not.
2. **The pixel sampling is checkable against the image itself.** A
   forge that invented colours would produce a frame whose colours
   match no pixel of the png it read. That is a real, cheap property,
   and it is not currently written as a rite.
3. **A human looking at it.** Weak, and admitted as weak.

So the strong claim is available for the *contract* and the weak claim
for the *art*, and the right move is to stop describing the second as
the first. `build.sh forge` prints the word **NOT** in its own header
for this reason.

**The tempting wrong fix** is to write a second forge in Red and
compare the two. That would be an oracle written by the same author
with the same blind spots, and it would be theatre. The only honest
independent judge is one written by someone else, in another language,
who is not me.

## A misdiagnosis, kept on the record

For four probes I was certain the bug was *functions*: the identical
sequence (`panel: copy []`, `append`, `rejoin`) gave a correct 674-char
frame at top level and a one-char corpse inside `build-frame`. I moved
the whole frame assembly to top level and wrote that down as a measured
property of this build.

**It was wrong.** The top-level assembly showed the *same* three `none`
rows. The real cause was hazard 15 — a function ending on a false `if` —
which has nothing to do with scope. The top-level move is harmless and
stays, but the stated reason was fiction and would have misled the next
hand.

The lesson worth keeping: I had a theory that fit four observations and
explained none of the exceptions. The exception *was* the clue — comment
(60 chars) and rune-2 (61) rendered; rune-1 (45), orders (22) and note
(19) did not. Those are exactly the rows that needed padding. Four probes
chasing scope while the data was shouting *length*.

## The second misdiagnosis: the demon that died in a different place each time

Worse, because for a long time I blamed the substrate.

`render.red` under the bridge died mid-rite, and **never in the same
place**. Sometimes the log stopped after `art-source`, sometimes after
`grid 719`, sometimes at the frame. Rites run through `rited` — which
waits 90 seconds — succeeded every single time on the *same files*. That
split is the tell: if the code is guilty, the harness is irrelevant. It
wasn't the code. It was my harness.

The evidence that finally killed the theory, in order:

1. A probe replicating `render.red`'s exact sequence, step by step, with
   a witness after each call, passed completely. Same art, same
   functions, same arguments.
2. A/B on the one-armed `either` I suspected (hazard 20) — reverted
   while the bridge was untouched, and it still failed. So not that
   either, at least not on its own.
3. Finally: read `run_rite()` instead of reading Red.

`run_rite()` waited for the rite's **log file** to exist, then killed
the interpreter. `say` writes that log from its first statement. The file
appeared instantly; the SIGTERM followed; the rest of the rite was
murdered mid-sentence. Sometimes the race landed after one `say`,
sometimes after three — hence a demon that died somewhere new every run,
which is precisely the shape of memory corruption and precisely not
memory corruption.

Three conclusions I am keeping:

- **A witness must be an end product, not a progress report.** The frame
  is published by an atomic `rename`, so it can never be half a picture.
  That is not just tidiness; it is the only reason the relay was safe.
- **A symptom that changes shape between runs is a harness bug until
  proven otherwise.** "Unstable" is not a property of Red. Red ran the
  same rites correctly the whole time; it was being shot.
- **The mirage is seductive** precisely because a flaky substrate is a
  comfortable explanation. The real bug was in code I had just written,
  and I spent the time looking at code I hadn't.

Also absent or hostile: `join` (use `rejoin`), `and`/`or`, `none?`
(use `= none`), `sleep`, `first` in expression position over a block of
lines (use `pick`), `forall` (does not work), `case/else` (absent).
`length?` on a `char!` errors; `index?` on `none` errors; `exists?`
wants a file literal.

## The threshold was a wrong model, not a tuning miss

The third misdiagnosis, and the only one that turned out to be about the
art rather than about the program.

Four wishes were conjured with the evidence kept — wish, prompt, the
256×256 png the model actually painted, the braille the forge made of it,
the frame (`scripts/imp-eval.sh`, which is a *development tool*: the
program still writes nothing outside `/dev/shm`, see covenant §5). Reading
a png beside its braille says more than staring at braille does:

| wish | source | what the threshold did |
|------|--------|------------------------|
| a lighthouse in a storm | night, most samples far below mid-grey | sparse; the tower and the wave band survived, the darks were empty |
| a fox asleep in a field of white flowers | bright, saturated | **dense, and faithful — to a source that was already a smear**, because sd-turbo at 256 px produced blobs |

So the forge was not losing the picture. It was losing *texture in the
darks*, and `FORGE-LUMA-MID: 128` was why. The instrument that settled
it was one number from `tests/rites/rate-compare.red`:

```
A0 picture-mean-luma: 42
```

The picture's own mean luma is **42**. The threshold was **128**. That is
not a tuning miss, it is a wrong *model*: a fixed 128 quietly assumes the
picture sits in the middle of the range, and a diffusion model picks its
own exposure and is not obliged to oblige.

The fix is one extra pass over the samples — threshold at the picture's
own mean, `forge-braille-mean` — with `forge-braille` (fixed 128) kept
alive as the baseline it was measured against. Rendered at 80×48 the
difference is not subtle: the wave band went from a scattered line of
dots to a solid mass, the tower read, and the darks have texture.

The honest limit: this is the *cheap* local threshold. Sauvola, or a
5×5-cell window, would be better and costs about twelve times as much in
Red. `forge-braille-at` takes the threshold as an argument precisely so
the expensive version can replace the cheap one without a rewrite.

And the control earned its keep. `forge-ramp` — grey levels as a ramp,
no threshold at all — makes the reduction to 40 columns legible on its
own, which is the evidence that the *grid* was never the limit:

```
  @Xs   ,;iiirrri;,,,,.            ..          ← the tower
  3;;.,:rX5MGSSSS###G32s;isssssr:.,::::,.     ← the wave band
```

What remains, and is not the forge's fault: at 256 px a complicated wish
comes back as coloured blobs, and the braille is faithfully a picture of
blobs. The forge is honest. The upstream render is the weak link.

## The substrate's answers (Rite III)

Five questions, five rites, five answers. This is the load-bearing
table of the whole delivery design.

| Question | Answer | Consequence |
|---|---|---|
| Can Red `sleep`? | **No** — `no-value` error | Red cannot wait. Nothing in Red may loop on time. |
| Can Red read a missing file? | **Yes**, with `try` — `cannot-open` is catchable | Polling is *possible*, if something else does the waiting. |
| Can Red `rename`? | **Yes** — returns `true` | The atomic frame swap is viable: write `.tmp`, rename, and the reader never sees a half-frame. |
| Can Red read a FIFO? | **No** — `read` refuses non-regular files (`cannot-open`) | No blocking input. Red is a **batch** processor, never a server. |
| Can Red `write/binary`? | **Unresolved** — hung | The PDF rite is blocked until this is answered. |
| What does one invocation cost? | **0.12s**, cold and warm | Cheap enough to call Red once per user action. |

### The shape that survives

Red cannot wait, cannot block, cannot read a pipe, and has no stdout.
It can compute, and read/write/rename regular files. Therefore:

> **Red is a pure function. One process per action. ~120ms each.**

The bridge owns the terminal, the input loop, the spinner and every
wait. It hands Red a job file; Red answers with a frame file and exits.
No polling in Red, no pipe, no event loop — just files, `rename`, and
a cheap process.

**A Red bridge is impossible.** This is a substrate prohibition, not a
matter of taste: the demon has no `sleep` and cannot open a pipe, so he
cannot be the thing that breathes. The *mind* is Red — the art, the
snark, the covenant, the wounds. The *body* is borrowed. See
`DESCENT.md`.

### One correction to our own folklore

`try` returns a *single* value, not a `[result error]` pair.
`set [a b] try [...]` assigns the same thing to both names, so every
rite using that pattern was reading a lie — including this document's
first draft. Take the one value and test it with `error?`.

## The ledger

A rite's testimony is written to `verdict.txt` / `harvest.txt` in the
repo root and is flushed after **every** seal, because horror 7 means a
rite that dies mid-way tells you nothing unless it was already talking.
`./rited tests/rites/rite-two.red verdict.txt` is the one that matters.

Last full testimony:

```
beast 666
SEALED grid 3            SEALED c0
SEALED unicode          SEALED ansi256
SEALED ansi16           SEALED truecolor
SEALED plain-ansi16     SEALED plain-unicode
SEALED plain-ansi256    SEALED plain-truecolor
SEALED bare             SEALED wide
DONE
```

Twelve seals, every one byte-exact against the python original
(`tests/oracle.py` and `tests/oracle-plain.py`). The four `plain-*` seals
were added after hazard 17: they exercise ordinary SGR codes such as
`1;31`, which the original vectors never touched, and they are the seals
that would have caught it.

## The exit

If you are lost: every rite writes what it did to a file, every function
is listed above, and the ceiling in `COVENANT.md` §5 guarantees nothing
was harmed. Close the console. The imp is a drawing tool with manners
worse than its manners.

The language these rites are written in is documented, measured on the
interpreter we actually ship and cross-checked against the official
specification, in [`RED.md`](RED.md). Read it before you write another
rite — several entries in this file have been corrected there, and the
corrections are marked **[corrected]**.

## ⚠️ [corrected] Two beliefs in this file are wrong

Both are recorded in `RED.md` with evidence. Neither has been acted on
here, because this file is the map and `AGENTS.md` is the law.

**1. `parse` is not dead.** The second horror above says *"`parse` returns
`logic` for a block rule. It is dead."* The official parse specification
says `logic!` is the **documented default** return, and that a `collect`
rule makes `parse` return a block instead. Measured on our build:

```
mold (parse "abc" [collect [some [keep skip]]])  →  {[#"a" #"b" #"c"]}
mold (parse [a b c] [collect [some [keep word!]]])  →  [a b c]
```

The parser is a full PEG implementation — search, validation, extraction,
modification. `sever` is good work and should stay as our default
splitter. But `AGENTS.md`'s *"The PEG `parse` is excommunicated… Never
reintroduce it"* currently forbids something that works. See `RED.md` §9
and §21.

**2. `hold-rite` is dead code.** It calls `global`, which does not exist in
Red 0.6.6 — `mold (hold-rite "probe" true "witness")` raises
`script / no-value`. The rites that matter use their own `say:`, so
nothing is broken; the function is just unreachable. `RED.md` §6.7.

**3. We are debugging blind, and the language ships a debugger.**
`do/trace` and its profiler are present and working in this build
(`RED.md` §17.1), as is the `r/near` error-context field. For eight
batches of research, a rite that produced no testimony was
indistinguishable from a compile error — that cost real time.
