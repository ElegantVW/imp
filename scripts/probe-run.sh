#!/usr/bin/env bash
# probe-run.sh — run each line of a question list as its own rite.
# A rite that fails to write its witness is a COMPILE error, and the
# question is reported as dead. This gives per-line attribution.
#
# Horror 10: a parse error anywhere kills the whole script, so questions
# are isolated one per rite rather than batched into one file.
# Horror 6: the console change-dirs to the rite's own directory, so each
# rite is staged in the imp root.
# Every staged rite needs a `Red [...]` header or it dies with no-header.
#
# Usage: probe-run.sh <questions-file> [prefix] [timeout-secs]
set -uo pipefail

QF="${1:?usage: probe-run.sh <questions-file> [prefix] [timeout]}"
PREFIX="${2:-pl}"
TMO="${3:-30}"
ROOT="$HOME/imp"
DRV="$ROOT/scripts/red-eval"

[[ -x "$DRV" ]] || { echo "red-eval missing" >&2; exit 1; }
"$DRV" init >/dev/null || { echo "no console" >&2; exit 1; }

mkdir -p "$ROOT/.probes"
REPORT="$ROOT/.probes/$PREFIX-report.txt"
: > "$REPORT"

# The console wedges: one bad rite can stop the input loop for good, and
# every later rite then "fails" for no reason. So we health-check before
# every question and rebuild the console if it stopped answering. Without
# this, a wedge masquerades as a wall of compile errors.
HEALTH="/tmp/probe-health.red"
printf 'Red [Title: "health"]\nwrite %%probe-health.txt "ok"\n' > "$HEALTH"

healthy() {
    rm -f "$ROOT/probe-health.txt"
    "$DRV" "$HEALTH" probe-health.txt 12 >/dev/null 2>&1
    [[ -s "$ROOT/probe-health.txt" ]]
}
rebuild() {
    "$DRV" init >/dev/null 2>&1
    healthy
}

rebuild || { echo "console never came up" >&2; exit 1; }

n=0
while IFS= read -r line; do
    [[ -z "${line// }" ]] && continue
    [[ "$line" == \#* ]] && continue
    n=$((n+1))
    id=$(printf "%03d" "$n")
    stage="/tmp/probe-$PREFIX-$id.red"
    ans="ans-$PREFIX-$id.txt"

    cat > "$stage" <<EOF
Red [Title: "probe $PREFIX $id"]
out: make string! 0
r: none
r: try/all [$line]
s: either error? r [rejoin ["ERR " mold r/type " / " mold r/id]] [either none = r ["none!"] [mold r]]
append out s
write %$ans out
EOF

    got="$("$DRV" "$stage" "$ans" "$TMO" 2>/dev/null | tr '\n' ' ')"
    if [[ -n "$got" ]]; then
        printf '%-50s %s\n' "$line" "$got" >> "$REPORT"
    else
        # Could be a genuine compile error, or a wedged console. Ask.
        if healthy; then
            printf '%-50s *** DEAD (real) ***\n' "$line" >> "$REPORT"
        else
            printf '%-50s [console wedged, rite not measured]\n' "$line" >> "$REPORT"
            rebuild >/dev/null 2>&1
            got="$("$DRV" "$stage" "$ans" "$TMO" 2>/dev/null | tr '\n' ' ')"
            if [[ -n "$got" ]]; then
                printf '%-50s [retry] %s\n' "$line" "$got" >> "$REPORT"
            else
                printf '%-50s *** DEAD (after rebuild) ***\n' "$line" >> "$REPORT"
            fi
        fi
    fi
    rm -f "$stage" "$ROOT/$ans"
done < "$QF"

echo "wrote $REPORT ($n questions)"
