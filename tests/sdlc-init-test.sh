#!/bin/bash
# sdlc-init-test.sh — Test de bout en bout du bootstrap (sdlc-init.sh)
# Usage : bash tests/sdlc-init-test.sh
# Sprint ELAG-1b · specs/Sprints/sprint-ELAG-1b-fix-bootstrap.md · M-ARCH-10
#
# Bootstrappe un projet jetable (mktemp -d + git init) et vérifie, par
# comportement, que le projet reçoit les mécanismes que la prose du modèle
# promet : CLAUDE.md chargeable, hook qui bloque toutes les poussées forcées
# et laisse passer les commandes légitimes, pre-compact.sh actif, .gitignore,
# skills avec frontmatter, gabarits datés par placeholder, marqueur de version
# courant, aucun $<chiffre> dans un skill (remplacé par les arguments du skill).
#
# Le dépôt réel n'est jamais modifié (M-PROC-30) : tout vit sous mktemp -d.
# Les poussées forcées sont construites en deux morceaux : le hook vivant de ce
# dépôt bloquerait toute commande Bash qui les contient littéralement.
# Codes de sortie : 0 = tous les cas passent · 1 = ≥ 1 cas en échec.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEST_ROOT="$(mktemp -d)"
cleanup() { rm -rf "$TEST_ROOT"; }
trap cleanup EXIT

FAILURES=0
CASES=0
pass() { CASES=$((CASES + 1)); echo "  [PASS] $1"; }
fail() { CASES=$((CASES + 1)); FAILURES=$((FAILURES + 1)); echo "  [FAIL] $1"; }
check() { # check "<libellé>" <commande…> — PASS si la commande réussit
  local label="$1"; shift
  if "$@" >/dev/null 2>&1; then pass "$label"; else fail "$label"; fi
}

# ─── OUTILLAGE ───────────────────────────────────────────────────────────────

# Copie du dépôt (arbre de travail) sans .git/ ni exemples/.
make_fixture() {
  local dir="$TEST_ROOT/$1"
  mkdir -p "$dir"
  ( cd "$REPO_ROOT" && tar --exclude=./.git --exclude=./exemples -cf - . ) | ( cd "$dir" && tar -xf - )
  echo "$dir"
}

# bootstrap <dépôt SDLC> <nom> : projet jetable ; sortie dans $BOOT_OUT, code dans $BOOT_RC.
bootstrap() {
  local sdlc="$1" target="$TEST_ROOT/$2"
  mkdir -p "$target"
  ( cd "$target" && git init -q && git -c user.email=t@t -c user.name=t commit -q --allow-empty -m init ) >/dev/null 2>&1
  BOOT_OUT=$( cd "$target" && bash "$sdlc/sdlc-init.sh" "Test" 2>&1 )
  BOOT_RC=$?
  echo "$target" > "$TEST_ROOT/.last"
}

# hook_rc <hook> <commande> : code de sortie du hook sur le schéma réel PreToolUse.
hook_rc() {
  python3 -c 'import json,sys; print(json.dumps({"hook_event_name":"PreToolUse","tool_name":"Bash","tool_input":{"command":sys.argv[1]}}))' "$2" \
    | bash "$1" >/dev/null 2>&1
  echo $?
}

# Aucun $<chiffre> dans les skills d'un répertoire (Claude Code les remplace par les arguments).
no_digit_args() { ! grep -nE '\$[0-9]' "$1"/*/SKILL.md; }

P="git pu""sh"; F="--for""ce"
BLOCKED=(
  "$P $F"
  "$P origin main $F"
  "$P $F origin main"
  "$P -f origin main"
  "$P origin main -f"
  "$P ${F}-with-lease origin main"
  "$P origin +main"
)
ALLOWED=(
  "$P origin main"
  "$P origin main && git worktree remove $F ../x"
  "$P origin main; rm -f origin.txt"
  "echo ok"
)

hook_cases() { # hook_cases <hook> <étiquette>
  local h="$1" tag="$2" c rc
  for c in "${BLOCKED[@]}"; do
    rc=$(hook_rc "$h" "$c")
    if [ "$rc" = "2" ]; then pass "$tag bloque : $c"; else fail "$tag bloque : $c (exit=$rc)"; fi
  done
  for c in "${ALLOWED[@]}"; do
    rc=$(hook_rc "$h" "$c")
    if [ "$rc" = "0" ]; then pass "$tag laisse passer : $c"; else fail "$tag laisse passer : $c (exit=$rc)"; fi
  done
}

# ─── BOOTSTRAP DE RÉFÉRENCE ──────────────────────────────────────────────────

echo "🔍 sdlc-init-test — bootstrap jetable"
bootstrap "$REPO_ROOT" ref
B="$TEST_ROOT/ref"
if [ "$BOOT_RC" -eq 0 ]; then pass "sdlc-init.sh sort en 0"; else fail "sdlc-init.sh sort en 0 (exit=$BOOT_RC)"; echo "$BOOT_OUT" | tail -5 | sed 's/^/        /'; fi

# ─── FICHIERS DU BOOTSTRAP ───────────────────────────────────────────────────

echo ""
echo "Fichiers"
check "CLAUDE.md présent" test -f "$B/CLAUDE.md"
check "Claude.md absent" test ! -e "$B/Claude.md"
check "CLAUDE.md seul dans la liste des fichiers" bash -c "ls '$B' | grep -ix 'claude.md' | grep -qx 'CLAUDE.md' && [ \$(ls '$B' | grep -icx 'claude.md') -eq 1 ]"
for line in ".env" ".claude/sprint-memory.md" ".claude/settings.local.json"; do
  check ".gitignore contient $line" grep -qxF "$line" "$B/.gitignore"
done
VERSION=$(grep -m1 -oE 'Version courante : [^ *]+' "$REPO_ROOT/README.md" | sed 's/Version courante : //')
check "marqueur de version courant ($VERSION) dans CLAUDE.md" grep -qF "SDLC version : $VERSION " "$B/CLAUDE.md"
check "marqueur de version courant ($VERSION) dans STANDARDS.md" grep -qF "SDLC version : $VERSION " "$B/STANDARDS.md"
check "aucun avertissement « Marqueur SDLC version non trouvé »" bash -c "! grep -qF 'Marqueur SDLC version non trouvé' <<<\"\$1\"" _ "$BOOT_OUT"
DATES=$(grep -cE 'JJ/MM/AAAA|AAAA-MM-JJ' "$B/.claude/skills/wrap-up/SKILL.md" 2>/dev/null)
if [ "${DATES:-0}" -eq 3 ]; then pass "3 placeholders de date intacts dans les gabarits du wrap-up"; else fail "3 placeholders de date intacts dans les gabarits du wrap-up (trouvés : ${DATES:-0})"; fi

# ─── HOOKS ───────────────────────────────────────────────────────────────────

echo ""
echo "Hook pre-tool-bash livré"
hook_cases "$B/.claude/hooks/pre-tool-bash.sh" "livré"

echo ""
echo "Hook pre-tool-bash vivant (dépôt SDLC)"
hook_cases "$REPO_ROOT/.claude/hooks/pre-tool-bash.sh" "vivant"

echo ""
echo "Source unique et pre-compact"
check "sdlc-init.sh ne lit plus le champ input" bash -c "! grep -qF \"get('input'\" '$REPO_ROOT/sdlc-init.sh'"
check "sdlc-init.sh sans copie inline du hook (heredoc HOOK)" bash -c "! grep -qE \"<< *'HOOK'\" '$REPO_ROOT/sdlc-init.sh'"
check "pre-compact.sh présent et exécutable" test -x "$B/.claude/hooks/pre-compact.sh"
PC_RC=$(echo '{"hook_event_name":"PreCompact","compaction_reason":"manual","context_used_tokens":1,"context_limit_tokens":2,"estimated_tokens_freed":1,"transcript_path":"-"}' \
  | ( cd "$B" && bash .claude/hooks/pre-compact.sh ) >/dev/null 2>&1; echo $?)
if [ "$PC_RC" = "0" ]; then pass "pre-compact.sh sort en 0 sur un JSON PreCompact"; else fail "pre-compact.sh sort en 0 sur un JSON PreCompact (exit=$PC_RC)"; fi
check "settings.json valide avec PreCompact manual et auto" python3 -c "
import json,sys
h=json.load(open(sys.argv[1]))['hooks']
m={e.get('matcher') for e in h['PreCompact']}
assert {'manual','auto'} <= m
" "$B/.claude/settings.json"

# Smoke test : un hook inopérant dans 08 doit faire échouer le bootstrap.
FX=$(make_fixture smoke)
sed -i "s/data.get('tool_input', {}).get('command', '')/data.get('input', {}).get('command', '')/" "$FX/08-hooks-TEMPLATE.md"
bootstrap "$FX" smoke-boot
if [ "$BOOT_RC" -ne 0 ] && grep -qF "❌ Hook" <<<"$BOOT_OUT"; then
  pass "smoke test : hook inopérant → ❌ et sortie en erreur"
else
  fail "smoke test : hook inopérant → ❌ et sortie en erreur (exit=$BOOT_RC)"
fi

# ─── SKILLS ──────────────────────────────────────────────────────────────────

echo ""
echo "Skills"
for s in wrap-up retrospective sdlc-sync diagnostic; do
  f="$B/.claude/skills/$s/SKILL.md"
  check "$s : frontmatter en ligne 1" bash -c "[ \"\$(head -1 '$f')\" = '---' ]"
  check "$s : name et description non vides" python3 -c "
import sys,re
t=open(sys.argv[1]).read().split('\n')
assert t[0]=='---'
end=t.index('---',1)
fm='\n'.join(t[1:end])
assert re.search(r'^name: *\S', fm, re.M)
assert re.search(r'^description: *\S', fm, re.M)
" "$f"
done
check "aucun \$<chiffre> dans les skills livrés" no_digit_args "$B/.claude/skills"
mkdir -p "$TEST_ROOT/digit/demo"
printf -- '---\nname: demo\ndescription: x\n---\n```bash\nawk %s\n```\n' "'{print \$2}'" > "$TEST_ROOT/digit/demo/SKILL.md"
check "garde \$<chiffre> rouge sur une fixture avec awk '{print \$2}'" bash -c "! ( $(declare -f no_digit_args); no_digit_args '$TEST_ROOT/digit' )"

# ─── BILAN ───────────────────────────────────────────────────────────────────

echo ""
echo "──────────────────────────────────────"
echo "$((CASES - FAILURES))/$CASES cas OK"
echo "──────────────────────────────────────"
[ "$FAILURES" -eq 0 ]
