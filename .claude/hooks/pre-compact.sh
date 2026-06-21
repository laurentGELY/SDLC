#!/bin/bash
# Hook pre-compact — Projet toolkit SDLC
# Version : 1.0.0 | 2026-06-21 | Sprint SDLC-23
# Déclenché par Claude Code avant toute compaction (manuelle ou automatique).
# Écrit un checkpoint dans .claude/sprint-memory.md pour que la reprise après
# une pause forcée par tranche horaire suive le même chemin que la reprise
# après crash (M-PROC-13/M-HOOKS-08).
#
# Schéma JSON réel reçu sur stdin (PreCompact) — confirmé verbatim
# code.claude.com/docs/en/hooks (Sprint SDLC-23, PAS le schéma "trigger"
# supposé par le PDR initial, qui était erroné — cf. 07-DECISIONS-SDLC.md M-HOOKS-08) :
#   {"session_id":"...","transcript_path":"...","cwd":"...","hook_event_name":"PreCompact",
#    "permission_mode":"...","compaction_reason":"manual"|"auto","context_used_tokens":N,
#    "context_limit_tokens":N,"estimated_tokens_freed":N}
#
# PreCompact peut bloquer via {"decision":"block"} mais ce script ne l'utilise jamais —
# toujours exit 0, y compris en cas d'échec de parsing JSON ou d'écriture fichier.

set -uo pipefail  # pas -e : un échec partiel ne doit jamais empêcher le exit 0 final

INPUT=$(cat)
read -r REASON USED LIMIT FREED TRANSCRIPT <<< "$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('compaction_reason', 'unknown'),
      data.get('context_used_tokens', '?'),
      data.get('context_limit_tokens', '?'),
      data.get('estimated_tokens_freed', '?'),
      data.get('transcript_path', '-'))
" 2>/dev/null || echo "unknown ? ? ? -")"

MEMORY_FILE=".claude/sprint-memory.md"

# Rien à checkpointer si aucun sprint actif (fichier absent) — ne pas en créer un.
if [ -f "$MEMORY_FILE" ]; then
  TIMESTAMP=$(date +%H:%M)
  ENTRY="[$TIMESTAMP] CHECKPOINT — compaction reason=$REASON — tokens ${USED}/${LIMIT} (≈${FREED} libérés) — transcript : \`$TRANSCRIPT\`"
  # Entrée la plus récente en tête, juste sous le header 2 lignes (cohérent
  # avec le format accumulatif déjà utilisé pour SESSION_BRIDGE.md, M-PROC-22).
  HEADER=$(head -2 "$MEMORY_FILE" 2>/dev/null)
  REST=$(tail -n +3 "$MEMORY_FILE" 2>/dev/null)
  { printf '%s\n' "$HEADER" "$ENTRY" "$REST"; } > "${MEMORY_FILE}.tmp" 2>/dev/null \
    && mv "${MEMORY_FILE}.tmp" "$MEMORY_FILE" 2>/dev/null
fi

exit 0
