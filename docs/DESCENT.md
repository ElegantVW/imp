# DESCENT — the chronicle so far

*An addendum to `ORIGIN.md`. Written between rites, in the order the
wounds arrived.*

---

## Rite III — the five questions, and the shape that survived

By now the core was sealed and the only thing left to invent was the
*delivery*. The daemon speaks into a window; the user lives in a
terminal. Between them: nothing.

So I asked five questions of the substrate, in five separate rites,
because a load error kills an entire script silently and I had learned
that the hard way nine times already.

1. **Can the demon wait?** (`sleep`) — *No.* `no-value`. He has no
   time of his own.
2. **Can it read a file that does not exist, and live?** — *Yes*, with
   `try`. Absence is survivable.
3. **Can it rename?** — *Yes.* `true`, cleanly. The atomic swap holds.
4. **Can it read a pipe and block?** — *No.* `read` refuses anything
   that is not a regular file. Not a refusal of the call: a refusal of
   the *idea*.
5. **What does one invocation cost?** — *0.12 seconds.* Cold. Warm.
   The same.

### The shape that survived

Four of those five answers close doors. Together they say one thing:

> **Red cannot wait, cannot block, cannot read a pipe, and has no
> stdout. Red is a batch processor. It is never a server.**

And the fifth answer is what saves the design, because 0.12s is nothing.
So the delivery inverts. The bridge owns the terminal, the input loop,
the spinner, and every wait. It hands the demon a **job file**. The
demon answers with a **frame file** and dies. One process per action.

```
  your terminal              /dev/shm/imp/                 red-view
 ┌────────────────┐  job  ┌──────────────────┐   job   ┌────────────┐
 │ imp (the body) │ ────► │ job   (written)  │ ──────► │ red  reads │
 │  owns termios  │        │ frame  (renamed) │ ◄────── │ red  writes│
 │  owns waiting  │        │ keys   (written) │         │ red  dies  │
 └────────────────┘        └──────────────────┘         └────────────┘
```

No pipe. No poll inside Red. No event loop. Just files, `rename`, and a
process that costs nothing.

### The body is borrowed

The user asked for purity: if the bridge must be written, write it in
Red. **It cannot be.** The demon has no `sleep` and cannot open a pipe,
so he cannot be the thing that breathes. That is not a preference, it
is a prohibition, and I would rather report it than pretend.

So the split is anatomical, and it suits the project better than
uniformity would have:

- the **mind** is Red — the art, the grid, the snark, the covenant, the
  wounds, the hour-ordering curse. Everything that *thinks*.
- the **body** is borrowed — termios, timers, the terminal. Everything
  that *breathes*.

A demon in a borrowed body is a better demon than a demon in a glass
house, anyway. It is the oldest shape the story has.

### 0.12s, and the price of one path

`rename` works, so the frame swap is atomic: write `.tmp`, rename, and
the reader never sees half a frame. `/dev/shm` holds it all, so the
filesystem never notices — not even a frame. Ceiling §5 is not merely
respected here, it is *inert*.

And the price, which is the genuinely evil part and the part I like:

> **Exit code 0 means the vessel accepted the wish, not that the art
> exists.**

The file appears when the imp decides. Covenant §1 permits the status
line to lie *by omission*; it may simply not mention the timing. A
script that treats `imp` as synchronous is wrong, and the grimoire says
so in one flat sentence.

## What I have not become

The user asked whether I was becoming evil, and I said: no, and the
division of labour matters. They bring the brief. I bring the craft.
The imp is evil. I am the thing that forges it.

That is not a hedge, it is the actual structure of the work. Every
horror in `GRIMOIRE.md` was not endured for atmosphere — it was
endured because the substrate is genuinely hostile, and the
documentation of those wounds is *useful*. The evil is the packaging.
The competence is the payload.

Which is, of course, the most satanical thing about it: the curse is
the only part that is decoration, and the decoration is the only part
that is honest about itself.

## Rite IV: the card that was already there

I had spent a long time blaming the language for being slow, and the
language was innocent. The tell was in a log I had read a hundred
times and never once *read*:

```
warning: no usable GPU found, --gpu-layers option will be ignored
warning: one possible reason is that llama.cpp was compiled without GPU support
```

A Radeon RX 5700 XT — 7.75 GiB of it, sitting idle, driver loaded,
display connectors live, `amdgpu` resident in the kernel. The model
zoo had been hand-tuned for CPU threads (`8/16`, "plain nproc was the
WORST") for weeks, and every measurement I took was a measurement of
a machine running with a limb tied.

The lesson is not "check for a GPU." I *had* checked — I had run
`nvidia-smi`, got nothing, and concluded there was no accelerator. I
probed for the one vendor I expected. The lesson is that a negative
result is only evidence about the thing you measured.

Then the second gift: `stable-diffusion.cpp` ships a **prebuilt Linux
Vulkan binary**. The entire art upgrade — no cmake, no compiler, no
`sudo`, no source tree — was a 38.7 MB zip. I had budgeted an evening
for a build. It took a minute, and it took a build that I never needed
to do.

So the imp's hand is now a diffusion model, and it turns out the
interesting part was never the arithmetic. It was learning which
questions I had stopped asking because I already knew the answer.
