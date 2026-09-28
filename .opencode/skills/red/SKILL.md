---
name: red
description: Use when writing, debugging, or reviewing Red code — especially in the imp project. Red is a Rebol-like language with no operator precedence, a VID layout dialect, and a runtime that fails silently. This skill teaches the traps that cost real time.
---

# Red

Red is a Rebol-like language. It is **not** Lisp, **not** Python, and **not**
what you expect. The single most important fact:

> **There is no operator precedence.** Evaluation is strictly left-to-right.
> `x = y - 1` is `(x = y) - 1`. Parenthesise every comparison.

## The five traps that cost the most time

### 1. No operator precedence

```red
;-- WRONG: parses as (x = y) - 1
if x = y - 1 [...]

;-- RIGHT
if (x = (y - 1)) [...]
```

Bind to a word first, then compare. This is not pedantry — it is the
difference between a working program and a silent wrong answer.

### 2. VID takes a literal, not an expression

VID is the layout dialect inside `layout`. `text 200 (mold mode)` is
`vid-invalid-syntax`. Bind the value to a word first:

```red
mode-text: form mode          ;-- outside the layout
mode-face: text 200 mode-text font [color: 210.210.220 size: 12]
```

### 3. `mold` of a string is a curly-brace string

`mold "normal"` is `{"normal"}`, not `"normal"`. That is what lands in a
face. `form "normal"` is `normal`. **Use `form` for face text.**

### 4. `//` is modulo, not division

`h // 12` gives 0–11, and `pick MODES 8` is `none` (pick is 1-based). Use
`divide` (returns `decimal!`, so wrap with `to integer!`) and add 1:

```red
mode: pick MODES (to integer! (divide h 12) + 1)
```

### 5. A synthetic event's key is a char; a real arrow key is a word

`event/key` for a synthetic event is a char (`key: #"l"` → `#"l"`). A real
arrow key is a word (`_left`). A switch on `left` matches neither:

```red
on-key [
    switch event/key [
        #"l"  [mode-face/text: "braille"]   ;-- synthetic
        _left [mode-face/text: "braille"]   ;-- real
    ]
]
```

## VID — the view dialect

- **`layout compose/deep` + `on-key` is `vid-invalid-syntax`.** Use a plain
  `layout`. `compose/deep` alone works, `on-key` alone works, both together
  fail.
- **`on-key` goes FIRST in the layout.** Last, and `win/actors` is `none` —
  the actor never attaches. An actor *can* reference a face defined later in
  the same layout.
- **VID takes a literal, not an expression** (see trap 2).

## The series model

Red's core data structure is the **series** — a block, string, or other
ordered collection. Key facts:

- `pick` is **1-based**. `pick block 0` is `none!`.
- `append` **flattens** a block. Use `append/only` to append as one element.
- `find`/`index?` count **bytes**; `length?`/`copy/part`/`pick` count
  **characters**. A `樯` is 3 bytes, 1 character.
- `replace` on a block finds the **value**, not the position. `poke` is
  positional and returns the assigned value, not the series — call it bare.
- `/` and `divide` both return `decimal!` for integer operands. Wrap with
  `to integer!` when you mean an integer.

## The error model

- **`try` returns ONE value.** Never `set [a b] try [...]`. Take one value
  and test it with `error?`.
- **`either` takes TWO blocks, always.** A one-armed `either` is a fatal
  error with no message.
- **`if` returns `none!` when false.** Never end a function on a conditional.
  Assign inside the branch, return the variable.
- **Load errors are total and silent.** A parse error kills the whole script
  with no output. Bisect by truncating the file.
- **A caught error carries `code`, `type`, `id`, `arg1..3`, `near`, and
  `where`.** Wrap risky work in `try` and write `mold` of the error.

## The harness laws (imp-specific)

- **A rite's witness is a single end product, written once, at the end.**
  Never a log, never a process. `rited` exits and `pkill`s on first sight of
  a non-empty witness.
- **Stage every rite in the repo root.** `do` change-dirs to the script's
  own directory, so `tests/rites/foo.red` cannot reach `%src/core.red`.
- **One console at a time.** A second `red-view` instance writes nothing.
- **A launch must come from a script that stays alive.** Launched inline, the
  shell exits and red-view dies with it.
- **Open the testimony file before anything that can fail.** `getenv` does
  not exist, and calling it first leaves an empty log.

## The imp project

The imp is a terminal art generator written in pure Red. Bare `imp` opens a
TUI window; `imp "a wish"` conjures ANSI art. The repo is at `~/imp`.

- **`docs/RED.md`** — the complete Red manual for this build. Read it before
  writing Red.
- **`docs/GRIMOIRE.md`** — the hazard map. Every true name, mapped.
- **`AGENTS.md`** — the law. The five-tier covenant is law, not theme park.

## When in doubt

1. Read `docs/RED.md` — it is sourced and execution-verified.
2. Read `docs/GRIMOIRE.md` — the hazard map.
3. Write a rite that writes a testimony file. The GUI console is the only
   oracle on Linux.
4. If a rite dies silently, bisect by truncating the file.
