#!/usr/bin/env bash
# probe-fifo.sh — does the demon block on a named pipe?
#
# red-view has no `sleep`. a bridge that polls without sleeping is a
# hung serpent wearing a hairpiece. so the whole delivery design rests
# on this: can Red open a FIFO and block on a read?
set -uo pipefail
IMP="$HOME/imp"
PIPE="/dev/shm/imp/keys"
LINK="$IMP/keys-probe.fifo"

mkdir -p /dev/shm/imp
rm -f "$PIPE" "$LINK"
mkfifo "$PIPE"
ln -sf "$PIPE" "$LINK"
rm -f "$IMP/probe-open.txt"

echo "⟡ probe: a writer will feed the pipe in 6s …" >&2
( sleep 6; printf 'ping\n' > "$PIPE" ) &

# rited stages the rite in the root and casts it
timeout 80 "$IMP/rited" "$IMP/tests/rites/probe-open.red" probe-open.txt
rc=$?
echo "---"
if [[ -s "$IMP/probe-open.txt" ]]; then
  cat "$IMP/probe-open.txt"
else
  echo "(no testimony — the demon hung on the pipe, or the port is unopenable)"
fi
exit $rc
