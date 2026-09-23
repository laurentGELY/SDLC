#!/bin/bash
# sdlc-validate-test.sh — Suite de tests de sdlc-validate.sh
# Usage : bash tests/sdlc-validate-test.sh
# Sprint ECO-7 · specs/Sprints/sprint-ECO-7-durcissement-validate.md
#
# Chaque cas copie le dépôt dans un répertoire temporaire, y injecte un défaut
# ciblé, lance le validateur sur la copie (SDLC_VALIDATE_ROOT) et vérifie que le
# BON contrôle a parlé : exit 1 ET ligne « ❌ C<n> · » dans la sortie. Un exit 1
# seul ne le prouve pas — dix contrôles tournent sans s'arrêter au premier échec.
# Le dépôt réel n'est jamais modifié (M-PROC-30) : tout vit sous mktemp -d.
#
# Patron repris de obra/superpowers/tests/ (mktemp -d + trap + pass/fail).
# Codes de sortie : 0 = tous les cas passent · 1 = ≥ 1 cas en échec.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VALIDATOR="$REPO_ROOT/sdlc-validate.sh"
TEST_ROOT="$(mktemp -d)"
cleanup() { rm -rf "$TEST_ROOT"; }
trap cleanup EXIT

FAILURES=0
CASES=0
pass() { CASES=$((CASES + 1)); echo "  [PASS] $1"; }
fail() { CASES=$((CASES + 1)); FAILURES=$((FAILURES + 1)); echo "  [FAIL] $1"; }

# ─── OUTILLAGE ───────────────────────────────────────────────────────────────

# Copie du dépôt sans .git/ ni exemples/ (91 Mo que le validateur ne lit pas).
# Le cas « baseline » garantit que cette exclusion ne retire rien d'utile.
make_fixture() {
  local dir="$TEST_ROOT/$1"
  mkdir -p "$dir"
  ( cd "$REPO_ROOT" && tar --exclude=./.git --exclude=./exemples -cf - . ) | ( cd "$dir" && tar -xf - )
  echo "$dir"
}

# Lance le validateur sur une fixture ; sortie dans $OUT, code dans $RC.
run_validate() {
  OUT=$(SDLC_VALIDATE_ROOT="$1" bash "$VALIDATOR" 2>&1)
  RC=$?
}

# Le contrôle C<n> doit être rouge et le script sortir en 1.
# Motif « ❌ C<n> · » complet : « C1 » seul matcherait aussi « C10 ».
assert_red() {
  local n="$1" label="$2"
  if [ "$RC" -eq 1 ] && grep -qF -- "❌ C$n ·" <<<"$OUT"; then
    pass "C$n rouge — $label"
  else
    fail "C$n rouge — $label (exit=$RC)"
    grep -E "^(✅|❌) C" <<<"$OUT" | sed 's/^/        /'
  fi
}

# Le contrôle C<n> doit être vert (quel que soit l'état des autres).
assert_green() {
  local n="$1" label="$2"
  if grep -qF -- "✅ C$n ·" <<<"$OUT"; then
    pass "C$n vert — $label"
  else
    fail "C$n vert — $label (exit=$RC)"
    grep -A6 -F -- "❌ C$n ·" <<<"$OUT" | sed 's/^/        /'
  fi
}

# ─── CAS ─────────────────────────────────────────────────────────────────────

echo ""
echo "sdlc-validate-test — $(date +%d/%m/%Y)"
echo ""

# Baseline : fixture non modifiée → tout vert. Sans ce cas, un rouge ailleurs
# pourrait venir de la copie elle-même et non du défaut injecté.
F=$(make_fixture baseline)
run_validate "$F"
if [ "$RC" -eq 0 ]; then
  pass "baseline — fixture non modifiée, exit 0"
else
  fail "baseline — fixture non modifiée (exit=$RC)"
  grep -E "^❌" <<<"$OUT" | sed 's/^/        /'
fi

# C8 — un script shell syntaxiquement invalide
F=$(make_fixture c8)
printf '#!/bin/bash\nif then\n' > "$F/zz-broken.sh"
run_validate "$F"
assert_red 8 "script zz-broken.sh invalide"

# C1 — README.md et CHANGELOG.md divergent sur la version courante
F=$(make_fixture c1)
sed -i '0,/^## \[/s/^## \[[^]]*\]/## [v9.9+FAUX]/' "$F/CHANGELOG.md"
run_validate "$F"
assert_red 1 "première entrée CHANGELOG.md altérée"

# C2 — un template sans marqueur de version dans ses 3 premières lignes
F=$(make_fixture c2)
sed -i '1,3s/v[0-9][0-9]*\.[0-9][0-9]*/vX/g' "$F/01-Claude-md-TEMPLATE.md"
run_validate "$F"
assert_red 2 "marqueur de version retiré de 01-Claude-md-TEMPLATE.md"

# C3 — un placeholder résiduel en prose dans un fichier de référence
F=$(make_fixture c3)
printf '\nPropriétaire : [À REMPLIR]\n' >> "$F/README.md"
run_validate "$F"
assert_red 3 "[À REMPLIR] en prose dans README.md"

# C4 — le skill vivant diverge de son template (section ajoutée d'un seul côté)
F=$(make_fixture c4)
printf '\n## Section parasite\n' >> "$F/.claude/skills/wrap-up/SKILL.md"
run_validate "$F"
assert_red 4 "## ajouté à .claude/skills/wrap-up/SKILL.md seulement"

# C5 — un hook actif lit une clé JSON que le template ne documente pas
F=$(make_fixture c5)
printf "\n# data.get('zz_cle_fantome')\n" >> "$F/.claude/hooks/pre-tool-bash.sh"
run_validate "$F"
assert_red 5 "clé data.get('zz_cle_fantome') dans pre-tool-bash.sh seulement"

# C6 — un fichier numéroté sur disque, absent de la carte 00-CONTEXT.md §1
F=$(make_fixture c6)
printf '<!-- Template SDLC v1.0 -->\n# Orphelin\n' > "$F/99-orphelin.md"
run_validate "$F"
assert_red 6 "99-orphelin.md absent de 00-CONTEXT.md §1"

# C7 — un identifiant de décision attribué deux fois
F=$(make_fixture c7)
printf '\n## M-PROC-25 · Doublon injecté\n' >> "$F/07-DECISIONS-SDLC.md"
run_validate "$F"
assert_red 7 "## M-PROC-25 dupliqué dans 07-DECISIONS-SDLC.md"

# C9 — le site docs/ porte une autre version que README.md
F=$(make_fixture c9)
sed -i 's/"version"[[:space:]]*:[[:space:]]*"[^"]*"/"version": "v9.9+FAUX"/' "$F/docs/meta.json"
run_validate "$F"
assert_red 9 "version altérée dans docs/meta.json"

# C10 — un livrable HTML a perdu son marqueur de version
F=$(make_fixture c10)
sed -i 's/SDLC version : /SDLC-version-retiree : /' "$F/docs/SPEC.html"
run_validate "$F"
assert_red 10 "marqueur « SDLC version : » retiré de docs/SPEC.html"

# ─── C3 · NON-AVEUGLEMENT ────────────────────────────────────────────────────
# C3 exemptait autrefois des fichiers entiers (C3_EXCEPTIONS) : un vrai résidu
# y passait sans alerte. Ces cas prouvent que le grain ligne voit les résidus
# en prose SANS rougir sur les citations légitimes (code inline, blocs fencés,
# titre et index de la décision M-TMPL-01).

# Résidu en prose dans un fichier autrefois exempté en entier
F=$(make_fixture c3-06-prose)
printf '\nResponsable du bootstrap : [À REMPLIR]\n' >> "$F/06-PDR-bootstrap.md"
run_validate "$F"
assert_red 3 "[À REMPLIR] en prose dans 06-PDR-bootstrap.md"

# Résidu en prose dans 07-DECISIONS-SDLC.md, sur une ligne sans M-TMPL-01
F=$(make_fixture c3-07-prose)
printf '\nDécideur : [À REMPLIR]\n' >> "$F/07-DECISIONS-SDLC.md"
run_validate "$F"
assert_red 3 "[À REMPLIR] en prose dans 07-DECISIONS-SDLC.md, hors M-TMPL-01"

# Marqueur NON échappé dans un bloc fencé : citation, doit rester vert.
# Sans cette injection, l'exclusion des fences ne serait testée sur rien
# (les fences existantes citent la forme échappée, que C3 ne matche pas).
F=$(make_fixture c3-fence)
printf '\n```bash\ngrep "[→ ADAPTER]" Claude.md\n```\n' >> "$F/06-PDR-bootstrap.md"
run_validate "$F"
assert_green 3 "[→ ADAPTER] dans un bloc fencé de 06-PDR-bootstrap.md"

# Citations légitimes en place (06 l. 40 inline, 07 titre + index M-TMPL-01)
F=$(make_fixture c3-legit)
run_validate "$F"
assert_green 3 "citations légitimes en place, sans injection"

# ─── BILAN ───────────────────────────────────────────────────────────────────

echo ""
echo "──────────────────────────────────────"
echo "$((CASES - FAILURES))/$CASES cas OK"
echo "──────────────────────────────────────"
[ "$FAILURES" -eq 0 ]
