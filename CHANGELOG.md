# CHANGELOG — SDLC Toolkit

---

## [v1.8] — 2026-06-14 · Sprint SDLC-05a · Wrap-up robustesse : §0e, signaux rétrospectifs, SESSION_BRIDGE, CLAUDE_PROJECT

- **`03-wrap-up-SKILL-TEMPLATE.md` v1.3** : §0a second output signaux rétrospectifs · §Étape 1 référence §0a synthèse · §0e revue objectif (ATTEINT/PARTIEL/NON ATTEINT) · §Étape 3 grep -En enforcement + 2 conditionnels (SESSION_BRIDGE / CLAUDE_PROJECT) · §Étape 5 réécrite SESSION_BRIDGE accumulatif · §Étape 6 réécrite vérification CLAUDE_PROJECT delta
- **`01-Claude-md-TEMPLATE.md` v1.8** : §Démarrage §2 lecture SESSION_BRIDGE · §Règles absolues sprint-memory.md explicité
- **`06-PDR-bootstrap.md`** : doc/SESSION_BRIDGE.md ajouté carte §Groupe 2
- **`07-DECISIONS-SDLC.md`** : M-PROC-19 à M-PROC-22 (revue objectif · signaux rétrospectifs · enforcement specs · SESSION_BRIDGE + CLAUDE_PROJECT)
- **Tests** : greps critères d'acceptation 1.1/1.5/1.6/1.7/1.8 tous verts ✓
- **Corrections ajustées vs spec** — test `grep -c "^## Étape [1-6]"` → 8 résultats (pas 6) : Étape 2b et 3.5 préexistants, attendu de la spec incorrectement calibré · specs/Sprints/ absent dans ce repo (PDR en conversation)

## [v1.7] — 2026-06-11 · Sprint SDLC-04 · Confiance FAIBLE → vérification externe + PostToolUse Option A/B

- **`01-Claude-md-TEMPLATE.md` v1.7** : §Analyse §Demande d'aval — si confiance FAIBLE, recommander explicitement une vérification externe (Oracle ou revue humaine) avant l'aval (M-PROC-18)
- **`08-hooks-TEMPLATE.md` v1.7** : §PostToolUse restructuré en Option A — lint/format ruff (reformulée, ex-M-HOOKS-01) / Option B — nouveau hook `post-commit-changelog.sh` + snippet `settings.json` + smoke test (M-HOOKS-03)
- **`02-STANDARDS-TEMPLATE.md`** : marqueur `SDLC version` v1.5 → v1.7 (paire avec `01-Claude-md-TEMPLATE.md`, cf. M-PROC-09)
- **`07-DECISIONS-SDLC.md`** : M-PROC-18, M-HOOKS-03
- **Tests** : `post-commit-changelog.sh` — `bash -n` OK · 4 scénarios smoke test (non-commit, --amend, commit avec/sans CHANGELOG.md) ✓

---

## [v1.6] — 2026-06-11 · Sprint SDLC-03 · Annotations sprint-memory + Handoff eager/lazy + index retrospective

- **`01-Claude-md-TEMPLATE.md` v1.6** : §Mémoire de sprint — annotation `[CONF: HAUTE/MOY/FAIBLE — raison]` sur ANALYSE (M-PROC-13) · champ `→ alternative :` sur BLOQUANT (M-PROC-14) · `[valide jusqu'à : condition]` sur DÉCISION (M-PROC-15) ; §Démarrage 4c + §Tokens — distinction Handoff chargement immédiat/différé (M-PROC-16)
- **`04-sprint-PDR-TEMPLATE.md` v1.6** : §Handoff scindé en chargement immédiat / chargement différé (M-PROC-16) · nouvelle section §Dépendances — inputs requis / outputs produits (M-ARCH-07)
- **`09-retrospective-SKILL-TEMPLATE.md` v1.6** : §Index des patterns en tableau structuré + §Métriques de rétro + §Requêtes utiles sur l'index (M-PROC-17)
- **`07-DECISIONS-SDLC.md`** : M-PROC-13, M-PROC-14, M-PROC-15, M-PROC-16, M-PROC-17, M-ARCH-07
- **Tests** : N/A (gouvernance uniquement)

---

## [v1.5] — 2026-06-05 · Sprint SDLC-02 · Init sprint spec + mémoire

- **`01-Claude-md-TEMPLATE.md` v1.5** : §Démarrage étape 4 remplacée par séquence 4a/4b/4c/4d — création spec, init mémoire, lecture, plan de dev ; règle absolue ajoutée
- **`02-STANDARDS-TEMPLATE.md` v1.5** : marqueur SDLC v1.4 → v1.5
- **`03-wrap-up-SKILL-TEMPLATE.md`** : §Étape 3 — bloc `specs/Sprints/sprint-N-slug.md` obligatoire ajouté (vérification existence + §Corrections ajustées vs spec)
- **`04-sprint-PDR-TEMPLATE.md`** : §Plan de développement (4d) + §Corrections ajustées vs spec (wrap-up) ajoutés après §Handoff Claude Code
- **`07-DECISIONS-SDLC.md`** : M-PROC-12 — Init sprint : spec + mémoire + plan de développement
- **Tests** : tous les greps de vérification passent ✓

---

## [v1.4] — 2026-06-04 · Sprint SDLC-01 · Modifications spot sed/grep

- **`01-Claude-md-TEMPLATE.md` v1.3** : §Modifications spot sur fichiers existants ajouté
- **`07-DECISIONS-SDLC.md`** : M-PROC-10 (mémoire de sprint) + M-PROC-11 (modifications spot sed/grep)
- **`02-STANDARDS-TEMPLATE.md` v1.4** : marqueur SDLC v1.3 → v1.4
