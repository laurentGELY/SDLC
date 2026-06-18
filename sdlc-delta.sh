#!/bin/bash
# sdlc-delta.sh — Pré-calcul delta SDLC · Co-construction PDR dans Claude.ai
# Version : 1.0.0 · 2026-06-14
# Usage   : bash ~/Downloads/Sandbox/SDLC/sdlc-delta.sh <chemin-projet>
# Sortie  : bloc structuré à coller dans Claude.ai pour co-construire le PDR SDLC-Sync
#
# Décision M-PROC-25 — emplacament toolkit : ~/Downloads/Sandbox/SDLC/

set -euo pipefail

SDLC_SRC="$HOME/Downloads/Sandbox/SDLC"
PROJECT_DIR="${1:-.}"
DATE=$(date +%Y-%m-%d)

PROJECT_DIR=$(cd "$PROJECT_DIR" && pwd)
PROJECT_NAME=$(basename "$PROJECT_DIR")

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 DELTA SDLC — $PROJECT_NAME · $DATE"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# ── 1. Versions ───────────────────────────────────────────────────
echo ""
echo "VERSIONS"

CURRENT_VERSION=$(grep -h "SDLC version" \
    "$PROJECT_DIR/Claude.md" \
    "$PROJECT_DIR/STANDARDS.md" 2>/dev/null \
  | grep -oP 'v[0-9]+\.[0-9]+' | head -1 \
  || echo "ABSENT")

TARGET_VERSION=$(grep "^\*\*Version courante" "$SDLC_SRC/README.md" 2>/dev/null \
  | grep -oP 'v[0-9]+\.[0-9]+' | head -1 \
  || echo "INCONNU")

echo "  Projet   : $CURRENT_VERSION"
echo "  Toolkit  : $TARGET_VERSION"
echo "  Toolkit  : $SDLC_SRC"

if [ "$CURRENT_VERSION" = "$TARGET_VERSION" ]; then
  echo "  → ✅ Déjà à jour — aucun PDR nécessaire"
  exit 0
fi
echo "  → Delta  : $CURRENT_VERSION → $TARGET_VERSION"

# ── 2. Inventaire fichiers de gouvernance ─────────────────────────
echo ""
echo "INVENTAIRE FICHIERS DE GOUVERNANCE"

check_file() {
  local label="$1"; local path="$2"
  if [ -f "$path" ]; then
    echo "  ✅ $label"
  else
    echo "  ❌ $label  ← ABSENT (à créer)"
  fi
}

check_file "Claude.md"                              "$PROJECT_DIR/Claude.md"
check_file "STANDARDS.md"                           "$PROJECT_DIR/STANDARDS.md"
check_file "CHANGELOG.md"                           "$PROJECT_DIR/CHANGELOG.md"
check_file "doc/ROADMAP.md"                         "$PROJECT_DIR/doc/ROADMAP.md"
check_file "doc/DECISIONS.md"                       "$PROJECT_DIR/doc/DECISIONS.md"
check_file "doc/LESSONS_LEARNED.md"                "$PROJECT_DIR/doc/LESSONS_LEARNED.md"
check_file "doc/DIAGNOSTIC_CMDS.md"                "$PROJECT_DIR/doc/DIAGNOSTIC_CMDS.md"
check_file "doc/SESSION_BRIDGE.md"                 "$PROJECT_DIR/doc/SESSION_BRIDGE.md"
check_file "doc/CLAUDE_PROJECT.md"                 "$PROJECT_DIR/doc/CLAUDE_PROJECT.md"
check_file ".claude/skills/wrap-up/SKILL.md"       "$PROJECT_DIR/.claude/skills/wrap-up/SKILL.md"
check_file ".claude/skills/retrospective/SKILL.md"  "$PROJECT_DIR/.claude/skills/retrospective/SKILL.md"
check_file ".claude/skills/sdlc-sync/SKILL.md"     "$PROJECT_DIR/.claude/skills/sdlc-sync/SKILL.md"
check_file ".claude/hooks/pre-tool-bash.sh"         "$PROJECT_DIR/.claude/hooks/pre-tool-bash.sh"
check_file ".claude/settings.json"                 "$PROJECT_DIR/.claude/settings.json"
check_file "specs/sprint-template.md"              "$PROJECT_DIR/specs/sprint-template.md"
check_file "specs/SPEC.md"                         "$PROJECT_DIR/specs/SPEC.md"

if [ -d "$PROJECT_DIR/specs/Sprints" ]; then
  N=$(ls "$PROJECT_DIR/specs/Sprints/" 2>/dev/null | wc -l)
  echo "  ✅ specs/Sprints/  ($N sprint(s) archivés)"
else
  echo "  ❌ specs/Sprints/  ← ABSENT (à créer)"
fi

# ── 3. État git ───────────────────────────────────────────────────
echo ""
echo "ÉTAT GIT"
cd "$PROJECT_DIR"
git log --oneline -5 2>/dev/null | sed 's/^/  /' || echo "  (pas de repo git)"
GIT_DIRTY=$(git status --porcelain 2>/dev/null || echo "")
if [ -z "$GIT_DIRTY" ]; then
  echo "  → ✅ Repo propre"
else
  echo "  → ⚠️  Modifications non commitées — résoudre avant le sync"
  git status --short 2>/dev/null | sed 's/^/    /'
fi

# ── 4. Sections de Claude.md (tuning local à préserver) ──────────
echo ""
echo "SECTIONS Claude.md  (tuning local à préserver)"
if [ -f "$PROJECT_DIR/Claude.md" ]; then
  grep -n "^## " "$PROJECT_DIR/Claude.md" | sed 's/^/  /'
else
  echo "  ❌ Fichier absent"
fi

# ── 5. Templates SDLC source ──────────────────────────────────────
echo ""
echo "TEMPLATES SOURCE  ($SDLC_SRC)"
for f in \
  01-Claude-md-TEMPLATE.md \
  02-STANDARDS-TEMPLATE.md \
  03-wrap-up-SKILL-TEMPLATE.md \
  04-sprint-PDR-TEMPLATE.md \
  04b-sdlc-sync-SKILL-TEMPLATE.md \
  09-retrospective-SKILL-TEMPLATE.md; do
  if [ -f "$SDLC_SRC/$f" ]; then
    VER=$(grep -oP 'SDLC v[0-9]+\.[0-9]+' "$SDLC_SRC/$f" 2>/dev/null | head -1 || echo "?")
    echo "  ✅ $f  ($VER)"
  else
    echo "  ❌ $f  ← MANQUANT"
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "→ Coller ce bloc dans Claude.ai avec le message :"
echo "  'Construis le PDR SDLC-Sync pour [nom-projet]'"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
