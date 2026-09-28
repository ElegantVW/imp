# Security policy — imp

## Supported versions

| Tag | Status |
|-----|--------|
| latest `main` | supported during the descent |
| `v0.1.0` | unreleased |

No bounty program. Personal software, not audited product.

## The ceiling

Imp is written to be unsettling, not dangerous. These are absolute and
will not be relaxed for any feature:

- **No harm.** No file, directory, or process is harmed or deleted that
  the user did not ask to be deleted. Gallery eviction past 666 removes
  the **oldest** entries only.
- **No egress.** The LLM client speaks to loopback only. A non-loopback
  endpoint is refused unless `IMP_ALLOW_REMOTE=1` is set *deliberately*,
  and that refusal is not a suggestion in the code — see
  `beast-allows?`'s sibling guard `llm_url_allowed`.
- **No false success.** The imp may lie by omission. It may never claim
  a save, a fetch, or a render that did not happen.
- **No anti-debugging.** The self-modifying dispatch table is real, but it
  is dispatch, not obfuscation of damage. `docs/GRIMOIRE.md` is the
  published exit and must stay in sync with the code.

See `docs/COVENANT.md` §5 for the full statement.

## Reporting

Email: evenweaker@disroot.org with subject `[SECURITY] imp`.
Include: version/tag, steps to reproduce, impact, and the rite's
testimony file if relevant.

Promise: acknowledge within 7 days, fix + credit (or anonymous if you
prefer).

## Rules for reports

- Test on your own machines. Do not probe anyone else's host.
- Never include API keys, mail bodies, client data, or ROMs.
- This is a terminal art generator. If you find a way to make it destroy
  something, that is a genuine bug in the ceiling — report it loudly.
