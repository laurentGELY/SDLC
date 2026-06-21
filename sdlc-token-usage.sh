#!/bin/bash
# sdlc-token-usage.sh — Mesure la consommation token réelle depuis les transcripts JSONL Claude Code
# Usage : bash sdlc-token-usage.sh [--dry-run]
# Prérequis : jq · répertoire courant = racine du projet cible
# Limitation connue : bucketisation par HH:MM (sans date) — suppose un sprint
# mono-journée locale ; chemin ~/.claude/projects/ non garanti stable inter-OS (cf. M-ENV-01)

set -e

CLAUDE_PROJECTS_DIR="${CLAUDE_PROJECTS_DIR:-$HOME/.claude/projects}"
PROJECT_SLUG=$(pwd | sed 's|/|-|g')
SESSION_DIR="$CLAUDE_PROJECTS_DIR/$PROJECT_SLUG"
MEMORY_FILE=".claude/sprint-memory.md"

if [ "$1" = "--dry-run" ]; then
  echo "[dry-run] Session dir : $SESSION_DIR"
  echo "[dry-run] jq présent  : $(command -v jq || echo 'NON')"
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "⚠️  jq requis — installer jq pour utiliser ce script" >&2
  exit 1
fi

if [ ! -d "$SESSION_DIR" ]; then
  echo "⚠️  Aucun transcript trouvé pour ce projet ($SESSION_DIR)" >&2
  exit 1
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 sdlc-token-usage — $(basename "$(pwd)") — $(date +%d/%m/%Y)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

USAGE=$(jq -r 'select(.type=="assistant" and .message.usage != null) |
  [(.timestamp | sub("\\.[0-9]+Z$"; "Z") | fromdateiso8601 | localtime | strftime("%H:%M")),
   (.message.usage.input_tokens // 0),
   (.message.usage.output_tokens // 0),
   (.message.usage.cache_read_input_tokens // 0),
   (.message.usage.cache_creation_input_tokens // 0)] | @tsv' \
  "$SESSION_DIR"/*.jsonl 2>/dev/null || true)

if [ -z "$USAGE" ]; then
  echo "⚠️  Aucune entrée usage trouvée dans les transcripts"
  exit 0
fi

echo ""
echo "TOTAUX BRUTS (toutes sessions du projet)"
echo "$USAGE" | awk -F'\t' '
  {in_t+=$2; out_t+=$3; cr_t+=$4; cc_t+=$5}
  END {
    printf "  input_tokens          : %d\n", in_t
    printf "  output_tokens         : %d\n", out_t
    printf "  cache_read_tokens     : %d\n", cr_t
    printf "  cache_creation_tokens : %d\n", cc_t
  }'

if [ ! -f "$MEMORY_FILE" ]; then
  echo ""
  echo "(pas de $MEMORY_FILE — bucketisation par étape ignorée)"
  exit 0
fi

BOUNDARIES=$(grep -oE '^\[[0-2][0-9]:[0-5][0-9]\] [A-ZÀ-Ü]+' "$MEMORY_FILE" \
  | sed -E 's/^\[([0-9:]+)\] (.*)/\1\t\2/')

if [ -z "$BOUNDARIES" ]; then
  echo ""
  echo "($MEMORY_FILE présent mais sans entrée horodatée reconnue — bucketisation ignorée)"
  exit 0
fi

echo ""
echo "PAR ÉTAPE ($MEMORY_FILE)"
awk -F'\t' '
  NR==FNR { n++; btime[n]=$1; blabel[n]=$1" "$2; next }
  {
    t=$1; idx=0
    for (i=1; i<=n; i++) if (btime[i] <= t) idx=i
    if (idx==0) { pre_in+=$2; pre_out+=$3; pre_cr+=$4 }
    else { bin[idx]+=$2; bout[idx]+=$3; bcr[idx]+=$4 }
  }
  END {
    printf "  %-18s %10s %10s %10s\n", "étape", "input", "output", "cache_read"
    if (pre_in+pre_out+pre_cr > 0)
      printf "  %-18s %10d %10d %10d\n", "(avant 1ère étape)", pre_in, pre_out, pre_cr
    for (i=1; i<=n; i++)
      printf "  %-18s %10d %10d %10d\n", blabel[i], bin[i], bout[i], bcr[i]
  }' <(echo "$BOUNDARIES") <(echo "$USAGE")
