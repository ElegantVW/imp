#!/usr/bin/env bash
# build.sh — the vessel speaks; the imp answers.
#
#   ./build.sh            verify substrate + the sealed core
#   ./build.sh smoke      conjure something and say whether it spoke
#   ./build.sh install    install the launcher into ~/bin/imp
#   ./build.sh clean      remove stray testimony files
#
# There is nothing to COMPILE. That is the point of v0.2.0: the C bridge
# is gone, so `build.sh` no longer needs a C compiler, and `install` is a
# copy rather than a build. Red has no console-only build on Linux and
# redc needs the proprietary enpro SDK, but neither matters any more —
# the launcher is bash and the program is Red.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
IMP="$HOME/imp"
RED="$IMP/red-view"
SHM="/dev/shm/imp"

die() { printf 'imp: %s\n' "$1" >&2; return 1; }

# ── substrate ───────────────────────────────────────────────────────────
need() { [[ -x "$1" ]] || die "MISSING $2"; }

substrate() {
  echo "imp: substrate"
  need "$RED" "red-view (fetch https://static.red-lang.org/dl/linux/red-view)"
  # The old check here was `[[ -f /lib/ld-linux.so.2 ]]`, which is a
  # dangling symlink on Arch (/lib -> usr/lib) and therefore reported a
  # missing loader for an interpreter that demonstrably runs. It also
  # asserted something about the filesystem rather than about the
  # program. Ask the program instead: can the loader actually resolve it?
  if ldd "$RED" >/dev/null 2>&1; then
    printf 'imp:   red-view present and its 32-bit libraries resolve\n'
  else
    die "red-view cannot be linked — need lib32-glibc"
  fi

  local sd="$HOME/.local/lib/sd/sd-cli"
  local sdlib="$HOME/.local/lib/sd"
  local model="$HOME/.local/share/pixie/models/sd_turbo-f16.gguf"
  if [[ -x "$sd" && -f "$model" ]]; then
    printf 'imp:   hand present (sd-cli + SD-Turbo)\n'
  else
    printf 'imp:   NO HAND. the imp will refuse and say so.\n' >&2
  fi
}

# ── the core ────────────────────────────────────────────────────────────
# Nothing is compiled, so this is presence plus the sealed rite. A file
# existing is not a file working; the only proof either is a testimony.
core() {
  echo "imp: core"
  local f
  for f in core.red frame.red forge.red conjure.red; do
    [[ -f "$ROOT/src/$f" ]] || die "src/$f missing"
    printf 'imp:   src/%s\n' "$f"
  done

  echo "imp: seals (byte-exact against tests/vectors)"
  "$ROOT/rited" "$ROOT/tests/rites/rite-two.red" verdict.txt >/dev/null \
    || die "rite-two gave no testimony"
  if grep -q 'BROKEN' "$ROOT/verdict.txt"; then
    die "a seal is BROKEN: $(tr '\n' ' ' < "$ROOT/verdict.txt")"
  fi
  printf 'imp:   %s SEALED\n' \
    "$(grep -o 'SEALED' "$ROOT/verdict.txt" | wc -l | tr -d ' ')"
}

# ── the forge ───────────────────────────────────────────────────────────
# NOT sealed, and this says so. reap is sealed against the Python
# original; the forge has no oracle of its own. What it does have is a
# structural witness, and — this is the real argument — the sealed
# `reap` sits downstream of it, so the GRID CONTRACT is sealed by
# composition even though the glyph CHOICE is not. That is a weaker
# claim than rite-two makes and it is written down as such rather than
# dressed up. docs/GRIMOIRE.md, "the forge is not sealed".
forge() {
  echo "imp: forge (structural witness only — NOT an oracle seal)"
  # The rite forges from whatever the last conjuring painted. If there
  # has not been one, there is nothing to forge and saying so beats
  # forging a synthetic image and calling it evidence.
  if [[ ! -s "$SHM/conjure.png" ]]; then
    printf 'imp:   nothing has been conjured yet. run: ./build.sh smoke\n' >&2
    return 0
  fi
  # the rite knows one fixture name; the launcher knows another.
  cp -f "$SHM/conjure.png" "$SHM/probe-src.png"
  "$ROOT/rited" "$ROOT/tests/rites/rite-forge-one.red" \
    "$SHM/forge-witness.txt" >/dev/null || die "rite-forge-one gave no testimony"
  tr '\n' ' ' < "$SHM/forge-witness.txt"
  printf '\n'
}

# ── the frame's width contract ───────────────────────────────────────────
# A seal in the sense rite-two uses the word, with one honest difference:
# there is no oracle. And there could not usefully be one — the Python
# original's frame has the SAME defect (its pad-to only ever pads), so an
# oracle would have blessed the 61-column border as correct. The property
# asserted here is the one the frame CLAIMS, fed the input that broke it.
frame() {
  echo "imp: frame (width contract, hostile input — no oracle, see above)"
  "$ROOT/rited" "$ROOT/tests/rites/rite-frame.red" \
    "$SHM/frame-witness.txt" >/dev/null || die "rite-frame gave no testimony"
  if grep -q 'BROKEN' "$SHM/frame-witness.txt"; then
    die "the frame is BROKEN: $(tr '\n' ' ' < "$SHM/frame-witness.txt")"
  fi
  tr '\n' ' ' < "$SHM/frame-witness.txt"
  printf '\n'
}

# ── the forge's threshold ──────────────────────────────────────────────
# A seal in the same sense as `frame`, with the same honesty about it:
# there is no oracle for a threshold, because there is nothing to compare
# a threshold to. What there IS is a set of synthetic pictures with known
# answers, which is how you test anything numeric. A5 is the one that
# matters most — it fails against a real bug that was live for a session
# (a threshold computed from the top seven rows of a 512x512 image).
otsu() {
  echo "imp: threshold (Otsu — synthetic answers, no oracle, see above)"
  [[ -s "$SHM/conjure.png" ]] && cp -f "$SHM/conjure.png" "$SHM/probe-src.png"
  # RITED_WAIT: this rite forges a 512x512 braille, which is ~30k `pick`
  # calls through a 32-bit interpreter. Measured at 1s of Red time, but
  # the 90s default is not a promise it should have to keep.
  RITED_WAIT="${RITED_WAIT:-200}" \
    "$ROOT/rited" "$ROOT/tests/rites/rite-otsu.red" \
    "$SHM/otsu-witness.txt" >/dev/null || die "rite-otsu gave no testimony"
  if grep -q 'BROKEN' "$SHM/otsu-witness.txt"; then
    die "the threshold is BROKEN: $(tr '\n' ' ' < "$SHM/otsu-witness.txt")"
  fi
  tr '\n' ' ' < "$SHM/otsu-witness.txt"
  printf '\n'
}

# ── smoke: one real conjuring, end to end ───────────────────────────────
smoke() {
  echo "imp: smoke"
  substrate
  local out
  out="$(mktemp)"
  if "$HOME/bin/imp" "a lighthouse in a storm" > "$out" 2>"$out.err"; then
    printf 'imp:   the demon spoke — %s bytes\n' "$(wc -c < "$out" | tr -d ' ')"
    sed -n '2,4p' "$out" | cut -c1-72
  else
    printf 'imp:   the vessel accepted the wish and painted nothing.\n' >&2
    sed 's/^/    /' "$out.err" >&2
    rm -f "$out" "$out.err"
    return 1
  fi
  rm -f "$out" "$out.err"
}

# ── rites ───────────────────────────────────────────────────────────────
rites() {
  echo "imp: rites"
  local t
  # rate-compare.red needs a picture to compare forge settings on. stage
  # the last conjuring's, and say so if there is none rather than letting
  # the rite print LOAD-ERROR and be mistaken for a broken forge.
  if [[ -s "$SHM/conjure.png" ]]; then
    cp -f "$SHM/conjure.png" "$SHM/probe-src.png"
  else
    printf 'imp:   (no conjure.png — rate-compare.red will decline)\n' >&2
  fi
  for t in "$ROOT"/tests/rites/*.red; do
    [[ -e "$t" ]] || continue
    [[ "$(basename "$t")" == _* ]] && continue
    [[ "$(basename "$t")" == probe-* ]] && continue
    "$ROOT/rited" "$t" "$(basename "${t%.red}").txt" >/dev/null || true
    printf 'imp:   %-22s %s\n' "$(basename "$t")" \
      "$(tr '\n' ' ' < "$ROOT/$(basename "${t%.red}").txt" 2>/dev/null | cut -c1-58)"
  done
}

# ── install ─────────────────────────────────────────────────────────────
# A copy, not a build. There is no C in this project any more.
install_imp() {
  mkdir -p "$HOME/bin"
  install -m 0755 "$ROOT/scripts/imp" "$HOME/bin/imp"
  printf 'imp: launcher → %s\n' "$HOME/bin/imp"
  printf 'imp: program  → %s (pure Red)\n' "$ROOT/src/conjure.red"
}

# ── main ────────────────────────────────────────────────────────────────
case "${1:-all}" in
  all)      substrate; core; forge; frame; otsu ;;
  smoke)    smoke ;;
  rites)    rites ;;
  otsu)     otsu ;;
  install)  install_imp ;;
  clean)    find "$IMP" -maxdepth 2 -name '*.txt' -newermt '-1 day' \
              -not -name 'LICENSE' -delete 2>/dev/null || true
            printf 'imp: recent testimony swept\n' ;;
  *)        sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//' ; exit 1 ;;
esac
