#!/bin/bash
# sdlc-project-check.sh — Génère/met à jour doc/CLAUDE_PROJECT.md
# Usage : bash /chemin/vers/sdlc-toolkit/sdlc-project-check.sh "Nom du projet Claude.ai"
# Prérequis : répertoire courant = racine du projet cible

set -e

if [ $# -lt 1 ]; then
  echo "Usage : bash sdlc-project-check.sh \"Nom du projet\""
  exit 1
fi

PROJECT_NAME="$1"
DATE_TODAY=$(date +%d/%m/%Y)
TARGET="doc/CLAUDE_PROJECT.md"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 sdlc-project-check — ${PROJECT_NAME} — ${DATE_TODAY}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ─── INVENTAIRE FICHIERS DE GOUVERNANCE ──────────────────────────────────────

echo ""
echo "📋 Fichiers de gouvernance détectés :"
find . -maxdepth 3 -name "*.md" ! -path './.git/*' | sort | sed 's|^\./||'

# ─── DELTA vs CLAUDE_PROJECT.md EXISTANT ─────────────────────────────────────

if [ -f "$TARGET" ]; then
  echo ""
  echo "⚡ Delta vs ${TARGET} existant :"
  find . -maxdepth 3 -name "*.md" ! -path './.git/*' | sort | sed 's|^\./||' \
    | while IFS= read -r f; do
        grep -qF "$(basename "$f")" "$TARGET" \
          || echo "   ⚠️  $f — absent de CLAUDE_PROJECT.md"
      done
  echo "   (silence = aucun delta)"
fi

# ─── AVIS CLAUDE ─────────────────────────────────────────────────────────────

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🤖 AVIS CLAUDE REQUIS — compléter ${TARGET} :"
echo "  • Description du projet (≤ 3 phrases — lire Claude.md §Rôle + SPEC.md §Vue)"
echo "  • Fichiers recommandés pour Claude.ai + justification 1 ligne chacun"
echo "  • Fichiers à exclure + raison (éphémère / trop volumineux / hors contexte)"
echo "  • Gaps : placeholders résiduels, sections manquantes, incohérences"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ─── GÉNÉRATION doc/CLAUDE_PROJECT.md ────────────────────────────────────────

mkdir -p doc
cat > "$TARGET" << HEREDOC
# CLAUDE_PROJECT — ${PROJECT_NAME}
<!-- Versionné · Mis à jour au bootstrap et à chaque sdlc-sync -->
<!-- Source de vérité pour reconstruire le projet Claude.ai si supprimé -->

## Description du projet Claude.ai
[À REMPLIR — ≤ 3 phrases · généré par sdlc-project-check.sh, validé par l'humain]

## Fichiers synchronisés
| Fichier repo | Rôle dans Claude.ai | Synchronisé |
|-------------|---------------------|-------------|
| Claude.md | Instructions permanentes | ✓ |
| [À REMPLIR] | [À REMPLIR] | ☐ |

## Fichiers exclus (et raison)
| Fichier | Raison d'exclusion |
|---------|-------------------|
| doc/SESSION_BRIDGE.md | Contenu éphémère — inutile dans Claude.ai |
| [À REMPLIR] | [À REMPLIR] |

## Dernière vérification : ${DATE_TODAY} · sdlc-project-check.sh
HEREDOC

echo "✅ ${TARGET} généré — valider l'avis ci-dessus, compléter le fichier, puis commiter."
echo ""
