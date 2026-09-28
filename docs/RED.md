# RED — the complete manual for Imp

> The Red language, as **measured on the interpreter Imp ships** and
> **cross-checked against the official specification**.
>
> Every claim is labelled **[V]** verified by execution · **[S]** read from
> the vendored source · **[W]** from the official docs or website · **[D]**
> differs from stock Red.
>
> Companion: [`RED-PROJECTS.md`](RED-PROJECTS.md) — what has actually been
> built in Red, verified project by project.
>
> Companion: [`RED-IDIOMS.md`](RED-IDIOMS.md) — patterns studied from 652
> files of real Red in `red-view-src/`, including the ones that contradict
> this document.

---

## 0. Provenance, and how to trust this

This document was built from four sources, cross-checked against each other.

| Source | What it gave | Label |
|---|---|---|
| **Execution** — 833 questions put to `imp/red-view` | Ground truth for this build | **[V]** |
| **The vendored source** — `imp/red-view-src/` (449 files) | Grammar, lexer, compiler, native specs | **[S]** |
| **The official spec** — [red/docs](https://github.com/red/docs), [Red/System Language Specification rev. 60](https://static.red-lang.org/red-system-specs.html), [red-lang.org](https://www.red-lang.org/) | Intended semantics, style, roadmap | **[W]** |
| **The project's own folklore** — `AGENTS.md`, `docs/GRIMOIRE.md` | Which scars are believed real | — |

The fourth turned out to be the least reliable. **Seven of its claims are
wrong**, and one of them — that `parse` is dead — was load-bearing enough to
have exiled a fully working PEG parser out of the codebase. Those
corrections are in §21, and they are the most valuable thing here.

### Reproducing the measurements

```bash
./scripts/red-eval init                     # bring the Red console up as an oracle
./scripts/probe-run.sh .probes/b1.txt b1    # ask every question in a file, one at a time
cat .probes/b1-report.txt                   # the answers, in order
```

Every answer quoted in this document is a real line from a report file kept
under `imp/.probes/`. The mapping is in §22.

### Two things the harness has to survive

Both are recorded because they will bite anyone who repeats this work.

1. **A parse error kills the entire script, silently** — no partial output,
   not even from the lines above the error. **[V]**
2. **The console can wedge.** After a rite it cannot finish, the input loop
   stops accepting work, and *every later rite then looks like a compile
   error*. One wedge masqueraded as forty language errors. So the runner
   health-checks the console before each question and rebuilds it if it
   stopped answering. **[V]**

A third lesson is in §8.1: **one `DEAD` verdict in the reports was wrong.**
`DEAD` is a harness verdict, not a language verdict. Every surprising result
was re-tested in a fresh console before it went in.

---

## 1. The substrate

| Fact | Value | Source |
|---|---|---|
| Language | Red | — |
| Version | `0.6.6` | **[V]** `mold system/version` → `"0.6.6"`; **[W]** released 19 Mar 2025 |
| `system/version` type | `tuple!` | **[V]** |
| Interpreter | `imp/red-view` — Red/View, GUI console | — |
| Format | ELF 32-bit LSB, Intel i386, stripped | `file red-view` |
| Source vendored | `imp/red-view-src/`, 449 `.r`/`.reds`/`.reb` | — |
| Interpreter written in | **Red/System (`.reds`)**, not C | **[S]** |
| Natives | **107** declared (`NATIVES_NB 120` slots) | **[S]** `runtime/macros.reds` |
| Actions | **59** declared (`ACTIONS_NB 62`) | **[S]** `environment/actions.red` |
| Licence | BSD 3-clause (modified); runtime under Boost | **[W]** Wikipedia |
| Word size | **32-bit**; 64-bit is a 1.0 goal | **[W]** |

**There is no `system/product` and no `system/build-date`.** **[V]** both are
`ERR script / invalid-path`. `system/version` is the only identity available.

### 1.1 Red and Red/System are two languages

The vendored tree makes this easy to get wrong. **[S]**

| Path | What it really is |
|---|---|
| `system/compiler.r` | The **Red/System** compiler — a C-like language with its own `if`, its own `routine`, no `parse`, no `forever`. `Title: "Red/System compiler"`, line 2. |
| `encapper/compiler.r` | **The Red language compiler.** `Title: "Red compiler"`. All Red intrinsics listed at `encapper/compiler.r:93-99`. |
| `environment/*.red` | The declarative language spec: 107 natives, 59 actions, 63 functions |
| `runtime/lexer.reds` | The tokenizer — the authority on literal syntax |
| `runtime/parse.reds` | The PEG parser, 2183 lines **[S]** |
| `utils/preprocessor.r` | The preprocessor **[S]** |
| `modules/view/` | The View/GTK layer — this is a Red**/View** build |
| `docs/lexer/lexer-states.txt` | The 66-state lexer FSM, human-readable |
| `tests/source/units/` | The language test suite — a good spec by example |

Wikipedia describes the intent: *"Key to the approach is that the language
has two parts: Red/System and Red."* **[W]** Red is a *full stack* language
— the same syntax carries you from scripts down to memory pointers.

### 1.2 A Red script needs a header — but any header works

A file with no `Red [...]` first line is **refused outright**: **[V]**

```
do %doctest.red
→ make error! [ type: 'syntax  id: 'no-header  arg1: %doctest.red ]
```

The check, from the interpreter **[S]** `runtime/natives.reds`:

```rebol
parse/case read file [some [src: "Red" opt "/System" any ws #"[" (found?: yes) break | skip]]
unless found? [cause-error 'syntax 'no-header reduce [file]]
```

What **is** allowed, all **[V]**:

| Form | Result |
|---|---|
| `Red [Title: "x"]` | runs |
| `Red []` | runs — an empty header is fine |
| free text before the header, then `Red [...]` | the text is treated as a comment, runs |
| `Red/System [Title: "x"]` | **rejected** — a Red script may not use the R/S header |

`core.red`, `rite-two.red` and every other file in this project already do
the first form. Good.

### 1.3 The console `change-dir`s to the script's own directory

`do %tests/rites/foo.red` makes `%src/core.red` inside it resolve to
`tests/rites/src/core.red`, which does not exist. **[V]**

```
do %tests/rites/_probe.red
→ ERR access / cannot-open   arg1: %src/core.red
```

This is the load-bearing half of "horror 6". The fix is what `rited` and
`red-eval` both do: **stage the rite in the directory it will run from**
(the Imp root), then `do %<name>.red`.

### 1.4 The console will not run a startup script

`red-view myscript.red` opens the window and **never evaluates the
argument**. **[V]** Hours were lost to this. The script only runs if you
*type* it.

Hence `scripts/red-eval`: it keeps one console alive and feeds it
`do %<staged>.red` through `xdotool`, then waits for the file the rite
writes. Same file-based oracle `rited` uses, reached a different way.

### 1.5 One console at a time, and X must be healthy

Only one Red console instance can be live; a second writes nothing. **[V]**
Always `pkill -x red-view` before casting.

`red-view` also needs an X display it is authorised for. If Xorg restarts,
a stale `~/.Xauthority` silently produces a console that opens, accepts
input, and never runs anything. Check `ps aux | grep Xorg` for the
`-auth /tmp/serverauth.*` file it was actually started with. This cost
real time here and would cost it again.

---

## 2. Evaluation order — the single most important fact

> ## Expressions evaluate strictly **left to right**. There is no operator precedence.

This is official, not folklore. **[W]** Red/System Language Specification,
§5.2, "Evaluation order rule":

> *Expressions are evaluated from **left to right**. There is no operator
> precedence except for infix functions which do have precedence over prefix
> calls.*

Its worked examples are precisely the cases the Imp core trips over:

```
1 + 2 * 3          ;-- (1 + 2) * 3 returns 9
1 + 2 * 3 = 9      ;-- ((1 + 2) * 3) = 9 returns TRUE
9 = 1 + 2 * 3      ;-- ((9 = 1) + 2) * 3 raises an error!
1 + (2 * 3)        ;-- 1 + (2 * 3) returns 7
foo 1 + 2          ;-- foo (1 + 2)
1 + foo 2 * 3      ;-- 1 + (foo (2 * 3))
```

### The measurement **[V]**

```
mold (1 + 2 * 3)        →  "9"      ;--  (1+2)*3 = 9.  NOT 7.
mold (2 + 3 * 4)        →  "20"     ;--  (2+3)*4 = 20. NOT 14.
mold (1 - 2 * 3)        →  "-3"     ;--  (1-2)*3 = -3. NOT 7.
mold (1 * 2 + 3)        →  "5"
mold (10 - 2 - 3)       →  "5"      ;--  left-assoc
mold (100 / 10 / 2)     →  "5"      ;--  left-assoc
mold (1 + 2 ** 3)       →  "27"     ;--  (1+2)**3 = 27. NOT 9.
mold (2 ** 3 ** 2)      →  "64"     ;--  (2**3)**2 = 64. NOT 512.
mold (1 + 2 ** 3 ** 2)  →  "729"    ;--  ((1+2)**3)**2
mold (1 + 2 % 3)        →  "0"      ;--  (1+2)%3
mold (1 + 2 << 3)       →  "24"     ;--  (1+2)<<3 = 3<<3
mold (1 + 2 * 3 - 4 / 2)→  "2.5"    ;--  9-4=5, 5/2=2.5
mold ((1 + 2) * 3)      →  "9"      ;--  parens work as expected
```

`2 ** 3 ** 2` = **64**, not 512, settles it: `**` is not right-associative
either. It has the same rank as everything else.

The compiler agrees. **[S]** `encapper/compiler.r`,
`check-infix-operators` (~line 4006) collects an expression's operators into
`ops` **left-to-right**, then walks `ops` left-to-right. There is no
precedence table, no rank, and no right-associativity rule anywhere.

### 2.1 The one exception: infix beats prefix

`mold 1 + 2 * 3` → **`"9"`** **[V]**. `mold` received the *whole* expression
and moulded its result, rather than moulding just `1`. This is the spec's
*"infix functions have precedence over prefix calls"* **[W]**.

This is why the Imp code is littered with `mold (…)`. The parens are not
decoration — they are the boundary.

### 2.2 The error that explains `GRIMOIRE` horror 3

`docs/GRIMOIRE.md` horror 3 says:

> `n - 1` parses as `(i <= n) - 1`

which is garbled, but it is pointing at something real. Comparison has the
**same rank** as arithmetic, so a comparison mixed into a chain binds first
and then the arithmetic is applied to a `logic!`. Measured **[V]**:

```
mold (1 = 2 - 1)        →  ERR script / expect-arg
mold (1 = 2 + 1)        →  ERR script / expect-arg
mold (9 = 1 + 2 * 3)    →  ERR script / expect-arg
mold (1 + 2 * 3 = 9)    →  "true"
mold (1 = 1)            →  "true"
mold (2 - 1 = 1)        →  "true"
```

`9 = 1 + 2 * 3` erroring is **exactly the spec's own worked example** of
`((9 = 1) + 2) * 3` **[W]**. So:

> **`x = y - 1` is a landmine.** It parses as `(x = y) - 1` and raises
> `script / expect-arg`. Never write a comparison on the left of an
> arithmetic chain. Parenthesise: `(x = y) - 1`, or better
> `x = (y - 1)`.

The folklore's instinct was right; its explanation was not.

### 2.3 `math` — the opt-in exception, and a genuine trap

`math` evaluates a block with real precedence, `**` right-associative
**[V]**:

```
mold math [1 + 2 * 3]     →  "7"
mold math [2 ** 3 ** 2]   →  "512"
mold math [10 - 2 - 3]    →  "5"
mold math [2 + 3 * 4]     →  "14"
mold math [10 + 10 ** 2 ** 3]  →  "100000010"
```

> ### ⚠️ `math` is a *different parser*, not a wrapper. It has different precedence.
>
> | Expression | the language | `math` |
> |---|---|---|
> | `1 + 2 * 3` | **9** | **7** |
> | `2 ** 3 ** 2` | **64** | **512** |
>
> **Porting a line out of `math` into normal code silently changes its
> meaning.** The upstream suite asserts both answers **[U]**
> `functions-test.red`:
> ```red
> 	--test-- "math test"
> 		--assert 7 = math [1 + 2 * 3]           ;← NOT 9
> 		--assert 100000010 = math [10 + 10 ** 2 ** 3]
> ```
> `math` is for *ported* expressions, where you want the precedence people
> expect. For new code, write the parentheses.

Only two levels: `**` first, then `* / % //`, then everything else
left-to-right **[S]** `environment/functions.red:267`. `math` **works** in
this build (§9 explains why its use of `parse` is not a problem).

### 2.4 Settling precedence with Red's own tracer

`trace` and `trace/all` print the evaluation order. Upstream uses this as
the ground truth **[U]** `evaluation-test.red`:
```red
	--test-- "hltrace-18"
		trace/all [1 + 2 * 4]
		--assert trace-output = next {
  1 + 2                              => 3
  3 * 4                              => 12
}
```
`(1+2) = 3`, then `3*4 = 12`. **Left to right. `*` does not bind tighter** —
12 *is* the left-to-right answer, and it agrees with `mold (1 + 2 * 4) → "12"`
and `mold (1 + 2 * 3) → "9"`.

> ⚠️ **A caution about analysis.** While researching this, an automated
> pass read that exact log and concluded *"`**` binds tighter than `+`, since
> `1 + 2 * 4 = 12`, not 9"* — wrong; 12 is the left-to-right answer. The
> same pass claimed `all` does not short-circuit, which direct measurement
> contradicts (`RED-IDIOMS.md` §3.8). A summary is not evidence. Every
> contested claim in these documents was re-measured before it was written
> down.

### 2.5 The rule to actually follow

> Parenthesise every sub-expression you care about. Never rely on `*`
> binding tighter than `+`. Never let a comparison sit on the left of an
> arithmetic chain. Never write a bare arithmetic chain.

---

## 3. Infix operators need surrounding spaces

```
mold (1 + 2 * 3)   → "9"       ;-- fine
1 + 2*3            → DEAD      ;-- no space after the 2
1+2*3              → DEAD      ;-- no spaces at all
```
**[V]**

**Why:** `+` and `-` are *word-initial* characters to Red's lexer, so directly
after a digit the scanner starts a **signed number**, not an operator
**[S]** `runtime/lexer.reds:225-314`. `1+2` lexes as `1` then `+2`.
`1+2*3` is then `1`, `+2`, `*3` — nonsense, and the whole rite dies with no
output (horror 10).

Related: `& * ? | ~ _ \` are **word characters, not sigils** **[S]**, so
`a*b` is *one word*, not a multiplication. And `%` is both the file sigil
and the remainder operator.

> **Always put whitespace on both sides of every infix operator.**

---

## 4. `none` and the front end

### Measured **[V]**

```
mold (none = none)      →  "true"
mold (none = false)     →  "false"     ;-- none is NOT false
mold (none = true)      →  "false"
mold (none = 0)         →  "false"
mold (false = 0)        →  "false"
mold (if none [1])      →  "none"
mold (if false [1])     →  "none"
mold (if true  [1])     →  "1"
mold (if 0     [1])     →  "1"         ;-- ZERO IS TRUTHY
mold (not none)         →  "true"
```

* `none` is a value in its own right, equal only to itself.
* In conditions, `none` and `false` are both falsy.
* **Everything else is truthy, including `0` and `""`.** There is no
  C-style falseness.
* `none` never equals `false` or `0`.
* `if` yields `none!` — not `false` — when the condition is falsy. **[W]**
  confirms: *"IF returns the resulting value of the block or 'none' if the
  condition was false."*
* `mold unset!` is `"unset!"`; `type? unset!` is `datatype!` — `unset!` is
  the *datatype*, not an instance. **[V]**

### `any` and `all` **[V]**

```
mold (any [none none])  →  "none"
mold (all [none none])  →  "none"
mold (all [true none])  →  "none"
mold (any [1 = 2 3])    →  "3"     ;-- any returns the first TRUTHY value
mold (all [1 2 3])      →  "3"     ;-- all returns the LAST value
mold (any [])           →  "none"
mold (all [])           →  "none"
mold (all [false (1 / 0)])  →  "none"   ;-- short-circuits
mold (any [true  (1 / 0)])  →  "true"   ;-- short-circuits
```

`any` → first truthy value, else `none`. `all` → last value if all truthy,
else `none`. Both short-circuit. **[S]** when the argument is a literal
block, `any`/`all` are compiled away entirely into a nested `if`/`either`
tree — no call at all.

### `none` in arithmetic is an **error**

```
mold (none - 1)    →  ERR script / expect-arg
mold (1 + none)    →  ERR script / expect-arg
mold (none + 1)    →  ERR script / expect-arg
mold (none - 1.0)  →  ERR script / expect-arg
mold (1.0 + none)  →  ERR script / expect-arg
```
**[V]**

> ⚠️ **Corrects `GRIMOIRE` horror 3.** It claims *"`none - 1` is `none`, i.e.
> false."* It raises `script / expect-arg`. Propagate explicitly with
> `if none = x [none]` and test with `= none`; never let `none` reach an
> operator.

---

## 5. Control flow

All **[V]**, values are the moulded result of the whole expression.

| Form | Result | Note |
|---|---|---|
| `if true [1]` | `1` | no else branch exists |
| `if false [1]` | `none` | yields `none!` |
| `unless false [1]` | `1` | Red has `unless`; Rebol 2 does not |
| `unless true [1]` | `none` | |
| `either true [1] [2]` | `1` | **both blocks mandatory** |
| `either false [1] [2]` | `2` | |
| `loop 3 [1]` | `1` | count coerced to integer |
| `loop 3.8 [1]` | `1` | truncates |
| `loop 0 [1]` | `none` | body never runs |
| `loop -1 [1]` | `none` | body never runs |
| `loop none [1]` | `ERR script / expect-arg` | |
| `repeat i 3 [i]` | `3` | `i` is a **global** counter |
| `repeat i 0 [i]` | `none` | |
| `foreach w [a b c] [w]` | `c` | counter is a **global** |
| `while [false] [1]` | `unset` | **[W]** "WHILE does not return any value" |
| `until [true] [1]` | `[1]` | runs at least once |
| `forever [break]` | `unset` | |
| `switch 2 [1 [10] 2 [20]]` | `20` | |
| `switch 9 [1 [10]]` | `none` | no match, no `/default` |
| `switch 9 [1 [10]] /default [99]` | `[99]` | `/default` returns the **block** |
| `case [false [1] true [2]]` | `2` | chain of conditions |
| `case [false [1]]` | `none` | |
| `case []` | `none` | |
| `case/all [true [1] true [2] true [3]]` | `3` | runs **every** match |
| `remove-each k [1 2 3 4 5] [k > 3]` | `[1 2 3]` | Red-only; survivors |

### 5.1 `if` takes ONE block — the second leaks

The nastiest trap in the language, and the codebase knows it as horror 9.
**[V]**

```
mold (if true  [1][2])   →  "[2]"
mold (if false [1][2])   →  "[2]"
mold (either true [1][2])→  "1"
```

`if` reads one block, evaluates it, and the **second block becomes the next
statement in the enclosing block**. In a paren the last expression wins, so
you get `[2]` and the `if` itself vanishes.

In a longer block this does not raise — it silently changes your program's
shape:

```red
either beast-allows? seq style [append out seq]
append ledger "entry"          ;-- runs on BOTH paths
```

**Use `either` whenever the branches are not both "do a thing".** There is
no `if/else` in Red 0.6.6. **[S]**

### 5.2 `return` inside a loop: the eighth horror, re-measured

`GRIMOIRE` horror 8 says `return` nested in a loop "does not leave the
function — it leaves the loop, and the demon spins forever."

**Measured, that is not what happens.** `return` inside a loop inside a
function returns from the **function**. Every loop form behaves the same;
none spins. **[V]**

The measurement is subtle — an *anonymous* `func` in expression position is
not applied at all (§6.4), which masks the result. Named functions show the
truth:

```red
f: func [][loop 3 [return 99] 5]
f                             ;-- 99
```

**[S]** `encapper/compiler.r:678-685`: `return` emits
`stack/unroll stack/FRAME_FUNCTION`, walking to the nearest *function* frame
and skipping loop frames. `break`/`continue` emit `stack/unroll-loop`, which
stops at the nearest *loop* frame instead.

So the rule in `core.red` — *"no `return` inside any loop in this core"* — is
**good hygiene, not a language necessity**. `return` in a loop is safe.
Keeping the rule costs nothing; the comment overstates the danger, which is
worth knowing before someone "fixes" it.

**The real trap is a bare `break`:** `mold loop 3 [break]` → `"unset"`. A
loop that breaks returns `unset!`, which then propagates. Carry answers out
in a variable, as `core.red` already does.

### 5.3 `break`, `continue`, `exit` **[V]**

| Form | Result |
|---|---|
| `mold loop 3 [break]` | `unset` |
| `mold loop 3 [continue]` | `unset` |
| `mold forever [break]` | `unset` |
| `mold (func [][exit])` | `integer!` — the value is `unset!` **[S]** |
| `mold (func [/local v][exit][v: 1 v])` | `none` (code after `exit` unreachable) |

`exit` yields `unset!`, **not** `none!`. **[S]**

### 5.4 `case` has no `else` in this build

```
mold (case [else [7]])  →  ERR script / no-value
```
**[V]**

The compiler has `else` handling in `comp-case` **[S]**, but it does not fire
in 0.6.6. Use `either` for a default branch.

### 5.5 `forall` does not work in this build

All three plausible spellings error **[V]**:

```
mold (forall w [a b c] [w])     →  ERR script / no-value
mold (forall w s [w])           →  ERR script / expect-arg
mold (forall [w [a b c] [w]])   →  ERR script / expect-arg
```

`forall` is declared as a native **[S]** but is not usable. `foreach` is the
one to use — which is what `src/core.red` does, correctly.

### 5.6 Loops and mutation

* `repeat` and `foreach` counter words are **global** **[S]**. After
  `repeat i 3 [...]`, `i` still holds `3` in the caller's context **[V]**.
* `foreach` advances the series destructively from the head **[S]**.
* `loop` has no word form — `repeat` provides that.

---

## 6. Functions

### 6.1 The four constructors **[V]**

`func` · `function` · `does` · `has` — all produce `function!`.

* `function` auto-collects every `set-word!` in the body into `/local`
  **[S]** (`collect-words`).
* `does` synthesises an empty spec **[S]**.
* `has` prepends `/local` to the given words **[S]**.

### 6.2 Specs, exactly

```
mold spec-of :sever   → [s [string!] delim [string!] /local out i j n f]
mold words-of :myfun  → [a b local c]
```
**[V]**

`words-of` includes the word `local` itself. Specs support **[S]**
`check-spec`, `encapper/compiler.r:1386-1437`:

```red
func [
    "docstring"                          ;-- optional, first
    /refinement arg [type!] "doc"        ;-- refinement + arg
    set-word: [type!]                    ;-- returns a value
    return: [type!]                      ;-- declared return
    /local a b c
][...]
```

Docstrings have no runtime effect **[W]** — but `spec-of` returns them, so
they are worth writing. `return:` is likewise documentation; the function
returns its last expression's value.

### 6.3 Reflection works — mostly **[V]**

```
mold spec-of :mold     → the full spec block, with docstrings
mold spec-of :myfun    → [a b /local c]
mold body-of :myfun    → [c: 1 a]
mold type? :mold       → "action!"
mold type? :myfun      → "function!"
mold words-of :mold    → ERR internal / not-done
```

⚠️ `words-of` on an **`action!`** such as `:mold` fails with
`internal / not-done`. On a `function!` it is reliable. So `spec-of` and
`body-of` are the universal doors; `words-of` only for your own functions.

### 6.4 ⚠️ An anonymous `func` in expression position is NOT called

The most surprising thing in the language. **[V]**

```
f: func [a][a + 1]

mold f 5                   →  "6"    ;-- named: called
mold (func [a][a + 1] 5)   →  "5"    ;-- anonymous: NOT called
mold ((func [a][a + 1] 5)) →  "5"
mold (func [a][a] 5 6)     →  "6"    ;-- last stray expression wins
h: func [a b][a + b]
mold h 1 2                 →  "3"    ;-- named: called
mold (func [a [integer!] b [integer!]] [a + b] 2 3)  →  "3"   ;-- not 5
```

In expression position the anonymous function is *constructed*; the trailing
values become independent expressions in the surrounding block, and the last
one is the block's value. Nothing is called.

**Rule: always name a function, or assign it first.** `src/core.red` already
names everything. Keep it that way.

### 6.5 Argument lists are fixed by the spec

A function consumes exactly as many expressions as its spec has parameters;
the rest become new statements. **[V]**

```
mold (repend [] "a" "b")   →  {"b"}      ;-- repend took only []
mold (also 1 2)            →  "1"        ;-- also takes one value
mold (7 // 3)              →  "1"
mold (remainder 7 3)       →  "1"
mold (7 remainder 3)       →  ERR script / no-arg
```

### 6.6 `compose` does not evaluate a plain block

```
mold (compose [a 1 + 1])     →  "[a 1 + 1]"   ;-- the block was ALREADY evaluated
mold (compose [a (1 + 1)])   →  "[a 2]"       ;-- parens are where evaluation happens
```
**[V]**

A block literal is evaluated *before* `compose` is called. To compose
*expressions*, the parens must be inside the literal so `compose` sees them
unevaluated.

### 6.7 `/local` and the missing `global`

`/local` words are real locals. There is **no `global` function**: **[V]**
`mold type? :global` → `unset!`, and `(global LEDGER-P: 1)` →
`ERR script / no-value`.

> ⚠️ **This breaks `hold-rite` in `src/core.red` (line 10).** It calls
> `global LEDGER-P: ...`, which does not exist in Red 0.6.6.
> `mold (hold-rite "probe" true "witness")` → `ERR script / no-value` **[V]**.
> Dead code — the rites that matter use their own `say:`. Either delete it
> or rewrite the two lines as plain `LEDGER-P: LEDGER-P + 1`; the globals
> are already at module level.

### 6.8 Recursion and `local` state

`mold (function [x] [y: x + 1 z: y * 2] 3)` → `3` **[V]**; the follow-up
`mold y` errors with `script / no-value` — `y` does not leak, which is
exactly what `function`'s auto-collection is for.

### 6.9 User-defined infix operators

Red can promote a two-argument function to an operator **[W][S]**:

```rebol
***: make op! :infix
```

Red's own test suite asserts the left-to-right rule for these **[S]**
`tests/source/units/function-test.red`:

```rebol
infix: function [a b][a * 10 + b]
***: make op! :infix
--assert 5 *+* 6 *** 7 = 1067     ;-- left-to-right, not 207
```

`make op!` is available here **[V]** (`mold type? make op! :add` → `"op!"`).
The Imp core does not need it, but it is the idiomatic way to make a
domain-specific operator.

---

## 7. Series: the model you must internalise

A Red series is a **window**, not a value: a start, an end, and a position.

### 7.1 Navigation **[V]**

| Call | Result on `[1 2 3]` |
|---|---|
| `mold head [1 2 3]` | `[1 2 3]` |
| `mold tail [1 2 3]` | `[]` — the empty block *after* the last value |
| `mold next [1 2 3]` | `[2 3]` |
| `mold back tail [1 2 3]` | `[3]` |
| `mold at [1 2 3] 2` | `[2 3]` |
| `mold skip [1 2 3] 1` | `[2 3]` |
| `mold index? at [1 2 3] 2` | `2` |
| `mold head? [1 2 3]` | `true` |
| `mold tail? [1 2 3]` | `false` |

Indices are **1-based**. **[W]** *"The starting position of an empty series
is at the last position (tail)."*

### 7.2 ⚠️ Appending moves EVERY window onto that series

This is the official example from the typeset documentation **[W]**, and it
reproduces exactly here **[V]**:

```red
a: "hello"
b: next a
append a " world"
mold a    ;-- {"hello world"}
mold b    ;-- {"ello world"}     ;-- b MOVED TOO
```

```
mold index? a              → "1"
mold index? b              → "2"
mold same? a b             → "false"
mold same? a head b        → "true"
append a " world"          → "hello world"
mold b                     → {"ello world"}
```

This is not a bug and it is not shallow copying. `a` and `b` are two
*positions* in one series. Growing the series moves every position. If you
hold a `next`-ed window across an `append` elsewhere, it will surprise you.

**Relevant to this project directly:** `src/core.red` does
`f: find at s i delim` and then `index? f`, holding derived positions across
`append out …`. Those `out` appends are on a *different* series, so it is
safe — but the pattern deserves a comment so the next hand does not "tidy"
it.

### 7.3 Mutating actions return a *position*, not the result

**[V]**

| Call | Result | Underneath |
|---|---|---|
| `mold insert [1 2] 3` | `[1 2]` | inserted 3; pointer is *past* it |
| `mold head insert copy [1 2] 3` | `[3 1 2]` | |
| `mold append [1 2] 3` | `[1 2 3]` | append returns the **head** |
| `mold change [1 2 3] 9` | `[2 3]` | changed 1→9; pointer is after it |
| `mold head change [1 2 3] 9` | `[9 2 3]` | |
| `mold remove [1 2 3]` | `[2 3]` | removed 1 |
| `mold (change "abc" "X")` | `{"bc"}` | same rule for strings |

**`insert`/`change`/`remove` advance; `append` resets to the head.** Use
`head insert …` / `head change …` whenever you want the whole series.

### 7.4 Bytes vs characters — horror 4, quantified

`find` and `index?` walk **bytes**. `length?`, `copy/part` and `pick` count
**characters**. On non-ASCII they disagree. **[V]**

```
mold length? "樯樯"                →  "2"    ;-- 2 characters
mold third "樯"                    →  none   ;-- 3rd BYTE is past the end
mold copy/part "樯樯" 1            →  {"樯"} ;-- 1 CHARACTER
mold index? find "樯樯" "樯"        →  "1"    ;-- 1-based byte index
mold true-span "樯樯"               →  "4"    ;-- 2 glyphs, 2 columns each
mold weigh-cell to char! 26941     →  "2"    ;-- 𠔡 is a wide glyph
```

A single `樯` (U+6A4F) is **3 bytes**. `third` asks for byte 3, which is past
the end, so it answers `none`. If you have been counting with `find` and
slicing with `copy/part` on CJK or emoji, your indices have been wrong by a
factor of up to 4.

A `string!` holds only `char!` values **[V]** (`mold (type? first "abc")` →
`"char!"`), which is why `string!` and `binary!` diverge here.

### 7.5 Assignment and copying **[V]**

```
c: "xy"
d: copy c
append d "z"
mold c  →  {"xy"}     ;-- the copy is independent
mold d  →  {"xyz"}
```

Blocks **do** alias on plain assignment; `copy` / `copy/deep` for
independence **[S]**:

```red
n: [[1 2] [3 4]]
mold (n/1/2)          → "2"
mold (copy n)         → unchanged
mold (copy/deep n)    → unchanged
```

### 7.6 Other measured series behaviour **[V]**

```
mold select [1 2 3] 2        → "3"      ;-- the value AFTER the match
mold select [a: 1 b: 2] 'b   → "2"
mold find [1 2 3] 2           → "[2 3]"  ;-- a sub-block
mold pick [1 2 3] 2           → "2"
mold pick [1 2 3] 9           → none
mold poke copy [1 2 3] 2 9    → "9"
mold reverse [1 2 3]          → "[3 2 1]"
mold sort [3 1 2]             → "[1 2 3]"   ;-- modifies in place
mold sort/reverse [3 1 2]     → "[3 2 1]"
mold (sort/compare [3 1 2] func [a b][a < b]) → "[1 2 3]"
mold trim "  a  "             → {"a"}
mold trim/head "  a  "        → {"a  "}
mold trim/tail "  a  "        → {"  a"}
mold (to-block "a")           → "[a]"
mold (to-block "a,b,c")       → ERR syntax / invalid
```

`sort/compare` needs a **function**, not a word: `sort/compare [1 2 3] <` →
`ERR script / no-arg` **[V]**.

---

## 8. Literals

All measured **[V]** unless marked.

| Literal | Type | `mold` gives |
|---|---|---|
| `42` | `integer!` | `42` |
| `1'000'000` | `integer!` | `1000000` |
| `0x1F` / `1FFFh` | `integer!` | hex form **[S]** |
| `1.0` | `float!` | `1.0` |
| `.5` | `float!` | `0.5` |
| `1e3` | `float!` | `1000.0` |
| `50%` | `percent!` | `50%` |
| `1,5` | — | **DEAD** — comma decimals rejected **[V]** |
| `1/2` | — | **not a ratio**; Red has no `ratio!`. It is the divide operator **[S]** |
| `16#{FF}` | `binary!` | `#{FF}` |
| `#{48656C6C6F}` | `binary!` | `#{48656C6C6F}` |
| `"abc"` | `string!` | `{"abc"}` |
| `{"multi`⏎`line"}` | `string!` | nests, keeps newlines **[S]** |
| `#"a"` · `#"^/"` | `char!` | `#"a"` · `#"^/"` |
| `%a/b.txt` | `file!` | `%a/b.txt` |
| `1x2` | `pair!` | `1x2` |
| `(1,2)` | `point2D!` | `(1, 2)` |
| `1.2.3` | `tuple!` | `1.2.3` |
| `$12` | `money!` | `$12.00` |
| `+USD100` | — | **DEAD** — ISO-prefixed money rejected **[V]** |
| `12:30:15.5` | `time!` | `12:30:15.5` |
| `2018-01-31` | `date!` | `31-Jan-2018` |
| `<tag>` | `tag!` | `<tag>` |
| `a` · `a:` · `:a` · `'a` · `/a` | word kinds | `a` · `a:` · `:a` · `'a` · `/a` |
| `#12` | `issue!` | `#12` |
| `[1 2]` | `block!` | `[1 2]` |
| `(1 2)` | `paren!` | `(1 2)` — evaluated |
| `#[a 1]` | `map!` | see §12 |
| `#(integer!)` | `datatype!` | see §12 |
| `@ref` | `ref!` | **[S]** |

### 8.1 `%` and the other arithmetic operators

`%` is bound to `remainder` and works, with the usual no-precedence
caveat: **[V]**

```
mold (7 % 3)          →  "1"
mold (5 % 3)          →  "2"
mold (9 % 4)          →  "1"
mold (7 // 3)         →  "1"
mold (remainder 7 3)  →  "1"
mold (1 + 2 % 3)      →  "0"     ;-- (1+2)%3 — NOT 1 + (2%3)
```

`7 remainder 3` is **not** a call and errors **[V]**. Write
`remainder 7 3`.

> ⚠️ A single harness question once reported `mold (7 % 3)` as `DEAD` when
> `%` is perfectly fine. The report is the evidence, but the *harness* was at
> fault. When a surprising result contradicts the source, re-run it in a
> fresh console before believing it. This one did not survive.

### 8.2 Word naming rules **[W]**

From the Red/System specification §3, and enforced by the same lexer:

* Identifiers are sequences of printable characters with no whitespace.
* A leading digit, `'`, `{`, `}`, `"`, `(`, `)`, `/`, `\`, `@`, `#`, `$`,
  `%`, `^`, `,`, `:`, `;`, `<`, `>` are forbidden as the **first** character.
* To stop a variable being mistaken for a hex literal, **names of 2, 4 or 8
  characters made only of `A-F`/`0-9` and ending in `h` are forbidden**
  (`1FFFh` is a number, not a variable).
* **Identifiers are case-insensitive.**

### 8.3 `form` vs `mold` **[V]**

```
mold "abc"            →  {"abc"}       ;-- string: quotes added
mold [1 2 3]          →  "[1 2 3]"
mold [a "b" c:]       →  [a {"b"} c:]  ;-- words bare, strings quoted
form [1 2 3]          →  "1 2 3"       ;-- no outer brackets
mold/only [1 2 3]     →  "1 2 3"
mold/flat [a b c]     →  "[a b c]"     ;-- no indentation
mold/part "abcdef" 3  →  {"ab"}
mold (mold/all [1 "a" #"b" none]) → {{[1 "a" #"b" none]}}
mold (mold "x")       →  {{"x"}}
```

`mold` is "loadable-ish", `form` is "human". **[W]** *"`mold` returns a
source format string representation"*, *"`form` returns a user-friendly
string representation"*.

### 8.4 The lexer is a public API **[W]** **[V]**

`runtime/lexer.reds` is not just an internal detail — Red exposes it:

| Function | Purpose | Measured **[V]** |
|---|---|---|
| `transcode <input>` | text → value | `mold (transcode "1 + 2")` → `"[1 + 2]"` |
| `scan <input>` | type of the next value only, no allocation | `mold (scan/fast "123.5")` → `"float!"` |
| `scan/next <input>` | `[type rest]` | `mold (scan/next "42 rest")` → `[integer! " rest"]` |
| `transcode/next <input>` | `[value rest]` | `mold (transcode/next "42 rest")` → `[42 " rest"]` |
| `transcode/trace <input> <cb>` | instrumented load, with `event`/`line`/`token` | needs a full callback |
| `load/next <input> <var>` | first value, rest into `var` | `ERR script / no-value` here |

`scan "123abc"` → `error!` (two values cannot be one token) **[V]**.

`transcode/trace` is the official way to write a **syntax highlighter** or a
**linter**, because the callback receives the current **line number**. Not
needed by Imp, but worth knowing it exists.

---

## 9. `parse` — the great correction

`docs/GRIMOIRE.md` horror 2 says:

> `parse` — Returns `logic` for a block rule. It is dead. `sever` is the
> replacement.

**That is wrong, and it is the most consequential error in the project's
folklore.** The PEG parser is fully functional in this build.

### 9.1 `logic!` is the documented default, not a failure

The official parse specification **[W]** says plainly:

> *By default, `parse` returns `logic!` value to indicate whether or not
> provided grammar rules succeeded in fully matching the input series.*
>
> ### Collecting mode
> *`collect` rule makes `parse` return a block instead of `logic!` value.*

So `parse "abc" [some "a" thru "c"]` → `true` is **correct behaviour**, not a
broken parser. The project read a correct default as a defect.

### 9.2 Extraction works **[V]**

```
mold (parse "abc"  [collect [some [keep skip]]])        →  {[#"a" #"b" #"c"]}
mold (parse [a b c] [collect [some [keep word!]]])      →  [a b c]
mold (parse "abc"  [collect [some [keep "a"]]])         →  {[#"a"]}
mold (parse "abc"  [collect [keep "a" 2 skip]])         →  {[#"a"]}
mold (parse "abc"  [collect set r [some [keep skip]]])  →  "true"   ;-- /set ⇒ logic!
```

`collect` allocates a block; `keep` puts matched values into it. That is the
missing half. `parse.reds` in this very tree contains `collect` (7 hits),
`keep` (7) and `reject` (1) **[S]** — the rules were there the whole time.

### 9.3 What the excommunication cost, and what it costs now

`sever` is a correct, well-written hand-rolled splitter, and its tests are
good. There is no reason to delete it. But three claims in the project's
doctrine are now known to be false:

| Claim | Reality |
|---|---|
| "`parse` returns `logic` for a block rule" | It returns `logic!` for **all** rules, string rules included, **by design** **[W]** |
| "It is dead" | It is a complete PEG parser: search, validation, extraction, modification |
| "The PEG `parse` is **excommunicated**… Never reintroduce it" | An AGENTS.md **law**. It is currently forbidding working, tested language features |

**Recommendation: do not rip out `sever`. Re-write the law.** `sever` is
fine for splitting on a single delimiter; `parse` is strictly better for
anything with structure (nested quotes, escapes, multi-char tokens,
validating a whole SGR grammar). A sensible amended law would be:

> `sever` is our splitter; use it by default. `parse` is available and
> working — reach for it when the pattern has structure, and prove it in a
> rite first.

I have deliberately **not** made that change, because `AGENTS.md` is law and
this document is evidence, not legislation. §21 lists it as the top open
question.

### 9.4 Other measured parse behaviour **[V]**

```
mold (parse "abc" [collect [some [keep skip]]])  →  {[#"a" #"b" #"c"]}
mold (parse "abc" [2 word!])                    →  ERR script / parse-unsupported
mold (parse "abc" [opt "z" any "a" 2 skip])     →  "true"
mold (parse "abc" [3 skip])                     →  "true"
mold (parse "abc" [2 3 skip])                   →  "true"
mold (parse "abc" [2 4 skip])                   →  "true"   ;-- count range
mold (parse "abc" ["a" thru "c"])               →  "true"
mold (parse "abc" [to "b" 2 skip])              →  "true"
mold (parse "abc" [end])                        →  "false"  ;-- head, not tail
mold (parse "abc" [fail])                       →  "false"
mold (parse "abc" [while [not end]])            →  HANGS THE CONSOLE
mold (parse "abc" [some "a"])                   →  "false"  ;-- see below
mold (parse "abc" [not "z" skip])               →  "false"
mold (parse "abc" [ahead "a" skip])             →  "false"
mold (parse "abc" [(1 + 1 = 2) skip])           →  "false"
```

⚠️ **This build's parse has real quirks.** `some "a"` on `"abc"` should match
once and succeed; it returns `false`. `not`/`ahead`/top-level `paren!` also
misbehave. And `while` hangs the console — **[W]** warns: *"CAUTION: If the
rule does not fail, `while` stuck in an infinite loop."*

**Datatype matching is not supported on string input** **[W]**: *"Matching by
datatype is not supported for `any-string!` input."* That is why
`[2 word!]` raises `parse-unsupported` **[V]**. Work on a `block!` if you
want to match by type.

**Loose comparison:** parse uses Red's loose `=`, not `==` **[W]**
`parse [I'm 100% <sure>][quote :I'M 1.0 "sure"]`.

**The full rule vocabulary** (all documented **[W]**, all worth having):
`case` `quote` `skip` `none` `end` `opt` `not` `ahead` `paren!` `set-word!`
`get-word!` integer-count `any` `some` `while` `to` `thru` `if` `into` `fail`
`break` `reject` `set` `copy` `collect` `keep` `remove` `insert` `change`,
plus `block!`/`word!` composition and `|` alternation.

`parse` also has `/case`, `/part` and `/trace` refinements **[W]**;
`/trace` takes a callback receiving `event match? rule input stack`, and
emits `push pop fetch match iterate paren end`.

**Keep the AGENTS.md rule that `parse` may not be trusted for a rite's
output** — that is about *process*, not capability. But know that the tool
works.

---

## 10. The preprocessor — fully working, and undocumented here

`AGENTS.md` does not mention the preprocessor at all. It is present in this
build **[S]** (`utils/preprocessor.r`, referenced from
`encapper/compiler.r:46,4334,4710,5059`) and **every directive I tested
works** **[V]**.

Directives are `issue!` values starting with `#`. They run after LOAD, so
they process **values, not text** **[W]**.

### Measured **[V]** — ten whole-file rites

| Rite | Code | Result |
|---|---|---|
| minimal header | `Red []` | ran |
| pre-header text | text, then `Red [...]` | ran — text ignored |
| conditional | `#if config/OS = 'Linux [write …]` | ran |
| false conditional | `#if config/OS = 'Windows [write …]` | correctly did **nothing** |
| choice | `#either config/OS = 'Linux ["linux"]["other"]` | `either-linux` |
| value injection | `#do keep [2 + 3]` | `5` |
| named macro | `#macro make-KB: func [n][n * 1024]` then `make-KB 64` | `65536` |
| R/S header | `Red/System [...]` | rejected |
| switch | `#switch config/OS [Linux ["ok"] Windows ["WRONG"]]` | `switch-ok` |
| expression position | `#either true [1][2]` | `integer` |

### The full directive set **[W]**

| Directive | Purpose |
|---|---|
| `#if <expr> [<body>]` | include code if the condition holds |
| `#either <expr> [<true>][<false>]` | compile-time choice |
| `#switch <expr> [<v1> [<c1>] … #default [<d>]]` | compile-time dispatch |
| `#case [<e1> [<c1>] …]` | chain of conditions |
| `#do [<body>]` · `#do keep [<body>]` | evaluate at preprocess time; `keep` substitutes the result |
| `#include <file>` | read and inline another Red file |
| `#macro <name> func <spec> <body>` | named macro |
| `#macro <pattern> func [s e][…]` | pattern-matching macro |
| `#local [<body>]` | scope macros to a block |
| `#reset` | wipe macros and the hidden context |
| `#process [on\|off]` | disable the preprocessor (escape hatch) |
| `#trace [on\|off]` | debug output for evaluated expressions |

`expand-directives <block>` and `expand-directives/clean <block>` let you run
the preprocessor over a block at runtime **[W]**.

**`config` is implicit inside every directive** **[W]** — the settings used
to compile the running executable. `#if config/OS = 'Linux […]` is the
canonical use, and it is exactly how a Red program becomes portable.

⚠️ One documented caveat **[W]**: at *compile* time these expressions are
currently evaluated by the **Rebol 2** interpreter, so directive code must
also be valid Red or it will work in the interpreter and fail in the
compiler.

### Should Imp use it?

Probably not much — the project deliberately caps at 6 functions with no
build-time machinery. But `#if config/OS = 'Linux` is the clean, official
way to write the one platform branch the bridge may eventually need, and
`#macro` is the sanctioned way to give a cursed DSL a domain verb. Both are
worth having in the vocabulary.

---

## 11. Errors and `try`

### 11.1 `try` returns ONE value

```
mold (type? try [1 / 0])   →  "error!"
mold error? try [1 + "a"]  →  "true"
mold (try [1 + 2])         →  "3"
mold (attempt [1 / 0])     →  none
mold (attempt [1 + 1])     →  "2"
```
**[V]**

`try` is a single-result call: the value **or** an `error!`. **Not** a
`[result error]` pair. This is already called out in `GRIMOIRE.md` and is
correct.

* `try [block]` → value or `error!` **[S]**
* `try/all [block]` → also catches `break`/`continue`/`return`/`exit`/`throw`
* `try/keep [block]` → keeps the call stack in the error
* `attempt [block]` → value or `none` **[V]**

There is **no `try/except`** in 0.6.6 **[S]** — only `/all` and `/keep`. The
pattern is:

```red
r: try/all [risky thing]
either error? r [report r/type r/id][use r]
```

### 11.2 The error object **[V]**

```
mold (try [1 / 0])
→ make error! [
    code: 400
    type: 'math
    id: 'zero-divide
    arg1: none
    arg2: none
    arg3: none
    near: [1 / 0]
    where: '/
    stack: -185899944
    files: none
]
```

The useful fields are **`id`** and **`type`**. Pull them with
`r: try […] r/id`:

| Expression | `r/id` |
|---|---|
| `1 / 0` | `zero-divide` |
| `none/x` | `bad-path-type` |
| `length? #"a"` | `expect-arg` |
| `to integer! "zz"` | `bad-to-arg` |
| `read %no-such` | `cannot-open` |
| `1 / 0` → `r/type` | `math` |

### 11.3 Error ids seen in practice **[V]**

`script / expect-arg` (missing argument, **and all `none` arithmetic**) ·
`script / no-value` · `script / no-arg` · `script / no-refine` ·
`script / need-value` · `script / bad-path-type` · `script / unset-path` ·
`script / invalid-path` · `script / parse-unsupported` · `syntax / invalid` ·
`syntax / no-header` · `access / cannot-open` · `math / zero-divide` ·
`script / bad-to-arg` · `internal / not-done`

---

## 12. What this substrate can and cannot do

**[V]** unless noted.

| Question | Answer | Evidence |
|---|---|---|
| Can Red sleep? | **No.** | `wait 100` **hangs the console**; `wait` bare → `ERR script / no-value` |
| Can Red read a missing file? | **Yes**, catchably | `error? try [read %definitely-missing-zzz]` → `true`, `r/id` = `cannot-open` |
| Can Red read a directory? | Yes, without error | `error? try [read %/tmp/]` → `false` |
| Can Red rename? | **Yes** | `rename %a %b` → `true`, then `exists? %b` → `true` |
| Can Red delete? | **Yes** | `delete %b` → `true`; a second delete does **not** error |
| Can Red read a FIFO? | **No** | `cannot-open` — `read` refuses non-regular files **[S, GRIMOIRE]** |
| `write` returns | `unset!` | `mold type? write %f "x"` → `"unset!"` |
| `open` bare | `ERR script / expect-arg` | |
| `load` a data file | `block!` — parses it | `mold type? load %f` → `"block!"` |
| `do` a missing file | `ERR` `cannot-open` | |
| `now` | `date!` | |
| Env vars | available | `get-env "HOME"` → `string!`; `length? list-env` → `57` |
| View present? | Yes | `type? :view` → `function!`; `system/view` is an `object!` **[V]** |
| `react` present? | Yes | `type? :react` → `function!`; `make-reactor` unset **[V]** |
| `alias` (R/S) present? | No | `type? :alias` → `unset!` **[V]** |

One invocation is cheap enough to call Red per user action — ~0.12 s
**[S, project-measured]**.

### The shape that survives

> Red cannot wait, cannot block, cannot read a pipe, and has no stdout. It
> can compute, and read/write/rename/delete regular files.
>
> **Red is a pure function. One process per action.** The bridge owns the
> terminal, the input loop, the spinner and every wait. Red answers with a
> file and exits.

### 12.1 This constraint is temporary — and that matters

The official roadmap **[W]**:

> * **v0.7** — Full I/O with async support.*
> * v1.0b — completed self-hosted Red with 64-bit support
> * v1.2 — Android backend · v1.4 — Web backend · **v2.0 — Red JIT compiler**

The 0.6.6 release notes say the same **[W]**: *"Next release (should be 0.7.0)
will feature the full async IO support we are all waiting for!"*

So **"Red cannot wait" is a property of 0.6.6, not of Red.** The architecture
in `docs/DESCENT.md` — a borrowed body, a Red mind — is correct for this
interpreter and should not be rewritten now, but the bridge/pure-function
split is not a permanent property of the language. Worth knowing before
anyone designs a third layer on top of it.

0.6.6 itself is a substantial release **[W]**: a **precise** garbage collector
(replacing the old conservative one), node-frame compaction, an external
resources manager for images and fonts, and system-allocation tracking. The
32-bit-only, no-async-I/O limits are the acknowledged 0.7 / 1.0 work.

---

## 13. Aggregates: `map!`, `object!`, typesets

### 13.1 ⚠️ `#[...]` is a map. `#(...)` is a constructor. `[...]` is a block.

Horror 1, worth restating because the three look similar and mean completely
different things. **[V]**

```
mold #[a 1 b 2]        →  {#[
                              a: 1
                              b: 2]}
mold form #[a 1 b 2]   →  "a: 1\nb: 2"
mold (make map! 10)    →  "#[]"
mold (make map! [a 1]) →  "#[ a: 1 ]"
mold #(integer!)       →  "integer!"    ;-- a datatype!
mold #(true)           →  "true"        ;-- a logic! literal
mold #(none)           →  "none"
mold type? #[a 1]      →  "map!"
mold type? make map! 10 → "map!"
```

`make map!` with a block body **does** build a map. The folklore that it is
"refused" is a garbled reading of `#()` being a construction spec — which is
true. Use `#[a 1 b 2]` or `make map! [a 1]`.

`construct` needs the **set-word** form **[V]**:
`mold (construct [a: 1 b: 2])` → `make object! [ a: 1 b: 2 ]`, while
`mold (construct [a 1 b 2])` → `make object! []`.

### 13.2 `object!` **[V]**

```
mold (make object! [a: 1 b: 2])    →  make object! [ a: 1  b: 2 ]
mold type? make object! [a: 1]     →  "object!"
mold words-of make object! [a: 1]  →  "[a]"
mold sort words-of o               →  "[a b]"
mold (make object! [a: 1] /copy)   →  "/copy"    ;-- /copy is NOT a refinement
```

⚠️ Copy an object with `copy`, not `/copy`.

### 13.3 Typesets **[S]** **[W]**

A typeset is *"sets of datatype values stored in a compact array of bits (up
to 96 bits)"* **[W]** — the official term is **pseudo-type** **[W glossary]**.

Built in: `all-word!` `any-block!` `any-function!` `any-list!` `any-object!`
`any-path!` `any-string!` `any-type!` `any-word!` `default!` `immediate!`
`internal!` `number!` `scalar!` `series!` `planar!` `any-point!` `external!`

Usable in any spec: `func [n [number!]]`, or your own:
`make typeset! [integer! string!]`.

---

## 14. Official coding style **[W]**

From the Red style guide, which is a **prerequisite for contributing
upstream**. The Imp code mostly already follows it.

* **Indentation:** tabs, size 4, one per block. Contributed files should carry
  `Tabs: 4` in the header.
* **Line length:** about 100 columns; a full line must fit in half a 1080p
  width.
* **Names:** lowercase by default (uppercase for acronyms and OS APIs).
  Variables are single-word **nouns**; multi-word names use dashes
  (`lost-items`, never `lostItems` or `lost_items`). Functions are **verbs**
  (`make`, `reduce`, `allow`, `crunch`) and start with the verb
  (`fill-blue`, never `blue-fill`).
* **Functions:** keep the spec block on one line where it fits; type
  annotations aligned on one column; each refinement on its own line; the
  attributes block on its own line; the main docstring on its own line if the
  spec wraps. Docstrings start with a capital and take no trailing dot.
* **Calls:** arguments follow the call on the same line; if wrapping, one per
  line, each indented by one level.
* **Comments:** `;--` prefix; single-line comments start at column 57; use
  several single-line comments rather than `comment {…}`.
* **Strings:** `""` for single-line, `{}` for multi-line. Prefer `{}` over
  escaping `^"` when a single-line string contains a quote.
* **Blocks:** `a: []` — no whitespace inside empty blocks. Contiguous blocks
  need no separation: `[][]`, `[]()`.

### 14.1 ⚠️ Never break a call across lines before its blocks

The style guide calls this out explicitly **[W]**:

> ```red
> b: either a = 1
>      [a + 1][123 + length? mold a]
> ```
> *That style is wrong because it breaks the ability to copy/paste code to
> the Red console (`either` will be evaluated before the block arguments are
> detected).*

A `paren!`/`block!` is a separate expression boundary. If the function name
is on the previous line, the interpreter runs the call with no arguments
before it ever sees the blocks. Keep them together:

```red
b: either a = 1 [
     a + 1
][
     123 + length? mold a
]
```

One-line is also fine and is what the guide prefers for small blocks:
`b: either a = 1 [a + 1][3]` — measured working **[V]**
(`mold (either true [1][2])` → `1`).

---

## 15. Official vocabulary **[W]**

From the official glossary, so the words mean what the project means:

| Term | Meaning |
|---|---|
| **Action** | *"One of a fixed set of functions all datatypes may support. Not all datatypes support all actions."* — the 59 in §17. |
| **Op** | *"A function with an infix interface, where the first arg appears to the left of the function name."* |
| **Native** | *"Functions written in Red/System, and exposed for use in Red."* — the 107. |
| **Mezzanine** | *"a function written wholly in Red that is included in the standard distribution."* — the 63 in §18. |
| **Routine** | *"A Red/System function written inline in Red."* |
| **Pseudo-type** | *"An informal name for `typeset`."* |
| **Dialect** | *"An embedded DSL that shares the same syntax as the Red language."* |
| **Datatype** | *"Datatypes are the foundation of Red…"* |
| **Module** | a separately loaded unit (View, etc.) |
| **libRed** | Red as an embeddable dynamic library (~1 MB) **[W Wikipedia]** |

`imp` is a *mezzanine*-shaped codebase: a handful of pure-Red functions
named for what they do. That is the right shape.

---

## 16. The imp core, as it actually is

Read from `src/core.red`, re-measured with correct arities **[V]**.

| True name | Plain name | Signature | Measured |
|---|---|---|---|
| `BEAST` | the number | a global `integer!` | `666` |
| `LEDGER-P` / `LEDGER-F` | passed / failed | two globals | `0` / `0` |
| `FALLEN` | the ASCII map | a 72-element `block!` of glyph/replacement **pairs** | `length? FALLEN` → `72` |
| `weigh-cell` | char width | `func [ch [char!]]` → `integer!` | `#"`x"`→`1`, `𠔡`→`2` |
| `unmake` | `to_ascii` | `func [ch [char!]]` → `string!` | `#"`│"`→`" "`, unknown→`" "` |
| `sever` | `split_lines` | `func [s [string!] delim [string!]]` → `block!` | `"a,b,c" ","`→`["a" "b" "c"]`, `"" ","`→`[""]`, `"a,,b"`→`["a" "" "b"]` |
| `m-end` | `find_esc_end` | `func [s [string!] i [integer!]]` | `"abc" 0`→`none`; on a real escape at 1→`11` |
| `well-formed?` | `is_sgr` | `func [seq [string!]]` → `logic!` | `[0m`→`true`, `[38;5;175m`→`true`, `[38;zzm`→`false` |
| `beast-allows?` | `style_permits` | `func [seq [string!] style [word!]]` | see §16.1 |
| `flay-line` | `clean_line` | `func [raw [string!] style [word!] width [integer!]]` | `"abc" 'unicode 5` → `"abc\e[0m  "` |
| `bare` | `strip_ansi` | `func [s [string!]]` | strips SGR → `"AB"` |
| `true-span` | `visible_width` | `func [ln [string!]]` → `integer!` | `"abc"`→`3`, `"樯樯"`→`4`, `""`→`0` |
| `reap` | `normalize_art` | `func [text [string!] style [word!] width [integer!] height [integer!]]` | `"hi" 'ascii 4 2` → 2 lines of 4 visible columns |
| `hold-rite` | assert | `func [name [string!] won [logic!] witness [string!]]` | **BROKEN — §6.7** |

### 16.1 The wound, re-measured **[V]**

`beast-allows?` on a `38;5;175` SGR sequence, by style:

| style | allows? |
|---|---|
| `unicode` | `true` |
| `ascii` | `false` |
| `ansi16` | `false` |
| `ansi256` | `false` |
| `truecolor` | `false` |

The documented wound — the allowlist advances past `38` without consuming
its operands — is real. `ansi256` and `truecolor` strip the sequence.

> **One correction.** `GRIMOIRE.md` says the wound leaves *"`unicode` (the
> default) and `ansi16` unaffected."* `ansi16` is **not** unaffected: its
> allowlist contains no `38` at all (`core.red:137-149` admits only
> `0 1 2 22`, `30–37`, `90–97`, `39–49`), so `38;5;175` is correctly
> rejected. Only `unicode` passes it through. This matters if anyone tries
> to "fix" the wound by widening the `ansi16` list.
>
> **The cause was found, and it is already documented.** `GRIMOIRE.md`
> horror 17 is the explanation: `core.red:143` tests
> `all [v = 0 v = 1 v = 2 v = 22]`, which in Red means *"v equals **all four**"*
> — never true. It was meant to be an OR. Measured **[V]**:
> ```
> mold (all [1 = 0 1 = 1 1 = 2 1 = 22])              →  "none"
> mold (any [(all [1 = 0 1 = 1]) (all [1 >= 30 1 <= 37])])  →  "none"
> mold (any [(all [31 = 0 31 = 1]) (all [31 >= 30 31 <= 37])])  →  "true"
> ```
> So a bare bold `1` is rejected while `31` alone is accepted, and `1;31`
> fails on its first parameter. **The `1;31` anomaly is horror 17, not a
> mystery.** Fixing it is a one-word change: `all` → `any` at
> `core.red:143`, plus updating the test that pins the wound.
>
> **A note on how it nearly got mis-filed:** a helper written as
> `e: func [s][to char! 27 s]` does *not* prepend ESC — `to` is a 2-argument
> action, so the third expression is a separate statement and the function
> returns `s` alone. Every result computed through that helper was
> meaningless. The bug was caught because the results contradicted the
> source, not because the harness noticed.

---

## 17. The 107 natives **[S]**

From `runtime/macros.reds` `#enum natives!`, in order.

**Control & evaluation** `if` `unless` `either` `any` `all` `while` `until`
`loop` `repeat` `forever` `foreach` `forall` `remove-each` `func` `function`
`does` `has` `switch` `case` `do` `get` `set` `print` `prin` `reduce`
`compose` `try`

**Comparison & logic** `equal?` `not-equal?` `strict-equal?` `lesser?`
`greater?` `lesser-or-equal?` `greater-or-equal?` `same?` `not` `type?`
`value?` `zero?` `sign?` `in`

**Sets** `union` `unique` `intersect` `difference` `exclude` `complement?`

**Math** `max` `min` `shift` `to-hex` `sine` `cosine` `tangent` `arcsine`
`arccosine` `arctangent` `arctangent2` `nan?` `log-2` `log-10` `log-e` `exp`
`square-root` `negative?` `positive?`

**Conversion & strings** `construct` `dehex` `enhex` `enbase` `debase`
`uppercase` `lowercase` `as-pair` `as-point2D` `as-point3D` `as-money` `as`
`call` `size?`

**Reflection & system** `stats` `bind` `context?` `throw` `catch` `extend`
`apply` `transcode` `recycle` `browse` `compress` `decompress` `now`
`set-env` `get-env` `list-env` `to-local-file` `checksum` `new-line`
`new-line?` `wait` `unset` `break` `continue` `exit` `return`

Presence in this build, spot-checked **[V]**: `attempt` `do` `sort` `parse`
`remove-each` `bind` `routine` `throw` `catch` `recycle` `stats` `value?`
`transcode` `apply` `size?` `sign?` `zero?` `context?` `list-env` `get-env`
`set-env` `browse` `compress` `decompress` `now` `halt` `quit` `split`
`react` `view` `unview` `draw` are all present. **`join` is not.** `pad`
exists (View); `center`, `use`, `global`, `protect`, `unprotect`,
`infix?`, `enforce`, `cond`, `sleep`, `format`, `ipv6`, `composite`, `map`
(HOF) do not.

### 17.1 Three things that are present and nobody here uses

* **`split`** — the block-aware string/series splitter, redesigned in 2021
  as a *dialected* interface. `mold (split "a,b,c" ",")` → `["a" "b" "c"]`
  **[V]**. `split/part` and `split/words` do **not** exist in 0.6.6, and
  `split [1 2 3] [2]` errors. It is `sever`'s standard-library cousin and
  probably the right tool for one-character delimiters.
* **`do/trace` — the interpreter event system.** The 2021 release added
  event generation to the interpreter, and it works here **[V]**:
  `do/trace [1 + 2] <callback>` evaluates and returns `3`, having emitted
  `INIT ENTER FETCH OPEN PUSH CALL RETURN EXIT END` to the callback.
  Callback spec **[W]**:
  `func [event [word!] code [any-block! none!] offset [integer!] value [any-type!] ref [any-type!] frame [pair!]]`.
  It ships an interactive **debugger**, a **profiler** and a **tracer** on
  top. For a project whose console has no stdout and whose errors go to a
  window, this is the missing debugging story — see §21.4.
* **`r/near` — the error context field.** `mold (r: try [1 / 0] r/near)` →
  `[1 / 0]` **[V]**. Announced in 2021 as a branch; it has landed. Useful
  for a `hold-rite`-style witness that records *where* a failure happened,
  not just that one did.

---

## 17A. Eight facts found by reading the code

These came out of studying 652 real Red files and the upstream test suite.
All **[V]** re-measured on our build. Full treatment and citations in
[`RED-IDIOMS.md`](RED-IDIOMS.md) §3.

### 17A.1 `()` is `unset!`, not `none!`

```
mold type? ()      →  "unset!"
mold type? none    →  "none!"
```
`()` is the "no value" literal and it is a **true `unset!`**, distinct from
`none`. It propagates through `set/any` and `get/any` unchanged **[U]**.

### 17A.2 `set` returns the **value**, not the target

```
a: 0
mold (set 'a 42)         →  "42"
mold (set [p q] [7 8])   →  "[7 8]"
mold p                   →  "7"
```
So `set` is usable in an expression. It is not a statement, whatever it
looks like.

### 17A.3 `context` is a fifth constructor, and it makes an `object!`

```
mold type? :context       →  "function!"
mold context [return 100] →  100
mold (context [123])      →  "make object! []"
```
It evaluates the body and returns an **object**. `return` inside it is
legal **[U]**. Not mentioned anywhere in this repo's docs.

### 17A.4 Refinements bind by **name**, in any order at the call site

```
f: func [/A argA /B argB][reduce [argA argB]]
mold (f/A/B 5 6)     →  [5 6]
mold (f/B/A 7 5)     →  [5 7]      ;-- swapped

f2: func [/A argA [string!] /B argB [integer!]][reduce [argA argB]]
mold (f2/B/A 7 "b")  →  ["b" 7]    ;-- types follow the REFINEMENT
```
**Argument types are checked against the refinement named at the call
site**, not the declaration order. Powerful, and a trap.

### 17A.5 `return:` is documentation, not enforcement

```
g: func [return: [logic!]][either true [1 = 3][false]]
mold g   →  "false"
```
Type checking happens on **arguments** only. A lying `return:` is silent.

### 17A.6 `func` does **not** create locals; `function` does

The most important spec fact, and the easiest to get wrong. **[V]**

```
ri: 100
f1: func [][ri: 2 ri]      →  2
mold ri                     →  "2"     ;-- the GLOBAL was clobbered
mold spec-of :f1            →  "[]"    ;-- and the spec is empty

f2: function [][rj: 2 rj]  →  2
mold type? get 'rj          →  ERR script / no-value   ;-- invisible globally
mold spec-of :f2            →  "[/local rj]"           ;-- hoisted automatically
```

> If you write `func` and assign a word in the body **without declaring it
> in `/local`**, you are writing to the **global context**. The failure is
> silent.

`src/core.red` declares `/local` on every function and is therefore
correct — but the reason is not obvious from the signature.

### 17A.7 `:x` get-arguments receive an **unreduced** `paren!`

```
getf: func [:x][type? :x]
mold (getf 1 + 2)      →  ERR script / expect-arg
mold (getf (1 + 2))    →  "paren!"
```
A parenthesised expression passed to a `:`-argument arrives **unreduced**.
`'x` lit-arguments get the unevaluated expression, and a `()` there *is*
reduced. A `:x` is also a **write-through reference** — `set x …` mutates
the caller's word **[U]**.

### 17A.8 `all`/`any` short-circuit for *values*, but not reliably for *side effects*

**Verified:** **[V]**
```
n: 0
mold (all [false (s())])   →  "none"   ;--  s() never ran;  n = 0
mold (any [true (s())])    →  "true"   ;--  s() never ran;  n = 0
```

**But a bare-word call in the block can still be evaluated:** **[V]**
```
boom: func [] [n: n + 1 1 / 0]
mold try (all [false boom()])  →  ERR
mold n                         →  "1"     ;-- boom() WAS called
```

> **Do not rely on `all`/`any` to suppress side effects.** Wrap
> side-effecting calls in parens, or do the effect after the test.

---

## 18. The 59 actions **[S]**

**General** `make` `random` `reflect` `to` `form` `mold` `modify`

**Scalar** `absolute` `add` `divide` `multiply` `negate` `power` `remainder`
`round` `subtract` `even?` `odd?`

**Bitwise** `and~` `complement` `or~` `xor~`

**Series** `append` `at` `back` `change` `clear` `copy` `find` `head`
`head?` `index?` `insert` `length?` `move` `next` `pick` `poke` `put` `remove`
`reverse` `select` `sort` `skip` `swap` `tail` `tail?` `take` `trim`

**I/O** `create` `close` `delete` `open` `open?` `query` `read` `rename`
`update` `write`

Per-datatype dispatch tables are in `runtime/datatypes/*.reds` **[S]** — 54
files, one per datatype, each listing exactly which actions it implements and
which it inherits. That is the file to read when you need to know whether
`something` works on `binary!`.

The 63 **mezzanine** functions (written in Red, shipped in the
distribution) are listed in `environment/functions.red` **[S]**, including
`also` `attempt` `repend` `replace` `math` `offset?` `suffix?` `scan` `load`
`save` `cause-error` `pad` `mod` `eval-set-path` `to-red-file` `dir?`
`clean-path` `split-path` `do-file` `read-thru` `load-thru` `do-thru`
`cos` `sin` `tan` `acos` `asin` `atan` `atan2` `sqrt` `rejoin` `sum`
`average` `last?` `dt` `clock` and more.

### The generated families **[S]**

`functions.red:120-152` generates, for **every** datatype `X!`:

```red
type? 1          ;-- "integer!"
integer? 1       ;-- true
to-integer 3.7   ;-- 3
```

and for every typeset, an `any-…?` test, and for `datatype!` itself a
`datatype?` test.

---

## 19. Corrections to the project's folklore

The single most useful table in this document. Every row was measured.

| Folklore | Measured / documented truth | §|
|---|---|---|
| "`parse` returns `logic` for a block rule. It is dead. **Never reintroduce it.**" | `logic!` is the **documented default**; `collect`/`keep` make it a full extractor. The parser works. | §9 |
| "`none - 1` is `none`, i.e. false" | It **errors**: `script / expect-arg` | §4 |
| "`none?` is absent — use `= none`" | **`none?` exists**, a `function!` | §17 |
| "`and`/`or` are absent" | Both exist as `op!` — bitwise, **not** Rebol's | §17 |
| "`#()` maps … `make map!` is refused" | `make map! [a 1]` **works**; `#()` is a constructor | §13.1 |
| "`return` in a loop does not leave the function" | It **does**; no spin. Hygiene, not necessity. | §5.2 |
| "The wound leaves `ansi16` unaffected" | `ansi16` **rejects** `38;5;N` — no `38` in its allowlist | §16.1 |
| `if cond [a][b]` "evaluates both sides" | Precisely: `if` reads one block, `[b]` becomes a **separate next statement** | §5.1 |
| `forall` is usable | It **errors** in all three forms | §5.5 |
| `case/else` is available | `case [else […]]` → `ERR script / no-value` | §5.4 |
| `and`/`or` are the boolean connectives | They are the **bitwise** `and~`/`or~`/`xor~`. The combinators are `all`/`any`. | §17A |
| A missing `Red [...]` header is optional | It is not — a file without one dies `syntax / no-header` | §1.2 |

**Confirmed, keep believing these:**

* `join` is genuinely absent. Use `rejoin`.
* `append` to a file literal is a genuine silent no-op (§20).
* `find`/`index?` (bytes) vs `copy/part`/`length?` (chars) genuinely diverge.
* A two-block `if` genuinely changes your program's shape.
* A missing `Red [...]` header genuinely kills the file.
* `do` genuinely `change-dir`s to the script's directory.
* A parse error genuinely kills the whole script silently.
* `wait` genuinely hangs. Red 0.6.6 genuinely cannot block.

---

## 20. `append` to a file literal is a silent no-op

The most dangerous runtime behaviour in this substrate. **[V]**

```red
write %h7.txt "start"
append %h7.txt "MORE"
mold (read %h7.txt)   →  {"start"}      ;-- the append vanished
```

`append` on a `file!` returns a mangled file value and writes nothing:

```
mold (append %v.txt "y")   →  "%v.txty"
```

The only reliable accumulation is to build the whole payload and write once:

```red
ledger: copy []
say: func [s [string!]][
    append ledger s
    write %verdict.txt rejoin ledger      ;-- rewrite the WHOLE file
]
```

That is exactly what `tests/rites/rite-two.red` does, and why it works.
`write/append` also works **[V]**.

---

## 21. Open questions for the next hand

Three things this research turned up that need a human decision, because
they change laws rather than code.

1. **The `parse` excommunication should be re-written.** `parse` works
   (§9). `sever` is fine and should stay as the default splitter, but
   `AGENTS.md`'s *"The PEG `parse` is **excommunicated** in this build — Never
   reintroduce it"* currently forbids working, tested language features. The
   honest amendment keeps the process rule (nothing reaches production
   without a rite) and drops the capability claim.
   **Corroboration:** see `RED-PROJECTS.md` §3.2 — the one independent
   commercial Red product abandoned XML schemas *in favour of* a `parse`
   dialect, and the Red team published an essay saying so.
2. **`hold-rite` is dead code** (§6.7). Delete it or fix the two `global`
   lines. Note that `r/near` (§17.1) gives it something real to report.
3. **`case/else` and `forall` should be added to the hazard list**, since
   both look available and both fail.
4. **We are debugging blind and there is a debugger in the box.**
   `do/trace` and its bundled profiler are present and working (§17.1).
   The whole `rited`/`red-eval` apparatus in this repo exists to work
   around the fact that errors go to a window. A rite whose "testimony
   file never appeared" has, for eight batches of research, been
   indistinguishable from a compile error — a `DEAD` verdict. `do/trace`
   would tell us which. Worth one rite to prove it, then wiring into
   `probe-run.sh`.
5. **`split` exists** (§17.1) and may be a better default than `sever` for
   single-character delimiters. Not a change to make now — `sever` is
   sealed and tested — but the next hand should know the option is there.
6. **A false comment is a defect, and one was fixed.** `src/core.red:79-82`
   claimed `return` inside a loop spins forever. Measured false, and the
   Red sources use `return` in loops ~95 times. The *rule* was kept (the
   core is sealed; the discipline is good) but the *reason* was corrected
   in place, pointing at `RED-IDIOMS.md` §0. The eight seals still pass.
7. **`all`/`any` are not side-effect barriers** (§17A.8). Any guard in this
   codebase that relies on a later clause being skipped is relying on
   something unmeasured. The sealed core does not — but a future rite
   might.

---

## 22. The twenty-one hazards

Every one is **[V]**-measured on this build.

### The language will lie to you

1. **No operator precedence.** `1 + 2 * 3` is **9**. Parenthesise. *(§2)*
2. **Comparison binds at the same rank as arithmetic.** `x = y - 1` parses as
   `(x = y) - 1` and raises. *(§2.2)*
3. **`if` takes one block.** The second silently becomes the next statement.
   Use `either`. *(§5.1)*
4. **Infix operators need surrounding spaces.** `1+2*3` is a dead rite. *(§3)*
5. **An anonymous `func` in expression position is not called.**
   `mold (func [a][a+1] 5)` is `5`, not `6`. Name your functions. *(§6.4)*
6. **`none` in arithmetic raises** `script / expect-arg`. *(§4)*
7. **Zero and `""` are truthy.** Only `none` and `false` are falsy. *(§4)*
8. **`case` has no `else`** in this build. *(§5.4)*
9. **`forall` does not work** in any of its forms. *(§5.5)*

### The runtime will hide from you

10. **A parse error kills the whole script, silently** — no partial output.
    Bisect by truncating. *(§0)*
11. **The console can wedge**, and every later rite then *looks* like a
    compile error. Health-check and rebuild. *(§0)*
12. **The console will not auto-run a startup script.** Type it. *(§1.4)*
13. **`do` change-dirs to the script's directory.** Stage in the Imp root. *(§1.3)*
14. **One console instance at a time.** A second writes nothing. *(§1.5)*
15. **Errors go to a window, not a stream.** Every rite writes a testimony
    file. *(§12)*
16. **A missing `Red [...]` header** kills the file with `syntax / no-header`. *(§1.2)*
17. **Never break a call across lines before its blocks** — the interpreter
    runs the call first. *(§14.1)*

### The data model will surprise you

18. **Appending to a series moves every window onto it.** `b: next a` then
    `append a "x"` changes `b` too. *(§7.2)*
19. **`find`/`index?` count bytes; `length?`/`copy/part`/`pick` count
    characters.** A `樯` is 3 bytes and 1 character. *(§7.4)*
20. **`insert`/`change`/`remove` return a position**, not the series. Use
    `head`. `append` returns the head. *(§7.3)*
21. **`append %file "x"` is a silent no-op.** Build the whole string and
    write once. *(§20)*

---

## 23. Cheat sheet

```red
Red [Title: "thing"]                    ;-- every file needs this

;; arithmetic — parenthesise, spaces, no trust
mold (1 + 2 * 3)                        ;-- 9, not 7
mold (x = (y - 1))                      ;-- NEVER x = y - 1

;; branching
either cond [do-a][do-b]               ;-- never `if c [a][b]`
either any [a b] [fallback]             ;-- `any` is the or-form
either all [a b] [proceed]              ;-- `all` is the and-form
if cond [do-a]                          ;-- returns none! when false

;; series — and remember append moves every window
head insert copy series value           ;-- insert then rewind
head change series value                ;-- change then rewind
append series value                     ;-- append already rewinds
copy/part at series index length        ;-- slicing (characters)
index? find series needle               ;-- byte index

;; parse — it works, but collect/keep to extract
parse "a,b,c" [collect [some [keep "," to ","]]]

;; strings
rejoin [a b c]                          ;-- NOT `join`
uppercase / lowercase
to string! value

;; errors
r: try/all [risky]                      ;-- ONE value
either error? r [r/id][r]               ;-- id is the useful field
attempt [risky]                         ;-- value or none

;; functions
named: func [a [integer!] /local b][
    b: a * 2
    b
]                                        ;-- always name it

;; reflection
spec-of :my-func                        ;-- always works
body-of :my-func                        ;-- always works
words-of :my-func                       ;-- functions only, not actions
```

---

## 24. Appendix — sources and reproduction

### Primary sources

| Source | URL | Used for |
|---|---|---|
| Red/System Language Specification, rev. 60, 2022-08-09 | `static.red-lang.org/red-system-specs.html` | The evaluation-order rule, §5.2; identifier rules §3 |
| Red official docs repo | `github.com/red/docs` (`en/*.adoc`) | parse, preprocessor, lexer, typesets, style guide, glossary |
| Parse dialect | `en/parse.adoc` | `collect`/`keep`, the full rule set, the `logic!` default |
| Preprocessor | `en/preprocessor.adoc` | every `#directive`, `expand-directives` |
| Lexer | `en/lexer.adoc` | `transcode` `scan` `load/next` `transcode/trace` |
| Typesets | `en/typesets.adoc` | the series/aliasing example, full typeset list |
| Coding Style Guide | `en/style-guide.adoc` | §14 |
| Glossary | `en/glossary.adoc` | §15 |
| red-lang.org blog | `red-lang.org` | 0.6.6 release notes; roadmap; static linking; Text-UI backend |
| Roadmap | `red-lang.org/p/roadmap_2.html` | v0.7 async I/O, v1.0 64-bit, v2.0 JIT |
| Wikipedia | `en.wikipedia.org/wiki/Red_(programming_language)` | history, licence, two-language design |
| Learn X in Y minutes | `learnxinyminutes.com/red/` | header rules, corroborating examples |

⚠️ The GitHub `red/docs` tree is **"a work in progress, only a few pieces
are available"** **[W]** and describes `master`, which is *ahead* of 0.6.6.
Where it and the shipped build disagree, this document follows the build and
says so. `parse` is the main case: the docs describe more rules than 0.6.6
behaves well (§9.4).

### Local sources

`red-view-src/environment/` — natives, actions, functions, routines
`red-view-src/encapper/compiler.r` — the Red language compiler
`red-view-src/runtime/` — lexer, parse, natives, datatypes, macros
`red-view-src/system/compiler.r` — the Red/System compiler (different language)
`red-view-src/tests/source/units/` — the upstream test suite, a spec by example
`red-view-src/docs/lexer/lexer-states.txt` — the 66-state FSM

### The measurement reports

**726 measured answers** across 12 batches, plus 10 whole-file preprocessor
rites, all checked in under `imp/.probes/`:

| File | Lines | Subject |
|---|---|---|
| `b1-report.txt` | 44 | precedence, `none`, control flow |
| `b2-report.txt` | 39 | operators, comparisons, arithmetic |
| `b3-report.txt` | 67 | loops, `return`, `switch`/`case`, functions |
| `b4-report.txt` | 85 | series, strings, navigation, copying |
| `b5-report.txt` | 132 | `parse`, maps, literals, types, I/O, codecs |
| `b6-report.txt` | 57 | the ten horrors, verified |
| `b7-report.txt` | 92 | the imp core; errors; conversions |
| `b8-report.txt` | 76 | reflection, presence census, misc |
| `b9-report.txt` | 26 | `words-of`/`spec-of`, `construct`, `forall` |
| `b10-report.txt` | 26 | `%` re-test, re-confirmations |
| `b11-report.txt` | 43 | **`parse`/`collect`, the `x = y - 1` error** |
| `b12-report.txt` | 39 | official series-aliasing example, lexer API |
| `b13-report.txt` | 36 | `do/trace`, `split`, `r/near`, View, absent census |
| `b14-report.txt` | 57 | `context`, refinements by name, `()` = `unset!`, `func` vs `function` |
| `b15-report.txt` | 14 | the `all`/`any` allowlist bug (horror 17) |

833 measured answers in total across 15 batches, plus 10 whole-file
preprocessor rites, all checked in under `imp/.probes/`.

Each line is `question → answer`. `*** DEAD ***` means the rite produced no
answer: a compile error, or a value that would not mould. Some lines appear
twice where the harness retried after a console wedge.

The preprocessor rites are `imp/.probes/pp/p01.red` … `p10.red`.

### Running the harness

```bash
./scripts/red-eval init                       # bring up the oracle
./scripts/probe-run.sh .probes/b11.txt b11     # re-run a batch
grep -n "collect" .probes/b11-report.txt       # find one answer
```

Requirements: an X display `red-view` can authenticate against, and `xdotool`.

### A word on the harness

`DEAD` is a **harness** verdict, not a language verdict. It produced both
true positives (genuine compile errors) and false ones (a wedged console, or
a rite whose answer would not mould). One false positive — `7 % 3` reported
dead — is recorded in §8.1 rather than quietly deleted, because the honest
thing about a measurement is to show the measurement that got it wrong.

**Rule: any surprising result gets re-tested in a fresh console before it
goes in the manual.**

---

## 25. One last thing

Red is a small, old, opinionated language, and almost all of its opinions
are *refusals*: no precedence, no ratio, no `else` on `if`, no closures, no
classes, no `join`, no `and`/`or` that mean what you expect. The code here
is full of workarounds — `sever`, `either` instead of `if/else`,
`subtract a b` instead of `a - b`, `FALLEN` walked by hand — and each one is
a scar from a real, measured failure.

But most of those scars turned out to be **unnecessary**. `none?` exists.
`and` and `or` exist. `make map!` works. `return` in a loop is fine.
`forall` is the broken one, not `parse`. The grammar in `src/core.red` is
careful, correct work built on five beliefs that the interpreter does not
support.

`docs/GRIMOIRE.md` is the exit. This document is the map of the ground
between here and there — including the parts of the map that were drawn
wrong.
