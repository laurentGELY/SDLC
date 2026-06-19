#!/bin/bash
# Hook pre-tool-bash — Projet toolkit SDLC
# Version : 2.1.0 | 2026-06-19 | Sprint SDLC-18 (fix-hooks-m04)
# Déclenché avant tout Bash/Edit/Write par Claude Code (matcher étendu — settings.json).
# Bloque les commandes incompatibles avec les contraintes du projet.
#
# Protocole Claude Code :
#   exit 0  = autoriser
#   exit 1  = bloquer (silencieux)
#   exit 2  = bloquer avec message d'erreur affiché dans Claude Code
#
# Schéma JSON réel reçu sur stdin (confirmé empiriquement, Sprint SDLC-18 — capture directe
# sans restart de session, PAS une doc tierce) :
#   {"session_id":"...","hook_event_name":"PreToolUse","tool_name":"Bash"|"Edit"|"Write",
#    "tool_input":{"command":"..."}} ou {"tool_input":{"file_path":"...", ...}}
# Ancien schéma supposé ({"tool":"bash","input":{"command":"..."}}) confirmé erroné — $CMD
# était toujours vide depuis SDLC-14, les blocages [UNIVERSEL] ne matchaient jamais rien.
# Historique des règles : 07-DECISIONS-SDLC.md (M-HOOKS-01→06)

set -euo pipefail

INPUT=$(cat)
TOOL=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_name', ''))
" 2>/dev/null || echo "")
CMD=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_input', {}).get('command', ''))
" 2>/dev/null || echo "")
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('tool_input', {}).get('file_path', ''))
" 2>/dev/null || echo "")

# ─── M-HOOKS-04 — garde-fou étape 4a (Claude.md §Démarrage) ──────────────────────────────────
# Si une mémoire de sprint référence un spec absent du disque, bloquer toute action SAUF celle
# qui créerait/éditerait ce spec lui-même (carve-out anti auto-verrouillage dès la conception —
# cf. 07-DECISIONS-SDLC.md M-HOOKS-04).
SPRINT_MEMORY=".claude/sprint-memory.md"
if [ -f "$SPRINT_MEMORY" ]; then
  SPEC_PATH=$(grep -m1 "# Spec : " "$SPRINT_MEMORY" 2>/dev/null | sed 's/^# Spec : //')
  if [ -n "$SPEC_PATH" ] && [ ! -f "$SPEC_PATH" ]; then
    CARVE_OUT=0
    if [ "$TOOL" = "Write" ] || [ "$TOOL" = "Edit" ]; then
      # FILE_PATH est toujours absolu (confirmé empiriquement, Sprint SDLC-18) — comparer en
      # suffixe, jamais en égalité stricte avec SPEC_PATH qui reste relatif.
      if [[ "$FILE_PATH" == "$SPEC_PATH" || "$FILE_PATH" == */"$SPEC_PATH" || "$FILE_PATH" == */specs/Sprints/* ]]; then
        CARVE_OUT=1
      fi
    fi
    # [M-HOOKS-06] Allowlist Bash lecture seule pendant le blocage — réduit le risque
    # d'auto-verrouillage total si un futur bug affecte le carve-out Write/Edit ci-dessus.
    # Une seule commande simple autorisée : pas de chaînage (;, &&, ||, |), pas de
    # redirection (>, >>), pas de substitution ($(), backticks) — sinon retombe au blocage.
    if [ "$TOOL" = "Bash" ] && ! echo "$CMD" | grep -qE '[;&|`]|\$\(|>'; then
      if echo "$CMD" | grep -qE '^[[:space:]]*(git[[:space:]]+(status|diff|log|show)\b|ls\b|cat\b|pwd\b|find\b|grep\b|head\b|tail\b|wc\b|bash[[:space:]]+-n\b)'; then
        CARVE_OUT=1
      fi
    fi
    if [ "$CARVE_OUT" -eq 0 ]; then
      echo "BLOQUÉ : étape 4a non exécutée — $SPEC_PATH référencé dans $SPRINT_MEMORY mais absent du disque." >&2
      echo "Créer ce fichier spec avant toute autre action (Claude.md §Démarrage 4a)." >&2
      echo "Commandes en lecture seule autorisées pendant ce blocage (simples, sans chaînage ni redirection) : git status/diff/log/show, ls, cat, pwd, find, grep, head, tail, wc, bash -n." >&2
      echo "Recours en dernier ressort (hors session Claude Code, si aucun outil ne débloque) : rm -f $SPRINT_MEMORY" >&2
      exit 2
    fi
  fi
fi

# ─── BLOCAGES STRICTS ─────────────────────────────────────────────────────────────────────────

# [UNIVERSEL] git push --force — destructif sur l'historique partagé
if echo "$CMD" | grep -qE 'git\s+push.*(--force|-f)\s'; then
  echo "BLOQUÉ : git push --force interdit." >&2
  echo "Utiliser git revert pour annuler un commit déjà poussé." >&2
  exit 2
fi

# [UNIVERSEL] rm -rf sur racine projet ou dossiers critiques
if echo "$CMD" | grep -qE 'rm\s+-rf\s+(/|\./)?(\.git|specs|doc|exemples)\b'; then
  echo "BLOQUÉ : rm -rf sur dossier critique détecté." >&2
  echo "Supprimer les fichiers individuellement ou demander confirmation." >&2
  exit 2
fi

# ─── AVERTISSEMENTS NON BLOQUANTS ────────────────────────────────────────────────────────────

# [UNIVERSEL] sudo hors apt/snap/systemctl — risque système
if echo "$CMD" | grep -qE '^sudo\s+' && \
   ! echo "$CMD" | grep -qE 'sudo\s+(apt|snap|systemctl)'; then
  echo "AVERTISSEMENT : commande sudo hors apt/snap détectée." >&2
  echo "Vérifier que cette commande est nécessaire et documentée." >&2
fi

exit 0
