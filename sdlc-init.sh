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
# Source de vérité : README.md (déjà contrôlé ↔ CHANGELOG.md par sdlc-validate.sh C1)
SDLC_VERSION="$(grep -m1 -oE 'Version courante : [^ *]+' "${SCRIPT_DIR}/README.md" | sed 's/Version courante : //')"
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

if [ -e "${TARGET_DIR}/CLAUDE.md" ] || [ -e "${TARGET_DIR}/Claude.md" ]; then
  echo "⚠️  CLAUDE.md (ou l'ancien Claude.md) existe déjà dans ce repo."
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
    -e "s#\[Nom du projet\]#${PROJECT_NAME}#g" \
    -e "s#JJ/MM/AAAA#${DATE_TODAY}#g" \
    -e "s#AAAA-MM-JJ#${DATE_ISO}#g" \
    -e "s#<!-- SDLC version : [^ ]* · aligné#<!-- SDLC version : ${SDLC_VERSION} · aligné#" \
    "${src}" > "${dst}"
  echo "  ✅ ${dst}"
}

# Comme deploy_template, mais ne remplace que le nom du projet : les placeholders de
# date des gabarits (ex. entrées LESSONS/CHANGELOG du skill wrap-up) restent des
# placeholders, à remplir à chaque usage (ELAG-1b, M-ARCH-10).
deploy_named() {
  local src="$1"
  local dst="$2"
  local dir
  dir="$(dirname "${dst}")"
  mkdir -p "${dir}"
  sed -e "s#\[Nom du projet\]#${PROJECT_NAME}#g" "${src}" > "${dst}"
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

# ─── HELPER : extraire un hook de 08-hooks-TEMPLATE.md ───────────────────────
# Source unique des hooks livrés (ELAG-1b, M-ARCH-10) : le bloc bash compris entre
# <!-- hook:<nom>:début --> et <!-- hook:<nom>:fin -->. Plus de copie inline à resynchroniser.

extract_hook() {
  local name="$1"
  local dst="$2"
  local src="${SCRIPT_DIR}/08-hooks-TEMPLATE.md"
  if ! grep -qF "<!-- hook:${name}:début -->" "${src}" || ! grep -qF "<!-- hook:${name}:fin -->" "${src}"; then
    echo "  ❌ Marqueurs hook:${name} absents de 08-hooks-TEMPLATE.md — bootstrap interrompu" >&2
    exit 1
  fi
  awk -v b="<!-- hook:${name}:début -->" -v e="<!-- hook:${name}:fin -->" \
    '$0 == b { f = 1; next } $0 == e { f = 0 } f && !/^```/' "${src}" \
    | sed -e "s#\[Nom du projet\]#${PROJECT_NAME}#g" -e "s#\[AAAA-MM-JJ\]#${DATE_ISO}#g" > "${dst}"
  chmod +x "${dst}"
  echo "  ✅ ${dst} (extrait de 08-hooks-TEMPLATE.md)"
}

# ─── ÉTAPE 1 : STRUCTURE DES DOSSIERS ────────────────────────────────────────

echo "📁 Création de la structure..."
mkdir -p \
  "${TARGET_DIR}/docs" \
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
deploy_template "${SCRIPT_DIR}/01-Claude-md-TEMPLATE.md"  "${TARGET_DIR}/CLAUDE.md"
deploy_template "${SCRIPT_DIR}/02-STANDARDS-TEMPLATE.md"  "${TARGET_DIR}/STANDARDS.md"

# CHANGELOG from scratch
cat > "${TARGET_DIR}/CHANGELOG.md" << CHANGELOG
<!-- VERSION : 1.0 | ${DATE_TODAY} | ${PROJECT_NAME} -->

# CHANGELOG

Toutes les modifications notables de ce projet sont documentées ici.
Format : Semantic Versioning adapté aux sprints.

---

## [1.0] — ${DATE_ISO} · Sprint 0 · Bootstrap SDLC

- **\`CLAUDE.md\` v1.0** : instructions permanentes Claude Code — à compléter (§Rôle · §Limites bash)
- **\`STANDARDS.md\` v1.0** : Definition of Done · types de sprint · niveaux de test
- **\`specs/sprint-template.md\`** : template PDR générique
- **\`.claude/skills/wrap-up/SKILL.md\` v1.0** : procédure clôture sprint
- **\`.claude/skills/sdlc-sync/SKILL.md\` v1.0** : skill alignement modèle SDLC
- **\`.claude/skills/retrospective/SKILL.md\` v1.0** : procédure rétrospective
- **\`.claude/hooks/pre-tool-bash.sh\` v1.0** : hook PreToolUse Bash
- **\`.claude/settings.json\`** : configuration hooks Claude Code
- **\`docs/ROADMAP.md\` v1.0** : structure Now/Next/Later
- **\`docs/DECISIONS.md\` v1.0** : registre décisions architecturales
- **\`docs/LESSONS_LEARNED.md\`** : registre apprentissages
- **\`docs/DIAGNOSTIC_CMDS.md\`** : archive commandes diagnostic
- **\`specs/SPEC.md\`** : structure architecture — à compléter par Claude Code
- **Tests** : N/A (bootstrap doc)
CHANGELOG
echo "  ✅ CHANGELOG.md"
echo ""

# ─── ÉTAPE 3 : DOSSIER docs/ ──────────────────────────────────────────────────

echo "📄 Dossier docs/..."

# ROADMAP depuis template
deploy_template "${SCRIPT_DIR}/05-ROADMAP-TEMPLATE.md" "${TARGET_DIR}/docs/ROADMAP.md"

# DECISIONS from scratch
cat > "${TARGET_DIR}/docs/DECISIONS.md" << DECISIONS
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
echo "  ✅ docs/DECISIONS.md"

# LESSONS_LEARNED from scratch
cat > "${TARGET_DIR}/docs/LESSONS_LEARNED.md" << LESSONS
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
echo "  ✅ docs/LESSONS_LEARNED.md"

# DIAGNOSTIC_CMDS from scratch
cat > "${TARGET_DIR}/docs/DIAGNOSTIC_CMDS.md" << DIAG
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
echo "  ✅ docs/DIAGNOSTIC_CMDS.md"
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
deploy_named "${SCRIPT_DIR}/03-wrap-up-SKILL-TEMPLATE.md" \
  "${TARGET_DIR}/.claude/skills/wrap-up/SKILL.md"
deploy_copy "${SCRIPT_DIR}/09-retrospective-SKILL-TEMPLATE.md" \
  "${TARGET_DIR}/.claude/skills/retrospective/SKILL.md"
deploy_copy "${SCRIPT_DIR}/04b-sdlc-sync-SKILL-TEMPLATE.md" \
  "${TARGET_DIR}/.claude/skills/sdlc-sync/SKILL.md"

# Diagnostic skill — squelette, Claude Code le complète
cat > "${TARGET_DIR}/.claude/skills/diagnostic/SKILL.md" << DIAG_SKILL
---
name: diagnostic
description: Diagnostic d'un bug, crash, blocage ou comportement anormal. Utiliser quand l'utilisateur signale une erreur ou une régression, ou demande pourquoi ça ne marche pas.
---
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
5. Si résolu → archiver dans \`docs/DIAGNOSTIC_CMDS.md\`
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

# Hooks actifs : blocages universels (pre-tool-bash) et checkpoint de compaction (pre-compact)
extract_hook pre-tool-bash "${TARGET_DIR}/.claude/hooks/pre-tool-bash.sh"
extract_hook pre-compact "${TARGET_DIR}/.claude/hooks/pre-compact.sh"

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
    ],
    "PreCompact": [
      {
        "matcher": "manual",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/pre-compact.sh"
          }
        ]
      },
      {
        "matcher": "auto",
        "hooks": [
          {
            "type": "command",
            "command": ".claude/hooks/pre-compact.sh"
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

# .gitignore — créé, ou complété sans doublon s'il existe (ELAG-1b, M-ARCH-10)
for entry in .env .claude/sprint-memory.md .claude/settings.local.json; do
  grep -qxF "${entry}" "${TARGET_DIR}/.gitignore" 2>/dev/null || echo "${entry}" >> "${TARGET_DIR}/.gitignore"
done
echo "  ✅ .gitignore (.env · .claude/sprint-memory.md · .claude/settings.local.json)"
echo ""

# ─── ÉTAPE 7 : VÉRIFICATIONS ─────────────────────────────────────────────────

echo "🔍 Vérifications..."

# Placeholders résiduels
RESIDUAL=$(grep -rl "\[→ ADAPTER\]\|\[Nom du projet\]" \
  "${TARGET_DIR}/STANDARDS.md" \
  "${TARGET_DIR}/docs/ROADMAP.md" \
  2>/dev/null || true)

if [ -n "${RESIDUAL}" ]; then
  echo "  ⚠️  Placeholders résiduels détectés (à compléter par Claude Code) :"
  echo "${RESIDUAL}" | sed 's/^/     /'
else
  echo "  ✅ Aucun placeholder résiduel dans les fichiers clés"
fi

# Smoke test hook — schéma réel PreToolUse (tool_input), un cas autorisé et un cas bloqué.
# Un hook qui lit une clé absente laisse tout passer en silence (M-HOOKS-05) :
# seul le cas bloqué le révèle.
INIT_ERRORS=0
SMOKE_OK=$(echo '{"hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"echo ok"}}' \
  | bash "${TARGET_DIR}/.claude/hooks/pre-tool-bash.sh" 2>/dev/null; echo $?)
SMOKE_KO=$(echo '{"hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":"git push --force origin main"}}' \
  | bash "${TARGET_DIR}/.claude/hooks/pre-tool-bash.sh" 2>/dev/null; echo $?)
if [ "${SMOKE_OK}" = "0" ] && [ "${SMOKE_KO}" = "2" ]; then
  echo "  ✅ Hook smoke test : commande autorisée → exit 0 · poussée forcée → exit 2"
else
  echo "  ❌ Hook smoke test : commande autorisée → exit ${SMOKE_OK} (0 attendu) · poussée forcée → exit ${SMOKE_KO} (2 attendu) — hook livré inopérant"
  INIT_ERRORS=$((INIT_ERRORS + 1))
fi

# Marqueur version
if grep -q "SDLC version : ${SDLC_VERSION}" "${TARGET_DIR}/CLAUDE.md"; then
  echo "  ✅ Marqueur SDLC version présent"
else
  echo "  ⚠️  Marqueur SDLC version non trouvé dans CLAUDE.md"
fi

echo ""

if [ "${INIT_ERRORS}" -gt 0 ]; then
  echo "❌ Bootstrap incomplet : ${INIT_ERRORS} mécanisme(s) livré(s) inopérant(s) — voir les vérifications ci-dessus."
  exit 1
fi

# ─── RÉSUMÉ ──────────────────────────────────────────────────────────────────

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Bootstrap mécanique terminé"
echo ""
echo "ÉTAPE SUIVANTE — ouvrir Claude Code dans ce repo et demander :"
echo ""
echo "  Le bootstrap mécanique est fait (SDLC ${SDLC_VERSION})."
echo "  Complète la gouvernance :"
echo "  - §Rôle dans CLAUDE.md"
echo "  - §Limites bash dans CLAUDE.md"
echo "  - §Démarrage §2 : commandes d'état du système"
echo "  - specs/SPEC.md : structure du domaine"
echo "  - .claude/skills/diagnostic/SKILL.md : commandes de diagnostic"
echo "  - Sections [ACTIVER si…] dans .claude/hooks/hooks-reference.md"
echo "    → décider lesquelles activer dans pre-tool-bash.sh"
echo "    → documenter chaque choix dans docs/DECISIONS.md §D-HOOK-XX"
echo ""
echo "  Grep de validation final :"
echo "  grep '\[→ ADAPTER\]' CLAUDE.md STANDARDS.md .claude/hooks/pre-tool-bash.sh"
echo "  → zéro résultat attendu avant le commit."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
