# RED — idioms, studied from real code

> Patterns extracted by reading the code the language's own author and core
> maintainers write: 652 files in `imp/red-view-src/`, the upstream test
> suite, and published Red sources.
>
> Every claim is **[V]** verified by running it · **[S]** quoted from source
> with a `file:line` reference · **[U]** from the upstream test suite.
>
> Companion: [`RED.md`](RED.md) (the language) ·
> [`RED-PROJECTS.md`](RED-PROJECTS.md) (what people built)

---

## 0. The most important finding in this document

> ## `return` inside a loop is not merely legal — it is the standard mechanism.

`docs/GRIMOIRE.md` horror 8 says `return` nested in a loop "does not leave
the function — it leaves the loop, and the demon spins forever", and
`src/core.red` carries a 5-line comment forbidding it.

**That is false.** I measured it in `RED.md` §5.2. Now I have the code
evidence too: the Red-level tree contains **95+ `return <value>` statements
lexically inside a loop body**, spread across essentially every file the
language author has written.

Two that leave no room for doubt:

`environment/console/engine.red:136-141`
```red
	count: function [s [string!] c [char!] /reverse return: [integer!]][
		cnt: 0
		step: pick [-1 1] reverse
		loop length? head s [either s/1 = c [cnt: cnt + 1 s: skip s step][return cnt]]
		cnt
	]
```
**[S]** `return` out of a `loop` is the only way to bail early, and it is
used unconditionally.

`environment/reactivity.red:120-127` — *the* canonical Red search loop:
```red
	pending?: function [reactor [object!] reaction [block! function!]][
		q: queue
		while [q: find/same/skip q reactor 4][
			if same? :q/2 :reaction [return yes]
			q: skip q 4
		]
		no
	]
```
**[S]** Walk a flat record table, `return` the first match, fall through
to a default at the tail. This is the shape the codebase uses everywhere.

`environment/codecs/CSV.red:226-236` — early validation with a custom error:
```red
		foreach refs disallowed [
			if all refs [
				return make error! rejoin [
					"Cannot use /" refs/1 " and /" refs/2 " refinements together"
				]
			]
		]
```
**[S]**

And from the upstream suite, the behaviour is **asserted**, not incidental
**[U]** `tests/source/units/loop-test.red`:
```red
	--test-- "ex1"   i: 0  loop 3 [i: i + 1 break i: i - 1]      --assert i = 1
	--test-- "ex2"   i: 0  loop 3 [i: i + 1 continue i: i - 1]  --assert i = 3
	--test-- "ex4"   list: [a b c]  while [not tail? list][list: next list break]
	--assert list = [b c]
	--test-- "ex7"   i: 0  loop 3 [i: i + 1 parse "1" [(break)] i: i - 1]
	--assert i = 1
	--test-- "ex8"   foo-ex2: does [parse "1" [(return 124)]]   --assert foo-ex2 = 124
```
`return` out of a **`parse` rule's** inline action unwinds to the enclosing
function. That is asserted behaviour, not folklore.

**And `return` through `if` conditions is transparent** **[U]**
`tests/source/units/function-test.red`:
```red
	--test-- "fun-ret-9"  f: function [][if true [return true]]
	                      g: function [][if f [return 1]]        --assert g = 1
	--test-- "fun-ret-12" g: function [][if not not f [return 1]] --assert g = 1
	--test-- "fun-ret-13" f: function [][if true [return 'X]]
	                      g: function [][if f [return 1]]        --assert g = 1
```

### What to do with the finding

`core.red`'s rule costs nothing and the discipline is good. But the
*comment* is wrong, and a wrong comment is how a future hand ends up
"fixing" working code or refusing to write something correct. Two options:

* **Keep the rule, fix the comment** — say it is a style choice, not a
  language necessity.
* **Relax the rule** — `return` out of a loop is clearer than
  `break`-plus-accumulator-variable in most of the cases the code currently
  works around.

My recommendation: **keep the rule, fix the comment.** `src/core.red` is
sealed and byte-exact against an oracle; there is no bug to fix there. But
the claim must stop being a lie, because a lie in a comment is a load-bearing
defect in a codebase whose entire value is that its comments are true.

---

## 1. Control flow as actually written

### 1.1 `if` is for side effects. `either` is for values.

The rule is applied without exception across the tree.

**`if`/`unless` — pure side effect, `none` on the false branch is harmless:** **[S]**
```red
make-dir: function [
	"Creates the specified directory. No error if already exists"
	path [file!]
	/deep "Create subdirectories too"
][
	if empty? path [return path]
	if slash <> last path [path: dirize path]
	if exists? path [
		if dir? path [return path]
		cause-error 'access 'cannot-open path
	]
	if any [not deep url? path] [
		create-dir path
		return path
	]
]
```
`environment/functions.red:646`

**`either` — whenever a value flows out.** The `word: either …` assignment
form appears 378 times alone: **[S]** `environment/functions.red:179`
```red
repend: func [
	"Appends a reduced value to a series and returns the series head"
	series [series!]
	value
	/only "Appends a block value as a block"
][
	head either any [only not any-block? series][
		insert/only tail series reduce :value
	][
		reduce/into :value tail series					;-- avoids wasting an intermediary block
	]
]
```

### 1.2 `any` is Red's ternary and its coalesce — the single most Red idiom

740 `any [` sites. The shape that replaces every nested `either`:

**[S]** `modules/view/VID.red:596-624` — five nested `any`s collapsed flat:
```red
		either tight [origin: spacing: 0x0][
			origin:  any [select self/styles @origin  self/origin]
			spacing: any [select self/styles @spacing self/spacing]
		]
```
and the four-candidate `any` used as a switch **[S]** same file:
```red
			align: any [								;-- set new alignment
				all [find words spec/2 first spec: next spec] ;-- user-provided mode
				all [value = 'return align]				;-- keep the same mode on `return`
				all [below? 'left]						;-- default for below
				'top									;-- default for across
			]
```

**Defaulting a refinement argument** — the most common use: **[S]**
```red
	face/offset: any [xy face/offset 0x0]                        ; modules/view/view.red:1049
		delimiter: any [delimiter comma]                         ; environment/codecs/CSV.red:239
		quote-char: any [qt-char #"^""]                          ; environment/codecs/CSV.red:240
		result: make any [values/1 0] 0                           ; environment/functions.red:1145
```

**`any` as a type dispatch table**, where a bare `word:` both binds and
serves as the condition **[S]** `environment/console/auto-complete.red:61`:
```red
		case [
			any [function? :w1 action? :w1 native? :w1 routine? :w1] [ … ]
			object? :w1 [word: str  words: words-of w1]
			words: select system/catalog/accessors type?/word :w1 [word: find/last/tail s #"/"]
		]
```

### 1.3 `all` as a guard list, with side effects smuggled in

Because `all` returns the **last** value, a side-effecting expression can go
anywhere except last, and a final flag controls the result. This is
ubiquitous.

**[S]** `environment/tools.red:582-606` — `return` used as a *stop-compiling*
signal rather than a value escape:
```red
						'else [
							unless empty? list: load/all cmd [
								switch/default list/1 [
									watch w	  	[add?: yes do watch]
									parents p	[show-parents event]
									stack s		[show-stack]
									next n		[clear cmd]
									continue c  [options/debug/active?: no clear cmd]
									quit q		[halt]
									help ?		[print dbg-usage]
								][print "Unknown command!"]
							]
						]
```

`all` over a typeset to coerce a value — note the deliberate `to logic!`,
because `all` returns the last value which may not be a `logic!`: **[S]**
`modules/view/utils.red:29-42`
```red
within?: function [
	"Return TRUE if the point is within the rectangle bounds"
	point	[planar!] "XY position"
	offset  [planar!] "Offset of area"
	size	[planar!] "Size of area"
	return: [logic!]
][
	to logic! all [
		point/x >= offset/x
		point/y >= offset/y
		point/x < (offset/x + size/x)
		point/y < (offset/y + size/y)
	]
]
```

### 1.4 ⚠️ The one-liner early-exit idiom

The sharpest trick in the tree **[S]** `environment/tools.red:508-526`:
```red
				any [report? exit]
```
`any` evaluates left to right: if `report?` is true, it returns `true` and
never reaches `exit`; if false, it evaluates `exit`, which leaves the
function. One line, no `if` nesting. It appears once in this exact form, but
`if <guard> [exit]` appears 380 times.

### 1.5 `switch` vs `case` vs the (absent) loop-over-a-block

There is **no `for`** and no "loop over a block" in Red. The four real
substitutes:

| Need | Use |
|---|---|
| dispatch on an exact value | `switch` (multi-value arms, `/default`) |
| dispatch on arbitrary conditions | `case` (final arm `true` or `'else`; `case/all` runs all) |
| fixed count, no index | `loop N [ … ]` |
| count with an index | `repeat i N [ … ]` |
| iterate a series | `foreach` |
| in-place transform with position | `forall` |
| zip two or three series in lockstep | `foreach [a b] s1 s2 [ … ]` |

**Zipped iteration** is the idiomatic map over parallel lists **[S]**
```red
		foreach [name cnt duration] profiling [			;-- generate report
			if unset? name [name: "<anonymous>"]
			print [pad append copy "#" rank 4 pad name 16 #"|" pad cnt 10 #"|" pad duration 10]
			rank: rank + 1
		]
```
`environment/tools.red:644`

```red
		foreach [name codec] system/codecs [
			if find codec/suffixes suffix [return do [codec/decode source]]
		]
```
`environment/functions.red:401` — note this is also the `return`-in-`foreach`
idiom, twice in one function.

**`case` returning a value from every arm** **[S]**
`environment/console/help.red:119-138`:
```red
	form-value: func [value [any-type!]][
		case [
			unset? :value		 [""]
			any-function? :value [fmt any [doc-string :value  spec-of :value]]
			any [any-block? value  vector? value] [ … ]
			any-object? value    [fmt words-of value]
			map? value           [fmt keys-of value]
			image? value         [fmt form reduce ["size:" value/size]]
			typeset? value       [fmt mold to block! value]
			string? value        [fmt/molded value]
			'else                [fmt :value]
		]
	]
```

### 1.6 A habit worth copying: `forever` + `exit`/`break` as scan/succeed

`exit` = failure, `break` = success **[S]**
`modules/view/backends/terminal/ansi-parser.reds:192-204`:
```red
	parse-DSC: func [][
		forever [
			unless next-byte [exit]
			if current-char <> #"^[" [continue]
			unless next-byte [exit]
			if current-char <> #"\" [continue]
			break
		]
	]
```

### 1.7 `parse … (found?: yes) break` as a find-the-marker primitive

Used to locate a script's header. Appears in both the console and the
standard library **[S]** `environment/console/engine.red:314` and
`environment/functions.red:879` are character-for-character identical:
```red
		parse/case script [some [pos: "Red" opt "/System" any ws #"[" (found?: yes) break | skip]]
```

---

## 2. Spec-writing conventions

### 2.1 The canonical shape **[S]**
```red
name: func [
	"Docstring: one line, capital letter, no trailing period"
	arg1	[type!]	"Description"
	arg2	[type!]	"Description"
	return:	[type!]	"Description of the returned value"
	/local
		loc1 [type!]	"Description"
][
	body
]
```

* **One tab** for docstring, args, refinements, `return:`.
* **Two tabs** for `/local` entries.
* Arg names left-aligned; types in a common column; docstrings after types.
* A refinement's arguments go on the **next line**, indented one level
  past the refinement.

**Refinement layout, real example** **[S]** `environment/codecs/CSV.red:210-224`:
```red
	set 'load-csv function [
		"Converts CSV text to a block of rows, where each row is a block of fields."
		data [string!] "Text CSV data to load"
		/with
			delimiter [char! string!] "Delimiter to use (default is comma)"
		/header		"Treat first line as header; implies /as-columns if /as-records is not used"
		/as-columns	"Returns named columns; default names if /header is not used"
		/as-records	"Returns records instead of rows; default names if /header is not used"
		/flat		"Returns a flat block; you need to know the number of fields"
		/trim		"Ignore spaces between quotes and delimiter"
		/quote
			qt-char [char!] "Use different character for quotes than double quote (^\")"
		/extern
			quote-char
	] [
```

### 2.2 Docstring rules, measured across 148 real docstrings **[S]**

| Rule | Count | Notes |
|---|---|---|
| First element of the spec | yes | always |
| Starts with a capital letter | 145 / 148 | |
| **No trailing period** | 140 / 148 | the 8 exceptions are all in `console/help.red` |
| No trailing `!` or `?` | 148 / 148 | |
| Verb-first, 3rd person singular | yes | "Returns…", "Converts…", "Evaluates…" |

`function` bodies usually have a docstring; `does` bodies never do;
`func` bodies in the compiler mostly do not.

### 2.3 `func` vs `function` — the difference is **scoping**, and it bites

This is the single most important spec fact, and the upstream tests prove
it precisely **[U]** `tests/source/units/function-test.red`:
```red
	--test-- "ri8 issue #443"
		ri8-fn: func[ /local ri8-b ri8-i ri8-j ][ … ]
		ri8-i: 100
	--assert 100 = ri8-i
```
versus **[V]** my own measurement, where the `/local` is **absent**:
```
ri: 100
f1: func [][ri: 2 ri]        →  2
mold ri                      →  "2"     ;-- the GLOBAL was clobbered
mold spec-of :f1             →  "[]"    ;-- and the spec is empty
```

and
```
f2: function [][rj: 2 rj]    →  2
mold type? get 'rj           →  ERR script / no-value   ;-- invisible globally
mold r2                      →  "2"
mold spec-of :f2             →  "[/local rj]"           ;-- hoisted automatically
```

> ### `func` does **not** create locals for words you never declared.
> ### `function` hoists every body word into `/local` for you.

**Consequence:** if you write `func` and assign a word in the body without
declaring it in `/local`, you are writing to the **global context**.
`src/core.red` gets this right — it declares `/local` on every function —
but the failure mode is silent and clobbers.

Use `function` unless you specifically want `func`'s behaviour.
`compile.r` and the standard library use `func` + explicit `/local` almost
everywhere, which is the safer, more explicit form.

### 2.4 `/local` order is normalised, not preserved **[U]**
```red
	--test-- "scope 11"  s11-f: function [/extern a /local b][c: 0]
	--assert [/local b c] = spec-of :s11-f
```
`spec-of` of a `function` always re-emits locals as a canonical `/local`
refinement followed by the discovered words, regardless of how you wrote it.

### 2.5 `return:` is documentation, not enforcement **[V]**
```
g: func [return: [logic!]][either true [1 = 3][false]]
mold g   →  "false"        ;-- declared logic!, returned logic!, fine
```
and the test suite proves you can lie to it **[U]**:
```red
	lgc-test3?: func [return: [logic!]][ either true [ 1 = 3 ][ false ] ]
  --test-- "logic-return-5"  --assert not lgc-test3?
```
Type enforcement happens only where a spec says so — i.e. on **arguments**.

### 2.6 Spec shapes the compiler rejects **[U]** `function-test.red`
```red
	--test-- "fsv15"  --assert error? try [do [func [a return: [integer!] b][]]]
	--test-- "fsv16"  --assert error? try [do [func [a return: b][]]]
	--test-- "#3595"  --assert error? try [do [func [return: [block!] "string" word][]]]
	--test-- "#5363"  --assert error? try [do [func [return: [block!] "string" word /local b][]]]
	--test-- "#5552"  --assert error? try [do [f: func [a [block!] return: [block!] /ref /local x][]]]
```
* `return:` must come **first**, before any other argument.
* A word after `return:`'s docstring is an error — use `/local`.
* `return:` must precede `/ref`, and an **empty refinement** before
  `/local` is an error.

### 2.7 `context` — a fifth constructor, and it makes an `object!` **[V]**
```
mold type? :context         →  "function!"
mold context [return 100]   →  100
mold (context [123])        →  "make object! []"     ;-- it EVALUATES then makes an object
```
Not on the AGENTS.md or folklore radar at all. It is `does`-like — a body
with no spec — but it produces an **object**, and `return` inside it is
legal (asserted upstream **[U]** `regression-test-red.red` `#3362`:
`--assert 100 = context [return 100]`).

---

## 3. New verified language facts

These came out of the code study and the test suite. Each is **[V]**
measured on our build unless marked.

### 3.1 `()` produces `unset!`, not `none!` **[V]**
```
mold type? ()        →  "unset!"
mold type? none      →  "none!"
```
`()` is the "no value" literal and it is a **true `unset!`**, distinct from
`none`. Upstream asserts it **[U]** `type-test.red`:
`--assert unset! = type? ()`, and `unset-1` proves it propagates through
`set/any` and `get/any` unchanged.

### 3.2 `set` returns the **value**, not the target **[V]**
```
a: 0
mold (set 'a 42)        →  "42"
mold (set [p q] [7 8])  →  "[7 8]"
mold p                  →  "7"
```
Upstream agrees **[U]** `set-1`, `set-3`. So `set` is usable in an
expression; it is not a statement.

### 3.3 Refinements bind by **name**, in any order at the call site **[V]**
```
f:  func [/A argA /B argB][reduce [argA argB]]
mold (f/A/B 5 6)         →  [5 6]
mold (f/B/A 7 5)         →  [5 7]      ;-- swapped: /A got 5, /B got 7

f2: func [/A argA [string!] /B argB [integer!]][reduce [argA argB]]
mold (f2/B/A 7 "b")      →  ["b" 7]    ;-- types follow the REFINEMENT, not the order
```
**The argument types are checked against the refinement named at the call
site.** `f2/B/A 7 "b"` passes the string to `/A` and the integer to `/B`,
and succeeds. **[U]** `fun-19` asserts this.

This is a genuinely powerful feature and also a trap: `f/A/B x y` and
`f/B/A x y` are different calls with different type requirements.

### 3.4 `:x` get-arguments receive an **unreduced** `paren!` **[V]**
```
getf: func [:x][type? :x]
mold (getf 1 + 2)        →  ERR script / expect-arg
mold (getf (1 + 2))      →  "paren!"
```
A parenthesised expression passed to a `:`-argument arrives as a
`paren!` value, **not** reduced. Upstream **[U]** `fwga2`:
`--assert (first [(20 + 30)]) = fwga-f (20 + 30)`.

By contrast `'x` lit-arguments receive the unevaluated expression, and a
`()` there *is* reduced (`--assert 50 = fwla-f (20 + 30)`, `fwla2`).

And `:x` is a **write-through reference** **[U]** `fwga5`:
```red
		fwga5-f: func[:x][set x 1 + get x]
		--assert 11 = fwga5-i                  ;-- the CALLER's word was mutated
```

### 3.5 `and` / `or` / `xor` are the **bitwise** operators, not combinators **[S][U]**
`operators.red` binds `and`/`or`/`xor` to `and~`/`or~`/`xor~`, whose specs
take `logic! integer! char! bitset! binary! pair! tuple! vector! any-point!`
**[S]**. Upstream tests them as truth tables **[U]**:
```red
	--test-- "and2" --assert true  and false =  false
	--test-- "and3" --assert false and true  =  false
	--test-- "or3"  --assert false or false  =  false
	--test-- "xor3" --assert true  xor true  =  false
```
The short-circuiting combinators are `any` and `all`. **Never reach for
`and`/`or` as a boolean connectives** — they are bit operations and will not
do what you expect.

### 3.6 `all` / `any` short-circuit — but verify, don't assume

**Verified [V]:**
```
n: 0
mold (all [false (s())])   →  "none"   ;  s() never ran
mold n                     →  "0"
mold (any [true (s())])    →  "true"   ;  s() never ran
mold n                     →  "0"
```
Also `mold (all [false (1 / 0)])` → `none` (no `math/zero-divide` raised).

**But** a bare-word call in the block may still be evaluated:
```
n: 0
boom: func [] [n: n + 1 1 / 0]
mold try (all [false boom()])  →  ERR script / expect-arg
mold n                         →  "1"      ;-- boom() WAS called
```

**Rule: do not rely on `all`/`any` to suppress side effects.** They
short-circuit for *values*, but a bare-word function application in the
block can be fetched and evaluated regardless. Wrap side-effecting calls in
parens, or restructure so the effect happens after the test.

### 3.7 `math` uses **different precedence** than the language **[V][U]**
This is the sharpest trap in the language, and it is intentional:

| Expression | Language | `math` |
|---|---|---|
| `1 + 2 * 3` | **9** | **7** |
| `1 + 2 * 4` | **12** | — |
| `2 ** 3 ** 2` | **64** | **512** |
| `10 + 10 ** 2 ** 3` | — | **100000010** (`**` right-assoc) |

Upstream asserts both sides **[U]** `functions-test.red`:
```red
	--test-- "math test"
		--assert 7 = math [1 + 2 * 3]           ;← NOT 9
		--assert 9 = math [(1 + 2) * 3]
		--assert 100000010 = math [10 + 10 ** 2 ** 3]
		--assert 33 = math [1 + 2 ** 3 * 4]
```
**Porting a line from `math` into normal code silently changes its
meaning.** `math` is a separate parser, not a wrapper.

### 3.8 Settling precedence with Red's own tracer **[V][U]**
There is a `trace` function and a `trace/all` refinement that print the
evaluation order. Upstream uses it as the ground truth **[U]**
`evaluation-test.red`:
```red
	--test-- "hltrace-18"
		trace/all [1 + 2 * 4]
		--assert trace-output = next {
  1 + 2                              => 3
  3 * 4                              => 12
}
```
`(1+2) = 3`, then `3*4 = 12`. **Left to right. `*` does not bind tighter.**

> ⚠️ **A caution about automated analysis.** During this research a code
> analysis pass read that same log and concluded *"`*` binds tighter than
> `+`, since `1 + 2 * 4 = 12`, not 9"*. That conclusion is wrong — 12 **is**
> the left-to-right answer. A subagent's summary is not evidence; the log
> is. Every contested claim here was re-measured on the interpreter
> before it went into this document. The same pass also claimed `all` does
> not short-circuit, which the direct measurement above contradicts.

### 3.9 The test harness, since we may as well use it **[S][U]**

Assertions are written as **comments**, parsed by a preprocessor, so tests
read as clean Red: **[U]**
```red
	--test-- "ex1"
		i: 0  loop 3 [i: i + 1 break i: i - 1]
		--assert i = 1
```
Harness words **[S]** `quick-test/quick-test.red`:

| Word | arity | spec |
|---|---|---|
| `~~~start-file~~~` | 1 | `title [string!]` |
| `===start-group===` | 1 | `title [string!]` |
| `--test--` | 1 | `title [string!]` |
| `--assert` | 1 | **`assertion [logic!]`** |
| `--assertf~=` | 3 | `x y e [float!]` (relative tolerance) |
| `===end-group===` | 0 | |
| `~~~end-file~~~` | 0 | |

**`--assert` requires a `logic!`**, so dynamic values are wrapped:
```red
	--assert to logic! all [error? try [set [a b] ()] a == 1 b == 2]
```
**[U]** `evaluation-test.red:1384`

Failure output is deliberately minimal — **only the test name**, never the
values **[S]**:
```
===group=== <group>
--test-- <name> FAILED**************
```
That is why the upstream suite is a goldmine of *what is true* and useless
for *why something failed*. Worth knowing before you trust a green run.

### 3.10 The upstream suite as a reference **[S]**
`red-view-src/tests/source/units/` — `lexer-test.red` is the authority on
literal forms, `evaluation-test.red` on evaluation order, `function-test.red`
on scoping and specs, `parse-test.red` on the PEG, `loop-test.red` on loop
return values, `regression-test-red.red` on everything that was ever broken.

Known-broken behaviours are marked with a ticket number in the test name
(`--test-- "#443"`, `"#2152"`, …). That file is a decade of scar tissue and
the most informative file in the tree.

---

## 4. Naming, from real code **[S]**

| Kind | Rule | Live examples |
|---|---|---|
| Value | single-word **noun** | `s` `q` `cnt` `step` `flags` `pane` `spec` `out` `ledger` |
| Function | single-word **verb** | `make` `reduce` `align-faces` `capture-events` `pre-load` `set-flag` |
| Multi-word | dash-separated, verb first | `align-faces` `get-focusable` `center-face` `show-parents` `find-argument` |
| Type test | trailing `?` | `face?` `overlap?` `within?` `keyval?` `strict?` |
| Never | snake_case, camelCase | — (0 instances in the Red-level tree) |
| Uppercase | only for OS / third-party API names | `CreateWindowEx` `hWnd` `msg` |

Two conventions worth copying:

* **Local scratch words are one letter** when the scope is three lines:
  `s` `p` `q` `v` `k`. `core.red`'s `/local mark found i n last-pair` is the
  same instinct at a larger scale.
* **Counter words are plain nouns**: `i` `index` `cnt` `rank` `idx`.

---

## 5. Series idioms

**Build a string** — three idioms, by size **[S]**
```red
	;-- one small string: rejoin
	rejoin [mark " " name " :: " witness]              ; src/core.red:11

	;-- accumulating across a loop: append into a block, write once
	ledger: copy []
	say: func [s [string!]][append ledger s  write %verdict.txt rejoin ledger]

	;-- with reduction: repend (append + reduce in one)
	repend output value
```

**Iterate and accumulate** — always `foreach`, never index arithmetic **[S]**
```red
		foreach raw lines [append out flay-line raw style width]     ; src/core.red:252
		foreach w spec-of w1 [if all [refinement? w w <> /local][append words w]]
```

**In-place transform** — `forall`, the Red answer to "map in place" **[U]**
```red
			forall b4967 [append out4967 index? b4967 b4967: next b4967 b4967/1: b4967/1 * 2]
			--assert b4967 == [1 4 3 8]
```
The test suite even documents that `break` inside `forall` is delicate **[U]**
`regression-test-red.red` `#4578`:
```red
			a1923: [1 2 3]
			forall a1923 [if a1923/1 = 2 [break] try [break] do [break]]
			repeat i 3 [break continue]
			foreach a a1923 [break]
			remove-each a a1923 [break]
			--assert true					;-- check if previous line didn't crash
```

**Sort with a comparator** — a function, never a word **[V]**
```red
	sort/compare words func [a b][(length? a) < (length? b)]
```
`sort/compare [1 2 3] <` → `ERR script / no-arg` **[V]**.

**Pre-size your output block** when you know the size **[S]**
```red
		words: make block! 4
		result: make block! 4
		lines: make string! 100
```
Red 0.6.6 added preallocation for `insert/append/dup` **[W]**, so this pays
off.

---

## 6. `copy` discipline

**The rule, as practiced: copy on the way in, never on the way out.**

* `copy` a series when it is about to be **modified** and is not freshly
  created. `src/core.red:225` `out: copy ""` then `append out …` — a string
  literal must be copied before appending. **[S]**
* Do **not** copy a series you only read.
* `copy/deep` is rare — 32 uses in the whole Red-level tree **[S]**. It is
  for when the *nested* content will be mutated.
* When a function returns a series it did not create, it usually returns a
  **position** (`head …`, `insert …`) rather than a copy. That is cheaper
  and the caller is expected to know the difference.

```red
	a: "hello"
	b: next a
	append a " world"
	mold b    ;-- {"ello world"}      ;-- append moved every window
```
**This is the trap `copy` cannot save you from** — see `RED.md` §7.2. A
`copy` taken *before* the append is the only defence:
`c: copy a  b: next c  append a "x"` leaves `b` alone.

---

## 7. Error handling idioms

**`try` gives you one value; branch on `error?`** **[V]**
```red
	r: try/all [risky thing]
	either error? r [report r/type r/id][use r]
```

**`attempt` when you only need a fallback** **[V]**
```red
	v: attempt [to integer! p]           ; src/core.red:140 — the house pattern
	unless any [v = none …][ok: false break]
```
`src/core.red` uses `attempt` in exactly one place, and it is the right
place: parsing a value that may be malformed, inside a hot loop.

**`error?` rather than `none?`** when the value could legitimately be
`none` — `none?` is `any [none = x]` and says nothing about `error!`. **[V]**

**`try/keep` when you need the stack** — otherwise the `stack` field is a
bare integer address. **[V]**

**Guarded `set`/`get` for optional words** — pervasive in the View engine
**[S]**
```red
			set/any 'value get/any word
			if all [not unset? :value  type = type? :val  (found-at-least-one?: yes)] [
```
and `set/any` as a way to assign a real `unset!` **[U]** `unset-1`.

**A pattern worth stealing** — validate first, bail with a purpose-built
error **[S]** `environment/codecs/CSV.red`:
```red
		if length <> length? line [return make error! non-aligned]
```

---

## 8. Comment style

The official guide says **[W]**: `;--` prefix, single-line comments start at
column 57, docstrings capitalised without a trailing period, `""` for
single-line strings and `{}` for multi-line, lowercase names.

**Verified against the tree [S]:** the guide is followed closely. The
deviation worth naming is the trailing period — 8 of 148 docstrings have
one, and all 8 are in `console/help.red`, i.e. one contributor's file. The
house rule is no period.

`src/core.red` uses a distinctive house voice for this project — lowercase
prose comments, no `;--`, written as if the code were being read aloud. That
is a project decision, not a Red one, and it is good.

---

## 9. Dialect structure

A Red dialect is a block passed to a function that walks it. The
dispatcher shape is consistent **[S]** — a `parse` rule plus a mutation
callback, or a `switch`.

**The cleanest small example** — `modules/view/VID.red:381-434`, a
`switch/default` on `type?/word` used as a type dispatch that **returns a
value**:
```red
			'else [
				opt?: switch/default type?/word value: pre-load value [
					point2D!  pair!  [unless opts/size  [opts/size:  value]]
					string!  [unless opts/text  [opts/text:  value]]
					percent! [either opts/image [scaling: value][unless opts/data [opts/data: value]]  yes]
					image!	  [unless opts/image [opts/image: value]]
					integer! [unless opts/size [either find [panel group-box] face/type [
						divides: value
					][
						opts/size: as-pair value face/size/y
						opts/size-x: value
					]]]
					block!	  [ …  yes]
				][no]
			]
```

**The parse-driven dialect** — `environment/codecs/CSV.red`:
```red
		collect/into [
			until [
				keep to-csv-line copy/part data size delimiter
				tail? data: skip data size
			]
		] make string! 1000
```
`collect/into` + `keep` + a `parse`-free manual walk. Note it allocates the
destination up front as the second argument — the idiomatic way to
pre-size.

**`parse` as a dialect engine, done right** **[S]**
`environment/console/engine.red:314`:
```red
		parse/case script [some [pos: "Red" opt "/System" any ws #"[" (found?: yes) break | skip]]
```
This is the shape `RED.md` §9 argues Imp should consider for `sever`:
`parse` matching, a `set-word!` capturing the position, a `logic!` flag for
success, `break` to stop.

---

## 10. Header blocks

Fields actually used across the tree **[S]**:

| Field | Example |
|---|---|
| `Title` | `Red [Title: "core"]` |
| `Author` | `Red [Title: "x" Author: "Name"]` |
| `Date` | `Red [Title: "x" Date: "2026-09-27"]` |
| `Purpose` | required by the `red/code` contribution guideline **[W]** |
| `Rights` | licence name or URL; **defaults to public domain** **[W]** |
| `File` | `Red [File: %main.red]` — used by `#include` resolution **[W]** |
| `Tabs` | `Tabs: 4` — **required in every file contributed to `red/red`** **[W]** |
| `Icon` | `Icon: %cherry.ico` — embedded app icon, used by CherryTracker **[W]** |
| `Needs` / `Config` | `Needs: 'View  Config: [GUI-engine: 'terminal]` **[W]** |
| `Comment` / `Version` | occasionally |

`src/core.red` uses only `Title`, and the rites use `Title` plus prose
comments. The `Purpose`/`Rights` pair is only mandatory upstream, not for a
private project. But `Tabs: 4` is a good habit and costs one line.

---

## 11. Anti-patterns the code itself avoids

**Shadowing `all` / `and`** — the compiler does not support redefining them,
so the code works around it with explicit defenses **[S]**
`modules/view/view.red:950`:
```red
	all?: :all											;-- compiler does not support redefining ALL
	svs: either system/words/all [only face/type = 'window][face/parent][get-current-screen]
```
and `environment/functions.red:29`:
```red
	attempt: func [
		"Tries to evaluate a block and returns result or NONE on error"
		code [block!]
		/safer "Capture all possible errors and exceptions"
		/local all result
	][
		set 'all safer										;-- `all:` refuses to compile
		try/:all [set/any 'result do code]
		:result
	]
```
Note `try/:all` — the dynamic refinement form (§3.3), used to pass `/all` to
`try` through a variable.

**Undeclared locals in `func`** — §2.3. Clobbers globals.

**A bare `for`** — does not exist. Reaching for it is the clearest sign you
are writing C in Red.

**`math` for ordinary arithmetic** — different precedence (§3.7). It is for
*ported* expressions, not for writing new ones.

**Relying on `all`/`any` to suppress side effects** — §3.6.

**Breaking a call across lines before its blocks** — the interpreter runs
the call argument-less. `style-guide.adoc` calls this out explicitly **[W]**
and `RED.md` §14.1 has it.

---

## 12. What I would change in `src/core.red`

Not asked for, and the core is sealed, so this is a note, not a plan.

1. **The `return` comment on lines 79-82 is false.** It claims a spin that
   does not happen. The rule is fine; the reason is not. (§0)
2. **`hold-rite` is dead code** (`global` does not exist). Either delete it
   or fix it — and `r/near` is now available to make it actually useful.
   (`RED.md` §6.7, §17.1)
3. **`sever` could be a `parse` dialect**, which would be shorter, faster
   and already tested by a decade of upstream tests. `RED.md` §9.
4. **Everything else is right.** The zero-`return` discipline, the
   `weigh-cell` explicit Unicode ranges, the `break`-plus-variable exits,
   the FALLEN pair-walking — that is careful, correct work, and it is
   correct for reasons the comments mostly get right.

---

## 13. Sources

| Source | Path / URL |
|---|---|
| Red-level source | `red-view-src/environment/`, `utils/`, `modules/`, `quick-test/`, `encapper/` |
| Upstream test suite | `red-view-src/tests/source/units/` |
| Test harness | `red-view-src/quick-test/quick-test.red` |
| Failing-test record | `red-view-src/tests/failing-tests.red` |
| Compiler tests | `red-view-src/tests/source/compiler/` |
| Style guide | `red/docs` → `en/style-guide.adoc` **[W]** |
| Glossary | `red/docs` → `en/glossary.adoc` **[W]** |
| Parse spec | `red/docs` → `en/parse.adoc` **[W]** |
| Red/System spec rev. 60 | `static.red-lang.org/red-system-specs.html` **[W]** |
| CherryTracker (real app Red) | `github.com/dockimbel/CherryTracker` |
| redCV (large library Red) | `github.com/ldci/redCV` |

Counts quoted are raw `grep -o` totals over the Red-level directories.
