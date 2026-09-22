#!/bin/bash
# sdlc-validate.sh — Vérification exécutable de la cohérence interne du modèle SDLC
# Usage : bash sdlc-validate.sh
# Sprint ECO-1 (M-PROC-40) · specs/Sprints/sprint-ECO-1-sdlc-validate.md
#
# Ce script valide le MODÈLE (ce dépôt), pas ses copies dans des projets cibles.
# Lecture seule : aucune écriture de fichier, aucun appel réseau, idempotent.
# Résout ses chemins par rapport à sa propre position — pas au cwd de l'appelant.
#
# Codes de sortie : 0 = tous les contrôles OK · 1 = ≥ 1 contrôle en échec · 2 = erreur d'exécution
# du script lui-même (fichier attendu absent, commande indisponible).

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$SCRIPT_DIR"

# ─── PRÉ-VOL — fichiers/commandes indispensables au script lui-même ──────────
# Une absence ici est une erreur d'exécution du script (exit 2), pas un
# contrôle en échec (exit 1) : sans ces fichiers, aucun des contrôles n'a de sens.

for cmd in grep sed tr diff sort comm uniq head basename date ls; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "❌ ERREUR — commande indisponible : $cmd"
    exit 2
  }
done

for f in README.md CHANGELOG.md 00-CONTEXT.md 07-DECISIONS-SDLC.md 08-hooks-TEMPLATE.md; do
  [ -f "$ROOT/$f" ] || {
    echo "❌ ERREUR — fichier attendu absent : $f"
    exit 2
  }
done

# ─── EXCEPTIONS STRUCTURELLES CONNUES ────────────────────────────────────────
# Une exception ne s'ajoute jamais pour contourner un vrai défaut — seulement
# pour un cas déjà justifié explicitement dans 07-DECISIONS-SDLC.md.

# C3 — le motif de placeholder est cité pour DOCUMENTER la convention M-TMPL-01,
# pas laissé en résidu réel. Format : "fichier|justification".
C3_EXCEPTIONS=(
  "06-PDR-bootstrap.md|cite [→ ADAPTER] pour documenter la convention M-TMPL-01, §Étape 2"
  "CHANGELOG.md|entrées narrant des sprints passés qui ont introduit [À REMPLIR] (ex. M-ARCH-08)"
  "07-DECISIONS-SDLC.md|documente la convention M-TMPL-01 elle-même (titres et citations)"
)

# C4 — paire dont le skill vivant n'a jamais été installé dans CE repo (état
# légitime du self-bootstrap SDLC-14, hors périmètre de ce sprint qui constate,
# il ne réécrit pas). Format : "template|justification".
C4_EXCEPTIONS=(
  "04b-sdlc-sync-SKILL-TEMPLATE.md|/sdlc-sync jamais installé ici — n'a pas d'objet appliqué au modèle sur lui-même"
  "11-help-SKILL-TEMPLATE.md|/help jamais installé dans ce repo (self-bootstrap SDLC-14)"
)

# C6 — aucune exception connue au premier lancement (liste initialisée vide,
# à remplir ici avec un renvoi vers 07-DECISIONS-SDLC.md si un cas légitime
# apparaît). Format : "fichier|justification".
C6_EXCEPTIONS=()

# ─── COMPTEURS + RAPPORT ─────────────────────────────────────────────────────

PASS=0
FAIL=0
TOTAL=0

report() {
  # $1 = libellé du contrôle · $2 = 0 (succès) / 1 (échec) · $3 = détail (optionnel, multiligne)
  TOTAL=$((TOTAL + 1))
  if [ "$2" -eq 0 ]; then
    PASS=$((PASS + 1))
    echo "✅ $1"
  else
    FAIL=$((FAIL + 1))
    echo "❌ $1"
  fi
  if [ -n "${3:-}" ]; then
    echo "$3" | sed 's/^/   /'
  fi
  echo ""
}

# ─── LES CONTRÔLES ──────────────────────────────────────────────────────────
# Une fonction par contrôle. Chacune imprime son propre verdict via `report`
# et retourne 0 (succès) ou 1 (échec) — jamais d'arrêt du script (pas de `-e`),
# le rapport doit être complet en un seul passage.

check_c1() {
  # Version README.md ↔ dernière entrée CHANGELOG.md
  local readme_v chlog_v
  readme_v=$(grep -m1 -oE 'Version courante : [^ *]+' "$ROOT/README.md" | sed 's/Version courante : //')
  chlog_v=$(grep -m1 -oE '^## \[[^]]+\]' "$ROOT/CHANGELOG.md" | tr -d '#[] ')
  if [ "$readme_v" = "$chlog_v" ]; then
    report "C1 · Version README.md ↔ CHANGELOG.md" 0 "README=$readme_v · CHANGELOG=$chlog_v"
    return 0
  else
    report "C1 · Version README.md ↔ CHANGELOG.md" 1 "README=$readme_v · CHANGELOG=$chlog_v — divergentes"
    return 1
  fi
}

check_c2() {
  # En-tête de version sur chaque template NN-*.md — commentaire HTML
  # (<!-- Template SDLC vX.Y ... -->). Exception stricte au cas par cas :
  # 00-CONTEXT.md n'est pas un template copié dans les projets cibles et
  # porte sa version dans le titre H1 (# ... · vX.Y) — convention stable
  # depuis l'origine, pas une dérive. Ne pas élargir le motif général : le
  # titre H1 de TOUS les templates contient un "v1.0" générique (version du
  # futur projet cible, pas du template SDLC) qui rendrait le contrôle
  # aveugle à un vrai en-tête manquant.
  local fail=0 detail="" base pattern
  for f in "$ROOT"/[0-9][0-9]*.md; do
    [ -f "$f" ] || continue
    base="$(basename "$f")"
    if [ "$base" = "00-CONTEXT.md" ]; then
      pattern='^#.*v[0-9]+\.[0-9]+'
    else
      pattern='<!--.*v[0-9]+\.[0-9]+'
    fi
    if head -3 "$f" | grep -qE "$pattern"; then
      continue
    fi
    fail=1
    detail="$detail
❌ $base — aucune version détectée dans les 3 premières lignes"
  done
  if [ "$fail" -eq 0 ]; then
    report "C2 · En-tête de version sur chaque template" 0 ""
  else
    report "C2 · En-tête de version sur chaque template" 1 "$detail"
  fi
  return $fail
}

check_c3() {
  # Placeholders [→ ADAPTER] / [À REMPLIR] / [Nom du projet] absents des
  # fichiers de référence — sauf citation documentée de la convention elle-même.
  local files=(00-CONTEXT.md 06-PDR-bootstrap.md 07-DECISIONS-SDLC.md README.md CHANGELOG.md Claude.md STANDARDS.md specs/SPEC.md)
  local fail=0 detail="" f excepted ex exfile
  for f in "${files[@]}"; do
    [ -f "$ROOT/$f" ] || continue
    if grep -lqE '\[→ ADAPTER\]|\[À REMPLIR\]|\[Nom du projet\]' "$ROOT/$f" 2>/dev/null; then
      excepted=0
      for ex in "${C3_EXCEPTIONS[@]}"; do
        exfile="${ex%%|*}"
        [ "$exfile" = "$f" ] && excepted=1
      done
      [ "$excepted" -eq 1 ] && continue
      fail=1
      detail="$detail
❌ $f — placeholder résiduel non justifié"
    fi
  done
  if [ "$fail" -eq 0 ]; then
    report "C3 · Placeholders hors des fichiers template" 0 "0 résidu non justifié (${#C3_EXCEPTIONS[@]} exception(s) documentée(s) — voir C3_EXCEPTIONS en tête de script)"
  else
    report "C3 · Placeholders hors des fichiers template" 1 "$detail"
  fi
  return $fail
}

check_c4() {
  # Parité structurelle (liste ordonnée des titres ^## ) entre 4 paires
  # template ↔ skill vivant. Une paire sans skill installée est signalée
  # ⚠️ non applicable si listée dans C4_EXCEPTIONS — pas un échec.
  local pairs=(
    "03-wrap-up-SKILL-TEMPLATE.md|.claude/skills/wrap-up/SKILL.md"
    "04b-sdlc-sync-SKILL-TEMPLATE.md|.claude/skills/sdlc-sync/SKILL.md"
    "09-retrospective-SKILL-TEMPLATE.md|.claude/skills/retrospective/SKILL.md"
    "11-help-SKILL-TEMPLATE.md|.claude/skills/help/SKILL.md"
  )
  local fail=0 detail="" p tmpl live known ex extmpl
  for p in "${pairs[@]}"; do
    tmpl="${p%%|*}"
    live="${p##*|}"
    if [ ! -f "$ROOT/$live" ]; then
      known=0
      for ex in "${C4_EXCEPTIONS[@]}"; do
        extmpl="${ex%%|*}"
        [ "$extmpl" = "$tmpl" ] && known=1
      done
      if [ "$known" -eq 1 ]; then
        detail="$detail
⚠️  $tmpl ↔ $live — non applicable (skill non installée dans ce repo)"
      else
        fail=1
        detail="$detail
❌ $tmpl ↔ $live — skill absente et non justifiée"
      fi
      continue
    fi
    if ! diff <(grep '^## ' "$ROOT/$tmpl") <(grep '^## ' "$ROOT/$live") >/dev/null 2>&1; then
      fail=1
      detail="$detail
❌ $tmpl ↔ $live — titres de section divergents"
    else
      detail="$detail
✓ $tmpl ↔ $live"
    fi
  done
  if [ "$fail" -eq 0 ]; then
    report "C4 · Parité structurelle template ↔ skill vivant" 0 "$detail"
  else
    report "C4 · Parité structurelle template ↔ skill vivant" 1 "$detail"
  fi
  return $fail
}

check_c5() {
  # Parité du schéma JSON (clés data.get('...')) entre 08-hooks-TEMPLATE.md
  # et les hooks actifs (pre-tool-bash.sh, pre-compact.sh)
  local diffout
  diffout=$(comm -3 \
    <(grep -oE "data\.get\('[a-z_]+'" "$ROOT/08-hooks-TEMPLATE.md" | sort -u) \
    <(grep -oE "data\.get\('[a-z_]+'" "$ROOT/.claude/hooks/pre-tool-bash.sh" "$ROOT/.claude/hooks/pre-compact.sh" 2>/dev/null | \
      grep -oE "'[a-z_]+'" | sed "s/^/data.get(/" | sort -u) 2>/dev/null)
  if [ -z "$diffout" ]; then
    report "C5 · Parité schéma JSON hook template ↔ hooks actifs" 0 ""
    return 0
  else
    report "C5 · Parité schéma JSON hook template ↔ hooks actifs" 1 "$diffout"
    return 1
  fi
}

check_c6() {
  # Carte des fichiers 00-CONTEXT.md §1 ↔ disque.
  # Dégradé à 2 listes (disque ↔ 00-CONTEXT.md) plutôt que 3 : le bloc
  # README.md §Structure du repo n'est pas normalisé (cf. §Risques du PDR
  # ECO-1) — [SDLC_CANDIDATE] à instruire séparément pour sa normalisation.
  # Extraction ajustée à la forme réelle de la table (nom de fichier entre
  # backticks, pas forcément en première colonne) — cf. PDR §C6, seul point
  # d'ajustement explicitement admis.
  local disk ctx diffout ex exfile
  disk=$(cd "$ROOT" && ls [0-9][0-9]*.md 2>/dev/null | sort)
  for ex in "${C6_EXCEPTIONS[@]}"; do
    exfile="${ex%%|*}"
    disk=$(echo "$disk" | grep -v "^${exfile}$")
  done
  ctx=$(sed -n '/^## 1\. Carte des fichiers/,/^## 2\./p' "$ROOT/00-CONTEXT.md" | \
    grep -oE '`[0-9]{2}[a-zA-Z0-9-]*\.md`' | tr -d '`' | sort -u)
  diffout=$(comm -3 <(echo "$disk") <(echo "$ctx"))
  if [ -z "$diffout" ]; then
    report "C6 · Carte des fichiers ↔ disque ↔ 00-CONTEXT.md" 0 ""
    return 0
  else
    report "C6 · Carte des fichiers ↔ disque ↔ 00-CONTEXT.md" 1 "$diffout"
    return 1
  fi
}

check_c7() {
  # Unicité des identifiants M-XXXX-NN dans 07-DECISIONS-SDLC.md
  local dups
  dups=$(grep -oE '^## M-[A-Z]+-[0-9]+' "$ROOT/07-DECISIONS-SDLC.md" | sort | uniq -d)
  if [ -z "$dups" ]; then
    report "C7 · Unicité des identifiants M-XXXX-NN" 0 ""
    return 0
  else
    report "C7 · Unicité des identifiants M-XXXX-NN" 1 "$dups"
    return 1
  fi
}

check_c8() {
  # Syntaxe de tous les scripts shell (racine + .claude/hooks/)
  local fail=0 detail="" f err
  for f in "$ROOT"/*.sh "$ROOT"/.claude/hooks/*.sh; do
    [ -f "$f" ] || continue
    if ! err=$(bash -n "$f" 2>&1); then
      fail=1
      detail="$detail
❌ $(basename "$f") — $err"
    fi
  done
  if [ "$fail" -eq 0 ]; then
    report "C8 · Syntaxe de tous les scripts shell" 0 ""
  else
    report "C8 · Syntaxe de tous les scripts shell" 1 "$detail"
  fi
  return $fail
}

check_c9() {
  # Site de documentation à jour (M-PROC-45). Le site docs/ est édité à la main
  # (docs/README.md) : sans contrôle, il a dérivé de SDLC-25 à SDLC-29 sans alerte.
  # (a) docs/meta.json porte la version courante du README.md
  # (b) docs/pages/versions.md mentionne le sprint courant (partie après le « + »)
  local fail=0 detail="" readme_v meta_v tag
  readme_v=$(grep -m1 -oE 'Version courante : [^ *]+' "$ROOT/README.md" | sed 's/Version courante : //')
  meta_v=$(grep -m1 -oE '"version"[[:space:]]*:[[:space:]]*"[^"]+"' "$ROOT/docs/meta.json" 2>/dev/null | sed -E 's/.*:[[:space:]]*"([^"]+)"/\1/')
  tag="${readme_v##*+}"
  if [ "$meta_v" != "$readme_v" ]; then
    fail=1
    detail="❌ docs/meta.json=${meta_v:-absent ou illisible} · README.md=$readme_v — divergentes"
  fi
  if [ -z "$tag" ] || ! grep -qF -- "$tag" "$ROOT/docs/pages/versions.md" 2>/dev/null; then
    fail=1
    detail="${detail:+$detail
}❌ docs/pages/versions.md ne mentionne pas « ${tag:-?} »"
  fi
  if [ "$fail" -eq 0 ]; then
    report "C9 · Site docs/ à jour (meta.json ↔ README.md, versions.md)" 0 "meta.json=$meta_v · versions.md mentionne $tag"
  else
    report "C9 · Site docs/ à jour (meta.json ↔ README.md, versions.md)" 1 "$detail"
  fi
  return $fail
}

check_c10() {
  # Livrables HTML de lecture humaine à jour (M-PROC-46) — même famille de défaut
  # que C9 : SPEC.html et MODE-OPERATOIRE.html sont restés figés à v1.4 jusqu'à
  # v2.0+SDLC-29 (23 versions) sans alerte. Pour chacun :
  # (a) le marqueur « SDLC version : <version du README> » est présent
  # (b) chaque template numéroté à la racine (NN-*.md) est cité par son nom —
  #     attrape « Les 10 fichiers du modèle » quand il y en a davantage.
  # Limite assumée : présence de noms, pas justesse de la prose.
  local fail=0 detail="" readme_v html f base missing
  readme_v=$(grep -m1 -oE 'Version courante : [^ *]+' "$ROOT/README.md" | sed 's/Version courante : //')
  for html in docs/SPEC.html docs/MODE-OPERATOIRE.html; do
    if [ ! -f "$ROOT/$html" ]; then
      fail=1
      detail="${detail:+$detail
}❌ $html — fichier absent"
      continue
    fi
    if ! grep -qF -- "SDLC version : ${readme_v}" "$ROOT/$html"; then
      fail=1
      detail="${detail:+$detail
}❌ $html — marqueur « SDLC version : ${readme_v} » absent"
    fi
    missing=""
    for f in "$ROOT"/[0-9][0-9]*.md; do
      [ -f "$f" ] || continue
      base="$(basename "$f")"
      grep -qF -- "$base" "$ROOT/$html" || missing="$missing $base"
    done
    if [ -n "$missing" ]; then
      fail=1
      detail="${detail:+$detail
}❌ $html — template(s) non cité(s) :$missing"
    fi
  done
  if [ "$fail" -eq 0 ]; then
    report "C10 · Livrables HTML à jour (marqueur de version, carte des templates)" 0 ""
  else
    report "C10 · Livrables HTML à jour (marqueur de version, carte des templates)" 1 "$detail"
  fi
  return $fail
}

# ─── REGISTRE DE CONTRÔLES ────────────────────────────────────────────────────
# Point d'extension pour les vagues 2/3 (ECO-2, ECO-3, …) :
# 1) définir une fonction check_cN ci-dessus, qui appelle `report` et retourne 0/1
# 2) l'ajouter à ce tableau, dans l'ordre où elle doit s'exécuter
CHECKS=(check_c1 check_c2 check_c3 check_c4 check_c5 check_c6 check_c7 check_c8 check_c9 check_c10)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔎 sdlc-validate — $(date +%d/%m/%Y)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

for c in "${CHECKS[@]}"; do
  "$c"
done

echo "──────────────────────────────────────"
echo "Résumé : ${PASS}/${TOTAL} ✅"
echo "──────────────────────────────────────"

if [ "$FAIL" -eq 0 ]; then
  exit 0
else
  exit 1
fi
