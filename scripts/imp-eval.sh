#!/usr/bin/env bash
# imp-eval.sh — keep the evidence, so "does it match what we asked for?"
# is a question with an answer instead of a squint.
#
#   imp-eval.sh "a lighthouse in a storm" "a dragon coiled in a well"
#
# For each wish it archives, under eval/<n>-<slug>/:
#   wish.txt    what the mortal asked for
#   prompt.txt  what the MOUTH told the hand to paint
#   mockery.txt what the dragon said
#   source.png  the 256x256 the diffusion model actually painted
#   art.txt     the braille the forge made of it
#   frame.txt   the finished panel
#
# NOTE ON THE CEILING. This is a development tool, not the program. The
# program still writes nothing outside /dev/shm/imp — that is the whole
# of COVENANT.md §5 and it has not been traded away. What this does is
# COPY the tmpfs artefacts out afterwards, on request, so a human can
# look at what was produced. Nothing the imp does is changed by it.
set -uo pipefail
IMP="$HOME/imp"
SHM="/dev/shm/imp"
OUT="$IMP/eval"
mkdir -p "$OUT"

run_one() {
  local n="$1" wish="$2"
  local slug dir
  slug="$(printf '%s' "$wish" | tr -cs '[:alnum:]' '-' | cut -c1-28 | sed 's/-$//')"
  dir="$OUT/$(printf '%02d' "$n")-$slug"
  mkdir -p "$dir"
  printf '%s' "$wish" > "$dir/wish.txt"

  rm -f "$SHM"/{frame,frame.tmp,conjure.png,imp-art.txt,conjure.log,conjure-reply.json,conjure-prompt.txt,conjure-mock.txt}

  if ! "$IMP/scripts/imp" "$wish" > "$dir/frame.txt" 2> "$dir/stderr.txt"; then
    printf '  %-30s FAILED — see %s/stderr.txt\n' "$slug" "$dir"
    return 1
  fi

  # the artefacts, as files. scraping the log lost two prompts to a
  # clever sed; the rite writes them out properly now.
  [[ -s "$SHM/conjure-prompt.txt" ]] && cp -f "$SHM/conjure-prompt.txt" "$dir/prompt.txt"
  [[ -s "$SHM/conjure-mock.txt"   ]] && cp -f "$SHM/conjure-mock.txt"   "$dir/mockery.txt"
  [[ -s "$SHM/conjure.log"       ]] && cp -f "$SHM/conjure.log"        "$dir/conjure.log"
  [[ -s "$SHM/conjure.png"  ]] && cp -f "$SHM/conjure.png"  "$dir/source.png"
  [[ -s "$SHM/imp-art.txt" ]] && cp -f "$SHM/imp-art.txt" "$dir/art.txt"

  local cols
  cols="$(sed 's/\x1b\[[0-9;]*m//g' "$dir/frame.txt" | awk '{print length($0)}' | sort -rn | head -1)"
  printf '  %-30s ok   frame=%sB widest=%s cols\n' "$slug" "$(wc -c < "$dir/frame.txt")" "$cols"
}

n=1
for wish in "$@"; do
  run_one "$n" "$wish"
  n=$((n + 1))
done
printf '\nevidence in %s\n' "$OUT"
