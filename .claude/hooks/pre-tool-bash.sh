#!/bin/bash
# Hook pre-tool-bash — Projet toolkit SDLC
# Version : 1.0.0 | 2026-06-19 | Sprint SDLC-14 (self-bootstrap)
# Déclenché avant toute commande Bash par Claude Code.
# Bloque les commandes incompatibles avec les contraintes du projet.
#
# Protocole Claude Code :
#   exit 0  = autoriser
#   exit 1  = bloquer (silencieux)
#   exit 2  = bloquer avec message d'erreur affiché dans Claude Code
#
# Le JSON d'entrée arrive sur stdin : {"tool":"bash","input":{"command":"..."}}
# Historique des règles : 07-DECISIONS-SDLC.md
#
# Aucune section [ACTIVER si...] n'est pertinente ici (pas de stack
# applicative, pas de pip/npm/venv/.env) — seuls les blocages [UNIVERSEL]
# du template 08-hooks-TEMPLATE.md sont repris.

set -euo pipefail

# Lire la commande depuis stdin (JSON Claude Code)
INPUT=$(cat)
CMD=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('input', {}).get('command', ''))
" 2>/dev/null || echo "")

# ─── BLOCAGES STRICTS ────────────────────────────────────────────────────────

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

# ─── AVERTISSEMENTS NON BLOQUANTS ────────────────────────────────────────────

# [UNIVERSEL] sudo hors apt/snap/systemctl — risque système
if echo "$CMD" | grep -qE '^sudo\s+' && \
   ! echo "$CMD" | grep -qE 'sudo\s+(apt|snap|systemctl)'; then
  echo "AVERTISSEMENT : commande sudo hors apt/snap détectée." >&2
  echo "Vérifier que cette commande est nécessaire et documentée." >&2
fi

exit 0
