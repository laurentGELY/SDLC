#!/bin/bash
# sdlc-init.sh — Bootstrap SDLC pour un nouveau projet
# Usage : bash /chemin/vers/sdlc-toolkit/sdlc-init.sh "Nom du projet"
# Prérequis : repo git initialisé · répertoire courant = racine du projet cible
#
# Ce script fait le travail mécanique. Claude Code fait le travail de sens.
# Après l'exécution, ouvrir Claude Code et demander la complétion (voir §Étape 2 de 10-OPERATIONS.html).

set -euo pipefail

# ─── CONFIGURATION ───────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SDLC_VERSION="v1.3"
DATE_TODAY=$(date +%d/%m/%Y)
DATE_ISO=$(date +%Y-%m-%d)

# ─── ARGUMENTS ───────────────────────────────────────────────────────────────

if [ $# -lt 1 ]; then
  echo "Usage : bash sdlc-init.sh \"Nom du projet\""
  echo "Exemple : bash sdlc-init.sh \"MonProjet\""
  exit 1
fi

PROJECT_NAME="$1"
TARGET_DIR="$(pwd)"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🏗️  SDLC Init ${SDLC_VERSION} — ${PROJECT_NAME}"
echo "   Cible : ${TARGET_DIR}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ─── VÉRIFICATIONS PRÉALABLES ────────────────────────────────────────────────

if [ ! -d "${TARGET_DIR}/.git" ]; then
  echo "❌ Aucun repo git détecté dans ${TARGET_DIR}"
  echo "   Initialiser d'abord : git init && git commit --allow-empty -m 'chore: init repo'"
  exit 1
fi

if [ -f "${TARGET_DIR}/Claude.md" ]; then
  echo "⚠️  Claude.md existe déjà dans ce repo."
  echo "   Pour un projet existant, utiliser /sdlc-sync dans Claude Code."
  read -p "   Continuer quand même ? (y/N) : " confirm
  if [ "${confirm}" != "y" ] && [ "${confirm}" != "Y" ]; then
    echo "   Annulé."
    exit 0
  fi
fi

# ─── HELPER : copier + remplacer placeholders ────────────────────────────────

deploy_template() {
  local src="$1"
  local dst="$2"
  local dir
  dir="$(dirname "${dst}")"
  mkdir -p "${dir}"
  sed \
    -e "s/\[Nom du projet\]/${PROJECT_NAME}/g" \
    -e "s/JJ\/MM\/AAAA/${DATE_TODAY}/g" \
    -e "s/AAAA-MM-JJ/${DATE_ISO}/g" \
    "${src}" > "${dst}"
  echo "  ✅ ${dst}"
}

deploy_copy() {
  local src="$1"
  local dst="$2"
  local dir
  dir="$(dirname "${dst}")"
  mkdir -p "${dir}"
  cp "${src}" "${dst}"
  echo "  ✅ ${dst}"
}

# ─── ÉTAPE 1 : STRUCTURE DES DOSSIERS ────────────────────────────────────────

echo "📁 Création de la structure..."
mkdir -p \
  "${TARGET_DIR}/doc" \
  "${TARGET_DIR}/specs/Sprints" \
  "${TARGET_DIR}/.claude/skills/wrap-up" \
  "${TARGET_DIR}/.claude/skills/retrospective" \
  "${TARGET_DIR}/.claude/skills/sdlc-sync" \
  "${TARGET_DIR}/.claude/skills/diagnostic" \
  "${TARGET_DIR}/.claude/hooks"
echo "  ✅ Dossiers créés"
echo ""

# ─── ÉTAPE 2 : FICHIERS RACINE ───────────────────────────────────────────────

echo "📄 Fichiers racine..."
deploy_template "${SCRIPT_DIR}/01-Claude-md-TEMPLATE.md"  "${TARGET_DIR}/Claude.md"
deploy_template "${SCRIPT_DIR}/02-STANDARDS-TEMPLATE.md"  "${TARGET_DIR}/STANDARDS.md"

# CHANGELOG from scratch
cat > "${TARGET_DIR}/CHANGELOG.md" << CHANGELOG
<!-- VERSION : 1.0 | ${DATE_TODAY} | ${PROJECT_NAME} -->

# CHANGELOG

Toutes les modifications notables de ce projet sont documentées ici.
Format : Semantic Versioning adapté aux sprints.

---

## [1.0] — ${DATE_ISO} · Sprint 0 · Bootstrap SDLC

- **\`Claude.md\` v1.0** : instructions permanentes Claude Code — à compléter (§Rôle · §Limites bash)
- **\`STANDARDS.md\` v1.0** : Definition of Done · types de sprint · niveaux de test
- **\`specs/sprint-template.md\`** : template PDR générique
- **\`.claude/skills/wrap-up/SKILL.md\` v1.0** : procédure clôture sprint
- **\`.claude/skills/sdlc-sync/SKILL.md\` v1.0** : skill alignement modèle SDLC
- **\`.claude/skills/retrospective/SKILL.md\` v1.0** : procédure rétrospective
- **\`.claude/hooks/pre-tool-bash.sh\` v1.0** : hook PreToolUse Bash
- **\`.claude/settings.json\`** : configuration hooks Claude Code
- **\`doc/ROADMAP.md\` v1.0** : structure Now/Next/Later
- **\`doc/DECISIONS.md\` v1.0** : registre décisions architecturales
- **\`doc/LESSONS_LEARNED.md\`** : registre apprentissages
- **\`doc/DIAGNOSTIC_CMDS.md\`** : archive commandes diagnostic
- **\`specs/SPEC.md\`** : structure architecture — à compléter par Claude Code
- **Tests** : N/A (bootstrap doc)
CHANGELOG
echo "  ✅ CHANGELOG.md"
echo ""

# ─── ÉTAPE 3 : DOSSIER doc/ ──────────────────────────────────────────────────

echo "📄 Dossier doc/..."

# ROADMAP depuis template
deploy_template "${SCRIPT_DIR}/05-ROADMAP-TEMPLATE.md" "${TARGET_DIR}/doc/ROADMAP.md"

# DECISIONS from scratch
cat > "${TARGET_DIR}/doc/DECISIONS.md" << DECISIONS
<!-- VERSION : 1.0 | ${DATE_TODAY} | ${PROJECT_NAME} -->

# DECISIONS

Registre exhaustif des décisions architecturales du projet.
Format : ID · Décision retenue · Alternative écartée · Justification

---

## Conventions

| Préfixe | Domaine |
|---------|---------|
| D-ARCH  | Architecture globale |
| D-PROC  | Procédures développement |
| D-OBS   | Observabilité |
| D-HOOK  | Hooks Claude Code |
| D-SYNC  | Alignements SDLC-Sync |
DECISIONS
echo "  ✅ doc/DECISIONS.md"

# LESSONS_LEARNED from scratch
cat > "${TARGET_DIR}/doc/LESSONS_LEARNED.md" << LESSONS
<!-- VERSION : 1.0 | ${DATE_TODAY} | ${PROJECT_NAME} -->

# LESSONS LEARNED

Registre des apprentissages par sprint.

---

## §Index des patterns

<!-- Remplir au fil des sprints — format : P-XX · [description] · sprints [N, M] -->
*Vide au bootstrap.*

Dernière /retrospective : —

---

## §Entrées par sprint

<!-- Format d'entrée :
### Sprint N — JJ/MM/AAAA — [Titre]
**Code :** [observations — ou "RAS"]
**Processus :** [observations — ou "RAS"]
**Lien pattern :** [confirme P-XX / infirme P-XX / aucun]
**Action proposée :** [action + destination] → décision : [en attente]
**Hook candidat :** [HOOK_CANDIDATE] [description] → ligne bash : \`[pattern]\` — décision : [en attente]
**SDLC candidat :** [SDLC_CANDIDATE] [description] → fichier cible : [...] — décision : [en attente]
-->

*Vide au bootstrap.*
LESSONS
echo "  ✅ doc/LESSONS_LEARNED.md"

# DIAGNOSTIC_CMDS from scratch
cat > "${TARGET_DIR}/doc/DIAGNOSTIC_CMDS.md" << DIAG
<!-- VERSION : 1.0 | ${DATE_TODAY} | ${PROJECT_NAME} -->

# DIAGNOSTIC_CMDS

Archive des commandes ayant localisé ou résolu un problème.
Alimenté à chaque /wrap-up (Étape 3 — obligatoire).

---

## Format

\`\`\`
## Symptôme : <description>
Date : JJ/MM/AAAA
Commande : <commande exacte>
Résultat observé : <ce qu'on a vu>
Conclusion : <ce que ça a confirmé ou infirmé>
\`\`\`

---

*Vide au bootstrap.*
DIAG
echo "  ✅ doc/DIAGNOSTIC_CMDS.md"
echo ""

# ─── ÉTAPE 4 : DOSSIER specs/ ────────────────────────────────────────────────

echo "📄 Dossier specs/..."
deploy_copy "${SCRIPT_DIR}/04-sprint-PDR-TEMPLATE.md" "${TARGET_DIR}/specs/sprint-template.md"

# SPEC.md from scratch — structure vide, Claude Code la remplit
cat > "${TARGET_DIR}/specs/SPEC.md" << SPEC
<!-- VERSION : 1.0 | ${DATE_TODAY} | ${PROJECT_NAME} -->
<!-- [→ ADAPTER] Ce fichier est à compléter par Claude Code en début de Sprint 1 -->

# SPEC — ${PROJECT_NAME}

Référence architecturale exhaustive du projet. Toujours à jour.
Mise à jour dans le même commit que tout changement de comportement système.

---

## §1 — Vue d'ensemble

<!-- [→ ADAPTER] Description du projet, objectif principal, utilisateurs -->

---

## §2 — Architecture

<!-- [→ ADAPTER] Schéma ou description des composants principaux -->

---

## §3 — Modules

<!-- [→ ADAPTER] Liste des modules, leur rôle, leurs dépendances -->

---

## §4 — Interfaces et formats

<!-- [→ ADAPTER] Formats d'entrée/sortie, APIs, schémas de données -->

---

## §5 — Contraintes et hypothèses

<!-- [→ ADAPTER] Contraintes techniques, hypothèses de conception -->
SPEC
echo "  ✅ specs/SPEC.md (structure vide — à compléter par Claude Code)"
echo ""

# ─── ÉTAPE 5 : SKILLS ────────────────────────────────────────────────────────

echo "📄 Skills Claude Code..."
deploy_template "${SCRIPT_DIR}/03-wrap-up-SKILL-TEMPLATE.md" \
  "${TARGET_DIR}/.claude/skills/wrap-up/SKILL.md"
deploy_copy "${SCRIPT_DIR}/09-retrospective-SKILL-TEMPLATE.md" \
  "${TARGET_DIR}/.claude/skills/retrospective/SKILL.md"
deploy_copy "${SCRIPT_DIR}/04b-sdlc-sync-SKILL-TEMPLATE.md" \
  "${TARGET_DIR}/.claude/skills/sdlc-sync/SKILL.md"

# Diagnostic skill — squelette, Claude Code le complète
cat > "${TARGET_DIR}/.claude/skills/diagnostic/SKILL.md" << DIAG_SKILL
# diagnostic — SKILL
<!-- À compléter par Claude Code lors du Sprint 1 -->
<!-- Lister ici les commandes de diagnostic spécifiques au système -->

Procédure de diagnostic pour bugs et comportements inattendus.

## Commandes de base

\`\`\`bash
# [→ ADAPTER] Commandes d'état du système
# [→ ADAPTER] Commandes de vérification des dépendances
# [→ ADAPTER] Commandes de lecture des logs
\`\`\`

## Procédure

1. Reproduire le comportement inattendu
2. Lire les logs (commandes ci-dessus)
3. Isoler le module concerné
4. Formuler hypothèse + commande de validation
5. Si résolu → archiver dans \`doc/DIAGNOSTIC_CMDS.md\`
6. Si non résolu → escalader avec contexte complet
DIAG_SKILL
echo "  ✅ .claude/skills/diagnostic/SKILL.md (squelette — à compléter Sprint 1)"
echo ""

# ─── ÉTAPE 6 : HOOKS ─────────────────────────────────────────────────────────

echo "📄 Hooks Claude Code..."

# Extraire le script bash du template (section §1)
# On copie le template hooks complet pour que Claude Code décide des sections
deploy_copy "${SCRIPT_DIR}/08-hooks-TEMPLATE.md" \
  "${TARGET_DIR}/.claude/hooks/hooks-reference.md"

# Créer un pre-tool-bash.sh minimal avec seulement les blocages universels
cat > "${TARGET_DIR}/.claude/hooks/pre-tool-bash.sh" << 'HOOK'
#!/bin/bash
# Hook pre-tool-bash — [À ADAPTER : remplacer par le nom du projet]
# Version : 1.0.0 | [date bootstrap]
# Sections activées : blocages universels uniquement
# Pour activer d'autres sections → lire hooks-reference.md · documenter dans doc/DECISIONS.md §D-HOOK-XX
#
# Protocole : exit 0 = autoriser · exit 1 = bloquer silencieux · exit 2 = bloquer avec message

set -euo pipefail

INPUT=$(cat)
CMD=$(echo "$INPUT" | python3 -c "
import sys, json
data = json.load(sys.stdin)
print(data.get('input', {}).get('command', ''))
" 2>/dev/null || echo "")

# ─── BLOCAGES UNIVERSELS ──────────────────────────────────────────────────────

if echo "$CMD" | grep -qE 'git\s+push.*(--force|-f)\s'; then
  echo "BLOQUÉ : git push --force interdit." >&2
  echo "Utiliser git revert pour annuler un commit déjà poussé." >&2
  exit 2
fi

if echo "$CMD" | grep -qE 'rm\s+-rf\s+(/|\./)?(\.git|src|data|db|scripts)\b'; then
  echo "BLOQUÉ : rm -rf sur dossier critique détecté." >&2
  exit 2
fi

# ─── AVERTISSEMENTS ───────────────────────────────────────────────────────────

if echo "$CMD" | grep -qE '^sudo\s+' && \
   ! echo "$CMD" | grep -qE 'sudo\s+(apt|snap|systemctl)'; then
  echo "AVERTISSEMENT : commande sudo hors apt/snap détectée." >&2
fi

exit 0
HOOK

chmod +x "${TARGET_DIR}/.claude/hooks/pre-tool-bash.sh"
echo "  ✅ .claude/hooks/pre-tool-bash.sh (chmod +x · blocages universels)"

# settings.json
cat > "${TARGET_DIR}/.claude/settings.json" << 'SETTINGS'
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
SETTINGS
echo "  ✅ .claude/settings.json"

# settings.local.json vide
cat > "${TARGET_DIR}/.claude/settings.local.json" << 'LOCAL'
{
  "permissions": {
    "allow": [
    ]
  }
}
LOCAL
echo "  ✅ .claude/settings.local.json"
echo ""

# ─── ÉTAPE 7 : VÉRIFICATIONS ─────────────────────────────────────────────────

echo "🔍 Vérifications..."

# Placeholders résiduels
RESIDUAL=$(grep -rl "\[→ ADAPTER\]\|\[Nom du projet\]" \
  "${TARGET_DIR}/STANDARDS.md" \
  "${TARGET_DIR}/doc/ROADMAP.md" \
  2>/dev/null || true)

if [ -n "${RESIDUAL}" ]; then
  echo "  ⚠️  Placeholders résiduels détectés (à compléter par Claude Code) :"
  echo "${RESIDUAL}" | sed 's/^/     /'
else
  echo "  ✅ Aucun placeholder résiduel dans les fichiers clés"
fi

# Smoke test hook
SMOKE=$(echo '{"tool":"bash","input":{"command":"echo ok"}}' \
  | bash "${TARGET_DIR}/.claude/hooks/pre-tool-bash.sh" 2>/dev/null; echo $?)
if [ "${SMOKE}" = "0" ]; then
  echo "  ✅ Hook smoke test : exit 0"
else
  echo "  ❌ Hook smoke test : exit ${SMOKE} — vérifier le script"
fi

# Marqueur version
if grep -q "SDLC version : ${SDLC_VERSION}" "${TARGET_DIR}/Claude.md"; then
  echo "  ✅ Marqueur SDLC version présent"
else
  echo "  ⚠️  Marqueur SDLC version non trouvé dans Claude.md"
fi

echo ""

# ─── RÉSUMÉ ──────────────────────────────────────────────────────────────────

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Bootstrap mécanique terminé"
echo ""
echo "ÉTAPE SUIVANTE — ouvrir Claude Code dans ce repo et demander :"
echo ""
echo "  Le bootstrap mécanique est fait (SDLC ${SDLC_VERSION})."
echo "  Complète la gouvernance :"
echo "  - §Rôle dans Claude.md"
echo "  - §Limites bash dans Claude.md"
echo "  - §Démarrage §2 : commandes d'état du système"
echo "  - specs/SPEC.md : structure du domaine"
echo "  - .claude/skills/diagnostic/SKILL.md : commandes de diagnostic"
echo "  - Sections [ACTIVER si…] dans .claude/hooks/hooks-reference.md"
echo "    → décider lesquelles activer dans pre-tool-bash.sh"
echo "    → documenter chaque choix dans doc/DECISIONS.md §D-HOOK-XX"
echo ""
echo "  Grep de validation final :"
echo "  grep '\[→ ADAPTER\]' Claude.md STANDARDS.md .claude/hooks/pre-tool-bash.sh"
echo "  → zéro résultat attendu avant le commit."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
