# Hooks Claude Code — Template Python · v1.0
<!-- Template SDLC v1.2 · Destination : .claude/hooks/ dans le repo cible -->
<!-- Généré au bootstrap · Complété au fil des sprints via boucle LESSONS_LEARNED -->

> Les hooks rendent certaines règles non-négociables — indépendamment de la mémoire du modèle.
> Ce template est Python-first. Les sections marquées `# [ACTIVER si…]` sont désactivées par défaut.
> Règle d'or : n'activer une section que si elle correspond à une contrainte réelle du projet,
> pas par précaution théorique.

---

## Arborescence attendue

```
.claude/
├── hooks/
│   └── pre-tool-bash.sh      # Hook PreToolUse Bash — copier et adapter
├── settings.json             # Déclare le hook — copier tel quel
└── settings.local.json       # Permissions allow locales — créer vide, compléter au fil de l'eau
```

---

## 1. `.claude/hooks/pre-tool-bash.sh`

Copier dans le projet cible, puis activer les sections pertinentes.
Grep de validation post-adaptation : `grep "\[ACTIVER" .claude/hooks/pre-tool-bash.sh`
→ zéro résultat attendu si toutes les décisions sont prises.

```bash
#!/bin/bash
# Hook pre-tool-bash — [Nom du projet]
# Version : 1.0.0 | [AAAA-MM-JJ] | [Nom du projet]
# Déclenché avant toute commande Bash par Claude Code.
# Bloque les commandes incompatibles avec les contraintes du projet.
# Émet des avertissements (non bloquants) sur les commandes à risque.
#
# Protocole Claude Code :
#   exit 0  = autoriser
#   exit 1  = bloquer (silencieux)
#   exit 2  = bloquer avec message d'erreur affiché dans Claude Code
#
# Le JSON d'entrée arrive sur stdin : {"tool":"bash","input":{"command":"..."}}
# Historique des règles : doc/DECISIONS.md §D-HOOK-XX

set -euo pipefail

# Lire la commande depuis stdin (JSON Claude Code)
INPUT=$(cat)
CMD=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('input', {}).get('command', ''))
" 2>/dev/null || echo "")

# ─── BLOCAGES STRICTS ────────────────────────────────────────────────────────
# Chaque blocage doit avoir une entrée dans doc/DECISIONS.md (préfixe D-HOOK-XX)

# [UNIVERSEL] git push --force — destructif sur l'historique partagé
if echo "$CMD" | grep -qE 'git\s+push.*(--force|-f)\s'; then
  echo "BLOQUÉ : git push --force interdit." >&2
  echo "Utiliser git revert pour annuler un commit déjà poussé." >&2
  exit 2
fi

# [UNIVERSEL] rm -rf sur racine projet ou dossiers critiques
if echo "$CMD" | grep -qE 'rm\s+-rf\s+(/|\./)?(\.git|src|data|db|scripts)\b'; then
  echo "BLOQUÉ : rm -rf sur dossier critique détecté." >&2
  echo "Supprimer les fichiers individuellement ou demander confirmation." >&2
  exit 2
fi

# [ACTIVER si politique apt-first] pip install --break-system-packages
# Décommenter si le projet interdit pip système au profit de apt/venv.
# → Documenter dans DECISIONS.md §D-HOOK-01
#
# if echo "$CMD" | grep -qE 'pip(3)?\s+install.*--break-system-packages'; then
#   echo "BLOQUÉ : pip install --break-system-packages interdit dans ce projet." >&2
#   echo "Ordre d'installation : apt → snap → venv (documenter si venv nécessaire)." >&2
#   exit 2
# fi

# [ACTIVER si politique venv obligatoire] pip install hors venv
# Décommenter si tout pip install doit se faire dans un venv activé.
# → Documenter dans DECISIONS.md §D-HOOK-02
#
# if echo "$CMD" | grep -qE 'pip(3)?\s+install\s+[^-]'; then
#   if [ -z "${VIRTUAL_ENV:-}" ]; then
#     echo "BLOQUÉ : pip install hors venv détecté." >&2
#     echo "Activer le venv du projet avant d'installer des dépendances." >&2
#     exit 2
#   fi
# fi

# [ACTIVER si projet Python pur] npm/yarn — non utilisés
# Décommenter si le projet est Python uniquement et npm/yarn ne doivent jamais être appelés.
# → Documenter dans DECISIONS.md §D-HOOK-03
#
# if echo "$CMD" | grep -qE '(npm|yarn)\s+(install|add|ci)'; then
#   echo "BLOQUÉ : npm/yarn ne sont pas utilisés dans ce projet Python." >&2
#   exit 2
# fi

# [ACTIVER si fichiers de données critiques] écriture directe hors pipeline
# Décommenter et adapter le pattern si certains fichiers ne doivent être écrits
# que par le script principal (ex : jsonl de production, bases sqlite).
# → Documenter dans DECISIONS.md §D-HOOK-04
#
# FICHIERS_PROTEGES="(nom_fichier_1|nom_fichier_2)\.(jsonl|sqlite)"
# if echo "$CMD" | grep -qE "$FICHIERS_PROTEGES" && \
#    ! echo "$CMD" | grep -q 'dry.run'; then
#   echo "BLOQUÉ : écriture directe dans fichier de données protégé détectée." >&2
#   echo "Ces fichiers ne sont écrits que par le pipeline principal." >&2
#   exit 2
# fi

# ─── AVERTISSEMENTS NON BLOQUANTS ────────────────────────────────────────────
# Ces règles émettent un rappel sans interrompre l'exécution.

# [UNIVERSEL] sudo hors apt/snap/systemctl — risque système
if echo "$CMD" | grep -qE '^sudo\s+' && \
   ! echo "$CMD" | grep -qE 'sudo\s+(apt|snap|systemctl)'; then
  echo "AVERTISSEMENT : commande sudo hors apt/snap détectée." >&2
  echo "Vérifier que cette commande est nécessaire et documentée." >&2
fi

# [ACTIVER si fichier .env présent] accès direct aux secrets
# Décommenter si le projet a un .env contenant des secrets (API keys, tokens).
# → Documenter dans DECISIONS.md §D-HOOK-05
#
# if echo "$CMD" | grep -qE '(cat|echo|tee|nano|vim|sed)\s+\.env([^.]|$)'; then
#   echo "AVERTISSEMENT : accès direct à .env détecté." >&2
#   echo "Ne jamais afficher le contenu de .env dans les logs ou sorties partagées." >&2
# fi

# [ACTIVER si fichier config critique] modification directe de config sans sauvegarde
# Adapter le nom du fichier de config principal du projet.
# → Documenter dans DECISIONS.md §D-HOOK-06
#
# FICHIER_CONFIG="config.yaml"  # [→ ADAPTER] nom du fichier de config principal
# if echo "$CMD" | grep -qE "(sed|echo|tee).*${FICHIER_CONFIG}"; then
#   echo "AVERTISSEMENT : modification directe de ${FICHIER_CONFIG} détectée." >&2
#   echo "Règle Claude.md : noter la valeur précédente avant modification." >&2
# fi

exit 0
```

---

## 2. `.claude/settings.json`

Copier tel quel — déclare le hook PreToolUse sur Bash.
Ne pas modifier sauf ajout d'un PostToolUse (voir §PostToolUse ci-dessous).

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/pre-tool-bash.sh"
          }
        ]
      }
    ]
  }
}
```

---

## 3. `.claude/settings.local.json`

Créer vide au bootstrap. Les entrées `allow` s'accumulent au fil des sessions
quand Claude Code demande confirmation pour une commande récurrente légitime.
Ne pas versionner si les chemins contiennent des chemins absolus personnels.

```json
{
  "permissions": {
    "allow": [
      // Compléter au fil des sessions — ex :
      // "Bash(python3 *)",
      // "Bash(git status)",
      // "Bash(pytest tests/ -q)"
    ]
  }
}
```

---

## §PostToolUse — optionnel, à activer consciemment

Un hook PostToolUse (lint/format automatique après écriture) est rentable
si le projet a un formatter configuré et des tests rapides (< 5s).

À ne pas activer par défaut — un test lent déclenché à chaque Edit ralentit
significativement le workflow. Décider au sprint 1 ou 2 une fois la stack stabilisée.

Si activé → ajouter dans `settings.json` :

```json
"PostToolUse": [
  {
    "matcher": "Edit|Write",
    "hooks": [
      {
        "type": "command",
        "command": "ruff format \"${tool_input_file}\" 2>/dev/null || true"
      },
      {
        "type": "command",
        "command": "ruff check \"${tool_input_file}\" --fix 2>/dev/null || true"
      }
    ]
  }
]
```

→ Documenter la décision dans `doc/DECISIONS.md` §D-HOOK-07.

---

## §Boucle de rétroaction — comment les règles évoluent

Les hooks ne sont pas figés au bootstrap. Le modèle de rétroaction est :

```
Incident ou hésitation en session
         ↓
Entrée LESSONS_LEARNED avec tag [HOOK_CANDIDATE] + ligne bash proposée
         ↓
/retrospective détecte ≥ 2 occurrences ou 1 incident grave
         ↓
Décision humaine explicite → décommenter/ajouter section dans pre-tool-bash.sh
         ↓
Entrée doc/DECISIONS.md §D-HOOK-XX + commit
```

**Règle** : ne jamais ajouter une règle dans le hook sans entrée DECISIONS.md correspondante.
Le hook est la conséquence d'une décision documentée, pas une précaution implicite.

---

## §Critères d'acceptation bootstrap hooks

- [ ] `pre-tool-bash.sh` : chmod +x, zéro section `[ACTIVER` non décidée
- [ ] `settings.json` : hook PreToolUse Bash déclaré
- [ ] `settings.local.json` : fichier créé (vide ou avec premières permissions)
- [ ] Grep de validation : `grep "\[ACTIVER" .claude/hooks/pre-tool-bash.sh` → zéro résultat
- [ ] Test smoke : `echo '{"tool":"bash","input":{"command":"echo ok"}}' | bash .claude/hooks/pre-tool-bash.sh` → exit 0
