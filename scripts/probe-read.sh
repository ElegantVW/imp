#!/usr/bin/env bash
# probe-read.sh — can the demon block on a pipe with a plain `read`?
#
# `sleep` does not exist in this build, so a blocking read on a FIFO is
# the only way the bridge can avoid a 100%-CPU polling loop. the writer
# loops, so the rendezvous cannot be missed and a hang is meaningful.
set -uo pipefail
IMP="$HOME/imp"
PIPE="/dev/shm/imp/keys"
LINK="$IMP/keys-probe.fifo"

mkdir -p /dev/shm/imp
rm -f "$PIPE" "$LINK"
mkfifo "$PIPE"
ln -sf "$PIPE" "$LINK"
rm -f "$IMP/probe-read.txt"

# the writer keeps offering, forever, until the reader takes one
(
  for i in 1 2 3 4 5 6 7 8; do
    printf 'ping\n' > "$PIPE" 2>/dev/null || break
  done
) &
WPID=$!

timeout 80 "$IMP/rited" "$IMP/tests/rites/probe-read.red" probe-read.txt
rc=$?
kill $WPID 2>/dev/null
wait $WPID 2>/dev/null

echo "---"
if [[ -s "$IMP/probe-read.txt" ]]; then
  cat "$IMP/probe-read.txt"
else
  echo "(no testimony: the demon did not block, or did not return)"
fi
exit $rc
