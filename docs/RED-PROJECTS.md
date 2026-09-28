# RED — projects written in it

> A field guide to what has actually been built in Red, what it proves about
> the language, and what the gaps say about the ecosystem.
>
> Researched September 2026. Every project below was **opened and read**,
> not taken from a search result. One candidate was rejected for exactly
> that reason — see §3.5.

---

## 1. How this was researched, and the bar for inclusion

Every entry here was verified against its own primary source: the GitHub
repository, the product page, or the official Red blog. I did not include
anything I had only seen in a search snippet.

**That bar caught a real error.** "Dispak" surfaced in three separate
searches as a Red deployment tool. Its README says, verbatim: *"It is
written in pure shell, so it can be used on any Unix/Linux machine."* It is
not a Red project. It is in §3.5 only so nobody else re-adds it.

The corollary: **absence of evidence here is not evidence of absence.** The
Red community is small and much of its work is either commercial and
undocumented, or in private repositories. The Red team's own words **[W]**:

> *"Red can be used to write almost anything, but the sparse ecosystem and
> some missing pieces limit certain use cases. It's used a lot for in-house
> data processing, custom DSLs, simple GUI apps, and more."*
> — red-lang.org, *Red in the real world*, 27 May 2024

That sentence is the single most honest description of the ecosystem, and
it should shape your expectations: **the interesting Red projects are the
ones the Red team built themselves.**

---

## 2. The pattern, in one paragraph

Almost every serious Red project follows the same shape: a **GUI or
data-processing core in Red/View**, with **Red/System dropped underneath
for the hot path**, bound to **C libraries by FFI**, compiled to a **single
statically-linked binary**. Dialects carry the expressiveness; `parse` and
`load` carry the data. Nobody is building a general-purpose web framework,
and that is a deliberate trade, not a failure of ambition.

---

## 3. The three known projects

### 3.1 CherryTracker — Amiga module player, Red/View + Draw + SDL3

**Where:** `github.com/dockimbel/CherryTracker` · MIT · 16★ · 42 commits ·
published 2026 · written by Nenad Rakočević, the language's author

The most substantial *open* Red application, and the most recent.

**What it is.** A playback-only Amiga-style module player (MOD / XM / S3M /
IT, up to 64 channels, via libxmp), with a FlodPro-inspired gray-bevel UI
drawn entirely with Red's **Draw** dialect, and audio via **SDL3**.

**Why it matters here.** It is the cleanest public demonstration of the
full stack, and every layer is a lesson:

| Layer | File | What it shows |
|---|---|---|
| App | `player.red` | FFI bindings, `routine!` bridges, snapshot-FIFO sync, Draw renderer, View event loop |
| FFI | `xmp.reds` | Red/System binding using **offset-based** accessors into `xmp_frame_info` / `xmp_module` |
| Audio | `audio.reds` | slim SDL3 audio-stream output, manual feed, S16 / 2ch / 44100 |

Two details worth stealing:

* **Sample-accurate audio↔visual sync.** A snapshot FIFO keyed on
  *bytes-played* surfaces exactly the frame that is audible **right now**,
  so meters and the pattern grid never lead the sound even with audio
  buffered ahead. That is a real-time problem solved with the right data
  structure, not with sleeps or polling — and Red 0.6.6 has no `sleep`.
* **A real DSP, in Red.** The spectrum analyzer is 48 log-spaced
  **Goertzel** bands (55 Hz–12 kHz) over a Hann-windowed output PCM. Not
  a fake bar chart. Per-channel VU meters use fast-attack/slow-decay
  ballistics.

**Build.** Uses the 2026 static-linking feature **[W]**:

```
redc -r -s -t Windows   -o CherryTracker.exe player.red
./redc -r -s -t Linux-GTK -o CherryTracker  player.red
```

`-s` is static linking; `-r` is release. The shipped binary is fully
self-contained. Linux needs 32-bit deps; from WSL, `pulseaudio:i386`.

**Honest note.** The README says it was *"Made with ❤️ using Red and
Claude Code"*, and the release blog describes dozens of iterations with
coding agents. So this is also the reference case for **AI-assisted Red
development** — which, given Red's small community, may be the most
repeatable way to write serious Red in 2026.

---

### 3.2 SmartXML — commercial XML → database ETL

**Where:** `redata.dev/smartxml` · **commercial** · v1.0.1, 26 Mar 2025 ·
portable build 0.80 MB · Windows + Linux

The first genuinely commercial Red product the team publicly profiled **[W]**.

**What it is.** Schema-free XML → JSON / SQL / table. Targets
**PostgreSQL, SQLite, MongoDB, ArangoDB**, plus a built-in **TinyNLP**
engine, multiprocessing, and batch processing (10 files at a time). Licensed
four ways: free (PostgreSQL/SQLite only, no multiprocessing, no batch),
$20/mo, $150/yr, or $250 perpetual.

**Why the author chose Red** — their own words **[W]**:

> *"I chose Red because I was tired of the complexity of 90% of modern
> languages and the constant breaking changes in many of them. If you were
> to ask me what language I would choose to start a project with, looking
> back, I would still choose Red or perhaps try to use Hare… simply because
> I want to be sure that my solution will work in 10 or even 20 years."*
>
> *"Initially, I thought I could finish within half a year, but the project
> took me many years."*

**The five design goals**, verbatim **[W]**: make parsing visual and simple;
**abandon XSD** schemas; **rethink XPath**; generate SQL from XML; batch
process.

**Why it matters here.** This is the strongest evidence for the claim that
`parse` is a first-class feature and not a curiosity. The Red team's own
commentary on it **[W]**:

> *"This application is a great fit for Red, whose `parse` function makes
> processing data easy (as much as XML processing can be) and clearly
> defined. The latter aspect is important, and often ignored. Can you write
> code to get that job done, maybe with regexes in this case? Yes. But can
> you maintain and extend that code? This is where dialects add enormous
> value."*

**A commercial product abandoned XML schemas in favour of a dialect.** That
is the entire Red thesis in one decision — and it is the exact opposite of
the belief recorded in this repo's `AGENTS.md`, which excommunicated `parse`
on the grounds that it "returns logic". See `RED.md` §9.

Also worth quoting, the author's design maxims **[W]** — they are unusually
good advice for any long-lived project:

> *"Standard tools have standard problems. And people very often become
> hostages of such solutions. Most people prefer the shortest, not the most
> correct path."*
>
> *"If you can sacrifice 10% of functionality at the cost of removing 90%
> of code, you should do it."*

---

### 3.3 RED Wallet — hardware-key crypto wallet

**Where:** `github.com/red/wallet` · 36★ · 14 forks · 278 commits ·
Windows 7/8/10 + macOS 10.1x · 2018

**What it is.** A desktop client for **Ledger Nano S** and **TREZOR**
hardware keys. Secures BTC, ETH and **1200 ERC-20** transactions, with batch
processing for ETH/tokens. **A single binary under 1 MB**, no installation,
no setup, no config files, no registry entries.

**Why it matters here.** This is the flagship demonstration of the
**full-stack** claim — the reason Red exists at all. It is:

* a **GUI** in Red/View (`btc-ui.red`)
* **HTTP/JSON** to blockchain nodes, using Red's built-in `read`
* **USB drivers written in Red/System** — the `keys/` directory
* **compiled to a single self-contained executable** with `red -r -t Windows`

A language that ships its own GUI, its own network stack, its own FFI, and
its own compiler can ship a 1 MB crypto wallet with no runtime. That is the
"full stack" claim, cashed.

**Two practical notes from its README.** It documents *both* build paths —
using a prebuilt Red binary (`red -r -t Windows wallet.red`) and building
the compiler from source via REBOL/View 2.7.8 + `red.r` — and it recommends
the `--no-compress` option so UPX does the compression instead of Redbin's.

---

## 4. The five niche projects

### 4.1 redCV — computer vision in Red

**Where:** `github.com/ldci/redCV` (mirrored to `red/redCV`) · 1★ · 161
commits · active since 2016 · **updated 20 Mar 2025 for Red 0.6.6**

The largest pure-Red library in existence: **600+ routines and functions**
for image processing, with 200+ documented code samples.

**Scope**, from its own changelog: conversions, logical and math operators
on `image!`; histograms and histogram equalisation; convolution (integer and
fast, per-channel and greyscale); **morphological operators**; edge
detection (including a fast operator set); Gaussian blur, Gaussian pyramid
decomposition, pyramidal rescaling; colour-space conversion and
`rcvInRange` sub-array extraction; contour area; **convex hull**;
**K-means**; **Voronoi**; **Dynamic Time Warping**; **Haar cascade** object
detection (with XML cascade loading) and **HOG**; a `matrix!`-style object
built with Toomas Vooglaid and Qingtian Xie; TIFF I/O (1–4 channel, 8-bit
uncompressed, 24-bit colour out); ZLib compression; PBM portable bitmaps;
**FLIR thermal** and **Optris infrared** camera support; motion detection
and tracking from a webcam; Fourier analysis; a Draw-DSL sample set.

It also **talks to the Pandore C++ library**, and there is a companion
`ldci/ffmpeg` binding for video.

**Two decisions that generalise:**

1. **Hot paths in Red/System `routine!`.** The author moved most functions
   to routines "for a faster image processing" — the same shape as
   CherryTracker's `xmp.reds`. *"Writing complex code is always easier
   than writing simple code"* cuts both ways.
2. **Modularity over monolith.** redCV is explicitly modular: include only
   the libraries you need. This *"reduces compilation duration, reduces the
   size of the executable applications, and helps in maintaining redCV."*
   Modules are not in the language yet, so the pattern is `#include` of
   plain scripts.

**Why it matters here.** redCV is the proof that Red is not a toy. It is
also the clearest demonstration of the **maturity tax**: its changelog is a
long list of "modified for Red 0.6.4", "adapted to 0.6.5", "100% compatible
with the new version of Red 0.6.6" — one maintainer keeping a large library
pinned to a moving 0.x language across nine years.

---

### 4.2 DiaGrammarr — "the world's first live-coded diagramming" tool

**Where:** Redlake Technologies (the Red team's commercial entity) ·
released **December 2020** for Windows · created by **Toomas Vooglaid**

**What it is.** A diagramming tool where the diagram **is** the program —
you edit a live Red representation and the picture updates. Wikipedia
describes it as *"Live coded diagramming"* **[W]**; the Red team's own
Facebook announcement calls it *"the world's first live-coded"* diagramming
product **[W]**.

**Why it matters here.** Three reasons, and the third is the best:

1. **It is the origin of a real subsystem in Red.** The team wrote
   **[W]**: *"the work on DiaGrammar led to a huge amount of work on a more
   general diagramming subsystem for Red."* Toomas Vooglaid separately
   worked on Red's `diagram` dialect, and Gregg Irwin used DiaGrammarr to
   prototype a dialected interface for `split`. A commercial product
   demonstrably pushed the language forward.
2. **It is the stress test for Draw + View.** *"DiaGrammar is written in
   Red and uses the **draw** dialect heavily"* **[W]** — and it is
   specifically cited as the reason the team could see that the Windows
   **D2D** migration *"is not exactly the same"* as GDI+, because
   *"sometimes users have to make adjustments."* DiaGrammarr is the canary
   for graphics regressions.
3. **It reached outside the community.** Pontus Granström presented
   *"Diagrammar: Simply Make Interactive Diagrams"* at **Strange Loop
   2022** **[W]**, in an **Elm** talk — the Elm community's canonical
   conference. A Red-written tool was presented to a functional-programming
   audience as a case study in interactive diagramming.

**Status.** Redlake's second product, **RAPIDE** (Rapid API Development
Environment), was announced to start in **Q2 2022** **[W]** — a Postman /
Insomnia competitor built on "Red's superpowers and how important
data-centric thinking is." I found **no confirmation it shipped.** Treat it
as announced, not delivered.

---

### 4.3 Red.js — a Red interpreter in the browser

**Where:** `github.com/ALANVF/Red.js` · **51★** (the most-starred Red
project outside the core org) · 229 commits · Haxe · updated Jan 2026

**What it is.** A web runtime for Red: `haxe build.hxml` then
`node bin/main.js` gives a Red REPL. Aspiration is a browser runtime with
web equivalents for View, Draw, Rich-Text and VID, and a Red/System that
compiles to WebAssembly.

**The most interesting part is the FAQ, because the answer is *why not*.**
Asked why he did not transpile Red to JS, ALANVF replies **[W]**:

> *"This is sadly not possible due to the fundamental differences between
> Red and JS. In order to support all of the meta-programming features that
> Red has, it'd be no different transpiling to JS than just embedding the
> interpreter."*

That is the single best one-paragraph defence of a homoiconic language I
have read. Metaprogramming, dialects, `do`/`load`/`mold` round-tripping —
none of it survives a transpile to a language with different object model
and lexical rules. The repo also carries a `parse-tests/` directory, which
is a quietly interesting sign that **reimplementing `parse` is the hard
part** of porting a Red runtime.

**Honest limitations**, in the author's own words **[W]**: *"currently very
incomplete"*; OS interaction doesn't exist in a browser; *"probably many
times slower"* than the native build; and *"I'm currently only 1 person,
so progress is gonna be kind of slow as long as it's just me."*

---

### 4.4 The Red toolchain — the largest Red project there is

**Where:** `github.com/red` · 33 repositories · `red/red` at **~6k★** ·
415 forks · Boost Software License

This is the one nobody lists, and it dwarfs everything else. **Red's own
compiler and interpreter are written in Red** — which is the entire point
of the "full stack" claim.

**What is written in Red, right now:**

| Component | Language | Source |
|---|---|---|
| `runtime/*.reds` — lexer, parse, natives, datatypes, collector | **Red/System** | in our vendored tree |
| `encapper/compiler.r` — the Red language compiler | **Red** (Rebol-syntax) | 129 KB in our tree |
| `system/compiler.r` — the Red/System compiler | **Red** (Rebol-syntax) | the bootstrapped front end |
| `system/linker.r`, `linker-static.r` | **Red** | our own COFF/ELF/Mach-O static linker |
| `modules/view/*` — the GUI engine | **Red** + Red/System | GTK3 / Windows / Syllable / QML |
| `environment/*.red` — the language spec | **Red** | 107 natives, 59 actions |
| The GUI console itself | **Red** | this is the `red-view` we run |

And the pipeline the RED Wallet README documents **[W]**:
`REBOL/View 2.7.8` → runs `red.r` → compiles `encapper/` → emits
`system/*.reds` → assembles `red-view`. The language eats its own tail.

**Why it matters here.** Two reasons.

*It is the definitive answer to "what is Red for".* If you can write a
cross-compiling linker, a garbage collector, and a GTK GUI toolkit in a
language, the language is real. `[S]` In our own `red-view-src/` you can
read the entire runtime in `runtime/` and the entire language definition in
`environment/`.

*It is why 32-bit is such a big deal.* The compiler emits x86 assembly via
Red/System, uses **x87** for float support on IA-32, and is being migrated
to **SSE**. The team declined LLVM after studying Zig's experience with
LLVM churn **[W]**. That is a strategic choice with a real price tag: no
64-bit, no ARM64, and a self-inflicted 32-bit tax on every Red user — which
is exactly why the `imp` interpreter we run is a 32-bit ELF.

**The curated code repos**, also worth knowing: `red/code` (184★) —
*Apps*, *Scripts*, *Showcase*, *Library*, with a contributor guideline
requiring a proper Red header (`Title, Author, Date, Purpose, Rights`); and
`red/community` (64★) for general user scripts.

---

### 4.5 The Text-UI View backend — a terminal GUI in Red

**Where:** Red 0.6.x+ `modules/view`, `GUI-engine: 'terminal` ·
contributed by **qtxie**, merged June 2024

Directly relevant to this repository, which wants a terminal art tool.

A complete **TUI backend for the View engine** — Red/View widgets rendered
into a terminal, not a window. Supported: View/VID styles (base, panel,
button, check, radio, field, text, progress, rich-text, image, text-list);
Draw commands (text, line, box, triangle, circle, ellipse — block-based for
now); rich-text in Draw; key-down/key events; Truecolor images with 256-colour
fallback; timers via `/rate`; frames with squared or rounded corners; file
and folder requesters; 256-colour text.

```red
Needs:  'View
Config: [GUI-engine: 'terminal]
```

Mouse support is present but opt-in via
`system/view/platform/mouse-event?: yes`. Menus are **not** implemented.
`view` still launches a full event loop; **Escape** returns to the console.

**The limitation that matters for us:** ANSI escape support in the `/text`
facet is **partial — colours and graphics mode only**. No cursor movement
beyond what that implies, no full-screen addressing.

**Why it matters here.** This is the answer to a question Imp keeps asking:
*should the TUI be Red, or should the bridge be the TUI?* A TUI backend
exists, in the language, and it is exactly as capable as our art output
needs. The catch is that our `red-view` binary is a **GUI console** — the
terminal engine is a *compilation* option, so switching means building Red
from the vendored source in `red-view-src/`, not flipping a runtime flag.

---

## 5. What the projects collectively teach about Red

### 5.1 The layering is consistent, and it is the real lesson

Across CherryTracker, redCV, RED Wallet and redCV, the same architecture
appears every time:

```
        Red  /  Red/View          ← UI, dialects, data modelling
                ↓
     Red/System `routine!`        ← hot paths, bit-twiddling, FFI glue
                ↓
        C libraries (FFI)         ← libxmp, SDL3, Pandore, zlib
```

That is not a coincidence; it is the answer to *"when do I drop to
Red/System?"* — when the profiler tells you to. Nobody drops to C; C is
only ever behind an FFI boundary.

### 5.2 Dialects are the point, and `parse` is the reason

SmartXML abandoned XSD for a dialect. The `split` redesign was a
dialected interface. The `diagram` dialect is a product. DiaGrammarr *is* a
dialect. **Every** data-heavy Red project is a parser plus a dialect, and
`parse` is the parser.

Which makes this repo's `AGENTS.md` position — *"the PEG `parse` is
excommunicated in this build"* — the single most expensive belief in the
codebase. See `RED.md` §9.

### 5.3 Single-file, statically-linked binaries are a genuine advantage

RED Wallet: <1 MB, no installer. SmartXML: 0.80 MB portable. CherryTracker:
fully self-contained, no DLLs. The 2026 static-linking work **[W]** makes
this routine: name a `.lib`/`.a` in `#import`, add `-s`, ship one file. For
a tool like Imp — which is a launcher plus a small binary — that is a real
deployment property, not a party trick.

### 5.4 The cost of 0.x is the tax everyone pays

redCV's changelog is a decade of "modified for 0.6.4", "adapted to 0.6.5",
"100% compatible with 0.6.6". The team closed ~120 tickets in 2021 and
~50 PRs — steady, not fast **[W]**. Nobody depends on Red the way they
depend on Python, *yet* — but the SmartXML author chose it specifically
expecting the code to outlive the ecosystem, and that bet is the whole
argument in one sentence.

### 5.5 What nobody is building

No general web framework (RAPIDE was announced; no evidence it shipped). No
game. No scientific-computing ecosystem beyond redCV. No mobile app — the
Android backend is roadmap item **1.2**, after 64-bit. No mainstream
library ecosystem at all. For sizing expectations: the entire curated
`red/code` repository is 184★.

---

## 6. Where to look next

| Resource | What it is |
|---|---|
| `github.com/red/code` | Curated Apps / Scripts / Showcase / Library, 184★ |
| `github.com/red/community` | General user scripts, 64★ |
| `github.com/ldci/redCV` + `ldci/ffmpeg` | Computer vision, 600+ routines |
| `github.com/dockimbel/CherryTracker` | The best full-stack open example |
| `redata.dev/smartxml` | Commercial ETL, plus the author's design essays |
| `red-by-example.org` | Task-oriented examples (incl. a `parse` page) |
| `github.com/red/docs` (`en/*.adoc`) | The official specification |
| `red-lang.org/p/roadmap_2.html` | Where Red is going |
| `gitlab.com/hiiamboris/red-spaces` | The cross-platform GUI project |
| `gitlab.com/hiiamboris/red-mezz-warehouse` | In-flight design work: composite, tracing, HOFs |
| `ask.lang.red` | "Red Sensei" — an LLM assistant for Red |
| `github.com/red/REP` | Red Enhancement Proposals, 158 open issues |
| r/redlang | the subreddit |
| gitter.im/red/red | the chat |

**A note on `ask.lang.red`** — with Imp written in an 0.x language by one
author in one repository, and coding agents having just produced
CherryTracker, an LLM assistant trained on the Red corpus is worth knowing
about even if you are wary of them. Treat its output the way you should
treat any AI's: as a fast first draft that must be checked against
`RED.md` and a rite.

---

## 7. One closing observation

Read the list again with fresh eyes, and something stands out: **almost
everything here was made by people who own the language.** CherryTracker is
by the language's author. redCV, redCV, and the compiler and linker and GUI
and console are by the core team and its two maintainers. SmartXML is the
one genuinely independent commercial product, and its author publicly
credits the community's honesty about Red's limits as part of why he chose
it.

That is not a criticism — a 15-year-old language with a 6k-star repository
and a professional toolchain has produced exactly what that shape implies:
**a small number of very serious things, built by the people who could
afford to build them.** Red's bet is that its users, not its maintainers,
make it common. As of this writing that bet is unresolved, and the 0.7
async-I/O milestone is the hinge.

For Imp — 300 lines of Red, one 32-bit console, and a Python bridge — the
relevant lesson is not ambition. It is §5.1: **write the data modelling and
the dialect in Red; keep the hot path small; let the binary be boring.**
