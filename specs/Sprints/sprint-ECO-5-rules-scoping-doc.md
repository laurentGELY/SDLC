# Sprint ECO-5 — Documentation du pattern `.claude/rules/` (rescopé depuis P-20)

**Type :** Doc
**Taille :** S
**Sprint :** ECO-5 (03/09/2026)

---

## §Contexte

`docs/ROADMAP.md §Next` portait `P-20 / ECO-5 — Hook SessionStart (injection auto
Règles absolues + HALT)`, motivé par `LL-T05` (2 occurrences confirmées : les
instructions d'init embarquées dans un PDR §Handoff sont traitées comme
suffisantes sans être confrontées à la checklist complète `Claude.md §Démarrage`
4a-4d — l'étape 4a a sauté sans garde-fou avant le `/wrap-up`).

**Vérification factuelle menée avant rédaction du plan (deux pistes évaluées,
toutes deux écartées) :**

1. **Piste hook `SessionStart`** — vérifiée sur `code.claude.com/docs/en/hooks` et
   `code.claude.com/docs/en/memory` : « Project-root CLAUDE.md survives
   compaction: after `/compact`, Claude re-reads it from disk and re-injects it
   into the session. » `Claude.md` recharge déjà nativement à `startup`,
   `resume`, `clear` et après `/compact` — exactement les matchers que le hook
   visait à couvrir. Ni `Claude.md` ni `hookSpecificOutput.additionalContext`
   (sortie du hook `SessionStart`) ne sont un mécanisme d'enforcement — la doc le
   dit explicitement : « there's no guarantee of strict compliance ». Le hook
   n'aurait donc pas ajouté de garantie de conformité supérieure à ce que
   `Claude.md` fournit déjà en étant chargé. Seul gain théorique : un rappel
   condensé à plus forte saillance qu'un fichier long — un pari, pas un
   mécanisme structurel.

2. **Piste self-split de `Claude.md` (ce repo) via `.claude/rules/`** — vérifiée
   sur `code.claude.com/docs/en/context-window §What survives compaction` :
   « Project-root CLAUDE.md and unscoped rules → Re-injected from disk » (un
   fichier `.claude/rules/*.md` **sans** `paths:` charge et survit à la
   compaction exactement comme `Claude.md` — aucun gain à en extraire du
   contenu sans marquer `paths:`). Cartographie de `Claude.md` (374 lignes,
   9 sections) : aucune section n'a de frontière naturelle par chemin de
   fichier — Règles absolues/Rôle/Démarrage (~144 lignes) sont des règles de
   cycle de vie de session, pas liées à un fichier lu ; Tokens/Modifications
   spot (~38 lignes) s'appliquent à toute édition quel que soit le type de
   fichier ; Analyse/Mémoire de sprint/Test (~136 lignes) s'appliquent à
   chaque sprint indépendamment du fichier touché ; Wrap-up/Oracle/Priorités
   (~38 lignes) sont déjà des pointeurs minimaux vers les skills correspondants
   (le pattern chargement-à-la-demande fonctionne déjà correctement via les
   skills `/wrap-up`/`/retrospective`). `.claude/rules/paths:` matche sur des
   lectures de fichier, pas sur une phase de sprint — ce repo est un projet de
   gouvernance de processus, pas un codebase avec des conventions par
   répertoire (`src/api/**`), donc le mécanisme n'a rien à découper ici.

**Décision utilisateur explicite (AskUserQuestion) :** documenter le pattern
`.claude/rules/` dans le template pour les **projets cibles** (qui ont, eux, de
vraies conventions par chemin) — sans reclasser `LL-T05` dans
`docs/LESSONS_LEARNED.md` (reste `Actif` tel quel, aucune modification de ce
fichier ce sprint).

---

## §Portée

**Inclus :**
- `01-Claude-md-TEMPLATE.md` — nouveau bullet dans `§Tokens §Chargement
  chirurgical`, documentant quand utiliser `.claude/rules/` (seuil ~200 lignes,
  frontière `paths:` réelle par répertoire/type de fichier uniquement — jamais
  du contenu transverse au processus) et le fait de persistance après
  compaction cité en §Contexte.
- `07-DECISIONS-SDLC.md` — nouvelle entrée `M-TMPL-06` (les deux pistes
  écartées + leur preuve factuelle) + ligne table de compatibilité.
- `docs/ROADMAP.md` — `P-20` déplacé `§Next` → `§Historique`, disposition
  rescopée documentée.
- `CHANGELOG.md`, `README.md` — entrées standard de version.

**Exclu :**
- `docs/LESSONS_LEARNED.md §LL-T05` — **non touché**, sur décision utilisateur
  explicite (option « Template seulement »).
- `08-hooks-TEMPLATE.md` — pas de nouveau hook, la piste est écartée.
- Tout split de `Claude.md` (ce repo) — écarté factuellement, aucune frontière
  `paths:` naturelle trouvée (§Contexte point 2).

---

## §Critères d'acceptation

- [x] `grep -n "\.claude/rules/" 01-Claude-md-TEMPLATE.md` → ≥ 1 résultat
- [x] `grep -c "^## M-TMPL-06" 07-DECISIONS-SDLC.md` → 1
- [x] `docs/ROADMAP.md §Next` ne contient plus la ligne `P-20`
- [x] `docs/ROADMAP.md §Historique` contient une nouvelle ligne ECO-5
- [x] `docs/LESSONS_LEARNED.md` — zéro diff (vérifié par `git diff --stat` avant
      commit)
- [x] `bash sdlc-validate.sh` → 8/8, exit code 0
- [x] `README.md §Version courante` = `v2.0+ECO-5`, cohérent avec
      `CHANGELOG.md`

---

## §Plan de développement

1. `01-Claude-md-TEMPLATE.md` v2.3 → v2.4 : ajouter le bullet `.claude/rules/`
   dans `§Tokens`, bump version en-tête + `<!-- Template SDLC vX.Y -->`.
2. `07-DECISIONS-SDLC.md` : ajouter ligne table de compatibilité + entrée
   complète `## M-TMPL-06` (Contexte/Retenu/Écarté ×2/Raison/Impact fichiers).
3. `docs/ROADMAP.md` : retirer la ligne `P-20` de `§Next`, ajouter une ligne
   `§Historique` en tête de table.
4. `CHANGELOG.md` : nouvelle entrée `## [v2.0+ECO-5]`.
5. `README.md` : bump `Version courante` + ligne `§Historique des versions`.
6. Vérification : `bash sdlc-validate.sh` (attendu 8/8) + `git diff --stat`
   (confirmer `docs/LESSONS_LEARNED.md` absent du diff).

---

## §Risques

- **Confusion `.claude/rules/` vs hooks** — le bullet est ajouté dans
  `§Tokens` (chargement chirurgical), pas dans `08-hooks-TEMPLATE.md`, pour ne
  pas mélanger un mécanisme de contexte (pas d'enforcement) avec un mécanisme
  de blocage (hooks). Mitigation : formulation explicite du bullet rappelant
  que `.claude/rules/` n'est pas un hook.
- **Sur-généralisation du pattern à ce repo** — écarté explicitement en
  §Contexte avec preuve factuelle ; risque résiduel faible, documenté pour
  éviter qu'un futur sprint retente la même piste sans relire cette analyse.

---

## §Corrections ajustées vs spec

*(à compléter au wrap-up si divergence)*
