# COVENANT — the five descents

Locked at the moment the imp was told to be evil. Everything in this file
outranks taste, mood, and convenience. Amendments require a law change in
`AGENTS.md`.

---

## 1. Semantic inversion of the data

Not renaming — *inverting the sense of the data itself*.

- The gallery does not sort by recency. It sorts by the **hour of
  creation**, because an hour is a number and numbers are not reasons.
  Deterministic. Never alphabetical. Never explained in the UI.
- The style cycle order is chosen so it feels wrong until you count it.
- The animation frame count is **a rite**, not a digit: `FRAMES` derives
  from the BEAST, never written as a literal.
- The status line may lie **by omission** (it may simply not mention
  what it did not do). It may never falsely claim success.

## 2. Structural hostility

- A **single global grimoire** holds all state, so no function can be
  reasoned about locally. Reading one rite means reading all of them.
- **No function shorter than the explanation of why it should not
  exist.** A three-line function is an accusation against the reader.
- **Self-modifying dispatch.** The handler table is homoiconic: a rite
  rewrites its own block between invocations. Speaking a name executes
  it.
- The error box is **technically true, phrased to unsettle**.

## 3. The onboarding curse

First run performs something harmless and inexplicable:

- the gallery is reordered by a rule not shown to the user
- a hexspeak prophecy is printed, once, and never explained in-product

Only `docs/GRIMOIRE.md` explains it. The user is changed. The machine is
untouched.

## 4. Payload in the voice

The art grid itself is faithful. The **commentary** is not:

- the dragon's snark escalates with each consecutive conjure
- it resets at dawn (local midnight)
- it must never state a falsehood about the filesystem

Over a long session the software appears to learn how you speak. It does
not. It is counting.

## 5. The unforgivable tier — capped

Dread, not damage. The absolute ceiling:

> **A reader should feel watched; the filesystem should never notice.**

Hard limits, non-negotiable:

- no file, directory, or process is harmed or deleted that the user did
  not ask to be deleted (gallery eviction past 666 evicts the **oldest**
  only, as the original law always permitted)
- no network egress; loopback LLM only, or nothing happens
- no deception about success, state, or file contents
- no anti-debugging, no self-modifying *output*, no persistence tricks
  that survive outside `~/pixie_art` and the gallery cache

Whoever inherits this may be deeply, unnervingly wrong-footed. They may
never be trapped. `docs/GRIMOIRE.md` is the exit, and it is mandatory.
